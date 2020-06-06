{ mix2nix, fetchFromGitHub }:

mix2nix.mkMixPackage rec {
  name = "xgen";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = name;
    rev = "v${version}";
    sha256 = "1qyi06w7kxk3n8ircpw2wlmw8i31ymzycn21x4bxdhvkc7s8f7pd";
  };

  mixNix = ./mix.nix;
  releaseType = "escript";
}
