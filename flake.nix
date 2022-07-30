{
  description = "Various Language Servers (lsp).";

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
        packages.vscode-langservers-extracted = pkgs.callPackage ./vscode-langservers-extracted { };
        packages.jdt-language-server = pkgs.callPackage ./jdt-language-server { };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-18_x
            yarn
          ];
        };
      });
}
