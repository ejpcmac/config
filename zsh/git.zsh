###############
# Git Aliases #
###############

alias glgs='glg --show-signature'
alias glol="git log --graph --pretty=format:'%Cgreen%G?%Creset %C(yellow)%h%Creset - %s%C(auto)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola='glol --all'
alias gbv='git branch -vv'
alias gba='git branch -avv'
alias gfa='git fetch --all --prune --tag'
alias gmff='git merge --ff-only'
alias grbp='git rebase -p'
alias gli='git clean -dxn -e "/.direnv/" -e "/config/"'
alias gclean='git clean -idx -e "/.direnv/" -e "/config/"'
