{ pkgs ? import <nixpkgs> { } }: rec {
  haam-fonts = pkgs.callPackage ./haam-fonts { };
}
