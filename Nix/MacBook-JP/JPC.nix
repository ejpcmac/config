##
## Home configuration for JPC@MacBook-JP
##

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  imports = [ ../common/home.nix ];

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [ duti ];

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  home.file = {
    # MacBook-JP-only Zsh aliases
    ".zsh/gpg-agent.zsh".source = confkit.file "zsh/gpg-agent.zsh";
    ".zsh/dev.local.zsh".source = ./zsh/dev.zsh;
    ".zsh/serveurs.zsh".source = ./zsh/serveurs.zsh;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs.ssh = {
    enable = true;

    forwardAgent = true;
    extraOptionOverrides.HostKeyAlgorithms = "ssh-rsa";

    extraConfig = ''
      Host localhost
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
      Host *.ejpcmac.net
          RemoteForward 2224 localhost:2224
          RemoteForward 2225 localhost:2225
    '';
  };

  programs.zsh = {
    oh-my-zsh.plugins = [ "osx" ];

    shellAliases = {
      # Use macOS `ls` instead of Oh My Zsh one
      ls = "/bin/ls -Gh";

      # Emacs
      eds = "launchctl start org.nixos.emacs";
      edp = "launchctl stop org.nixos.emacs";
      edr = "edp && sleep 1 && eds";

      # Frequent commands
      op = "open";
      ded = "diskutil eject disk2";
      erase-disk = "diskutil eraseDisk 'Free Space' 'Sans Titre' MBR";

      # restart SystemUIServer
      restart-systemuiserver = "killall SystemUIServer";

      # Maximum 7z compression
      m7z = "7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=64m -ms=on";

      # TrueCrypt in the terminal
      truecrypt = "/Applications/TrueCrypt.app/Contents/MacOS/TrueCrypt --text";

      # Hibernation modes
      hm-fast = "sudo pmset hibernatemode 0";
      hm-sleep = "sudo pmset hibernatemode 3";
      hm-hibernate = "sudo pmset hibernatemode 25";
    };
  };
}
