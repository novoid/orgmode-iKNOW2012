
(add-to-list 'load-path "~/.emacs.d/src/org/lisp") ;; <- adjust
(add-to-list 'load-path "~/.emacs.d/src/org") ;; <- adjust

(require 'org-install)
(require 'org-latex)

;; this line only required until the upcomming Org-mode/Emacs24 sync
(load "~/.emacs.d/src/org/lisp/org-exp-blocks.el")


;; Configure Babel to support all languages included in the manuscript
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (org        . t)))
(setq org-confirm-babel-evaluate nil)

;; Configure Org-mode
  (setq org-export-latex-hyperref-format "\\ref{%s}")
  (setq org-entities-user '(("space" "\\ " nil " " " " " " " ")))
  (setq org-latex-to-pdf-process '("texi2dvi --clean --verbose --batch %f"))

  (require 'org-special-blocks)
  (defun org-export-latex-no-toc (depth)  
    (when depth
      (format "%% Org-mode is exporting headings to %s levels.\n"
              depth)))
  (setq org-export-latex-format-toc-function 'org-export-latex-no-toc)
  (setq org-export-pdf-remove-logfiles nil)

(org-add-link-type 
   "cite" nil
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
             (format "\\cite{%s}" path)))))

(org-add-link-type 
   "acm" nil
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
             (format "{\\%s{%s}}" path desc)))))

(add-to-list 'org-export-latex-classes
               '("acm-proc-article-sp"
                 "\\documentclass{acm_proc_article-sp}
              [NO-DEFAULT-PACKAGES]
              [EXTRA]
               \\usepackage{graphicx}
               \\usepackage{hyperref}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
