##
## Common system configuration
##

{ config, pkgs, ... }:

let
  inherit (pkgs) callPackage runCommand;
  confkit = import ../../confkit;

  keyboardLayout = runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./layout.xkb} $out
  '';
in

{
  imports = with confkit.modules; [
    environment
    nix
    tmux
    zsh
  ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

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

  hardware.u2f.enable = true;

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
    maim
    mkpasswd
    mosh
    mpc_cli
    nix-prefetch-github
    nox
    openssh
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
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    emacs = { enable = true; defaultEditor = true; };
    ntp.enable = true;
    pcscd.enable = true;
    printing.enable = true;

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
