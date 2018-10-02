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

(setq package-check-signature nil)

;; Yasnippet config
(require 'yasnippet)
(yas-global-mode 1)

;; CUDA Config
;; Set .cu files to open in C mode automagically
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-mode))
;; Company
(add-hook 'after-init-hook 'global-company-mode)

;; CEDET
;;(global-ede-mode 1)
;(semantic-load-enable-code-helpers)
;(global-srecode-minor-mode 1)
(semantic-mode 1)
(require 'semantic/bovine/gcc)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(misterioso))
 '(display-time-day-and-date t)
 '(minimap-display-semantic-overlays nil)
 '(minimap-enlarge-certain-faces nil)
 '(minimap-hide-fringes t)
 '(minimap-hide-scroll-bar nil)
 '(minimap-minimum-width 10)
 '(minimap-window-location 'right)
 '(package-selected-packages
   '(pyimpsort slime slime-company counsel-ebdb hydra ivy pylint flycheck-pycheckers flycheck-pos-tip flycheck-popup-tip flycheck-pkg-config flycheck-inline flycheck-haskell flycheck-cython flycheck-color-mode-line flycheck-clojure use-package projectile lsp-haskell lsp-intellij lsp-java lsp-ui lsp-python company-lsp lsp-mode academic-phrases python csv-mode context-coloring js2-mode mu4e-maildirs-extension ht mu4e-alert mu-cite nov minimap haskell-mode magit company company-auctex company-bibtex company-c-headers company-eshell-autosuggest company-irony company-irony-c-headers company-math flycheck flycheck-clang-analyzer flycheck-clang-tidy flycheck-cstyle flycheck-irony flymake-google-cpplint iedit irony auto-complete-c-headers yasnippet auto-complete auctex))
 '(send-mail-function 'smtpmail-send-it)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "outline" :family "Courier")))))

(setq TeX-auto-save t)
(setq TeX-parse-self t)

; This sets a keybinding for the recompile command to make life easier
(global-set-key (kbd "C-M-a") 'recompile)

; Get rid of that stupid beeping
(setq visible-bell t)

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

(setq org-agenda-files nil)
(setq org-agenda-files '("/home/jbailey/Dropbox/Org/"))
(add-to-list 'org-agenda-files '"/home/jbailey/Dropbox/Academics/AME557/")
(add-to-list 'org-agenda-files '"/home/jbailey/Dropbox/Academics/AME559/")
(setq org-default-notes-file (expand-file-name "~/Org/notes.org"))

;; Org-secretary
;(load "~/.emacs.d/org-secretary")


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

;; (setq shr-external-broswer (executable-find "conkeror"))
;; (setq browse-url-generic-program (executable-find "conkeror"))

(defun xah-rename-eww-hook ()
  "Rename eww browser's buffer so sites open in a new buffer."
  (rename-buffer "eww" t))
(add-hook 'eww-mode-hook #'xah-rename-eww-hook)

;; C-u M-x eww will force a new eww buffer
(defun modi/force-new-eww-buffer (orig-fun &rest args)
  "ORIG-FUN When prefix argument is used, a new eww buffer will be created,
regardless of whether the current buffer is in `eww-mode'."
  (if current-prefix-arg
      (with-temp-buffer
        (apply orig-fun args))
    (apply orig-fun args)))
(advice-add 'eww :around #'modi/force-new-eww-buffer)

;; Other fun stuff
(setq desktop-save-mode 1)

;; (add-to-list 'load-path "~/.emacs.d/mu4e")
;; ;; mu4e configuration
;; (require 'mu4e)

;; ;; I have my "default" parameters from Gmail
;; (setq mu4e-sent-folder "/home/jbailey/Maildir/sent"
;;       ;; mu4e-sent-messages-behavior 'delete ;; Unsure how this should be configured
;;       mu4e-drafts-folder "/home/jbailey/Maildir/drafts"
;;       user-mail-address "asaxplayinghorse@gmail.com"
;;       smptmail-smtp-user "asaxplayinghorse"
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587)

;; ;; Now I set a list of 
;; (defvar my-mu4e-account-alist
;;   '(("Gmail"
;;      (mu4e-sent-folder "/Gmail/sent")
;;      (user-mail-address "asaxplayinghorse@gmail.com")
;;      (smtpmail-smtp-user "asaxplayinghorse")
;;      (smtpmail-local-domain "gmail.com")
;;      (smtpmail-default-smtp-server "smtp.gmail.com")
;;      (smtpmail-smtp-server "smtp.gmail.com")
;;      (smtpmail-smtp-service 587)
;;      )
;;      ;; Include any other accounts here ...
;;     ))

;; (defun my-mu4e-set-account ()
;;   "Set the account for composing a message.
;;    This function is taken from: 
;;      https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
;;   (let* ((account
;;     (if mu4e-compose-parent-message
;;         (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
;;     (string-match "/\\(.*?\\)/" maildir)
;;     (match-string 1 maildir))
;;       (completing-read (format "Compose with account: (%s) "
;;              (mapconcat #'(lambda (var) (car var))
;;             my-mu4e-account-alist "/"))
;;            (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
;;            nil t nil nil (caar my-mu4e-account-alist))))
;;    (account-vars (cdr (assoc account my-mu4e-account-alist))))
;;     (if account-vars
;;   (mapc #'(lambda (var)
;;       (set (car var) (cadr var)))
;;         account-vars)
;;       (error "No email account found"))))
;; (add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

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

(set-face-attribute 'default nil :font "Iosevka-14")

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;;LSP For Python
(use-package lsp-mode
  :ensure t
  :config
  
  ;; make sure we have lsp-imenu everywhere we have LSP
  (require 'lsp-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)  
  ;; get lsp-python-enable defined
  ;; NB: use either projectile-project-root or ffip-get-project-root-directory
  ;;     or any other function that can be used to find the root directory of a project
  (lsp-define-stdio-client lsp-python "python"
                           #'projectile-project-root
                           '("pyls"))

  ;; make sure this is activated when python-mode is activated
  ;; lsp-python-enable is created by macro above 
  (add-hook 'python-mode-hook
            (lambda ()
              (lsp-python-enable)))

  ;; lsp extras
  (use-package lsp-ui
    :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode))

  (use-package company-lsp
    :config
    (push 'company-lsp company-backends))

  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg))

(global-flycheck-mode 1)
;; (with-eval-after-load 'flycheck		;
;;   (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))

(use-package flycheck
 :ensure t
 :init (global-flycheck-mode))

(autoload 'pylint "pylint")
(add-hook 'python-mode-hook 'pylint-add-menu-items)
(add-hook 'python-mode-hook 'pylint-add-key-bindings)

;; This is just a convenience keybind. It's nice to have recompile
;; stuck to a single keychord
(global-set-key (kbd "C-M-a") 'recompile)

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

;(load-file "~/.emacs.d/ivy-rich.el")

(use-package ivy-rich
 :after ivy
 :custom
(ivy-virtual-abbreviate 'full
                         ivy-rich-switch-buffer-align-virtual-buffer t
                         ivy-rich-path-style 'abbrev)
 :config
 (ivy-set-display-transformer 'ivy-switch-buffer
                              'ivy-rich-switch-buffer-transformer))

(use-package swiper
 :after ivy
 :bind (("C-s" . swiper)
        ("C-r" . swiper)))

(setq global-display-line-numbers-mode t)

;Lisp/SLIME Configuraiton
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(provide '.emacs)
;;; .emacs ends here
