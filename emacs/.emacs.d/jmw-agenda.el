(require 'org)
(setq org-agenda-files '("~/core/mind/sys/short/proc/main.org"))
(org-agenda-list)
(org-agenda-write (concat (getenv "TEMP")
			  "/agenda.txt"))
