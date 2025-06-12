################################################################################
##                                                                            ##
##                     NixOS extension module for saturne                     ##
##                                                                            ##
################################################################################

{
  imports = [
    # Common extensions
    ../../common/nixos

    # confkit extensions
    ./modules/confkit/features
    ./modules/confkit/profile
  ];
}
