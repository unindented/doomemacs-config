;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Daniel Perez Alvarez"
      user-mail-address "daniel@unindented.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font
      (font-spec :family "Cascadia Code NF" :size 18 :weight 'regular)
      doom-variable-pitch-font
      (font-spec :family "Cascadia Code NF" :size 18 :weight 'regular)
      doom-big-font
      (font-spec :family "Cascadia Code NF" :size 24 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory (file-truename "~/org/"))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;
;;; Dashboard

(defun my/custom-banner ()
  (let* ((banner '("    _________________     "
                   "   |.---------------.|    "
                   "   ||               ||    "
                   "   || $ emacs_      ||    "
                   "   ||               ||    "
                   "   ||               ||    "
                   "   ||               ||    "
                   "   ||_______________||    "
                   "   /.-.-.-.-.-.-.-.-.\\    "
                   "  /.-.-.-.-.-.-.-.-.-.\\   "
                   " /.-.-.-.-.-.-.-.-.-.-.\\  "
                   "/______/_________\\______\\ "
                   "'-----------------------' "))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my/custom-banner)

;;
;;; Org

(use-package! org
  :defer t
  :init
  (map! :leader
        :desc "Previous pos in mark ring" "DEL" #'org-mark-ring-goto))

;;
;;; Org-roam

(use-package! org-roam
  :defer t
  :custom
  (org-roam-directory (file-truename "~/org/notes/"))
  :config
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-roam-capture-templates
        '(
          ;; default
          ("d" "default" plain (file "~/org/templates/default.org")
           :if-new (file+head "note_${slug}.org"
                              "#+title: ${title}\n#+hugo_bundle: note_${slug}\n#+export_file_name: index\n#+date: %u\n#+filetags: :Uncategorized:")
           :unnarrowed t)
          ;; projects
          ("p" "project" plain (file "~/org/templates/project.org")
           :if-new (file+head "project_${slug}.org"
                              "#+title: ${title}\n#+hugo_bundle: project_${slug}\n#+export_file_name: index\n#+date: %u\n#+filetags: :Project:")
           :unnarrowed t)
          ;; references
          ("b" "book" plain (file "~/org/templates/book.org")
           :if-new (file+head "reference_${slug}.org"
                              "#+title: ${title}\n#+hugo_bundle: reference_${slug}\n#+export_file_name: index\n#+date: %u\n#+filetags: :Book:")
           :unnarrowed t)
          ("k" "bookmark" plain (file "~/org/templates/bookmark.org")
           :if-new (file+head "reference_${slug}.org"
                              "#+title: ${title}\n#+hugo_bundle: reference_${slug}\n#+export_file_name: index\n#+date: %u\n#+filetags: :Bookmark:")
           :unnarrowed t)
          ("v" "video" plain (file "~/org/templates/video.org")
           :if-new (file+head "reference_${slug}.org"
                              "#+title: ${title}\n#+hugo_bundle: reference_${slug}\n#+export_file_name: index\n#+date: %u\n#+filetags: :Video:")
           :unnarrowed t)))
  (org-roam-db-autosync-mode))

;;
;;; Treemacs

(use-package! treemacs
  :defer t
  :config
  (setq treemacs-position 'right))
