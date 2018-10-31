# Config files

This repository contains an extract from my personal configuration framework
from which I have removed some sensitive information. This extraction being
currently a manual operation, it will not always be up to date to my last
tweakings, but you can get the general idea.

Sharing this here is a way to spread some ideas, some good aliases and other
various customisations I use for my everyday comfort. Enjoy! :)

## Organisation

* Root
    * `gpg.conf` - GnuPG configuration. *This file is not read by Nix.*
    * `screenrc` - tiny screen configuration. I use it only for doing UART over
        USB on macOS.
    * `tmux-*.conf` - tmux configuration.
    * `vimrc` - vim configuration.
    * `zshrc` - system-wide Zsh configuration file. *This one is not used by Nix
        but is present for outside-of-Nix configuration on FreeBSD and computers
        where Nix is installed in single-user mode.*
* `karabiner` - some configuration for Karabiner Elements, mainly to handle my
    TypeMatrix keyboard and make my Yubikey usable while my layout is in BÉPO.
* `Nix`
    * Root - main modules for the global environment, Nix, tmux, vim, XServer
        and Zsh.
    * `home-manager` - user environment configuration on several machines. The
        common part is in `common.nix`.
    * `MacBook-JP` - system environment on my Mac.
    * `nixos-test` - some tests for configuring NixOS.
    * `zsh` - some Zsh files as resources, namely general configuration and a
        custom prompt.
* `vim` - some vim configuration.
* `vscode` - VSCode settings, keybindings and snippets.
* `zsh` - my little Zsh framework, with environment configuration, aliases and
    functions sorted by modules.

## History

I started to use Zsh back in 2013 when another student introduced me to it.
Then, I started to use vim, tmux and other console tools. I was sharing by hand
any modifications between my personal computer and my server. There were only
few modifications and it did not evolve quickly at the time.

In April 2017 I started my end-of-studies internship. Keeping configuration
files up-to-date between machines started to become quite difficult, so I went
for Git. The framework started then, as I broke up my `~/.zshrc` to a few
modular files. Following this way, I started to use this Git repository for all
my configuration files, be it for tmux, vim, GnuPG and even Atom—and now VSCode.

In July 2018 I started using Nix and `home-manager` to manage my user
environment. The current state of this framework reflects this: on my Mac and
Linux computers, my user environemnt is fully handled by it. Currently, Zsh
submodules are still linked in `~/.zsh` and my main `~/.zshrc` imports them. It
may change in the future to Nix building a `~/.zshrc` concatenating these files.
I will however always keep pure Zsh files as source to maintain the
compatibility with my FreeBSD server environment.
