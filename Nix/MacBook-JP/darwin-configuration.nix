##
## System configuration for MacBook-JP
##

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
  fix-unstable = import ../common/overlays/darwin-fix-unstable.nix;

  # Editor script to use emacsclient, falling back to Emacs.
  editorScript = with pkgs; writeScriptBin "emacseditor" ''
    #!${runtimeShell}
    if [ -z "$1" ]; then
      exec ${emacs}/bin/emacsclient --create-frame --alternate-editor ${emacs}/bin/emacs
    else
      exec ${emacs}/bin/emacsclient --alternate-editor ${emacs}/bin/emacs "$@"
    fi
  '';
in

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  imports = with confkit.modules; [
    environment
    nix
    tmux
    zsh
  ];

  nix.maxJobs = 4;

  nixpkgs.overlays = [
    fix-unstable
  ];

  ############################################################################
  ##                              Environment                               ##
  ############################################################################

  environment.variables = {
    LANG = "fr_FR.UTF-8";
    LC_ALL = "$LANG";
    EDITOR = "${editorScript}/bin/emacseditor";

    # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    dcfldd
    emacs
    emv
    git
    git-lfs
    iftop
    imagemagick
    lsof
    mosh
    nix-prefetch-github
    openssh
    pandoc
    ranger
    rename
    rsync
    testdisk
    trash-cli
    tree
    unzip
    watch
    wget
    xz
    zip

    # TeXLive can be useful for tools like Pandoc or Org.
    texlive.combined.scheme-medium
  ];

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    emacs.enable = true;
    nix-daemon.enable = true;
  };

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  environment.etc = {
    "ranger/rc.conf".source = confkit.file "ranger/rc.conf";
    "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
  };
}
