{
  imports = [
    # Extensions for existing usages
    ./server.nix
    ./workstation.nix

    # Custom usages
    ./home.nix
  ];

  confkit.extensions = {
    profile.additionalUsages = [ "home" ];
  };
}
