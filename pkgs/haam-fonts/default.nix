{ lib, stdenv, fetchgit, }:
stdenv.mkDerivation rec {
  pname = "haam-fonts";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/Haam-z/haam-fonts";
    rev = "f0da282bc48b53116af7d972a92ba0fb5c4e0f92";
    hash = "sha256-vUOOMxyz0c4OLxlkNGQXm6V9yy9cZz5IdfDHdFa+DYQ=";
  };

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
     mkdir -p $out/share/fonts
    install -m444 -Dt $out/share/fonts/ ${src}/fonts/*.*tf;
  '';

  meta = with lib; {
    description = "A collection of fonts so i never install anything else";
    homepage = "https://github.com/Haam-z/fonts";
    license = licenses.unlicense;
  };
}
