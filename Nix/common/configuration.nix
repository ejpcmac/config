################################################################################
##                                                                            ##
##                        Common system configuration                         ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (pkgs) runCommand;
  confkit = import ../../confkit;
  jpc_overlay = import ./overlays/jpc_overlay.nix;

  keyboardLayout = runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./layout.xkb} $out
  '';
in

{
  imports = with confkit.modules; [
    # Confkit modules
    environment
    nix
    tmux
    utilities
    zsh
  ];

  nixpkgs.overlays = [ jpc_overlay ];

  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  hardware = {
    brightnessctl.enable = true;
    pulseaudio.enable = true;
    u2f.enable = true;
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  time.timeZone = "Indian/Kerguelen";

  location = {
    latitude = -49.35;
    longitude = 70.22;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr-bepo";
    defaultLocale = "fr_FR.UTF-8";
  };

  ############################################################################
  ##                              Environment                               ##
  ############################################################################

  environment.variables = {
    # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

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

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    betterlockscreen
    dmg2img
    lm_sensors
    maim
    mpc_cli
    nix-prefetch-github
    ntfs3g
    openssl
    pandoc
    pdfpc
    pv
    pythonPackages.glances
    wakelan
    xorg.xev

    # TeXLive can be useful for tools like Pandoc or Org.
    texlive.combined.scheme-full

    # Desktop environment
    sxhkd

    # Applications
    keepassx2
    libreoffice
    mpv
    pcmanfm
    pqiv
    riot-desktop
    veracrypt
    zathura
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    ssh.startAgent = false;
    tmux.useBepoKeybindings = true;
    wireshark = { enable = true; package = pkgs.wireshark-qt; };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    emacs = { enable = true; defaultEditor = true; };
    pcscd.enable = true;
    printing.enable = true;

    ntp = {
      enable = true;
      servers = [ "time2.kerguelen.ipev.fr" "time.kerguene.ipev.fr" ];
    };

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
  ##                          Custom configuration                          ##
  ############################################################################

  environment.etc = {
    "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
    "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
  };
}
