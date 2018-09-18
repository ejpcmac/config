##########################
# asdf (Setup & Aliases) #
##########################

##
## Setup
##

if [[ -f $HOME/.asdf/asdf.sh && -z "$IN_NIX_SHELL" ]]; then
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
fi

##
## General aliases
##

# Setup
aget() {
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf &&
    source $HOME/.asdf/asdf.sh &&
    asdf update &&
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
}

alias a='asdf'
alias apa='asdf plugin-add'
alias apl='asdf plugin-list'
alias apla='asdf plugin-list-all'
alias apr='asdf plugin-remove'
alias apu='asdf plugin-update'
alias apua='asdf plugin-update --all'
alias ai='asdf install'
alias au='asdf uninstall'
alias acur='asdf current'
alias ag='asdf global'
alias alo='asdf local'
alias al='asdf list'
alias ala='asdf list-all'
alias ars='asdf reshim'
alias aup='asdf update'
alias aused='find ~/Programmes -name .tool-versions -exec cat {} \; | sort -u'

##
## Plugins
##

# Ruby
alias air='asdf install ruby'
alias aur='asdf uninstall ruby'
alias agr='asdf global ruby'
alias alor='asdf local ruby'
alias alr='asdf list ruby'
alias alar='asdf list-all ruby'
alias arsr='asdf reshim ruby'

# Erlang
alias aierl='asdf install erlang'
alias auerl='asdf uninstall erlang'
alias agerl='asdf global erlang'
alias aloerl='asdf local erlang'
alias alerl='asdf list erlang'
alias alaerl='asdf list-all erlang'
alias arserl='asdf reshim erlang'

# Elixir
alias aie='asdf install elixir'
alias aue='asdf uninstall elixir'
alias age='asdf global elixir'
alias aloe='asdf local elixir'
alias ale='asdf list elixir'
alias alae='asdf list-all elixir'
alias arse='asdf reshim elixir'

# node.js
alias ain='asdf install nodejs'
alias aun='asdf uninstall nodejs'
alias agn='asdf global nodejs'
alias alon='asdf local nodejs'
alias aln='asdf list nodejs'
alias alan='asdf list-all nodejs'
alias arsn='asdf reshim nodejs'
alias nia='npm i -g yarn bs-platform flow-bin uuid'
