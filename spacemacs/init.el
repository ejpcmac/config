;; -*- mode: emacs-lisp -*-
;; Spacemacs configuration.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration."

  (setq-default
   ;; Use the full Spacemacs distrubution.
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t

   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; Global configuration
     better-defaults
     (keyboard-layout :variables kl-layout 'bepo)

     ;; Languages & systems
     c-c++
     elixir
     emacs-lisp
     erlang
     javascript
     latex
     lua
     markdown
     nixos
     org
     php
     ruby
     rust
     shell-scripts
     sql
     vimscript
     yaml

     ;; Tools
     docker
     git
     restclient
     version-control

     ;; Edition
     auto-completion
     ivy
     syntax-checking
     )

   ;; List of packages installed out of a layer.
   dotspacemacs-additional-packages '(
     direnv
     )

   ;; List of installed packages not to update.
   dotspacemacs-frozen-packages '()

   ;; List of packages to exclude.
   dotspacemacs-excluded-packages '()

   ;; Keep the Spacemacs installation clean by only installing used
   ;; packages.
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function."

  (setq-default
   ;; Package management
   dotspacemacs-check-for-update t
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-default-package-repository nil

   ;; General options
   dotspacemacs-persistent-server nil
   dotspacemacs-large-file-size 1
   dotspacemacs-smooth-scrolling t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; Aspect
   dotspacemacs-startup-banner 'official
   dotspacemacs-loading-progress-bar t
   dotspacemacs-verbose-loading nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)
   dotspacemacs-default-font '("Meslo LG S"
                               :size 12
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)

   ;; Layout
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 20
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-line-numbers '(:relative nil :disabled-for-modes dired-mode)

   ;; Keyboard
   dotspacemacs-editing-style 'vim
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-whitespace-cleanup 'all

   ;; Editing
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   ;; helm
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code."

  ;; eft-jpc specific configuration
  (if (string= (system-name) "eft-jpc")
      (setq-default
       dotspacemacs-default-font '("Meslo LG S"
                                   :size 13
                                   :weight normal
                                   :width normal
                                   :powerline-scale 1.1)))
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code."

  ;;
  ;; Enable modes
  ;;

  (direnv-mode)
  (global-git-commit-mode t)

  ;;
  ;; Default behaviour
  ;;

  (setq-default
   auto-fill-function 'do-auto-fill)

  ;;
  ;; Specific behaviour
  ;;

  ;; Show the 80 characters rule in text-mode and prog-mode.
  (add-hook 'text-mode-hook 'turn-on-fci-mode)
  (add-hook 'prog-mode-hook 'turn-on-fci-mode)

  ;;
  ;; Theme
  ;;

  ;; Use a wavy powerline only in GUI.
  (if (display-graphic-p)
      (setq powerline-default-separator 'wave)
    (setq powerline-default-separator 'nil))

  ;;
  ;; Keyboard options
  ;;

  ;; Make the right option key available to type symbols.
  (when (eq system-type 'darwin)
    (setq mac-right-option-modifier 'none))

  ;; Use T and S to scroll up and down
  (define-key evil-normal-state-map (kbd "T") 'evil-scroll-down)
  (define-key evil-normal-state-map (kbd "S") 'evil-scroll-up)

  ;;
  ;; File modes
  ;;

  (add-to-list 'auto-mode-alist '("sxhkdrc" . conf-unix-mode))
  )
