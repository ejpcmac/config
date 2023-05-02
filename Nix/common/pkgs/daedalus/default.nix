{ fetchFromGitHub }:

(import
  (fetchFromGitHub {
    owner = "input-output-hk";
    repo = "daedalus";
    rev = "5.2.0";
    hash = "sha256-ImXTFG8KgQvLNfFpApRUjmZZPoBwf+5ZjXhBrRw+XPA=";
  })
  { }).daedalus
