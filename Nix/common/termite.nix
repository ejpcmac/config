####### Configuration for Termite ##############################################
##                                                                            ##
## * Simple dark theme                                                        ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  programs.termite = {
    enable = true;
    allowBold = mkDefault true;
    audibleBell = mkDefault false;
    backgroundColor = mkDefault "rgba(0, 0, 0, 0.75)";
    browser = mkDefault "xdg-open";
    clickableUrl = mkDefault true;
    cursorBlink = mkDefault "system";
    cursorShape = mkDefault "block";
    dynamicTitle = mkDefault true;
    filterUnmatchedUrls = mkDefault true;
    font = mkDefault "Monospace 9";
    fullscreen = mkDefault true;
    geometry = mkDefault "800x600";
    mouseAutohide = mkDefault false;
    scrollOnKeystroke = mkDefault true;
    scrollOnOutput = mkDefault false;
    scrollbackLines = mkDefault 10000;
    scrollbar = mkDefault "off";
    searchWrap = mkDefault true;
    urgentOnBell = mkDefault true;
  };
}
