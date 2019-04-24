####### Configuration for bspwm ################################################
##                                                                            ##
## * Use sxhkd for keyboard shortcuts                                         ##
## * Load the wallpaper from $HOME/Images/wallpaper.jpg using feh             ##
## * Start conky                                                              ##
## * 50/50 splits                                                             ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  # TODO: Remove when it is merged in home-manager.
  imports = [ ./modules/bspwm.nix ];

  programs.bspwm = {
    enable = true;

    monitors = mkDefault ''
      bspc monitor -d 1 2 3 4 5 6 7 8 9 0
    '';

    initScript = mkDefault ''
      # Avoid spawning sxhkd twice.
      if [ $(ps x | grep sxhkd | grep -v grep | wc -l) -eq 0 ]; then
          sxhkd &
      fi

      feh --bg-fill "$HOME/Images/wallpaper.jpg"

      pkill -x conky
      conky
    '';

    extraConfig = mkDefault ''
      bspc config border_width         4
      bspc config window_gap           0

      bspc config split_ratio          0.50
      bspc config borderless_monocle   true
      bspc config gapless_monocle      true
    '';

    extraRules = mkDefault ''
      bspc rule -a Firefox:Places split_dir=south split_ratio=0.8
      bspc rule -a Nightly:Places split_dir=south split_ratio=0.8
      bspc rule -a Gimp desktop='^0' state=floating follow=on
      bspc rule -a Keepassx locked=on
      bspc rule -a Zathura state=tiled
    '';
  };
}
