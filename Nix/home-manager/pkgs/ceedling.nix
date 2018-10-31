{ buildRubyGem, ruby, rake }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "ceedling";
  version = "0.28.3";
  source.sha256 = "7fc51bb36bcd74545fbc0406832466596d946eac22b40473cb6d9b18a689d207";

  constructor = buildRubyGem rec {
    inherit ruby;
    name = "${gemName}-${version}";
    gemName = "constructor";
    version = "2.0.0";
    source.sha256 = "3e2184496074926f5afa396f5d4377dce99a26f3a5763afe6c256e3611b8150b";
  };

  thor = buildRubyGem rec {
    inherit ruby;
    name = "${gemName}-${version}";
    gemName = "thor";
    version = "0.20.0";
    source.sha256 = "b47dad86e151c08921cf935c1ad2be4d9982e435784d6bc223530b62a4bfb85a";
  };

  buildInputs = [ rake ];
  propagatedBuildInputs = [ constructor thor ];
}
