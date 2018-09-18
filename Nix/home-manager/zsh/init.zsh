###########
# Imports #
###########

function export_local_bin() {
    if [ -z "$IN_NIX_SHELL" ]; then
        export PATH=$HOME/.local/bin:$PATH
    fi
}

# Programmes locaux nécessaires aux imports
export_local_bin

for script ($HOME/.zsh/*.zsh); do
    source $script
done
unset script

# Programmes locaux prioritaires sur les ajouts des imports
export_local_bin

#########################
# Modifications locales #
#########################

# Redéfinition du PROMPT sans le domaine
prompt_color() {
    if [ -n "$IN_NIX_SHELL" ]; then
        echo "$fg_bold[blue]"
    else
        echo "$fg_bold[green]"
    fi
}

PROMPT='%{$(prompt_color)%}[%n@%m]:%{$reset_color%}%~ %# '
