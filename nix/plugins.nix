pkgs:
let
  # TODO: Remove when nixpkgs version exceeds 2025-03-09.
  render-markdown-nvim' = pkgs.vimUtils.buildVimPlugin {
    pname = "render-markdown.nvim";
    version = "0-unstable-2025-03-09";
    src = pkgs.fetchFromGitHub {
      owner = "MeanderingProgrammer";
      repo = "render-markdown.nvim";
      rev = "c065031d030955e1d071a7fcdd8c59e0fd2f0343";
      hash = "sha256-Wa5roH6etPACY7xtvycF4d9PE2jHIbkoS0M08HePXno=";
    };
  };

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
    # render-markdown-nvim
    render-markdown-nvim'
    alpha-nvim

    # TODO: Obsidian. Unless markdown-oxide is enough.
    # obsidian-nvim

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
