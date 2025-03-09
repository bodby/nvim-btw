{ pkgs }: {
  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    (nvim-treesitter.withPlugins (p: with p; [
      comment
      luadoc
      vimdoc
      doxygen

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
    render-markdown-nvim
    alpha-nvim

    # TODO: Obsidian. Unless markdown-oxide is enough.
    # obsidian-nvim

    gitsigns-nvim
    # smartcolumn-nvim
    # virt-column-nvim
  ];

  # Other LSPs should be in devShells.
  packages = with pkgs; [
    ripgrep
    nixd
  ];
}
