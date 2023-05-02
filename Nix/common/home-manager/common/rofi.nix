####### Configuration for rofi #################################################
##                                                                            ##
## * Install rofi                                                             ##
## * Theme switcher system                                                    ##
##     * `$HOME/.config/rofi/switch-theme` script provided                    ##
##     * Switch between dark and light themes                                 ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  home.packages = [ pkgs.rofi ];

  xdg.configFile = {
    "rofi/config-light.rasi".text = mkDefault ''
      configuration {
        modi: "combi";
        combi-modi: "window,drun,run";
        show-icons: true;
        icon-theme: "Adwaita";
      }
      @theme "Arc"
    '';

    "rofi/config-dark.rasi".text = mkDefault ''
      configuration {
        modi: "combi";
        combi-modi: "window,drun,run";
        show-icons: true;
        icon-theme: "Adwaita-dark";
      }
      @theme "Arc-Dark"
    '';

    "rofi/switch-theme" = {
      executable = true;
      text = ''
        #!/bin/sh

        config=$HOME/.config/rofi/config.rasi
        current_config=$(readlink $config)

        if [ "$current_config" == "config-dark.rasi" ]; then
            ln -sf config-light.rasi $config
        elif [ "$current_config" == "config-light.rasi" ]; then
            ln -sf config-dark.rasi $config
        else
            ln -sf config-light.rasi $config
        fi
      '';

      # Automatically create the links if they do not exist.
      onChange = ''
        cfg_dir=$HOME/.config/rofi
        config=$cfg_dir/config.rasi

        if [ ! -f $config ]; then
            ln -sf config-light.rasi $config
        fi
      '';
    };
  };
}
