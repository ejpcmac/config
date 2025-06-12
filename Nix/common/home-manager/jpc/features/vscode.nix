################################################################################
##                                                                            ##
##             Home configuration for jpc with the VScode feature             ##
##                                                                            ##
################################################################################

{ inputs, lib, pkgs, system, ... }:

let
  libjpc = pkgs.callPackage ../lib { };
  inherit (libjpc) link;

  # Use unstable to be on the cutting edge.
  pkgs-vscode = import inputs.nixpkgs-unstable {
    inherit system;
    # Use the overlay to allow specifying which unfree extensions are allowed.
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode-extension-fill-labs-dependi"
      "vscode-extension-mhutchie-git-graph"
    ];
  };

  # Extension sources.
  open-vsx = pkgs-vscode.open-vsx;
  vscode-marketplace = pkgs-vscode.vscode-marketplace;

  # Manage extensions declaratively.
  vscodium = pkgs-vscode.vscode-with-extensions.override {
    vscode = pkgs-vscode.vscodium;

    vscodeExtensions = (with open-vsx; [
      # Get from Open VSX first.
      open-vsx."42crunch".vscode-openapi
      a5huynh.vscode-ron
      belfz.search-crates-io
      bierner.markdown-mermaid
      bpruitt-goddard.mermaid-markdown-syntax-highlighting
      cab404.vscode-direnv
      charliermarsh.ruff
      # continue.continue
      ctf0.macros
      # eamodio.gitlens
      editorconfig.editorconfig
      elixir-lsp.elixir-ls
      emmanuelbeziat.vscode-great-icons
      erlang-ls.erlang-ls
      esbenp.prettier-vscode
      fey.oscura
      fill-labs.dependi
      fwcd.kotlin
      gruntfuggly.todo-tree
      james-yu.latex-workshop
      jeanp413.open-remote-ssh
      jebbs.plantuml
      jjk.jjk
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      marus25.cortex-debug
      mcu-debug.debug-tracker-vscode
      mcu-debug.memory-view
      mcu-debug.peripheral-viewer
      mcu-debug.rtos-views
      mhutchie.git-graph
      mrorz.language-gettext
      ms-ceintl.vscode-language-pack-fr
      ms-python.mypy-type-checker
      ms-python.python
      ms-vscode.hexeditor
      myriad-dreamin.tinymist
      probe-rs.probe-rs-debugger
      rangav.vscode-thunder-client
      redhat.vscode-yaml
      rhaiscript.vscode-rhai
      rust-lang.rust-analyzer
      samuelcolvin.jinjahtml
      semanticdiff.semanticdiff
      shardulm94.trailing-spaces
      sissel.shopify-liquid
      slbtty.lisp-syntax
      # slint.slint
      stephen-hamilton-c.black-plus-material
      syler.sass-indented
      takumii.markdowntable
      tamasfe.even-better-toml
      tekumara.typos-vscode
    ]) ++ (with vscode-marketplace; [
      # Few extensions that are not available on Open VSX.
      dfoxfranke.lunaria
      dioxuslabs.dioxus
      dnut.rewrap-revived
      ms-vscode.wordcount
      valentin.beamdasm
      wengerk.highlight-bad-chars
    ]) ++ pkgs-vscode.vscode-utils.extensionsFromVscodeMarketplace [
      # Pin Vim to v1.20.3 to avoid a bug with BÉPO keyboard layout.
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.20.3";
        sha256 = "sha256-VqGm0O2OBQZjUo8jef+vZ0qkWiQSrKXShw2YuzkaQX0=";
      }
    ] ++ [
      # Nebula Oni expects a mutable installation directory to update the themes
      # from the user configuration. As the installation directory is NOT
      # mutable using nix, let’s use a fork with hardcoded themes using my
      # preferences.
      ((pkgs-vscode.vscode-utils.buildVscodeExtension rec {
        pname = "nebula-oni-theme";
        version = "1.2.3+hardcoded";

        vscodeExtPublisher = "ejpcmac";
        vscodeExtName = pname;
        vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";

        src = pkgs.fetchFromGitHub {
          owner = vscodeExtPublisher;
          repo = vscodeExtName;
          rev = "v${version}";
          hash = "sha256-GcBl2Vri/mXBDL4EaGliHBXdaCKXNBNwosucgfsR6lI=";
        };
      }).overrideAttrs (_: { sourceRoot = null; }))
    ];
  };
in

{
  ############################################################################
  ##                   Persistence & custom configuration                   ##
  ############################################################################

  home.file = {
    ".persist/VSCodium/config/User/settings.json".source = link "/config/vscode/settings.json";
    ".persist/VSCodium/config/User/keybindings.json".source = link "/config/vscode/keybindings.json";
    ".persist/VSCodium/config/User/snippets".source = link "/config/vscode/snippets";
  };

  xdg.configFile = {
    "VSCodium".source = link "/home/jpc/.persist/VSCodium/config";
  };

  ############################################################################
  #                                 Aliases                                  #
  ############################################################################

  programs = {
    git.extraConfig.core.editor = "codium --wait";

    zsh = {
      shellAliases = {
        # Open the configuration using VSCodium.
        oc = "codium /config";
      };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs-vscode; [
    # VSCodium.
    vscodium

    # Language servers and tools.
    kotlin-language-server
    nixd
    nixpkgs-fmt
    nodePackages.prettier
    probe-rs
    ruff
    rust-analyzer
  ];

  ############################################################################
  ##                         Environment variables                          ##
  ############################################################################

  home.sessionVariables = {
    TYPOS_LSP_PATH = "${pkgs-vscode.typos-lsp}/bin/typos-lsp";
  };
}
