###################
# Bazik ZSH theme #
###################

##
## Coloured ls
##

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

##
## Left prompt with contextual colours
##

setopt prompt_subst
autoload -U colors && colors

# Use a special colour for Nix shells.
prompt_color() {
    if [ -n "$IN_NIX_SHELL" ]; then
        echo "$fg_bold[blue]"
    else
        echo "$fg_bold[green]"
    fi
}

# Use a different prompt for root and non-root users.
if [ "`id -u`" -eq 0 ]; then
    PROMPT='%{$fg_bold[red]%}[%n@%M]:%{$reset_color%}%d %# '
else
    PROMPT='%{$(prompt_color)%}[%n@%M]:%{$reset_color%}%~ %# '
fi

##
## Right prompt with Git and the clock.
##
## (Adapted from code found at <https://gist.github.com/joshdick/4415470>.)
##

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}↑NUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}↓NUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropirate for Git remote states
parse_git_remote_state() {
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi

    if ! git diff --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

# If inside a Git repository, print its branch and state
git_prompt_string() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$(parse_git_remote_state)$GIT_PROMPT_PREFIX%{$fg[green]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX "
}

clock() {
    echo "%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"
}

# Set the right-hand prompt
RPROMPT='$(git_prompt_string)$(clock)'
