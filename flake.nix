{
  description = "Neovim config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forall = nixpkgs.lib.genAttrs systems;
    in {
      packages = forall (system:
        let
          pkgs = import nixpkgs { inherit system; };
          nvim-pkgs = import ./nix/plugins.nix pkgs;
        in {
          default = pkgs.callPackage ./nix/package.nix {
            inherit (nvim-pkgs) plugins packages;
            viAlias = true;
            vimAlias = true;
          };

          gui = let
            package = self.packages.${system}.default;
          in pkgs.writeShellApplication {
            name = "nvim-gui";
            runtimeInputs = [
              pkgs.neovide
              package
            ];
            text = /* bash */ ''
              neovide --fork --no-tabs --neovim-bin ${package}/bin/nvim
            '';
          };
        });

      devShells = forall (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [ pkgs.lua-language-server ];
            inputsFrom = [ ];
          };
        });
    };
}
