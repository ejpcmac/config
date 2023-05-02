################################################################################
##                                                                            ##
##                    Home configuration for root@neptune                     ##
##                                                                            ##
################################################################################

{ inputs, ... }:

{
  # Base on the root home configuration from confkit.
  imports = [ inputs.confkit.nixosModules.home-config-root ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    identity = {
      name = "Neptune";
      email = "***[ REDACTED ]***";
    };

    programs = {
      git.enable = true;
      zsh.plugins = [ "git" "zfs" ];
    };
  };

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/zfs-clean-snapshots".source = ../../../common/scripts/zfs-clean-snapshots;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    git.extraConfig.credential.helper = "store";
  };
}
