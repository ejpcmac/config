#######################
# Aliases & Functions #
#######################

# Files
alias gmod='chmod -R u=rwX,go=rX'
alias gmodg='chmod -R ug=rwX,o=rX'

# ZSH
alias zshrc='vim ~/.zshrc; . ~/.zshrc'
alias rz='. ~/.zshrc'
alias zu='upgrade_oh_my_zsh && update-zsh-plugins'
alias zi='install-zsh-plugins'

# GPG
alias gpg-e='gpg --edit-key'
alias gpg-cs='gpg --check-sigs'

# Miscellanous
alias e='code .'
alias oc='code ~/.config_files'
alias pgst='pg_ctl -l "$PGDATA/server.log" start'
alias pgsp='pg_ctl stop'
alias pgswitch='killall postgres && pgst'
alias di='diceware --fr -s 8'

# Easter Eggs
alias love='echo ❤️'

install-zsh-plugins() {
    git clone https://github.com/gusaiani/elixir-oh-my-zsh.git $ZSH_CUSTOM/plugins/elixir
    git clone https://github.com/chisui/zsh-nix-shell.git $ZSH_CUSTOM/plugins/nix-shell
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}

update-zsh-plugins() {
    current_pwd=$(pwd)

    cd $ZSH_CUSTOM/plugins
    for plugin (*~example); do
        echo "Updating $plugin..."
        cd $plugin && git pull
        cd ..
    done

    cd "$current_pwd"
}
