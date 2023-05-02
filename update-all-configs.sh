#!/bin/sh

for machine in helios neptune philae pluton saturne; do
    printf "\n\e[32m=> Updating the inputs for $machine...\e[0m\n\n"
    (cd ./Nix/$machine && nix flake lock --update-input common)
done
