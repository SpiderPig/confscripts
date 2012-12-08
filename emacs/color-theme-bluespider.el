(defun color-theme-bluespider ()
  "White on Black with hilights in shades of blues"
  (interactive)
  (color-theme-install
   '(color-theme-bluespider
     ((background-color . "#000000")
     (background-mode . dark)
;;     (border-color . "#969696")
     (cursor-color . "thistle")
     (foreground-color . "white")
     (mouse-color . "white"))
;;     (fringe ((t (:background "#ffffff"))))
;;     (mode-line ((t (:foreground "#000000" :background "#e5e5e5" :box (:line-width 1)))))
;;     (mode-line-inactive ((t (:foreground "#000000" :background "#e0e0e0 ":box (:line-width 1)))))
     (region ((t (:background "#04122b"))))
     (font-lock-builtin-face ((t (:foreground "pale green"))))
     (font-lock-comment-face ((t (:foreground "dark cyan" :italic t))))
     (font-lock-constant-face ((t (:foreground "turquoise"))))
     (font-lock-function-name-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-keyword-face ((t (:foreground "SteelBlue"))))
     (font-lock-string-face ((t (:foreground "cyan"))))
     (font-lock-type-face ((t (:foreground"aquamarine"))))
     (font-lock-variable-name-face ((t (:foreground "deep sky blue"))))
     (minibuffer-prompt ((t (:foreground "aquamarine" :bold t))))
     (font-lock-warning-face ((t (:foreground "salmon1" :bold t))))
;; Semantic faces
     (semantic-decoration-on-includes                  ((t (:foreground "cyan"))))
     (semantic-decoration-on-unknown-includes          ((t (:underline "red"))))
     (semantic-decoration-on-unparsed-includes         ((t (:underline "yellow"))))
     (semantic-decoration-on-private-members-face      ((t (:foreground "yellow"))))
     (semantic-decoration-on-protected-members-face    ((t (:foreground "red"))))
     (semantic-tag-boundary-face                       ((t (:overline "gray"))))
     (semantic-unmatched-syntax-face                   ((t (:underline "yellow"))))
;; Ediff
     (ediff-even-diff-A ((t (:background "#000d14" :foreground "white"))))
     (ediff-odd-diff-A ((t (:background "#04122b" :foreground "white"))))
     (ediff-even-diff-B ((t (:background "#061207" :foreground "white"))))
     (ediff-odd-diff-B ((t (:background "#0f0d01" :foreground "white"))))
     (ediff-current-diff-A ((t (:background "dark cyan" :foreground "white"))))
     (ediff-current-diff-B ((t (:background "dark green" :foreground "white"))))
     (ediff-fine-diff-A ((t (:background "cyan" :foreground "black"))))
     (ediff-fine-diff-B ((t (:background "green" :foreground "black"))))
;; Flyspell
     (flyspell-duplicate           ((t (:underline "orange"))))
     (flyspell-incorrect           ((t (:underline "salmon1"))))

     (bm-face ((t (:background "#04122b" :foreground "white"))))
     )))
(provide 'color-theme-bluespider)
