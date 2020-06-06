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
     emacs-lisp
     markdown
     org
     ruby
     shell-scripts
     vimscript

     ;; Tools
     git
     version-control
     yaml

     ;; Edition
     auto-completion
     ivy
     )
   ;; List of packages installed out of a layer.
   dotspacemacs-additional-packages '(
     apache-mode
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
   dotspacemacs-themes '(spacemacs-light
                         spacemacs-dark)
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
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code."

  ;;
  ;; Enable modes
  ;;

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

  ;; Use C-s to save.
  (global-set-key (kbd "C-s") 'save-buffer)

  ;; Use T and S to scroll up and down
  (define-key evil-normal-state-map (kbd "T") 'evil-scroll-down)
  (define-key evil-normal-state-map (kbd "S") 'evil-scroll-up)

  ;;
  ;; File modes
  ;;

  (add-to-list 'auto-mode-alist '("httpd-.*\\.conf" . apache-mode))
  (add-to-list 'auto-mode-alist '("vhosts/.*\\.conf" . apache-mode))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby yaml-mode apache-mode insert-shebang fish-mode company-shell helm-themes helm-swoop helm-projectile helm-nixos-options helm-mode-manager helm-gitignore helm-flx helm-descbinds helm-company helm-c-yasnippet helm-ag flyspell-correct-helm ace-jump-helm-line nix-mode company-nixos-options nixos-options vimrc-mode dactyl-mode xterm-color unfill shell-pop org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download mwim multi-term htmlize gnuplot git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter flyspell-correct-ivy flyspell-correct flycheck-pos-tip pos-tip flycheck eshell-z eshell-prompt-extras esh-help diff-hl auto-dictionary smeargle orgit mmm-mode markdown-toc markdown-mode magit-gitflow gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md evil-magit magit magit-popup git-commit with-editor fuzzy company-statistics company auto-yasnippet yasnippet ac-ispell auto-complete ws-butler winum which-key wgrep volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline smex restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint ivy-hydra indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make helm helm-core google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu elisp-slime-nav dumb-jump popup f dash s diminish define-word counsel-projectile projectile pkg-info epl counsel swiper ivy column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed async aggressive-indent adaptive-wrap ace-window ace-link avy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
