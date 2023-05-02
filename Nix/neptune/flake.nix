{
  description = "The configuration for neptune.";

  inputs = {
    common.url = "git+file:///config?ref=main&dir=Nix/common";

    nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.11";
      inputs = {
        nixpkgs.follows = "common/nixpkgs";
        nixpkgs-22_11.follows = "common/nixpkgs";
      };
    };
  };

  outputs = { self, common, nixos-mailserver, ... }:
    let
      inputs = common // { inherit nixos-mailserver; };
    in
    {
      nixosConfigurations.neptune = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs system; };

        modules = [
          ./configuration.nix

          {
            home-manager.extraSpecialArgs = { inherit inputs system; };
          }
        ];
      };

      # This allows to run `nix build` in the directory to build the configuration.
      defaultPackage.x86_64-linux = self.nixosConfigurations.neptune.config.system.build.toplevel;
    };
}
