############################
# Elixir (Setup & Aliases) #
############################

##
## Setup
##

# Make escripts installed by Mix available.
export PATH=$PATH:$HOME/.mix/escripts

# Enable shell history.
export ERL_AFLAGS='-kernel shell_history enabled'

##
## Aliases
##

# Environment
alias P='MIX_ENV=prod'
alias RPI='MIX_TARGET=rpi'
alias RPI3='MIX_TARGET=rpi3'

# Archives installation
alias mlr='mix local.rebar'
alias mlg='mix archive.install github ejpcmac/ex_gen'
alias mlp='mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez'
alias mlnerves='mix archive.install hex nerves_bootstrap'
alias mla='mlh; mlr; mlg; mlp; mlnerves'

# Generators
alias mgs='mix xgen.std --contrib --package --license MIT'
alias mgn='mix xgen.nerves'
alias mnn='mix nerves.new'

# Dependencies
alias mdua='mix do deps.update --all, deps.unlock --unused'

# Compilation and tests
alias mtw='mix test.watch --stale'

# Archives
alias ma='mix archive'
alias mau='mix archive.uninstall'

# escripts
alias me='mix escript'
alias mei='mix escript.install'
alias meu='mix escript.uninstall'

# Remote console to local apps
alias mapp='elixir --sname app@localhost -S mix'
alias isma='iex --sname app@localhost -S mix'
alias ir='iex --sname dev --remsh app@localhost'

# Phoenix
alias phx='iex --sname app@localhost -S mix phx.server'
alias ms='elixir --sname app@localhost -S mix setup'
alias mrs='elixir --sname app@localhost -S mix reset'

# Distillery
alias mrlv='mix release --verbose'
alias mrln='mix release --no-tar'
alias mrlp='mix release --env=preprod --no-tar'
alias mrls='mix release --env=server --no-tar'

# Nerves
alias mfw='mix firmware'
alias mfwb='mix firmware.burn'
alias mfwp='mix firmware.push --user-dir priv/ssh'
alias mdfwb='mix do firmware, firmware.burn'
alias mdfwp='mix do firmware, firmware.push --user-dir priv/ssh'
alias mdgfw='mix do deps.get, firmware'
alias mdgfwb='mix do deps.get, firmware, firmware.burn'
alias mdgfwp='mix do deps.get, firmware, firmware.push --user-dir priv/ssh'

# Docs
alias mhdf='mix hex.docs fetch'
alias mhdo='mix hex.docs open --offline'

mhdu() {
    dir=$(pwd)
    cd $HOME/.hex/docs

    for package (*); do
        mix hex.docs fetch $package
    done

    cd $dir
}

# Erlang compilation log
logerl() {
    if [ $# -ne 1 ]; then
        echo "usage:\n"
        echo "    logerl <version>\n"
        return 1
    fi

    tail -f "$HOME/.asdf/plugins/erlang/kerl-home/builds/asdf_$1/otp_build_$1.log"
}
