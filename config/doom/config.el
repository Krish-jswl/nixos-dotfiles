;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; BASIC UI / EDITOR SETTINGS
(global-visual-line-mode 1)
(pixel-scroll-precision-mode 1)

(setq display-line-numbers-type 'relative)

(setq doom-font
      (font-spec :family "Iosevka Nerd Font"
                 :size 20))

;;; THEME
(setq doom-theme 'doom-tomorrow-night)

; (setq doom-gruvbox-material-background "hard"
;       doom-gruvbox-material-palette "material")

(setq org-startup-with-inline-images t)

(set-frame-parameter (selected-frame) 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

; (after! doom-themes
;   (custom-set-faces!
;     '(default :background "#282828" :foreground "#d4be98")
;
;     '(cursor :background "#d8a657")
;
;     '(fringe :background "#282828")
;
;     '(line-number
;       :background "#282828"
;       :foreground "#5a524c")
;
;     '(line-number-current-line
;       :background "#282828"
;       :foreground "#d8a657")
;
;     '(vertical-border :foreground "#3c3836")
;     '(window-divider :foreground "#3c3836")
;
;     '(region :background "#3c3836")
;
;     '(org-block :background "#32302f")
;     '(org-code :foreground "#a9b665")
;
;     '(corfu-default
;       :background "#32302f"
;       :foreground "#d4be98")
;
;     '(corfu-current
;       :background "#3c3836"
;       :foreground "#d4be98")
;
;     '(treemacs-root-face :foreground "#d8a657")
;     '(treemacs-directory-face :foreground "#7daea3")))
;
;;; ORG MODE
(setq org-directory "~/org/")

(setq org-agenda-files
      '("~/org/tasks.org"
        "~/org/inbox.org"))

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "IN-PROGRESS(i)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)")))

  (setq org-log-done 'time)
  (setq org-hide-emphasis-markers t)

  (defun my/org-journal-file ()
    (format-time-string
     (expand-file-name "journal-%Y.org" org-directory)))

  (defun my/org-datetree-location ()
    (org-datetree-find-date-create
     (calendar-current-date)))

  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "~/org/inbox.org")
           "* TODO %?\n%U\n")

          ;; ("s" "Study task" entry
          ;;  (file "~/org/tasks.org")
          ;;  "* TODO %?\nSCHEDULED: %t\n")

          ;; ("n" "Notes" entry
          ;;  (file "~/org/cs.org")
          ;;  "* %?\n%U\n")

          ("j" "Journal" entry
           (file+function
            my/org-journal-file
            my/org-datetree-location)

           "* %<%H:%M>\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n%?\n"))))

;;; COMPLETION / LSP
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides
      '((file (styles partial-completion))))

;; (after! eglot
;;   (setq completion-category-overrides
;;         '((eglot (styles orderless)))))

(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 1
        corfu-preview-current t))

(use-package! corfu-popupinfo
  :after corfu
  :config
  (corfu-popupinfo-mode 1))

;;; TREEMACS
(map! :leader
      :desc "Toggle Treemacs"
      "e e" #'treemacs)

(after! treemacs
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1))

(after! treemacs-projectile)

;;; CURSOR / MOTION
(use-package! pulsar
  :config
  (pulsar-global-mode 1))

(after! beacon
  (beacon-mode -1))

;;; INDENT GUIDES
(after! indent-bars
  (setq indent-bars-prefer-character t)
  (setq indent-bars-color '(highlight :face-bg t :blend 0.3))
  (setq indent-bars-width-frac 0.1)
  (setq indent-bars-spacing-override 2))

(add-hook 'web-mode-hook #'indent-bars-mode)

;;; LANGUAGE INDENTATION
;; C / C++
(setq-hook! '(c-ts-mode-hook c++-ts-mode-hook)
  c-ts-mode-indent-offset 4)
