###############
# Nix Aliases #
###############

# nix-env
alias ne='nix-env'
alias ns='nix-env -qaP'
alias ni='nix-env --install'
alias nun='nix-env --uninstall'
alias nu='nix-env --upgrade'
alias nrb='nix-env --rollback'
alias neq='nix-env --query'
alias ngl='nix-env --list-generations'
alias ngs='nix-env --switch-generation'
alias ngd='nix-env --delete-generations'

# nix-channel
alias nic='nix-channel'
alias nicl='nix-channel --list'
alias nica='nix-channel --add'
alias nicr='nix-channel --remove'
alias nicu='nix-channel --update'
alias nicrb='nix-channel --rollback'

# nix-build
alias nb='nix-build'

# nix-shell
alias nis='nix-shell'
alias nisp='nix-shell --pure'
alias niss='nix-instantiate shell.nix --indirect --add-root $PWD/shell.drv'

# nix-collect-garbage
alias ngc='nix-collect-garbage'
alias ngcd='nix-collect-garbage -d'
alias ngco='nix-collect-garbage --delete-older-than 30d'

# nix-store
alias nso='nix-store --optimise -v'

# home-manager
alias h='home-manager'
alias hb='home-manager build'
alias hs='home-manager switch'
alias hp='home-manager packages'
alias hn='home-manager news'
alias hgen='home-manager generations'
