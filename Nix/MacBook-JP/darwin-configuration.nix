{ config, pkgs, ... }:

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  imports = [
    ../environment.nix
    ../nix.nix
    ../tmux.nix
    ../vim.nix
    ../zsh.nix
  ];

  nix.maxJobs = 4;

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    dcfldd
    emv
    git
    git-lfs
    imagemagick
    lsof
    nix-prefetch-github
    nox
    openssh
    rename
    rsync
    testdisk
    tree
    unzip
    watch
    wget
    xz
    zip
  ];

  services = {
    nix-daemon.enable = true;
  };
}
