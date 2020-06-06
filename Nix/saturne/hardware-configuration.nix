# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "saturne/os";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A2B3-E01F";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "saturne/os/nix";
      fsType = "zfs";
    };

  fileSystems."/etc" =
    { device = "saturne/os/etc";
      fsType = "zfs";
    };

  fileSystems."/root" =
    { device = "saturne/os/root";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "saturne/os/var";
      fsType = "zfs";
    };

  fileSystems."/nix/store" =
    { device = "saturne/os/nix/store";
      fsType = "zfs";
    };

  fileSystems."/var/cache" =
    { device = "saturne/os/var/cache";
      fsType = "zfs";
    };

  fileSystems."/var/db" =
    { device = "saturne/os/var/db";
      fsType = "zfs";
    };

  fileSystems."/var/empty" =
    { device = "saturne/os/var/empty";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    { device = "saturne/os/var/log";
      fsType = "zfs";
    };

  fileSystems."/var/tmp" =
    { device = "saturne/os/var/tmp";
      fsType = "zfs";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}