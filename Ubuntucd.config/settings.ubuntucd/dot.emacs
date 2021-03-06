;; (setq load-path (cons "~/.emacs.d/subdirs" load-path))
(setq stack-trace-on-error t)
(load "~/.emacs.d/pkgs/subdirs")

;;(setq server-mode t)
;;load paredit minor mode
(autoload 'paredit-mode "paredit"
     "Minor mode for pseudo-structurally editing Lisp code."
   t)

;; My Information
(setq user-full-name "Harrison Teng")

;; Make TERM to be xterm so that VIM works fine in Term Mode
(setenv "TERM" "xterm")

;;Daemon config
;;http://www.wanglianghome.org/blog/2009/01/customization-tips-for-emacs-daemon.html
;;(if (and (fboundp 'daemonp) (daemonp))
;;(add-hook 'after-make-frame-functions
;;(lambda (frame)
;;(with-selected-frame frame
;;(set-fontset-font "fontset-default"
;;'chinese-gbk "AR PL UKai CN 20"))))
;;(set-fontset-font "fontset-default" 'chinese-gbk "AR PL UKai CN 20"))
(setq window-system-default-frame-alist
      '(
        ;; if frame created on x display
        (x
     (menu-bar-lines . 1)
     (tool-bar-lines . nil)
     ;; mouse
     (mouse-wheel-mode . 1)
     (mouse-wheel-follow-mouse . t)
     (mouse-avoidance-mode . 'exile)
     ;; face
     ;;(font . "文泉驿等宽微米黑 8")
	 (font . "-unknown-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
     )
        ;; if on term
        (nil
     (menu-bar-lines . 0) (tool-bar-lines . 0)
      (background-color . "black")
      (foreground-color . "white")
     )
    )
      )

;; Chinese environment settings.
(set-language-environment 'Chinese-GB)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)

;; Transaparency
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

;;Melpa
(when (>= emacs-major-version 24)
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
)
;;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
;;set-frame-parameter (selected-frame) 'alpha '(85 50))
;;(add-to-list 'default-frame-alist '(alpha 85 50))
;;
;;eval-when-compile (require 'cl))
;;(defun toggle-transparency ()
;;  (interactive)
;;  (if (/=
;;       (cadr (frame-parameter nil 'alpha))
;;       100)
;;      (set-frame-parameter nil 'alpha '(100 100))
;;    (set-frame-parameter nil 'alpha '(85 50))))
;;(global-set-key (kbd "C-c t") 'toggle-transparency)

;;winner-mode
(when (fboundp 'winner-mode)
      (winner-mode 1))

;;org mode
;;(setq load-path (cons "~/.emacs.d/pkgs/org-7.7/contrib/lisp" load-path))
;;add same level title, M-RET
;;fold/collapse, TAB
;;table ,|A|B|C , C-c RET, auto add next line in table
;;add timestamp, M-x my-insert-date or C-c .
;;C-c C-s|d schedule|deadline
;;C-c a L List by Tag
;;C-c , [A]B|C] set priority and shift up/down to pro/de mote priority
;;C-c C-x C-c set column view and q quit it
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-todo-keyword-faces '(("TODO" . (:foreground "white" :weight bold))
				("INPROGRESS" . (:foreground "forest green" :weight bold))
				("VERIFY" . (:foreground "gold" :weight bold)) 
							   ("DONE" . (:foreground "green" :weight bold)) 
							    ("PENDING" . (:foreground "OrangeRed" :weight bold)) 
							   ("CANCELED" . (:foreground "red" :weight bold)) 
							   ))

(setq org-todo-keywords
             '((sequence "TODO" "INPROGRESS" "VERIFY" "|" "PENDING" "DONE" "CANCELED")))

(setq org-tag-alist '(("@my" . ?m) ("@other" . ?o) ("@vip" . ?v)))

(setq org-highest-priority ?A) 
(setq org-lowest-priority ?E) 
(setq org-default-priority ?E) 
;; appearance 
(setq org-priority-faces '((?A . (:background "red" :foreground "white" :weight bold)) 
						   (?B . (:background "DarkOrange" :foreground "white" :weight bold)) 
						   (?C . (:background "yellow" :foreground "DarkGreen" :weight bold)) 
						   (?D . (:background "DodgerBlue" :foreground "black" :weight bold)) 
						   (?E . (:background "SkyBlue" :foreground "black" :weight bold)) ))

;;If you would like a TODO entry to automatically change to DONE when all children are done, you can use the following setup:
(defun org-summary-todo (n-done n-not-done)
       "Switch entry to DONE when all subentries are done, to TODO otherwise."
       (let (org-log-done org-log-states)   ; turn off logging
         (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
     
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;;Sample
;;* org-mode configuration
;;#+STARTUP: OVERVIEW
;;#+PROPERTY: CLOCK_INTO_DRAWER t 
;;#+TAGS: { LEARNING(l) LISP C FUCK-GFW EMACS TEX EMULATOR PYTHON BLOG }
;;#+STARTUP: hidestars
;;
;;  [[http://www.mastermindcn.com/2012/02/org_mode_quite_a_life/][where this file come from]]
;;* Inbox [100%]
;;** DONE Interface C: momory interface
;;   CLOSED: [2012-11-09 Fri 11:30] SCHEDULED: <2012-11-08 thu="thu">
;;* Tasks [16%]
;;** TODO [#B] learning org-mode                                     :LEARNING:
;;   SCHEDULED: <2012-10-26 Fri>
;;   :LOGBOOK:
;;   CLOCK: [2012-11-09 Fri 09:39]--[2012-11-09 Fri 10:24] =>;  0:45
;;   CLOCK: [2012-11-09 Fri 08:18]--[2012-11-09 Fri 08:52] =>;  0:34
;;   :END:
;;** TODO [#A] Common lisp [50%]                                         :LISP:
;;*** TODO shoutcast protocal
;;    :LOGBOOK:
;;    CLOCK: [2012-11-07 Wed 20:49]--[2012-11-07 Wed 21:50] =>  1:01
;;    CLOCK: [2012-11-07 Wed 15:22]--[2012-11-07 Wed 16:37] =>  1:15
;;    :END:
;;*** DONE database 
;;    CLOSED: [2012-11-07 Wed 16:04] SCHEDULED: <2012-10-26 Fri>
;;    :LOGBOOK:
;;    CLOCK: [2012-11-07 Wed 15:13]--[2012-11-07 Wed 15:21] =>  0:08
;;    :END:
;;* Routines
;;** TODO Japanese Learning
;;   SCHEDULED: <2012-10-22 Mon +1d>
;;   - State "DONE"       from "TODO"       [2012-11-07 Wed 14:31]
;;   - State "DONE"       from "TODO"       [2012-11-05 Mon 11:27]
;;   - State "DONE"       from "TODO"       [2012-11-05 Mon 11:26]
;;   :LOGBOOK:
;;   CLOCK: [2012-11-07 Wed 12:36]--[2012-11-07 Wed 14:30] =>  1:54
;;   :END:
;;   :PROPERTIES:
;;   :LAST_REPEAT: [2012-11-07 Wed 14:31]
;;   :END:
;;* Remind
;;*** TODO Weekly Review 
;;    SCHEDULED: <2012-11-11 Sun +1w>
;;*** TODO Internet bill repayment
;;    DEADLINE: <2012-11-20 Tue>
;;* Reading
;;** TODO 汉史
;;** TODO 明史
;;** TODO 清史
;;** TODO TCP/IP stevens
;;   :LOGBOOK:
;;   CLOCK: [2012-11-04 Sun 11:05]--[2012-11-04 Sun 11:10] =>  0:05
;;   :END:
;;** Security Engineering by Ross Anderson
;;   :LOGBOOK:
;;   CLOCK: [2012-11-08 Thu 14:05]--[2012-11-08 Thu 15:58] =>  1:53
;;   CLOCK: [2012-11-08 Thu 10:43]--[2012-11-08 Thu 12:10] =>  1:27
;;   :END:
;;* Daily Review
;;#+BEGIN: clocktable :maxlevel 5 :scope agenda-with-archives :block day :fileskip0 t :indent t
;;Clock summary at [2012-11-09 Fri 11:32], for Friday, November 09, 2012.
;;
;;| File     | Headline                        | Time   |      |
;;|----------+---------------------------------+--------+------|
;;|          | ALL *Total time*                | *1:19* |      |
;;|----------+---------------------------------+--------+------|
;;| todo.org | *File time*                     | *1:19* |      |
;;|          | Tasks [16%]                     | 1:19   |      |
;;|          | \__ TODO [#B] learning org-mode |        | 1:19 |
;;#+END:
;;* Weekly Review 
;;#+BEGIN: clocktable :maxlevel 5 :scope agenda-with-archives :block thisweek :fileskip0 t :indent t
;;#+END:

;;==== End of orgmode ======
;; Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(setq preferred-debugger-alist 
      '((c-mode . gdb) 
	(c++-mode . gdb)
	(cperl-mode . perldb)
	;;(jde-mode . jdb)
	))


;; zooming; http://emacs-fu.blogspot.com/2008/12/zooming-inout.html
(
   defun harrison-zoom (n) (interactive)
   (
      set-face-attribute 'default (selected-frame) :height
      (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10))
   )
)

(global-set-key (kbd "C-+")     (lambda()(interactive(harrison-zoom 1))))
(global-set-key [C-kp-add]      (lambda()(interactive(harrison-zoom 1))))
(global-set-key (kbd "C--")     (lambda()(interactive(harrison-zoom -1))))
(global-set-key [C-kp-subtract] (lambda()(interactive(harrison-zoom -1))))

;;shell command completion
(require 'shell-command)
(shell-command-completion-mode)

;;load hideshow minor mode
(load-library "hideshow")

;;(global-set-key (kbd "C-=") 'abbrev-mode)
;;(global-set-key (kbd "C-x t a") 'abbrev-mode)
;;(global-set-key (kbd "C-x t c") 'highlight-changes-mode)
;;(global-set-key (kbd "C-x t v") 'view-mode)
;;(global-set-key (kbd "C-x t f") 'auto-fill-mode)
(global-set-key (kbd "C-x t h") 'hs-minor-mode)
;;open file as root , Ctrl-c Ctrl-x Ctrl-f
(global-set-key (kbd "C-x t r") 'th-find-file-sudo)

;; M-/ runs shell command with region as stdin
(global-set-key (kbd "M-/") 'shell-command-on-region)
;; M-& runs shell command with region as stdin and replaces it with stdout
(global-set-key (kbd "M-&") (lambda () (interactive)
                              (setq current-prefix-arg (list 4))
                              (call-interactively 'shell-command-on-region)))

;; make commenting easy ;)
(global-set-key (kbd "M-#") 'comment-region)
(global-set-key (kbd "C-#") 'comment-region)

;; fullscreen editing
(global-set-key (kbd "<f11>") 'fullscreen)
(defun fullscreen ()
  "Toggle fullscreen editing."
  (interactive)
  ;(menu-bar-mode nil)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

;;regex-tool
(load "regex-tool" t)    ; load regex-tool if it's available

;;find-grep
;;(setq grep-find-command 
;;  "find . -type f '!' -wholename '*/.svn/*' -print0 | xargs -0 -e grep -nH -e ")

;;ack
(require 'ack)

;;psvn
(require 'psvn)

;;funcs to issue svn cmd
;;ref url http://www.emacswiki.org/emacs/SvnMisc
(defun svncmdbuf (cmd &optional fn)
  "run the given svn command on the current window"
  (interactive "scmd:")
  (let
	  ((buf "*svn-cmd*"))
	(if (not fn)
		(setq fn (buffer-file-name)))
	(if (shell-command (format "svn %s %s" cmd fn) buf)
		(switch-to-buffer-other-window buf))))

(defun svndiff ()
  "diff the current buffer with subversion"
  (interactive)
  (let
	  ((fn (buffer-file-name)))
	(if (and fn (shell-command (format "svn diff %s" fn) "*svn-diff*"))
		(switch-to-buffer-other-window "*svn-diff*"))))
	
(defun svn (c)
  "run svn command tool"
  (interactive "c: (a)dd (d)iff (D)iff revision (c)ommit (l)og (r)esolve (R)evert (b)lame (u)p (x)delete")
  (case c
	(?a (svncmdbuf "add"))
	(?b (svncmdbuf "blame"))
	(?d (svncmdbuf "diff"))
	(?D (call-interactively 'sd))
	(?c (svncmdbuf (concat "commit -m \"" (read-string "checkin message:") "\"")))
	(?l (svncmdbuf "log"))
	(?u (svncmdbuf "up"))
	(?r (svncmdbuf "resolved"))
	(?x (svncmdbuf "rm"))
	(?R (if (yes-or-no-p "revert?") (svncmdbuf "revert")))
    (t (message "unknown command key %c" c)
       )
    )
  )

;;
;;(require 'w3m-load)
;;Begin of ffap===============
;;ffap
(require 'ffap)
;; rebind C-x C-f and others to the ffap bindings (see variable ffap-bindings)
(ffap-bindings)
;; C-u C-x C-f finds the file at point
(setq ffap-require-prefix t)
;; browse urls at point via w3m
(setq ffap-url-fetcher 'w3m-browse-url)
;;End of ffap=================


;;ascii.el
(autoload 'ascii-on        "ascii" "Turn on ASCII code display."   t)
(autoload 'ascii-off       "ascii" "Turn off ASCII code display."  t)
(autoload 'ascii-display   "ascii" "Toggle ASCII code display."    t)
(autoload 'ascii-customize "ascii" "Customize ASCII code display." t)

; show a menu only when running within X (save real estate when
; in console)
(require 'tool-bar+)
     (tool-bar-pop-up-mode 1)
;(menu-bar-mode (if window-system 1 -1))
(cond (window-system
          (menu-bar-mode -99)
))

;;Indent by parenthesis
(defun harrison-indent-according-to-paren ()
  "Indent the region between paren"
  (interactive)
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char)))
        (pos (point)))
    (save-excursion
      (cond ((string-match "[[{(<]" next-char)
             (indent-region pos (progn (forward-sexp 1) (point)) nil))
            ((string-match "[\]})>]" prev-char)
             (indent-region (progn (backward-sexp 1) (point)) pos nil))))))

(global-set-key (kbd "C-x t =") 'harrison-indent-according-to-paren)

;;;; default Tab is 8 now
(setq-default indent-tabs-mode nil)
(setq default-tab-width 8)



;; Toggle Tab Width
(global-set-key [C-tab] 'toggle-tab-width)
(defun toggle-tab-width ()
 (interactive)
 (cond ((= tab-width 4) (setq tab-width 8))
       ((= tab-width 8) (setq tab-width 4)))
 (recenter)
 )

;;make tab to 8 in cc-mode
;;(setq-default c-basic-offset 8
;;                  tab-width 8
;;                  indent-tabs-mode t)

;;Wdired
;;(require 'wdired nil t)
;;(when (featurep 'wdired)
;;  (autoload 'wdired-change-to-wdired-mode "wdired")
;;  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;)

(require 'wdired)
(autoload 'wdired-change-to-wdired-mode "wdired")
(add-hook 'dired-load-hook
          '(lambda ()
             (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
             (define-key dired-mode-map
               [menu-bar immediate wdired-change-to-wdired-mode]
               '("Edit File Names" . wdired-change-to-wdired-mode))))


;;Dir+
(require 'dired+)

;;(define-key dired-mode-map "b" 'dired-mark-extension)
(define-key dired-mode-map "c" 'dired-up-directory)
(define-key dired-mode-map "e" 'dired-mark-files-containing-regexp)
;;(define-key dired-mode-map "E" 'chunyu-dired-open-explorer)
(define-key dired-mode-map "P" 'dired-execute-file)
(define-key dired-mode-map "\M-[" 'dired-omit-mode)
(define-key dired-mode-map "\M-o" nil)
(define-key dired-mode-map "b" 'wdired-change-to-wdired-mode)
(define-key dired-mode-map "r" 'dired-mark-files-regexp)
(define-key dired-mode-map "/" 'dired-mark-directories)
(define-key dired-mode-map "K" 'dired-kill-subdir)
(define-key dired-mode-map [(control ?/)] 'dired-undo)


;;copy between different windows in the same buffer
(setq dired-dwim-target t)

;;mic-paren
(require 'mic-paren) ; loading
     (paren-activate)     ; activating

;;auto-info
(require 'autoinfo)
       (autoinfo-mode t)

;;HTTP-twiddle
(require 'http-twiddle)
       (http-twiddle-mode t)

;;uniq the buffer names
(require 'uniquify)
   (setq uniquify-buffer-name-style 'reverse)
   (setq uniquify-separator "/")
   (setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
   (setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffer

;;Note that the uniquify functions provided with Emacs,
;;uniquify-buffer-file-name, uniquify-rename-buffer,
;;uniquify-rationalize-file-buffer-names, deals with the problem of
;;uniqueness of buffer names. It has nothing to do with the problem of
;;removing identical adjacent lines in a given buffer.
;;;;If you want a command which mimics the uniq utility found on Unix systems, put the following in your InitFile:
 (defun uniquify-region ()
   "remove duplicate adjacent lines in the given region"
   (interactive)
   (narrow-to-region (region-beginning) (region-end))
   (beginning-of-buffer)
   (while (re-search-forward "^\\(.*\n\\)\\1+" nil t)
     (replace-match "\\1" nil nil))
   (widen) nil)

(defun uniquify-buffer ()
   (interactive)
   (mark-whole-buffer)
   (uniquify-region))
;;;;M-x uniquify-buffer will remove identical adjacent lines in current buffer, giving a result similar to what would be obtained with the Unix uniq command.


;;Begin of Smart Compile =====================================================

(require 'smart-compile nil t)
;;   %F  absolute pathname            ( /usr/local/bin/netscape.bin )
;;   %f  file name without directory  ( netscape.bin )
;;   %n  file name without extention  ( netscape )
;;   %e  extention of file name       ( bin )

(add-to-list 'smart-compile-alist
            '("~/projects/gcc/.*" . "make"))

(when (featurep 'smart-compile)
(setq smart-compile-alist
     '(("\\.c$"          . "gcc -Wall -o %n %f")
       ("\\.[Cc]+[Pp]*$" . "g++ -o %n %f")
       ("\\.java$"       . "javac %f")
       ("\\.f90$"        . "f90 %f -o %n")
       ("\\.[Ff]$"       . "f77 %f -o %n")
       ("\\.mp$"         . "runmpost.pl %f -o ps")
       ("\\.php$"        . "php %f")
       ("\\.tex$"        . "latex %f")
       ("\\.l$"          . "lex -o %n.yy.c %f")
       ("\\.y$"          . "yacc -o %n.tab.c %f")
       ("\\.py$"         . "python %f")
       ("\\.sql$"        . "mysql < %f")
       ("\\.ahk$"        . "start d:\\Programs\\AutoHotkey\\AutoHotkey %f")
       ("\\.sh$"         . "./%f")
       (emacs-lisp-mode  . (emacs-lisp-byte-compile))))
(setq smart-run-alist
     '(("\\.c$"          . "./%n")
       ("\\.[Cc]+[Pp]*$" . "./%n")
       ("\\.java$"       . "java %n")
       ("\\.php$"        . "php %f")
       ("\\.m$"          . "%f")
       ("\\.scm"         . "%f")
       ("\\.tex$"        . "dvisvga %n.dvi")
       ("\\.py$"         . "python %f")
       ("\\.pl$"         . "perl \"%f\"")
       ("\\.pm$"         . "perl \"%f\"")
       ("\\.bat$"        . "%f")
       ("\\.mp$"         . "mpost %f")
       ("\\.ahk$"        . "start d:\\Programs\\AutoHotkey\\AutoHotkey %f")
       ("\\.sh$"         . "./%f")))
(setq smart-executable-alist
     '("%n.class"
       "%n.exe"
       "%n"
       "%n.mp"
       "%n.m"
       "%n.php"
       "%n.scm"
       "%n.dvi"
       "%n.py"
       "%n.pl"
       "%n.ahk"
       "%n.pm"
       "%n.bat"
       "%n.sh")))

(global-set-key (kbd "<f9>") 'smart-compile)

;;End of Smart Compile =======================================================

;;Begin of IDO mode =========================
(require 'ange-ftp)
(require 'ido)
   ;;(ido-mode t)
;;Enable IDO for Buffer switch
(setq ido-enable-flex-matching t)
;;Ignore cvs mode buffers
(defun my-ido-ignore-buffers (name)
 "Ignore all c mode buffers -- example function for ido."
 (with-current-buffer name
  (cond ((or (derived-mode-p 'cvs-mode) (derived-mode-p 'sql-interactive-mode))
         nil)
        (t
         (string-match "^ ?\\*" name)))))

(setq-default ido-ignore-buffers '(my-ido-ignore-buffers)
                           ido-auto-merge-work-directories-length -1)
 (defun ido-execute ()
     (interactive)
     (call-interactively
      (intern
       (ido-completing-read
        "M-x "
        (let (cmd-list)
          (mapatoms (lambda (S) (when (commandp S) (setq cmd-list
(cons (format "%S" S) cmd-list)))))
          cmd-list)))))

   (global-set-key "\C-c-x" 'ido-execute)


;;{{{ ido: fast switch buffers
(add-hook 'ido-define-mode-map-hook 'ido-my-keys)

(defun ido-my-keys ()
  "Set up the keymap for `ido'."

  ;; common keys
  (define-key ido-mode-map "\C-e" 'ido-edit-input)
  (define-key ido-mode-map "\t" 'ido-complete) ;; complete partial
  (define-key ido-mode-map "\C-j" 'ido-select-text)
  (define-key ido-mode-map "\C-m" 'ido-exit-minibuffer)
  (define-key ido-mode-map "?" 'ido-completion-help) ;; list completions
  (define-key ido-mode-map [(control ? )] 'ido-restrict-to-matches)
  (define-key ido-mode-map [(control ?@)] 'ido-restrict-to-matches)

  ;; cycle through matches
  (define-key ido-mode-map "\C-r" 'ido-prev-match)
  (define-key ido-mode-map "\C-s" 'ido-next-match)
  (define-key ido-mode-map [right] 'ido-next-match)
  (define-key ido-mode-map [left] 'ido-prev-match)

  ;; toggles
  (define-key ido-mode-map "\C-t" 'ido-toggle-regexp) ;; same as in isearch
  (define-key ido-mode-map "\C-p" 'ido-toggle-prefix)
  (define-key ido-mode-map "\C-c" 'ido-toggle-case)
  (define-key ido-mode-map "\C-a" 'ido-toggle-ignore)

  ;; keys used in file and dir environment
  (when (memq ido-cur-item '(file dir))
    (define-key ido-mode-map "\C-b" 'ido-enter-switch-buffer)
    (define-key ido-mode-map "\C-d" 'ido-enter-dired)
    (define-key ido-mode-map "\C-f" 'ido-fallback-command)

    ;; cycle among directories
    ;; use [left] and [right] for matching files
    (define-key ido-mode-map [down] 'ido-next-match-dir)
    (define-key ido-mode-map [up]   'ido-prev-match-dir)

    ;; backspace functions
    (define-key ido-mode-map [backspace] 'ido-delete-backward-updir)
    (define-key ido-mode-map "\d"        'ido-delete-backward-updir)
    (define-key ido-mode-map [(meta backspace)] 'ido-delete-backward-word-updir)
    (define-key ido-mode-map [(control backspace)] 'ido-up-directory)

    ;; I can't understand this
    (define-key ido-mode-map [(meta ?d)] 'ido-wide-find-dir)
    (define-key ido-mode-map [(meta ?f)] 'ido-wide-find-file)
    (define-key ido-mode-map [(meta ?k)] 'ido-forget-work-directory)
    (define-key ido-mode-map [(meta ?m)] 'ido-make-directory)

    (define-key ido-mode-map [(meta down)] 'ido-next-work-directory)
    (define-key ido-mode-map [(meta up)] 'ido-prev-work-directory)
    (define-key ido-mode-map [(meta left)] 'ido-prev-work-file)
    (define-key ido-mode-map [(meta right)] 'ido-next-work-file)

    ;; search in the directories
    ;; use C-_ to undo this
    (define-key ido-mode-map [(meta ?s)] 'ido-merge-work-directories)
    (define-key ido-mode-map [(control ?\_)] 'ido-undo-merge-work-directory)
    )

  (when (eq ido-cur-item 'file)
    (define-key ido-mode-map "\C-k" 'ido-delete-file-at-head)
    (define-key ido-mode-map "\C-l" 'ido-toggle-literal)
    (define-key ido-mode-map "\C-o" 'ido-copy-current-word)
    (define-key ido-mode-map "\C-v" 'ido-toggle-vc)
    (define-key ido-mode-map "\C-w" 'ido-copy-current-file-name)
    )

  (when (eq ido-cur-item 'buffer)
    (define-key ido-mode-map "\C-b" 'ido-fallback-command)
    (define-key ido-mode-map "\C-f" 'ido-enter-find-file)
    (define-key ido-mode-map "\C-k" 'ido-kill-buffer-at-head)
    ))

(ido-mode t)
;;}}}


;;everywhere allows for ido type buffer switching.. which is nice.
(setq ido-everywhere t)
;;End of IDO mode ============================
;;
;;Begin of Auto complete mode ==========
(add-to-list 'load-path "~/.emacs.d/elpa/popup-20151222.1339")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20151227.354")
(require 'auto-complete)
(require 'auto-complete-config)
;;End of Auto complete mode ========

;;;;Require C-x C-c prompt. I've closed too often by accident.
;;;;http://www.dotemacs.de/dotfiles/KilianAFoth.emacs.html
(global-set-key [(control x) (control c)]
  (function
   (lambda () (interactive)
     (cond ((y-or-n-p "Quit? ")
            (save-buffers-kill-emacs))))))

;;;;"I always compile my .emacs, saves me about two seconds
;;;;startuptime. But that only helps if the .emacs.elc is newer
;;;;than the .emacs. So compile .emacs if it's not."
(defun autocompile nil
  "compile itself if ~/.emacs"
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat
default-directory ".emacs")))
      (byte-compile-file (buffer-file-name))))

(add-hook 'after-save-hook 'autocompile)


(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;;;; Provides vi's % style bracket matching. (press % to match the bracket when the context is a bracket) Much easier then the C-M-f and C-M-b in emacs.



;;;; Tab Bar
(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "M-j") 'tabbar-backward)
(global-set-key (kbd "M-k") 'tabbar-forward)
;;(global-set-key [M-S-up] 'tabbar-forward-group)
;;(global-set-key [M-S-down] 'tabbar-backward-group)
;;(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

  (set-face-attribute
   'tabbar-default-face nil
   :background "gray60")
  (set-face-attribute
   'tabbar-unselected-face nil
   :background "gray85"
   :foreground "gray30"
   :box nil)
  (set-face-attribute
   'tabbar-selected-face nil
   :background "#f2f2f6"
   :foreground "black"
   :box nil)
  (set-face-attribute
   'tabbar-button-face nil
   :box '(:line-width 1 :color "gray72" :style released-button))
  (set-face-attribute
   'tabbar-separator-face nil
   :height 0.7)

(defun tabbar-buffer-ignore-groups (buffer)
;;Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond
     ((or (get-buffer-process (current-buffer))
          (memq major-mode
                '(comint-mode compilation-mode)))
      '("Process")
      )
     ((member (buffer-name)
              '("*scratch*" "*Messages*"))
      '("Common")
      )
     ((eq major-mode 'dired-mode)
      '("Dired")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Help")
      )
     ((memq major-mode
            '(rmail-mode
              rmail-edit-mode vm-summary-mode vm-mode mail-mode
              mh-letter-mode mh-show-mode mh-folder-mode
              gnus-summary-mode message-mode gnus-group-mode
              gnus-article-mode score-mode gnus-browse-killed-mode))
      '("Mail")
      )
     (t
      (list
       "default"  ;; no-grouping
       (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
           mode-name
         (symbol-name major-mode)))
      )

     )))

(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

;;end of tabbar conf


;; When you start Emacs, package Session restores various variables
;; (e.g., input histories) from your last session. It also provides a
;; menu containing recently changed/visited files and restores the
;; places (e.g., point) of such a file when you revisit it.
;;
;; C-x C-/ jumps to the position of the last change
(require 'session)
(add-hook 'after-init-hook 'session-initialize)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; with this fuction you can insert date easily ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-insert-date ()
(interactive)
(insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))

(global-set-key (kbd "C-c m d") 'my-insert-date)


;;;More display goodness- highlight-tail mode, which
;;;;colorizes recently added text, but the color diminishes
;;;;over time, so you can see what you most recently typed.
;;;;http://groups.google.com/group/gnu.emacs.sources/msg/b50d53424e7ca0cd?output=gplain
;;;;http://nic-nac-project.de/~necui/ht.html
;;(require 'highlight-tail)
;;(highlight-tail-reload)

;;;;"Redefine the Home/End keys to (nearly) the same as visual studio
;;;;behavior... special home and end by Shan-leung Maverick WOO
;;;;<sw77@cornell.edu>"
;;;;This is complex. In short, the first invocation of Home/End moves
;;;;to the beginning of the *text* line. A second invocation moves the
;;;;cursor to the beginning of the *absolute* line. Most of the time
;;;;this won't matter or even be noticeable, but when it does (in
;;;;comments, for example) it will be quite convenient.
(global-set-key [home] 'My-smart-home)
(global-set-key [end] 'My-smart-end)
(defun My-smart-home ()
  "Odd home to beginning of line, even home to beginning of
text/code."
  (interactive)
  (if (and (eq last-command 'My-smart-home)
           (/= (line-beginning-position) (point)))
      (beginning-of-line)
    (beginning-of-line-text))
  )
(defun My-smart-end ()
  "Odd end to end of line, even end to begin of text/code."
  (interactive)
  (if (and (eq last-command 'My-smart-end)
           (= (line-end-position) (point)))
      (end-of-line-text)
    (end-of-line))
  )
(defun end-of-line-text ()
  "Move to end of current line and skip comments and trailing space.
Require `font-lock'."
  (interactive)
  (end-of-line)
  (let ((bol (line-beginning-position)))
    (unless (eq font-lock-comment-face (get-text-property bol 'face))
      (while (and (/= bol (point))
                  (eq font-lock-comment-face
                      (get-text-property (point) 'face)))
        (backward-char 1))
      (unless (= (point) bol)
        (forward-char 1) (skip-chars-backward " \t\n"))))
  ) ;;;;Done with home and end keys.

;;;;But what about the normal use for home and end?
;;;;We can still have them! Just prefixed with control.
(global-set-key [\C-home] 'beginning-of-buffer)
(global-set-key [\C-end] 'end-of-buffer)


;;;;Don't echo passwords when communicating with interactive programs-
;;;;basic security.
(add-hook 'comint-output-filter-functions
'comint-watch-for-password-prompt)

;;;;The autosave is typically done by keystrokes, but I'd like to save
;;;;after a certain amount of time as well.
(setq auto-save-timeout 1800)

;; abbr of yes and no
(fset 'yes-or-no-p 'y-or-n-p)

;; disable startup message page
(setq inhibit-startup-message t)

;; display date
(setq display-time-day-and-date t)

;; display time
(display-time)

;; 24-hours time
(setq display-time-24hr-format t)

;; format time as date-time
(setq display-time-day-and-date t)

;; frequency of time update
(setq display-time-interval 10)

;; setup Init Folder that Emacs will enter
(setq default-directory "~/projects")

;;Centralized backup dir to hold ~ backup files
(add-to-list 'backup-directory-alist (cons "." "~/.emacsbackups/"))


;; always end a file with a newline
(setq require-final-newline t)

(setq x-bitmap-file-path nil)

(setq x-stretch-cursor nil)

;;  character: f (0146, 102, 0x66)
;;    charset: ascii (ASCII (ISO646 IRV))
;; code point: 102
;;     syntax: word
;;   category: a:ASCII   l:Latin  
;;buffer code: 0x66
;;  file code: 0x66 (encoded by coding system utf-8)
;;       font: -B&H-LucidaTypewriter-Medium-R-Normal-Sans-12-120-75-75-M-70-ISO8859-1
;;
;; set default-font a for emacs with window
(cond (window-system
   ;;(set-default-font "-b&h-lucidaTypewriter-medium-r-normal-sans-12-120-75-75-m-70-iso8859-1")
   (set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
))

;;-b&h-lucidatypewriter-medium-r-normal-sans-11-80-100-100-m-70-iso8859-1
;;"-bitstream-bitstream vera sans mono-medium-o-normal--0-0-0-0-c-0-iso8859-9"
;;"-bitstream-bitstream vera sans mono-bold-o-normal--0-0-0-0-c-0-iso8859-15"
;;"-schumacher-clean-medium-r-normal--14-140-75-75-c-70-iso646.1991-irv"
;;"-schumacher-clean-medium-r-normal--12-120-75-75-c-60-iso8859-1"
;;"-b&h-lucidatypewriter-medium-r-normal-sans-14-100-100-100-m-80-iso8859-1"
;;"-b&h-lucidaTypewriter-medium-r-normal-sans-12-120-75-75-m-70-iso8859-1"
;;"-b&h-lucidatypewriter-medium-r-normal-sans-12-120-75-75-m-70-iso8859-1"
;;"-b&h-lucidatypewriter-medium-r-normal-sans-12-120-75-75-m-70-iso10646-1"

;;Begin of Mew ===========================================

(setq load-path (cons "/usr/share/emacs/site-lisp/mew" load-path))
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
;;(setq mew-icon-directory "/usr/share/emacs/site-lisp/mew/etc")
(setq mew-use-cached-passwd t)
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
       'mew-user-agent
       'mew-user-agent-compose
       'mew-draft-send-message
       'mew-draft-kill
       'mew-send-hook))
;;(setq mew-pop-size 0)
;;(setq mew-smtp-auth-list nil)
(setq toolbar-mail-reader 'Mew)
(set-default 'mew-decode-quoted 't) 
(when (boundp 'utf-translate-cjk)
      (setq utf-translate-cjk t)
      (custom-set-variables
         '(utf-translate-cjk t)))
(if (fboundp 'utf-translate-cjk-mode)
    (utf-translate-cjk-mode 1))
;;(require 'flyspell) ;;
;;End of Mew =============================================


;;Begin of Dird Mode======================================
;;Recursive Delete on the Directory
(setq dired-recursive-deletes t) ;
;;Recursive Copy
(setq dired-recursive-copies t) ;
(require 'dired-x)
;;Jump to current Dired via C-x C-j
(global-set-key "\C-x\C-j" 'dired-jump)
; set association of files
(setq dired-guess-shell-alist-user
      '(("\\.chm$" "kchmviewer * &")
        ("\\.pdf$" "kpdf * &")
        ("\\.rm$" "gmplayer * &")
        ("\\.rmvb$" "gmplayer * &")
        ("\\.avi$" "gmplayer * &")
        ("\\.asf$" "gmplayer * &")
        ("\\.wmv$" "gmplayer * &")
        ("\\.htm$" "w3m * &")
        ("\\.html$" "w3m * &")
        ("\\.doc$" "openoffice.org-2.0 -writer * &")
        ("\\.odt$" "openoffice.org-2.0 -writer * &")
        ("\\.mpg$" "gmplayer * &")
        ("\\.iso$" "kiso * &")
        ("\\.cs$" (concat "mcs " (mapconcat (function (lambda (x) (format "%s" x)))(directory-files "." nil (concat "[^" (thing-at-point 'word) "]\\.cs")) " ") " -out:" (thing-at-point 'word) ".exe"))
        ("\\.exe$" "mono")
        ("\\.rpm$" "rpm -ql")))

;; z to compress the dir
(defun harrison-dired-compress-dir ()
  (interactive)
  (let ((files (dired-get-marked-files t)))
    (if (and (null (cdr files))
             (string-match "\\.\\(tgz\\|tar\\.gz\\)" (car files)))
        (shell-command (concat "tar -xvf " (car files)))
      (let ((cfile (concat (file-name-nondirectory
                            (if (null (cdr files))
                                (car files)
                              (directory-file-name default-directory))) ".tgz")))
        (setq cfile
              (read-from-minibuffer "Compress file name: " cfile))
        (shell-command (concat "tar -zcvf " cfile " " (mapconcat 'identity files " ")))))
    (revert-buffer)))

(add-hook 'dired-mode-hook
          (function (lambda()
                      (define-key dired-mode-map "z" 'harrison-dired-compress-dir)
                      (define-key dired-mode-map "W" 'browse-url-of-dired-file)
                      )
                    )
)

;;End of Dird Mode======================================

;; covert pdf / rtf to text then read it in console
;;(cond (( not window-system )
;;(add-to-list 'auto-mode-alist '("\\.pdf\\'" . no-pdf))
;;    (defun no-pdf ()
;;      "Run pdftotext on the entire buffer."
;;      (interactive)
;;      (let ((modified (buffer-modified-p)))
;;        (erase-buffer)
;;        (shell-command
;;         (concat "pdftotext " (buffer-file-name) "-")
;;         (current-buffer)
;;         t)
;;        (set-buffer-modified-p modified)))
;;))

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . no-pdf))
   (defun no-pdf ()
     "Run pdftotext on the entire buffer."
     (interactive)
     (erase-buffer)
     (shell-command
      (concat "pdftotext " (buffer-file-name) " -")
      (current-buffer)
      t)
     (set-buffer-modified-p nil)
     (toggle-read-only t)
     (delete-other-windows)
   )

;;(cond (( not window-system )
;;
;;      ("^.+\\.pdf$" "pdftotext"
;;       ((:capture-output t)
;;      (:args ("%S - | fmt -w " window-width))
;;      (:ignore-on-read-text t)
;;      (:constraintp (lambda ()
;;                      (and (filesets-which-command-p "pdftotext")
;;                                (filesets-which-command-p "fmt"))))))
;;      ("^.+\\.rtf$" "rtf2htm"
;;       ((:capture-output t)
;;      (:args ("%S 2> /dev/null | w3m -dump -T text/html"))
;;      (:ignore-on-read-text t)
;;      (:constraintp (lambda ()
;;                      (and (filesets-which-command-p "rtf2htm")
;;                                (filesets-which-command-p "w3m"))))))
;;
;;))

;; find string in pdf

;;(cond (( not window-system )
;;       (defun find-pdfpage-pdftotext (fname &rest rest)
;;       (apply 'find-sh (format "pdftotext -layout %s -" fname) rest))

;;))


;;Goto line by percentage
(defun harrison-goto-line-in-percentage (percent)
  (interactive (list (or current-prefix-arg
                         (string-to-number
                          (read-from-minibuffer "Goto percent: ")))))
  (let* ((total (count-lines (point-min) (point-max)))
         (num (round (* (/ total 100.0) percent))))
    (goto-line num)))

;;Goto line by percentage
(global-set-key (kbd "M-;") 'harrison-goto-line-in-percentage)
;;Vim-style goto-line
(global-set-key (kbd "M-g") 'goto-line)
;;Perl-menu shortcut
;;(global-set-key [f7] 'insert-perl-DataDumper)
;;(global-set-key [(shift f7)] 'insert-perl-die)
;;(global-set-key [f11] 'run-perl) 
;;(global-set-key [(control f11)] 'run-perl-cmdopt) 
;;(global-set-key [(shift f11)] 'debug-perl) 


;; Enable Column Number
(setq column-number-mode t)
;; Enable middle-rolling-mouse
;;Xemacs
;;(setq mouse-wheel-mode t)
;; Highlight what the mark set
(transient-mark-mode t)
;; Highlight matched parenthesses
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;; BACKSPACE ought to act as DEL
;; if you got problem on backspace replace the following line with this:
;;  
;; ('normal-erase-is-backspace-mode 1)
(setq normal-erase-is-backspace-mode 1)
;; Print Buffer name on the Title Bar
(setq frame-title-format "emacs@%b")
;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode 1))        ; GNU Emacs
;;  (setq font-lock-auto-fontify t))   ; XEmacs

;;;Emacs title bar to reflect file name
(defun frame-title-string ()
   "Return the file name of current buffer, using ~ if under home directory"
   (let
      ((fname (or
                 (buffer-file-name (current-buffer))
                 (buffer-name))))
      ;;let body
      (when (string-match (getenv "HOME") fname)
        (setq fname (replace-match "~" t t fname))        )
      fname))

;;; Title = 'system-name File: foo.bar'
(setq frame-title-format '("" system-name "  File: "(:eval (frame-title-string))))

(defun shell-command-buffer-file-name ()
  "This function could use some safety checks."
  (interactive)
  (shell-command (expand-file-name (buffer-file-name))))

;;Begin of Color Customization =================================================

;;Make the comment darkgrey

(eval-after-load "font-lock"
  '(set-face-foreground (quote font-lock-comment-face) "wheat"))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(background "blue")
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "Turquoise"))))
 '(font-lock-comment-face ((t (:foreground "MediumAquamarine"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:bold t :foreground "DarkOrchid"))))
 '(font-lock-doc-string-face ((t (:foreground "green2"))))
 '(font-lock-function-name-face ((t (:foreground "SkyBlue"))))
 '(font-lock-keyword-face ((t (:bold t :foreground "CornflowerBlue"))))
 '(font-lock-preprocessor-face ((t (:italic nil :foreground "CornFlowerBlue"))))
 '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
 '(font-lock-string-face ((t (:foreground "LimeGreen"))))
 '(font-lock-type-face ((t (:foreground "#9290ff"))))
 '(font-lock-variable-name-face ((t (:foreground "PaleGreen"))))
 '(font-lock-warning-face ((((class color) (background dark)) (:foreground "yellow" :background "red"))))
 '(highlight ((t (:background "CornflowerBlue"))))
 '(list-mode-item-selected ((t (:background "gold"))))
 '(makefile-space-face ((t (:background "wheat"))))
 '(mode-line ((t (:background "Navy"))))
 '(paren-match ((t (:background "darkseagreen4"))))
 '(region ((t (:background "DarkSlateBlue"))))
 '(show-paren-match ((t (:foreground "black" :background "wheat"))))
 '(show-paren-mismatch ((((class color)) (:foreground "white" :background "red"))))
 '(speedbar-button-face ((((class color) (background dark)) (:foreground "green4"))))
 '(speedbar-directory-face ((((class color) (background dark)) (:foreground "khaki"))))
 '(speedbar-file-face ((((class color) (background dark)) (:foreground "cyan"))))
 '(speedbar-tag-face ((((class color) (background dark)) (:foreground "Springgreen"))))
 '(vhdl-speedbar-architecture-selected-face ((((class color) (background dark)) (:underline t :foreground "Blue"))))
 '(vhdl-speedbar-entity-face ((((class color) (background dark)) (:foreground "darkGreen"))))
 '(vhdl-speedbar-entity-selected-face ((((class color) (background dark)) (:underline t :foreground "darkGreen"))))
 '(vhdl-speedbar-package-face ((((class color) (background dark)) (:foreground "black"))))
 '(vhdl-speedbar-package-selected-face ((((class color) (background dark)) (:underline t :foreground "black"))))
 '(widget-field ((((class grayscale color) (background light)) (:background "DarkBlue")))))


;;foreground and background
;; Xemacs                                                                                                               
(set-background-color "black")                                                                                                          
(set-foreground-color "white")                                                                                                          
;;(set-face-foreground 'modeline "grey")
;;(set-face-background 'modeline "purple")
(set-face-background 'highlight "orangered")                                                                                               
(set-face-background 'region "orangered")                                                                                               
;;(set-cursor-color "green")
;;(setq tab-width 1) 

;;End of Color customization ===================================================


;;Begin of Command run on cursor ===============================================

(defvar command-output-buffer "Command Output"
  "Name of the buffer used to present output from commands.")

(defun command-output-buffer-cleanup (&optional buffer-name)
  "Cleanup before executing a command.buffer-name is the command's output buffer."
  (let ((name (or buffer-name command-output-buffer)))
    (when (get-buffer command-output-buffer)
      (kill-buffer command-output-buffer))))

(defun run-command (command &optional pre-view-hook)
  "Run COMMAND and view the result in another window.
PRE-VIEW-HOOK is an optional function to call before entering
view-mode. This is useful to set the major-mode of the result buffer,
because if you did it afterwards then it would zap view-mode."
  (command-output-buffer-cleanup)
  (with-current-buffer (get-buffer-create command-output-buffer)
    ;; prevent `shell-command' from printing output in a message
    (let ((max-mini-window-height 0))
      (shell-command command t))
    (goto-char (point-min))
    (when pre-view-hook
      (funcall pre-view-hook)))
  (view-buffer-other-window command-output-buffer))

(defun command-output-hook (commandstring)
  "Hook of the command output."
  (interactive)
;;  (let (command (shell-command commandstring))
;;    (run-command command)))
   (run-command commandstring))


;;End of Command run on cursor =================================================

;;Begin of Emacs-lisp-mode =====================================================

;;End of Emacs-lisp-mode =====================================================

;;Begin of PHP-mode ============================================================
;;php-mode
(setq load-path (cons ".emacs.d/pkgs/pi-php-mode" load-path))
(require 'pi-php-mode)
(require 'php-electric)
(add-hook 'php-mode-user-hook 'turn-on-font-lock)

;;;;Emacs 23s face per buffer
;;(make-face 'php-comment-face)
;; (set-face-foreground 'php-comment-face "LightGrey")
;; (set-face-background 'php-comment-face "Grey")                                                                                               
;; (add-hook 'php-mode-hook 
;;           (lambda ()
;;            (set (make-local-variable 'font-lock-comment-face)
;;                 'php-comment-face))
;;	   (buffer-face-mode)
;;	   )

;;(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;;;; To use abbrev-mode, add lines like this:
(add-hook 'php-mode-user-hook
  '(lambda () (define-abbrev php-mode-abbrev-table "ex" "extends")))

;;;php-mode
(defvar php-mode-syntax-table php-mode-syntax-table)     
  ;; underscore considered part of word
  (modify-syntax-entry ?_ "w" php-mode-syntax-table)
  ;; forward slash considered part of word
;;  (modify-syntax-entry ?/ "w" php-mode-syntax-table)
  ;; colon considered part of word
  (modify-syntax-entry ?: "w" php-mode-syntax-table)
  ;; dollar-sign considered punctuation, not part of word
  (modify-syntax-entry ?$ "." php-mode-syntax-table)
  ;; amphersand considered punctuation, not part of word
  (modify-syntax-entry ?& "." php-mode-syntax-table)


;; highlight cursored lines in php-mode
;;(add-hook 'php-mode-hook 'hl-line-mode)

;;fold/collapse braces-block in php
(add-hook 'php-mode-hook 'hs-minor-mode)
(add-hook 'php-mode-hook
     (function (lambda ()
         (which-func-mode)
         ;;Code hiding
         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
         (local-set-key (kbd "<f6>") 'hs-hide-all)
         (local-set-key (kbd "<S-f6>") 'hs-show-all)
         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
         )
       )
)

;; insert print_r func template by C-c j in PHP-mode
(add-hook 'php-mode-hook
 (function (lambda ()
   (local-set-key (kbd "C-c j") (defun foo(arg) "Doc String" (interactive "M") (insert "printf(\"<pre>%s</pre>\",print_r(" arg ",true));"))))))

;; insert echo out debug template by C-c g in PHP-mode
(add-hook 'php-mode-hook
 (function (lambda ()
   (local-set-key (kbd "C-c g") (defun foo1(arg) "Doc String1" (interactive "M") (insert "echo \"blah=\"." arg ".\"<br>\";"))))))

;;check php syntax
(defun check-php ()
  (interactive)
  (setq php-buffer-name buffer-file-name)
  (compile (concat "php -l " (buffer-file-name)))
)
(add-hook 'php-mode-hook
 (lambda ()
  (local-set-key (kbd "C-p c") 'check-php)))

;; insert comment
(add-hook 'php-mode-hook
 (function (lambda ()
   (local-set-key (kbd "C-c m") (defun foo2(arg) "Doc String2" (interactive "M") (insert 
"
/**
 *
 * Description
 *
 * @access " arg "
 */
"
))))))

;;PearDoc ---------------------------------------------------------------
(defun peardoc-command ()
;;  "This function could use some safety checks."
  (interactive)      
  (shell-command (concat "pear info " (replace-regexp-in-string "/" "_" (thing-at-point 'word)))))

(add-hook 'php-mode-hook
 (function (lambda ()
   (local-set-key (kbd "C-c p") 'peardoc-command))))

;;links 'http://pear.php.net/search.php?q=PEAR::getStaticProperty&in=site'
;;Pear Web Doc ---------------------------------------------------------------
(defun peardoc-webinfo-command ()
;;  "This function could use some safety checks."
  (interactive)      
  (w3m-goto-url (concat "http://pear.php.net/search.php?q=" (thing-at-point 'word) "&in=site") ))



(add-hook 'php-mode-hook
;; ((lambda ()
;;  (define-key php-mode-map "\C-pr" 'peardoc-webinfo-command))))
  (function (lambda ()
    (local-set-key (kbd "C-p r") 'peardoc-webinfo-command))))

;;PHP Web Doc ---------------------------------------------------------------
(defun phpdoc-webinfo-command ()
;;  "This function could use some safety checks."
  (interactive)      
		(w3m-goto-url (concat "http://www.php.net/" (thing-at-point 'word) ) ))


(add-hook 'php-mode-hook
;; ((lambda ()
;;  (define-key php-mode-map "\C-pw" 'phpdoc-webinfo-command))))
  (function (lambda ()
    (local-set-key (kbd "C-p w") 'phpdoc-webinfo-command))))

;;evaluate php code on region
(eval-after-load 'php-mode
  (define-key php-mode-map (kbd "C-c C-p")
    (lambda (from to)
      (interactive "r")
       (shell-command-on-region from to "php")
    )
  )
)

(defun php-doc-paragraph-boundaries ()
    (setq paragraph-separate "^[ \t]*\\(\\(/[/\\*]+\\)\\|\\(\\*+/\\)\\|\\(\\*?\\)\\|\\(\\*?[ \t]*@[[:alpha:]]+\\([ \t]+.*\\)?\\)\\)[ \t]*$")
      (setq paragraph-start (symbol-value 'paragraph-separate)))

(add-hook 'php-mode-user-hook 'php-doc-paragraph-boundaries)
;;End of PHP-mode ============================================================


;;Begin of Cperl-mode ========================================================

(defvar cperl-module-insert-map nil)
(setq cperl-module-insert-map (make-sparse-keymap))

(global-set-key "\C-cp" cperl-module-insert-map)


;; Perl
;;
;;set indent to be 8
(setq cperl-indent-level 8)

;; Start cperl-mode instead of perl-mode
(setq auto-mode-alist (cons '("\\.\\([pP][Llm]\\|al\\)$" . cperl-mode)
                       auto-mode-alist))
;;
;; You can either fine-tune the bells and whistles of this mode or
;; bulk enable them by putting
;(setq cperl-hairy t)
;;
;; use cperl mode if perl is in the #!
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))

;;highlight cursored lines in cperl
;;(add-hook 'cperl-mode-hook 'hl-line-mode)

;; Start cperl-mode instead of perl-mode
(setq auto-mode-alist (cons '("\\.\\([pP][Llm]\\|al\\)$" . cperl-mode)
                       auto-mode-alist))

;;
;; You can either fine-tune the bells and whistles of this mode or
;; bulk enable them by putting
;(setq cperl-hairy t)
;;
;; use cperl mode if perl is in the #!
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))

;;PerlDoc ---------------------------------------------------------------

;;Cperl-mode
(require 'cperl-mode)

;;cperl-mode
(defvar cperl-mode-syntax-table cperl-mode-syntax-table)     
   ;; colon considered part of word
   (modify-syntax-entry ?: "w" cperl-mode-syntax-table)
   ;; single quote considered part of word
   (modify-syntax-entry ?' "w" cperl-mode-syntax-table)
   ;; dollar-sign considered punctuation, not part of word
   (modify-syntax-entry ?$ "." cperl-mode-syntax-table)
   ;; ampersand considered punctuation, not part of word
   (modify-syntax-entry ?& "." cperl-mode-syntax-table)

(add-hook 'cperl-mode-hook 'hs-minor-mode)
(add-hook 'cperl-mode-hook
     (function (lambda ()
         (which-func-mode)
         ;;Code hiding
         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
         (local-set-key (kbd "<f6>") 'hs-hide-all)
         (local-set-key (kbd "<S-f6>") 'hs-show-all)
         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
	 (which-function-mode)
         )
       )
)

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(f10)] 'check-perl))))

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(f11)] 'run-perl))))

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(control f11)] 'run-perl-cmdopt))))

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(shift f11)] 'debug-perl))))

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(f7)] 'insert-perl-DataDumper))))

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key [(shift f7)] 'insert-perl-die))))

;; insert sub template by C-c s in cperl-mode
(add-hook 'cperl-mode-hook
 (function (lambda ()
   (local-set-key (kbd "\C-cp s") (defun foo(arg) "Doc String" (interactive "M") (insert 
"
#
#
#
sub " arg " {

	my X = shift;
	my (X,XXX,XXX) = @_;

	return X;
}
"
))))))

;; insert mutator ( private ) by \C-cp m in cperl-mode
(add-hook 'cperl-mode-hook
 (function (lambda ()
   (local-set-key (kbd "\C-cp m") (defun PerlMutator(NameinMethod NameinAttribute) "Insert Perl Mutator template"  (interactive "sName in Method:\nsName in Attribute: ") (insert 
"
#
#
# Method Name: _set" NameinMethod "
# Accessibility: PRIVATE
# Description  :
#                mutator of attribute " NameinAttribute ".
# Parameters   :
#                XXX => Comments
# Returns      :
#                NULL.
# TODO         :
#                NULL.
#
#

sub _set" NameinMethod " {

	# Comments
  	my ( $this,XXX ) = @_;

	checkPrivate;

  	$this->{'" NameinAttribute "'} = XXX;

  	return;

}
"
))))))

;; insert mutator ( public ) by \C-cp a in cperl-mode
(add-hook 'cperl-mode-hook
 (function (lambda ()
   (local-set-key (kbd "\C-cp a") (defun PerlAccessor(NameinMethod NameinAttribute) "Insert Perl Accessor template"  (interactive "sName in Method:\nsName in Attribute: ") (insert
"
#
#
# Method Name: get" NameinMethod "
# Accessibility: PUBLIC
# Description  :
#                accessor of attribute " NameinAttribute " 
# Parameters   :
#                NULL.
# Returns      :
#                attribute " NameinAttribute "
# TODO         :
#                NULL.
#

sub get" NameinMethod " {

        # Comments
        my $this = shift;

        return $this->{'" NameinAttribute "'};

}
"
))))))

;; insert method ( public ) by \C-cp d in cperl-mode
(add-hook 'cperl-mode-hook
 (function (lambda ()
   (local-set-key (kbd "\C-cp d") (defun PerlMethod(NameofMethod) "Insert Perl Module Method template"  (interactive "sName Of Method: ") (insert
"
#
# Method Name: do" NameofMethod " 
# Accessibility: Public
# Description  :
#                XXX.
# Parameters   :
#                XXX => Comments
#                XXX => Comments
#                XXX => Comments
# Returns      :
#                XXX
# TODO         :
#                NULL.
#

sub do" NameofMethod " {

        # Comments
        my ( $this,XXX,XXX ) = @_;

        $this->{'ATTRIBUTE'} = XXX;

        return;

}
"
))))))

;;cperl-mode with ffap
 (setq ffap-perl-inc-dirs 
         (apply 'append 
                (mapcar (function ffap-all-subdirs)
                        (split-string (shell-command-to-string 
                                       "perl -e 'pop @INC; print join(q/ /,@INC);'")))))

(defun my-cperl-ffap-locate(name)
     "Return cperl module for ffap"
     (let* ((r (replace-regexp-in-string ":" "/"       (file-name-sans-extension name)))
            (e (replace-regexp-in-string "//" "/" r))
            (x (ffap-locate-file e '(".pm" ".pl" ".xs") ffap-perl-inc-dirs)))
       x
       )
    )

(add-to-list 'ffap-alist  '(cperl-mode . my-cperl-ffap-locate))

;;evaluate perl code on region
;;(eval-after-load 'cperl-mode
;;  (define-key cperl-mode-map (kbd "C-c C-e")
;;    (lambda (from to)
;;      (interactive "r")
;;       (shell-command-on-region from to "perl -w -Mstrict -")
;;    )
;;  )
;;)



;;(add-hook 'cperl-mode-hook
;; (lambda () 
;;    (local-set-key (kbd "C-p k" (lambda () 
;;      (command-output-hook (thing-at-point 'word))
;;    )))
;; ) 
;;)

;;Cperl-mode Perl Doc .function---------------------------------------------------------------
(defun Cperlmode-perldoc-function-command ()
;;  "This function could use some safety checks."
  (interactive)      
  (shell-command (concat "perldoc -t -f " (thing-at-point 'word))))

(add-hook 'cperl-mode-hook
 (lambda ()
  (local-set-key (kbd "C-p f") 'Cperlmode-perldoc-function-command)))

;;Perl function Web Doc ---------------------------------------------------------------
(defun perldoc-function-webinfo-command ()
	(interactive)
		(w3m-goto-url (concat "http://perldoc.perl.org/functions/" (thing-at-point 'word) ".html") ))

(add-hook 'cperl-mode-hook
	(function (lambda ()
		    (local-set-key (kbd "C-p C-f") 'perldoc-function-webinfo-command))))

;;;;Cperl-mode Perl Doc .module---------------------------------------------------------------
(defun Cperlmode-perldoc-module-command ()
;;  "This function could use some safety checks."
    (interactive)
       (shell-command (concat "perldoc -t " (thing-at-point 'word))))


(add-hook 'cperl-mode-hook
 (lambda ()
  (local-set-key (kbd "C-p m") 'Cperlmode-perldoc-module-command)))


;; Cperl-mode-perldoc on prompt
(add-hook 'cperl-mode-hook
 (lambda ()
  (local-set-key (kbd "C-p d") 'cperl-perldoc)))

;;Perl modules Web Doc ---------------------------------------------------------------
(defun perldoc-module-webinfo-command ()
	(interactive)
		(w3m-goto-url (concat "http://search.cpan.org/search?module=" (thing-at-point 'word)) ) )

(add-hook 'cperl-mode-hook
	(function (lambda ()
		    (local-set-key (kbd "C-p C-m") 'perldoc-module-webinfo-command))))

;; check current perl syntax
(defun check-perl ()
  (interactive)
  (setq perl-buffer-name buffer-file-name)
  (shell-command (concat "perl -c " (replace-regexp-in-string "\\(.*\\):\\(.*\\)" "\\2" perl-buffer-name)))
)


;;run the current perl program
(defun run-perl ()
  (interactive)
  (setq perl-buffer-name buffer-file-name)
  (shell-command (concat "perl " (replace-regexp-in-string "\\(.*\\):\\(.*\\)" "\\2" perl-buffer-name)))
)

;;run the current perl program with user-input command options
(defun run-perl-cmdopt ( Option )
  "Run Perl current buffer with command option"
  (interactive "sCommand Option: ")
  (setq perl-buffer-name buffer-file-name)
  (shell-command (concat "perl " (replace-regexp-in-string "\\(.*\\):\\(.*\\)" "\\2" perl-buffer-name) " " Option))
)

;;debug the current perl program
(defun debug-perl ()
  (interactive "*")
  (setq perl-buffer-name buffer-file-name)
  (shell)
  (setq perl-run-command "perl -d ")
  (insert perl-run-command)
  (insert perl-buffer-name)
)

;;Add perl Data::Dumper template
(defun insert-perl-DataDumper ()
  "Add perl print template of DataDumper"
  (interactive "*")
  (setq steve-var "use Data::Dumper;print Dumper();")
  (insert steve-var)
)


;;Add perl die template
(defun insert-perl-die ()
  "Add perl die template"
  (interactive "*")
  (setq steve-var "or die \" : $!\";")
  (insert steve-var)
)

(add-hook 'cperl-mode-hook 'doperlmenu)

(defun doperlmenu ()

;; ---------------------------------------------------------------------------
;;			MENU CUSTOMISATION : Perl 
;; ---------------------------------------------------------------------------
;;Add a 'Perl' menu
(define-key global-map [menu-bar perl-menu]
  (cons "myPerl" (make-sparse-keymap "myPerl")))
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [goto-line-label] '("Goto Line" . goto-line) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comment-region-label] '("Comment Highlighted Region" . comment-region) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [shell-label] '("MS-DOS Command Prompt" . shell) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [indent-region-label] '("Indent Highlighted Region   (f4)" . indent-region) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [wrap-all-lines-label] '("Wrap Lines" . wrap-all-lines) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [bury-buffer-label] '("Previous Window" . bury-buffer) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [insert-perl-DataDumper-label] '("Insert: use Data::Dumper; print Dumper();" . insert-perl-DataDumper) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [insert-perl-die-label] '("Insert: or die \" : $!\";" . insert-perl-die) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator1] '("--" . perl-menu-separator1) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [check-perl-label] '("Check Syntax of current Perl Code" . check-perl) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [run-perl-label] '("Run Current Perl Code" . run-perl) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [run-perl-cmdopt-label] '("Run Current Perl Code with Cmd Opt" . run-perl-cmdopt) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [debug-perl-label] '("Debug Current Perl Code" . debug-perl) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator2] '("--" . perl-menu-separator2) t)
;;(define-key-after (lookup-key global-map [menu-bar perl-menu])
;;  [split-window-vertically-label] '("Split window                      (f9)" . split-window-vertically) t)
;;(define-key-after (lookup-key global-map [menu-bar perl-menu])
;;  [delete-other-windows-label] '("Unsplit window                  (f10)" . delete-other-windows) t)
;;(define-key-after (lookup-key global-map [menu-bar perl-menu])
;;  [query-replace-label] '("Replace                            (f11)" . query-replace) t)
;;(define-key-after (lookup-key global-map [menu-bar perl-menu])
;;  [undo-label] '("Undo                                (f12)" . undo) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator3] '("--" . perl-menu-separator3) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [end-of-defun-label] '("End of function" . end-of-defun) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [beginning-of-defun-label] '("Beginning of function" . beginning-of-defun) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [ascii-table-label] '("Show ASCII Table" . ascii-table) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [cperl-mode-label] '("Switch to cperl-mode" . cperl-mode) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator4] '("--" . perl-menu-separator4) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [unix-to-dos-label] '("Reformat UNIX -> DOS" . unix-dos) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [dos-to-unix-label] '("Reformat DOS -> UNIX" . dos-unix) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator5] '("--" . perl-menu-separator5) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comments-in-italics-label] '("Comments in Italics" . make-comment-italic) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comments-in-unitalics-label] '("Comments NOT in Italics" . make-comment-unitalic) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comments-invisible-label] '("Invisible Comments" . make-comment-invisible) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comments-visible-label] '("Visible Comments" . make-comment-visible) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [comments-red-label] '("Red Comments" . make-comment-red) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [perl-menu-separator6] '("--" . perl-menu-separator6) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [desktop-save-label] '("Save Desktop" . desktop-save) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [desktop-clear-label] '("Clear Desktop" . desktop-clear) t)
(define-key-after (lookup-key global-map [menu-bar perl-menu])
  [desktop-remove-label] '("Disable Desktop Function" . desktop-remove) t)

; (define-key global-map [menu-bar Misc] nil)	;disable the menu

;; Add Speedbar to "Tools" menu
(cond (window-system
       (define-key-after (lookup-key global-map [menu-bar tools])
         [speedbar-menu-separator] '("--" . speedbar-menu-separator) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [speedbar] '("Speedbar" . speedbar-frame-mode) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [speedbar2] '("(Selects files with middle mouse button)" . speedbar-frame-mode) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [speedbar-menu-separator2] '("--" . speedbar-menu-separator2) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [tetris-menu-label] '("Tetris" . tetris) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [gomoku-menu-label] '("Gomoku" . gomoku) t)
       (define-key-after (lookup-key global-map [menu-bar tools])
         [doctor-menu-label] '("Emacs Doctor" . doctor) t)
))

)

;;kill perlmenu when there are no cperl-mode in any openning buffers.
(add-hook 'kill-buffer-hook 
	(lambda () 
		(interactive)
			(if (eql major-mode 'cperl-mode) 
				(killperlmenu)
			)
	)
)

(defun killperlmenu() (interactive) (define-key global-map [menu-bar perl-menu] nil))

;;perl5db provides a convenient command line interface, and maybe it more quick to 
;;use command than using emacs command.
;; Remember perl5db commands is worth if you want to debug perl script. 
;;Except n, s, c, b, B, w, W, L, p, x these most used commands, these are also convenient:

;;    * f Switch to a loaded file
;;    * l Jump to line or function
;;    * . Back to current line
;;    * r Return from current subroutine
;;    * V Search for variable
;;    * S Search for function
;;    * y List lexcial variables

;;http://cpansearch.perl.org/src/YEWENBIN/Emacs-PDE-0.2.16/lisp/doc/QuickStartEn.html#sec19
;;    * perldb-ui
;;    * perldb-many-windows
;;    * perldb-restore-windows

(require 'windata)
(autoload 'perldb-ui "perldb-ui" "perl debugger" t)

(add-hook 'cperl-mode-hook
 (function (lambda ()
    (local-set-key (kbd "C-c d") 'myperldb))))

(defun myperldb ()
	(interactive)
	(ecb-deactivate)
	(setq perldb-many-windows t)
	(call-interactively 'perldb-ui)
)

(autoload 'xs-mode "xs-mode" "Major mode for XS files" t)
(add-to-list 'auto-mode-alist '("\\.xs$" . xs-mode))

;;End of Cperl-mode ==========================================================

;;Begin of cc-mode ===========================================================
(setq load-path (cons ".emacs.d/pkgs/ccmode-5.32.2" load-path))
(require 'gud)
;;(require 'gdb-ui)

 (add-hook 'gdb-mode-hook 
 	  (lambda ()
 	    (setq gdb-many-windows 't)
             (local-set-key [f6] 'gud-up)
             (local-set-key [(shift f6)] 'gud-down)
             (local-set-key [f7] 'gud-step)
             (local-set-key [(shift f7)] 'gud-stepi)
             (local-set-key [f8] 'gud-next)
             (local-set-key [(shift f8)] 'gud-finish)
             (local-set-key [(ctrl f8)] 'gud-until)
             (local-set-key [f9] 'humble-recompile)
             (local-set-key [(shift f9)] 'compile)
             (local-set-key [f10] 'humble-gud)
 	    ;;(define-key gud-mode-map [f9] 'gdb-many-windows)
 	    ;;(setq gdb-use-separate-io-buffer 't)
 	    ;;(tool-bar-mode 't)
	    ))

(defun humble-recompile () 
  "recompile if possible"
  (interactive) 
  (if (fboundp 'recompile)
      (recompile)
    (call-interactively 'smart-compile)))


(defun humble-gud ()
  "gdb if not already running, otherwise bring to front"
  (interactive)
  (require 'gud)
  (if (and (boundp 'gud-comint-buffer)	;find running gdb process
	   gud-comint-buffer
	   (buffer-name gud-comint-buffer)
	   (get-buffer-process gud-comint-buffer))
      (if (fboundp 'gdb-restore-windows)
	   (gdb-restore-windows)
	(pop-to-buffer gud-comint-buffer))
    (call-interactively 
     (or (cdr (assq major-mode preferred-debugger-alist))
	 'gdb))))


(require 'xcscope)
;; 5. If you intend to use xcscope.el often you can optionally edit your
;;    ~/.emacs file to add keybindings that reduce the number of keystrokes
;;    required.  For example, the following will add "C-f#" keybindings, which
;;    are easier to type than the usual "C-c s" prefixed keybindings.  Note
;;    that specifying "global-map" instead of "cscope:map" makes the
;;    keybindings available in all buffers:
;;
;; to generate global index run cscope-indexer -r under /emcsvn/emc
;;(add-hook 'cscope-minor-mode-hooks
;;          '(lambda ()
;;             (define-key cscope:map "\C-css" 'cscope-find-this-symbol)
;;             (define-key cscope:map "\C-csd" 'cscope-find-global-definition)
;;             (define-key cscope:map "\C-csg" 'cscope-find-global-definition)
;;             (define-key cscope:map "\C-csG" 'cscope-find-global-definition-no-prompting)
;;             (define-key cscope:map "\C-csc" 'cscope-find-functions-calling-this-function)
;;             (define-key cscope:map "\C-csC" 'cscope-find-called-functions)
;;             (define-key cscope:map "\C-cst" 'cscope-find-this-text-string)
;;             (define-key cscope:map "\C-cse" 'cscope-find-egrep-pattern)
;;             (define-key cscope:map "\C-csf" 'cscope-find-this-file)
;;             (define-key cscope:map "\C-csi" 'cscope-find-files-including-file)
;;             ;; --- (The '---' indicates that this line corresponds to a menu separator.)
;;             (define-key cscope:map "\C-csb" 'cscope-display-buffer)
;;             (define-key cscope:map "\C-csB" 'cscope-display-buffer-toggle)
;;             (define-key cscope:map "\C-csn" 'cscope-next-symbol)
;;             (define-key cscope:map "\C-csN" 'cscope-next-file)
;;             (define-key cscope:map "\C-csp" 'cscope-prev-symbol)
;;             (define-key cscope:map "\C-csP" 'cscope-prev-file)
;;             (define-key cscope:map "\C-csu" 'cscope-pop-mark)
;;             ;; ---
;;             (define-key cscope:map "\C-csa" 'cscope-set-initial-directory)
;;             (define-key cscope:map "\C-csA" 'cscope-unset-initial-directory)
;;             ;; ---
;;             (define-key cscope:map "\C-csL" 'cscope-create-list-of-files-to-index)
;;             (define-key cscope:map "\C-csI" 'cscope-index-files)
;;             (define-key cscope:map "\C-csE" 'cscope-edit-list-of-files-to-index)
;;             (define-key cscope:map "\C-csW" 'cscope-tell-user-about-directory)
;;             (define-key cscope:map "\C-csS" 'cscope-tell-user-about-directory)
;;             (define-key cscope:map "\C-csT" 'cscope-tell-user-about-directory)
;;             (define-key cscope:map "\C-csD" 'cscope-dired-directory)))

(defun find-caller (tagname)
    "Find occurences of tagname in files in the current directory matching extension of current file."
    (interactive (list (find-tag-tag "Find caller: ")))
      (let ((cmd "grep -n "))
	    (cond
	           ((member major-mode '(lisp-mode cmulisp-mode))
		          (grep (concat cmd "-i '" tagname "' *.lisp")))
		        ((eq major-mode 'c-mode)
			       (grep (concat cmd "'" tagname "' *.[ch]")))
			     ((member major-mode '(latex-mode tex-mode))
			            (grep (concat cmd "-i '" tagname "' *.tex")))
			          ((eq major-mode 'emacs-lisp-mode)
				         (grep (concat cmd "'" tagname "' *.el")))
				       (t (grep (concat cmd "'" tagname "' *"))))))


(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)

(defun harrison-indent-or-complete ()
  (interactive)
  ;;(if (looking-at "\\>")
         (hippie-expand nil)
         (indent-for-tab-command)
  ;;       (indent-for-tab-command))
 )

;;make c code like :
;; void * test ( int * data ) {
;;        int * ptr;
;;        int a = 0;
;;        ptr = &a;
;;}
;; you can also give BSD a try:
;; void * test ( int * data )
;;{
;;        int * ptr;
;;        int a = 0;
;;        ptr = &a;
;;}
(c-add-style "HARRISON"
            '("awk"
              ;; enable following to get Tabwidth 8)
              (c-basic-offset . 8)
              ;;(c-basic-offset . 2)
              (c-offsets-alist . ((inline-open . 0)
                                  (inclass . +)
                                  (label . -4)
                                  (substatement-open . 0)
                                  (case-label . +)
                                  )
              )
             )
)

(add-hook 'c-mode-hook 'hs-minor-mode)

;;;c-mode
(defvar c-mode-syntax-table c-mode-syntax-table)     
  ;; underscore considered part of word
  (modify-syntax-entry ?_ "w" c-mode-syntax-table)

(defun harrison-c-mode-common-hook()
  ;; enable following to get Tabwidth 8 and Tab)
 ;;(setq tab-width 8 indent-tabs-mode t)
 (setq tab-width 8 tab-width 8 indent-tabs-mode nil)
;;to add /usr/include/ C Header function definitions in the Semantic syntax db
(setq semanticdb-project-system-databases
                (list (semanticdb-create-database
                         semanticdb-new-database-class
                         "/usr/include")))
 (c-set-style "HARRISON")
 ;;; hungry-delete and auto-newline
 (c-toggle-auto-hungry-state 1)

 (define-key c-mode-base-map [(return)] 'newline-and-indent)
 (define-key c-mode-base-map [(f7)] 'compile)
 (define-key c-mode-base-map [(meta \`)] 'c-indent-command)
;;  (define-key c-mode-base-map [(tab)] 'hippie-expand)
 (define-key c-mode-base-map [(control tab)] 'harrison-indent-or-complete)
 (define-key c-mode-base-map [(alt ?/)] 'semantic-ia-complete-symbol-menu)
 (setq c-macro-shrink-window-flag t)
 (setq c-macro-preprocessor "cpp")
 (setq c-macro-cppflags " ")
 (setq c-macro-prompt-flag t)
 (define-key c-mode-base-map [f3] '(lambda () (interactive) (point-to-register ?1)))
 (define-key c-mode-base-map [S-f3] '(lambda () (interactive) (register-to-point ?1)))
 (define-key c-mode-base-map [f5] 'hs-toggle-hiding)
 (define-key c-mode-base-map [f6] 'hs-hide-all)
 (define-key c-mode-base-map [S-f6] 'hs-show-all)
 (setq abbrev-mode t)
;;enable following line to 1. get Tab 2. Tab-width 8
;; (setq c-basic-offset 8 tab-width 8 indent-tabs-mode t)
 ;;(setq c-basic-offset 8 tab-width 8 indent-tabs-mode nil)
 ;;add the followings to display which func we are
 (imenu-add-menubar-index)
 (which-function-mode)
)

(add-hook 'c-mode-common-hook 'harrison-c-mode-common-hook)
(define-key c-mode-base-map (kbd "C-c d") 'mygdb ) 

;;mygdb 0. deactivate ecb 1. call gdb
(defun mygdb ()
  (interactive)
  (ecb-deactivate)
  ;;(setq gud-gdb-command-name "gdb --annotate=3") 
  (call-interactively 'gdb)
)
;;run the current program
(defun run-currentfile ()
 (interactive)
   (setq current-buffer-name buffer-file-name)
    (
     if (string-match "\\(.*\\):\\(.*\\):\\(.*\\)\\.c" current-buffer-name)
        (shell-command (match-string 3 current-buffer-name))
      (shell-command (replace-regexp-in-string "\\(.*\\)\\.c" "\\1" current-buffer-name))
    )
)

;;(let* ((s1  "a:b/c.c") (s2 "d/e.c")) (if (string-match "^\\(.*:(?:.*)\\.c\\|.*\\)\\.c" s2) (match-string 1 s2) "error"))

;;(let* ((s1  "a:b/c.c") (s2 "/ssh:harrison@bvlah.alah.com:d/e.c")) (if (string-match "\\(.*\\):\\(.*\\):\\(.*\\)\\.c" s2) (match-string 3 s2) "error"))


;;run the current program with user-input command options
(defun run-buffer-name-cmdopt ( Option )
;; "Run current buffer with command option"
 (interactive "sCommand Option: ")
  (setq current-buffer-name buffer-file-name)
   (
     if (string-match "\\(.*\\):\\(.*\\):\\(.*\\)\\.c" current-buffer-name)
        (shell-command (concat (match-string 3 current-buffer-name) " " Option))
      (shell-command (concat (replace-regexp-in-string "\\(.*\\)\\.c" "\\1" current-buffer-name) " " Option))
   )
)

(add-hook 'c-mode-hook
 (function (lambda ()
    (local-set-key [(control f10)] 'run-currentfile))))

(add-hook 'c-mode-hook
 (function (lambda ()
    (local-set-key [(control f11)] 'run-buffer-name-cmdopt))))

;;ccmode mysql c api web search --------------------------
(defun mysqlapidoc-webinfo-command ()
  (interactive)
  (w3m-goto-url (concat "http://dev.mysql.com/doc/refman/5.0/en/" (replace-regexp-in-string "_" "-" (thing-at-point 'word)) ".html") ))
(define-key c-mode-base-map (kbd "C-c w") 'mysqlapidoc-webinfo-command ) 

(defun harrison-c++-mode-hook()
;;enable following line to 1. get Tab 2. Tab-width 8
;; (setq tab-width 8 indent-tabs-mode t)
 (setq tab-width 2 indent-tabs-mode nil)
 (c-set-style "HARRISON")
;;(define-key c++-mode-map [f3] 'replace-regexp)
)

;;(global-set-key [(control tab)] 'harrison-indent-or-complete)

(autoload 'senator-try-expand-semantic "senator")

(setq hippie-expand-try-functions-list
         '(
               senator-try-expand-semantic
               try-expand-dabbrev
               try-expand-dabbrev-visible
               try-expand-dabbrev-all-buffers
               try-expand-dabbrev-from-kill
               try-expand-list
               try-expand-list-all-buffers
               try-expand-line
               try-expand-line-all-buffers
               try-complete-file-name-partially
               try-complete-file-name
               try-expand-whole-kill
       )
)

;;;;;;;;;;;;;;
;;;
;;; Valgrind
;;;
;;;;;;;;;;;;;;

;;Call Valgrind
(defun call-valgrind (file)
	;;prompt for a file
	(interactive "fEnter file: ")
	(shell-command (concat "valgrind -v --leak-check=full " file))
	(switch-to-buffer-other-window "*Shell Command Output*")
	(compilation-shell-minor-mode t)
)

;;valgrind the current program
(defun call-valgrind-currentfile ()
  (interactive)
  (setq current-buffer-name buffer-file-name)
  (
   if (string-match "\\(.*\\):\\(.*\\):\\(.*\\)\\.c" current-buffer-name)
      (shell-command (match-string 3 current-buffer-name))
      (shell-command (replace-regexp-in-string "\\(.*\\)\\.c" "valgrind -v --leak-check=full \\1.x" current-buffer-name))
    )
)

(add-hook 'c-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "C-c g")  'call-valgrind-currentfile)
                      )))


;;valgrind the current program
(defun valgrind-currentfile ()
  (interactive)
  (require 'valgrind)
  (setq file-of-buffer buffer-file-name)
  (valgrind (replace-regexp-in-string "\\(.*\\)\\.c" "valgrind --leak-check=full -v \\1.x" file-of-buffer))
)

(add-hook 'c-mode-hook
          (function (lambda ()
                      (local-set-key (kbd "C-c G")  'valgrind-currentfile)
                      )))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Auto-completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(global-set-key [(control tab)] 'senator-complete-symbol);
(global-set-key "\C-q" 'senator-completion-menu-popup)
;;(global-set-key [(control tab)] 'semantic-ia-complete-symbol-menu)
;;(global-set-key "\C-q" 'senator-completion-menu-popup)
;;(global-set-key "\C-l" 'senator-complete-symbol)

;;cc-mode
;;(defvar c-mode-syntax-table c-mode-syntax-table)
;;   ;; underscore considered part of word
;;      (modify-syntax-entry ?_ "w" c-mode-syntax-table)

;;Man POSIX on thing-at-piont
(defun posix-man-in-cc-mode ()
;;  "This function could use some safety checks."
 (interactive)
       (man (thing-at-point 'word))
)

(add-hook 'cc-mode-hook
 (function (lambda ()
   (local-set-key (kbd "C-c p") 'posix-man-in-cc-mode))))

;;(add-hook 'c-mode-hook
;;(local-set-key (kbd "C-c p") (lambda () (interactive) (man (thing-at-point 'symbol)))
;;)
;;)

(add-hook 'c-mode-hook (lambda () (local-set-key (kbd "C-c m") (lambda () (interactive) (man (thing-at-point 'symbol))) )) )

;;I don't like it that the compilation window takes up 1/2 of the frame by default. So, I use the following, which works well most of the time: 
(setq compilation-window-height 18)

;;I also don't like that the compilation window sticks around after a successful compile. After all, most of the time, all I care about is that the compile completed cleanly. Here's how I make the compilation window go away, only if there was no compilation errors: 
;;(setq compilation-finish-function
;;      (lambda (buf str)
;;
;;        (if (string-match "exited abnormally" str)
;;
;;            ;;there were errors
;;            (message "compilation errors, press C-x ` to visit")
;;
;;          ;;no errors, make the compilation window go away in 0.5 seconds
;;			(
;;                         if (eql major-mode 'compilation-mode) 
;;				(run-at-time 0.5 nil 'delete-windows-on buf)
;;                           
;;                        )
;;
;;          ;;(run-at-time 0.5 nil 'delete-window-on buf)
;;          (message "NO COMPILATION ERRORS!"))))

(add-to-list 'compilation-finish-functions #'compile-autoclose)
(defun compile-autoclose (buffer string)
  (cond ( (and (eql major-mode 'compilation-mode) (string-match "finished" string))
         (message "Build maybe successful: closing window.")
         ;;enable below to bury the compilation buffer
         (run-with-timer 4 nil 'bury-buffer "*compilation*")
         ;;enable below to kill the window
         ;;(run-with-timer 4 nil
         ;;                'delete-window
         ;;                (get-buffer-window buffer t))
         )
        (t
         (if (eql major-mode 'compilation-mode) (message "Compilation exited abnormally: %s" string) )
        )
  )
)

;;End of cc-mode =============================================================

;;;;Begin of magit ==== 
;;;;(defun my-magit-status ()
;;;;    "Don't split window."
;;;;      (interactive)
;;;;        (let ((pop-up-windows nil))
;;;;          (call-interactively 'magit-status)))
(add-to-list 'display-buffer-alist
                 '(".*COMMIT_EDITMSG". ((display-buffer-pop-up-window) .
                                        ((inhibit-same-window . t)))))
(defun myms ()
  "Start up my magit status in new frame."
  (interactive)
  (select-frame (make-frame '((name . "Emacs Magit Status")
                  (minibuffer . t))))
        (let ((pop-up-windows nil))
          (call-interactively 'magit-status)
          (call-interactively 'magit-log)
          (other-window -1)
    )    
)
;;;;;;;End of magit ==== 


;;;;Begin of nxhtml-mode =======================================================
;;
;;(load "~/.emacs.d/pkgs/nxhtml/autostart.el")
;;(setq auto-mode-alist
;;     (cons '("\\.\\(xml\\|xsl\\|rng\\|mxml\\|xhtml\\)\\'" . nxhtml-mode)
;;           auto-mode-alist))
;;(nxhtml-minor-mode t)
;;(nxhtml-global-minor-mode t)
;;;;(setq nxml-where-global t)
;;(setq nxhtml-skip-welcome t)
;;;;We dont want mumamo backgroud color
;;(setq mumamo-background-colors nil)

;;End of nxhtml-mode =========================================================

;;Begin of Gentoo-syntax =====================================================
(require 'gentoo-syntax)

(setq auto-mode-alist (cons '("\\.ebuild\\'" . ebuild-mode) auto-mode-alist)) 
(setq auto-mode-alist (cons '("\\.eclass\\'" . ebuild-mode) auto-mode-alist))

;;End of Gentoo-syntax =======================================================

;;Begin of ActionScript Mode==================================================
;;(load "~/.emacs.d/pkgs/ani-fcsh.el")
;;(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)
;;;; Activate actionscript-mode for any files ending in .as
;;(setq auto-mode-alist
;;     (cons '("\\.\\(as\\|as2\\|as3\\)\\'" . actionscript-mode)
;;           auto-mode-alist))
;;;; Load our actionscript-mode extensions.
;;;;(eval-after-load "actionscript-mode" '(load "as-config"))
;;;;End of ActionScript Mode====================================================

;;Begin of Mysql Command =====================================================
;;mysql desc command ---------------------------------------------------------------
(defun mysqldesctable-command ()
;;  "This function could use some safety checks."
  (interactive)      
;;   (shell-command-on-region (point)
;;             (mark) "links http://pear.php.net/" nil))
;;  (shell-command (concat "mysql -ucoverage -pcoverage -e 'use coverage;desc " (thing-at-point 'word) "'")))
  (shell-command (concat "mysql -uqxu -pmypass -e 'use QAResultBeta;desc " (thing-at-point 'word) "'")))

;;(global-set-key (kbd "C-c q") 'mysqldesctable-command)


;;mysql select one rec command ---------------------------------------------------------------
(defun mysqlselecttable-onerec-command ()
;;  "This function could use some safety checks."
  (interactive)      
;;   (shell-command-on-region (point)
;;             (mark) "links http://pear.php.net/" nil))
  (shell-command (concat "mysql -uqxu -pmypass -e 'use QAResultBeta;select * from " (thing-at-point 'word) " order by id DESC limit 1 \\G'")))

;;(global-set-key (kbd "C-c l") 'mysqlselecttable-onerec-command)

;;End of Mysql Command =====================================================

;;Begin of Python-mode =====================================================

;;    * C-j: Insert a new line with the same indentation level as the current line
;;    * RET: Insert a new line with the same indentation level as the current line
;;    * C-M-a: Go to the beginning of the current function or class
;;    * C-M-e: Go to the end of the current function or class
;;    * C-M-h: Mark the current function or class for copying, etc.
;;    * C-M-x: Execute the current function or class
;;    * C-c C-b: Submit a bug report
;;    * C-c C-c: Execute the buffer (i.e., the file being displayed)
;;    * C-c C-d: Trace the stack of the process being executed
;;    * C-c C-h: Get context-based help
;;    * C-c TAB: Indent a highlighted (or marked) region
;;    * C-c C-k: Mark a block of text. Using this at the head of a class or function definition will mark the entire block.
;;    * C-c C-l: Shift the region to the left. If the cursor is in the middle of a region, the lower half of the region will shift.
;;    * C-c RET: Execute the current file, opening a new window to show the output.
;;    * C-c C-n: Jump to the next statement.
;;    * C-c C-p: Jump to the previous statement.
;;    * C-c C-r: Shift the region to the right. If the cursor is in the middle of a region, the lower half of the region will shift.
;;    * C-c C-s: Execute a Python command.
;;    * C-c C-t: Toggle shells
;;    * C-c C-u: Go up one block
;;    * C-c C-v: List the version of the Python mode
;;    * C-c C-w: Run PyChecker
;;    * C-c !: Open the Python interactive shell
;;    * C-c #: Comment the highlighted (marked) region
;;    * C-c :: Check the indentation off-set
;;    * C-c <: Shift the region to the left
;;    * C-c >: Shift the region to the right
;;    * C-c ?: Show Python mode documentation
;;    * C-c |: Execute the highlighted (marked) part of the current program. 

;;Root Path of pylookup

;; PyDoc -----------------------------------------------------------------
(setq load-path (cons "~/.emacs.d/pkgs/python-mode-1.0" load-path))
(add-hook 'python-mode-hook
            (lambda ()
              (setq py-python-command "python2")
              (setq py-default-interpreter "python2")))

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
               'flymake-create-temp-inplace))
       (local-file (file-relative-name
            temp-file
            (file-name-directory buffer-file-name))))
      (list "pycheckers.sh"  (list local-file))))
   (add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init)))

(defun pydoc (w)
  "Launch PyDOC on the Word at Point"
  (interactive
   (list (let* ((word (thing-at-point 'word))
		(input (read-string 
			(format "pydoc entry%s: " 
				(if (not word) "" (format " (default %s)" word))))))
	      (if (string= input "") 
		         (if (not word) (error "No pydoc args given")
			    word) ;sinon word
		     input) ;sinon input
	         )))
  (shell-command (concat py-python-command " -c \"from pydoc import help;help('" w "')\"") "*PYDOCS*")
  (view-buffer-other-window "*PYDOCS*" t 'kill-buffer-and-window)
)

(add-hook 'python-mode-hook
  (function (lambda ()
    (local-set-key (kbd "C-p y") 'pydoc))))

;;----pydoc lookup for module.method info----  
(defun python-module-method-info ()  
  (interactive)  
   (let ((curpoint (point)) (prepoint) (postpoint) (cmd))  
     (save-excursion  
       (beginning-of-line)  
       (setq prepoint (buffer-substring (point) curpoint)))  
     (save-excursion  
       (end-of-line)  
       (setq postpoint (buffer-substring (point) curpoint)))  
     (if (string-match "[_a-z][_\\.0-9a-z]*$" prepoint)  
         (setq cmd (substring prepoint (match-beginning 0) (match-end 0))))  
     (if (string-match "^[_0-9a-z]*" postpoint)  
         (setq cmd (concat cmd (substring postpoint (match-beginning 0) (match-end 0)))))  
     (if (string= cmd "") nil  
       (let ((max-mini-window-height 0))  
         (shell-command (concat "pydoc " cmd))))))  
   
(add-hook 'python-mode-hook  
           (lambda ()  
             (local-set-key (kbd "C-p m") 'python-module-method-info)))

;;Python Web Doc ---------------------------------------------------------------
(defun pydoc-webinfo-command ()
;;  "This function could use some safety checks."
  (interactive)
;;      http://docs.python.org/2.7/search.html?q=threading&check_keywords=yes&area=default
;;      http://docs.python.org/2.7/py-modindex.html#cap-p
        (w3m-goto-url (concat "http://docs.python.org/2.7/py-modindex.html#cap-" (replace-regexp-in-string "\\([a-zA-Z]\\)\\(.*\\)" "\\1" (replace-regexp-in-string "\\." "/" (thing-at-point 'word)) ) ) )

)

;; highlight cursored lines in python-mode
;;(add-hook 'python-mode-hook 'hl-line-mode)

;; hs-minor-mode
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook
     (function (lambda ()
         (which-func-mode)
         ;;Code hiding
         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
         (local-set-key (kbd "<f6>") 'hs-hide-all)
         (local-set-key (kbd "<S-f6>") 'hs-show-all)
         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
		 (local-set-key (kbd "C-p w") 'pydoc-webinfo-command)
         )
       )
)


;; python-mode-pydoc
(add-hook 'python-mode-hook
 (lambda ()
  (local-set-key (kbd "C-p y") 'pydoc)))

(add-hook 'python-mode-hook
           (lambda ()
             (set (make-variable-buffer-local 'beginning-of-defun-function)
                  'py-beginning-of-def-or-class)
             (setq outline-regexp "def\\|class ")))

;;(add-hook 'python-mode-hook 'turn-on-eldoc-mode)

;;(add-hook 'python-mode-hook
;;          '(lambda () (eldoc-mode 1)) t)


;;End of Python-mode ============================================================

;;Begin of sh-mode ==========================================================

;; highlight cursored lines in sh-mode
;;(add-hook 'sh-mode-hook 'hl-line-mode)

;; hs-minor-mode
(add-hook 'sh-mode-hook 'hs-minor-mode)
(add-hook 'sh-mode-hook
     (function (lambda ()
         (which-func-mode)
         ;;Code hiding
         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
         (local-set-key (kbd "<f6>") 'hs-hide-all)
         (local-set-key (kbd "<S-f6>") 'hs-show-all)
         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
         )
       )
)

;;eval highlighted shell code
;;it seems C-x C-e works, how come ?
(add-hook 'sh-mode-hook
 (lambda()
  (interactive)
  (local-set-key (kbd "C-c C-l")
     '(lambda (beginning end)
       (interactive "r")
       (shell-command-on-region beginning end "/bin/bash")))))


;;run the current bash program
(defun run-currentshell ()
  (interactive)
  (setq bash-buffer-name buffer-file-name)
  (shell-command (concat "bash " (replace-regexp-in-string "\\(.*\\):\\(.*\\)" "\\2" bash-buffer-name)))
)

(add-hook 'sh-mode-hook
 (function (lambda ()
    (local-set-key [f11] 'run-currentshell))))


;;run the current bash with user-input command options
(defun run-bash-cmdopt ( Option )
;; "Run current bash with command option"
 (interactive "sCommand Option: ")
  (setq current-buffer-name buffer-file-name)
   (
     if (string-match "\\(.*\\):\\(.*\\):\\(.*\\)\\.sh" current-buffer-name)
        (shell-command (concat (match-string 3 current-buffer-name) " " Option))
      (shell-command (concat "bash " (replace-regexp-in-string "\\(.*\\):\\(.*\\)" "\\2" current-buffer-name) " " Option))
   )
)

(add-hook 'sh-mode-hook
 (function (lambda ()
    (local-set-key [(control f11)] 'run-bash-cmdopt))))

;;End of Shell-mode ============================================================

;;;;Begin of Csharp-mode ===========================================================
;;;;http://davh.dk/script/csharp-mode.el
;;;;http://www.emacswiki.org/emacs/download/csharp-mode.el, this is the new one should work
;; (autoload 'csharp-mode "csharp-mode"
;;   "Major mode for editing C# code." t)
;; (setq auto-mode-alist (cons '( "\\.cs\\'" . csharp-mode ) auto-mode-alist ))
;;
;;;;http://www.imayhem.com/cpardo/cske.html
;;(require 'compile)
;;(require 'cl)
;;
;;(add-hook 'csharp-mode-hook (lambda() (sln-minor-mode 1)))
;;
;;(load-library "cske/msbuild.el")
;;(load-library "cske/sln-mode.el")
;;(load-library "cske/csproj-mode.el")
;;(load-library "cske/sln-minor-mode.el")
;;
;;(add-to-list 'auto-mode-alist '("\\.sln$" . sln-mode)) 
;;(add-to-list 'auto-mode-alist '("\\.csproj$" . csproj-mode)) 
;;
;;;;;;; Helpers for building regexps.
;;;;(defmacro c-paren-re (re)
;;;;   `(concat "\\(" ,re "\\)"))
;;;;   (defmacro c-identifier-re (re)
;;;;   `(concat "\\[^_]"))
;;;;
;;;;;;hs-minor-mode
;;;;(add-hook 'csharp-mode-hook 'hs-minor-mode)
;;;;(add-hook 'csharp-mode-hook
;;;;     (function (lambda ()
;;;;         (which-func-mode)
;;;;         ;;Code hiding
;;;;         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
;;;;         (local-set-key (kbd "<f6>") 'hs-hide-all)
;;;;         (local-set-key (kbd "<S-f6>") 'hs-show-all)
;;;;         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
;;;;         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
;;;;         )
;;;;       )
;;;;)
;;;;
;;;;
;;;;;; Patterns for finding Microsoft C# compiler error messages:
;;;;(require 'compile)
;;;;(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
;;;;(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)
;;;;
;;;;;; Patterns for defining blocks to hide/show:
;;;;(push '(csharp-mode
;;;;        "\\(^\\s *#\\s *region\\b\\)\\|{"
;;;;        "\\(^\\s *#\\s *endregion\\b\\)\\|}"
;;;;        "/[*/]"
;;;;        nil
;;;;        hs-c-like-adjust-block-beginning)
;;;;      hs-special-modes-alist)
;;;;
;;;;;;folding brace-blocks
;;;;(unless (assoc 'csharp-mode hs-special-modes-alist)
;;;;          (push '(csharp-mode
;;;;                  "{" "}"
;;;;                  "/[*/]"
;;;;                  nil
;;;;                  hs-c-like-adjust-block-beginning)
;;;;                hs-special-modes-alist))
;;
;;;;Search C# Keyword on msdn
;;(defun msdn-csharp-webinfo-search ()
;;  ;;  "This function could use some safety checks."
;;    (interactive)
;;      (w3m-goto-url (concat "http://www.google.com/search?q=msdn+Csharp+" (thing-at-point 'word)) )
;;      )
;;
;;      (add-hook 'csharp-mode-hook
;;         (function (lambda ()
;;                (local-set-key (kbd "C-c p w") 'msdn-csharp-webinfo-search))))
;;
;;;;End of Csharp-mode =============================================================

;;;;Begin of nxml =============================
;;(load "nxml-mode-20041004/rng-auto.el")
;; (setq auto-mode-alist
;;       (cons '("\\.\\(xml\\|rng\\)\\'" . nxml-mode)
;;               auto-mode-alist))
;;(unify-8859-on-decoding-mode)
;;;;End of nxml =============================
;;
;;;;Begin of JDEE------------

;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/pkgs/jde-2.3.5.1/lisp"))
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/pkgs/elib-1.0"))
;;; If you DO NOT want Emacs to defer loading the JDE until you open a
;;;; Java file, edit the following line
;;(setq defer-loading-jde nil)
;;;; to read:
;;;;
;;;;(setq defer-loading-jde t)
;;;;

;;(if defer-loading-jde
;;    (progn
;;      (autoload 'jde-mode "jde" "JDE mode." t)
;;      (setq auto-mode-alist
;;            (append
;;            '(("\\.java\\'" . jde-mode))
;;             auto-mode-alist)))
;;        (require 'jde))

;;;; Sets the basic indentation for Java source files
;;;; to two spaces.
;;(defun my-jde-mode-hook ()
;;  (setq c-basic-offset 2)
;;)


;;(add-hook 'jde-mode-hook 'my-jde-mode-hook)

;;;; Include the following only if you want to run
;;;; bash as your shell.

;;;; Setup Emacs to run bash as its primary shell.
;;(setq shell-file-name "bash")
;;(setq shell-command-switch "-c")
;;(setq explicit-shell-file-name shell-file-name)
;;(setenv "SHELL" shell-file-name)
;;(setq explicit-sh-args '("-login" "-i"))
;;(if (boundp 'w32-quote-process-args)
;;  (setq w32-quote-process-args ?\")) ;; Include only for MS Windows.

;;;; jde-mode
;;(defvar jde-mode-syntax-table jde-mode-syntax-table)
;;   ;; dot considered part of word
;;   (modify-syntax-entry ?. "w" jde-mode-syntax-table)

;;;;JDK Web Doc ---------------------------------------------------------------
;;(defun jdkdoc-webinfo-command ()
;;;;  "This function could use some safety checks."
;;  (interactive)
;;;;      (if (string-match (rx (and "javax." (zero-or-more anything) )) (thing-at-point 'word)) (shell-command (concat "links http://java.sun.com/javaee/5/docs/api/" (replace-regexp-in-string "\\." "/" (thing-at-point 'word)) ".html" ) ) )
;;        (if (string-match (rx (and "javax." (zero-or-more anything) )) (thing-at-point 'word)) (w3m-goto-url (concat "http://docs.oracle.com/javase/7/docs/api/" (replace-regexp-in-string "\\." "/" (thing-at-point 'word)) ".html" ) ) )
;;;;      (if (string-match (rx (and "java." (zero-or-more anything) )) (thing-at-point 'word)) (shell-command (concat "links http://java.sun.com/j2se/1.5.0/docs/api/" (replace-regexp-in-string "\\." "/" (thing-at-point 'word)) ".html" ) ) )
;;        (if (string-match (rx (and "java." (zero-or-more anything) )) (thing-at-point 'word)) (w3m-goto-url (concat "http://docs.oracle.com/javase/7/docs/api/" (replace-regexp-in-string "\\." "/" (thing-at-point 'word)) ".html" ) ) )
;;)

;;;;hengha: no, you can save it.茂驴陆 Read (info "(emacs) Save Keyboard Macro")

;;(add-hook 'jde-mode-hook
;;;; ((lambda ()
;;;;  (define-key php-mode-map "\C-pw" 'phpdoc-webinfo-command))))
;;  (function (lambda ()
;;   (local-set-key (kbd "C-j w") 'jdkdoc-webinfo-command))))

;;;; ---End of JDEE--------------

;;Begin of w3m ==================================================================

(defun myw3m ()
  "browsing in a pop-up frame."
  (interactive)
  (select-frame (make-frame '((name . "w3m")
			      (minibuffer . t))))
  (call-interactively 'w3m)
)


;;load link on new tab, background
(defun rand-w3m-view-this-url-background-session ()
    (interactive)
      (let ((in-background-state w3m-new-session-in-background))
	    (setq w3m-new-session-in-background t)
	        (w3m-view-this-url-new-session)
		    (setq w3m-new-session-in-background in-background-state)))

(defun my-w3m-bindings ()
    (define-key w3m-mode-map (kbd "C-<return>") 'rand-w3m-view-this-url-background-session))

(add-hook 'w3m-mode-hook 'my-w3m-bindings)

;;;Emacs-w3m will now be invoked when you type the C-x m key 
;;;on a string which looks like a URL in any Emacs buffer. 
;;;In addition, you can use emacs-w3m to preview an HTML file 
;;;that you are just editing by typing the C-c C-v key 
;;;(note that you need to use Emacs and the html-mode major mode to edit the HTML file).
;;;(setq browse-url-browser-function 'w3m-browse-url)
;;;(global-set-key "\C-xm" 'browse-url-at-point)

;;;w3m
(setq load-path (cons "~/.emacs.d/pkgs/emacs-w3m" load-path))
(require 'w3m-load)

(setq w3m-async-exec t)

;; browse url in new tab by default
(setq browse-url-browser-function 'w3m-browse-url
     browse-url-new-window-flag t)

;;;set default homepage of w3m
(setq w3m-home-page "http://www.google.ca/")

;;switch between these engines in emacs-w3m buffer: C-u S
(require 'w3m-search)
(eval-after-load "w3m-search"
  '(progn
     	(add-to-list 'w3m-search-engine-alist
                  '("wikipedia" "http://en.wikipedia.org/wiki/Special:Search?search=%s" nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("emacswiki" "http://www.google.com/search?q=site:emacswiki.org+%s" nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("msdn" "http://www.google.com/search?q=site:msdn.microsoft.com+%s" nil))
   	(add-to-list 'w3m-search-engine-alist
		'("cpanmodule" "http://search.cpan.org/search?module=%s" nil))
   	(add-to-list 'w3m-search-engine-alist
		'("phpmodule" "http://www.php.net/%s" nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("hoogle"
                    "http://haskell.org/hoogle/?q=%s"
                    nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("quote"
                    "http://finance.google.com/finance?q=%s"
                    nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("portage" "http://packages.gentoo.org/search/?sstring=%s" nil))
     	(add-to-list 'w3m-search-engine-alist
                  '("ports"
                    "http://www.freebsd.org/cgi/ports.cgi?query=%s"
                    nil))
     	;; http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=
     	(add-to-list 'w3m-search-engine-alist
                  '("dict"
                    "http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=%s"
                    nil))
     (add-to-list 'w3m-uri-replace-alist                           
                  '("\\`w:" w3m-search-uri-replace "wikipedia"))
     (add-to-list 'w3m-uri-replace-alist                           
                  '("\\`ew:" w3m-search-uri-replace "emacswiki"))
     (add-to-list 'w3m-uri-replace-alist                           
                  '("\\`m:" w3m-search-uri-replace "msdn"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`q:" w3m-search-uri-replace "quote"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`y:" w3m-search-uri-replace "yahoo"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`g:" w3m-search-uri-replace "google"))
     (add-to-list 'w3m-uri-replace-alist
		  '("\\`dict:" w3m-search-uri-replace "dict"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`gp:" w3m-search-uri-replace "portage"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`fp:" w3m-search-uri-replace "ports"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`h:" w3m-search-uri-replace "hoogle"))))

;;;invoke different engine in w3m mode:U ew:emacs-w3m
(setq w3m-search-default-engine "cpanmodule")
(setq browse-url-browser-function 'w3m-browse-url)
(global-set-key (kbd "C-c w") 'browse-url-at-point)

;;;copying url at point
;;;

 (defun w3m-copy-url-at-point ()
    (interactive)
    (let ((url (w3m-anchor)))
      (if (w3m-url-valid url)
	    (kill-new (w3m-anchor))
        (message "No URL at point!"))))

   (add-hook 'w3m-mode-hook 
	       (lambda ()
		     (local-set-key "C-c w c" 'w3m-copy-url-at-point)))

(require 'w3m-lnum)
 (defun jao-w3m-go-to-linknum ()
   "Turn on link numbers and ask for one to go to."
   (interactive)
   (let ((active w3m-link-numbering-mode))
     (when (not active) (w3m-link-numbering-mode))
     (unwind-protect
         (w3m-move-numbered-anchor (read-number "Anchor number: "))
       (when (not active) (w3m-link-numbering-mode)))))

 (define-key w3m-mode-map "f" 'jao-w3m-go-to-linknum)

(defun w3m-browse-current-buffer ()
    (interactive)
    (let ((filename (concat (make-temp-file "w3m-") ".html")))
    (unwind-protect
    (progn
          (write-region (point-min) (point-max) filename)
	            (w3m-find-file filename))
           (delete-file filename))))

;; place your cursor over a link, save it in delicious
(defun delicious-post-url ()
   (interactive)
   (if (null (w3m-anchor))
        (message "no anchor at point")
        (let ((url (w3m-anchor)))
       (if (w3m-url-valid url)
             	  (progn
            	              (w3m-goto-url (concat "http://delicious.com/save?url=" url)))
             	              	(message "no URL at point!")))))

;; A wrapper for the w3m-view-this-url function.
;; Allows me to decide whether or not I want a link to open in new session in
;; the background without making everything open the background.
(defun my-view-this-url (session)
   (interactive "P")
   (if session
      (progn
            (setq w3m-new-session-in-background t)
                (w3m-view-this-url-new-session)
                (setq w3m-new-session-in-background nil))
            (w3m-view-this-url)))

(add-hook 'w3m-mode-hook
     (lambda ()
        (local-set-key "C-c w n" 'my-view-this-url)))

;;M-x w3m-link-numbering-mode toggles a minor mode showing link numbers on an overly
;;M-n M-x w3m-move-numbered-anchor, where n is the link number

;;End of w3m =====================================================================

;;Begin of Trac ================
;;End of Trac =================

;;Begin of vbnet-mode ==============
(autoload 'vbnet-mode "vbnet-mode" "Visual Basic mode." t)
 (setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vb\\|vbs\\)$" .
                                  vbnet-mode)) auto-mode-alist))

;;Search VB.NET Keyword on msdn
(defun msdn-vbdotnet-webinfo-search ()
  ;;  "This function could use some safety checks."
  (interactive)
  (w3m-goto-url (concat "http://www.google.com/search?q=msdn+VB.NET+" (thing-at-point 'word)) )
)

(add-hook 'vbnet-mode-hook
   (function (lambda ()
       (local-set-key (kbd "C-v w") 'msdn-vbdotnet-webinfo-search))))

;;
;;End of vbnet-mode ===============

;;Begin of powershell-mode =========
(autoload 'powershell-mode "powershell-mode" "A editing mode for Microsoft PowerShell." t)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode)) ; PowerShell script
;;End of powershell-mode ===========
;;Begin of javascript-mode=========================================================
;;(autoload 'javascript-mode "javascript" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Sets the basic indentation for Javascript source files
;; to two spaces.
(defun my-javascript-mode-hook ()
       (setq tab-width 8))

(add-hook 'js2-mode-hook 'my-javascript-mode-hook)

;;hs-minor-mode
(add-hook 'js2-mode-hook 'hs-minor-mode)
(add-hook 'js2-mode-hook
     (function (lambda ()
         (which-func-mode)
         ;;Code hiding
         (local-set-key (kbd "<f5>") 'hs-toggle-hiding)
         (local-set-key (kbd "<f6>") 'hs-hide-all)
         (local-set-key (kbd "<S-f6>") 'hs-show-all)
         (local-set-key (kbd "<f8>") '(lambda () (interactive) (point-to-register ?1)))
         (local-set-key (kbd "<S-f8>") '(lambda () (interactive) (register-to-point ?1)))
         )
       )
)


;;javascript-mode
;;Error on using following, why ?
;;(defvar javascript-mode-syntax-table javascript-mode-syntax-table)
;;  ;; dot considered part of word
;;  (modify-syntax-entry ?. "w" javascript-mode-syntax-table)

;;working
;;cc-mode is required to make c-populate-syntax-table work
(require 'cc-mode)
;;(defvar javascript-mode-syntax-table
(defvar js2-mode-syntax-table
 (let ((table (make-syntax-table)))
  (c-populate-syntax-table table)
  (modify-syntax-entry ?. "w" table)
  table)
 "Syntax table used in JavaScript mode.")

;;EXT Web Doc ---------------------------------------------------------------
(defun extdoc-webinfo-command ()
;;  "This function could use some safety checks."
 (interactive)
       (if (string-match (rx (and "Ext." (zero-or-more anything) )) (thing-at-point 'word)) (w3m-goto-url (concat "http://extjs.com/deploy/dev/docs/output/" (thing-at-point 'word) ".html" ) ) )
      ;;(w3m-goto-url (concat "http://extjs.com/deploy/dev/docs/output/" (thing-at-point 'word) ".html") )
)

(add-hook 'js2-mode-hook
 (function (lambda ()
              (local-set-key (kbd "C-j e") 'extdoc-webinfo-command))))

;;End of javascript-mode==========================================================

;;Begin of viper-mode======================================================================
;;copied from here: http://jasonal.blogspot.com/2006/12/viper-mode-in-emacs.html
;;(setq viper-mode t)
;;(require 'viper)
;;
;;(setq-default viper-mode t
;;viper-expert-level '5
;;;; ex-style don't allow you to move cross lines.
;;viper-ex-style-editing nil
;;viper-ex-style-motion nil
;;viper-auto-indent t
;;viper-inhibit-startup-message t
;;viper-eletric-mode t
;;viper-always t
;;viper-want-ctl-h-help t
;;viper-want-emacs-keys-in-insert t
;;viper-want-emacs-keys-in-vi t
;;viper-vi-style-in-minibuffer nil
;;viper-no-multiple-ESC t
;;viper-case-fold-search t
;;viper-re-search t
;;viper-re-query-replace t
;;viper-syntax-preference 'emacs
;;viper-delete-backwards-in-replace t
;;viper-parse-sexp-ignore-comments nil
;;viper-ESC-moves-cursor-back nil)
;;
;;(define-key viper-vi-global-user-map "\C-f" 'forward-char)
;;(define-key viper-vi-global-user-map "\C-b" 'backward-char)
;;(define-key viper-vi-global-user-map "\M-v" 'scroll-down)
;;(define-key viper-vi-global-user-map "\C-v" 'scroll-up)
;;(define-key viper-vi-global-user-map "\C-y" 'yank)
;;(define-key viper-vi-global-user-map "\C-e"
;;(or (command-remapping 'move-end-of-line) 'move-end-of-line))
;;
;;;; I don't like the default face in viper minibuffer
;;(setq viper-minibuffer-vi-face nil
;;viper-minibuffer-emacs-face nil)
;;;;;;colorize viper's mode-line indicator
;;;;(eval-after-load 'viper
;;;;     '(progn
;;;;       (setq viper-vi-state-id (concat (propertize "<V>" 'face 'hi-blue-b) " "))
;;;;       (setq viper-emacs-state-id (concat (propertize "<E>" 'face 'hi-red-b) " "))
;;;;       (setq viper-insert-state-id (concat (propertize "<I>" 'face 'hi-blue-b) " "))
;;;;       (setq viper-replace-state-id (concat (propertize "<R>" 'face 'hi-blue-b) " "))
;;;;       ;; The property `risky-local-variable' is a security measure
;;;;       ;; for mode line variables that have properties
;;;;       (put 'viper-mode-string 'risky-local-variable t))
;;;;)
;;;;End of viper-mode========================================================================

;;set cursor blink as Dark-orange
;;see complete color hex code here : http://www.tayloredmktg.com/rgb/
(set-cursor-color "#ff8c00")

;;Begin of Eshell==========================================================================
;;so that you can eval the lisp in eshell and get result in mini-buffer
(require 'esh-mode)
;;always save history
(setq eshell-save-history-on-exit t)
;;history size 
(setq eshell-history-size 5000)
;;emulate bash history as much as possible
(setq eshell-hist-ignoredups t)
(setq eshell-cmpl-cycle-completions nil)
;; add auto-completion in eshellWelcome to the Emacs shell
(setq eshell-prefer-to-shell t)
;; scroll to the bottom,make eshell more like a terminal
(setq eshell-scroll-to-bottom-on-output t)
(setq eshell-scroll-show-maximum-output t)
(add-to-list 'eshell-output-filter-functions 'eshell-postoutput-scroll-to-bottom)
;; C-a
;;; from ZwaX at EmacsWiki
;;; I use the following code. It makes C-a go to the beginning of the
;;; command line, unless it is already there, in which case it goes to the
;;; beginning of the line. So if you are at the end of the command line
;;; and want to go to the real beginning of line, hit C-a twice:
(defun eshell-maybe-bol ()
	(interactive)
	(let ((p (point)))
	(eshell-bol)
		(if (= p (point))
			(beginning-of-line)))
)
(add-hook 'eshell-mode-hook
		'(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))
;;man bash tweak
;; With the following, you can type info cvs at the eshell prompt and it
;; will work.
(defun eshell/info (subject)
	 "Read the Info manual on SUBJECT."
	 (let ((buf (current-buffer)))
	 (Info-directory)
	 (let ((node-exists (ignore-errors (Info-menu subject))))
	 (if node-exists
 	0
;; We want to switch back to *eshell* if the requested
;; Info manual doesn’t exist.
	 (switch-to-buffer buf)
	 (eshell-print (format "There is no Info manual on %s.\n"
	 subject))
 	1)))
 )

;;;; use ansi-term for these commands
(add-hook
 'eshell-first-time-mode-hook
 (lambda ()
 (setq
 eshell-visual-commands
 (append
 '("vim" "screen" "lftp" "python" "telnet" "ssh" "perldoc")
 eshell-visual-commands)))
)
;;End of eshell================================================================
;;;
;;(require 'em-term)
;;(dolist (item '("more" "vim" "sysinstall" "pydoc"))
;;  (add-to-list 'eshell-visual-commands item)
;;  (add-to-list 'eshell-visual-commands "vim")
;;  (add-to-list 'eshell-visual-commands "more")
;;)

;;(add-hook 'eshell-mode-hook
;;           (lambda ()
;;             (when viper-mode
;;               (setq viper-auto-indent nil))))

;;;(add-to-list 'eshell-visual-commands "perldoc")

;;;better solution for load commands in eshell:
;;; (eval-after-load "em-term" '(add-to-list 'eshell-visual-commands "perldoc"))
;;;or
;;; (when (not (boundp 'eshell-visual-commands)) (setq eshell-visual-commands ' ())) (add-to-list 'eshell-visual-commands "perldoc")
;;;however someone marked above command is bad idea in lisp programming:
;;;"In general, well-designed Lisp programs should not use [eval-after-load].  The clean and modular ways to interact with a Lisp library are (1) examine and set the library's variables (those which are meant for outside use), and (2) call the library's functions."

;;;This variable controls which method will be used
;;;when a method is not specified in the tramp file name. 
(require 'tramp)
(setq tramp-password-prompt-regexp ".*[Pp]assword: *$")
(setq tramp-shell-prompt-pattern "^[^;$#>]*[;$#>]*")
;;;[[Regexp `\(^[^#$%>
;;;]*[#$%>] *\|^[^;$#>]*[;$#>] *\)\'' not found in 60 secs]]
(setq password-cache-expiry nil)
(setq tramp-default-method "ssh")
(setq tramp-default-user "root")
;;;(setq tramp-default-host "localhost")

;;;(set-default 'tramp-default-proxies-alist (quote ((".*"
;;;"\\'harrison.teng\\'" "/ssh:%h:"))))
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\'harrison.teng\\'" "/ssh:bastion3ai.electric.net:"))))
;;;(add-to-list 'tramp-default-proxies-alist '(".*" "\'root\'" "/ssh:%h:"))
(defun sudo-edit (&optional arg)
    "Edit currently visited file as root.With a prefix ARG prompt for a file to visit.
  Will also prompt for a file to visit if current
  buffer is not visiting a file."
    (interactive "P")
	  (if (or arg (not buffer-file-name))
	      (find-file (concat "/sudo:root@localhost:"
                  (ido-read-file-name "Find file(as root): ")))
			      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
(global-set-key (kbd "C-x C-r") 'sudo-edit)

;;;(defun sudo-edit-current-file ()
;;;  (interactive)
;;;  (let ((position (point)))
;;;    (find-alternate-file
;;;     (if (file-remote-p (buffer-file-name))
;;;         (let ((vec (tramp-dissect-file-name (buffer-file-name))))
;;;           (tramp-make-tramp-file-name
;;;            "sudo"
;;;            (tramp-file-name-user vec)
;;;            (tramp-file-name-host vec)
;;;            (tramp-file-name-localname vec)))
;;;       (concat "/sudo:root@localhost:" (buffer-file-name))))
;;;    (goto-char position)))

;;(defun sudo-edit-current-file ()
;;  (interactive)
;;  (let ((my-file-name) ; fill this with the file to open
;;        (position))    ; if the file is already open save position
;;    (if (equal major-mode 'dired-mode) ; test if we are in dired-mode 
;;        (progn
;;          (setq my-file-name (dired-get-file-for-visit))
;;          (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
;;      (setq my-file-name (buffer-file-name); hopefully anything else is an already opened file
;;            position (point))
;;      (find-alternate-file (prepare-tramp-sudo-string my-file-name))
;;      (goto-char position))))


(defun prepare-tramp-sudo-string (tempfile)
  (if (file-remote-p tempfile)
      (let ((vec (tramp-dissect-file-name tempfile)))

        (tramp-make-tramp-file-name
         "sudo"
         (tramp-file-name-user nil)
         (tramp-file-name-host vec)
         (tramp-file-name-localname vec)
         (format "ssh2:%s@%s|"
                 (tramp-file-name-user vec)
                 (tramp-file-name-host vec))))
    (concat "/sudo:root@localhost:" tempfile)))

(define-key dired-mode-map [s-return] 'sudo-edit-current-file)

;;;(add-to-list 'load-path "~/.emacs.d/pkgs/tramp/lisp/")
;;;

;;;(add-to-list 'Info-default-directory-list "~/.emacs.d/pkgs/tramp/info/")

;;(add-to-list 'load-path "~/.emacs.d/pkgs/erc")
;;    (require 'erc)

;;;;Beging of ERC =========================================================
;;(defmacro asf-erc-bouncer-connect (command server port nick ssl pass)
;;  "Create interactive command `command', for connecting to an IRC server. The command uses interactive mode if passed an argument."
;;  (fset command
;;	`(lambda (arg)
;;	   (interactive "p")
;;	   (if (not (= 1 arg))
;;	       (erc-select ,server ,port ,nick)
;;	       (let ((erc-connect-function ',(if ssl
;;						 'open-ssl-stream
;;						 'open-network-stream
;;                                                 )
;;                                           )
;;                     )
;;		(erc ,server ,port ,nick "hengha" t ,pass)
;;               )))))
;;
;;(setq erc-prompt (lambda ()
;;		   (if (and (boundp 'erc-default-recipients) (erc-default-target))
;;		       (erc-propertize (concat (erc-default-target) ">") 'read-only t 'rear-nonsticky t 'front-nonsticky t)
;;		       (erc-propertize (concat "ERC>") 'read-only t 'rear-nonsticky t 'front-nonsticky t))))
;;
;;(asf-erc-bouncer-connect erc-freenode "irc.freenode.net" 6667 "hengha" nil "3565335653")
;;
;;;;(asf-erc-bouncer-connect erc-emc
;;	;;		 "irc.electric.net" 6667 "harrison" t nil)
;;
;;(defun irc ()
;;  "Start up my IRC connections."
;;  (interactive)
;;  (select-frame (make-frame '((name . "Emacs IRCS")
;;			      (minibuffer . t))))
;;  (call-interactively 'erc-freenode)
;;  ;;(sit-for 1)
;;  ;;(call-interactively 'erc-emc)
;;)
;;
;;;; C-c e o to emc
;;(global-set-key "\C-ceo" (lambda () (interactive)
;;                               (erc-select-ssl :server "irc.electric.net" :port "6667"
;;                                    :nick "harrison")))
;;
;;(setq erc-autojoin-channels-alist
;;         '(("freenode.net" "#emacs")
;;           ("electric.net" "#EMC")))
;;
;;;;End of ERC =============================================================


;;Begin of multi-term ====================================================
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)

(setq multi-term-program "/bin/bash")   ;; use bash
(setq term-default-bg-color "#000000")  ;; background color (black)
(setq term-default-fg-color "#dddd00")  ;; foreground color (yellow)

;; (setq multi-term-program "/bin/zsh") ;; or use zsh...

(add-hook 'term-mode-hook
 '(lambda ()
    (setq autopair-dont-activate t)
  )
)

(global-set-key (kbd "C-c m b") 'multi-term-prev) ;; move to previous term
(global-set-key (kbd "C-c m t") 'multi-term-next) ;; move to next term
(global-set-key (kbd "C-c m T") 'multi-term) ;; create a new one


;;(add-hook 'term-mode-hook
;;  only needed if you use autopair
;;  #'(lambda () (setq autopair-dont-activate t)))

;;End of multi-term ======================================================

;;Begin of g-client======================================================
;;(add-to-list 'load-path "/home/harrison/.emacs.d/pkgs/g-client/")
;;(load-library "g")
;;
;;;; Write to Diary any entry added to Google Calendar
;;(eval-after-load "gcal"
;;  '(progn
;;     (defun gcal-read-event (title content
;;                                 where
;;                                 start end
;;                                 who
;;                                 transparency status)
;;       "Prompt user for event params and return an event structure."
;;       (interactive
;;      (list
;;       (read-from-minibuffer "Title: ")
;;       (read-from-minibuffer "Content: ")
;;       (read-from-minibuffer "Where: ")
;;       (gcal-read-calendar-time "Start Time: ")
;;       (gcal-read-calendar-time "End Time: ")
;;       (gcal-read-who "Participant: ")
;;       (gcal-read-transparency)
;;       (gcal-read-status)))
;;       (save-excursion
;;       (let ((pop-up-frames (window-dedicated-p (selected-window))))
;;         (find-file-other-window (substitute-in-file-namediary-file)))
;;       (when (eq major-mode default-major-mode) (diary-mode))
;;       (widen)
;;       (diary-unhide-everything)
;;       (goto-char (point-max))
;;       (when (let ((case-fold-search t))
;;               (search-backward "Local  Variables:"
;;                                (max (- (point-max) 3000)(point-min))
;;                                t))
;;         (beginning-of-line)
;;         (insert "n")
;;         (forward-line -1))
;;       (let* ((dayname)
;;              (day (substring start 8 10))
;;              (month (substring start 5 7))
;;              (year (substring start 0 4))
;;              (starttime (substring start 11 16))
;;              (endtime (substring end 11 16))
;;              (monthname (calendar-month-name (parse-integer month) t))
;;              (date-time-string (concat (mapconcat 'eval calendar-date-display-form "")
;;                                        " " starttime " - " endtime)))
;;         (insert
;;          (if (bolp) "" "n")
;;          ""
;;          date-time-string " " title))
;;       (bury-buffer)
;;       (declare (special gcal-auth-handle))
;;       (let ((event (make-gcal-event
;;                     :author-email (g-auth-email gcal-auth-handle))))
;;         (setf (gcal-event-title  event) title
;;               (gcal-event-content event) content
;;               (gcal-event-where event) where
;;               (gcal-event-when-start event) start
;;               (gcal-event-when-end event) end
;;               (gcal-event-who event) who
;;               (gcal-event-transparency  event) transparency
;;               (gcal-event-status event) status)
;;         event)))))
;;
;;
;;(setq g-user-email "harrisonteng2010@gmail.com")
;;(gcal-emacs-calendar-setup)
;;(setq g-html-handler 'w3m-buffer)
;;End of g-client  =======================================================

;;;general emacs html converter
;;;(require 'htmlize)

;;;mi-config
;;(global-set-key "\C-hf" 'mode-info-describe-function)
;;(global-set-key "\C-hv" 'mode-info-describe-variable)
;;(global-set-key "\M-."  'mode-info-find-tag)

;;;gnusrv emacs
;;;(autoload 'gnuserv-start "gnuserv-compat"
;;;          "Allow this Emacs process to be a server for client processes."
;;;          t)
;;;(setq gnuserv-program "gnuserv-emacs")
;;;(gnuserv-start)

;;;Configuration for semantic
;;;(setq semantic-load-turn-useful-things-on t)
;;;Load for CEDET
;;;(require 'cedet)


;;Begin of Tramp =====================================================================
;;End of Tramp ======================================================================

;;Begin of golang mode ======
;;http://dominik.honnef.co/posts/2013/03/writing_go_in_emacs/
(add-to-list 'load-path "~/.emacs.d/elpa/go-mode-20151226.1224")
;;(setq load-path (cons "~/.emacs.d/pkgs/go-mode.el" load-path))
(require 'go-mode)
;;(require 'go-mode-load)
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook (lambda ()
						(local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
						(local-set-key (kbd "C-c i") 'go-goto-imports)
						(local-set-key (kbd \"M-.\") 'godef-jump)
						))
(setq load-path (cons "~/.emacs.d/pkgs/goflymake" load-path))
(add-to-list 'load-path "~/.emacs.d/pkgs/goflymake")
(require 'go-flymake)
;; format before save
(add-hook 'before-save-hook 'gofmt-before-save)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake)
(autoload 'flymake-find-file-hook "flymake" "" t)
(add-hook 'find-file-hook 'flymake-find-file-hook)
(setq flymake-gui-warnings-enabled nil)
(setq flymake-log-level 0)
(defun flymake-golang-init ()
  (defadvice flymake-save-buffer-in-file ;;;;fix for my goscript usage
  (around flymake-save-buffer-in-file-golang-fix
       (file-name)
       activate)
  (make-directory (file-name-directory file-name) 1)
  (save-excursion
    (goto-char 0)
    (when (looking-at "^#!/.*goscript.*")
      (progn (forward-line 1) (forward-char -1)))
    (write-region (point) (point-max) file-name nil 566))
  (flymake-log 3 "saved buffer %s in file %s" (buffer-name) file-name))
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    ;; edit this if you use `8g'/`6g' other than my `cg'
    ;; #!/bin/bash
    ;; 6g $*
    ;; exit 0
    (list "cg" (list "-o /dev/null" local-file))))
(setq flymake-allowed-file-name-masks
      (cons '(".+//.go$"
              flymake-golang-init
              flymake-simple-cleanup
              flymake-get-real-file-name)
            flymake-allowed-file-name-masks))
(defun flymake-display-current-error ()
  "Display errors/warnings under cursor."
  (interactive)
  (let ((ovs (overlays-in (point) (1+ (point)))))
    (catch 'found
      (dolist (ov ovs)
        (when (flymake-overlay-p ov)
          (message (overlay-get ov 'help-echo))
          (throw 'found t))))))
(global-set-key (kbd "C-c f") 'flymake-display-current-error)
(global-set-key (kbd "C-c m") 'flymake-mode)

;;golang webdoc
(defun golangdoc-webinfo-command ()
  (interactive)
  (message (thing-at-point 'word))
        (if (string-match (rx (and "github" (zero-or-more anything) )) (thing-at-point 'word)) 
            (let (p1 p2 pos2lineend)
              (setq p1 (point) )
              (setq p2 (line-end-position) )
              (setq pos2lineend (replace-regexp-in-string "\"" ""  (buffer-substring-no-properties p1 p2) ) )
              (w3m-goto-url pos2lineend)
              ) 
          (w3m-goto-url (concat "http://golang.org/pkg/" (thing-at-point 'word) "/" ) )
          )
)

(add-hook 'go-mode-hook
  (function (lambda ()
    (local-set-key (kbd "C-j w") 'golangdoc-webinfo-command))))

(add-hook 'go-mode-hook 'auto-complete-mode)
(require 'go-autocomplete)
(require 'auto-complete-config)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
;;End of golang mode ========
;;Harrison (add-to-list 'load-path "~/.emacs.d/pkgs/cedet-1.0pre4/speedbar")
(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
(define-key-after (lookup-key global-map [menu-bar tools])
[speedbar] '("Speedbar" . speedbar-frame-mode) [calendar])
(global-set-key [(f4)] 'speedbar-get-focus)
;;;w3 link listings
(autoload 'w3-speedbar-buttons "sb-w3" "s3 specific speedbar button generator.")

;;Harrison(add-to-list 'load-path "~/.emacs.d/pkgs/cedet-1.0pre4/eieio")

;;Harrison(add-to-list 'load-path "~/.emacs.d/pkgs/cedet-1.0pre4/semantic")
;;Harrison(setq semantic-load-turn-everything-on t)
;;Harrison(require 'semantic-load)


;; Load CEDET
;;Harrison(load-file "~/.emacs.d/pkgs/cedet-1.0pre4/common/cedet.el")

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; Select one of the following
;;Harrison(semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)

;; Enable this if you develop in semantic, or develop grammars
;;(semantic-load-enable-semantic-debugging-helpers)

(add-to-list 'load-path "~/.emacs.d/elpa/ecb-20140215.114")
(require 'ecb)
(setq ecb-tip-of-the-day nil)
(global-set-key [f12] 'ecb-activate) ;;activate ecb
(global-set-key [C-f12] 'ecb-deactivate) ;;deactivate ecb

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset (quote set-from-style))
 '(column-number-mode t)
 '(display-time-mode t)
 '(ecb-layout-window-sizes (quote (("left8" (0.1657142857142857 . 0.28378378378378377) (0.1657142857142857 . 0.22972972972972974) (0.1657142857142857 . 0.2702702702702703) (0.1657142857142857 . 0.16216216216216217)))))
 '(ecb-options-version "2.32")
 '(ecb-source-path (quote ("~/projects" "~/" "/cygdrive/c/Inetpub/wwwroot/enterprisemailer" "/svn" "/emcsvn")))
;; '(jde-help-docsets (quote (("JDK API" "nil" nil))))
;; '(jde-jdk (quote ("1.7.0_25")))
;; '(jde-jdk-doc-url "nil")
;; '(jde-jdk-registry (quote (("1.7.0_25" . "/usr/lib/jvm/java-7-oracle/"))))
 '(mumamo-chunk-coloring 1)
 '(regex-tool-backend (quote perl))
 '(safe-local-variable-values (quote ((eval add-hook (quote write-file-hooks) (quote time-stamp)))))
 '(show-paren-mode t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 20) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (set-background-color "black"))))
 '(transient-mark-mode t))

(require 'autoinsert)
(auto-insert-mode)
(setq auto-insert-directory "~/.mytemplates/")
(setq auto-insert t)
(define-auto-insert "\\.c\\'" "start.c") ;;; C Template
(define-auto-insert "\\.scs\\'" "startService.cs") ;;; C# Service Template
(define-auto-insert "\\.cs\\'" "start.cs") ;;; C# Template

(define-auto-insert "\\.h\\'" "start.c.h") ;;; C Header Template
(define-auto-insert "\\.java\\'" "start.java") ;;; Java Template
(define-auto-insert "\\.pl\\'" "start.pl") ;;; Perl Script Template
(define-auto-insert "\\.pm\\'" "pm.pl") ;;; Perl Module Template
(define-auto-insert "\\.sh\\'" "start.sh") ;;; Bash Template
(define-auto-insert "\\.py\\'" "start.py") ;;; Python Script Template
;;in Emacs 21 you have to say (rx (and foo bar)) instead of (rx foo bar)
(define-auto-insert (rx (and "class." (zero-or-more anything) ".py") ) "startclass.py") ;;; Python Class Template
(define-auto-insert "\\.php\\'" "start.php") ;;;  Script Template
(define-auto-insert (rx (and "class4." (zero-or-more anything) ".php") ) "class4.start.php") ;;; PHP4 Class Template
(define-auto-insert (rx (and "class5." (zero-or-more anything) ".php") ) "class5.start.php") ;;; PHP5 Class Template
(define-auto-insert (rx (and "aclass5." (zero-or-more anything) ".php") ) "aclass5.start.php") ;;; PHP5 Abstract Class Template
(define-auto-insert (rx (and "int." (zero-or-more anything) ".php") ) "int.start.php") ;;; PHP5 Interface Template
(define-auto-insert (rx (and "constants." (zero-or-more anything) ".php") ) "constant4.start.php") ;;; PHP4 Constants Template
;;(define-auto-insert "class\\.\\*\\.php\\'" "classstart.php") ;;; classstart.php

;;#disaster mode https://github.com/jart/disaster 
(eval-after-load 'cc-mode
  '(progn
     (require 'disaster)
     (defun my-c-mode-common-hook ()
       (define-key c-mode-base-map (kbd "C-c C-d") 'disaster)
       (define-key c-mode-base-map (kbd "C-c C-c") 'compile))
     (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)))

;; EMC mailer c tags
;;find /emcsvn/emc/emcmailer/trunk -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations -o EMCMAILER.TAGS
;;
;; EMC spamd c tags
;;find /emcsvn/emc/emcspamd/trunk -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations
;;
;; EMC libemcbase tags
;;find /emcsvn/emc/libemcbase -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations
;;
;; M4 perl tags
;;find /svn/trunk/broadcast -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.pl' -o -name '*.pm' -o -name '*.tpl' \) -print |xargs etags -a --declarations -o HM4L.TAGS
;; Campaign Connect PHP tag
;;find /svn/trunk/campaignconnect -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.php' -o -name '*.inc' -o -name '*.tpl' \) -print |xargs etags -a --declarations
;;
;; Fusemail PHP tag
;;find /emcsvn/fusemail/web -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.php' -o -name '*.inc' -o -name '*.tpl' \) -print |xargs etags -a --declarations
;;
;; EMC billing tag
;;find /emcsvn/billing/trunk -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.pl' -o -name '*.pm' -o -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations
;;
;; /svn/trunk/{broadcast,m4c} Perl,C source code
;;find /svn/trunk/{broadcast,m4c} -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.pl' -o -name '*.pm' -o -name '*.sh' -o -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations


;; Load up Python|Perl|bash|tcl|expect tag file
;;find ./projects /usr/include /usr/local/broadcast -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.py' -o -name '*.php' -o -name '*.inc' -o -name '*.tpl' -o -name '*.pl' -o -name '*.pm' -o -name '*.exp' -o -name '*.sh' -o -name '*.tcl' -o -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations
;;find ./projects /usr/include -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' \) -prune -o \( -name '*.c' -o -name '*.h' \) -print |xargs etags -a --declarations --language=c -o ./CTAGS

;;find ./projects /usr/include /usr/local/include -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.cpp' -o -name '*.h' \) -print |xargs etags -a --declarations -o HCCPP.TAGS

;;find ./projects/trunk /usr/include /usr/local/include -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.cpp' -o -name '*.h' \) -print |xargs etags -a --declarations -o HCCPP_T.TAGS

;;find /home/harrison/Documents/backup/openbsd44 -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.cpp' -o -name '*.h' \) -print |xargs etags -a --declarations -o HCCPPOB.TAGS


;;find /usr/include /usr/local/include /usr/local/broadcast -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.c' -o -name '*.cpp' -o -name '*.h' \) -print |xargs etags -a --declarations -o CCPP.TAGS

;;find ./projects -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.pl' -o -name '*.pm' -o -name '*.xs' \) -print |xargs etags -a --declarations -o HPL.TAGS

;;find /usr/local/broadcast -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.pl' -o -name '*.pm' -o -name '*.xs' \) -print |xargs etags -a --declarations -o HPL_P.TAGS


;;find ./projects -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o -name '*.py' -print |xargs etags -a --declarations -o HPY.TAGS

;;find ./projects/trunk/campaignconnect -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o -name '*.php' -print |xargs etags -a -o HPHP.TAGS
;; M-x visit-tags-table
(setq tags-file-name "~/TAGS")

;;Remeber the last settings
(require 'desktop)
(desktop-load-default)
(desktop-read)

;;(defun indent-buffer ()
;;  "Indent the currently visited buffer."
;;  (interactive)
;;  (indent-region (point-min) (point-max)))
;;
;;(defun indent-region-or-buffer ()
;;  "Indent a region if selected, otherwise the whole buffer."
;;  (interactive)
;;  (save-excursion
;;    (if (region-active-p)
;;        (progn
;;          (indent-region (region-beginning) (region-end))
;;          (message "Indented selected region."))
;;      (progn
;;        (indent-buffer)
;;        (message "Indented buffer.")))))

;;===========================
;;CVS shortcut keys
;;===========================

;;This mode runs the hook `cvs-mode-hook', as the final step
;;during initialization.

;;key             binding
;;---             -------
;;
;;C-c             Prefix Command
;;C-k             cvs-mode-acknowledge
;;C-o             cvs-mode-display-file
;;ESC             Prefix Command
;;SPC             cvs-mode-next-line
;;%               cvs-mode-mark-matching-files
;;+               cvs-mode-tree
;;-               negative-argument
;;0 .. 9          digit-argument
;;=               cvs-mode-diff
;;?               cvs-help
;;A               cvs-mode-add-change-log-entry-other-window
;;B               cvs-set-secondary-branch-prefix
;;C               cvs-mode-commit-setup
;;F               cvs-mode-set-flags
;;I               cvs-mode-insert
;;M               cvs-mode-mark-all-files
;;O               cvs-mode-update
;;S               cvs-mode-mark-on-state
;;T               cvs-mode-toggle-marks
;;U               cvs-mode-undo
;;a               cvs-mode-add
;;b               cvs-set-branch-prefix
;;c               cvs-mode-commit
;;d               cvs-mode-diff-map
;;e               cvs-mode-examine
;;f               cvs-mode-find-file
;;g               cvs-mode-revert-buffer
;;h               cvs-help
;;i               cvs-mode-ignore
;;l               cvs-mode-log
;;m               cvs-mode-mark
;;n               cvs-mode-next-line
;;o               cvs-mode-find-file-other-window
;;p               cvs-mode-previous-line
;;q               cvs-bury-buffer
;;r               cvs-mode-remove
;;s               cvs-mode-status
;;t               cvs-mode-tag
;;u               cvs-mode-unmark
;;x               cvs-mode-remove-handled
;;z               kill-this-buffer
;;DEL             cvs-mode-unmark-up
;;
;;<down-mouse-3>  cvs-menu
;;<mouse-2>       cvs-mode-find-file
;;<RET>           cvs-mode-find-file
;;
;;C-c C-c         cvs-mode-kill-process
;;
;;ESC s           cvs-status
;;ESC u           cvs-update
;;ESC e           cvs-examine
;;ESC c           cvs-checkout
;;ESC DEL         cvs-mode-unmark-all-files
;;ESC f           cvs-mode-force-command
;;
;;d v             cvs-mode-diff-vendor
;;d h             cvs-mode-diff-head
;;d b             cvs-mode-diff-backup
;;d d             cvs-mode-diff
;;d 2             cvs-mode-idiff-other
;;d e             cvs-mode-idiff
;;d =             cvs-mode-diff
;;d E             cvs-mode-imerge


;; psvn

;; This buffer uses svn-status mode in which the following keys are defined:
;; g     - svn-status-update:               run 'svn status -v'
;; M-s   - svn-status-update:               run 'svn status -v'
;; C-u g - svn-status-update:               run 'svn status -vu'
;; =     - svn-status-show-svn-diff         run 'svn diff'
;; l     - svn-status-show-svn-log          run 'svn log'
;; i     - svn-status-info                  run 'svn info'
;; r     - svn-status-revert                run 'svn revert'
;; X v   - svn-status-resolved              run 'svn resolved'
;; U     - svn-status-update-cmd            run 'svn update'
;; M-u   - svn-status-update-cmd            run 'svn update'
;; c     - svn-status-commit                run 'svn commit'
;; a     - svn-status-add-file              run 'svn add --non-recursive'
;; A     - svn-status-add-file-recursively  run 'svn add'
;; +     - svn-status-make-directory        run 'svn mkdir'
;; R     - svn-status-mv                    run 'svn mv'
;; C     - svn-status-cp                    run 'svn cp'
;; D     - svn-status-rm                    run 'svn rm'
;; M-c   - svn-status-cleanup               run 'svn cleanup'
;; k     - svn-status-lock                  run 'svn lock'
;; K     - svn-status-unlock                run 'svn unlock'
;; b     - svn-status-blame                 run 'svn blame'
;; X e   - svn-status-export                run 'svn export'
;; RET   - svn-status-find-file-or-examine-directory
;; ^     - svn-status-examine-parent
;; ~     - svn-status-get-specific-revision
;; E     - svn-status-ediff-with-revision
;; X X   - svn-status-resolve-conflicts
;; S g   - svn-status-grep-files
;; S s   - svn-status-search-files
;; s     - svn-status-show-process-buffer
;; h     - svn-status-pop-to-partner-buffer
;; e     - svn-status-toggle-edit-cmd-flag
;; ?     - svn-status-toggle-hide-unknown
;; _     - svn-status-toggle-hide-unmodified
;; m     - svn-status-set-user-mark
;; u     - svn-status-unset-user-mark
;; $     - svn-status-toggle-elide
;; w     - svn-status-copy-current-line-info
;; DEL   - svn-status-unset-user-mark-backwards
;; * !   - svn-status-unset-all-usermarks
;; * ?   - svn-status-mark-unknown
;; * A   - svn-status-mark-added
;; * M   - svn-status-mark-modified
;; * P   - svn-status-mark-modified-properties
;; * D   - svn-status-mark-deleted
;; * *   - svn-status-mark-changed
;; * .   - svn-status-mark-by-file-ext
;; * %   - svn-status-mark-filename-regexp
;; * s   - svn-status-store-usermarks
;; * l   - svn-status-load-usermarks
;; .     - svn-status-goto-root-or-return
;; f     - svn-status-find-file
;; o     - svn-status-find-file-other-window
;; C-o   - svn-status-find-file-other-window-noselect
;; v     - svn-status-view-file-other-window
;; I     - svn-status-parse-info
;; V     - svn-status-svnversion
;; P l   - svn-status-property-list
;; P s   - svn-status-property-set
;; P d   - svn-status-property-delete
;; P e   - svn-status-property-edit-one-entry
;; P i   - svn-status-property-ignore-file
;; P I   - svn-status-property-ignore-file-extension
;; P C-i - svn-status-property-edit-svn-ignore
;; P k   - svn-status-property-set-keyword-list
;; P K i - svn-status-property-set-keyword-id
;; P K d - svn-status-property-set-keyword-date
;; P y   - svn-status-property-set-eol-style
;; P x   - svn-status-property-set-executable
;; P m   - svn-status-property-set-mime-type
;; H     - svn-status-use-history
;; x     - svn-status-update-buffer
;; q     - svn-status-bury-buffer

;; C-x C-j - svn-status-dired-jump

