################################################################################
##                                                                            ##
##                     Home configuration for jpc@saturne                     ##
##                                                                            ##
################################################################################

{ config, inputs, lib, pkgs, system, ... }:

let
  libjpc = import ../../../common/home-manager/jpc/lib {
    inherit config lib pkgs;
  };

  inherit (lib) mkDefault mkForce;
  inherit (libjpc) link;

  nixpkgs-20_03 = import inputs.nixpkgs-20_03 { inherit system; };
  darktable = nixpkgs-20_03.darktable;
  track = inputs.track.packages.${system}.track;

  mkBar = params: libjpc.mkBar ({
    modules-right = mkDefault "alsa temperature memory gpumem cpufreq cpu gpu battery wlan modem eth-usb eth date";
  } // params);
in

{
  imports = [
    # Configuration shared between hosts.
    ../../../common/home-manager/jpc/general.nix
    ../../../common/home-manager/jpc/type/laptop.nix
    ../../../common/home-manager/jpc/usage/workstation.nix
    ../../../common/home-manager/jpc/features/server-aliases.nix
    ../../../common/home-manager/jpc/features/zfs.nix
  ];

  ############################################################################
  ##                         nixpkgs configuration                          ##
  ############################################################################

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "veracrypt"
  ];

  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    # General persistence
    ".bitcoin".source = link "/home/jpc/.persist/Crypto-monnaies/Bitcoin";
    ".bitmonero".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/data";
    ".dashcore".source = link "/home/jpc/.persist/Crypto-monnaies/Dash";
    ".mixxx".source = link "/home/jpc/.persist/Mixxx";
    ".purple".source = link "/home/jpc/.persist/Pidgin";
    ".thunderbird".source = link "/home/jpc/.persist/Thunderbird";
    ".vpn".source = link "/home/jpc/.persist/vpn";
    ".persist/Crypto-monnaies/Bitcoin/blocks".source = link "/data/Blockchains/Bitcoin";
    ".persist/Crypto-monnaies/Dash/blocks".source = link "/data/Blockchains/Dash";
    ".persist/Crypto-monnaies/Monero/data/lmdb".source = link "/data/Blockchains/Monero";

    # Cache persistence
    ".cache/calibre".source = link "/home/jpc/.persist/Calibre/cache";
    ".cache/cantata".source = link "/home/jpc/.persist/Cantata/cache";
    ".cache/liferea".source = link "/home/jpc/.persist/Liferea/cache";
    ".cache/monero-project".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/cache";

    # Persistence for the Courriels module
    ".cache/mu".source = link "/home/jpc/.persist/mu";

    # Persistence for the Photo module
    ".cache/darktable".source = link "/home/jpc/.persist/Darktable/cache";

    # Scripts
    ".local/bin/format-ssd".source = ./scripts/format-ssd;
    ".local/bin/org-sync".source = ../../../common/scripts/org-sync;
    ".local/bin/switch-mode".source = ./scripts/switch-mode;
    ".local/bin/titan-backup".source = ./scripts/titan-backup;
    ".local/bin/toggle-brightness".source = ./scripts/toggle-brightness;
    ".local/bin/toggle-touchpad".source = ./scripts/toggle-touchpad;
    ".local/bin/zfs-clean-snapshots".source = ../../../common/scripts/zfs-clean-snapshots;
  };

  xdg.configFile = {
    # General Persistence
    "Signal".source = link "/home/jpc/.persist/Signal";
    "asunder".source = link "/home/jpc/.persist/Asunder";
    "calibre".source = link "/home/jpc/.persist/Calibre/config";
    "cantata".source = link "/home/jpc/.persist/Cantata/config";
    "liferea".source = link "/home/jpc/.persist/Liferea/config";
    "monero-project".source = link "/home/jpc/.persist/Crypto-monnaies/Monero/config";

    # Persistence for the Photo module
    "darktable".source = link "/home/jpc/.persist/Darktable/config";
  };

  xdg.dataFile = {
    # General persistence
    "Daedalus/mainnet".source = link "/home/jpc/.persist/Crypto-monnaies/Daedalus";
    "cantata".source = link "/home/jpc/.persist/Cantata/data";
    "liferea".source = link "/home/jpc/.persist/Liferea/data";
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    nextcloud-client = { enable = true; startInBackground = true; };

    polybar = {
      script = ''
        mode=laptop

        if [ -f $HOME/.local/share/mode ]; then
            mode=$(${pkgs.coreutils}/bin/cat $HOME/.local/share/mode)
        fi

        case $mode in
            docked|docked-gpu|docked-nvidia)
                polybar laptop &
                polybar center &
                polybar right &
                ;;

            presentation|presentation-gpu)
                polybar laptop &
                polybar projector &
                ;;

            *)
                polybar laptop &
        esac
      '';

      config = {
        "bar/laptop" = mkBar {
          height = 36;
          font-size = 10;
          modules-right = "alsa backlight temperature memory gpumem cpufreq cpu gpu battery wlan modem eth-usb eth date tray";
        };

        "bar/center" = mkBar {
          height = 60;
          font-size = 15;
        };

        "bar/right" = mkBar {
          height = 60;
          font-size = 15;
        };

        "bar/projector" = mkBar {
          height = 36;
          font-size = 10;
          modules-right = "date";
        };

        "module/alsa".master-soundcard = "hw:1";
        "module/temperature".hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon10/temp1_input";
        "module/wlan".interface = "wlp0s20f3";
        "module/eth".interface = "enp10s0u1u3u3";

        "module/battery" = {
          battery = "BAT0";
          adapter = "ADP1";
        };

        "module/eth-usb" = {
          type = mkDefault "internal/network";
          interface = "enp58s0u1u4";

          format-connected-prefix = mkDefault "󰈀 ";
          format-connected-prefix-foreground = mkDefault "\${colors.icon}";
          format-connected-underline = mkDefault "#55aa55";

          label-connected = mkDefault "%local_ip% %netspeed:9%";
        };

        "module/modem" = {
          type = mkDefault "internal/network";
          interface = "enp0s20f0u4";
          unknown-as-up = true;

          format-connected-prefix = mkDefault "  ";
          format-connected-prefix-foreground = mkDefault "\${colors.icon}";
          format-connected-underline = mkDefault "#55aa55";

          label-connected = mkDefault "Modem USB %netspeed:9%";
        };
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    pidgin = { enable = true; plugins = [ pkgs.pidgin-otr ]; };
    termite.font = "DejaVu Sans Mono 8.5";

    zsh = {
      shellAliases = {
        # Restart services
        rdm = "sudo systemctl restart display-manager";
        nvidia-uvm-restart = "sudo rmmod nvidia_uvm && sudo modprobe nvidia_uvm";
        osr = mkForce "osp && nvidia-uvm-restart && ost";
        rn = "systemctl --user restart nextcloud-client";
        rr = "systemctl --user restart redshift";

        # Aliases to managed configurations
        ocg = "ecc ~/Informatique/Administration/Tiers/Configuration/guillaume";
        ocm = "ecc ~/Informatique/Administration/Tiers/Configuration/maman";

        # Specialisation management
        spe-docked = "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
        spe-docked-offload = "sudo /nix/var/nix/profiles/system/specialisation/docked-offload/bin/switch-to-configuration switch";
        spe-undocked = "sudo /nix/var/nix/profiles/system/specialisation/undocked/bin/switch-to-configuration switch";
        spe-undocked-gpu = "sudo /nix/var/nix/profiles/system/specialisation/undocked-gpu/bin/switch-to-configuration switch";

        # External drive shortcuts
        umnt = "udisksctl mount -b /dev/sda1";
        uumnt = "udisksctl unmount -b /dev/sda1";
        upo = "udisksctl power-off -b /dev/sda";
        upob = "udisksctl power-off -b /dev/sdb";
        ueject = "uumnt && upo";

        mount-titan = ''
          sudo udevadm trigger && \
          sudo cryptsetup open --allow-discards /dev/sda2 titan && \
          sudo zpool import titan -NR /titan
        '';

        unmount-titan = ''
          sudo zpool export titan && \
          sudo cryptsetup close titan && \
          udisksctl power-off -b /dev/sda
        '';

        # QEMU VMs.
        freebsd = ''
          qemu-system-x86_64 \
            -m 4096 \
            -smp 6 \
            -accel kvm \
            -drive file=$HOME/VMs/FreeBSD/freebsd.qcow2,format=qcow2 \
            -serial mon:stdio \
            -nographic \
        '';

        macos = ''
          quickemu \
            --vm ~/VMs/macOS/macos-sonoma.conf \
            --width 1920 \
            --height 1080 \
            --display spice \
        '';
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    # Utilities
    track
    zola

    # Applications
    asunder
    bitcoin
    calibre
    cantata
    darktable
    easytag
    gimp
    gnucash
    liferea
    mixxx
    monero-gui
    qmapshack
    scribus
    signal-desktop
    soundkonverter
    stellarium
    thunderbird
    veracrypt
    xsane
    yubikey-manager
    yubioath-flutter
  ];
}
