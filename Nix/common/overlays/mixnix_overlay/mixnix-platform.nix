{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "mixnix-src";
  version = "ejpcmac-2021-12-30";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = "mixnix";
    rev = "0119d6dfd102d7ade83144e888e8103b0aa982e2";
    sha256 = "0n7nm7995s6d674mjlaxrxjrbf525aynp1fwp2ima5ig85c7k1nd";
  };

  installPhase = ''
    mkdir -p $out/mixnix
    cp -r $src/* $out/mixnix
  '';
}
