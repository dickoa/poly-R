
(require 'poly-R)
(require 'polymode-test-utils)

(ert-deftest poly-r/indentation ()
  (pm-test-file-indent poly-noweb+R-mode "knitr-beamer.Rnw"))

(ert-deftest poly-r/Rd-mode-test ()
  (pm-test-run-on-file poly-rd-mode "test.Rd"
    (switch-to-buffer (current-buffer))
    (goto-char 1)
    (pm-switch-to-buffer)
    (should (eq major-mode 'Rd-mode))
    (goto-char 52)
    (pm-switch-to-buffer)
    (should (eq major-mode 'ess-r-mode))
    (goto-char 92)
    (pm-switch-to-buffer)
    (should (eq major-mode 'Rd-mode))
    (goto-char 102)
    (pm-switch-to-buffer)
    (should (eq major-mode 'ess-r-mode))))

(ert-deftest poly-r/rd-font-lock-test ()
  (pm-test-poly-lock poly-rd-mode "test.Rd"
    ((insert-delete-1 ("usage" end))
     (switch-to-buffer (current-buffer))
     (insert " ")
     (pm-test-faces)
     (delete-backward-char 1))
    ((insert-delete-2 ("^a_name" beg))
     (insert "  ")
     (delete-backward-char 1))
    ((insert-new-line-3 ("examples" end))
     (insert "\n")
     (pm-test-faces)
     (delete-backward-char 1))))

(ert-deftest poly-r/no-nested-spans ()
  (pm-test-run-on-string 'poly-markdown-mode
    "```{r load-bodipy}
cnames = tolower(cnames)
cnames = gsub('\\(', '', cnames)
cnames = gsub('aa', 'bb', cnames)
```"
    (switch-to-buffer (current-buffer))
    (goto-char 20)
    (pm-switch-to-buffer)
    (should (eq major-mode 'ess-r-mode))
    (should (equal (pm-innermost-range 20 t)
                   (cons 20 111)))
    (goto-char 78)
    (pm-switch-to-buffer)
    (should (eq major-mode 'ess-r-mode))))

(ert-deftest poly-r/after-change-extention ()
  (pm-test-poly-lock poly-markdown+R-mode "minimal.Rmd"
    ((delete-1 ("first\n```" end))
     (delete-backward-char 1)
     (pm-test-faces)
     (insert "`")
     (pm-test-faces))))

