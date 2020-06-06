{ rustPlatform, fetchFromGitHub, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "rustup-mirror";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "jiegec";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l58f6m2k1h8k9l3ifk0z9djkbrvcrjy2vfygdamz3n3avcdp7kg";
  };

  cargoSha256 = "07safw2fi97kj316mzqq2rpvb7lgm8czvr4w0plxlm1hf5fzp2f3";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];
}
