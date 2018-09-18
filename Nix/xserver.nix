{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;

    # Setup the keyboard layout.
    layout = "fr";
    xkbVariant = "bepo";

    # Enable touchpad support with natural scrolling.
    libinput = {
      enable = true;
      naturalScrolling = true;
    };

    # Use Gnome 3 as desktop manager.
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };
}
