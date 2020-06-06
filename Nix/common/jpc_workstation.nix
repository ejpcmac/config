################################################################################
##                                                                            ##
##                   Common workstation home configuration                    ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
  confkit = import ../../confkit;

  # vscode = pkgs.vscode-with-extensions.override {
  #   vscodeExtensions = with pkgs.vscode-extensions; [
  #     ms-vscode.cpptools
  #   ];
  # };

  beamPackages = pkgs.beam.packages.erlangR22;
  elixir = beamPackages.elixir_1_10;
  erlang = beamPackages.erlang;
  ruby = pkgs.ruby_2_5;
  python = pkgs.python3;
in

{
  imports = [
    # Common configuration between all hosts.
    ./jpc_common.nix

    # Yet-to-be-published modules.
    ../common/bspwm.nix
    ../common/polybar.nix
    ../common/termite.nix
  ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Utilities
    bashInteractive
    ceedling
    cloc
    direnv
    gitAndTools.hub
    gitAndTools.git-sync
    mixnix
    nixops
    pass
    pms
    qrencode
    screen
    tokei
    xgen
    zolaUnstable

    # Interpreters for scripts / tools
    elixir
    ruby
    python

    # Desktop environment
    conky

    # Applications
    meld
    vscode
    yubioath-desktop
    zeal
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Zsh aliases and environments
    ".zsh/ceedling.zsh".source = confkit.file "zsh/ceedling.zsh";
    ".zsh/dev.zsh".source = confkit.file "zsh/dev.zsh";
    ".zsh/direnv.zsh".source = confkit.file "zsh/direnv.zsh";
    ".zsh/docker.zsh".source = confkit.file "zsh/docker.zsh";
    ".zsh/elixir.zsh".source = confkit.file "zsh/elixir.zsh";
    ".zsh/rust.zsh".source = confkit.file "zsh/rust.zsh";

    # Non-natively handled configuration files
    ".screenrc".source = confkit.file "misc/screenrc";
  };

  xdg.configFile = {
    "zathura/zathurarc".source = confkit.file "misc/zathurarc_bepo";
    "tridactyl/tridactylrc".text =
      readFile (confkit.file "misc/tridactylrc_bepo")
      + "\nset editorcmd ${pkgs.emacs}/bin/emacsclient --create-frame";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.git = {
    extraConfig.credential.helper = "store";
  };

  programs.rofi = {
    enable = true;
  };

  programs.zsh = {
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

      # WiFi toggle.
      won = "nmcli radio wifi on";
      woff = "nmcli radio wifi off";

      # Emacs
      eds = "systemctl --user start emacs";
      edp = "systemctl --user stop emacs";
      edr = "edp && eds";

      # Restart services
      rc = "systemctl --user restart compton";
      rp = "systemctl --user restart polybar";

      # Reload the custom keyoard configuration.
      reload-xkb = "nix-shell -p xorg.xkbcomp --run 'xkbcomp ~/config/Nix/common/layout.xkb $DISPLAY'";

      # Make SSH work with termite.
      ssh = "TERM=xterm-256color ssh";

      # Make direnv work correctly with tmux.
      tmux = "direnv exec / tmux";
    };
  };
}
