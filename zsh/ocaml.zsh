###########################
# OCaml (Setup & Aliases) #
###########################

##
## Setup
##

if [ -z "$IN_NIX_SHELL" ]; then
    source $HOME/.opam/opam-init/init.zsh &> /dev/null || true
    eval `opam config env`
fi

##
## Aliases
##

# Opam setup
alias oget='wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s ~/.local/bin 4.07.0'
alias oia='opam install dune merlin ocp-indent'
alias oce='eval `opam config env`'

# Opam
alias o='opam'
alias os='opam switch'
alias osr='opam switch remove'
alias ol='opam list'
alias ou='opam update'
alias oi='opam install'
alias oup='opam upgrade'
alias or='opam remove -a'
