#!/bin/sh

for machine in helios neptune philae pluton saturne; do
    printf "\n\e[32m=> Checking the configuration for $machine...\e[0m\n\n"
    (cd ./Nix/$machine && nix show-derivation > /dev/null)
done
