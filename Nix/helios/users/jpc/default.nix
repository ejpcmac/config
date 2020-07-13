################################################################################
##                                                                            ##
##                     Home configuration for jpc@helios                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  confkit = import ../../../../confkit;
in

{
  imports = [
    ../../../common/users/jpc/general.nix
    ../../../common/users/jpc/features/repo-mirroring.nix
    ../../../common/users/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    browsh
    firefox
    pms

    # Repositories mirroring tools
    cargo-cacher
  ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/clean-binary-cache".source = ./scripts/clean-binary-cache;
    ".local/bin/nix-add-store-paths".source = ./scripts/nix-add-store-paths;
    ".local/bin/nix-build-cache".source = ./scripts/nix-build-cache;
    ".local/bin/nix-mirror-channel".source = ./scripts/nix-mirror-channel;
    ".local/bin/prepare-op-mirror".source = ./scripts/prepare-op-mirror;
  };

  xdg.configFile = {
    "pms/pms.conf".source = confkit.file "misc/pms_bepo.conf";
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  # Specific Git configuration
  programs.git = {
    signing.signByDefault = mkForce false;
    extraConfig.credential.helper = "store";
  };

  programs.zsh = {
    shellAliases = {
      # Emacs
      eds = "systemctl --user start emacs";
      edp = "systemctl --user stop emacs";
      edr = "edp && eds";

      # Mirrors
      sync-crates = ''
        cargo-cacher -dd --all \
            --index /data/Mirroirs/crates.io \
            --api http://crates.saturne \
            --dl http://crates.saturne/crates
      '';
    };
  };
}
