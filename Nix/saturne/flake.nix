{
  description = "The configuration for saturne.";

  inputs = {
    common.url = "path:../common";
    nixpkgs-20_03.url = "github:NixOS/nixpkgs/nixos-20.03";
    track.url = "github:ejpcmac/track";
  };

  outputs = { self, common, ... }@local:
    let
      inputs = common // { inherit (local) nixpkgs-20_03 daedalus track; };
    in
    {
      nixosConfigurations.saturne = inputs.nixpkgs.lib.nixosSystem rec {
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
      defaultPackage.x86_64-linux = self.nixosConfigurations.saturne.config.system.build.toplevel;
    };
}
