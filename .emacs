;;; MyEmacs --- The summary is as follows: flycheck is annoying.
;;; Commentary:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)

;;; Code:
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")))
  (add-to-list 'package-unsigned-archives (cons "melpa" (concat proto "://melpa.org/packages/")))

  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
;;(package-initialize)
(setq package-check-signature nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(display-time-day-and-date t)
 '(font-latex-fontify-sectioning 'color)
 '(minimap-display-semantic-overlays nil)
 '(minimap-enlarge-certain-faces nil)
 '(minimap-hide-fringes t)
 '(minimap-hide-scroll-bar nil)
 '(minimap-minimum-width 10)
 '(minimap-window-location 'right)
 '(package-selected-packages
   '(pdf-tools diminish slime slime-company matlab-mode magithub magit-filenotify magit-find-file magit-gerrit magit-gh-pulls magit-org-todos magit-todos counsel swiper counsel-ebdb hydra ivy pylint flycheck-pycheckers flycheck-pos-tip flycheck-popup-tip flycheck-pkg-config flycheck-inline flycheck-haskell flycheck-cython flycheck-color-mode-line flycheck-clojure use-package projectile lsp-haskell lsp-intellij lsp-java lsp-ui lsp-python company-lsp lsp-mode academic-phrases python csv-mode context-coloring js2-mode nov minimap haskell-mode magit company company-auctex company-bibtex company-c-headers company-eshell-autosuggest company-irony company-irony-c-headers company-math iedit irony auto-complete-c-headers yasnippet auto-complete auctex))
 '(send-mail-function 'smtpmail-send-it)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "outline" :family "Courier")))))
)
(require 'magit)

;; Yasnippet config
(require 'yasnippet)
(yas-global-mode 1)

;; CUDA Config
;; Set .cu files to open in C mode automagically
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-mode))
;; Company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;; IEdit
(require 'iedit)

(semantic-mode 1)
(require 'semantic/bovine/gcc)

;; Add capability to handle matlab files
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

; This sets a keybinding for the recompile command to make life easier
(global-set-key (kbd "C-M-a") 'recompile)

; Enable IDO
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)

;; Org-Mode Configuration
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cb" 'org-iswitchb)
(setq org-log-done t)

(setq org-agenda-files '("/home/jbailey/Org/"))
(setq org-default-notes-file (expand-file-name "~/Org/notes.org"))

; Make Org mode show the scheduled tasks two weeks before their deadlines.
(setq org-deadline-warning-days 14)

;; Add keybinding for imenu
(global-set-key (kbd "M-i") 'imenu)

(require 'diminish)
(diminish 'ivy-mode)
(diminish 'company-mode)
(diminish 'eldoc-mode)

;;; Configuration
;;;;;;;;;;;;;;;;;
;;
;; In short; your todos use the TODO keyword, your team's use TASK.
;; Your org-todo-keywords should look something like this:

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")
        (sequence "TASK(f)" "|" "DONE(d)")
        (sequence "MAYBE(m)" "|" "CANCELLED(c)")))

;; It helps to distinguish them by color, like this:

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "DarkOrange1" :weight bold))
        ("MAYBE" . (:foreground "sea green"))
        ("DONE" . (:foreground "light sea green"))
        ("CANCELLED" . (:foreground "forest green"))
        ("TASK" . (:foreground "light blue"))))

;; If you want to keep track of stuck projects you should tag your
;; projects with :prj:, and define:

(setq org-tags-exclude-from-inheritance '("prj")
      org-stuck-projects '("+prj/-MAYBE-DONE"
                           ("TODO" "TASK") ()))

;; Define a tag that marks TASK entries as yours:

(setq org-sec-me "jsb")

;; Finally, you add the special views to your org-agenda-custom-commands:
;;
(setq org-agenda-custom-commands
      '(("h" "Work todos" tags-todo
         "-personal-doat={.+}-dowith={.+}/!-TASK"
         ((org-agenda-todo-ignore-scheduled t)))
        ("H" "All work todos" tags-todo "-personal/!-TASK-MAYBE"
         ((org-agenda-todo-ignore-scheduled nil)))
	("A" "Work todos with doat or dowith" tags-todo
	 "-personal+doat={.+}|dowith={.+}/!-TASK"
	 ((org-agenda-todo-ignore-scheduled nil)))
	("j" "TODO dowith and TASK with"
	 ((org-sec-with-view "TODO dowith")
	  (org-sec-where-view "TODO doat")
	  (org-sec-assigned-with-view "TASK with")
	  (org-sec-stuck-with-view "STUCK with")))
	("J" "Interactive TODO dowith and TASK with"
	 ((org-sec-who-view "TODO dowith")))))

