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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/home/joey/.sdkman"
#[[ -s "/home/joey/.sdkman/bin/sdkman-init.sh" ]] && source "/home/joey/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/joey/cloudsdk/google-cloud-sdk/path.bash.inc' ]; then source '/home/joey/cloudsdk/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/joey/cloudsdk/google-cloud-sdk/completion.bash.inc' ]; then source '/home/joey/cloudsdk/google-cloud-sdk/completion.bash.inc'; fi

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/Documents/Keys/Test Cloud TTS-28e661a83ec0.json"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export HISTTIMEFORMAT="%F %T "

export BASH_SILENCE_DEPRECATION_WARNING=1
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
alias vim="nvim"
export JAVA_HOME=$(/usr/libexec/java_home -v 16.0.1)

export PATH="/Users/joey/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/.ghcup/bin/:$PATH"
export PATH="/usr/local/opt/gettext/bin:/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/lib:/opt/homebrew/include:$PATH"
export PATH="/Users/joey/.local/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="$HOME/Nim/bin:$HOME/.nimble/bin:$PATH"
#export PATH="$HOME/.nimble/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/sqlite/lib"
#export CPPFLAGS="-I/usr/local/opt/sqlite/include"

#export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
eval "$(hub alias -s)"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
#export PATH="/Library/Developer/CommandLineTools/usr/bin:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib:$PATH"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export GODOT_BIN="/Applications/Godot.app/Contents/MacOS/Godot"

# opam configuration
test -r /Users/joey/.opam/opam-init/init.sh && . /Users/joey/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export CPLUS_INCLUDE_PATH=$(llvm-config --includedir):/opt/homebrew/include:$CPLUS_INCLUDE_PATH
export LD_LIBRARY_PATH=$(llvm-config --libdir):/opt/homebrew/lib:$LD_LIBRARY_PATH
source $HOME/.ghcup/env
source /usr/local/lib/bazel/bin/bazel-complete.bash
export PATH="/opt/homebrew/opt/qt\@5/bin:$PATH"

# export LDFLAGS="-L/opt/homebrew/opt/qt\@5/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/qt\@5/include"

# export PKG_CONFIG_PATH="/opt/homebrew/opt/qt\@5/lib/pkgconfig"
export CMAKE_PREFIX_PATH=/opt/homebrew/Cellar/qt\@5/5.15.2
alias sshkvm4g="ssh root@172.111.1.101"
alias sshkvm2g="ssh root@172.111.1.102"
. "$HOME/.cargo/env"
