################################################################################
##                                                                            ##
##                 Home configuration for jpc on workstations                 ##
##                                                                            ##
################################################################################

{ config, inputs, lib, pkgs, system, ... }:

let
  libjpc = import ../lib { inherit config lib pkgs; };
  inherit (libjpc) link;

  unstable = import inputs.nixpkgs-unstable { inherit system; };
  confkit-channel = inputs.confkit.lib.channel;

  emacs = pkgs.emacs30.override { withNativeCompilation = false; };
  git = pkgs.git.override { withLibsecret = true; };
  git-z = inputs.git-z.packages.${system}.git-z;
in

{
  imports = [
    # Yet-to-be-published modules.
    ../../common/bspwm.nix
    ../../common/rofi.nix
    ../../common/termite.nix
    ../../common/xsettingsd.nix

    # Features enabled on every workstation.
    ../features/vscode.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    services = {
      polybar.enable = true;
    };

    programs = {
      gpg.enable = true;
      screen.enable = true;
      zathura.enable = true;

      tridactyl = {
        enable = true;
        editor = "${emacs}/bin/emacsclient --create-frame";
      };

      zsh.plugins = [
        "dev"
        "direnv"
        "docker"
        "elixir"
        "imagemagick"
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
    ".password-store".source = link "/home/jpc/.persist/pass";
    ".ykman".source = link "/home/jpc/.persist/Yubico";

    # Make Tridactyl native work with the persistence.
    ".persist/Firefox/native-messaging-hosts" = {
      recursive = true;
      source =
        let
          nativeMessagingHosts = [ pkgs.tridactyl-native ];
        in
        pkgs.runCommandLocal "native-messaging-hosts" { } ''
          mkdir $out
          for ext in ${toString nativeMessagingHosts}; do
              ln -sLt $out $ext/lib/mozilla/native-messaging-hosts/*
          done
        '';
    };

    # Persistence for the Informatique module
    ".cargo".source = link "/home/jpc/.persist/Informatique/cargo";
    ".gradle".source = link "/home/jpc/.persist/Informatique/gradle";
    ".hex".source = link "/home/jpc/.persist/Informatique/hex";
    ".mix".source = link "/home/jpc/.persist/Informatique/mix";
    ".nerves".source = link "/home/jpc/.persist/Informatique/nerves";
    ".npm".source = link "/home/jpc/.persist/Informatique/npm";
    ".stack".source = link "/home/jpc/.persist/Informatique/stack";

    # Work in progress Jujutsu support in Zsh.
    ".zsh/jujutsu.zsh".source =
      link "/config/Nix/common/home-manager/jpc/zsh/jujutsu.zsh";
    ".zsh-custom/themes/bazik+jj.zsh-theme".source =
      link "/config/Nix/common/home-manager/jpc/zsh/bazik+jj.zsh-theme";

    # Custom configuration
    ".xgen.exs".source = ../res/xgen.exs;

    # Scripts
    ".local/bin/preview-update".source = ../../../scripts/preview-update;
  };

  xdg.configFile = {
    # General persistence
    "Element".source = link "/home/jpc/.persist/Element";

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
  };

  xdg.dataFile = {
    # General persistence
    "direnv".source = link "/home/jpc/.persist/direnv";
    "keyrings".source = link "/home/jpc/.persist/keyrings";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    emacs = {
      enable = true;
      defaultEditor = true;
    };

    dunst = {
      enable = true;

      settings = {
        global = {
          follow = "keyboard";
        };
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    direnv = { enable = true; nix-direnv.enable = true; };
    emacs = { enable = true; package = emacs; };

    git = {
      extraConfig = {
        credential.helper = "${git}/bin/git-credential-libsecret";
      };

      ignores = [
        ".Trash-*/"
        ".direnv/"
      ];
    };

    jujutsu = {
      enable = true;
      package = unstable.jujutsu;

      settings = {
        user = {
          name = "Jean-Philippe Cugnet";
          email = "jean-philippe@cugnet.eu";
        };

        signing = {
          behavior = "drop";
          backend = "gpg";
          key = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
        };

        git = {
          sign-on-push = true;
          write-change-id-header = true;
        };

        ui = {
          default-command = [
            "log"
            "--no-pager"
            "--config"
            "ui.show-cryptographic-signatures=true"
          ];

          diff-formatter = "difft";
          editor = "codium --wait";
          merge-editor = "vscodium";
        };

        templates = {
          log = "log_oneline";
        };

        template-aliases = {
          log_oneline = ''
            if(root,
              format_root_commit(self),
              label(if(current_working_copy, "working_copy"),
                concat(
                  separate(" ",
                    format_short_change_id_with_hidden_and_divergent_info(self),
                    author.name(),
                    format_timestamp(commit_timestamp(self)),
                    bookmarks,
                    tags,
                    working_copies,
                    if(git_head, label("git_head", "git_head()")),
                    format_short_commit_id(commit_id),
                    if(conflict, label("conflict", "conflict")),
                    if(config("ui.show-cryptographic-signatures").as_boolean(),
                      format_short_cryptographic_signature(signature)),
                    if(empty, label("empty", "(empty)")),
                    if(description,
                      description.first_line(),
                      label(if(empty, "empty"), description_placeholder),
                    ),
                  ) ++ "\n",
                ),
              )
            )
          '';
        };
      };
    };

    zsh = {
      oh-my-zsh = {
        theme = "bazik+jj";

        plugins = [
          "docker"
          "elixir"
          "mix"
          "rust"
        ];
      };

      shellAliases = {
        # General aliases
        op = "xdg-open";
        mkp = "mount-keepass";

        # Restart services
        eds = "systemctl --user start emacs";
        edp = "systemctl --user stop emacs";
        edr = "edp && eds";
        ost = "sudo systemctl start ollama";
        osp = "sudo systemctl stop ollama";
        osr = "osp && ost";
        rc = "systemctl --user restart compton";
        rp = "systemctl --user restart polybar";

        # Aliases for update aliases.
        uca = "update-common-all";
        ucc = "update-confkit";
        uha = "update-host-all";
        uhc = "update-host-common";

        # Update the system flakes.
        update-common-all = "(cd /config/Nix/common && nix flake update)";
        update-confkit = "(cd /config/Nix/common && nix flake update confkit)";
        update-host-all = "(cd /config/Nix/$HOST && nix flake update)";
        update-host-common = "(cd /config/Nix/$HOST && nix flake update common)";

        confkit-live = ''
          sed -e "s|github:ejpcmac/confkit/${confkit-channel}|git+file:///config/confkit|" \
              -i /config/Nix/common/flake.nix && \
          update-confkit && \
          update-host-common \
        '';

        confkit-snors = ''
          update-confkit && \
          update-host-common && \
          snors \
        '';

        confkit-rollback = ''
          sed -e "s|git+file:///config/confkit|github:ejpcmac/confkit/${confkit-channel}|" \
              -i /config/Nix/common/flake.nix && \
          update-confkit && \
          update-host-common \
        '';

        confkit-commit = ''
          sed -e "s|git+file:///config/confkit|github:ejpcmac/confkit/${confkit-channel}|" \
              -i /config/Nix/common/flake.nix && \
          update-confkit && \
          (cd /config && git add confkit Nix/common/flake.*) && \
          (cd /config && git commit -m "deps(common): update confkit") && \
          update-host-common && \
          (cd /config && git add Nix/$HOST/flake.lock) && \
          (cd /config && git commit -m "deps($HOST): update common (confkit)") \
        '';

        # Preview the update on the current host.
        preview-update-host = "preview-update $HOST";
        preview-merge-host = ''
          nix store diff-closures \
              --derivation \
              "git+file:///config?dir=Nix/$HOST&ref=main" \
              "git+file:///config?dir=Nix/$HOST&ref=origin/main"
        '';

        preview-current-host = ''
          nix store diff-closures \
              --derivation \
              "git+file:///config?dir=Nix/$HOST&ref=HEAD" \
              "git+file:///config?dir=Nix/$HOST"
        '';

        diff-current-host = ''
          nix store diff-closures \
              "git+file:///config?dir=Nix/$HOST&ref=HEAD" \
              "git+file:///config?dir=Nix/$HOST"
        '';

        # Reload the custom keyoard configuration.
        reload-xkb = ''
          ${pkgs.xorg.xkbcomp}/bin/xkbcomp \
            /config/Nix/common/res/layout.xkb \
            $DISPLAY
        '';

        # Project filesystem handling.
        zc-ash = "zc-elixir && zcc db";
        zc-elixir = "zccnb _build && zccnb deps && zccnb .elixir_ls";
        zc-rust = "zccnb target";

        # Make SSH work with termite.
        ssh = "TERM=xterm-256color ssh";

        # Make direnv work correctly with tmux.
        tmux = "direnv exec / tmux";

        # Make git and hub subcommands that need Emacs still work in Nix shells.
        git = "TMPDIR=/tmp git";
        hub = "TMPDIR=/tmp hub";
      };

      initContent = ''
        zgcl() {
          if [ $# -ne 1 ]; then
            echo "usage: zgcl <repo-url>"
            return 1
          fi

          local repo=$1
          local name=$(basename --suffix=.git $repo)

          zfs-create-current $name &&
          git clone --recurse-submodules $repo $name
        }

        zgclg() {
          if [ $# -ne 2 ]; then
            echo "usage: zgclg <repo-url> <branch>"
            return 1
          fi

          local repo=$1
          local branch=$2
          local name=$(basename --suffix=.git $repo)

          zfs-create-current $name &&
          zfs-create-current $name/.git &&
          pushd $name &&
          git init &&
          git remote add origin $repo &&
          git fetch &&
          git checkout -t origin/$branch &&
          git submodule init &&
          git submodule update &&
          popd
        }

        zgclw() {
          if [ $# -ne 2 ]; then
            echo "usage: zgclw <repo-url> <branch>"
            return 1
          fi

          local repo=$1
          local branch=$2
          local name=$(basename --suffix=.git $repo)

          zfs-create-current -o canmount=off $name
          zfs-create-current $name/$branch &&
          zfs-create-current $name/$branch/.git &&
          pushd $name/$branch &&
          git init &&
          git remote add origin $repo &&
          git fetch &&
          git checkout -t origin/$branch &&
          git submodule init &&
          git submodule update &&
          popd
        }

        zgwa() {
          local worktree=$(basename $1)

          pushd ..
          zfs-create-current $worktree
          popd
          git worktree add $@
        }

        zgwr() {
          local worktree=$(basename $1)

          pushd ..
          zfs-destroy-current $worktree
          popd
          git worktree prune
        }

        archive() {
          if [ $# -ne 1 ]; then
            echo "usage: archive <project>"
            return 1
          fi

          zfs-rename-current $1 _Archives/$1
        }

        unarchive() {
          if [ $# -ne 1 ]; then
            echo "usage: unarchive <project>"
            return 1
          fi

          zfs-rename-current _Archives/$1 $1
        }

        # TODO: Remove when the project migration is over.
        migrate-repo() {
          if [ $# -ne 2 ]; then
            echo "usage: migrate-repo <repo> <project>"
            return 1
          fi

          local repo=$1
          local project=$2

          pushd ~/Projets/$project &&
          zfs-create-current $repo &&
          popd &&
          rsync -a --progress $repo/ ~/Projets/$project/$repo/ &&
          rm -rf $repo
        }
      '';
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    cargo-generate
    cloc
    diceware
    emacs.pkgs.mu4e
    unstable.gg-jj
    gh
    git-z
    gitAndTools.git-sync
    gitAndTools.gitflow
    nixpkgs-24_11.mu
    # nix-linter
    nix-tree
    openssl
    pass
    pdfpc
    qemu
    quickemu
    statix
    tokei
    wakelan
    xorg.xev

    # Desktop environment
    alsa-utils
    maim
    sxhkd
    xclip
    xdotool

    # Interpreters for scripts / tools
    elixir
    python3

    # Applications
    element-desktop
    firefox
    keepassxc
    libreoffice
    meld
    mpv
    pavucontrol
    pcmanfm
    pqiv
    seahorse
    teams-for-linux
  ];
}
