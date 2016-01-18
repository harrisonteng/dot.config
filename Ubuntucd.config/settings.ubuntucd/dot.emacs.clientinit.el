;;emacsclient -c -n -e '(load "~/.emacs.d/clientinit.el")'
;; window size
(set-frame-size (selected-frame) 200 65)

;; set theme. Default theme is moe-light
;;(load-theme 'moe-dark t)

;; set highlight line for dark theme
(set-face-background 'highlight "orangered")                                                                                               
(set-face-background 'region "orangered")  
(set-background-color "black")
(set-foreground-color "white")
;; default font for this frame
(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; activate ecb
(ecb-activate)
