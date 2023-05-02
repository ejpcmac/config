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
     theming

     ;; Applications
     mu4e

     ;; Languages & systems
     c-c++
     elixir
     emacs-lisp
     erlang
     html
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
     org-super-agenda
     org-trello
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
   dotspacemacs-check-for-update nil
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
   dotspacemacs-default-font '("Fira Code Retina"
                               :size 15
                               :weight normal
                               :width normal
                               :powerline-scale 1.0)

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
   )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                    Hardware-specific customisations                    ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun jpc/on-machine (name)
    (string= (system-name) name))

  (defun jpc/is-docked ()
    (file-exists-p "~/.local/share/is_docked"))

  (if (and (jpc/on-machine "saturne") (jpc/is-docked))
      (setq-default dotspacemacs-default-font '("Fira Code Retina"
                                                :size 23
                                                :weight normal
                                                :width normal
                                                :powerline-scale 1.0)))
)

(defun dotspacemacs/user-init ()
  "Initialization function for user code."

  ;; Theme customisations
  (setq theming-modifications
        '((spacemacs-light
           (mu4e-cited-1-face :foreground "DodgerBlue4")
           (mu4e-cited-2-face :foreground "chartreuse4")
           (mu4e-cited-3-face :foreground "DarkOrchid4")
           (org-scheduled :foreground "DarkMagenta")
           (org-scheduled-today :height 1.0 :foreground "DarkMagenta")
           (org-agenda-done :height 1.0)
           (org-agenda-date-today :height 1.1))
          (spacemacs-dark
           (mu4e-cited-1-face :foreground "SteelBlue1")
           (mu4e-cited-2-face :foreground "chartreuse3")
           (mu4e-cited-3-face :foreground "MediumPurple")
           (org-scheduled-today :height 1.0)
           (org-agenda-done :height 1.0)
           (org-agenda-date-today :height 1.1))))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                          Fira Code Ligatures                           ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun fira-code-mode--make-alist (list)
    "Generate prettify-symbols alist from LIST."
    (let ((idx -1))
      (mapcar
       (lambda (s)
         (setq idx (1+ idx))
         (let* ((code (+ #Xe100 idx))
                (width (string-width s))
                (prefix ())
                (suffix '(?\s (Br . Br)))
                (n 1))
           (while (< n width)
             (setq prefix (append prefix '(?\s (Br . Bl))))
             (setq n (1+ n)))
           (cons s (append prefix suffix (list (decode-char 'ucs code))))))
       list)))

  (defconst fira-code-mode--ligatures
    '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
      "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
      "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
      "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
      ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
      "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
      "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
      "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
      ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
      "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
      "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
      "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
      "x" ":" "+" "+" "*"))

  (defvar fira-code-mode--old-prettify-alist)

  (defun fira-code-mode--enable ()
    "Enable Fira Code ligatures in current buffer."
    (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
    (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
    (prettify-symbols-mode t))

  (defun fira-code-mode--disable ()
    "Disable Fira Code ligatures in current buffer."
    (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
    (prettify-symbols-mode -1))

  (define-minor-mode fira-code-mode
    "Fira Code ligatures minor mode"
    :lighter " Fira Code"
    (setq-local prettify-symbols-unprettify-at-point 'right-edge)
    (if fira-code-mode
        (fira-code-mode--enable)
      (fira-code-mode--disable)))

  (defun fira-code-mode--setup ()
    "Setup Fira Code Symbols"
    (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

  (provide 'fira-code-mode)
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code."

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                         General configuration                          ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;
  ;; Enable Fira Code ligatures
  ;;

  (add-hook 'prog-mode-hook 'fira-code-mode)

  ;;
  ;; Enable modes
  ;;

  (direnv-mode)
  (org-super-agenda-mode)

  ;;
  ;; Default behaviour
  ;;

  (setq-default
   auto-fill-function 'do-auto-fill)

  ;;
  ;; Specific behaviour
  ;;

  ;; Show the line numbers and 80 characters rule in text-mode and prog-mode.
  (add-hook 'text-mode-hook 'display-line-numbers-mode)
  (add-hook 'text-mode-hook 'display-fill-column-indicator-mode)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

  ;;
  ;; Keyboard options
  ;;

  ;; Use C-s to save.
  (global-set-key (kbd "C-s") 'save-buffer)

  ;; Use C-0 to open Treemacs.
  (global-set-key (kbd "C-$") 'treemacs-select-window)

  ;; Use C-<1-5> to switch between windows.
  (global-set-key (kbd "C-\"") 'winum-select-window-1)
  (global-set-key (kbd "C-«") 'winum-select-window-2)
  (global-set-key (kbd "C-»") 'winum-select-window-3)
  (global-set-key (kbd "C-(") 'winum-select-window-4)
  (global-set-key (kbd "C-)") 'winum-select-window-5)

  ;; Make the right option key available to type symbols.
  (when (eq system-type 'darwin)
    (setq mac-right-option-modifier 'none))

  ;; Use gb and gé to switch between workspaces.
  (define-key evil-normal-state-map (kbd "gé") 'eyebrowse-next-window-config)
  (define-key evil-normal-state-map (kbd "gb") 'eyebrowse-prev-window-config)

  ;;
  ;; File modes
  ;;

  (add-to-list 'auto-mode-alist '("sxhkdrc" . conf-unix-mode))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                        Fixes for BÉPO Keyboards                        ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (define-key org-mode-map (kbd "M-c") 'org-metaleft)
  (define-key org-mode-map (kbd "M-t") 'org-metadown)
  (define-key org-mode-map (kbd "M-s") 'org-metaup)
  (define-key org-mode-map (kbd "M-r") 'org-metaright)

  (with-eval-after-load 'treemacs
    (define-key evil-treemacs-state-map (kbd "t") 'treemacs-next-line))

  (with-eval-after-load 'magit
    (define-key magit-mode-map (kbd "t") 'evil-next-visual-line)
    (define-key magit-mode-map (kbd "s") 'evil-previous-visual-line)
    (define-key magit-mode-map (kbd "k") 'magit-stage))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                                Org-mode                                ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq org-directory "~/Org"
        org-default-notes-file (concat org-directory "/Notes.org")
        org-todo-keyword-faces '(("Idée"       . "DeepSkyBlue")
                                 ("À-faire"    . "OrangeRed")
                                 ("En-cours"   . "orange")
                                 ("En-attente" . "DarkGrey")
                                 ("En-pause"   . "maroon"))
        org-highest-priority 1
        org-lowest-priority  5
        org-default-priority 3
        org-priority-faces '((?1 . "red")
                             (?2 . "LimeGreen")
                             (?3 . "DodgerBlue1")
                             (?4 . "OliveDrab")
                             (?5 . "SaddleBrown"))
        org-capture-templates '(("i" "Idée" entry
                                 (file "Perso/Idées.org")
                                 "** Idée [#3] %?\n   %a")
                                ("t" "Tâche classique" entry
                                 (file "Perso/Tâches.org")
                                 "** À-faire [#3] %?\n   SCHEDULED: %t\n   %a")
                                ("d" "Tâche à échéance" entry
                                 (file "Perso/Tâches.org")
                                 "** À-faire [#3] %?\n   DEADLINE: %t\n   %a")
                                ("e" "Événement" entry
                                 (file "Perso/Événements.org")
                                 "** %?\n   %t\n   %a"))
        org-agenda-files (list
                          (concat org-directory "/Perso")
                          (concat org-directory "/Perso/Projets"))
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-custom-commands '(("o" "Tâches occasionnelles" tags "rec")
                                     ("O" "Tâches pro occasionnelles" tags "pro:rec")
                                     ("w" "Tâches en attente" todo "En-attente")
                                     ("p" "Tâches en attente" todo "En-pause")
                                     ("i" "Idées" todo "Idée"))
        org-super-agenda-groups '((:name "Planifié"
                                         :scheduled today
                                         :scheduled past)
                                  (:name "Important"
                                         :priority "1")
                                  (:name "Organisation"
                                         :tag "org")
                                  (:name "Administratif"
                                         :tag "adm")
                                  (:name "Professionnel"
                                         :tag "pro")
                                  (:name "Social"
                                         :tag "soc")
                                  (:name "Photo"
                                         :tag "photo")
                                  (:name "Informatique"
                                         :tag ("sys" "dev" "contrib"))
                                  (:name "Entretien"
                                         :tag "entretien"))
        org-adapt-indentation t
        org-habit-graph-column 58
        org-habit-show-habits-only-for-today nil
        org-habit-show-all-today nil
        org-list-description-max-indent 5
        org-pomodoro-manual-break t
        org-pomodoro-keep-killed-pomodoro-time t
        org-startup-folded t)

  ;; Add professionnal tasks on pluton.
  (if (string= (system-name) "pluton")
      (setq org-capture-templates '(("i" "Idée" entry
                                     (file "Perso/Idées.org")
                                     "** Idée [#3] %?\n   %a")
                                    ("I" "Idée pro" entry
                                     (file "Pro/Idées Pro.org")
                                     "** Idée [#3] %?\n   %a")
                                    ("t" "Tâche classique" entry
                                     (file "Perso/Tâches.org")
                                     "** À-faire [#3] %?\n   SCHEDULED: %t\n   %a")
                                    ("T" "Tâche pro classique" entry
                                     (file "Pro/Tâches Pro.org")
                                     "** À-faire [#3] %?\n   SCHEDULED: %t\n   %a")
                                    ("d" "Tâche à échéance" entry
                                     (file "Perso/Tâches.org")
                                     "** À-faire [#3] %?\n   DEADLINE: %t\n   %a")
                                    ("D" "Tâche pro à échéance"
                                     entry (file "Pro/Tâches Pro.org")
                                     "** À-faire [#3] %?\n   DEADLINE: %t\n   %a")
                                    ("e" "Événement" entry
                                     (file "Perso/Événements.org")
                                     "** %?\n   %t\n   %a")
                                    ("E" "Événement pro"
                                     entry (file "Pro/Événements.org")
                                     "** %?\n   %t\n   %a"))
            org-agenda-files (list (concat org-directory "/Perso")
                                   (concat org-directory "/Pro")
                                   (concat org-directory "/Pro/Projets"))))

  ;;
  ;; Keyboard options
  ;;

  (global-set-key (kbd "C-+") 'org-capture)
  (global-set-key (kbd "C--") 'org-agenda-list)
  (global-set-key (kbd "C-<f8>") '(lambda (&optional arg)
                                 (interactive "P")
                                 (org-agenda arg "o")))
  (global-set-key (kbd "C-S-<f9>") '(lambda (&optional arg)
                                    (interactive "P")
                                    (org-agenda arg "O")))
  (global-set-key (kbd "C-<f6>") '(lambda (&optional arg)
                                    (interactive "P")
                                    (org-agenda arg "p")))
  (global-set-key (kbd "C-<f7>") '(lambda (&optional arg)
                                    (interactive "P")
                                    (org-agenda arg "w")))
  (global-set-key (kbd "C-<f9>") '(lambda (&optional arg)
                                    (interactive "P")
                                    (org-agenda arg "i")))

  ;; Also use C-s to save in org-agenda.
  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "C-s") '(lambda (&optional arg)
                                                   (interactive)
                                                   (org-save-all-org-buffers)
                                                   (call-process-shell-command "~/.local/bin/org-sync &"))))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;                                  mu4e                                  ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Define it here since it has been replaced by mu4e-main-buffer-name in mu4e
  ;; 1.4+, but something still needs it in my Emacs configuration (maybe in the
  ;; Spacemacs layer?).
  (defconst mu4e~main-buffer-name " *mu4e-main*"
    "*internal* Name of the mu4e main view buffer.")

  (with-eval-after-load 'mu4e
    (setq mu4e-get-mail-command "mbsync ***"
          send-mail-function 'sendmail-send-it
          message-citation-line-format "Le %A %d/%m/%Y à %T %Z, %N a écrit :\n"
          message-citation-line-function 'message-insert-formatted-citation-line
          mu4e-attachment-dir "~/Téléchargements/_Courriels"
          mu4e-change-filenames-when-moving t

          ;; Interface
          mu4e-headers-fields '((:human-date . 12)
                                (:flags . 6)
                                (:mailing-list . 10)
                                (:from . 22)
                                (:subject . 100)
                                (:maildir))
          mu4e-headers-sort-direction 'ascending
          mu4e-headers-skip-duplicates nil
          mu4e-view-show-addresses t
          mu4e-view-show-images t
          mu4e-enable-notifications t
          mu4e-enable-mode-line t

          ;; OpenPGP settings
          mml-secure-openpgp-sign-with-sender t
          mml-secure-openpgp-encrypt-to-self t)

    ;;
    ;; Contexts
    ;;

    (setq mu4e-contexts
          redacted)


    ;;
    ;; Keyboard options
    ;;

    ;; Move T to È like t is already moved to è in BÉPO evil mode.
    (define-key mu4e-headers-mode-map (kbd "È") 'mu4e-headers-mark-thread)
    (define-key mu4e-view-mode-map (kbd "È") 'mu4e-view-mark-thread)

    ;; Use C-+ and C-- for org-capture and org-agenda like everywhere else.
    (define-key mu4e-headers-mode-map (kbd "C-+") 'org-capture)
    (define-key mu4e-headers-mode-map (kbd "C--") 'org-agenda-list)
    (define-key mu4e-view-mode-map (kbd "C-+") 'org-capture)
    (define-key mu4e-view-mode-map (kbd "C--") 'org-agenda-list)

    ;; Use , to mark for refile.
    (define-key mu4e-headers-mode-map (kbd ",") 'mu4e-headers-mark-for-refile)
    (define-key mu4e-view-mode-map (kbd ",") 'mu4e-view-mark-for-refile)

    ;; Better attachment command
    (define-key mu4e-compose-mode-map (kbd "C-c C-a") 'mail-add-attachment))

  ;; Enable desktop notifications.
  (with-eval-after-load 'mu4e-alert
    (mu4e-alert-set-default-style 'notifications))
  )
