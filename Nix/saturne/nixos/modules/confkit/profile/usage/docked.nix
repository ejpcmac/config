################################################################################
##                                                                            ##
##                     Configuration for the docked setup                     ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "docked" config.confkit.profile.usage) {

    ########################################################################
    ##                              confkit                               ##
    ########################################################################

    confkit = {
      info.location = "caen";
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      xserver = {
        dpi = 212;
        videoDrivers = [ "nvidia" ];

        xrandrHeads = [
          { output = "DP-0"; primary = true; }
          { output = "DP-1.1"; monitorConfig = ''Option "RightOf" "DP-0"''; }
          { output = "DP-1.2"; monitorConfig = ''Option "RightOf" "DP-1.1"''; }
        ];

        # Fix screen tearing when using the Nvidia driver.
        screenSection = ''
          Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
          Option "AllowIndirectGLXProtocol" "off"
          Option "TripleBuffer" "on"
        '';
      };
    };

    ########################################################################
    ##                         Home configuration                         ##
    ########################################################################

    home-manager.users.jpc = {
      services = {
        picom = {
          # Fix application flickering when using the the Nvidia driver.
          backend = "xrender";
          vSync = true;
          settings = {
            unredir-if-possible = false;
          };
        };

        polybar = {
          config = {
            "bar/laptop".monitor = "DP-0";
            "module/backlight".card = "nvidia_0";
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
                bspc monitor DP-0 -d $ 1 2 3 4 5 6 7 8 9 0 = %
            fi
          '';
        };
      };
    };
  };
}
