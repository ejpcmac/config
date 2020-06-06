################################################################################
##                                                                            ##
##                     Home configuration for jpc@helios                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  confkit = import ../../confkit;
in

{
  imports = [ ../common/jpc_common.nix ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  nixpkgs.config.allowUnfree = true;
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
    # Zsh aliases and environments
    ".zsh/zfs.zsh".source = confkit.file "zsh/zfs.zsh";
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
      # Specific ZFS aliases
      zly = "zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";
      wzly = "watch -n 1 zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot";

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
