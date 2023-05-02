################################################################################
##                                                                            ##
##                   Home configuration for jpc on laptops                    ##
##                                                                            ##
################################################################################

{
  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  programs.zsh.shellAliases = {
    # WiFi toggle.
    won = "nmcli radio wifi on";
    woff = "nmcli radio wifi off";

    # Performance
    cpg = "cpupower frequency-info";
    cpt = "sudo cpupower frequency-set --max 2900MHz";
    cpt2 = "sudo cpupower frequency-set --max 2000MHz";
    cpt3 = "sudo cpupower frequency-set --max 1200MHz";
    cpt4 = "sudo cpupower frequency-set --max 800MHz";
    ucpt = "sudo cpupower frequency-set --max 4800MHz";
  };
}
