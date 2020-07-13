################################################################################
##                                                                            ##
##                     Configuration for the ZFS feature                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  jpc = import <nixpkgs-jpc> { inherit pkgs; };
in

{
  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    jpc.syncoid
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    zfs = {
      autoSnapshot = {
        enable = true;
        frequent = 4;
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 24;
      };

      autoScrub = {
        enable = true;
        interval = "Sun, 13:00";
      };
    };
  };
}
