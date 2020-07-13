################################################################################
##                                                                            ##
##                  Home configuration for jpc in Kerguelen                   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  libjpc = import ../lib { inherit pkgs; };

  ## Generates a Kermail account.
  mkKermail = userName: { primary ? false }:
    libjpc.mkEmail "${userName}@***[ REDACTED ]***" {
      inherit userName primary;

      imap = {
        host = "***[ REDACTED ]***";
        port = 993;
        tls = {
          enable = true;
        };
      };

      smtp = {
        host = "***[ REDACTED ]***";
        port = 465;
        tls = {
          enable = true;
        };
      };
    };
in

{
  ############################################################################
  ##                                Accounts                                ##
  ############################################################################

  accounts.email = {
    accounts = {
      "***[ REDACTED ]***" = mkKermail "***[ REDACTED ]***" { primary = true; };
      "***[ REDACTED ]***" = mkKermail "***[ REDACTED ]***" {};
      "***[ REDACTED ]***" = mkKermail "***[ REDACTED ]***" {};
      "***[ REDACTED ]***" = mkKermail "***[ REDACTED ]***" {};
    };
  };
}
