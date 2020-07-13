################################################################################
##                                                                            ##
##                   Home configuration for jpc on laptops                    ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    linuxPackages.cpupower
  ];

  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  programs.zsh.shellAliases = {
    # WiFi toggle.
    won = "nmcli radio wifi on";
    woff = "nmcli radio wifi off";

    # Performance
    cpt = "sudo cpupower frequency-set --max 2900MHz";
    cpt2 = "sudo cpupower frequency-set --max 1800MHz";
    cpt3 = "sudo cpupower frequency-set --max 1200MHz";
    cpt4 = "sudo cpupower frequency-set --max 800MHz";
    ucpt = "sudo cpupower frequency-set --max 4800MHz";
  };
}
