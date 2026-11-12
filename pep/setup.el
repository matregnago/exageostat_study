;;; setup.el --- Org-mode configuration for the infufrgs class
;; Loaded by export.el (batch) and by infufrgs.org's local variables.

(add-to-list 'load-path (file-name-directory (or load-file-name buffer-file-name)))
(require 'ox-latex)
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))
(require 'org-ref)

;; infufrgs is report-based: top-level headings are chapters.
(add-to-list 'org-latex-classes
             '("infufrgs"
               "\\documentclass{infufrgs}\n[NO-DEFAULT-PACKAGES]\n[PACKAGES]\n[EXTRA]"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))

;; The class already loads fontenc, graphicx, hyperref, babel and newtxmath.
;; Org's default amssymb clashes with newtxmath, so the infufrgs class skips
;; the default packages and only adds what the class lacks.
(setq org-latex-packages-alist
      '(("utf8" "inputenc" t ("pdflatex"))
        ("" "longtable" nil)
        ("" "wrapfig" nil)
        ("" "rotating" nil)
        ("normalem" "ulem" t)
        ("" "amsmath" t)
        ("" "capt-of" nil)
        ("" "url" t)))

;; The class sets the PDF metadata itself in \maketitle.
(setq org-latex-hyperref-template nil)

;; Org always emits \date{...}, but infufrgs' \date takes two arguments
;; ({month}{year}).  Drop Org's line; set the date with
;; #+LATEX_HEADER: \date{maio}{2027} instead.
(defun infufrgs-drop-org-date (output backend _info)
  (if (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string "^\\\\date{[^{}]*}\n" "" output)
    output))
(add-to-list 'org-export-filter-final-output-functions #'infufrgs-drop-org-date)
