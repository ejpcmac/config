################################################################################
##                                                                            ##
##                       Configuration for workstations                       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce mkIf;
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
      adb.enable = true;
      dconf.enable = true;
      gnupg.agent = { enable = true; enableSSHSupport = true; };
      i3lock = { enable = true; package = pkgs.betterlockscreen; };
      ssh.startAgent = false;
    };

    ########################################################################
    ##                               Fonts                                ##
    ########################################################################

    fonts.packages = with pkgs; [
      fira-code-symbols # Needed to get the ligatures in Emacs.
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.noto
      roboto-mono
    ];
  };
}
