self: super:

let
  inherit (super) callPackage lib;
in

{
  ############################################################################
  ##                             Local packages                             ##
  ############################################################################

  diceware = callPackage ../pkgs/diceware { };
  exiv2-0-27 = callPackage ../pkgs/exiv2-0-27 { };
  xgen = callPackage ../pkgs/xgen { };

  ############################################################################
  ##                             Version fixes                              ##
  ############################################################################

  # Pin the Darktable version until I have time to check the upgrade properly.
  darktable = callPackage ../pkgs/darktable { };

  # Use Fira Code 1 until I find why Fira Code Retina is not available in Emacs
  # in more recent versions.
  fira-code = callPackage ../pkgs/fira-code { };

  ############################################################################
  ##                                Patches                                 ##
  ############################################################################

  # HACK: The GitLab service mistakenly hardcodes PostgreSQL 14, yet is only
  # compatible with PostgreSQL 16+.
  postgresql_14 = lib.warn "postgresql_14 is overlayed to postgresql_16" super.postgresql_16;

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
}
