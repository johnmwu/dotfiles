;; install use-package if it isn't already
(require 'package)
(when (< emacs-major-version 27) (package-initialize))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; load literate configuration
(setq vc-follow-symlinks t) ;; Answer y to "Symbolic link to
                            ;; Git-controlled source file; follow link?"
(load "~/.emacs.d/config.el")
