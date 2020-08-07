################################################################################
##                                                                            ##
##                 Home configuration for jpc on workstations                 ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;

  beamPackages = pkgs.beam.packages.erlangR22;
  elixir = beamPackages.elixir_1_10;
  erlang = beamPackages.erlang;
  ruby = pkgs.ruby_2_5;
  python = pkgs.python3;
in

{
  imports = [
    # Yet-to-be-published modules.
    ../../common/bspwm.nix
    ../../common/polybar.nix
    ../../common/termite.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    gpg.enable = true;
    pms.enable = true;
    screen.enable = true;
    zathura.enable = true;

    tridactyl = {
      enable = true;
      editor = "${pkgs.emacs}/bin/emacsclient --create-frame";
    };

    zsh.plugins = [
      "ceedling"
      "dev"
      "direnv"
      "docker"
      "elixir"
      "rust"
    ];
  };

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  xdg.configFile = {
    # TODO: Factorise sxhkd configurations and auto-create the link.
    "sxhkd/sxhkdrc_undocked".source = ../../../../../desktop/sxhkdrc_undocked;
    "sxhkd/sxhkdrc_docked".source = ../../../../../desktop/sxhkdrc_docked;
    "conky/conky.conf".source = ../../../../../desktop/conky.conf;
    "conky/conky_functions.lua".source = ../../../../../desktop/conky_functions.lua;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    git.extraConfig.credential.helper = "store";
    rofi.enable = true;

    zsh = {
      oh-my-zsh.plugins = [
        "cargo"
        "docker"
        "elixir"
        "gem"
        "mix"
        "rust"
      ];

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

        # Reload the custom keyoard configuration.
        reload-xkb = "nix-shell -p xorg.xkbcomp --run 'xkbcomp ~/config/Nix/common/res/layout.xkb $DISPLAY'";

        # Make SSH work with termite.
        ssh = "TERM=xterm-256color ssh";

        # Make direnv work correctly with tmux.
        tmux = "direnv exec / tmux";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    bashInteractive
    ceedling
    cloc
    direnv
    dmg2img
    gitAndTools.hub
    gitAndTools.git-sync
    maim
    mixnix
    mpc_cli
    nix-prefetch-github
    nixops
    pass
    pijul
    qrencode
    tokei
    xgen
    zolaUnstable

    # Interpreters for scripts / tools
    elixir
    ruby
    python

    # Desktop environment
    conky
    sxhkd

    # Applications
    meld
    riot-desktop
    tigervnc
    vscodium
    yubioath-desktop
    zeal
  ];
}
