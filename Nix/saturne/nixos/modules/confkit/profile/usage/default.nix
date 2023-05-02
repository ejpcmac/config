{
  imports = [
    # Custom usages
    ./docked.nix
    ./nomade.nix
  ];

  confkit.extensions = {
    profile.additionalUsages = [ "docked" "nomade" ];
  };
}
