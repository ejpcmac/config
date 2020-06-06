{ rustPlatform, fetchFromGitHub, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cacher";
  version = "ejpcmac-2020-05-06";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = pname;
    rev = "f28263e467f82adb7084b7b916a6ef5cdaaa54db";
    sha256 = "1wbhlpkqidvilbv00wq3dffprrb2a2kbp9xymzn5bxrg818kif14";
  };

  cargoSha256 = "0iwh89c8jl97h1rl8p3izqc8z94820kn2hbyavqx1hrlv9ig7xvi";

  buildInputs = [ sqlite ];
}
