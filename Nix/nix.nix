{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
in

{
   nix = {
    package = pkgs.nix;
    # TODO: Enable on Darwin when it is available.
    useSandbox = if stdenv.isDarwin then false else true;
    buildCores = 0;

    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
    '';

    gc = let gc-common = {
      automatic = true;
      options = "--delete-older-than 30d";
    }; in
    if stdenv.isDarwin then gc-common // {
      interval = { Hour = 21; Minute = 0; };
    } else gc-common // {
      dates = "21:00";
    };
  };
}
