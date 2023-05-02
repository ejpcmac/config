################################################################################
##                                                                            ##
##                     Home configuration for jpc@pluton                      ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  inherit (lib) mkForce;
in

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/features/server-aliases.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    identity.email = mkForce "***[ REDACTED ]***";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    polybar = {
      config = {
        "bar/main".modules-right = "alsa memory cpu battery date";
        "module/alsa".master-soundcard = "hw:0";
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    termite.font = "DejaVu Sans Mono 8.5";
  };
}
