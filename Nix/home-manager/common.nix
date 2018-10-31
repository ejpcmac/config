{ config, pkgs, ... }:

let
  inherit (pkgs) callPackage stdenv lib beam;

  ceedling = callPackage ./pkgs/ceedling.nix {};
  elixir = beam.packages.erlangR21.elixir_1_7;
  erlang = beam.interpreters.erlangR21;
  ruby = pkgs.ruby_2_5;
in

{
  home.packages = with pkgs; [
    aspcud
    aspell
    bashInteractive
    ceedling
    cloc
    direnv
    iftop
    nmap
    p7zip
    qrencode
    screen
    tmuxinator

    elixir
    erlang
    ruby
  ];

  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = ../../zsh/aliases.zsh;
    ".zsh/ceedling.zsh".source = ../../zsh/ceedling.zsh;
    ".zsh/direnv.zsh".source = ../../zsh/direnv.zsh;
    ".zsh/docker.zsh".source = ../../zsh/docker.zsh;
    ".zsh/elixir.zsh".source = ../../zsh/elixir.zsh;
    ".zsh/git.zsh".source = ../../zsh/git.zsh;
    ".zsh/nix.zsh".source = ../../zsh/nix.zsh;
    ".zsh/ocaml.zsh".source = ../../zsh/ocaml.zsh;
    ".zsh/rust.zsh".source = ../../zsh/rust.zsh;

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = ../../zsh/themes/bazik.zsh-theme;

    # Non-natively handled configuration files
    ".gnupg/gpg.conf".source = ../../gpg.conf;
    ".screenrc".source = ../../screenrc;
  };

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };

  programs.git = {
    enable = true;

    userName = "Jean-Philippe Cugnet";
    userEmail = "***";

    signing = {
      gpgPath = "gpg2";
      key = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
      signByDefault = true;
    };

    extraConfig = {
      merge.ff = false;
      pull.rebase = "preserve";
      mergetool.keepBackup = false;

      "gitflow \"feature.finish\"".no-ff = true;
      "gitflow \"release.finish\"".sign = true;
      "gitflow \"hotfix.finish\"".sign = true;

      "filter \"lfs\"" = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
      };
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zsh/init.zsh;

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/.zsh-custom";
      theme = "bazik";

      plugins = [
        "cargo"
        "docker"
        "elixir"
        "gem"
        "git"
        "git-flow"
        "mix"
        "nix-shell"
        "rust"
        "sudo"
        "tmuxinator"
        "zsh-syntax-highlighting"
      ];
    };

    shellAliases = {
      tmux = "direnv exec / tmux";
    };
  };
}
