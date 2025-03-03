{ inputs, pkgs, ... }:
final: prev:
let
  nvimPackages = import ./nvim-pkgs.nix {
    inherit pkgs inputs;
    inherit (final) system;
  };

  mkNeovimConfig =
    {
      appName ? null,
      nvim-unwrapped ? pkgs.neovim-unwrapped,
      plugins ? [ ],
      extraPackages ? [ ],
      extraLuaPackages ? p: [ ],
      viAlias ? false,
      vimAlias ? false,
    }:
    with pkgs.lib;
    let
      inherit (pkgs) stdenv;

      defaultPlugin = {
        plugin = null;
        config = null;
        optional = false;
        runtime = { };
      };

      nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
        inherit viAlias vimAlias;
        extraPython3Packages = p: [ ];
        withPython3 = false;
        withRuby = false;
        withNodeJs = false;
        plugins = map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins;
      };

      nvimRtp = stdenv.mkDerivation {
        name = "nvim-rtp";
        src = ../nvim;

        buildPhase = ''
          mkdir -p $out/lua
          mkdir -p $out/after
          mkdir -p $out/snippets
          mkdir -p $out/colors
        '';

        installPhase = ''
          cp -r lua after snippets colors $out
        '';
      };

      initLua = /* lua */ ''
        vim.loader.enable()

        -- Used for blink.cmp so it can find snippets.
        vim.g.root_path = "${nvimRtp}"

        vim.o.rtp = "${nvimRtp}," .. vim.o.rtp .. ",${nvimRtp}/after"

        ${builtins.readFile ../nvim/init.lua}

        -- NOTE: I have to add this as a separate directory because normally 'queries/' and
        --       'ftplugin/' are actually in the root of the config folder.
        -- vim.o.rtp = "${nvimRtp}/after" .. vim.o.rtp 
      '';

      isCustomAppName = appName != null && appName != "nvim" && appName != "";

      extraMakeWrapperArgs =
        (optionalString isCustomAppName "--set NVIM_APPNAME '${appName}'")
        + (optionalString (extraPackages != [ ]) "--suffix PATH ':' '${makeBinPath extraPackages}'");

      extraLuaPackages' = extraLuaPackages nvim-unwrapped.lua.pkgs;

      extraLuaWrapperArgs =
        optionalString (extraLuaPackages' != [ ])
          "--suffix LUA_PATH ';' '${concatMapStringsSep ";" luaPackages.getLuaPath extraLuaPackages'}'";

      extraLuaCWrapperArgs =
        optionalString (extraLuaPackages' != [ ])
          "--suffix LUA_CPATH ';' '${concatMapStringsSep ";" luaPackages.getLuaCPath extraLuaPackages'}'";

      nvim-wrapped = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
        nvimConfig
        // {
          luaRcContent = initLua;
          wrapperArgs =
            escapeShellArgs nvimConfig.wrapperArgs
            + " "
            + extraMakeWrapperArgs
            + " "
            + extraLuaCWrapperArgs
            + " "
            + extraLuaWrapperArgs;
          wrapRc = true;
        }
      );
    in
    nvim-wrapped.overrideAttrs (prev: {
      buildPhase =
        prev.buildPhase
        + optionalString isCustomAppName /* bash */ ''
          mv $out/bin/nvim $out/bin/${escapeShellArgs appName}
        '';

      meta.mainProgram = if isCustomAppName then appName else prev.meta.mainProgram;
    });
in
{
  nvim-btw = mkNeovimConfig {
    plugins = nvimPackages.plugins;
    extraPackages = nvimPackages.packages;
    viAlias = true;
    vimAlias = true;
  };
}
