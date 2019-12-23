;;;;;;;; MODE / PACKAGE ;;;;;;;;
(require 'package)
(package-initialize)
(ignore-errors
  (column-number-mode 1)
  (size-indication-mode 1)
  (menu-bar-mode 0) ;; from https://youtu.be/PKaJoqQQoIA?t=423
  (tool-bar-mode 0) ;; from https://youtu.be/PKaJoqQQoIA?t=423
  (scroll-bar-mode 0)
  (winner-mode 1))




;;;; auctex ;;;;
(setq TeX-view-program-selection
      (quote
       (((output-dvi has-no-display-manager)
         "dvi2tty")
        ((output-dvi style-pstricks)
         "dvips and gv")
        (output-dvi "xdvi")
        (output-pdf "Okular")
        (output-html "xdg-open"))))
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq font-latex-fontify-script nil)



;;;; ido-mode ;;;; 
(ido-mode 'buffers) ;; only buffers because of bug 36435
(setq ido-create-new-buffer 'always)
(setq ido-enable-flex-maatching t)
(defadvice ido-switch-buffer (around no-confirmation activate)
  (let ((confirm-nonexistent-file-or-buffer nil))
    ad-do-it))



;;;; elpy ;;;;
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))




;;;; buffer-move ;;;;
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)



