{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  name = "mixnix-src";
  version = "2019-07-24";

  src = fetchFromGitLab {
    owner = "manveru";
    repo = "mixnix";
    rev = "3fe662bf6f764a7a49677663d234202e61f528d3";
    sha256 = "14sn0szlyzj5x63damsk9xryxmngryc6fmhsqh8x6yk0xxy082a9";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';
}
