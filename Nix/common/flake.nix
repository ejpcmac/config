{
  description = "Common inputs for all machines.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    confkit.url = "github:ejpcmac/confkit/v0.0.18";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn = {
      url = "git+file:///config/Nix/common/vpn";
      flake = false;
    };
  };

  outputs = inputs: inputs;
}
