#!/bin/sh

################################################################################
##                                                                            ##
##                       Auto-install script for Helios                       ##
##                                                                            ##
################################################################################

set -e
set -x

################################################################################
##                                  Options                                   ##
################################################################################

name=helios
config_repo=https://gitlab.ejpcmac.net/univers/$name.git
zpool=$name
root=$zpool/os
boot_disk=/dev/nvme0n1
boot_partition=/dev/nvme0n1p1

luks_options="--cipher aes-xts-plain64 \
              --key-size 512 \
              --hash sha512 \
              --use-random"

{ set +x; } 2> /dev/null

################################################################################
##                                   Script                                   ##
################################################################################

# Configure Nix.
printf "\n\e[32m=> Configuring Nix...\e[0m\n\n"
(
    set -x
    mkdir -p ~/.config/nix
    echo "max-jobs = auto\nauto-optimise-store = true" > ~/.config/nix/nix.conf
)

# Install the dependencies for the script.
printf "\n\e[32m=> Installing the dependencies for the script...\e[0m\n\n"
(
    set -x
    nix-env -Ai nixos.git
)

# Partition the boot disk.
printf "\n\e[32m=> Partitioning the boot disk...\e[0m\n\n"
(
    set -x
    parted $boot_disk -- mklabel gpt
    parted $boot_disk -- mkpart ESP fat32 1MiB 512MiB
    parted $boot_disk -- mkpart primary 512MiB 4096MiB
    parted $boot_disk -- mkpart primary 4608MiB 100%
    parted $boot_disk -- set 1 boot on
)

# Format the ESP.
printf "\n\e[32m=> Formatting the ESP...\e[0m\n\n"
(
    set -x
    mkfs.fat -F 32 -n boot $boot_partition
)

# Format the LUKS devices.
printf "\n\e[32m=> Formatting the LUKS devices...\e[0m\n\n"
(
    set -x
    cryptsetup $luks_options luksFormat /dev/nvme0n1p2
    cryptsetup $luks_options luksFormat /dev/sda
    cryptsetup $luks_options luksFormat /dev/sdb
    cryptsetup $luks_options luksFormat /dev/sdc
    cryptsetup $luks_options luksFormat /dev/sdd
    cryptsetup $luks_options luksFormat /dev/sde
    cryptsetup $luks_options luksFormat /dev/sdf
)

# Mount the LUKS devices.
printf "\n\e[32m=> Mounting the LUKS devices...\e[0m\n\n"
(
    set -x
    cryptsetup luksOpen /dev/nvme0n1p2 ssd
    cryptsetup luksOpen /dev/sda hdd1
    cryptsetup luksOpen /dev/sdb hdd2
    cryptsetup luksOpen /dev/sdc hdd3
    cryptsetup luksOpen /dev/sdd hdd4
    cryptsetup luksOpen /dev/sde hdd5
    cryptsetup luksOpen /dev/sdf hdd6
)

# Create the ZFS pool.
printf "\n\e[32m=> Creating the ZFS pool...\e[0m\n\n"
(
    set -x
    zpool create -m none -R /mnt $zpool \
        -O acltype=posixacl \
        -O atime=off \
        -O checksum=sha512 \
        -O compression=lz4 \
        -O dnodesize=auto \
        -O normalization=formD \
        -O reservation=1G \
        -O xattr=sa \
        -O com.sun:auto-snapshot=true \
        raidz2 \
        /dev/mapper/hdd1 \
        /dev/mapper/hdd2 \
        /dev/mapper/hdd3 \
        /dev/mapper/hdd4 \
        /dev/mapper/hdd5 \
        /dev/mapper/hdd6 \
        cache \
        /dev/mapper/ssd
)

# Create the OS filesystems.
printf "\n\e[32m=> Creating the OS filesystems...\e[0m\n\n"
(
    set -x
    zfs create -o mountpoint=legacy                                $root
    zfs create                      -o com.sun:auto-snapshot=false $root/nix
    zfs create                                                     $root/nix/store
    zfs create                      -o com.sun:auto-snapshot=false $root/config
    zfs create                      -o com.sun:auto-snapshot=false $root/etc
    zfs create                                                     $root/root
    zfs create                                                     $root/var
    zfs create                      -o com.sun:auto-snapshot=false $root/var/cache
    zfs create                                                     $root/var/db
    zfs create                      -o com.sun:auto-snapshot=false $root/var/empty
    zfs create -o compression=gzip                                 $root/var/log
    zfs create                      -o com.sun:auto-snapshot=false $root/var/tmp
    zfs create -o mountpoint=/home                                 $zpool/home
)

# Unmount the automatically mounted filesystems.
printf "\n\e[32m=> Unmounting the automatically mounted filesystems...\e[0m\n\n"
(
    set -x
    zfs unmount -a
)

# Mount the filesystems.
printf "\n\e[32m=> Mounting the filesystems...\e[0m\n\n"
(
    set -x
    mount -t zfs $root /mnt
    mkdir -p /mnt/boot /mnt/nix /mnt/config /mnt/etc /mnt/root /mnt/var
    mount $boot_partition /mnt/boot
    mount -t zfs $root/nix /mnt/nix
    mount -t zfs $root/config /mnt/config
    mount -t zfs $root/etc /mnt/etc
    mount -t zfs $root/root /mnt/root
    mount -t zfs $root/var /mnt/var
    mkdir /mnt/nix/store /mnt/var/cache /mnt/var/db /mnt/var/empty /mnt/var/log /mnt/var/tmp
    mount -t zfs $root/nix/store /mnt/nix/store
    mount -t zfs $root/var/cache /mnt/var/cache
    mount -t zfs $root/var/db /mnt/var/db
    mount -t zfs $root/var/empty /mnt/var/empty
    mount -t zfs $root/var/log /mnt/var/log
    mount -t zfs $root/var/tmp /mnt/var/tmp
)

# Generate the hardware configuration.
printf "\n\e[32m=> Generating the hardware configuration...\e[0m\n\n"
(
    set -x
    nixos-generate-config --root /mnt
)

# Install the configuration.
printf "\n\e[32m=> Installing the configuration...\e[0m\n\n"
(
    set -x
    git clone --recurse-submodules $config_repo /mnt/config
    rm /mnt/etc/nixos/configuration.nix
    ln -s ../../config/Nix/$name/configuration.nix /mnt/etc/nixos/
)

# Install NixOS.
printf "\n\e[32m=> Installing NixOS...\e[0m\n\n"
(
    set -x
    nix-channel --add https://github.com/ejpcmac/jpc-nix/archive/master.tar.gz jpc-nix
    nix-channel --update
    nixos-install
)

printf "\n\e[32m\e[1mInstallation complete!\e[0m\n\n"
