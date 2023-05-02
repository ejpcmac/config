################################################################################
##                                                                            ##
##                      System configuration for Philae                       ##
##                                                                            ##
################################################################################

{ lib, modulesPath, ... }:

{
  imports = [
    # Philae derives from the minimal netboot installer.
    "${modulesPath}/installer/netboot/netboot-minimal.nix"

    # Import my personal NixOS extension module.
    ../common/nixos

    # Configuration for the users.
    ./users/root

    # Import kexec to allow bootstrapping.
    ./kexec.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    features.utilities.enable = lib.mkForce false;

    info = {
      name = "philae";
      location = "ovh";
    };
  };

  ############################################################################
  ##                              Boot process                              ##
  ############################################################################

  boot = {
    loader.grub.enable = false;
    # Reboot the machine on fatal boot issues.
    kernelParams = [ "panic=30" "boot.panic_on_fail" ];
    supportedFilesystems = [ "zfs" ];
  };

  ############################################################################
  ##                                Programs                                ##
  ############################################################################

  programs = {
    mosh.enable = true;
  };
}
