;; System Configuration ----------------------------------------
;; 
;;   Startup Performance

(setq gc-cons-threshold (* 50 1000 1000))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "*** Emacs loaded in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))

;;   Native Compilation

(setq native-comp-async-report-warnings-errors nil)

;; Package Management ----------------------------------------

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

;;   Keep .emacs.d Clean

(setq user-emacs-directory (expand-file-name "~/.cache/emacs")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

(use-package no-littering)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;;   Default Coding System

(set-default-coding-systems 'utf-8)

;;   Server Mode

(server-start)

;; Keyboard Bindings
;;
;;   ESC Cancels All

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;   Rebind C-u

(global-set-key (kbd "C-M-u") 'universal-argument)

;; Evil Mode

(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

;; Keybinding Panel

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; Use general.el to Simplify Leader Bindings

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer dj/leader-key
			  :keymaps '(normal insert visual emacs)
			  :prefix "SPC"
			  :global-prefix "C-SPC"))

;; User Interface Configuration ----------------------------------------

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

;; (menu-bar-mode -1)

(setq visible-bell t)

(setq use-dialog-box nil)

(set-frame-parameter (selected-frame) 'alpha '(95 . 95))
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(column-number-mode)

(dolist (mode '(text-mode-hook
		prog-mode-hook
		conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq display-line-numbers-type 'relative)

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(setq ad-redefinition-action 'accept)

;; Theme Configuration ----------------------------------------

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t)

  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package diminish)

;; Font Configuration ----------------------------------------

(set-face-attribute 'default nil
		    :font "FiraCode Nerd Font-11")

(set-face-attribute 'fixed-pitch nil
		    :font "FiraCode Nerd Font-11")

(set-face-attribute 'variable-pitch nil
		    :font "Cantarell-11")
		    
;; Mode Line Configuration ----------------------------------------

(use-package all-the-icons
  :if (display-graphic-p))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 35)
  (setq doom-modeline-bar-width 8)
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-lsp t)
  (setq doom-modeline-github nil)
  (setq doom-modeline-battery t)
  (setq doom-modeline-time t))

;; Network Proxy Configuration ----------------------------------------

;; (setq url-proxy-services '(("http" . "192.168.229.1:7890")
;; 			                     ("https" . "192.168.229.1:7890")))

;; Workspace Configuration ----------------------------------------


;; Auto Saving
(use-package super-save
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;; Auto Revert Changed Files
;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Highlight Matching Braces
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;; Set default connection mode to SSH
(setq tramp-default-method "ssh")

;; Editing Configuration ----------------------------------------

;; Tab Widths

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

;; Commenting

(use-package evil-commentary
  :after evil
  :init (evil-commentary-mode))

;; Automatically clean whitespace
(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

;; Set default connection mode to SSH
(setq tramp-default-method "ssh")

;; Parinfer -- For Lispy Language
(use-package parinfer-rust-mode
  :disabled
  :hook
  (clojure-mode . parinfer-rust-mode)
  (emacs-lisp-mode . parinfer-rust-mode)
  (common-lisp-mode . parinfer-rust-mode)
  (schema-mode . parinfer-rust-mode)
  (lisp-mode . parinfer-rust-mode)
  :init
  (setq parinfer-rust-auto-download t))


(use-package origami
  :hook (yaml-mode . origami-mode))

(use-package savehist
  :config
  (setq history-length 50)
  (savehist-mode 1))

(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package consult
  :demand t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-M-l" . consult-imenu)
         ("C-M-j" . persp-switch-to-buffer*)
         :map minibuffer-local-map
         ("C-r" . consult-history))
  :config
  (consult-preview-at-point-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Window Management Configuration ----------------------------------------

;; Frame Scaling/Zooming

(use-package default-text-scale
  :defer 1
  :config
  (default-text-scale-mode))

;; File Browsing

(use-package all-the-icons-dired)

;; Org Mode Configuration ----------------------------------------

(setq-default fill-column 80)

;; Turn on indentation and auto-fill mode for Org files
(defun dj/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (diminish org-indent-mode))

(use-package org
  :defer t
  :hook (org-mode . dj/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2)

  (setq org-modules
    '(org-crypt
        org-habit
        org-bookmark
        org-eshell
        org-irc))

  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))

  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup)

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (ledger . t))))

;; Development Configuration ----------------------------------------

;; Git

(use-package magit
  :commands (magit-status magit-get-current-branch))

(dj/leader-key
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

(use-package magit-todos
  :defer t)

;; Projectile

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; Programming Development Configuration ----------------------------------------

;; 1. LSP ----------------------------------------

;; Eglot -- LSP Client

;; Company -- Completion Package

;; 2. Programming Languages ----------------------------------------

;; Web Development
