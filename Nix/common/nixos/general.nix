################################################################################
##                                                                            ##
##                        General system configuration                        ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib.trivial) release;
  jpc_overlay = import ../overlays/jpc_overlay.nix;
in

{
  imports = [
    # Import the confkit NixOS module to get ready-to-use configurations for
    # several tools.
    ../../../confkit/nixos

    # Import the home-manager NixOS module to handle user configurations
    # declaratively.
    ../../../home-manager/nixos
  ];

  nixpkgs.overlays = [ jpc_overlay ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    nix.enable = true;
    ranger.enable = true;
    shell.enable = true;
    tmux.enable = true;
    utilities.enable = true;
    zsh.enable = true;

    # Use BÉPO-optimised keybindings.
    keyboard.bepo = true;
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  # TODO: Remove NixOS 19.09 support once all machines are on NixOS 20.03.
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
  } // (if release == "19.09" then {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
  } else {});

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    ntp.enable = true;
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    lm_sensors
    openssl
    pv
    pythonPackages.glances
  ];
}
// (if release == "20.03" then {
  # TODO: Remove NixOS 19.09 support once all machines are on NixOS 20.03.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };
} else {})
