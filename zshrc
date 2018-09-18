# /etc/zshrc
# Fichier de configuration principal de zsh

#####################
# Paramètres de zsh #
#####################

# Gestion de la couleur dans le PROMPT
autoload -U colors && colors

# Complétion des options des commandes
autoload -U compinit
compinit

#################
# Environnement #
#################

# Langue française et encodage UTF-8
export LANG="fr_FR.UTF-8"

# nano comme éditeur par défaut
export EDITOR="vim"

# Couleurs de `ls` (BSD)
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
#
# 1.    directory               -               blue/none       ex
# 2.    symbolic link           -               magenta/none    fx
# 3.    socket                  -               green/none      cx
# 4.    pipe                    -               brow/none       dx
# 5.    executable              -               red/none        bx
# 6.    block special           -               black/red       ab
# 7.    character special                       black/brown     ad
# 8.    executable with setuid bit              RED/grey        Bh
# 9.    executable with setgid bit              MAGENTA/grey    Fh
# 10.   directory o+w, with sticky bit          blue/grey       eh
# 11.   directory o+w, without sticky bit       cyan/grey       gh
export LSCOLORS="exfxcxdxbxabadBhFhehgh"
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=30;41:cd=30;43:su=1;31;47:sg=1;35;47:tw=34;47:ow=36;47"

##########
# Prompt #
##########

# Prompt coloré différemment selon que l’utilisateur est normal ou root
if [ "`id -u`" -eq 0 ]; then
    export PROMPT="%{$fg_bold[red]%}[%n@%M]:%{$reset_color%}%d %# "
else
    export PROMPT="%{$fg_bold[green]%}[%n@%M]:%{$reset_color%}%~ %# "
fi

# Prompt de droite affichant l’heure
export RPROMPT="%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"

########################
# Définition des Alias #
########################

# Gestion de la couleur pour 'ls' et 'grep' + 'ls' lisible par l’homme
if [ `uname` = "Linux" ]; then
    alias ls='ls -h --color=auto'   # Linux
else
    alias ls='ls -Gh'               # BSD
fi
alias tree='tree -C'
alias grep='grep --color=auto'

# Raccourcis pour 'ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'

# 'df' et 'du' lisibles
alias df='df -h'
alias du='du -h'

# Garder la version compressée pour unxz
alias unxz='unxz -kv'

# Suppression des fichiers d’emacs
alias delmacs="find . -maxdepth 1 -name '#*#' -delete -or -name '*~' -delete"

##################
# Options de zsh #
##################

# Désactivation des beeps
unsetopt beep
unsetopt hist_beep
unsetopt list_beep

# Amélioration des sélections
setopt extendedglob

# Schémas de complétion

# - Schéma A :
# 1ère tabulation : complète jusqu'au bout de la partie commune
# 2ème tabulation : propose une liste de choix
# 3ème tabulation : complète avec le 1er item de la liste
# 4ème tabulation : complète avec le 2ème item de la liste, etc...
# -> c'est le schéma de complétion par défaut de zsh.

# Schéma B :
# 1ère tabulation : propose une liste de choix et complète avec le 1er item
#                   de la liste
# 2ème tabulation : complète avec le 2ème item de la liste, etc...
# Si vous voulez ce schéma, décommentez la ligne suivante :
#setopt menu_complete

# Schéma C :
# 1ère tabulation : complète jusqu'au bout de la partie commune et
#                   propose une liste de choix
# 2ème tabulation : complète avec le 1er item de la liste
# 3ème tabulation : complète avec le 2ème item de la liste, etc...
# Ce schéma est le meilleur à mon goût !
# Si vous voulez ce schéma, décommentez la ligne suivante :
unsetopt list_ambiguous
# (Merci à Youri van Rietschoten de m'avoir donné l'info !)

############################################
# Paramètres de l'historique des commandes #
############################################

# Nombre d'entrées dans l'historique
export HISTORY=1000
export SAVEHIST=1000

# Fichier où est stocké l'historique
export HISTFILE=$HOME/.history

# Ajoute l'historique à la fin de l'ancien fichier
#setopt append_history

# Chaque ligne est ajoutée dans l'historique à mesure qu'elle est tapée
setopt inc_append_history

# Ne stocke pas  une ligne dans l'historique si elle  est identique à la
# précédente
setopt hist_ignore_dups

# Supprime les  répétitions dans le fichier  d'historique, ne conservant
# que la dernière occurrence ajoutée
#setopt hist_ignore_all_dups

# Supprime les  répétitions dans l'historique lorsqu'il  est plein, mais
# pas avant
setopt hist_expire_dups_first

# N'enregistre  pas plus d'une fois  une même ligne, quelles  que soient
# les options fixées pour la session courante
#setopt hist_save_no_dups

# La recherche dans  l'historique avec l'éditeur de commandes  de zsh ne
# montre  pas  une même  ligne  plus  d'une fois,  même  si  elle a  été
# enregistrée
setopt hist_find_no_dups
