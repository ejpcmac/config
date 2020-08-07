####### Configuration for Termite ##############################################
##                                                                            ##
## * Simple dark theme as a default                                           ##
## * Theme switcher system                                                    ##
##     * Use `termite -c $HOME/.config/termite/themed-config`                 ##
##     * `$HOME/.config/termite/switch-theme` script provided                 ##
##     * Switch between dark and light themes                                 ##
##     * Switch between hard and soft themes for both light and dark          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkDefault;
in

{
  programs.termite = {
    enable = true;
    allowBold = mkDefault true;
    audibleBell = mkDefault false;
    backgroundColor = mkDefault "#151515";
    browser = mkDefault "xdg-open";
    clickableUrl = mkDefault true;
    cursorBlink = mkDefault "system";
    cursorShape = mkDefault "block";
    dynamicTitle = mkDefault true;
    filterUnmatchedUrls = mkDefault true;
    font = mkDefault "Monospace 9";
    fullscreen = mkDefault true;
    geometry = mkDefault "800x600";
    mouseAutohide = mkDefault false;
    scrollOnKeystroke = mkDefault true;
    scrollOnOutput = mkDefault false;
    scrollbackLines = mkDefault 10000;
    scrollbar = mkDefault "off";
    searchWrap = mkDefault true;
    urgentOnBell = mkDefault true;
  };

  xdg.configFile = {
    "termite/config-dark-hard".text = mkDefault (
      config.xdg.configFile."termite/config".text
      + readFile ./res/termite/jpc-dark.config);

    "termite/config-dark-soft".text = mkDefault (
      config.xdg.configFile."termite/config".text
      + readFile ./res/termite/base16-snazzy-noextra.config);

    "termite/config-light-soft".text = mkDefault (
      config.xdg.configFile."termite/config".text
      + readFile ./res/termite/base16-atelier-dune-light-noextra.config);

    "termite/config-light-hard".text = mkDefault (
      config.xdg.configFile."termite/config".text
      + readFile ./res/termite/jpc-light.config);

    "termite/switch-theme" = {
      executable = true;
      text = ''
        #!/bin/sh

        config=$HOME/.config/termite/themed-config
        current_config=$(readlink $config)

        if [ "$1" == "hardsoft" ]; then
            config=$HOME/.config/termite/$current_config
            current_config=$(readlink $config)
        fi

        if [ "$current_config" == "config-dark" ]; then
            ln -sf config-light $config
        elif [ "$current_config" == "config-light" ]; then
            ln -sf config-dark $config
        elif [ "$current_config" == "config-dark-hard" ]; then
            ln -sf config-dark-soft $config
        elif [ "$current_config" == "config-dark-soft" ]; then
            ln -sf config-dark-hard $config
        elif [ "$current_config" == "config-light-soft" ]; then
            ln -sf config-light-hard $config
        elif [ "$current_config" == "config-light-hard" ]; then
            ln -sf config-light-soft $config
        else
            ln -sf config-dark-hard $HOME/.config/termite/config-dark
            ln -sf config-light-hard $HOME/.config/termite/config-light
            ln -sf config-dark $HOME/.config/termite/themed-config
        fi

        pkill -USR1 termite
      '';

      # Automatically create the links if they do not exist.
      onChange = ''
        cfg_dir=$HOME/.config/termite
        config=$cfg_dir/themed-config
        config_light=$cfg_dir/config-light
        config_dark=$cfg_dir/config-dark

        if [ ! -f $config ]; then
            ln -sf config-dark $config
        fi

        if [ ! -f $config_dark ]; then
            ln -sf config-dark-hard $config_dark
        fi

        if [ ! -f $config_light ]; then
            ln -sf config-light-hard $config_light
        fi
      '';
    };
  };
}
