{
  description = "Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # blink-cmp.url = "github:Saghen/blink.cmp";
    # blink-cmp.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      formatter = nixpkgs.lib.genAttrs systems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );

      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import ./nix/pkgs)
              (import ./nix/package.nix { inherit inputs pkgs; })
            ];
          };
        in
        rec {
          default = nvim;
          nvim = pkgs.nvim-btw;
        }
      );
    };
}
