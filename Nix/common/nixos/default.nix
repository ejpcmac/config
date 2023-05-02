################################################################################
##                                                                            ##
##                      Personal NixOS extension module                       ##
##                                                                            ##
################################################################################

{
  imports = [
    # Always-on configuration
    ./general.nix

    # confkit extensions
    ./modules/confkit/profile
    ./modules/confkit/location
    ./modules/confkit/features

    # NixOS extensions
    ./modules/services
  ];
}
