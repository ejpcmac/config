###############
# ZFS Aliases #
###############

alias z='zfs'
alias zl='zfs list -o name,used,available,referenced,usedbysnapshots,compressratio,mountpoint'
alias zls='zfs list -r -d 1 -t snapshot -o name,used,refer,compressratio'
alias zc='zfs create'
alias zs='zfs snapshot'
alias zsr='zfs snapshot -r'
alias zd='zfs destroy'
alias zmv='zfs rename'
alias zg='zfs get'
alias zst='zfs set'
alias zih='zfs inherit'
alias zm='zfs mount'
alias zum='zfs unmount'
