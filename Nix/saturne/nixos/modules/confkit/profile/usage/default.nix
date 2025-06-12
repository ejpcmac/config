{
  imports = [
    # Custom usages
    ./docked.nix
    ./undocked.nix
  ];

  confkit.extensions = {
    profile.additionalUsages = [ "docked" "undocked" ];
  };
}
