#!/bin/bash

epylint "$1" 2>/dev/null
pyflakes "$1"
pep8 --ignore=E221,E701,E202,E501,E265,W291,W1401 --repeat "$1"
true
