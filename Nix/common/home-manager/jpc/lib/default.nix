{ config, lib, pkgs }:

let
  inherit (lib) mkDefault replaceStrings;

  identity = config.confkit.identity;

  defaultImap = {
    host = "***[ REDACTED ]***";
    port = 993;
    tls.enable = true;
  };

  defaultSmtp = {
    host = "***[ REDACTED ]***";
    port = 465;
    tls.enable = true;
  };
in

{
  ## Creates a link to a file.
  link = file:
    pkgs.runCommand "${replaceStrings [ "/" " " ] [ "-" "_" ] file}" { } ''
      ln -s '${file}' $out
    '';

  ## Generates a bar.
  mkBar = params: {
    fixed-center = mkDefault false;
    width = mkDefault "100%";

    background = mkDefault "\${colors.background}";
    foreground = mkDefault "\${colors.foreground}";
    line-size = mkDefault 3;
    line-color = mkDefault "#f00";
    padding-left = mkDefault 0;
    padding-right = mkDefault 2;
    module-margin-left = mkDefault 1;
    module-margin-right = mkDefault 2;

    font-0 = mkDefault "NotoSansM NF:size=${toString params.font-size}:weight=bold;0";

    modules-left = mkDefault "bspwm";
    modules-right = mkDefault "alsa temperature memory cpufreq cpu battery wlan eth date";

    locale = mkDefault "fr_FR.UTF-8";

    wm-restack = mkDefault "bspwm";

    cursor-click = mkDefault "pointer";
    cursor-scroll = mkDefault "ns-resize";
  } // params;

  ## Generates an email account.
  mkEmail = address: { primary ? false
                     , userName ? address
                     , imap ? defaultImap
                     , smtp ? defaultSmtp
                     , smtpAuth ? "login"
                     }: {
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
