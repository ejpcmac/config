################################################################################
##                                                                            ##
##                Home configuration for jpc on home computers                ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (pkgs) writeShellScript;
  inherit (libjpc) mkEmail;
  libjpc = import ../lib { inherit config pkgs; };

  # Index the mailbox and update mu4e after running mbsync.
  mbsyncPostExec = writeShellScript "mbsync-post-exec" ''
    ${pkgs.emacs}/bin/emacsclient \
        --socket-name=/var/run/user/1000/emacs1000/server \
        --eval '(mu4e~proc-kill)' &&

    ${pkgs.mu}/bin/mu index --maildir=$HOME/Courriels &&

    ${pkgs.emacs}/bin/emacsclient \
        --socket-name=/var/run/user/1000/emacs1000/server \
        --eval '(mu4e-alert-enable-mode-line-display)'
  '';
in

{
  ############################################################################
  ##                                Accounts                                ##
  ############################################################################

  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Courriels";

    accounts = {
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" {};
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" {};
      "***[ REDACTED ]***" = mkEmail "***[ REDACTED ]***" {};

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

  # services.mbsync = {
  #   enable = true;
  #   frequency = "*:0/5";
  #   postExec = "${mbsyncPostExec}";
  # };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    pidgin = { enable = true; plugins = [ pkgs.pidgin-otr ]; };

    zsh = {
      shellAliases = {
        # iPhone management
        mount-iphone = "ifuse ~/iPhone";
        unmount-iphone = "fusermount -u ~/iPhone";
        backup-iphone-photos = "rsync -a --progress ~/iPhone/DCIM/*/* ~/Photo/iPhone";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    ifuse

    # Applications
    darktable
    mixxx
    signal-desktop
    stellarium
  ];
}
