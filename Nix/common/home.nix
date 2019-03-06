##
## Common home configuration
##

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (pkgs) callPackage beam;
  confkit = import ../../confkit;

  ceedling = callPackage ./pkgs/ceedling.nix {};
  elixir = beam.packages.erlangR21.elixir_1_8;
  erlang = beam.interpreters.erlangR21;
  ruby = pkgs.ruby_2_5;
  python = pkgs.python3;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "18.09";  # Did you read the comment?

  imports = with confkit.modules; [ git ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    bashInteractive
    ceedling
    cloc
    direnv
    nmap
    p7zip
    qrencode
    screen
    screenfetch
    tmuxinator
    # TODO: Enable when it builds on macOS.
    # tokei

    # Interpreters for scripts / tools.
    elixir
    erlang
    ruby
    python
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = confkit.file "zsh/aliases.zsh";
    ".zsh/ceedling.zsh".source = confkit.file "zsh/ceedling.zsh";
    ".zsh/dev.zsh".source = confkit.file "zsh/dev.zsh";
    ".zsh/direnv.zsh".source = confkit.file "zsh/direnv.zsh";
    ".zsh/docker.zsh".source = confkit.file "zsh/docker.zsh";
    ".zsh/elixir.zsh".source = confkit.file "zsh/elixir.zsh";
    ".zsh/git.zsh".source = confkit.file "zsh/git.zsh";
    ".zsh/imagemagick.zsh".source = confkit.file "zsh/imagemagick.zsh";
    ".zsh/nix.zsh".source = confkit.file "zsh/nix.zsh";
    ".zsh/rust.zsh".source = confkit.file "zsh/rust.zsh";

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = confkit.file "zsh/themes/bazik.zsh-theme";

    # Non-natively handled configuration files
    ".spacemacs".source = ../../spacemacs/init.el;
    ".screenrc".source = confkit.file "misc/screenrc";

    ".gnupg/gpg.conf".text = ''
        default-key C350CCB299D730FDAF8C5B7AE847B871DADD49DF
      '' + readFile (confkit.file "misc/gpg.conf");
  };

  xdg.configFile = {
    "tridactyl/tridactylrc".text =
      readFile (confkit.file "misc/tridactylrc_bepo")
      + "\nset editorcmd ${pkgs.emacs}/bin/emacsclient --create-frame";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    userName = "Jean-Philippe Cugnet";
    userEmail = "***";
    signing.key = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
  };

  programs.zsh = {
    enable = true;
    initExtra = readFile (confkit.file "zsh/config/home_init.zsh");

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
      # Make direnv work correctly with tmux.
      tmux = "direnv exec / tmux";

      # Base tmux session.
      tmb = "tmuxinator base";

      # Help command
      aider = "ssh aide@ejpcmac.net -L 7000:localhost:7000";
    };
  };
}
