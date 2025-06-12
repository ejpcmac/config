################################################################################
##                                                                            ##
##         Configuration for Intel monitors with Nvidia GPU rendering         ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "monitors-intel+gpu" config.confkit.profile.type) {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
        xrandrHeads = [{ output = "eDP-1-1"; primary = true; }];
      };
    };

    ########################################################################
    ##                         Home configuration                         ##
    ########################################################################

    home-manager.users.jpc = {
      services = {
        polybar = {
          config = {
            "bar/laptop".monitor = "eDP-1-1";
            "bar/center".monitor = "DP-0.1";
            "bar/right".monitor = "DP-0.2";
            "bar/projector".monitor = "HDMI-0";
            "module/backlight".card = "intel_backlight";
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
                docked-gpu)
                    bspc wm --reorder-monitors DP-0.1 DP-0.2 eDP-1-1
                    bspc monitor %DP-0.1 -d 1 2 3 4 5
                    bspc monitor %DP-0.2 -d 6 7 8 9 0
                    bspc monitor eDP-1-1 -d $ = %
                    ;;

                presentation-gpu)
                    bspc wm --reorder-monitors eDP-1-1 HDMI-0
                    bspc monitor eDP-1-1 -d $ 1 2 3 4 5 6 7 8 9 0
                    bspc monitor HDMI-0 -d = %
                    ;;

                *)
                    bspc monitor eDP-1-1 -d $ 1 2 3 4 5 6 7 8 9 0 = %
            esac
          '';
        };

        zsh = {
          shellAliases = {
            # Mode management
            sml = "switch-mode laptop";
            smd = "switch-mode docked-gpu";
            smp = "switch-mode presentation-gpu";
            smdup = "switch-mode duplicated-gpu";
          };
        };
      };
    };
  };
}
