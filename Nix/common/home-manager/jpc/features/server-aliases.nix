################################################################################
##                                                                            ##
##               Home configuration for jpc with server aliases               ##
##                                                                            ##
################################################################################

{ lib, ... }:

let
  mkNhOs = host: domain: command: local: ''
    nh os ${command} --ask \
      /config/Nix/${host} \
      --hostname ${host} \
      --target-host root@${host}${domain} \
  '' + (lib.optionalString (!local) ''
    --build-host root@${host}${domain} \
  '') + ''
    -- --keep-going \
  '';

  mkNeptuneNo = mkNhOs "neptune" ".ejpcmac.net";
in

{
  home.file.".zsh/serveurs.zsh".source = ../zsh/serveurs.zsh;

  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  programs.zsh.shellAliases = {
    neptune-update-all = "(cd /config/Nix/neptune && nix flake update)";
    neptune-nob = mkNeptuneNo "boot" false;
    neptune-nos = mkNeptuneNo "switch" false;
    neptune-not = mkNeptuneNo "test" false;
    neptune-local-nob = mkNeptuneNo "boot" true;
    neptune-local-nos = mkNeptuneNo "switch" true;
    neptune-local-not = mkNeptuneNo "test" true;

    neptune-tree = ''
      nix-tree --derivation "git+file:///config?dir=Nix/neptune"
    '';
  };
}
