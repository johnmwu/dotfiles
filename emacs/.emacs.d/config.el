  (require 'use-package-ensure)
  (setq use-package-always-ensure t)

(require 'org)

(add-to-list 'org-modules 'org-habit)

(fset 'jmw/org-prefix (make-sparse-keymap))
(global-set-key (kbd "C-c o") 'jmw/org-prefix)

(cl-defstruct jmw/run
  process-marker)

(setq jmw/run-stack '())

  (global-set-key "\C-ca" 'org-agenda)

  (setq org-agenda-span 10)
  (setq org-agenda-start-day "-4d")

  (defun jmw/org-make-habit ()
    "Turn the following heading into a habit. Schedules it for
  today with .+1d/2d repeater interval."
    (interactive)
    (let ((time (concat
		 "<"
		 (format-time-string "%F") ;; yyyy-mm-dd
		 " .+1d/2d")))
      (org-set-property "STYLE" "habit")
      (org-schedule '(1) time)))
  (define-key 'jmw/org-prefix "h" 'jmw/org-make-habit)

  (setq org-todo-keywords
	'((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANCEL(c)")))

  (setq org-todo-keyword-faces
	'(("CANCEL" . (:foreground "red" :weight bold))
	  ("WAIT" . (:foreground "yellow" :weight bold))))

  (defun jmw/ad-org-agenda-place-template (oldfun args)
    (cl-letf (((symbol-function 'delete-other-windows) 'ignore))
      (apply oldfun args)))      
  (advice-add 'org-agenda
	      :around 'jmw/ad-org-capture-place-template)
  (setq org-agenda-window-setup 'other-window)

  (setq org-agenda-window-setup 'other-window)
  (setq org-agenda-restore-windows-after-quit t)
  (setq org-agenda-files '("~/core/mind/sys/short/proc/main.org"))
  (setq org-habit-show-habits-only-for-today nil)

  (setq org-clock-history-length 35)

  (setq org-clock-mode-line-total 'today)

  (add-hook 'org-clock-goto-hook (lambda () (recenter-top-bottom 18)))

  (defun jmw/org-clock-goto ()
    (interactive)
    (select-frame-set-input-focus (jmw/main-sched-frame))
    (select-window (jmw/main-sched-window))
    (org-clock-goto))
  (define-key 'jmw/org-prefix "g" 'jmw/org-clock-goto)

  (defun jmw/push-task (task-name)
    "Push a task onto the stack."
    (interactive "sTask name: ")
    (jmw/org-clock-goto)
    (org-insert-todo-heading-respect-content)
    (org-do-demote)
    (move-end-of-line 1)
    (insert task-name)
    (org-clock-in))
  (define-key 'jmw/org-prefix "p" 'jmw/push-task)

(defun jmw/org-clock-out-up ()
  "Clock out and go up a process in the stack."
  (interactive)
  (when (org-clocking-p)
    (let ((org-log-note-clock-out nil)
	        (org-clock-out-switch-to-state nil))
	    (org-clock-out)))
  (pop org-clock-history)
  (let* ((marker (pop org-clock-history))
	       (buf (marker-buffer marker)))
    (select-window (jmw/main-sched-window))
    (goto-char marker)
    (org-clock-in)))
(define-key 'jmw/org-prefix "o" 'jmw/org-clock-out-up)

  (defun jmw/org-done ()
    (interactive)
    (jmw/org-clock-goto)
    (org-todo "DONE") 
		(jmw/org-clock-out-up))
  (define-key 'jmw/org-prefix "d" 'jmw/org-done)

  (defun jmw/org-cancel ()
    (interactive)
    (jmw/org-clock-goto)
    (org-todo "CANCEL")
		(jmw/org-clock-out-up))
  (define-key 'jmw/org-prefix "c" 'jmw/org-cancel)

;; this uses an internal function, not ideal
(defun jmw/main-sched-frame ()
  jmw/main-frame)
(defun jmw/main-sched-window ()
  (get-buffer-window "main.org" (jmw/main-sched-frame)))

(use-package ob-go)

(require 'ob-js)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
	 (python . t)
	 (C . t)
	 (shell . t)
	 (go . t)
	 (js . t)
   (java . t)))

	(org-babel-lob-ingest "~/.emacs.d/library-of-babel.org")

(setq org-confirm-babel-evaluate nil)

(setq org-src-window-setup 'other-window)

(add-to-list 'org-structure-template-alist
	     '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist
	     '("py" . "src python"))
(add-to-list 'org-structure-template-alist
	     '("sh" . "src sh"))

(setq org-src-preserve-indentation t)

(require 'org-tempo)

  (setq org-cycle-include-plain-lists 'integrate)

  (setq org-blank-before-new-entry 
	'((heading . nil)
	  (plain-list-item . nil))) 
  (setq org-M-RET-may-split-line
	'((headline . nil)
	  (item . nil)))

  (defun jmw/org-insert-creation ()
    (org-set-property "created" (format-time-string "%F %T %Z")))
  (add-hook 'org-insert-heading-hook 'jmw/org-insert-creation)

  (setq org-log-repeat nil)

  (setq org-refile-targets '((nil . (:maxlevel . 10))))

  (setq org-adapt-indentation nil)

  (global-set-key "\C-cc" 'org-capture)

(setq org-capture-templates '())

(add-to-list 'org-capture-templates
             '("e"
               "Computer error"
               entry
               (file "~/core/mind/ob/thm/cs/soft/err-log.org")
               "* %U %?\n %i"))

(add-to-list 'org-capture-templates
             '("i"
               "interesting thought"
               entry
               (file+headline "~/core/mind/sys/short/proc/main.org"
                              "interesting thought")
               "* %U %?\n %i"))

(add-to-list 'org-capture-templates
             '("g"
               "google search"
               entry
               (file+headline "~/core/mind/sys/short/proc/main.org"
                              "google search")
               "* %U %?\n %i"))

  (defun jmw/ad-org-capture-place-template (oldfun args)
    (cl-letf (((symbol-function 'delete-other-windows) 'ignore))
      (apply oldfun args)))      
  (advice-add 'org-capture-place-template
	      :around 'jmw/ad-org-capture-place-template)

  (setf (car (nthcdr 4 org-emphasis-regexp-components)) 50)
  (org-set-emph-re 'org-emphasis-regexp-components
		   org-emphasis-regexp-components)

  (setq org-emphasis-alist
	'(("*" (bold :foreground "Yellow")) ;; like highlighting
	  ("/" italic)
	  ("_" underline)
	  ("=" org-verbatim verbatim)
	  ("~" org-code verbatim)
	  ("+" (:strike-through t))))

  (defun jmw/org-comment ()
    (interactive)
    (insert "*")
    (org-time-stamp-inactive '(16))
    (insert " JMW:* "))
  (define-key 'jmw/org-prefix "ac" 'jmw/org-comment)

  (defun jmw/org-highlight-region (from to)
    (interactive "r")
    (when (use-region-p)
      (save-excursion
	(goto-char to)
	(insert "*")
	(goto-char from)
	(insert "*"))
      (deactivate-mark)
      (fill-paragraph)))
  (define-key 'jmw/org-prefix "ah" 'jmw/org-highlight-region)

  (global-set-key "\C-cl" 'org-store-link)

  (setq org-startup-truncated nil)

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
	  ("NN" "\\NN" t "&#x2115;" "N" "N" "ℕ") 
	  ("QQ" "\\QQ" t "&#x211A;" "Q" "Q" "ℚ") 
	  ))

(use-package tex
  :config
  (setf (alist-get 'output-pdf TeX-view-program-selection) '("xdg-open"))
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq font-latex-fontify-script nil)

  :defer t
  :ensure auctex)

(use-package elpy
	:defer t
	:init
	(advice-add 'python-mode :before 'elpy-enable)

	:bind (:map elpy-mode-map
							("C-c C-f" . elpy-nav-forward-block)
							("C-c C-b" . elpy-nav-backward-block))

	:config
	;; Needed to get xref-find-definitions working
	;; See https://github.com/jorgenschaefer/elpy/issues/948
	(setq elpy-rpc-backend "jedi")
	)

  (use-package buffer-move
    :bind
    (("<C-S-up>" . 'buf-move-up)
     ("<C-S-down>" . 'buf-move-down)
     ("<C-S-left>" . 'buf-move-left)
     ("<C-S-right>" . 'buf-move-right)))

  (use-package emms-setup
    :config
    (emms-all)
    (emms-default-players)
    (setq emms-source-file-default-directory "~/core/mind/env/ext")
    (setq emms-repeat-playlist t)
    (emms-mode-line 0)
    (emms-playing-time 0)
    (emms-add-directory-tree (concat
			      emms-source-file-default-directory
			      "/chills"))
    (emms-shuffle)

    :ensure emms)

  (fset 'jmw/emms-prefix (make-sparse-keymap))
  (global-set-key (kbd "C-c e") 'jmw/emms-prefix)

  (define-key 'jmw/emms-prefix (kbd "<SPC>") 'emms-pause)

(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

(global-set-key "\C-x\C-h" 'hexl-find-file)

  (use-package lorem-ipsum)

  (use-package vterm
    :config
    (setq vterm-min-window-width 50))

  (fset 'jmw/vterm-prefix (make-sparse-keymap))
  (global-set-key (kbd "C-c v") 'jmw/vterm-prefix)

  (define-key 'jmw/vterm-prefix "b" 'vterm)
  (define-key 'jmw/vterm-prefix "o" 'vterm-other-window)

(add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))

  (add-hook 'vterm-mode-hook
	    (lambda ()
	      (set-process-query-on-exit-flag
	       (get-buffer-process (current-buffer)) nil)))

  (use-package go-mode
	  :bind
	  (:map go-mode-map
	  ("M-." . godef-jump)
	  ("C-x 4 ." . godef-jump-other-window)
	  ("C-c C-d" . godoc-at-point))

	  :config
	  ;; (setq godoc-at-point-function 'godoc-gogetdoc)
	  )

  (use-package ivy)
  (ivy-mode 1)

  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")

    (setq ivy-re-builders-alist
	  '((t . ivy--regex-ignore-order)))

  (use-package counsel
    :bind (:map global-map
		("M-x" . counsel-M-x)
		("C-x C-f" . counsel-find-file)
		("M-y" . counsel-yank-pop)
		("C-h v" . counsel-describe-variable)
		("C-h f" . counsel-describe-function)
	   :map org-mode-map
	   ("C-c C-j" . counsel-org-goto))

    :config
    (setq ivy-initial-inputs-alist '(()))
    (setq counsel-find-file-at-point t))

  (defun jmw/ad-counsel-org-goto ()
    (org-mark-ring-push))
  (advice-add 'counsel-org-goto
	      :before 'jmw/ad-counsel-org-goto)
  (setq org-mark-ring-length 16)

  (use-package ivy-rich
    :config
    ;; (ivy-rich-mode 1)
    )

  (defun ivy-rich-file-size (candidate)
    (let ((fname (expand-file-name candidate ivy--directory)))
      (if (or (not (file-exists-p fname)) (file-remote-p fname))
	  ""
	(file-size-human-readable (file-attribute-size
				   (file-attributes fname))
				  "si"))))

  (plist-put ivy-rich-display-transformers-list
	     'counsel-find-file
	     '(:columns
	      ((ivy-rich-candidate
		(:width 40))
	       ;; (ivy-rich-file-user
	       ;;  (:width 4 :face font-lock-doc-face))
	       ;; (ivy-rich-file-group
	       ;;  (:width 4 :face font-lock-doc-face))
	       ;; (ivy-rich-file-modes
		;; (:width 11 :face font-lock-doc-face))
	       (ivy-rich-file-size
		(:width 6 :face font-lock-doc-face))
	       (ivy-rich-counsel-find-file-truename
		(:face font-lock-doc-face))
	       ;; (ivy-rich-file-last-modified-time
	       ;;  (:width 30 :face font-lock-doc-face))
	       )))
  (ivy-rich-set-display-transformer)

(setq ivy-rich-parse-remote-buffer nil)

(use-package exwm
  :ensure nil 
  :demand t

  :config
    (require 'exwm-systemtray)
    (exwm-systemtray-enable)
    (setq exwm-systemtray-height 16)
    (setq exwm-workspace-number 8)
  (setq exwm-input-global-keys
        `(
          ([?\s-r] . exwm-reset)
          ([?\s-w] . exwm-workspace-switch)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
          (,(kbd "C-;") . other-window)
          (,(kbd "C-'") . other-frame)
          (,(kbd "s-k") . exwm-workspace-delete)
          ))
    (setq exwm-input-simulation-keys
  	'(
  	  ([?\M-w] . [?\C-c])
  	  ([?\C-y] . [?\C-v])
  	  ))
    (setq exwm-workspace-show-all-buffers t)
    (setq exwm-layout-show-all-buffers t)
    (add-hook 'exwm-update-class-hook
  	    (lambda ()
  	      (exwm-workspace-rename-buffer exwm-class-name)))
    (setq exwm-input-prefix-keys (delete ?\C-h exwm-input-prefix-keys))
    (setq exwm-input-prefix-keys (add-to-list 'exwm-input-prefix-keys ?\C-g))
    (exwm-enable)
  (call-process-shell-command "ibus-daemon -drxR")
    (use-package desktop-environment
      :ensure nil
  
      :config
      ;; For some reason, this has to be after exwm setup
      (setq desktop-environment-update-exwm-global-keys :global)
      (desktop-environment-mode))
    (defun desktop-environment-screenshot ()
      (interactive)
      (shell-command "sleep 0.2; scrot -s '/tmp/%F_%T_$wx$h.png' -e 'xclip -selection clipboard -target image/png -i $f &>/dev/null'"))
      (setq display-time-day-and-date t)
      (setq display-time-24hr-format t)
      (setq display-time-default-load-average nil)
      (display-time-mode 1)
      (display-battery-mode 1))

  (setq custom-safe-themes t)

(use-package smart-mode-line
  :config
  (setq sml/theme 'dark)
  (setq sml/mode-width 0)
  (sml/setup)
  )

(use-package mini-modeline
  :after smart-mode-line

  :config
  (setq mini-modeline-right-padding 20)
  (line-number-mode 0)
  (defun jmw/mode-line-buffer-pos ()
    (concat 
     (number-to-string (line-number-at-pos))
     ":"
     (number-to-string (current-column))
     ))
  (setq mini-modeline-r-format
        '("" ;; mode line construct needs to start with a string
          "%e"
          mode-line-front-space
  				(:eval (jmw/mode-line-buffer-pos))
  				mode-line-position
          ;; (:eval (string-trim (format-mode-line mode-line-position)))
          mode-line-mule-info
          mode-line-client
          mode-line-modified
          mode-line-remote
  				;; empty if running in window system
          mode-line-frame-identification
          mode-line-buffer-identification
  				"   "
  				;; I guess this is for evil mode
          ;; evil-mode-line-tag
          (:eval (string-trim (format-mode-line mode-line-modes)))
  				"   "
          mode-line-misc-info
          ))
  (mini-modeline-mode t)
  )

  (use-package js2-mode
    :config
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    (setq js-indent-level 2))

(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'c++ 'c))

(defun inside-class-enum-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (up-list -1)
      (backward-sexp 1)
      (looking-back "enum[ \t]+class[ \t]+[^}]+"))))

(defun align-enum-class (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      0
    (c-lineup-topmost-intro-cont langelem)))

(defun align-enum-class-closing-brace (langelem)
  (if (inside-class-enum-p (c-langelem-pos langelem))
      '-
    '+))

(defun fix-enum-class ()
  "Setup `c++-mode' to better handle \"class enum\"."
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . align-enum-class))
  (add-to-list 'c-offsets-alist
               '(statement-cont . align-enum-class-closing-brace)))

(add-hook 'c++-mode-hook 'fix-enum-class)

(setq typescript-indent-level 2)

  (setq custom-file (concat user-emacs-directory "/custom.el"))

  (size-indication-mode 1)

(add-hook 'emacs-lisp-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(setq-default electric-indent-inhibit t)

(setq-default indent-tabs-mode nil)

(ignore-errors
  (menu-bar-mode 0) 
  (tool-bar-mode 0) 
  (scroll-bar-mode 0)
  (winner-mode 1)
  (fringe-mode 1))

  (add-to-list 'default-frame-alist '(fullscreen . fullboth))
  (set-frame-font "Ubuntu Mono-12" t t)
  (setq inhibit-startup-screen t)

	(defun jmw/exwm-standard-apps ()
		(interactive)

		(exwm-workspace-switch-create 1)
		(let ((browser (getenv "BROWSER")))
			(start-process-shell-command browser nil browser))

		(sleep-for 1)

		(exwm-workspace-switch-create 2)
		(let ((pdf-viewer (getenv "PDF_VIEWER")))
			(start-process-shell-command pdf-viewer nil pdf-viewer))

		(sleep-for 1)

		(exwm-workspace-switch-create 3)
		(start-process-shell-command "anki" nil "anki")

		(sleep-for 1)
		)

	(defun jmw/exwm-startup-apps ()
		;; if megasync doesn't detect a system tray, it'll pop up a window.
		;; sleep so it will detect a system tray
		(start-process-shell-command "megasync" nil "sleep 5; megasync")
		)

(setq jmw/init-file-list (list
	                        (getenv "JMW_EMACS_CONFIG")
                          (getenv "JMW_LATEX_CONFIG")
                          (getenv "JMW_SH_CONFIG")
	                        ))

(add-hook 'window-setup-hook
			    (lambda ()
				    (split-window-right) 
				    (split-window-right)
				    (balance-windows)
				    (dolist (fname jmw/init-file-list)
		          (find-file fname))
				    (find-file (concat (getenv "PROC_DIR")
				                       "/main.org"))
            (setq jmw/main-window (get-buffer-window "main.org"))
            (setq jmw/main-frame (selected-frame))
				    (set-window-dedicated-p jmw/main-window
							                      t) 
				    (windmove-right)
				    (vterm)
				    (windmove-right)
				    (vterm)
				    (when (member 'exwm features)
					    ;; We're using exwm
					    (jmw/exwm-startup-apps))
				    (select-window jmw/main-window))
          )

  (load-theme 'manoj-dark)

(set-face-attribute 'org-mode-line-clock
		    nil
		    :foreground "cyan3")

  (fset 'jmw/prefix (make-sparse-keymap))
  (global-set-key (kbd "C-c j") 'jmw/prefix)

  (setq make-backup-files nil)

  (setq scroll-preserve-screen-position t)

  (server-start)

  (setq-default fill-column 72)

(setq jmw/text-window-width (+ fill-column 3))
(defun jmw/resize-text-window ()
	(interactive)
	(window-resize (selected-window)
								 (- jmw/text-window-width (window-width))
								 t))

(defun jmw/split-text-window-right ()
  (interactive)
  (split-window-right)
	(sit-for 0.001)
  (windmove-right)
  (jmw/resize-text-window)
  ;; (switch-to-buffer (get-buffer-create "*scratch*"))
  )
(define-key 'jmw/prefix "3" 'jmw/split-text-window-right)

(setq-default tab-width 2)

  (global-set-key (kbd "C-;") 'other-window)
  (define-key org-mode-map (kbd "C-'") nil)
  (global-set-key (kbd "C-'") 'other-frame)

  (fset 'yes-or-no-p 'y-or-n-p)

  (defun switch-to-window-or-buffer (buffer)
    (let ((containing-window (get-buffer-window buffer t)))
      (if containing-window
	  (select-window containing-window)
	(switch-to-buffer buffer))))

(defun jmw/insert-instant ()
  (interactive)
  (org-time-stamp-inactive '(16)))
(define-key 'jmw/prefix "t" 'jmw/insert-instant)

(global-unset-key (kbd "C-z"))

  (defun jmw/7z (zfile file outfile)
    (if (file-exists-p outfile)
	;; If outfile exists, put it back into the zfile (the 7z archive)
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
      ;; Otherwise, extract it
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
			      (getenv "JMW_TEMP") 
			      " "
			      zfile
			      " "
			      file))
		     0))
	  (message "Incorrect Password. Try again.")
	  (sit-for 0.5))
	(find-file outfile))))

  (defun jmw/wander ()
    (interactive)
    (jmw/7z (getenv "WANDER_ARCHIVE")
	    "wander.txt"
	    (concat (getenv "JMW_TEMP")
		    "/wander.txt")))
  (define-key 'jmw/prefix "w" 'jmw/wander)

  (defun jmw/safe ()
    (interactive)
    (jmw/7z (getenv "SAFE_ARCHIVE")
	    "safe.org"
	    (concat (getenv "JMW_TEMP")
		    "/safe.org")))
  (define-key 'jmw/prefix "s" 'jmw/safe)

  (fset 'jmw/timer-prefix (make-sparse-keymap))
  (global-set-key (kbd "C-c t") 'jmw/timer-prefix)

  (defun jmw/run-with-timer (durationspec)
    (interactive "sDuration: ")
    (setq jmw/timer
	  (run-with-timer (timer-duration durationspec)
			  0.5
			  'jmw/times-up)))
  (define-key 'jmw/timer-prefix "s" 'jmw/run-with-timer)

  (defun jmw/times-up ()
    "Single function run when timer expires"
    (play-sound-file "~/core/prod/bin/other/alarm.wav"))

  (defun jmw/find-timer (timerlist)
    (if timerlist
	(if (equal (timer--function (car timerlist))
		   'jmw/times-up)
	    (car timerlist)
	  (jmw/find-timer (cdr timerlist)))
      nil))
  (defun jmw/cancel-timer ()
    (interactive)
    (cancel-timer jmw/timer)
    (let ((timer (jmw/find-timer timer-list)))
      (if timer
	  (setq jmw/timer timer))))
  (defun jmw/time-left ()
    "Timer info. May be expanded to more than just time remaining."
    (interactive)
    (let* ((time-diff (time-subtract (timer--time jmw/timer)
				     (current-time)))
	   (floats (float-time time-diff))
	   (seconds (floor floats)))
      (message "%ss" seconds)))
  (define-key 'jmw/timer-prefix "c" 'jmw/cancel-timer)
  (define-key 'jmw/timer-prefix "d" 'jmw/time-left) ;; "display"

(setq fst-test-001 567)
