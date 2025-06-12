###################
# Jujutsu Aliases #
###################

alias t='jj'

# Init & clone
alias ti='jj git init --colocate'
alias tcl='jj git clone --colocate'

# Information
alias ts='jj status --no-pager'
alias tl='jj log --config ui.show-cryptographic-signatures=true'
alias tla='tl -r ::'
alias tlw='watch -n 1 --color jj log --color=always --config ui.show-cryptographic-signatures=true'
alias tlaw='tlw -r ::'
alias tll='tl -T builtin_log_detailed --stat'
alias tllp='tl -T builtin_log_detailed -s --patch'
alias tlla='tll -r ::'
alias tllap='tllp -r ::'
alias tllw='tlw -T builtin_log_detailed --stat'
alias tel='jj evolog --config ui.show-cryptographic-signatures=true'
alias telp='tel -s --patch'
alias telpw='watch -n 1 --color jj evolog --color=always -s --patch --config ui.show-cryptographic-signatures=true'
alias tell='tel -T builtin_log_detailed --stat'
alias tellp='tell --patch'
alias tol='jj operation log'
alias tolp='tol -s --patch'
alias toll='tol --stat'
alias tsh='jj show --config ui.show-cryptographic-signatures=true'
alias td='jj diff'
alias tdg='jj diff --git'

# Changes
alias tn='jj new'
alias tnm='jj new main'
alias tnd='jj new develop'
alias tnw='jj new jpc/wip'
alias tns='jj new @-'
alias tnn='jj next --no-edit'
alias tnp='jj prev --no-edit'
alias tnb='jj new -B@'
alias tib='jj new -B@ && jj next --edit'
alias te='jj edit'
alias tew='jj edit jpc/wip'
alias ten='jj next --edit'
alias tep='jj prev --edit'
alias tde='jj describe'
alias tdep='jj describe @-'
alias tdemsg='jj describe --message'
alias tdera='jj describe --reset-author --no-edit'
alias tderap='tdera @-'
alias tdezp='tdez @-'
alias tc='jj commit'
alias tcz='tdez && tn'
alias tcmsg='jj commit --message'
alias tsp='jj split'
alias tspm='jj split --tool meld'
alias tsq='jj squash'
alias tsqi='jj squash -i'
alias tsqim='jj squash -i --tool meld'
alias tdup='jj duplicate'
alias trb='jj rebase'
alias trbd='jj rebase -d'
alias trbc='jj rebase -r@ -d'
alias trs='jj resolve'
alias trst='jj restore'
alias tab='jj abandon'
alias tsi='jj sign'
alias tsip='tsi -r@-'
alias tsu='jj unsign'

tdez() {
    if [[ "$(git z -V)" == "git-z 0.2.3" ]]; then
        local message
        message="$(git z commit --print-only)"

        local st=$?
        if [ $st -ne 0 ]; then
            return $st
        fi

        message=$(echo $message | sed 's/^#\(.*\)/JJ:\1/')
        jj describe $@ --edit --message "$message"
    else
        local bookmarks="$(
            jj log --no-graph -r 'heads(::@ & bookmarks())' -T 'self.bookmarks()'
        )"

        git z commit \
            --topic "$bookmarks" \
            --command "sh -c \"\
                echo -n '\$message' \
                | sed 's/^#\(.*\)/JJ:\1/' \
                | jj describe $@ --edit --stdin\" \
                "
    fi

}

# Bookmarks
alias tbl='jj bookmark list --no-pager'
alias tbla='jj bookmark list --all --no-pager'
alias tbc='jj bookmark create -r'
alias tbcc='jj bookmark create -r@'
alias tbcp='jj bookmark create -r@-'
alias tbd='jj bookmark delete'
alias tbf='jj bookmark forget'
alias tbm='jj bookmark move --to'
alias tbmf='jj bookmark move --allow-backwards --to'
alias tbmp='jj bookmark move --to=@-'
alias tbup='tbmp --from "heads(::@- & bookmarks())"'
alias tbs='jj bookmark set --to'
alias tbsf='jj bookmark set --allow-backwards --to'
alias tbr='jj bookmark rename'
alias tbt='jj bookmark track'
alias tbu='jj bookmark untrack'

# Workspaces
alias twl='jj workspace list'
alias twa='jj workspace add'
alias twr='jj workspace forget'
alias twmv='jj workspace rename'

# Remotes
alias tf='jj git fetch'
alias tfa='jj git fetch --all-remotes'
alias trl='jj git remote list'
alias tra='jj git remote add'
alias trrm='jj git remote remove'
alias trmv='jj git remote rename'
alias tp='jj git push'
alias tup='tbup && tp'
alias tpns='jj git push --config git.sign-on-push=false'
alias tpc='tp --change @-'
alias tpn='tp --allow-new --bookmark'
alias tpt='tp --tracked'
alias tpa='tp --all'
alias tpd='tp --deleted'

# Files
alias tft='jj file track'
alias tfu='jj file untrack'

# Misc
alias tu='jj undo'
alias twip='tdemsg wip && tbsf @ jpc/wip && tpn jpc/wip --config git.sign-on-push=false'
alias tdi="jj config set --repo 'revset-aliases.\"immutable_heads()\"' 'builtin_immutable_heads() | develop@origin'"
alias gg='WEBKIT_DISABLE_COMPOSITING_MODE=1 \gg'
