################################################################################
##                                                                            ##
##                         Common home configuration                          ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
  confkit = import ../../confkit;
  jpc_overlay = import ./overlays/jpc_overlay.nix;
  mixnix_overlay = import ./overlays/mixnix_overlay;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "19.09";  # Did you read the comment?

  imports = with confkit.modules; [ git ];

  nixpkgs.overlays = [
    mixnix_overlay
    jpc_overlay
  ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Build platforms
    mixnix-platform

    # Utilities
    diceware
    mu
    nmap

    # Repositories mirroring tools
    apt-mirror
    mini_repo
    rustup-mirror
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = confkit.file "zsh/aliases.zsh";
    ".zsh/git.zsh".source = confkit.file "zsh/git.zsh";
    ".zsh/imagemagick.zsh".source = confkit.file "zsh/imagemagick.zsh";
    ".zsh/nix.zsh".source = confkit.file "zsh/nix.zsh";

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = confkit.file "zsh/themes/bazik.zsh-theme";

    # Non-natively handled configuration files
    ".spacemacs".source = ../../spacemacs/init.el;

    ".gnupg/gpg.conf".text = ''
        default-key C350CCB299D730FDAF8C5B7AE847B871DADD49DF
      '' + readFile (confkit.file "misc/gpg.conf");
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
        "git"
        "git-flow"
        "nix-shell"
        "sudo"
        "tmuxinator"
        "zsh-syntax-highlighting"
      ];
    };

    shellAliases = {
      # Base tmux session.
      tmb = "tmuxinator base";

      # Get the property of files.
      own = "sudo chown jpc:users";

      # Generate quickly clean documents with pandoc.
      pd = "pandoc --number-sections --toc -V geometry:margin=25mm -V fontsize=11pt";
    };
  };
}
