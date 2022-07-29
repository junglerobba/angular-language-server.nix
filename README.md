# web-language-servers.nix

- [Introduction](#introduction)
- [Angular Language Server](#angular-language-server)
- [Typescript Language Server](#typescript-language-server)
- [Extracted VSCcode Language Servers](#extracted-vscode-language-servers)


## Introduction

A Nix flake providing various language servers for web development. It allows easy integration into existing development shells without polluting `package.json/devDependencies` (which probably other developers aren't intersted in if the use a different tooling, i.e. not Nix).


## Angular Language Server

It provides `bin/angular-language-server` (aka `ngserver`) from [vscode-ng-language-service](https://github.com/angular/vscode-ng-language-service) with the wrapped command line arguments `--add-flags --ngProbeLocations $out/node_modules --tsProbeLocations $out/node-modules`, which expects `node` in the `$PATH`. A typical usage of this server is to provide just the `--stdio` flag.

Besides the wrapped version it includes `bin/angular-language-server-unwrapped` which expects `nodejs` in the `$PATH` and this one does not set any command line arguments by default. This requires to provide the `--ngProbeLocations ` and the `--ngProbeLocations` arguments to the script.

The currently used packages are visible through [angular-language-server/package.json](./angular-language-server/package.json).


## Typescript Language Server

It provides `bin/typescript-language-server` from [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server), which expects `node` in the `$PATH`. A typical usage of this server is to provide just the `--stdio` flag.

The currently used packages are visible through [typescript-language-server/package.json](./typescript-language-server/package.json).


## Extracted VSCcode Language Servers

It provides `bin/vscode-{css,eslint,html,json}-language-server` from [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) with expects `node` in `$PATH`. A typical usage of these servers is to pass the `--stdio` flag.

The currently used packages are visible through [vscode-langservers-extracted/package.json](./vscode-langservers-extracted/package.json).

Included are currently:

- vscode-css-language-server
- vscode-eslint-language-server
- vscode-html-language-server
- vscode-json-language-server


## How to use this?

Include the flake into your flake which defines the dev shell, e.g.:

``` nix
{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    language-servers.url = git+https://git.sr.ht/~bwolf/web-language-servers.nix;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, language-servers, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-18_x
            language-servers.packages.${system}.angular-language-server
            language-servers.packages.${system}.typescript-language-server
            language-servers.packages.${system}.vscode-langservers-extracted
          ];
        };
      });
}
```


## Contributions

Contributions are welcome as patches to the [mailing list](https://lists.sr.ht/~bwolf/public-inbox).


## License

[ISC](./LICENSE)
