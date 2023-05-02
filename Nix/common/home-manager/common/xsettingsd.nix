####### Configuration for xsettingsd ###########################################
##                                                                            ##
## * Enable xsettingsd                                                        ##
## * Theme switcher system                                                    ##
##     * `$HOME/.config/xsettingsd/switch-theme` script provided              ##
##     * Switch between dark and light themes                                 ##
##                                                                            ##
################################################################################

{ lib, ... }:

let
  inherit (lib) mkDefault;
in

{
  services.xsettingsd.enable = true;

  xdg.configFile = {
    "xsettingsd/xsettingsd-light.conf".text = mkDefault ''
      Net/ThemeName "Adwaita"
      Net/IconThemeName "breeze"
      Gtk/CursorThemeName "capitaine-cursors"
    '';

    "xsettingsd/xsettingsd-dark.conf".text = mkDefault ''
      Net/ThemeName "Adwaita-dark"
      Net/IconThemeName "breeze-dark"
      Gtk/CursorThemeName "capitaine-cursors"
    '';

    "xsettingsd/switch-theme" = {
      executable = true;
      text = ''
        #!/bin/sh

        config=$HOME/.config/xsettingsd/xsettingsd.conf
        current_config=$(readlink $config)

        if [ "$current_config" == "xsettingsd-dark.conf" ]; then
            ln -sf xsettingsd-light.conf $config
        elif [ "$current_config" == "xsettingsd-light.conf" ]; then
            ln -sf xsettingsd-dark.conf $config
        else
            ln -sf xsettingsd-light.conf $HOME/.config/xsettingsd/xsettingsd.conf
        fi

        systemctl --user restart xsettingsd.service
      '';

      # Automatically create the links if they do not exist.
      onChange = ''
        cfg_dir=$HOME/.config/xsettingsd
        config=$cfg_dir/xsettingsd.conf

        if [ ! -f $config ]; then
            ln -sf xsettingsd-light.conf $config
        fi
      '';
    };
  };
}
