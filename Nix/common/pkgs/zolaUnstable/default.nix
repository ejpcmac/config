{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "unstable-2019-08-12";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "a6db79f89bd1fa9f2b325ff2f2057400bf4ef8ab";
    sha256 = "0vmp7fqar9va50rnzmxkxbrwzz2gll03mf29cnzdhqqb7lc5lndr";
  };

  cargoSha256 = "1ik6qdif399k066za31dpig10p87505yr196n1l58d2pyr1z71b2";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openssl ];

  postInstall = ''
    install -D -m 444 completions/zola.bash \
      -t $out/share/bash-completion/completions
    install -D -m 444 completions/_zola \
      -t $out/share/zsh/site-functions
    install -D -m 444 completions/zola.fish \
      -t $out/share/fish/vendor_completions.d
  '';

  meta = with stdenv.lib; {
    description = "A fast static site generator with everything built-in";
    homepage = https://www.getzola.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
