# $HOME/.kshrc

# This is the Posix & Korn shell $ENV file (aka .kshrc).
# This file is sourced for interactive (ksh -i) sessions.
# BEWARE: Other shells may also source this file when setup as $ENV.


# TESTED:
# * HP-UX 11i (11.23)
#   - /bin/ksh (ksh88)
#   - /usr/bin/sh (posix)
# * Solaris 10 (u8)
#   - /bin/ksh (ksh88)
#   - /usr/xpg4/bin/sh (X/Open)
#   - /usr/dt/bin/dtksh (cde ksh93)
# * RHEL 5 (u4)
#   - /bin/sh (bash)


## Features:
##
## * colorized prompt
## * detects supported terminal color method: ascii escapes or ncurses tput.
## * bash/zsh automagic escape sequences (color prompts, etc).
## * xterm AND Putty dynamic titlebar.
## * dynamic working-dir in prompt lets you know when PWD is write protected.
## * enables GNU colorized ls, grep, etc.
## * does right thing when shells (bash, zsh) are invoked as /bin/sh (posix modes)
## * portable shell code.


echo ".kshrc $0"

# code here to sense if called as ENV

if   [ -n "$BASH_VERSION" ]
  then # bash
    #printf "enabling bash options\n"

    [ -f /etc/bashrc ] && . /etc/bashrc
    shopt -s checkwinsize   # Check window after each command.
    shopt -s dotglob        # files beginning with . to show 'echo *'.
    shopt -s histappend     # Append $HISTSIZE lines to $HISTFILE.
    export HISTCONTROL=${HISTCONTROL:-"ignoreboth"}       # Ignore repeated cmds, or begin with space.
    export HISTIGNORE=${HISTIGNORE:-"ls:ll:la:l."}        # Explicitly ignore file listing.
    export HISTTIMEFORMAT=${HISTTIMEFORMAT:-"%F %H:%M  "} # The libc strftime(3) format (man -s3 strftime).
    export HISTFILE="$HOME/.bash_history"    # Default is ~/.sh_history.
    export HISTSIZE=${HISTSIZE:-"2000"}               # Lines of command history logged (in memory).
    export HISTFILESIZE=${HISTSIZE:-"2000"}               # maximum number of history events to save (in file).

elif [ -n "$ZSH_VERSION" ]
  then # zsh
    #printf "enabling zsh options\n"

    setopt APPEND_HISTORY    # append to histfile, do not replace histfile on exit.
    setopt HIST_IGNORE_DUPS  # duplicates of the previous event ignored.
    setopt HIST_IGNORE_SPACE # no history on cmds starting with space char.
    setopt EXTENDED_HISTORY  # timestamp in history file.
    export HISTFILE="$HOME/.zsh_history" # Default is ~/.sh_history.
    export HISTSIZE=${HISTSIZE:-"2000"}               # Lines of command history logged (in memory).
    export SAVEHIST=${SAVEHIST:-"1000"}               # maximum number of history events to save (in file).

elif [ -n "$KSH_VERSION" ]
  then # ksh93
    #printf "enabling ksh93 options\n"
    set -o globstar
    export EXTENDED_HISTORY=ON                        # AIX-5.3 ksh datestamp in ksh history.
    export HISTFILE="$HOME/.ksh_history" # Default is ~/.sh_history.
    export HISTSIZE=${HISTSIZE:-"2000"}               # Lines of command history logged.
    export HISTEDIT=${HISTEDIT:-"$VISUAL"}            # History editor ; replaces obsolete var FCEDIT.

  else # ksh88 or Posix
    #printf "enabling ksh88 or Posix options\n"

    export HISTFILE="$HOME/.sh_history" # Default is ~/.sh_history.
    export HISTSIZE=${HISTSIZE:-"2000"}               # Lines of command history logged.
    export HISTEDIT=${HISTEDIT:-"$VISUAL"}            # History editor ; replaces obsolete var FCEDIT.
fi




# ${ZSH_VERSION:+%\{}


