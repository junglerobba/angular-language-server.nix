{
  description = "Angular Language Server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_20;
      in {
        packages.angular-language-server =
          pkgs.callPackage ./angular-language-server { inherit nodejs; };

        packages.default = self.packages.${system}.angular-language-server;

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nodejs yarn ]; };
      });
}
