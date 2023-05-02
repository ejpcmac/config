################################################################################
##                                                                            ##
##               Home configuration for jpc with server aliases               ##
##                                                                            ##
################################################################################

let
  mkNixosRebuild = host: domain: command: ''
    nixos-rebuild ${command} \
      --flake "git+file:///config?dir=Nix/${host}#${host}" \
      --build-host root@${host}${domain} \
      --target-host root@${host}${domain} \
  '';

  mkNeptuneNor = mkNixosRebuild "neptune" ".ejpcmac.net";
in

{
  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  programs.zsh.shellAliases = {
    neptune-update-all = "(cd /config/Nix/neptune && nix flake update)";
    neptune-update-common = "(cd /config/Nix/neptune && nix flake lock --update-input common)";
    neptune-norb = mkNeptuneNor "boot";
    neptune-nors = mkNeptuneNor "switch";
  };
}
