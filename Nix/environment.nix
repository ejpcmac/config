{ config, pkgs, ... }:

let
  inherit (pkgs) stdenv;
  nixos-rebuild = if stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";
  nixosPath = if stdenv.isDarwin then "'<darwin>'" else "\"<nixpkgs/nixos>\"";
in

{
  environment = {
    variables = if stdenv.isDarwin then {
      LANG = "fr_FR.UTF-8";
      LC_ALL = "$LANG";

      # `ls` colors (BSD)
      # a     black
      # b     red
      # c     green
      # d     brown
      # e     blue
      # f     magenta
      # g     cyan
      # h     light grey
      #
      # 1.    directory                               blue/none       ex
      # 2.    symbolic link                           magenta/none    fx
      # 3.    socket                                  green/none      cx
      # 4.    pipe                                    brow/none       dx
      # 5.    executable                              red/none        bx
      # 6.    block special                           black/red       ab
      # 7.    character special                       black/brown     ad
      # 8.    executable with setuid bit              RED/grey        Bh
      # 9.    executable with setgid bit              MAGENTA/grey    Fh
      # 10.   directory o+w, with sticky bit          blue/grey       eh
      # 11.   directory o+w, without sticky bit       cyan/grey       gh
      LSCOLORS = "exfxcxdxbxabadBhFhehgh";
    } else {
      LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=30;41:cd=30;43:su=1;31;47:sg=1;35;47:tw=34;47:ow=36;47";
    };

    shellAliases = {
      # Coloured `tree`, `grep` and `ls
      tree = "tree -C";
      grep = "grep --color=auto";
      ls =
        if stdenv.isLinux then "ls -h --color=auto"
        else if stdenv.isDarwin then "/bin/ls -Gh"
        else "ls -Gh";

      # Shortcuts for `ls`
      ll = "ls -l";
      la = "ls -A";
      lla = "ls -Al";

      # Human-readable `df` and `du`
      df = "df -h";
      du = "du -h";

      # Keep compressed version when using `unxz`
      unxz = "unxz -kv";

      # Handy nixos-rebuild aliases
      nor = nixos-rebuild;
      nors = "nix build --no-link -f ${nixosPath} config.system.build.toplevel && ${nixos-rebuild} switch";
    };
  };
}