;; Custom number of days for org agenda views
(setq org-agenda-span 28)

;; EWW Configuration

(setq shr-external-broswer (executable-find "conkeror"))
(setq browse-url-generic-program (executable-find "conkeror"))

(defun xah-rename-eww-hook ()
  "Rename eww browser's buffer so sites open in a new buffer."
  (rename-buffer "eww" t))
(add-hook 'eww-mode-hook #'xah-rename-eww-hook)

;; C-u M-x eww will force a new eww buffer
(defun modi/force-new-eww-buffer (orig-fun &rest args)
  "When prefix argument is used, a new eww buffer will be created,
regardless of whether the current buffer is in `eww-mode'."
  (if current-prefix-arg
      (with-temp-buffer
        (apply orig-fun args))
    (apply orig-fun args)))  
(advice-add 'eww :around #'modi/force-new-eww-buffer)

;; Other fun stuff
(setq desktop-save-mode 1)
(setq desktop-auto-save-set-timer 60)

;; Add important files to registers on boot
(set-register ?1 '(file . "/home/jbailey/.emacs"))


;; Miscellaneous Emacs Config

(display-time-mode 1)
(setq display-time-day-and-date 1)
(defface egoge-display-time
   '((((type x w32 mac))
      ;; #060525 is the background colour of my default face.
      (:foreground "#060525" :inherit bold))
     (((type tty))
      (:foreground "blue")))
   "Face used to display the time in the mode line.")
 ;; This causes the current time in the mode line to be displayed in
 ;; `egoge-display-time-face' to make it stand out visually.
 ;; (setq display-time-string-forms
 ;;       '((propertize (concat " " 24-hours ":" minutes " ")
 ;; 		     'face 'egoge-display-time)))

 ;; display-time-mode mail notification
 (defface display-time-mail-face '((t (:background "red")))
     "If display-time-use-mail-icon is non-nil, its background colour is that
      of this face. Should be distinct from mode-line. Note that this does not seem
      to affect display-time-mail-string as claimed.")
 (setq
  display-time-mail-file "/var/mail/username"
  display-time-use-mail-icon t
  display-time-mail-face 'display-time-mail-face)
 (display-time-mode t)

(setq mu4e-view-prefer-html nil)

(setq shr-color-visible-luminance-min 90)

(defadvice org-agenda (around split-vertically activate)
  (let ((split-width-threshold 80))  ; or whatever width makes sense for you
    ad-do-it))

;;(set-face-attribute 'default nil :font "Iosevka-16")

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq ring-bell-function 'ignore)

;; This is just a convenience keybind. It's nice to have recompile
;; stuck to a single keychord
(global-set-key (kbd "C-M-a") 'recompile)
(global-set-key (quote [f5]) 'ps-print-buffer)

;; Some Ivy/Counsel configuration
(use-package counsel
  :after ivy
  :bind (("C-x C-f" . counsel-find-file)
         ("M-x" . counsel-M-x)
         ("M-y" . counsel-yank-pop)))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x b" . ivy-switch-buffer)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-display-style 'fancy)
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

;; SLIME Configuration
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(provide '.emacs)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t
      )

;; revert pdf-view after compilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;;; .emacs ends here

