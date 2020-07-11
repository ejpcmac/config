self: super:

let
  inherit (super) callPackage;

  ## Updates Elixir in a given beam.packages version.
  updateElixir = erlang-self: erlang-super: rec {
    elixir_1_10 = self.beam.lib.callElixir ./elixir-1.10.nix {
      inherit (erlang-super) erlang rebar;
      debugInfo = true;
    };

    elixir = elixir_1_10;
  };
in

rec {
  ############################################################################
  ##                             Local packages                             ##
  ############################################################################

  apt-mirror = callPackage ../pkgs/apt-mirror {};
  ceedling = callPackage ../pkgs/ceedling {};
  cargo-cacher = callPackage ../pkgs/cargo-cacher {};
  diceware = callPackage ../pkgs/diceware {};
  mini_repo = callPackage ../pkgs/mini_repo {};
  pms = callPackage ../pkgs/pms {};
  rustup-mirror = callPackage ../pkgs/rustup-mirror {};
  xgen = callPackage ../pkgs/xgen {};
  zolaUnstable = callPackage ../pkgs/zolaUnstable {};

  ############################################################################
  ##                             Version fixes                              ##
  ############################################################################

  # To get --off <timeout>.
  betterlockscreen = super.betterlockscreen.overrideAttrs (attrs: rec {
    src = self.fetchFromGitHub {
      owner = "pavanjadhaw";
      repo = "betterlockscreen";
      rev = "89f7dcd2be2053297c559762d23b5e4a6ba20546";
      sha256 = "0dcr4nvaxi749njr258rnba44ay12dikaxy6q709m400h50xppr2";
    };
  });

  # mu 1.5 can move messages between filesystems.
  mu = super.mu.overrideAttrs (attrs: rec {
    version = "1.5.1+09c1942";

    src = self.fetchFromGitHub {
      owner  = "djcb";
      repo   = "mu";
      rev    = "09c19421877eb513b5800bd0d07edfccd2ea2988";
      sha256 = "1kzsnhmvk23srnhmszf4qblxla0hi3nd6mchzdq9q30jzr7hg5r2";
    };

    postPatch = "";
  });

  ############################################################################
  ##                       Elixir 1.10 on NixOS 19.09                       ##
  ############################################################################

  beam = self.lib.recursiveUpdate super.beam rec {
    packages = {
      erlang = super.beam.packages.erlang.extend updateElixir;
      erlangR18 = super.beam.packages.erlangR18.extend updateElixir;
      erlangR19 = super.beam.packages.erlangR19.extend updateElixir;
      erlangR20 = super.beam.packages.erlangR20.extend updateElixir;
      erlangR21 = super.beam.packages.erlangR21.extend updateElixir;
      erlangR22 = super.beam.packages.erlangR22.extend updateElixir;
    };

    interpreters.elixir_1_10 = packages.erlang.elixir_1_10;
    interpreters.elixir = interpreters.elixir_1_10;
  };

  inherit (beam.interpreters) elixir_1_10;

  ############################################################################
  ##                                Patches                                 ##
  ############################################################################

  # Patch Signal-Desktop to use the system tray.
  signal-desktop = super.signal-desktop.overrideAttrs (attrs: rec {
    # Also patch the version while in Kerguelen.
    version = "1.29.3";
    src = /data/Logiciels/Installeurs/Linux/Internet/signal-desktop_1.29.3_amd64.deb;

    installPhase = attrs.installPhase + ''
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace $out/bin/signal-desktop $out/bin/signal-desktop\ --use-tray-icon
    '';
  });

  # Update Mixxx and install the udev rule for HID controllers.
  mixxx = super.mixxx.overrideAttrs (attrs: rec {
    version = "2.2.4";

    src = self.fetchFromGitHub {
      owner = "mixxxdj";
      repo = "mixxx";
      rev = "release-${version}";
      sha256 = "1dj9li8av9b2kbm76jvvbdmihy1pyrw0s4xd7dd524wfhwr1llxr";
    };

    postInstall = self.lib.optionalString self.stdenv.isLinux ''
      rules="$src/res/linux/mixxx.usb.rules"
      if [ ! -f "$rules" ]; then
          echo "$rules is missing, must update the Nix file."
          exit 1
      fi

      mkdir -p "$out/lib/udev/rules.d"
      cp "$rules" "$out/lib/udev/rules.d/69-mixxx-usb-uaccess.rules"
    '';
  });
}
