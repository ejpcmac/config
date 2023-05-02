#!/bin/sh

################################################################################
##                                                                            ##
##        Bootstrap script to transform any rescue system into Philae         ##
##                                                                            ##
################################################################################

set -e
set -x

################################################################################
##                                  Options                                   ##
################################################################################

config_repo=https://gitlab.ejpcmac.net/jpc/config.git

{ set +x; } 2> /dev/null

################################################################################
##                                   Script                                   ##
################################################################################

printf "\n\e[32m=> Configuring Nix...\e[0m\n\n"
(
    set -x
    mkdir -p /etc/nix
    # Allow installing nix as root, see
    #   https://github.com/NixOS/nix/issues/936#issuecomment-475795730
    echo "build-users-group =" > /etc/nix/nix.conf
    echo -e "max-jobs = auto\nauto-optimise-store = true" >> /etc/nix/nix.conf
)

printf "\n\e[32m=> Installing Nix...\e[0m\n\n"
(
    set -x
    curl -L https://nixos.org/nix/install | sh
)

. $HOME/.nix-profile/etc/profile.d/nix.sh

printf "\n\e[32m=> Installing the dependencies for the script...\e[0m\n\n"
(
    set -x
    nix-channel --add https://nixos.org/channels/nixos-21.05 nixpkgs
    nix-channel --update
    nix-env -Ai nixpkgs.git
)

printf "\n\e[32m=> Cloning the configuration...\e[0m\n\n"
(
    set -x
    git clone --recurse-submodules $config_repo /config
)

printf "\n\e[32m=> Building Philae...\e[0m\n\n"
(
    set -x
    nix build -f '<nixpkgs/nixos>' config.system.build.kexec_tarball \
        -I nixos-config=/config/Nix/philae/configuration.nix \
        -o /result
)

printf "\n\e[32m=> Extracting Philae...\e[0m\n\n"
(
    set -x
    cd /
    tar -xf /result/tarball/nixos-system-x86_64-linux.tar.xz
)

printf "\n\e[32m=> Starting Philae...\e[0m\n\n"
(
    set -x
    /kexec_philae
)
