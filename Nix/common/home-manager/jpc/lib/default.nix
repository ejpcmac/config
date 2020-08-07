{ config, pkgs }:

let
  identity = config.confkit.identity;

  defaultImap = {
    host = "***[ REDACTED ]***";
    port = 143;
    tls = { enable = true; useStartTls = true; };
  };

  defaultSmtp = {
    host = "***[ REDACTED ]***";
    port = 587;
    tls = { enable = true; useStartTls = true; };
  };
in

{
  ## Generates an email account.
  mkEmail = address: { primary ? false
                     , userName ? address
                     , imap ? defaultImap
                     , smtp ? defaultSmtp
                     , smtpAuth ? "login" }: {
    realName = identity.name;
    inherit address userName primary imap smtp;

    passwordCommand = "${pkgs.pass}/bin/pass courriel/${address}";

    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      remove = "both";
    };

    msmtp = {
      enable = true;
      extraConfig.auth = smtpAuth;
    };

    gpg = {
      encryptByDefault = true;
      signByDefault = true;
      key = identity.gpgKey;
    };
  };
}
