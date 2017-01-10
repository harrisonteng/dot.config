#!/bin/bash

emacsclient -c -n -e '(load "~/.emacs.clientinit.el")' --alternate-editor=vim --no-wait
