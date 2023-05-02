################################################################################
##                                                                            ##
##                Home configuration for jpc on home computers                ##
##                                                                            ##
################################################################################

{ config, inputs, pkgs, system, ... }:

let
  unstable = import inputs.nixpkgs-unstable { inherit system; };
  libjpc = pkgs.callPackage ../lib { };

  inherit (libjpc) link mkEmail;
in

{
  ############################################################################
  ##                              Persistence                               ##
  ############################################################################

  home.file = {
    # General persistence
    ".mixxx".source = link "/home/jpc/.persist/Mixxx";
    ".purple".source = link "/home/jpc/.persist/Pidgin";
    ".thunderbird".source = link "/home/jpc/.persist/Thunderbird";
    ".wine".source = link "/home/jpc/.persist/wine";

    # General cache persistence
    ".cache/calibre".source = link "/home/jpc/.persist/Calibre/cache";
    ".cache/cantata".source = link "/home/jpc/.persist/Cantata/cache";
    ".cache/liferea".source = link "/home/jpc/.persist/Liferea/cache";

    # Persistence for the Courriels module
    ".cache/mu".source = link "/home/jpc/.persist/mu";

    # Persistence for the Photo module
    ".cache/darktable".source = link "/home/jpc/.persist/Darktable/cache";
  };

  xdg.configFile = {
    # General persistence
    "asunder".source = link "/home/jpc/.persist/Asunder";
    "calibre".source = link "/home/jpc/.persist/Calibre/config";
    "cantata".source = link "/home/jpc/.persist/Cantata/config";
    "liferea".source = link "/home/jpc/.persist/Liferea/config";
    "Signal".source = link "/home/jpc/.persist/Signal";

    # Persistence for the Photo module
    "darktable".source = link "/home/jpc/.persist/Darktable/config";
  };

  xdg.dataFile = {
    # General persistence
    "cantata".source = link "/home/jpc/.persist/Cantata/data";
    "liferea".source = link "/home/jpc/.persist/Liferea/data";
  };

  ############################################################################
  ##                                Accounts                                ##
  ############################################################################

  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Courriels";

    accounts = {
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" { };
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" { };
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" { };

      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" {
        imap = {
          host = "***[ REDACTED ]***";
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = "***[ REDACTED ]***";
          port = 465;
          tls.enable = true;
        };
      };
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    nextcloud-client = { enable = true; startInBackground = true; };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    pidgin = { enable = true; plugins = [ pkgs.pidgin-otr ]; };

    zsh = {
      shellAliases = {
        # Aliases to local scripts and tools
        ta = "track all";

        # Network drives shortcuts
        lm = "mount | grep media";
        unet = "sudo systemctl stop 'media-*.mount'";

        # Emailing aliases
        eg = "mbsync ***[ REDACTED ]***:INBOX ***[ REDACTED ]***:INBOX";
        es = "mbsync -a";

        # mu initialisation
        mu-init = ''
          mu init -m ~/Courriels \
                  --my-address=***[ REDACTED ]*** \
                  --my-address=***[ REDACTED ]***
        '';
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    gitAndTools.hub
    nixops
    pijul
    tokei
    zola

    # Applications
    calibre
    darktable
    element-desktop
    liferea
    unstable.mixxx
    scribus
    signal-desktop
    stellarium
    thunderbird
    yubioath-desktop
    zeal
  ];
}
