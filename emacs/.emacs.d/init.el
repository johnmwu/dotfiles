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
(setq vc-follow-symlinks nil) ; ignore warning
(org-babel-load-file "~/.emacs.d/config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-auto-save nil)
 '(custom-enabled-themes (quote (manoj-dark)))
 '(package-selected-packages
   (quote
    (vterm pyim emms lorem-ipsum bash-completion ace-window w3m google-this magit utop tuareg haskell-mode julia-mode julia-repl buffer-move python-mode sage-shell-mode auctex md4rd racket-mode markdown-mode proof-general))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
