{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "apt-mirror-${version}";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "apt-mirror";
    repo = "apt-mirror";
    rev = version;
    sha256 = "0qj6b7gldwcqyfs2kp6amya3ja7s4vrljs08y4zadryfzxf35nqq";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/apt-mirror $out/bin
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/apt-mirror --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';
}
