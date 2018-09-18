{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.packages = with pkgs; [ duti ];

  home.file = {
    # MacBook-JP-only Zsh aliases
    ".zsh/dev.zsh".source = ../../zsh/dev.macbook-jp.zsh;
    ".zsh/gpg-agent.zsh".source = ../../zsh/gpg-agent.zsh;
    ".zsh/serveurs.zsh".source = ../../zsh/serveurs.zsh;
  };

  programs.ssh = {
    enable = true;

    forwardAgent = true;
    extraOptionOverrides.HostKeyAlgorithms = "ssh-rsa";

    extraConfig = ''
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

      # TODO: Remove when not needed.
      # Temporary fix to avoid vim starting XQuartz.
      vim = "vim -X";

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
