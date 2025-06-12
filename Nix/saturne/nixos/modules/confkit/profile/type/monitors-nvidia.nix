################################################################################
##                                                                            ##
##                     Configuration for Nvidia monitors                      ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "monitors-nvidia" config.confkit.profile.type) {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
        xrandrHeads = [{ output = "DP-0"; primary = true; }];
      };
    };

    ########################################################################
    ##                         Home configuration                         ##
    ########################################################################

    home-manager.users.jpc = {
      services = {
        polybar = {
          config = {
            "bar/laptop".monitor = "DP-0";
            "bar/center".monitor = "DP-1.1";
            "bar/right".monitor = "DP-1.2";
            "bar/projector".monitor = "HDMI-0";
            "module/backlight".card = "nvidia_0";
          };
        };
      };

      programs = {
        bspwm = {
          monitors = ''
            mode=laptop

            if [ -f $HOME/.local/share/mode ]; then
                mode=$(cat $HOME/.local/share/mode)
            fi

            case $mode in
                docked-nvidia)
                    bspc wm --reorder-monitors DP-1.1 DP-1.2 DP-0
                    bspc monitor %DP-1.1 -d 1 2 3 4 5
                    bspc monitor %DP-1.2 -d 6 7 8 9 0
                    bspc monitor DP-0 -d $ = %
                    ;;

                presentation-nvidia)
                    bspc wm --reorder-monitors DP-0 HDMI-0
                    bspc monitor DP-0 -d $ 1 2 3 4 5 6 7 8 9 0
                    bspc monitor HDMI-0 -d = %
                    ;;

                *)
                    bspc monitor DP-0 -d $ 1 2 3 4 5 6 7 8 9 0 = %
            esac
          '';
        };

        zsh = {
          shellAliases = {
            # Mode management
            sml = "switch-mode laptop";
            smd = "switch-mode docked-nvidia";
          };
        };
      };
    };
  };
}
