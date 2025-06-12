################################################################################
##                                                                            ##
##                     Home configuration for jpc@pluton                      ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  libjpc = pkgs.callPackage ../../../common/home-manager/jpc/lib { };
  inherit (lib) mkDefault mkForce;
  inherit (libjpc) link;

  mkBar = params: libjpc.mkBar ({
    modules-right = mkDefault "alsa memory cpu eth-vmware battery date";
  } // params);
in

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/features/server-aliases.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    identity.email = mkForce "***[ REDACTED ]***";
  };

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # Scripts
    ".local/bin/org-sync".source = ../../../common/scripts/org-sync;
  };

  xdg.configFile = {
    # General persistence
    "nix".source = link "/home/jpc/.persist/nix";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    polybar = {
      script = ''
        mode=laptop

        if [ -f $HOME/.local/share/mode ]; then
            mode=$(${pkgs.coreutils}/bin/cat $HOME/.local/share/mode)
        fi

        case $mode in
            docked-4k-full)
                polybar main-4k &
                ;;

            docked-4k)
                polybar main-4k &
                ;;

            *)
                polybar main-hd &
        esac
      '';

      config = {
        "bar/main-hd" = mkBar { height = 36; font-size = 10; };
        "bar/main-4k" = mkBar { height = 60; font-size = 15; };

        "module/alsa".master-soundcard = "hw:0";

        "module/eth-vmware" = {
          type = "internal/network";
          interface = "ens32";

          format-connected-prefix = "󰈀 ";
          format-connected-prefix-foreground = "\${colors.icon}";
          format-connected-underline = "#55aa55";

          label-connected = "VMWare %netspeed:9%";
        };
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    termite.font = "DejaVu Sans Mono 8.5";
  };
}
