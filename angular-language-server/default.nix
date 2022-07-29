{ pkgs, nodejs, ... }:

let
  version = let packageJson = with builtins; fromJSON (
    readFile ./package.json);
            in builtins.replaceStrings ["^" "~"] ["" ""] (packageJson.dependencies."@angular/language-server");

in pkgs.mkYarnPackage rec {
  pname = "angular-language-server";
  version = "14.1";
  src = ./.;
  inherit nodejs;

  dontFixup = true;
  doDist = false;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r $node_modules $out
    cp $src/index.js $out/bin/${pname}-unwrapped
    chmod a+x $out/bin/${pname}-unwrapped

    makeWrapper $out/bin/${pname}-unwrapped $out/bin/${pname} \
      --add-flags "--ngProbeLocations $out/node_modules --tsProbeLocations $out/node-modules"

    runHook postInstall
  '';
}