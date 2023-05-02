################################################################################
##                                                                            ##
##                       Configuration for workstations                       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) getName mkForce mkIf;

  # Configure Firefox for Tridactyl.
  firefox = pkgs.firefox.override {
    cfg = {
      enableTridactylNative = true;
    };
  };
in

{
  config = mkIf (builtins.elem "workstation" config.confkit.profile.usage) {

    ########################################################################
    ##                              confkit                               ##
    ########################################################################

    confkit = {
      features.fonts.enable = true;
    };

    ########################################################################
    ##                         nixpkgs configuration                      ##
    ########################################################################

    nixpkgs.config = {
      allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
        "veracrypt"
      ];
    };

    ########################################################################
    ##                       General configuration                        ##
    ########################################################################

    users.groups = {
      # Create the plugdev group to allow normal users to use OpenOCD.
      plugdev = { };
    };

    ########################################################################
    ##                             Networking                             ##
    ########################################################################

    networking = {
      networkmanager = {
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      actkbd.enable = mkForce false;
      gnome.gnome-keyring.enable = true;

      emacs = {
        enable = true;
        defaultEditor = true;
      };

      redshift = {
        enable = true;
        temperature = { day = 5500; night = 2800; };
        brightness = { day = "1.0"; night = "1.0"; };
      };

      udev = {
        packages = [
          pkgs.openocd
          # pkgs.libsigrok
        ];

        extraRules = ''
          # Enable TRIM support on JMicron-based enclosures with an incorrect firmware (JMS583, JMS561U).
          ACTION=="add|change", ATTRS{idVendor}=="152d", ATTRS{idProduct}=="0583", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
          ACTION=="add|change", ATTRS{idVendor}=="152d", ATTRS{idProduct}=="1561", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"

          # Ergodox EZ bootloader.
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", TAG+="uaccess"
        '';
      };

      xserver = {
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

    ########################################################################
    ##                               Programs                             ##
    ########################################################################

    programs = {
      dconf.enable = true;
      gnupg.agent = { enable = true; enableSSHSupport = true; };
      ssh.startAgent = false;
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; [
      # Utilities
      betterlockscreen
      pandoc
      pdfpc
      wakelan
      xorg.xev

      # TeXLive can be useful for tools like Pandoc or Org.
      texlive.combined.scheme-full

      # Applications
      drawio
      firefox
      gnome.seahorse
      keepassxc
      libreoffice
      mpv
      pcmanfm
      pqiv
      veracrypt
    ];

    ########################################################################
    ##                               Fonts                                ##
    ########################################################################

    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "DejaVuSansMono" "Noto" ]; })
      fira-code-symbols # Needed to get the ligatures in Emacs.
    ];
  };
}
