# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set PATH so it includes go's bin if it exists
if [ -d "/usr/local/go/bin" ] ; then
    PATH="$PATH:/usr/local/go/bin"
fi

# load cargo environment before starfish
. "$HOME/.cargo/env"

# https://starship.rs/
# title config based off https://stackoverflow.com/a/71467884/4918
function set_win_title() {
  local cmd=" ($@)"
  if [[ "$cmd" == " (starship_precmd)" || "$cmd" == " ()" ]]
  then
      cmd=""
  fi
  if [[ $PWD == $HOME ]]
  then
      if [[ $SSH_TTY ]]
      then
      echo -ne "\033]0; ??????? @ $HOSTNAME ~$cmd\a" < /dev/null
      else
      echo -ne "\033]0; ???? ~$cmd\a" < /dev/null
      fi
  else
      BASEPWD=$(basename "$PWD")
      if [[ $SSH_TTY ]]
      then
      echo -ne "\033]0; ??????? $BASEPWD @ $HOSTNAME $cmd\a" < /dev/null
      else
      echo -ne "\033]0; ???? $BASEPWD $cmd\a" < /dev/null
      fi
  fi
}

starship_precmd_user_func="set_win_title"
eval "$(starship init bash)"
trap "$(trap -p DEBUG |  awk -F"'" '{print $2}');set_win_title \${BASH_COMMAND}" DEBUG

# https://fly.io/docs/hands-on/install-flyctl/
if [ -d "$HOME/.fly" ]; then
  export FLYCTL_INSTALL="$HOME/.fly"
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi

# Use VSCode by default
export EDITOR="code --wait"

# Use BuildKit by default
export DOCKER_BUILDKIT=1

# NVM junk
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Keep it secret! Keep it safe!
if [ -f ~/.bash_secrets ]; then
    . ~/.bash_secrets
fi

# for debcargo
DEBEMAIL="david@black.co.at"
DEBFULLNAME="David Schmitt"
CHROOT=debcargo-testing-amd64-sbuild
export DEBEMAIL DEBFULLNAME CHROOT
export QUILT_PATCHES=debian/patches

# allow josm to run under wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_SCREENSHOTS_DIR=/home/david/Pictures/Screenshots
