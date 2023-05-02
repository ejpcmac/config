################################################################################
##                                                                            ##
##                        General system configuration                        ##
##                                                                            ##
################################################################################

{ inputs, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?

  imports = [
    # Import the confkit NixOS module to get ready-to-use configurations for
    # several tools.
    inputs.confkit.nixosModules.confkit-nixos

    # Import the home-manager NixOS module to handle user configurations
    # declaratively.
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.overlays = [
    # Enable my personal overlay on all hosts.
    (import ../overlays/jpc_overlay.nix)
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    keyboard.layout = "bépo";

    features = {
      base.enable = true;
      shell.enable = true;
      utilities.enable = true;
    };

    programs = {
      nix.enable = true;
      ranger.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
  };

  ############################################################################
  ##                           Nix configuration                            ##
  ############################################################################

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  console.keyMap = "fr-bepo";
  i18n.defaultLocale = "fr_FR.UTF-8";
  home-manager.useUserPackages = true;

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    glances
    openssl
    pv
  ];
}
