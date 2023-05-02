################################################################################
##                                                                            ##
##                     Configuration for the MPD feature                      ##
##                                                                            ##
################################################################################

{
  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  # Enable ALSA sound.
  sound.enable = true;

  ############################################################################
  ##                                Firewall                                ##
  ############################################################################

  # Open ports for httpd and MPD.
  networking.firewall.allowedTCPPorts = [ 80 6600 ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    # Serve the music directory for cover art.
    httpd = {
      enable = true;
      adminAddr = "***[ REDACTED ]***";
      virtualHosts.helios.documentRoot = "/data/Musique/Albums";
    };

    mpd = {
      enable = true;
      musicDirectory = "/data/Musique/Albums";
      extraConfig = builtins.readFile ../res/mpd.conf;
      network.listenAddress = "any";
    };
  };
}
