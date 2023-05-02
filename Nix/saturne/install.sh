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
config_dir=/config
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
    echo "auto-optimise-store = true" > ~/.config/nix/nix.conf
    echo "max-jobs = auto" >> ~/.config/nix/nix.conf
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
)

printf "\n\e[32m=> Installing the dependencies for the script...\e[0m\n\n"
(
    set -x
    nix profile install nixpkgs#git
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
        -O checksum=sha512 \
        -O compression=zstd \
        -O dnodesize=auto \
        -O normalization=formD \
        -O reservation=1G \
        -O xattr=sa \
        -O atime=off \
        -O canmount=off \
        -O devices=off \
        -O exec=off \
        -O setuid=off \
        mirror \
        /dev/mapper/ssd1 \
        /dev/mapper/ssd2
)

printf "\n\e[32m=> Creating the OS filesystems...\e[0m\n\n"
(
    set -x

    zfs create -o canmount=off -o mountpoint=legacy $zpool/local
    zfs create                                      $zpool/local/config
    zfs create                                      $zpool/local/nix

    zfs create -o canmount=off -o mountpoint=legacy $zpool/system
    zfs create -o canmount=off                      $zpool/system/data
    zfs create                                      $zpool/system/data/AccountsService
    zfs create                                      $zpool/system/data/adjtime
    zfs create                                      $zpool/system/data/boltd
    zfs create                                      $zpool/system/data/chrony
    zfs create                                      $zpool/system/data/cups
    zfs create -o canmount=off                      $zpool/system/data/docker
    zfs create                                      $zpool/system/data/docker/config
    zfs create                                      $zpool/system/data/docker/containerd
    zfs create                                      $zpool/system/data/docker/state
    zfs create                                      $zpool/system/data/fwupd
    zfs create                                      $zpool/system/data/journal
    zfs create                                      $zpool/system/data/mpd
    zfs create -o canmount=off                      $zpool/system/data/NetworkManager
    zfs create                                      $zpool/system/data/NetworkManager/connections
    zfs create                                      $zpool/system/data/NetworkManager/state
    zfs create                                      $zpool/system/data/nix-serve
    zfs create                                      $zpool/system/data/systemd
    zfs create                                      $zpool/system/data/usbmux
    zfs create                                      $zpool/system/data/utmp
    zfs create                                      $zpool/system/root

    zfs create -o canmount=off -o com.sun:auto-snapshot=true $zpool/user
    zfs create -o canmount=off -o mountpoint=/data           $zpool/user/data
    zfs create -o canmount=off -o mountpoint=/home/$user     $zpool/user/$user
    zfs create -o exec=on      -o mountpoint=/home/$user     $zpool/user/$user/modules/home
    zfs create                                               $zpool/user/$user/modules/home/.cache
)

printf "\n\e[32m=> Unmounting the automatically mounted filesystems...\e[0m\n\n"
(
    set -x
    zfs unmount -a
)

printf "\n\e[32m=> Mounting the filesystems needed for the installation...\e[0m\n\n"
(
    set -x
    mount -t tmpfs tmpfs /mnt
    mkdir -p /mnt/boot /mnt/config /mnt/nix
    mount $boot_partition /mnt/boot
    mount -t zfs $zpool/local/config /mnt/config
    mount -t zfs $zpool/local/nix /mnt/nix
)

printf "\n\e[32m=> Generating the hardware configuration...\e[0m\n\n"
(
    set -x
    nixos-generate-config --root /mnt --no-filesystems
)

printf "\n\e[32m=> Mounting the user filesystems...\e[0m\n\n"
(
    set -x
    zfs mount -a
)

function mkhome() {
    local user=$1
    local uid=$2

    local user_home=/mnt/home/$user
    local user_nix_profile=/mnt/nix/var/nix/profiles/per-user/$user
    local user_gcroots=/mnt/nix/var/nix/gcroots/per-user/$user

    mkdir -p $user_home $user_nix_profile $user_gcroots
    chown -R $uid:users $user_home $user_nix_profile $user_gcroots
    chmod 700 $user_home
}

printf "\n\e[32m=> Configuring the user homes...\e[0m\n\n"
(
    set -x
    mkhome $user 1000
)

printf "\n\e[32m=> Generating the hardware configuration...\e[0m\n\n"
(
    set -x
    nixos-generate-config --root /mnt --no-filesystems
)

printf "\n\e[32m=> Installing the configuration...\e[0m\n\n"
(
    set -x
    git clone --recurse-submodules $config_repo /mnt$config_dir
    mv /mnt/etc/nixos/hardware-configuration.nix /mnt$config_dir/Nix/$name
    chown -R 1000:users /mnt$config_dir
    chmod 700 /mnt$config_dir
    ln -s /mnt$config_dir $config_dir
)

printf "\n\e[32m=> Installing NixOS...\e[0m\n\n"
(
    set -x
    nixos-install --no-root-passwd --flake git+file:///mnt$config_dir?dir=Nix/$name#$name
)

printf "\n\e[32m\e[1mInstallation complete!\e[0m\n\n"
