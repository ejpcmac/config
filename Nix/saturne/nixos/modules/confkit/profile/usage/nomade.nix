################################################################################
##                                                                            ##
##                     Configuration for the nomade setup                     ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "nomade" config.confkit.profile.usage) {

    ########################################################################
    ##                              confkit                               ##
    ########################################################################

    confkit = {
      info.location = "nomade";
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
        dpi = 141;
        xrandrHeads = [{ output = "eDP-1"; primary = true; }];
      };
    };

    ########################################################################
    ##                         Home configuration                         ##
    ########################################################################

    home-manager.users.jpc = {
      services = {
        polybar = {
          config = {
            "bar/laptop".monitor = "eDP-1";
            "module/backlight".card = "intel_backlight";
          };
        };
      };

      programs = {
        bspwm = {
          monitors = ''
            if [ -f $HOME/.local/share/is_docked ]; then
                bspc wm --reorder-monitors DP-1.1 DP-1.2 DP-0
                bspc monitor %DP-1.1 -d 1 2 3 4 5
                bspc monitor %DP-1.2 -d 6 7 8 9 0
                bspc monitor DP-0 -d $ = %
            else
                bspc monitor eDP-1 -d $ 1 2 3 4 5 6 7 8 9 0 = %
            fi
          '';
        };
      };
    };
  };
}
