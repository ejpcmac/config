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

    # Power management.
    tlp-default = "sudo ln -sf /etc/static/tlp.conf /etc/tlp.conf && sudo systemctl reload tlp";
    tlp-power = "sudo ln -sf /config/Nix/common/res/tlp_power.conf /etc/tlp.conf && sudo systemctl reload tlp";
    tlp-balance-power = "sudo ln -sf /config/Nix/common/res/tlp_balance_power.conf /etc/tlp.conf && sudo systemctl reload tlp";
    tlp-balance-performance = "sudo ln -sf /config/Nix/common/res/tlp_balance_performance.conf /etc/tlp.conf && sudo systemctl reload tlp";
    tlp-performance = "sudo ln -sf /config/Nix/common/res/tlp_performance.conf /etc/tlp.conf && sudo systemctl reload tlp";
    tlp-ultra = "sudo ln -sf /config/Nix/common/res/tlp_ultra.conf /etc/tlp.conf && sudo systemctl reload tlp";

    # Performance
    cpg = "cpupower frequency-info";
    cpt = "sudo cpupower frequency-set --max 2900MHz";
    cpt2 = "sudo cpupower frequency-set --max 2000MHz";
    cpt3 = "sudo cpupower frequency-set --max 1200MHz";
    cpt4 = "sudo cpupower frequency-set --max 800MHz";
    ucpt = "sudo cpupower frequency-set --max 4800MHz";
  };
}
