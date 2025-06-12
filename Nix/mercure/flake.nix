{
  description = "The configuration for mercure.";

  inputs = {
    common.url = "path:../common";
  };

  outputs = { self, common, ... }:
    let
      inputs = common;
    in
    {
      nixosConfigurations.mercure = inputs.nixpkgs.lib.nixosSystem rec {
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
      defaultPackage.x86_64-linux = self.nixosConfigurations.mercure.config.system.build.toplevel;
    };
}
