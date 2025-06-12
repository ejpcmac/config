{
  imports = [
    # Custom types
    ./monitors-intel.nix
    ./monitors-intel-gpu.nix
    ./monitors-nvidia.nix
  ];

  confkit.extensions = {
    profile.additionalTypes = [
      "monitors-intel"
      "monitors-intel+gpu"
      "monitors-nvidia"
    ];
  };
}
