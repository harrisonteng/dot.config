;;;;;; make it fullscreen at the startup
;;;(add-to-list 'default-frame-alist '(fullscreen . maximized)) 

;; window size
(set-frame-size (selected-frame) 1024 1024)

;; set theme. Default theme is moe-light
;;(load-theme 'moe-dark t)

;; set highlight line for dark theme
(set-face-background 'highlight "orangered")                                                                                               
(set-face-background 'region "orangered")  
(set-background-color "black")
(set-foreground-color "white")
;; default font for this frame
(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
;; activate ecb
(ecb-activate)
