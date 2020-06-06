self: super:

let
  inherit (super) callPackage;
in

rec {
  mixnix-platform = callPackage ./mixnix-platform.nix {};
  mix2nix = callPackage "${mixnix-platform}/nix/mix2nix.nix" {};
  mixnix = mix2nix.mix2nix;
}
