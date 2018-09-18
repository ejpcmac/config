# Prompt coloré différemment selon que l’utilisateur est normal ou root
autoload -U colors && colors

if [ "`id -u`" -eq 0 ]; then
    PS1="%{$fg_bold[red]%}[%n@%M]:%{$reset_color%}%d %# "
else
    PS1="%{$fg_bold[green]%}[%n@%M]:%{$reset_color%}%~ %# "
fi

RPS1="%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"
