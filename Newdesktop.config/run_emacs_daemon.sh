#!/bin/bash

pkill emacs24;sleep 4;emacs24 --daemon --eval "(setq default-frame-alist '((font-backend . \"xft\") (set-background-color \"black\") (set-foreground-color \"white\")))"
