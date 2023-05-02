################################################################################
##                                                                            ##
##                     Home configuration for jpc@helios                      ##
##                                                                            ##
################################################################################

{ pkgs, ... }:

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/backup-ceres".source = ./scripts/backup-ceres;
    ".local/bin/backup-ejpcmac.net".source = ./scripts/backup-ejpcmac.net;
    ".local/bin/clean-binary-cache".source = ./scripts/clean-binary-cache;
    ".local/bin/music".source = ./scripts/music;
    ".local/bin/nix-add-store-paths".source = ./scripts/nix-add-store-paths;
    ".local/bin/nix-build-cache".source = ./scripts/nix-build-cache;
    ".local/bin/nix-mirror-channel".source = ./scripts/nix-mirror-channel;
    ".local/bin/prepare-op-mirror".source = ./scripts/prepare-op-mirror;
    ".local/bin/start-drives-fans".source = ./scripts/start-drives-fans;
    ".local/bin/zfs-clean-snapshots".source = ../../../common/scripts/zfs-clean-snapshots;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    git.extraConfig.credential.helper = "store";

    zsh = {
      shellAliases = {
        # Emacs
        eds = "systemctl --user start emacs";
        edp = "systemctl --user stop emacs";
        edr = "edp && eds";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    browsh
    firefox
  ];
}
