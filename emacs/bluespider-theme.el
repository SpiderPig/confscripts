
(deftheme bluespider
  "High-contrast Blues/greens faces on a black background.")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'bluespider
   `(default ((,class (:foreground "white" :background "black"))))
   `(cursor ((,class (:background "thistle"))))
   `(error ((,class (:foreground "salmon1"))))
   `(warning ((,class (:foreground "orange"))))
   `(success ((,class (:foreground "dark cyan"))))
   ;; Highlighting faces
   `(highlight ((,class (:foreground "white" :background "dark blue"))))
   `(region ((,class (:foreground "white" :background "#04122b"))))
   `(secondary-selection ((,class (:background "#0f0d01"))))
   `(isearch ((,class (:foreground "white" :background "dark cyan"))))
   `(lazy-highlight ((,class (:background "gray25"))))
   ;; Font lock faces
   `(font-lock-builtin-face ((,class (:foreground "pale green"))))
   `(font-lock-comment-face ((,class (:foreground "dark cyan" :italic t))))
;   `(font-lock-comment-delimiter-face ((,class (:foreground ,"blue"))))
   `(font-lock-constant-face ((,class (:foreground "turquoise"))))
   `(font-lock-doc-string-face ((,class (:foreground "#3041c4"))))
   `(font-lock-doc-face ((,class (:foreground "gray"))))
   `(font-lock-reference-face ((,class (:foreground "red"))))
   `(font-lock-function-name-face ((,class (:foreground "LightSteelBlue"))))
   `(font-lock-keyword-face ((,class (:foreground "SteelBlue"))))
   `(font-lock-negation-char-face ((,class (:foreground ,"cyan"))))
   `(font-lock-preprocessor-face ((,class (:foreground "#e3ea94"))))
   `(font-lock-string-face ((,class (:foreground "cyan"))))
   `(font-lock-type-face ((,class (:foreground "aquamarine"))))
   `(font-lock-variable-name-face ((,class (:foreground "deep sky blue"))))
   `(font-lock-warning-face ((,class (:foreground "salmon1" :bold t))))
   `(c-annotation-face ((,class (:inherit font-lock-constant-face))))
   ;; Button and link faces
   `(link ((,class (:underline t :foreground "cyan"))))
   `(link-visited ((,class (:underline t :foreground "dark cyan"))))
   ;; Gnus faces
   `(gnus-header-content ((,class (:weight normal :foreground "yellow green"))))
   `(gnus-header-from ((,class (:foreground "pale green"))))
   `(gnus-header-subject ((,class (:foreground "pale turquoise"))))
   `(gnus-header-name ((,class (:foreground "dark sea green"))))
   `(gnus-header-newsgroups ((,class (:foreground "dark khaki"))))
   ;; Message faces
   `(message-header-name ((,class (:foreground "dark turquoise"))))
   `(message-header-cc ((,class (:foreground "yellow green"))))
   `(message-header-other ((,class (:foreground "dark khaki"))))
   `(message-header-subject ((,class (:foreground "pale turquoise"))))
   `(message-header-to ((,class (:foreground "pale green"))))
   `(message-cited-text ((,class (:foreground "SpringGreen3"))))
   `(message-separator ((,class (:foreground "deep sky blue"))))
   ;; Semantic faces
   `(semantic-decoration-on-includes                  ((,class (:foreground "cyan"))))
   `(semantic-decoration-on-unknown-includes          ((,class (:underline "red"))))
   `(semantic-decoration-on-unparsed-includes         ((,class (:underline "yellow"))))
   `(semantic-decoration-on-private-members-face      ((,class (:foregroundd "yellow"))))
   `(semantic-decoration-on-protected-members-face    ((,class (:foregroundd "red"))))
   `(semantic-tag-boundary-face                       ((,class (:overline "gray"))))
   `(semantic-unmatched-syntax-face                   ((,class (:underline "yellow"))))

   `(ediff-even-diff-A ((,class (:background "#000d14" :foreground "white"))))
   `(ediff-odd-diff-A ((,class (:background "#04122b" :foreground "white"))))
   `(ediff-even-diff-B ((,class (:background "#061207" :foreground "white"))))
   `(ediff-odd-diff-B ((,class (:background "#0f0d01" :foreground "white"))))
   `(ediff-current-diff-A ((,class (:background "dark cyan" :foreground "white"))))
   `(ediff-current-diff-B ((,class (:background "dark green" :foreground "white"))))
   `(ediff-fine-diff-A ((,class (:background "cyan" :foreground "black"))))
   `(ediff-fine-diff-B ((,class (:background "green" :foreground "black"))))

;; Flyspell
    `(flyspell-duplicate           ((,class (:underline ,"orange"))))
    `(flyspell-incorrect           ((,class (:underline , "salmon1"))))

    `(dired-boring ((,class (nil))))
    `(dired-directory ((,class (:foreground "dark cyan"))))
    `(dired-executable ((,class (:foreground "deep sky blue"))))
    `(dired-flagged ((,class (nil))))
    `(dired-header ((,class (:foreground "gray20"))))
    `(dired-marked ((,class (:foreground "#e3ea94"))))
    `(dired-permissions ((,class (:foreground "gray20"))))
    `(dired-setuid ((,class (nil))))
    `(dired-socket ((,class (nil))))
    `(dired-symlink ((,class (:foreground "yellow green"))))
;; dired-ignored                                 abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; dired-mark                                    abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; dired-perm-write                              abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; dired-warning                                 abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 

 ;;; grep
    `(grep-context-face ((,class (:foreground "gray80"))))
    `(grep-error-face ((,class (:foreground "salmon1"))))
    `(grep-hit-face ((,class (:foreground "dark cyan"))))
    `(grep-match-face ((,class (:foreground "cyan"))))
    `(match ((,class (:background "black" :foreground "cyan"))))

    `(cscope-file-face ((,class (:foreground "dark cyan"))))
;; cscope-function-face                          abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; cscope-line-face                              abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; cscope-line-number-face                       abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
;; cscope-mouse-face                             abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
    `(bm-face ((,class (:background "#04122b" :foreground "white"))))
))
(provide-theme 'bluespider)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; bluespider-theme.el ends here