;;;; org-mode ;;;;
(require 'org)
(global-set-key "\C-cl" 'org-store-link) 
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)
(global-set-key (kbd "C-c o o") 'jmw-org-clock-out-up)
(global-set-key (kbd "C-c o p") 'jmw-push-task)
(define-key org-mode-map
  (kbd "C-c C-w")
  'jmw-org-refile)
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(setq org-capture-templates
      '(("e"
         "Computer error"
         entry
         (file "~/core/mind/ob/thm/cs/soft/err-log.org")
         "* %U %?\n %i")
        ("i"
         "interesting thought"
         entry
         (file+headline "~/core/mind/sys/short/proc/main.org"
                        "interesting thought")
         "* %U %?\n %i")))
(setq org-refile-targets '((nil . (:maxlevel . 3))))
(setq org-agenda-window-setup 'other-window)
(setq org-agenda-restore-windows-after-quit t)
(setq org-entities-user ; special symbols
      '(("scrB" "\\scrB" t "&#x212C;" "B" "B" "ℬ") ; "script B"
        ("scrS" "\\scrS" t "&#x1D4AE;" "S" "S" "𝒮") 
        ("scrF" "\\scrF" t "&#x2131;" "F" "F" "ℱ") 
        ("RR" "\\RR" t "&#x211D;" "R" "R" "ℝ") 
        ("ZZ" "\\ZZ" t "&#x2124;" "Z" "Z" "ℤ") 
        ("CC" "\\CC" t "&#x2102;" "C" "C" "ℂ") 
        ("PP" "\\PP" t "&#x2119;" "P" "P" "ℙ") ; prob
        ("EE" "\\EE" t "&#x1D53C;" "E" "E" "𝔼") ; e.v.
        ("eps" "\\eps" t "&#x03B5;" "e" "e" "ε") 
        ("iff" "\\iff" t "&#x21D4;" "<->" "<->" "⇔") 
        ("imp" "\\imp" t "&#x21D2;" "->" "->" "⇒") 
        ("del" "\\del" t "&#x2202;" "d" "d" "∂") 
        ))
(setq org-agenda-files '("~/core/mind/sys/short/proc/main.org"))
(setq org-cycle-include-plain-lists 'integrate)
(setq org-blank-before-new-entry 
      '((heading . nil)
	(plain-list-item . nil))) 
(setq org-startup-truncated nil)
(setq org-M-RET-may-split-line
      '((headline . nil)
	(item . nil)))
(setq org-agenda-span 10)
(setq org-habit-show-habits-only-for-today nil)
(setq org-mark-ring-length 16)
(setq org-use-speed-commands t)

;(setq org-popup-calendar-for-date-prompt nil) ;; also turns off live
					      ;; display
(defun jmw-org-refile (&optional arg default-buffer rfloc msg)
  "Redefinition of `org-refile` that places the previous location
of point on the org mark ring if using the refile interface as a
goto."
  (interactive "P")
  (when (equal arg '(4))
    (org-mark-ring-push))
  (org-refile arg default-buffer rfloc msg))
;; org-clock ;;
(require 'org-clock) ;; The functions here are autoloaded, but I load it
		     ;; now to add 'org-clock-out-if-current
(setq org-clock-history-length 35)
(setq org-clock-mode-line-total 'today)
(defun jmw-org-clock-out-up ()
  "Clock out and go up a process in the stack."
  (interactive)
  (when (org-clocking-p)
    (let ((org-log-note-clock-out nil)
	  (org-clock-out-switch-to-state nil))
      (org-clock-out)))
  (pop org-clock-history)
  (let* ((marker (pop org-clock-history))
	 (buf (marker-buffer marker)))
    (switch-to-buffer buf)
    (goto-char marker)
    (org-clock-in)))
;; code copied from ~org-clock-out-if-current~
(defun jmw-org-clock-out-if-current ()
  (when (and (org-clocking-p)
	     org-clock-out-when-done
	     (marker-buffer org-clock-marker)
	     (or (and (eq t org-clock-out-when-done)
		      (member org-state org-done-keywords))
		 (and (listp org-clock-out-when-done)
		      (member org-state org-clock-out-when-done)))
	     (equal (or (buffer-base-buffer (org-clocking-buffer))
			(org-clocking-buffer))
		    (or (buffer-base-buffer (current-buffer))
			(current-buffer)))
	     (< (point) org-clock-marker)
	     (> (save-excursion (outline-next-heading) (point))
		org-clock-marker))
    (org-auto-repeat-maybe org-state)
    (jmw-org-clock-out-up)))
(add-hook 'org-after-todo-state-change-hook
	  'jmw-org-clock-out-if-current)
(remove-hook 'org-after-todo-state-change-hook
	     'org-clock-out-if-current)
(add-hook 'org-clock-goto-hook
	  (lambda ()
	    (recenter-top-bottom 18)))
(defun jmw-org-clock-goto ()
  (interactive)
  (org-overview)
  (org-clock-goto))
(global-set-key (kbd "C-c j g")
		'jmw-org-clock-goto)
(defun jmw-push-task ()
  "Push a task onto the stack."
  (interactive)
  (org-insert-todo-heading-respect-content)
  (org-do-demote))
;; org-babel ;;
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)))
(org-babel-lob-ingest "~/.emacs.d/library-of-babel.org")



;;;; bash-completion ;;;;
(require 'bash-completion)
(bash-completion-setup)



;;;; ein ;;;;
(ignore-errors 
 (require 'ein)
 (require 'ein-notebook)
 (require 'ein-subpackages))



;;;; emms ;;;;
; recommended
(require 'emms-setup)
(emms-all)
(emms-default-players)
; settings
(setq emms-source-file-default-directory "~/core/mind/env/ext")
(setq emms-repeat-playlist t)
(emms-mode-line 0)
(emms-playing-time 0)
; key bindings
; C-c e will be the emms prefix key
(global-set-key (kbd "C-c e <SPC>") 'emms-pause)
; setup to begin playing "chills"
(emms-add-directory-tree (concat
                          emms-source-file-default-directory
                          "/chills"))
(emms-shuffle)



;;;; comint-mode ;;;;
(add-hook 'comint-mode-hook ;; don't want line wrapping in REPLs
      (lambda () (setq auto-fill-function '())))



;;;; text-mode ;;;;
(add-hook 'text-mode-hook
	  (lambda () (setq fill-column 72)))



;;;; xref ;;;;
;; (setq tags-table-list '("/home/michael/extra/mind/glibc"))



;;;; ffap ;;;;
(ffap-bindings)



;;;; cc-mode ;;;;
(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))



;;;;;;;; KEY SEQUENCE ;;;;;;;;
(global-set-key (kbd "C-c j w") 'jmw-wander)
(global-set-key (kbd "C-c j s") 'jmw-safe)
(global-set-key (kbd "C-;") 'other-window)
(global-set-key "\C-x\C-h" 'hexl-find-file)
(global-set-key (kbd "C-c t s") 'jmw-run-with-timer)
(global-set-key (kbd "C-c t c") 'jmw-cancel-timer)
(global-set-key (kbd "C-c t d") 'jmw-time-left) ;; "display"








;;;;;;;; STARTUP ;;;;;;;;
;; startup set of buffers and windows
(add-to-list 'default-frame-alist '(fullscreen . fullboth))
(add-to-list 'display-buffer-alist
             `(,(regexp-quote "*shell")
             display-buffer-same-window))
(set-default-font "Ubuntu Mono-12")
(setq inhibit-startup-screen t)
(add-hook 'window-setup-hook
	  (lambda ()
	    (find-file (concat (getenv "PROC_DIR")
                               "/main.org"))
            (set-window-dedicated-p (get-buffer-window "main.org")
                                    t) 
	    (split-window-right) ; a hack. Shouldn't have to be here.
            (windmove-right)
            (shell)
            (split-window-right)
            (balance-windows)
	    ))







;;;;;;;; OTHER ;;;;;;;;
;;;; variable ;;;;
(setq make-backup-files nil)
(setq-default fill-column 72)
(setq scroll-preserve-screen-position t)
(setq tab-stop-list '(4 8))
(setq ansi-color-names-vector
      ["black" "red3" "green3" "yellow3"
       "dodger blue" "magenta3" "cyan3" "gray90"])
(setq ansi-color-map (ansi-color-make-color-map))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (manoj-dark)))
 '(package-selected-packages
   (quote
    (cdlatex htmlize emms elpy lorem-ipsum bash-completion ace-window ein w3m google-this magit utop tuareg haskell-mode julia-mode julia-repl buffer-move python-mode sage-shell-mode auctex md4rd racket-mode markdown-mode proof-general))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;;; other ;;;;
(server-start) 
(defun jmw-7z (zfile file outfile)
  (if (file-exists-p outfile)
      (progn
	(message "Preparing to compress")
        (sit-for 0.25)
	(call-process-shell-command
	 (concat "7z a -p"
		 (read-passwd "Password? " t)
		 " "
		 zfile
		 " "
		 outfile))
	(call-process-shell-command
	 (concat 
	  "shred -u "
	  outfile)))
    (progn
      (message "Preparing to extract")
      (sit-for 0.25)
      (unless (file-exists-p zfile)
        (error (concat
                "Archive file "
                zfile
                " does not exist.")))
      (while (not (eq
		   (call-process-shell-command
		    (concat "7z e -p"
			    (read-passwd "Password? ")
			    " -o"
			    (getenv "TEMP") ;; this could be an issue. Really, we want
			    ;; the dir name
			    " "
			    zfile
			    " "
			    file))
		   0))
	(message "Incorrect Password. Try again.")
	(sit-for 0.5))
      (find-file outfile))))
(defun jmw-wander ()
  (interactive)
  (jmw-7z (getenv "WANDER_ARCHIVE")
	  "wander.txt"
	  (concat (getenv "TEMP")
		  "/wander.txt")))
(defun jmw-safe ()
  (interactive)
  (jmw-7z (getenv "SAFE_ARCHIVE")
	  "safe.txt"
	  (concat (getenv "TEMP")
		  "/safe.txt")))
(defun jmw-times-up ()
  "Single function run when timer expires"
  (play-sound-file "~/core/prod/bin/other/alarm.wav"))
(defun jmw-run-with-timer (durationspec)
  (interactive "sDuration: ")
  (setq jmw-timer
	(run-with-timer (timer-duration durationspec)
			0.5
			'jmw-times-up)))
(defun jmw-find-timer (timerlist)
  (if timerlist
      (if (equal (timer--function (car timerlist))
		 'jmw-times-up)
	  (car timerlist)
	(jmw-find-timer (cdr timerlist)))
    nil))
(defun jmw-cancel-timer ()
  (interactive)
  (cancel-timer jmw-timer)
  (let ((timer (jmw-find-timer timer-list)))
    (if timer
	(setq jmw-timer timer))))
(defun jmw-time-left ()
  "Timer info. May be expanded to more than just time remaining."
  (interactive)
  (let* ((time-diff (time-subtract (timer--time jmw-timer)
				   (current-time)))
	 (floats (float-time time-diff))
	 (seconds (floor floats)))
    (message "%ss" seconds)))
