{ fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "pms-${version}";
  version = "2018-11-23";
  goPackagePath = "github.com/ambientsound/pms";

  src = fetchFromGitHub {
    owner = "ambientsound";
    repo = "pms";
    rev = "000c5c0b5b51d0a82621ca0d94577b812cb98701";
    sha256 = "1rad133j0ib4lbg8xxkm7hcs0h8b4djix75i92hvjcdqc004m8wp";
  };

  goDeps = ./deps.nix;
}
