# Config

This repository contains an extract from my personal configuration framework
from which I have removed some sensitive information. This extraction being a
manual operation, it will not always be up to date to my last tweakings, but you
can get the general idea.

Sharing this here is a way to spread some ideas, some good aliases and other
various customisations I use for my everyday comfort. Enjoy! :)

## Organisation

* `Nix`
    * `common` - configuration shared between hosts.
        * `modules` – NixOS or `home-manager` modules that are not ready enough
          or too much specific to be `confkit` or proposed in NixOS or
            `home-manager`.
        * `overlays` – `nixpkgs` overlays.
        * `pkgs` – packages (maybe should I setup a proper
            [NUR](https://github.com/nix-community/NUR) at some point).
        * `res` – resource files for the configuration.
        * `system` – common system configuration, modularised to be flexible.
        * `users` – common `home-manager` configuration.
    * `saturne` – configuration for my personal PC.
    * `helios` – configuration for my home NAS.
* [`confkit`](https://github.com/ejpcmac/confkit) – my public opinionated
    configuration framework. You can also use it if you want, and even
    contribute :)
* `home-manager` – I now refer to
    [`home-manager`](https://github.com/rycee/home-manager) as a submodule
    instead of a channel. It gives me more control about the exact version I am
    using and eases the deployment or re-deployment of my configuration.
* `desktop` – some desktop environment related configuration. Some more
    configuration (`bspwn`, …) can be found under `Nix/`.
* `spacemacs` – Spacemacs configuration.
* `vscode` – VSCode settings, keybindings and snippets.

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

In December 2018 I extracted many files in a public configuration framework I
have named `confkit`. It is refered as a submodule here and you can use it
yourself if you want: while I am using the `develop` branch of it, I publish
tagged versions with a changelog. Some features that are currently only in this
repository may be extracted to confkit at some point.
