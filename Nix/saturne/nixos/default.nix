################################################################################
##                                                                            ##
##                     NixOS extension module for saturne                     ##
##                                                                            ##
################################################################################

{
  imports = [
    # Common extentions
    ../../common/nixos

    # confkit extensions
    ./modules/confkit/features
    ./modules/confkit/profile
  ];
}
