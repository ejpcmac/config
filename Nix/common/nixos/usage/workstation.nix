################################################################################
##                                                                            ##
##                       Configuration for workstations                       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  keyboardLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${../../res/layout.xkb} $out
  '';
in

{
  ############################################################################
  ##                             Kernel modules                             ##
  ############################################################################

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ exfat-nofuse ];
    kernelModules = [ "exfat" ];
  };

  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  hardware = {
    pulseaudio.enable = true;
    u2f.enable = true;
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    networkmanager = {
      enable = true;
      packages = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    emacs = { enable = true; defaultEditor = true; };
    pcscd.enable = true;
    printing.enable = true;

    redshift = {
      enable = true;
      temperature = { day = 5500; night = 2800; };
      brightness = { day = "1.0"; night = "1.0"; };
    };

    udev = {
      packages = [ pkgs.openocd ];
      extraRules = ''
        # Enable TRIM support on JMS583-based enclosures with an incorrect firmware.
        ACTION=="add|change", ATTRS{idVendor}=="152d", ATTRS{idProduct}=="0583", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
      '';
    };

    xserver = {
      enable = true;

      # Configure the keyboard layout.
      layout = "fr";
      xkbVariant = "bepo";
      displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${keyboardLayout} $DISPLAY";

      # Enable touchpad support with natural scrolling.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      # Use LightDM with the Enso greeter as login screen.
      displayManager.lightdm = {
        enable = true;
        greeters.enso.enable = true;
      };

      # Use bspwm.
      windowManager.bspwm.enable = true;

      # Automatically lock the screen after 10 minutes.
      xautolock = {
        enable = true;
        locker = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
        time = 10;
      };
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
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    ssh.startAgent = false;
    wireshark = { enable = true; package = pkgs.wireshark-qt; };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    betterlockscreen
    ntfs3g
    pandoc
    pdfpc
    wakelan
    xorg.xev

    # TeXLive can be useful for tools like Pandoc or Org.
    texlive.combined.scheme-full

    # Applications
    firefox
    keepassx2
    libreoffice
    mpv
    pcmanfm
    pqiv
    veracrypt
  ];

  ############################################################################
  ##                                 Fonts                                  ##
  ############################################################################

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      carlito # Compatible with Calibri.
      fira-code
      inconsolata
      lato
      meslo-lg
      (nerdfonts.override { withFont = "DejaVuSansMono Noto"; })
      opensans-ttf
      symbola
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
}
