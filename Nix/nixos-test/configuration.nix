##
## NixOS system configuration test
##

{ config, pkgs, ... }:

let
  inherit (pkgs) callPackage runCommand;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09";  # Did you read the comment?

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    # Configuration shared between hosts
    ../common/configuration.nix
  ];

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # efi.efiSysMountPoint = "/boot/efi";
      efi.efiSysMountPoint = "/boot";
      timeout = 1;
    };

    # initrd.luks.devices = [
    #   { name = "nixos"; device = "/dev/sda3"; preLVM = true; allowDiscards = true; }
    # ];

    cleanTmpDir = true;
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  networking.hostName = "nixos-test";

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    # pandoc

    # TeXLive can be useful for tools like Pandoc or Org.
    # texlive.combined.scheme-medium

    # Applications
    cantata
    easytag
    firefox
    gimp
    keepassx2
    libreoffice
    pqiv
    thunderbird
    zathura
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    # gnupg.agent = { enable = true; enableSSHSupport = true; };
    wireshark = { enable = true; package = pkgs.wireshark-gtk; };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    # smartd = { enable = true; notifications.x11.enable = true; };
  };
}
