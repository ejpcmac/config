################################################################################
##                                                                            ##
##                  Configuration for the webserver feature                   ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.custom.saturne.webserver;
in

{
  options.confkit.features.custom.saturne.webserver = {
    enable = mkEnableOption "the webserver feature";
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    systemd.tmpfiles.rules = [
      # Create virtual hosts document roots.
      "d /var/lib/www/bark-artwork.com 755 root root - -"
      "d /var/lib/www/jpc_photos 755 root root - -"
      "d /var/lib/www/localhost 755 root root - -"
    ];

    ########################################################################
    ##                             Networking                             ##
    ########################################################################

    networking = {
      firewall = {
        allowedTCPPorts = [ 80 ];
      };

      hosts = {
        # Local web servers
        "127.0.0.1" = [
          "localhost"
          "saturne"
          "dev.jpc.photos"
          "dev.bark-artwork.com"
        ];
      };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      httpd = {
        enable = true;
        enablePHP = true;
        adminAddr = "jpc+saturne@ejpcmac.net";

        virtualHosts = {
          "localhost".documentRoot = "/var/lib/www/localhost";

          "dev.jpc.photos" = {
            documentRoot = "/var/lib/www/jpc_photos";
            extraConfig = ''
              <Directory "/var/lib/www/jpc_photos">
                DirectoryIndex index.html index.php
                AllowOverride All
              </Directory>
            '';
          };

          "dev.bark-artwork.com" = {
            documentRoot = "/var/lib/www/bark-artwork.com";
            extraConfig = ''
              <Directory "/var/lib/www/bark-artwork.com">
                DirectoryIndex index.html index.php
                AllowOverride All
              </Directory>
            '';
          };
        };
      };
    };
  };
}
