{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "jdt-language-server";
  version = "1.12.0";

  src = pkgs.fetchurl {
    url = https://download.eclipse.org/jdtls/milestones/1.12.0/jdt-language-server-1.12.0-202206011637.tar.gz;
    sha256 = "sha256-OPIP7Ceo/NsbPEmhF2Kd0IALFhFxr9S4lL3AJvL8ovM=";
  };

  buildPhase = ''
    mkdir -p jdt-language-server
    tar xfz $src -C jdt-language-server
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -a jdt-language-server/bin/* $out/bin
    chmod a+x $out/bin/jdtls
    chmod a-x $out/bin/jdtls.py
    cp -a jdt-language-server $out/libexec
  '';

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
}
