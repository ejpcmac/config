################################################################################
##                                                                            ##
##                     General home configuration for jpc                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
  jpc_overlay = import ../../overlays/jpc_overlay.nix;
  mixnix_overlay = import ../../overlays/mixnix_overlay;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "19.09";  # Did you read the comment?

  # Import the confkit home-manager module to get ready-to-use configurations
  # for several tools.
  imports = [ ../../../../confkit/home-manager ];

  nixpkgs.overlays = [
    mixnix_overlay
    jpc_overlay
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################


  confkit = {
    identity = {
      name = "Jean-Philippe Cugnet";
      email = "jean-philippe@cugnet.eu";
      gpgKey = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
    };

    # Use BÉPO-optimised keybindings.
    keyboard.bepo = true;

    git.enable = true;

    zsh = {
      enable = true;
      ohMyZsh = true;
      plugins = [
        "aliases"
        "git"
        "imagemagick"
        "nix"
      ];
    };
  };

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Non-natively handled configuration files
    ".spacemacs".source = ../../../../spacemacs/init.el;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.home-manager = {
    enable = true;
  };

  programs.zsh = {
    oh-my-zsh.plugins = [
      "git"
      "git-flow"
      "tmuxinator"
      "zsh-syntax-highlighting"
    ];

    shellAliases = {
      # Base tmux session.
      tmb = "tmuxinator base";

      # Get the property of files.
      own = "sudo chown jpc:users";

      # Generate quickly clean documents with pandoc.
      pd = "pandoc --number-sections --toc -V geometry:margin=25mm -V fontsize=11pt";
    };
  };

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
  ];
}
