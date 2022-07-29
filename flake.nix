{
  description = "Web language servers (lsp).";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs-18_x;
      in {
        packages.typescript-language-server = pkgs.callPackage ./typescript-language-server { };
        packages.angular-language-server = pkgs.callPackage ./angular-language-server { inherit nodejs; };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-18_x
            yarn
          ];
        };
      });
}
