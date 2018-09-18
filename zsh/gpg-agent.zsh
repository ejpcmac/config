##################################
# SSH GPG Agent (Linux or macOS) #
##################################

if [ `uname` = "Linux" ]; then
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
else
    if [ -f "${HOME}/.gpg-agent-info" ]; then
        source "${HOME}/.gpg-agent-info"
        export GPG_AGENT_INFO
        export SSH_AUTH_SOCK
    fi
    export GPG_TTY=$(tty)
fi
