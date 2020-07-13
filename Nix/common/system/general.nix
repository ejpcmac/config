################################################################################
##                                                                            ##
##                        General system configuration                        ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  confkit = import ../../../confkit;
  jpc_overlay = import ../overlays/jpc_overlay.nix;
in

{
  imports = with confkit.modules.system; [
    # Confkit modules
    environment
    nix
    tmux
    utilities
    zsh
  ];

  nixpkgs.overlays = [ jpc_overlay ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "fr_FR.UTF-8";
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    lm_sensors
    ntfs3g
    openssl
    pv
    pythonPackages.glances
    wakelan
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    tmux.useBepoKeybindings = true;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    ntp.enable = true;
  };

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  environment = {
    etc = {
      "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
      "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
    };

    variables = {
      # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
      RANGER_LOAD_DEFAULT_RC = "FALSE";
    };
  };
}
