################################################################################
##                                                                            ##
##                     General home configuration for jpc                     ##
##                                                                            ##
################################################################################

{ config, inputs, lib, pkgs, ... }:

let
  libjpc = import ./lib { inherit config lib pkgs; };
  inherit (libjpc) link;

  jpc_overlay = import ../../overlays/jpc_overlay.nix;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "25.05"; # Did you read the comment?

  # Import the confkit home-manager module to get ready-to-use configurations
  # for several tools.
  imports = [ inputs.confkit.nixosModules.confkit-home ];

  # Enable overlays on all hosts.
  nixpkgs.overlays = [
    jpc_overlay
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    keyboard.layout = "bépo";

    identity = {
      name = "Jean-Philippe Cugnet";
      email = "jean-philippe@cugnet.eu";
      gpgKey = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
    };

    programs = {
      dua.enable = true;
      eza.enable = true;
      git.enable = true;

      zsh = {
        enable = true;
        ohMyZsh = true;
        plugins = [
          "aliases"
          "git"
          "nix"
        ];
      };
    };
  };

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # General persistence
    # TODO: Remove when plugins are installed by Nix.
    ".zsh-custom/plugins".source = link "/home/jpc/.persist/zsh-plugins";

    # Create a link to ~/.spacemacs.
    ".spacemacs".source = link "/config/spacemacs/init.el";
  };

  xdg.configFile = {
    # General persistence
    "htop".source = link "/home/jpc/.persist/htop";

    # Install the configuration for tmuxinator.
    "tmuxinator/jpc.yml".source = ./res/tmuxinator_jpc.yml;
  };

  xdg.dataFile = {
    # General persistence
    "ranger".source = link "/home/jpc/.persist/ranger";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    home-manager.enable = true;

    ssh = {
      enable = true;
      userKnownHostsFile = "~/.persist/ssh/known_hosts";
    };

    zsh = {
      history.path = "$HOME/.persist/Histories/zsh_history";

      oh-my-zsh.plugins = [
        "git"
        "git-flow"
        "tmuxinator"
        "zsh-syntax-highlighting"
      ];

      shellAliases = {
        # Helpers to get the current file system.
        fs = "findmnt -n -o SOURCE -T .";
        mnt = "findmnt -n -o TARGET -T .";

        # Base tmux session.
        tmb = "tmuxinator jpc";

        # Get the property of files.
        own = "sudo chown jpc:users";

        # Low-level sysadmin.
        clear-memcache = "sudo sysctl vm.drop_caches=3";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    hwatch
    nmap
    viddy
  ];
}
