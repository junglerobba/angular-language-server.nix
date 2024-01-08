# language-servers.nix

(mostly just a fork of [language-servers.nix](https://git.sr.ht/~bwolf/language-servers.nix) with the other language servers removed, since they're mostly available through nixpkgs, and angular-language-server set as the default package)

## Angular Language Server

It provides `bin/ngserver` from [vscode-ng-language-service](https://github.com/angular/vscode-ng-language-service) with the wrapped command line arguments `--add-flags --ngProbeLocations $out/node_modules --tsProbeLocations $out/node-modules`, which expects `node` in the `$PATH`. A typical usage of this server is to provide just the `--stdio` flag.

Besides the wrapped version it includes `bin/angular-language-server-unwrapped` which expects `nodejs` in the `$PATH` and this one does not set any command line arguments by default. This requires to provide the `--ngProbeLocations ` and the `--ngProbeLocations` arguments to the script.

The currently used packages are visible through [angular-language-server/package.json](./angular-language-server/package.json).

## How to use this?

Include the flake into your flake which defines the dev shell, e.g.:

``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    angular-language-server.url = "git+https://gitlab.com/junglerobba/angular-language-server";
    angular-language-server.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, angular-language-server, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            nodejs-18_x
            angular-language-server.packages.${system}.default
          ];
        };
      });
}
```

## License

[ISC](./LICENSE)
