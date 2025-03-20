pkgs:
let
  # syntax-gaslighting = pkgs.vimUtils.buildVimPlugin {
  #   pname = "syntax-gaslighting.nvim";
  #   version = "2025-03-10";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "NotAShelf";
  #     repo = "syntax-gaslighting.nvim";
  #     rev = "a9fea11133e7bf00575e540e97a776b8677cb76c";
  #     hash = "sha256-k+HSFYn3stgs0IoCQnJPIpkig8EPtHMAdjdkLyckUOo=";
  #   };
  # };
in {
  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    (nvim-treesitter.withPlugins (p: with p; [
      comment
      luadoc
      vimdoc
      doxygen

      gitignore
      git_rebase

      jsonc
      json
      toml
      yaml

      bash
      c
      cpp
      haskell
      markdown
      markdown_inline
      latex
      bibtex
      typst
      glsl
      zig
      meson
      rust
      ocaml
      lua
      vim
      python
      nix
      html
      css
      javascript
      query
    ]))

    telescope-nvim
    telescope-zf-native-nvim
    blink-cmp
    # blink-compat
    render-markdown-nvim
    alpha-nvim

    nightfox-nvim

    gitsigns-nvim
    # smartcolumn-nvim
    # virt-column-nvim

    # syntax-gaslighting
  ];

  # Other LSPs should be in devShells.
  packages = with pkgs; [
    ripgrep
    nixd
  ];
}
