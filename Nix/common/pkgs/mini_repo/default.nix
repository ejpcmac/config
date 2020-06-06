{ mix2nix, fetchFromGitHub, makeWrapper }:

mix2nix.mkMixPackage rec {
  name = "mini_repo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ejpcmac";
    repo = name;
    rev = "d79f4d4656050ab9df198ad00cddfa7f5df61ec4";
    sha256 = "1xclavc9ngkscfzkcdw6s0n4s5fny2n3r9dfgwdhaswczm787kss";
  };

  nativeBuildInputs = [ makeWrapper ];

  mixNix = ./mix.nix;
  mixConfig = {
    hackney = self: { patches = []; };
  };

  buildPhase = ''
    MIX_ENV=prod mix release --no-deps-check --path $out
  '';

  installPhase = ''
    # Patch the executable to work properly from the Nix store.
    sed -i 's/cp/install -m 644/' $out/bin/${name}
    wrapProgram $out/bin/${name} --set RELEASE_TMP /tmp/${name}

    # Install the configuration.
    cp ${./releases.exs} $out/releases/${version}/releases.exs
  '';
}
