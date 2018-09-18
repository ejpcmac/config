# NixOS Test configuration file.

{ config, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03";  # Did you read the comment?

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ../environment.nix
    ../nix.nix
    ../tmux.nix
    ../vim.nix
    ../xserver.nix
    ../zsh.nix
  ];

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    initrd.luks.devices = [
      { name = "nixos"; device = "/dev/sda3"; preLVM = true; allowDiscards = true; }
    ];

    cleanTmpDir = true;
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  fileSystems."/home".options = [ "discard" ];

  networking = {
    hostName = "nixos-test";
    # wireless.enable = true
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    dcfldd
    emv
    git
    git-lfs
    gnupg
    htop
    imagemagick
    lsof
    mkpasswd
    nix-prefetch-github
    nox
    openssh
    rename
    rsync
    testdisk
    tree
    unzip
    watch
    wget
    xz
    zip

    firefox
    keepassx2
    libreoffice
    quodlibet
    thunderbird

    gnome3.gnome-session
  ];

  programs = {
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    wireshark = { enable = true; package = pkgs.wireshark-gtk; };
  };

  services = {
    ntp.enable = true;
    # printing.enable = true;
    # smartd = { enable = true; notifications.x11.enable = true; };
  };
}
