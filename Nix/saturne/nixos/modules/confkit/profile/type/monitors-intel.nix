################################################################################
##                                                                            ##
##                      Configuration for Intel monitors                      ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "monitors-intel" config.confkit.profile.type) {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
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
            "bar/center".monitor = "DP-1-0.1";
            "bar/right".monitor = "DP-1-0.2";
            "bar/projector".monitor = "HDMI-1-0";
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
                docked)
                    bspc wm --reorder-monitors DP-1-0.1 DP-1-0.2 eDP-1
                    bspc monitor %DP-1-0.1 -d 1 2 3 4 5
                    bspc monitor %DP-1-0.2 -d 6 7 8 9 0
                    bspc monitor eDP-1 -d $ = %
                    ;;

                presentation)
                    bspc wm --reorder-monitors eDP-1 HDMI-1-0
                    bspc monitor eDP-1 -d $ 1 2 3 4 5 6 7 8 9 0
                    bspc monitor HDMI-1-0 -d = %
                    ;;

                *)
                    bspc monitor eDP-1 -d $ 1 2 3 4 5 6 7 8 9 0 = %
            esac
          '';
        };

        zsh = {
          shellAliases = {
            # GPU management
            enable-nvidia-monitors = "sudo modprobe nvidia_drm && sudo systemctl restart display-manager";
            disable-nvidia-monitors = "sudo systemctl stop display-manager && sudo rmmod nvidia_drm && sudo systemctl start display-manager";

            # Mode management
            sml = "switch-mode laptop";
            smd = "switch-mode docked";
            smp = "switch-mode presentation";
            smdup = "switch-mode duplicated";
          };
        };
      };
    };
  };
}
