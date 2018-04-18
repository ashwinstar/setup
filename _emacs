;Building and Using Cscope
;-------------------------
;From https://github.com/dkogan/xcscope.el
;
; git clone git@github.com:dkogan/xcscope.el.git to "~/workspace/setup/emacs/"
;
;
(load "~/workspace/setup/emacs/xcscope.el/xcscope.el")
(cscope-setup)
; After the above is loaded, open the directory (e.g. $SRC_DIR where you
; want to build the cscope database and run the cscope-index-file command
; by doing C-c s I
; Wait until the "indexing finished message appears in the cscope index
; window

; lldb integration
(load "~/workspace/setup/emacs/gud.el")

(setq column-number-mode t)

(setq-default fill-column 80)
(which-function-mode 1)
;------------------------------------------------------------------------
;
; Language-specific settings
;
; The M-[aeh] bindings are not working for C and C++ modes
;

;(setq java-mode-hook
;	'(lambda () (auto-fill-mode 1)
;		(setq fill-column 80)
;		(setq comment-column 32)
;		(define-key c-mode-map [delete] 'delete-char)
;		(define-key c-mode-map [C-delete] 'kill-word) ))


;;; C files

;; Style that matches the formatting used by
;; src/tools/pgindent/pgindent.  Many extension projects also use this
;; style.
(c-add-style "gpdb"
             '("bsd"
               (c-auto-align-backslashes . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((case-label . +)
                                   (label . -)
                                   (statement-case-open . +)))
               (fill-column . 78)
               (indent-tabs-mode . t)
               (tab-width . 4)))

(add-hook 'c-mode-hook
          (defun gpdb-c-mode-hook ()
            (when (string-match ".*gpdb.*" buffer-file-name)
              (c-set-style "gpdb")
              ;; Don't override the style we just set with the style in
              ;; `dir-locals-file'.  Emacs 23.4.1 needs this; it is obsolete,
              ;; albeit harmless, by Emacs 24.3.1.
              (set (make-local-variable 'ignored-local-variables)
                   (append '(c-file-style) ignored-local-variables)))))

(setq c++-mode-hook
	'(lambda () (auto-fill-mode 1)
		(setq fill-column 80)
		(setq comment-column 32)
		(define-key c-mode-map [delete] 'delete-char)
		(define-key c-mode-map [C-delete] 'kill-word) ))

;(setq text-mode-hook
;	'(lambda () (auto-fill-mode 1)
;		(setq fill-column 80)
;               (setq tab-width 4)
;                (setq indent-tabs-mode t)
;		(define-key text-mode-map [delete] 'delete-char)
;		(define-key text-mode-map [C-delete] 'kill-word) ))

;(setq fundamentalmode-hook
;	'(lambda () (auto-fill-mode 1)
;		(setq fill-column 80)
;		(setq tab-width 4) 
;		(setq indent-tabs-mode t)
;		(define-key fundamentalmode-map [delete] 'delete-char)
;		(define-key fundamentalmode-map [C-delete] 'kill-word) ))

;(setq c-continued-statement-offset 1)
;(setq c-argdecl-indent 0)
;(setq c-auto-newline 'T)

;Find the ctags in directory pointed by this environment variable
;Command used to build the tags
;   find . -type f -iname "*.[ch]" | etags -

(setq tags-table-list (list (getenv "SRC_DIR")))


;Load Solarized Color theme
;https://github.com/sellout/emacs-color-theme-solarized
;(add-to-list 'custom-theme-load-path "~/workspace/env/emacs/emacs-color-theme-solarized/")
;(load-theme 'solarized t)


(fset 'down-line
   [?\C-u ?1 ?\M-x ?s ?c ?r ?o ?l ?l ?- ?d ?o ?w ?n return]); C-U 1 M-x scroll-down
(global-set-key [home] 'down-line)

(fset 'up-line
   [?\C-u ?1 ?\M-x ?s ?c ?r ?o ?l ?l ?- ?u ?p return])	; C-U 1 M-x scroll-up
(global-set-key [end]  'up-line)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


; Enable spell checking for comments and strings in program
(add-hook 'prog-mode-hook 'flyspell-prog-mode)


; Enable IDO mode
;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
;(ido-mode 1)


(defun my-full-build()
  "Run full build for GPDB"
  (interactive)
  (let ((temp-comp compile-command))
    (compile "cd ${SRC_DIR}; make install -w -s;" )
    (setq compile-command temp-comp)))

(global-set-key [f5] 'my-full-build)

; follow compilation buffer
(setq compilation-scroll-output t)
(global-set-key [f6] 'shell)

; bind M-/ to find-tag for finding files
(global-set-key [?\M-/] 'find-tag)
