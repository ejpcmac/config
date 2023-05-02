################################################################################
##                                                                            ##
##                 Home configuration for jpc on workstations                 ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  libjpc = pkgs.callPackage ../lib { };
  inherit (libjpc) link;

  git = pkgs.git.override { withLibsecret = true; };
  beamPackages = pkgs.beam.packages.erlangR24;
  erlang = beamPackages.erlang;
  elixir = beamPackages.elixir_latest;
  ruby = pkgs.ruby_3_0;
  python = pkgs.python3;
in

{
  imports = [
    # Yet-to-be-published modules.
    ../../common/bspwm.nix
    ../../common/polybar.nix
    ../../common/rofi.nix
    ../../common/termite.nix
    ../../common/xsettingsd.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    programs = {
      gpg.enable = true;
      screen.enable = true;
      zathura.enable = true;

      tridactyl = {
        enable = true;
        editor = "${pkgs.emacs}/bin/emacsclient --create-frame";
      };

      zsh.plugins = [
        "dev"
        "direnv"
        "docker"
        "elixir"
        "rust"
      ];
    };
  };

  ############################################################################
  ##                         nixpkgs configuration                          ##
  ############################################################################

  # FIXME: Wy do we need this?
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "font-bh-lucidatypewriter"
  ];

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # General persistence
    ".emacs.d".source = link "/home/jpc/.persist/Emacs";
    ".mozilla".source = link "/home/jpc/.persist/Firefox";
    ".nixops".source = link "/home/jpc/.persist/NixOps";
    ".password-store".source = link "/home/jpc/.persist/pass";
    ".vscode-oss".source = link "/home/jpc/.persist/VSCodium/extensions";
    ".ykman".source = link "/home/jpc/.persist/Yubico";

    # Persistence for the Informatique module
    ".cargo".source = link "/home/jpc/.persist/Informatique/cargo";
    ".hex".source = link "/home/jpc/.persist/Informatique/hex";
    ".mix".source = link "/home/jpc/.persist/Informatique/mix";
    ".nerves".source = link "/home/jpc/.persist/Informatique/nerves";
    ".npm".source = link "/home/jpc/.persist/Informatique/npm";
    ".rustup".source = link "/home/jpc/.persist/Informatique/rustup";
    ".stack".source = link "/home/jpc/.persist/Informatique/stack";
    "go".source = link "/home/jpc/.persist/Informatique/go";

    # Create links for the VSCodium configuration.
    ".persist/VSCodium/config/User/settings.json".source = link "/config/vscode/settings.json";
    ".persist/VSCodium/config/User/keybindings.json".source = link "/config/vscode/keybindings.json";
    ".persist/VSCodium/config/User/snippets".source = link "/config/vscode/snippets";

    # Custom configuration
    ".ssh/id_rsa.pub".source = ../../../res/ssh_keys/yubikey4.pub;
    ".xgen.exs".source = ../res/xgen.exs;

    # Scripts
    ".local/bin/mount-keepass".source = ../../../scripts/mount-keepass;
  };

  xdg.configFile = {
    # General persistence
    "Element".source = link "/home/jpc/.persist/Element";
    "VSCodium".source = link "/home/jpc/.persist/VSCodium/config";

    # Create links for the nixpkgs overlays.
    "nixpkgs/overlays/jpc_overlay.nix".source = link "/config/Nix/common/overlays/jpc_overlay.nix";

    # TODO: Factorise sxhkd configurations and auto-create the link.
    "sxhkd/sxhkdrc_docked".source = ../../../../../desktop/sxhkdrc_docked;
    "sxhkd/sxhkdrc_undocked" = {
      source = ../../../../../desktop/sxhkdrc_undocked;

      # Automatically create the link if it does not exist.
      onChange = ''
        config=$HOME/.config/sxhkd/sxhkdrc
        if [ ! -f $config ]; then
            ln -sf sxhkdrc_undocked $config
        fi
      '';
    };

    "conky/conky.conf".source = ../../../../../desktop/conky.conf;
    "conky/conky_functions.lua".source = ../../../../../desktop/conky_functions.lua;
  };

  xdg.dataFile = {
    # General persistence
    "direnv".source = link "/home/jpc/.persist/direnv";
    "keyrings".source = link "/home/jpc/.persist/keyrings";

    # Persistence for the Informatique module
    "Zeal".source = link "/home/jpc/.persist/Informatique/Zeal";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    direnv = { enable = true; nix-direnv.enable = true; };
    git.extraConfig.credential.helper = "${git}/bin/git-credential-libsecret";

    zsh = {
      oh-my-zsh.plugins = [
        "docker"
        "elixir"
        "gem"
        "mix"
        "rust"
      ];

      shellAliases = {
        update-common-all = "(cd /config/Nix/common && nix flake update)";
        update-confkit = "(cd /config/Nix/common && nix flake lock --update-input confkit)";
        update-host-all = "(cd /config/Nix/$HOST && nix flake update)";
        update-host-common = "(cd /config/Nix/$HOST && nix flake lock --update-input common)";

        # Commandes fréquentes.
        op = "xdg-open";

        # Open the configuration using VSCodium.
        oc = "codium /config";

        # Emacs
        eds = "systemctl --user start emacs";
        edp = "systemctl --user stop emacs";
        edr = "edp && eds";

        # Restart services
        rc = "systemctl --user restart compton";
        rp = "systemctl --user restart polybar";

        # Reload the custom keyoard configuration.
        reload-xkb = ''
          ${pkgs.xorg.xkbcomp}/bin/xkbcomp \
            /config/Nix/common/res/layout.xkb \
            $DISPLAY
        '';

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
    cargo-generate
    cloc
    gitAndTools.gitflow
    gitAndTools.git-sync
    maim
    nil
    nix-linter
    nix-tree
    nixpkgs-fmt
    pass
    pavucontrol
    statix
    xclip

    # Interpreters for scripts / tools
    erlang
    elixir
    ruby
    python

    # Desktop environment
    sxhkd
    xdotool

    # Applications
    meld
    # pulseview
    # tigervnc
    vscodium
  ];
}
