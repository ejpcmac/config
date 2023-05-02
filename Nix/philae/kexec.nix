{ pkgs, config, ... }:

let
  inherit (pkgs) callPackage nukeReferences runCommand writeTextFile;
in

{
  system.build = rec {
    image = runCommand "image" { buildInputs = [ nukeReferences ]; } ''
      mkdir $out
      cp ${config.system.build.kernel}/bzImage $out/kernel
      cp ${config.system.build.netbootRamdisk}/initrd $out/initrd
      echo "init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}" > $out/cmdline
      nuke-refs $out/kernel
    '';

    kexec_script = writeTextFile {
      executable = true;
      name = "kexec_philae";
      text = ''
        #!${pkgs.stdenv.shell}

        export PATH=${pkgs.kexectools}/bin:${pkgs.cpio}/bin:$PATH

        kexec -l ${image}/kernel --initrd=${image}/initrd \
              --append="init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}"

        sync

        printf "\n\e[32m=> Landing in 3... 2... 1...\e[0m\n\n"
        kexec -e
      '';
    };

    kexec_tarball = callPackage <nixpkgs/nixos/lib/make-system-tarball.nix> {
      contents = [ ];

      storeContents = [
        { object = config.system.build.kexec_script; symlink = "/kexec_philae"; }
      ];
    };
  };
}
