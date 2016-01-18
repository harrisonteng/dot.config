(require 'w3m-search)
(eval-after-load "w3m-search"
  '(progn
     (add-to-list 'w3m-search-engine-alist
                  '("quote"
                    "http://finance.google.com/finance?q=%s"
                    nil))
     (add-to-list 'w3m-search-engine-alist
                  '("ports"
                    "http://www.freebsd.org/cgi/ports.cgi?query=%s"
                    nil))
     ;; http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=
     (add-to-list 'w3m-search-engine-alist
                  '("dict"
                    "http://www.dict.org/bin/Dict?Form=Dict2&Database=*&Query=%s"
                    nil))
     (add-to-list 'w3m-search-engine-alist
                  '("hoogle"
                    "http://haskell.org/hoogle/?q=%s"
                    nil))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`q:" w3m-search-uri-replace "quote"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`y:" w3m-search-uri-replace "yahoo"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`g:" w3m-search-uri-replace "google"))
     (add-to-list 'w3m-uri-replace-alist
		  '("\\`dict:" w3m-search-uri-replace "dict"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`fp:" w3m-search-uri-replace "ports"))
     (add-to-list 'w3m-uri-replace-alist
                  '("\\`h:" w3m-search-uri-replace "hoogle"))))

(setq w3m-use-cookies t)
(setq browse-url-browser-function 'w3m-browse-url)
(global-set-key "\C-xm" 'browse-url-at-point)

;; use M-W (uppercase) to copy the url at the point
(defun w3m-copy-url-at-point ()
  (interactive)
  (let ((url (w3m-anchor)))
    (if (w3m-url-valid url)
	(kill-new (w3m-anchor))
	      (message "No URL at point!"))))
	      
(add-hook 'w3m-mode-hook 
	  (lambda ()	    
	    (local-set-key "\M-W" 'w3m-copy-url-at-point)))

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

(defun w3m-browse-current-buffer ()
  (interactive)
  (let ((filename (concat (make-temp-file "w3m-") ".html")))
    (unwind-protect
        (progn
          (write-region (point-min) (point-max) filename)
          (w3m-find-file filename))
      (delete-file filename))))

(defun w3m-download-with-curl (loc)
  (define-key w3m-mode-map "c"
    (lambda (dir)
      (interactive "Save to: ")
      (cd dir)
      (start-process "curl" "*curl*" "curl.exe" "-O" "-s" (w3m-anchor)))))

(add-hook 'w3m-form-input-textarea-mode-hook 
          (lambda()
            (save-excursion
              (while (re-search-forward "\r\n" nil t)
                (replace-match "\n" nil nil))
              (delete-other-windows))))

;; filter/translate unicode from web pages
(setq w3m-use-filter t)
;; send all pages through one filter
(setq w3m-filter-rules `(("\\`.+" w3m-filter-b7j0c)))

(defun w3m-filter-b7j0c (url)
  (let ((list '(
                ("&#187;" "&gt;&gt;")
                ("&laquo;" "&lt;")
                ("&raquo;" "&gt;")
                ("&ouml;" "o")
                ("&#8230;" "...")
                ("&#8216;" "'")
                ("&#8217;" "'")
                ("&rsquo;" "'")
                ("&lsquo;" "'")
                ("&#39;" "'")
                ("&amp;#39;" "'")
                ("\u2019" "\'")
                ("\u2018" "\'")
                ("\u201c" "\"")
                ("\u201d" "\"")
                ("&rdquo;" "\"")
                ("&ldquo;" "\"")
                ("&#8220;" "\"")
                ("&#8221;" "\"")
                ("\u2013" "-")
                ("\u2014" "-")
                ("&#8211;" "-")
                ("&#8212;" "-")
                ("&ndash;" "-")
                ("&mdash;" "-")
                )))
  (while list
    (let ((pat (car (car list)))
          (rep (car (cdr (car list)))))
      (goto-char (point-min))
      (while (search-forward pat nil t)
        (replace-match rep))
      (setq list (cdr list))))))

(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-file-name-coding-system 'utf-8
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8
      w3m-terminal-coding-system 'utf-8)

;; link numbering
  (require 'w3m-lnum)
  (defun my-w3m-go-to-linknum ()
    "Turn on link numbers and ask for one to go to."
    (interactive)
    (let ((active w3m-link-numbering-mode))
      (when (not active) (w3m-link-numbering-mode))
      (unwind-protect
          (w3m-move-numbered-anchor (read-number "Anchor number: "))
        (when (not active) (w3m-link-numbering-mode)))))

(define-key w3m-mode-map "f" 'my-w3m-go-to-linknum)

;; view buffers with w3m upon request
(global-set-key (kbd "<f11>") 'w3m-browse-current-buffer)