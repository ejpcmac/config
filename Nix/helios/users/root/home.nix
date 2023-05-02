################################################################################
##                                                                            ##
##                     Home configuration for root@helios                     ##
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
      name = "Helios";
      email = "root@helios";
    };

    programs = {
      git.enable = true;
      zsh.plugins = [ "git" "zfs" ];
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    git.extraConfig.credential.helper = "store";
  };
}
