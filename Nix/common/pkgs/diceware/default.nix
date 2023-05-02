{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diceware";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PR9csAQHSJWq5x286+vUYLeFJuTHoWqSvGvfIDJjGuc=";
  };

  cargoHash = "sha256-wbf2l+QdPOBnmYewPWnSMc05DKnkXPFlprJLMLVKHkU=";

  doCheck = false;
}
