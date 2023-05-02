####### Configuration for bspwm ################################################
##                                                                            ##
## * Use sxhkd for keyboard shortcuts                                         ##
## * Load the wallpaper from $HOME/.loca/sharewallpaper.jpg using feh         ##
## * 50/50 splits                                                             ##
##                                                                            ##
################################################################################

{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  # TODO: Remove when it is merged in home-manager.
  imports = [ ../../modules/bspwm.nix ];

  programs.bspwm = {
    enable = true;

    monitors = mkDefault ''
      bspc monitor -d $ 1 2 3 4 5 6 7 8 9 0 = %
    '';

    initScript = mkDefault ''
      # Avoid spawning sxhkd twice.
      if [ $(ps x | grep sxhkd | grep -v grep | wc -l) -eq 0 ]; then
          sxhkd &
      fi

      ${pkgs.feh}/bin/feh --bg-fill "$HOME/.local/share/wallpaper.jpg"
    '';

    extraConfig = mkDefault ''
      bspc config border_width         4
      bspc config window_gap           0

      bspc config split_ratio          0.50
      bspc config borderless_monocle   true
      bspc config gapless_monocle      true
    '';

    extraRules = mkDefault ''
      bspc rule -a Emacs state=tiled
      bspc rule -a mpv state=fullscreen
      bspc rule -a Pqiv state=tiled
      bspc rule -a Veracrypt state=tiled
      bspc rule -a Zathura state=tiled
    '';
  };
}
