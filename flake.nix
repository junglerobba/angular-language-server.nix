{
  description = "Angular Language Server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_20;
        angular-language-server = pkgs.callPackage ./angular-language-server { inherit nodejs; };
      in
      {
        packages.default = angular-language-server;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            yarn
          ];
        };

      }
    )
    // {
      overlays.default = final: prev: {
        angular-language-server = self.packages.${final.system}.default;
      };
    };
}
