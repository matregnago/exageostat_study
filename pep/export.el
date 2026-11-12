;;; export.el --- Export infufrgs.org to LaTeX in batch mode

(load-file (expand-file-name "setup.el"))

(setq enable-local-variables nil
      org-confirm-babel-evaluate nil)

(with-current-buffer (find-file-noselect "infufrgs.org")
  (org-babel-tangle)
  (org-latex-export-to-latex))
