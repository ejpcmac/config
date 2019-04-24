##
## Home configuration for jpc@nixos-test
##

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  inherit (pkgs) callPackage;
  confkit = import ../../confkit;

  pms = callPackage ../common/pkgs/pms.nix {};
  rocketchat-desktop = callPackage ../common/pkgs/rocketchat-desktop.nix {};

  # Patch Signal-Desktop to use the system tray.
  signal-desktop = pkgs.signal-desktop.overrideAttrs (attrs : rec {
    installPhase = attrs.installPhase + ''
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace \"$out/bin/signal-desktop\" $out/bin/signal-desktop\ --use-tray-icon
    '';
  });

  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
    ];
  };
in

{
  imports = [
    ../common/home.nix
    ../common/bspwm.nix
    ../common/polybar.nix
    ../common/termite.nix
  ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    conky
    pms

    # Applications
    # android-studio
    # riot-desktop
    rocketchat-desktop
    # saleae-logic
    signal-desktop
    vscode
    yubioath-desktop
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  xdg.configFile = {
    "sxhkd/sxhkdrc".source = ../../desktop/sxhkdrc;
    "conky/conky.conf".source = ../../desktop/conky.conf;
    "conky/conky_functions.lua".source = ../../desktop/conky_functions.lua;
    "pms/pms.conf".source = confkit.file "misc/pms_bepo.conf";
    "zathura/zathurarc".source = confkit.file "misc/zathurarc_bepo";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  # Specific Git configuration
  programs.git = {
    # userEmail = mkForce "***";
    signing.signByDefault = mkForce false;
    extraConfig.credential.helper = "store";
  };

  programs.rofi = {
    enable = true;
  };

  # TODO: Update from eft-jpc.
  programs.zsh = {
    # Add nix because auto-completion does not work out of the box on non NixOS
    # or nix-darwin platform for now.
    oh-my-zsh.plugins = [ "nix" ];

    shellAliases = {
      # Commandes fréquentes.
      op = "xdg-open";

      # Emacs
      eds = "systemctl --user start emacs";
      edp = "systemctl --user stop emacs";
      edr = "edp && eds";

      # Restart services
      rc = "systemctl --user restart compton";
      rp = "systemctl --user restart polybar";

      # Configuration Git perso.
      gitp = "git config user.name \"Jean-Philippe Cugnet\" && git config user.email ***";
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  # Compositor for windows transparency.
  services.compton = {
    enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Musique";
    # extraConfig = readFile ./mpd/mpd.conf;
  };
}
