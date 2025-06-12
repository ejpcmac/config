#!/bin/sh

for machine in helios mercure neptune philae pluton saturne; do
    printf "\n\e[32m=> Checking the configuration for $machine...\e[0m\n\n"
    (cd ./Nix/$machine && nix derivation show > /dev/null)
done