## Terminal color capability switch.
## in order of desire: tput, ascii
## NOTE: zsh seems to have escape sequences wrappers, like bash.
## NOTE: The zsh right side escape (close-stash) is itself escaped, but not the left (open-stash).
tput setaf 4
case $? in
  0) # tput works.
     tput sgr0
     #echo "TPUT STYLE CHOSEN"
     Rc="${BASH:+\\[}${ZSH_VERSION:+%{}`printf \"setaf 1\n\" | tput -S`${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Yc="${BASH:+\\[}${ZSH_VERSION:+%{}`printf \"setaf 3\n\" | tput -S`${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Bc="${BASH:+\\[}${ZSH_VERSION:+%{}`printf \"setaf 4\n\" | tput -S`${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Wc="${BASH:+\\[}${ZSH_VERSION:+%{}`printf \"setaf 7\nbold\n\" | tput -S`${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Nc="${BASH:+\\[}${ZSH_VERSION:+%{}`tput sgr0`${ZSH_VERSION:+%\}}${BASH:+\\]}"
  ;;
  *) # setup the ascii methods.
     #echo "ASCII STYLE CHOSEN"
     Rc="${BASH:+\\[}${ZSH_VERSION:+%{}\033[0;31m${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Yc="${BASH:+\\[}${ZSH_VERSION:+%{}\033[0;33m${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Bc="${BASH:+\\[}${ZSH_VERSION:+%{}\033[0;34m${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Wc="${BASH:+\\[}${ZSH_VERSION:+%{}\033[1;37m${ZSH_VERSION:+%\}}${BASH:+\\]}"
     Nc="${BASH:+\\[}${ZSH_VERSION:+%{}\033[0m${ZSH_VERSION:+%\}}${BASH:+\\]}"
  ;;
esac


# xterm and putty support dynamic in-session modification of the titlebar.
# NOTE: The "^[" and "^G" are literal escapes.

titlebar () {
  printf "^[]0;${@}^G" > `tty`
}



# This function updates the interactive prompt.
# Note the id(1) usage to work-around Solaris (without having to choose xpg4 id that supports -u).
setprompt() {

  _SYS=`hostname | sed 's|\..*||'`

  # The basename of the current working directory, with $HOME abbreviated with a tilde.
  # If the current working directory is a first-tier location, it is preceeded with a slash (example: /etc or /tmp).

  OIFS=$IFS
  IFS='/'
  set $PWD
  IFS=$OIFS
  unset OIFS

  if   [ "$PWD" = "$HOME" ]
    then _PWD='~'
  elif [ "$#" -le "2"  ]
    then _PWD="${PWD}"
    #else _PWD="${@:$#}"  # only in newish ksh or bash.
    else _PWD=`basename ${PWD}`
  fi
  shift $#

  # make non-writable dirs red.
  [ -w "${PWD}" ] || _PWD="${Rc}${_PWD}${_Nc}"

  case `id | cut -d'(' -f1 | cut -c5-` in
  0)   # Privledge prompt
    _PS1="${Rc}[${Nc}${LOGNAME}${Rc}@${Nc}${_SYS}${Rc}:${Nc}${Wc}${_PWD}${Nc}${Rc}]${Nc}${Wc}# ${Nc}"
    _PS2="${Rc}>  ${Nc}"
  ;;
  *)   # User prompt
    _PS1="${Bc}[${Nc}${LOGNAME}${Bc}@${Nc}${_SYS}${Bc}:${Nc}${Wc}${_PWD}${Nc}${Bc}]${Nc}${Wc}$ ${Nc}"
    _PS2="${Bc}>  ${Nc}"
  ;;
  esac
  COLUMNS=`expr ${#_PS1} + 10`
  PS1=`echo ${_PS1}`
  PS2=`echo ${_PS2}`

  # putty titlebar - section 4.9.1 putty User Manual
  # "PuTTY allows the server to send xterm control sequences which modify the title of the window in mid-session "
  # Please note the begining and ending are literal escapes (Control Sequences).
  # in VI - INSERT MODE - type ctrl+v - then type esc for "^[" OR ctrl+g for "^G" - then esc to exit insert mode.
  titlebar "${LOGNAME} @ ${_SYS} : ${PWD}"

  unset _SYS _PWD
}




# This function uses the korn shell built-in CD cmd, and the setprompt function together.
# the effect is the user prompt displays updated path.
# this function is designed to replaice (alias) the cd cmd.
prompt_cd() {
  ## the Use of built-in command function would assure only the builtin, non-aliased, functions are used.
  ## The command builtin does not exist in some ksh88, notable hp-ux 11i, but does in Solaris 10.
  #command 'cd' "$@" && setprompt

  ## ksh88 support - "\cd" is an alternative to avoid functions.
  ## Prevents the recursive alias expansion problem that the builtin command would otherwise handle.
  \cd "${@:-"$HOME"}" && setprompt
}



case `basename $VISUAL` in
  *[Vv][Ii]*)
    set -o vi
  ;;
  *macs*)
    set -o emacs
    # following for emacs keybind (bash/emacs style arrows).
    alias __A=`echo "\020"` # up
    alias __B=`echo "\016"` # down
    alias __C=`echo "\006"` # right
    alias __D=`echo "\002"` # left
  ;;
  *) # Some other editor?
     # ksh does not support other editors.
     set -o vi
  ;;
esac




# the prompt features the working path, and colors.
setprompt
alias cd="prompt_cd"
alias ..='prompt_cd ".." ; printf "$PWD\n"'


# List enhancements
# Solaris 5.11 may have GNU ls(1) installed.
[ "`uname -s`" = "SunOS" ] && \
[ "`uname -r`" = "5.11" ] && \
[ -x "/usr/gnu/bin/ls" ] && \
export PATH="/usr/gnu/bin/:$PATH" && \
alias ls='/usr/gnu/bin/ls'

# check for GNU ls (colorful list)
ls --version 2> /dev/null | grep GNU >/dev/null 2>&1 && export LS_COLOUR="--color=auto"

# check for human readable ( -h )
ls -h /dev/null 2> /dev/null 1>&2 && H='-h'

alias l.='ls -lAdF ${H} ${LS_COLOUR} .*'    # list only hidden things
alias la='ls -lAF ${H} ${LS_COLOUR}'        # list all
alias ll='ls -lF ${H} ${LS_COLOUR}'         # list long
alias ls='ls -F ${LS_COLOUR}'               # list with flags

## GNU grep, if available, has colorized output.
grep --version 2> /dev/null | grep GNU >/dev/null 2>&1 && alias grep='grep --color=auto'


# When EDITOR == vim ; alias vi to vim
[ "`basename $EDITOR`" = "vim" ] && alias vi='vim'

export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/5.5/packages/i386/

DOT_KSHRC=TRUE
export DOT_KSHRC
