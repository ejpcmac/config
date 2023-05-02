################################################################################
##                                                                            ##
##                  System configuration for www.ejpcmac.net                  ##
##                                                                            ##
################################################################################

{ pkgs, ... }:

{
  imports = [
    # Import my personal NixOS extension module.
    ../../../common/nixos

    # Configuration for the users.
    ../../../common/users/root/usage/container.nix
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "www";
      machineId = "***[ REDACTED ]***";
      location = "neptune";
    };

    profile.type = [ "container" ];
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  users.users.wwwrun.extraGroups = [ "acme" ];

  ############################################################################
  ##                               Networking                               ##
  ############################################################################

  networking = {
    nameservers = [ "***[ REDACTED ]***" ];
    defaultGateway = "***[ REDACTED ]***";
    useDHCP = false;

    # Allow access to the web server
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  ############################################################################
  ##                              Certificates                              ##
  ############################################################################

  security.acme = {
    acceptTerms = true;
    certs = {
      "ejpcmac.net" = {
        webroot = "/var/lib/acme/acme-challenge";
        email = "***[ REDACTED ]***";
        extraDomainNames = [
          "***[ REDACTED ]***"
        ];
      };
    };
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    httpd = {
      enable = true;
      enablePHP = true;
      adminAddr = "***[ REDACTED ]***";

      phpOptions = ''
        [PHP]
        default_charset = "UTF-8"
        display_errors = Off
        display_startup_errors = Off

        [Date]
        date.timezone = "Europe/Paris"
      '';

      virtualHosts = {
        ################################################################
        ##                          Websites                          ##
        ################################################################

        "ejpcmac.net" = {
          forceSSL = true;
          useACMEHost = "ejpcmac.net";
          documentRoot = "/persist/sites/ejpcmac.net";
          extraConfig = ''
            RedirectMatch ^/$ /blog/

            <Directory "/persist/sites/ejpcmac.net">
              DirectoryIndex index.html index.php
              AddDefaultCharset UTF-8
              AllowOverride All
              Require all granted
            </Directory>
          '';
        };
      };
    };
  };
}
