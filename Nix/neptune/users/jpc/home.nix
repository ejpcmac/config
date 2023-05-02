################################################################################
##                                                                            ##
##                      Home configuration for jpc@neptune                    ##
##                                                                            ##
################################################################################

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    git.extraConfig.credential.helper = "store";
  };
}
