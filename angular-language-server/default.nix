{ pkgs, nodejs, ... }:

let
  version = let packageJson = with builtins; fromJSON (readFile ./package.json);
  in builtins.replaceStrings [ "^" "~" ] [ "" "" ]
  (packageJson.dependencies."@angular/language-server");

in pkgs.mkYarnPackage rec {
  inherit version nodejs;
  pname = "angular-language-server";

  src = ./.;

  buildInputs = with pkgs; [ typescript ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r $node_modules $out
    cp $src/index.js $out/bin/${pname}-unwrapped
    patchShebangs --build $out/bin/${pname}-unwrapped
    chmod a+x $out/bin/${pname}-unwrapped

    makeWrapper $out/bin/${pname}-unwrapped $out/bin/ngserver \
      --add-flags "--ngProbeLocations $out/node_modules --tsProbeLocations ${pkgs.typescript}/lib/node-modules"

    runHook postInstall
  '';

  dontFixup = true;
  doDist = false;
}
