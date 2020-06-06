{
  certifi = {
    buildTool = "rebar3";
    deps = [
      "parse_trans"
    ];
    fetchHex = {
      sha256 = "867ce347f7c7d78563450a18a6a28a8090331e77fa02380b4a21962a65d36ee5";
      url = "https://repo.hex.pm/tarballs/certifi-2.5.1.tar";
    };
    version = "2.5.1";
  };
  cowboy = {
    buildTool = "rebar3";
    deps = [
      "cowlib"
      "ranch"
    ];
    fetchHex = {
      sha256 = "99aa50e94e685557cad82e704457336a453d4abcb77839ad22dbe71f311fcc06";
      url = "https://repo.hex.pm/tarballs/cowboy-2.6.3.tar";
    };
    version = "2.6.3";
  };
  cowlib = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "a7ffcd0917e6d50b4d5fb28e9e2085a0ceb3c97dea310505f7460ff5ed764ce9";
      url = "https://repo.hex.pm/tarballs/cowlib-2.7.3.tar";
    };
    version = "2.7.3";
  };
  ex_aws = {
    buildTool = "mix";
    deps = [
      "hackney"
    ];
    fetchHex = {
      sha256 = "1e4de2106cfbf4e837de41be41cd15813eabc722315e388f0d6bb3732cec47cd";
      url = "https://repo.hex.pm/tarballs/ex_aws-2.1.1.tar";
    };
    version = "2.1.1";
  };
  ex_aws_s3 = {
    buildTool = "mix";
    deps = [
      "ex_aws"
    ];
    fetchHex = {
      sha256 = "c0258bbdfea55de4f98f0b2f0ca61fe402cc696f573815134beb1866e778f47b";
      url = "https://repo.hex.pm/tarballs/ex_aws_s3-2.0.2.tar";
    };
    version = "2.0.2";
  };
  hackney = {
    buildTool = "rebar3";
    deps = [
      "certifi"
      "idna"
      "metrics"
      "mimerl"
      "ssl_verify_fun"
    ];
    fetchHex = {
      sha256 = "9f8f471c844b8ce395f7b6d8398139e26ddca9ebc171a8b91342ee15a19963f4";
      url = "https://repo.hex.pm/tarballs/hackney-1.15.1.tar";
    };
    version = "1.15.1";
  };
  hex_core = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "9e52ee57c001022fa36dfa3b835c58383c1b09b162fd993e15bdc98904f29b0b";
      url = "https://repo.hex.pm/tarballs/hex_core-0.5.0.tar";
    };
    version = "0.5.0";
  };
  idna = {
    buildTool = "rebar3";
    deps = [
      "unicode_util_compat"
    ];
    fetchHex = {
      sha256 = "689c46cbcdf3524c44d5f3dde8001f364cd7608a99556d8fbd8239a5798d4c10";
      url = "https://repo.hex.pm/tarballs/idna-6.0.0.tar";
    };
    version = "6.0.0";
  };
  jason = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "b03dedea67a99223a2eaf9f1264ce37154564de899fd3d8b9a21b1a6fd64afe7";
      url = "https://repo.hex.pm/tarballs/jason-1.1.2.tar";
    };
    version = "1.1.2";
  };
  metrics = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "25f094dea2cda98213cecc3aeff09e940299d950904393b2a29d191c346a8486";
      url = "https://repo.hex.pm/tarballs/metrics-1.0.1.tar";
    };
    version = "1.0.1";
  };
  mime = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "30ce04ab3175b6ad0bdce0035cba77bba68b813d523d1aac73d9781b4d193cf8";
      url = "https://repo.hex.pm/tarballs/mime-1.3.1.tar";
    };
    version = "1.3.1";
  };
  mimerl = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "67e2d3f571088d5cfd3e550c383094b47159f3eee8ffa08e64106cdf5e981be3";
      url = "https://repo.hex.pm/tarballs/mimerl-1.2.0.tar";
    };
    version = "1.2.0";
  };
  parse_trans = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "09765507a3c7590a784615cfd421d101aec25098d50b89d7aa1d66646bc571c1";
      url = "https://repo.hex.pm/tarballs/parse_trans-3.3.0.tar";
    };
    version = "3.3.0";
  };
  plug = {
    buildTool = "mix";
    deps = [
      "mime"
      "plug_crypto"
    ];
    fetchHex = {
      sha256 = "0bcce1daa420f189a6491f3940cc77ea7fb1919761175c9c3b59800d897440fc";
      url = "https://repo.hex.pm/tarballs/plug-1.8.2.tar";
    };
    version = "1.8.2";
  };
  plug_cowboy = {
    buildTool = "mix";
    deps = [
      "cowboy"
      "plug"
    ];
    fetchHex = {
      sha256 = "6055f16868cc4882b24b6e1d63d2bada94fb4978413377a3b32ac16c18dffba2";
      url = "https://repo.hex.pm/tarballs/plug_cowboy-2.0.2.tar";
    };
    version = "2.0.2";
  };
  plug_crypto = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "18e49317d3fa343f24620ed22795ec29d4a5e602d52d1513ccea0b07d8ea7d4d";
      url = "https://repo.hex.pm/tarballs/plug_crypto-1.0.0.tar";
    };
    version = "1.0.0";
  };
  ranch = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "6b1fab51b49196860b733a49c07604465a47bdb78aa10c1c16a3d199f7f8c881";
      url = "https://repo.hex.pm/tarballs/ranch-1.7.1.tar";
    };
    version = "1.7.1";
  };
  ssl_verify_fun = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "f0eafff810d2041e93f915ef59899c923f4568f4585904d010387ed74988e77b";
      url = "https://repo.hex.pm/tarballs/ssl_verify_fun-1.1.4.tar";
    };
    version = "1.1.4";
  };
  unicode_util_compat = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "d869e4c68901dd9531385bb0c8c40444ebf624e60b6962d95952775cac5e90cd";
      url = "https://repo.hex.pm/tarballs/unicode_util_compat-0.4.1.tar";
    };
    version = "0.4.1";
  };
}

