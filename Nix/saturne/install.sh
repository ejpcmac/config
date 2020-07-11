#!/bin/sh

################################################################################
##                                                                            ##
##                      Auto-install script for Saturne                       ##
##                                                                            ##
################################################################################

set -e
set -x

################################################################################
##                                  Options                                   ##
################################################################################

name=saturne
user=jpc
config_repo=https://gitlab.ejpcmac.net/jpc/config.git
config_dir=/mnt/home/$user/config
zpool=$name
disk1=/dev/nvme0n1
disk2=/dev/nvme1n1
boot_partition=${disk1}p1
mirror1=${disk1}p2
mirror2=${disk2}p2

luks_options="--cipher aes-xts-plain64 \
              --key-size 512 \
              --hash sha512 \
              --use-random"

{ set +x; } 2> /dev/null

################################################################################
##                                   Script                                   ##
################################################################################

printf "\n\e[32m=> Configuring Nix...\e[0m\n\n"
(
    set -x
    mkdir -p ~/.config/nix
    echo "max-jobs = auto\nauto-optimise-store = true" > ~/.config/nix/nix.conf
)

printf "\n\e[32m=> Installing the dependencies for the script...\e[0m\n\n"
(
    set -x
    nix-env -Ai nixos.git
)

printf "\n\e[32m=> Partitioning the SSDs...\e[0m\n\n"
(
    set -x
    parted $disk1 -- mklabel gpt
    parted $disk1 -- mkpart ESP fat32 1MiB 1GiB
    parted $disk1 -- mkpart primary 1GiB 100%
    parted $disk1 -- set 1 boot on

    parted $disk2 -- mklabel gpt
    parted $disk2 -- mkpart ESP fat32 1MiB 1GiB
    parted $disk2 -- mkpart primary 1GiB 100%
)

printf "\n\e[32m=> Formatting the ESP...\e[0m\n\n"
(
    set -x
    mkfs.fat -F 32 -n boot $boot_partition
)

printf "\n\e[32m=> Formatting the LUKS devices...\e[0m\n\n"
(
    set -x

    cryptsetup $luks_options luksFormat $mirror1
    while [ $? -ne 0 ]; do
        cryptsetup $luks_options luksFormat $mirror1
    done

    cryptsetup $luks_options luksFormat $mirror2
    while [ $? -ne 0 ]; do
        cryptsetup $luks_options luksFormat $mirror2
    done
)

printf "\n\e[32m=> Mounting the LUKS devices...\e[0m\n\n"
(
    set -x
    cryptsetup luksOpen $mirror1 ssd1
    cryptsetup luksOpen $mirror2 ssd2
)

printf "\n\e[32m=> Creating the ZFS pool...\e[0m\n\n"
(
    set -x
    zpool create -m none -R /mnt $zpool \
        -o autotrim=on \
        -O acltype=posixacl \
        -O atime=off \
        -O checksum=sha512 \
        -O compression=lz4 \
        -O dnodesize=auto \
        -O normalization=formD \
        -O reservation=1G \
        -O xattr=sa \
        -O com.sun:auto-snapshot=true \
        mirror \
        /dev/mapper/ssd1 \
        /dev/mapper/ssd2
)

printf "\n\e[32m=> Creating the OS filesystems...\e[0m\n\n"
(
    set -x
    root=$zpool/os
    zfs create -o mountpoint=legacy                                $root
    zfs create                      -o com.sun:auto-snapshot=false $root/nix
    zfs create                                                     $root/nix/store
    zfs create                      -o com.sun:auto-snapshot=false $root/etc
    zfs create                                                     $root/root
    zfs create                                                     $root/var
    zfs create                      -o com.sun:auto-snapshot=false $root/var/cache
    zfs create                                                     $root/var/db
    zfs create                      -o com.sun:auto-snapshot=false $root/var/empty
    zfs create -o compression=gzip                                 $root/var/log
    zfs create                      -o com.sun:auto-snapshot=false $root/var/tmp
    zfs create -o mountpoint=/home                                 $zpool/home
    zfs create                                                     $zpool/home/jpc
    zfs create                      -o com.sun:auto-snapshot=false $zpool/home/jpc/config
    zfs create                                                     $zpool/home/jpc/.cache
)

# Unmount the automatically mounted filesystems like $zpool/home so that the
# NixOS installer does not handle them.
printf "\n\e[32m=> Unmounting the automatically mounted filesystems...\e[0m\n\n"
(
    set -x
    zfs unmount -a
)

# Then mount manually the “legacy” filesystems.
printf "\n\e[32m=> Mounting the filesystems...\e[0m\n\n"
(
    set -x
    mount -t zfs $root /mnt
    mkdir -p /mnt/boot /mnt/nix /mnt/etc /mnt/root /mnt/var
    mount $boot_partition /mnt/boot
    mount -t zfs $root/nix /mnt/nix
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

printf "\n\e[32m=> Generating the hardware configuration...\e[0m\n\n"
(
    set -x
    nixos-generate-config --root /mnt
)

# Only after generating the hardware-configuration.nix, we can mount the other
# ZFS filesystems.
printf "\n\e[32m=> Mounting the non-OS filesystems...\e[0m\n\n"
(
    set -x
    zfs mount -a
)

function mkhome() {
    local user=$1
    local uid=$2

    local user_home=/mnt/home/$user
    local user_nix_profile=/mnt/nix/var/nix/profiles/per-user/$user

    mkdir -p $user_home $user_nix_profile
    chown -R $uid:users $user_home
    chmod 700 $user_home
}

printf "\n\e[32m=> Configuring the user homes...\e[0m\n\n"
(
    set -x
    mkhome $user 1000
)

printf "\n\e[32m=> Installing the configuration...\e[0m\n\n"
(
    set -x
    git clone --recurse-submodules $config_repo $config_dir
    mv /mnt/etc/nixos/hardware-configuration.nix $config_dir/Nix/$name
    chown -R 1000:users $config_dir
    chmod 700 $config_dir
    rm /mnt/etc/nixos/configuration.nix
    ln -s ../../home/$user/config/Nix/$name/configuration.nix /mnt/etc/nixos/
    ln -s ../../home/$user/config/Nix/$name/hardware-configuration.nix /mnt/etc/nixos/
)

printf "\n\e[32m=> Installing NixOS...\e[0m\n\n"
(
    set -x
    nix-channel --add https://github.com/ejpcmac/jpc-nix/archive/master.tar.gz jpc-nix
    nix-channel --update
    nixos-install --no-root-passwd
)

printf "\n\e[32m\e[1mInstallation complete!\e[0m\n\n"
