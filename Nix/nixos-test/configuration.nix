##
## NixOS system configuration test
##

{ config, pkgs, ... }:

let
  inherit (pkgs) callPackage;
  confkit = import ../../confkit;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09";  # Did you read the comment?

  imports = with confkit.modules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    # confkit modules
    environment
    nix
    tmux
    zsh
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
  time.timeZone = "Europe/Paris";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "fr_FR.UTF-8";
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  ############################################################################
  ##                              Environment                               ##
  ############################################################################

  environment.variables = {
    # Set $TMDIR so that it is the same inside and outside Nix shells.
    TMPDIR = "/var/run/user/$UID";

    # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

  ############################################################################
  ##                                 Fonts                                  ##
  ############################################################################

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      meslo-lg
      (nerdfonts.override { withFont = "DejaVuSansMono Noto"; })
      opensans-ttf
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = { enable = true; autohint = false; };
      includeUserConf = false;
      penultimate.enable = true;
      ultimate.enable = false;
      useEmbeddedBitmaps = true;
    };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    curl
    dcfldd
    emv
    git
    git-lfs
    gnupg
    htop
    iftop
    imagemagick
    killall
    lsof
    mkpasswd
    mosh
    mpc_cli
    nix-prefetch-github
    nox
    openssh
    # pandoc
    ranger
    rename
    rsync
    sshfs
    testdisk
    trash-cli
    tree
    unzip
    watch
    wget
    xorg.xev
    xz
    zip

    # TeXLive can be useful for tools like Pandoc or Org.
    # texlive.combined.scheme-medium

    # Desktop environment
    feh
    sxhkd

    # Applications
    cantata
    easytag
    firefox
    gimp
    keepassx2
    libreoffice
    thunderbird
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
    emacs = { enable = true; defaultEditor = true; };
    ntp.enable = true;
    printing.enable = true;
    # smartd = { enable = true; notifications.x11.enable = true; };

    xserver = {
      enable = true;

      # Configure the keyboard layout.
      layout = "fr";
      xkbVariant = "bepo";

      # Enable touchpad support with natural scrolling.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      # Use bspwm.
      windowManager.bspwm.enable = true;
      desktopManager.xterm.enable = false;
    };
  };

  systemd.services = {
    # Disable ModemManager to avoid it messing with serial communications.
    modem-manager.enable = false;

    # Currently, we also need to disable this service to avoid ModemManager to
    # be respawn after rebooting.
    "dbus-org.freedesktop.ModemManager1".enable = false;
  };

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  environment.etc = {
    "ranger/rc.conf".source = confkit.file "ranger/rc.conf";
    "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
  };
}
