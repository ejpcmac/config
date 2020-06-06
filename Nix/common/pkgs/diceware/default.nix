{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diceware";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z3nnaazgvj1j8a0xw5jjcdzqpqai875p4fi0ncfjsa8ar6krcfs";
  };

  cargoSha256 = "042l9hm87a9vjhp24fpkxi3wcwdxmqqc7i55rqi7gm1whn78861p";

  doCheck = false;
}
