{
  pkgs,
  plugins ? [ ],
  packages ? [ ],
  luaPackages ? p: [ ],
  appName ? null,
  viAlias ? appName == null || appName == "nvim",
  vimAlias ? appName == null || appName == "nvim",
  ...
}:
let
  inherit (pkgs.lib)
    concatStringsSep
    optionalString
    makeBinPath
    concatMapStringsSep
    escapeShellArgs;

  mkNeovim = {
    appName,
    viAlias,
    vimAlias,
    nvim-unwrapped ? pkgs.neovim-unwrapped,
    extraPlugins ? [ ],
    extraPackages ? [ ],
    extraLuaPackages ? p: [ ]
  }:
  let
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
      plugins = map (p:
        defaultPlugin // (if p ? plugin then p else { plugin = p; })) extraPlugins;
    };

    nvimRtp = pkgs.stdenv.mkDerivation {
      name = "nvim-rtp";
      src = ../nvim;

      buildPhase = ''
        mkdir -p $out/lua $out/after $out/snippets $out/colors
      '';

      installPhase = ''
        cp -r lua after snippets colors $out
      '';
    };

    initLua = /* lua */ ''
      vim.loader.enable()
      -- Used for blink.cmp's snippet search path.
      vim.g.root_path = '${nvimRtp}'
      vim.o.rtp = '${nvimRtp},' .. vim.o.rtp .. ',${nvimRtp}/after'

      ${builtins.readFile ../nvim/init.lua}
    '';

    modifiedAppName = appName != null && appName != "nvim" && appName != "";
    extraLuaPackages' = extraLuaPackages nvim-unwrapped.lua.pkgs;

    makeWrapperArgs = concatStringsSep " " [
      (optionalString modifiedAppName
        "--set NVIM_APPNAME '${appName}'")
      (optionalString (extraPackages != [ ])
        "--prefix PATH ':' '${makeBinPath extraPackages}'")
    ];

    luaWrapperArgs =
      let paths = concatMapStringsSep ";" luaPackages.getLuaPath extraLuaPackages';
      in optionalString (extraLuaPackages' != [ ]) "--suffix LUA_PATH ';' '${paths}'";

    luaCWrapperArgs =
      let paths = concatMapStringsSep ";" luaPackages.getLuaCPath extraLuaPackages';
      in optionalString (extraLuaPackages' != [ ]) "--suffix LUA_CPATH ';' '${paths}'";

    nvim-wrapped = pkgs.wrapNeovimUnstable nvim-unwrapped
      (nvimConfig // {
        luaRcContent = initLua;
        wrapperArgs = concatStringsSep " " [
          (escapeShellArgs nvimConfig.wrapperArgs)
          makeWrapperArgs
          luaCWrapperArgs
          luaWrapperArgs
        ];
        wrapRc = true;
      });
  in
  nvim-wrapped.overrideAttrs (finalAttrs: {
    meta.mainProgram =
      if modifiedAppName
      then appName
      else finalAttrs.meta.mainProgram;

    buildPhase = finalAttrs.buildPhase
      + optionalString modifiedAppName /* bash */ ''
        mv $out/bin/nvim $out/bin/${escapeShellArgs appName}
      '';
  });
in
mkNeovim {
  inherit viAlias vimAlias appName;
  extraPlugins = plugins;
  extraPackages = packages;
}
