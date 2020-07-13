{ pkgs }:

let
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
    realName = "Jean-Philippe Cugnet";
    passwordCommand = "${pkgs.pass}/bin/pass courriel/${address}";

    inherit address userName primary imap smtp;

    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      remove = "both";
    };

    msmtp.enable = true;
    msmtp.extraConfig.auth = smtpAuth;

    gpg = {
      encryptByDefault = true;
      signByDefault = true;
      key = "C350CCB299D730FDAF8C5B7AE847B871DADD49DF";
    };
  };
}
