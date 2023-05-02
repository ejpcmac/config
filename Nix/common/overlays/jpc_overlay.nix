self: super:

let
  inherit (super) callPackage;

  ## Adds the latest Elixir version in a given beam.packages.
  updateElixir = erlang-self: erlang-super: {
    elixir_latest = self.beam.beamLib.callElixir ../pkgs/elixir-latest {
      inherit (erlang-super) erlang;
      debugInfo = true;
    };

    elixir = erlang-self.elixir_latest;
  };
in

{
  ############################################################################
  ##                             Local packages                             ##
  ############################################################################

  daedalus = callPackage ../pkgs/daedalus { };
  diceware = callPackage ../pkgs/diceware { };
  xgen = callPackage ../pkgs/xgen { };

  ############################################################################
  ##                             Version fixes                              ##
  ############################################################################

  # Pin the Darktable version until I have time to check the upgrade properly.
  darktable = callPackage ../pkgs/darktable { };

  # Use Fira Code 1 until I find why Fira Code Retina is not available in Emacs
  # in more recent versions.
  fira-code = callPackage ../pkgs/fira-code { };

  # There are breaking changes in mu 1.8, let’s update it later.
  mu = callPackage ../pkgs/mu { };

  ############################################################################
  ##                                Patches                                 ##
  ############################################################################

  # Add crypto-currencies.
  gnucash = super.gnucash.overrideAttrs (attrs: {
    patches = attrs.patches ++ [
      ./crypto-currencies.patch
    ];
  });

  # Install udev rules.
  libsigrok = super.libsigrok.overrideAttrs (attrs: {
    postInstall = attrs.postInstall + ''
      mkdir -p "$out/lib/udev/rules.d"
      cp "contrib/60-libsigrok.rules" "$out/lib/udev/rules.d"
      cp "contrib/61-libsigrok-plugdev.rules" "$out/lib/udev/rules.d"
      cp "contrib/61-libsigrok-uaccess.rules" "$out/lib/udev/rules.d"
    '';
  });

  ############################################################################
  ##                     Latest Elixir on NixOS Stable                      ##
  ############################################################################

  beam = self.lib.recursiveUpdate super.beam {
    packages = {
      erlang = super.beam.packages.erlang.extend updateElixir;
      erlangR21 = super.beam.packages.erlangR21.extend updateElixir;
      erlangR22 = super.beam.packages.erlangR22.extend updateElixir;
      erlangR23 = super.beam.packages.erlangR23.extend updateElixir;
      erlangR24 = super.beam.packages.erlangR24.extend updateElixir;
    };

    interpreters.elixir_latest = self.beam.packages.erlang.elixir_latest;
    interpreters.elixir = self.beam.interpreters.elixir_latest;
  };

  inherit (self.beam.interpreters) elixir_latest;
}
