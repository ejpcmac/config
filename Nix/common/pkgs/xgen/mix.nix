{
  bunt = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "951c6e801e8b1d2cbe58ebbd3e616a869061ddadcc4863d0a2182541acae9a38";
      url = "https://repo.hex.pm/tarballs/bunt-0.2.0.tar";
    };
    version = "0.2.0";
  };
  certifi = {
    buildTool = "rebar3";
    deps = [
      "parse_trans"
    ];
    fetchHex = {
      sha256 = "75424ff0f3baaccfd34b1214184b6ef616d89e420b258bb0a5ea7d7bc628f7f0";
      url = "https://repo.hex.pm/tarballs/certifi-2.4.2.tar";
    };
    version = "2.4.2";
  };
  credo = {
    buildTool = "mix";
    deps = [
      "bunt"
      "jason"
    ];
    fetchHex = {
      sha256 = "aaa40fdd0543a0cf8080e8c5949d8c25f0a24e4fc8c1d83d06c388f5e5e0ea42";
      url = "https://repo.hex.pm/tarballs/credo-1.0.0.tar";
    };
    version = "1.0.0";
  };
  dialyxir = {
    buildTool = "mix";
    deps = [
      "erlex"
    ];
    fetchHex = {
      sha256 = "71b42f5ee1b7628f3e3a6565f4617dfb02d127a0499ab3e72750455e986df001";
      url = "https://repo.hex.pm/tarballs/dialyxir-1.0.0-rc.4.tar";
    };
    version = "1.0.0-rc.4";
  };
  earmark = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "17f0c38eaafb4800f746b457313af4b2442a8c2405b49c645768680f900be603";
      url = "https://repo.hex.pm/tarballs/earmark-1.3.0.tar";
    };
    version = "1.3.0";
  };
  erlex = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "c01c889363168d3fdd23f4211647d8a34c0f9a21ec726762312e08e083f3d47e";
      url = "https://repo.hex.pm/tarballs/erlex-0.1.6.tar";
    };
    version = "0.1.6";
  };
  ex_cli = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "30f97ef0751c75863c669cf34ebb689a5a3ebf9dafd2e73739f173fbd7561a53";
      url = "https://repo.hex.pm/tarballs/ex_cli-0.1.6.tar";
    };
    version = "0.1.6";
  };
  ex_doc = {
    buildTool = "mix";
    deps = [
      "earmark"
      "makeup_elixir"
    ];
    fetchHex = {
      sha256 = "519bb9c19526ca51d326c060cb1778d4a9056b190086a8c6c115828eaccea6cf";
      url = "https://repo.hex.pm/tarballs/ex_doc-0.19.1.tar";
    };
    version = "0.19.1";
  };
  ex_unit_notifier = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "36a2dcab829f506e01bf17816590680dd1474407926d43e64c1263e627c364b8";
      url = "https://repo.hex.pm/tarballs/ex_unit_notifier-0.1.4.tar";
    };
    version = "0.1.4";
  };
  excoveralls = {
    buildTool = "mix";
    deps = [
      "hackney"
      "jason"
    ];
    fetchHex = {
      sha256 = "fb4abd5b8a1b9d52d35e1162e7e2ea8bfb84b47ae07c38d39aa8ce64be0b0794";
      url = "https://repo.hex.pm/tarballs/excoveralls-0.10.2.tar";
    };
    version = "0.10.2";
  };
  file_system = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "fd4dc3af89b9ab1dc8ccbcc214a0e60c41f34be251d9307920748a14bf41f1d3";
      url = "https://repo.hex.pm/tarballs/file_system-0.2.6.tar";
    };
    version = "0.2.6";
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
      sha256 = "b5f6f5dcc4f1fba340762738759209e21914516df6be440d85772542d4a5e412";
      url = "https://repo.hex.pm/tarballs/hackney-1.14.3.tar";
    };
    version = "1.14.3";
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
  makeup = {
    buildTool = "mix";
    deps = [
      "nimble_parsec"
    ];
    fetchHex = {
      sha256 = "9e08dfc45280c5684d771ad58159f718a7b5788596099bdfb0284597d368a882";
      url = "https://repo.hex.pm/tarballs/makeup-0.5.5.tar";
    };
    version = "0.5.5";
  };
  makeup_elixir = {
    buildTool = "mix";
    deps = [
      "makeup"
    ];
    fetchHex = {
      sha256 = "0f09c2ddf352887a956d84f8f7e702111122ca32fbbc84c2f0569b8b65cbf7fa";
      url = "https://repo.hex.pm/tarballs/makeup_elixir-0.10.0.tar";
    };
    version = "0.10.0";
  };
  marcus = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "572f7bc5acd86e0122ccf8989a427420a655cc586ff540dd7a33b6ddcc8b43d8";
      url = "https://repo.hex.pm/tarballs/marcus-0.1.1.tar";
    };
    version = "0.1.1";
  };
  metrics = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "25f094dea2cda98213cecc3aeff09e940299d950904393b2a29d191c346a8486";
      url = "https://repo.hex.pm/tarballs/metrics-1.0.1.tar";
    };
    version = "1.0.1";
  };
  mimerl = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "993f9b0e084083405ed8252b99460c4f0563e41729ab42d9074fd5e52439be88";
      url = "https://repo.hex.pm/tarballs/mimerl-1.0.2.tar";
    };
    version = "1.0.2";
  };
  mix_test_watch = {
    buildTool = "mix";
    deps = [
      "file_system"
    ];
    fetchHex = {
      sha256 = "c72132a6071261893518fa08e121e911c9358713f62794a90c95db59042af375";
      url = "https://repo.hex.pm/tarballs/mix_test_watch-0.9.0.tar";
    };
    version = "0.9.0";
  };
  nimble_parsec = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "ee261bb53214943679422be70f1658fff573c5d0b0a1ecd0f18738944f818efe";
      url = "https://repo.hex.pm/tarballs/nimble_parsec-0.4.0.tar";
    };
    version = "0.4.0";
  };
  parse_trans = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "09765507a3c7590a784615cfd421d101aec25098d50b89d7aa1d66646bc571c1";
      url = "https://repo.hex.pm/tarballs/parse_trans-3.3.0.tar";
    };
    version = "3.3.0";
  };
  ssl_verify_fun = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "f0eafff810d2041e93f915ef59899c923f4568f4585904d010387ed74988e77b";
      url = "https://repo.hex.pm/tarballs/ssl_verify_fun-1.1.4.tar";
    };
    version = "1.1.4";
  };
  stream_data = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "fa86b78c88ec4eaa482c0891350fcc23f19a79059a687760ddcf8680aac2799b";
      url = "https://repo.hex.pm/tarballs/stream_data-0.4.2.tar";
    };
    version = "0.4.2";
  };
  typed_struct = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "25971ce73a8b336dedf2f80e4dafaab111af127ba4773955b66805c89e197f6a";
      url = "https://repo.hex.pm/tarballs/typed_struct-0.1.4.tar";
    };
    version = "0.1.4";
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

