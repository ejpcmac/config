###############################
# FreeBSD Aliases & Functions #
###############################

# System update
alias upsnap='zfs snapshot -r tank/root@before-update'
alias unsnap='zfs destroy -r tank/root@before-update'
alias bsdu='freebsd-update fetch'
alias bsdi='freebsd-update install'

# Ports
alias pfu='portsnap fetch update'
alias pm='portmaster -d'
alias pma='portmaster -ad -x tmux'
alias pmo='portmaster -od'
alias pmc='portmaster --clean-distfiles --clean-packages -y'

# Jails
alias e='ezjail-admin'
alias el='ezjail-admin list'
alias ec='ezjail-admin console'
alias est='ezjail-admin start'
alias esp='ezjail-admin stop'
alias er='ezjail-admin restart'
alias jup='ezjail-admin update -P'
alias juu='ezjail-admin update -u'

# Update a jail
ju() {
    if [ $# -ne 1 ]; then
        echo "usage: ju <jail>"
        return 1
    fi

    zfs snapshot -r tank/ezjail/$1@before-update &&
    ezjail-admin console -e 'portmaster -ad' $1
    echo
    echo "You may want to run \`juo $1\` if it’s all OK."
}

# Delete the snapshot after a successful update
juo() {
    if [ $# -ne 1 ]; then
        echo "usage: juo <jail>"
        return 1
    fi

    zfs destroy -r tank/ezjail/$1@before-update &&
    echo "Snapshot deleted"
}
