#!/bin/bash

pkill emacs-snapshot;sleep 4;emacs-snapshot --daemon --eval "(setq default-frame-alist '((font-backend . \"xft\") (set-background-color \"black\") (set-foreground-color \"white\")))"
