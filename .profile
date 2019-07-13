# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export PATH=/usr/lib/dart/bin:$HOME/.local/bin:/snap/bin:/usr/local/gradle/gradle-4.6/bin:/usr/local/kotlinc/bin:/usr/local/android-studio/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin:/usr/sbin:/local/bin:/usr/local/bin:/sbin:/usr/games:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/opt/android-sdk
export PATH=$PATH:$HOME/.cargo/bin:$HOME/yuzu/:$HOME/.nimble/bin:$HOME/nimlibs
export PATH=$PATH:$HOME/gcclibs/aarch64-linux-gnu/bin:$HOME/gcclibs/arm-linux-gnueabi/bin
export PATH=$HOME/android-studio/bin:$HOME/.pub-cache/bin:$HOME/flutter/bin:$PATH
export LD_LIBRARY_PATH=$HOME/Qt/5.12.0/gcc_64/lib:$LD_LIBRARY_PATH
export GOROOT=/usr/local/go
export GOBIN=$GOROOT/bin
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:/usr/local/go/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=${DEVKITPRO}/devkitARM
export DEVKITA64=${DEVKITPRO}/devkitA64
export PATH=$PATH:$DEVKITA64/bin:$DEVKITPRO/tools/bin
export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$HOME/.opam/4.05.0/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$PATH
export LD_LIBRARY_PATH="$HOME/Qt/5.12.0/gcc_64/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:/lib:/usr/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu"
export LFS=/mnt/lfs
export GODOT_BIN="$HOME/Godot/godot.x11.opt.tools.64"
export PYTHONSTARTUP="$HOME/.pythonstartup"
export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
# User specific aliases and functions:
# alias vim="/usr/bin/vim.gtk"
alias ls="ls -h --color=auto"
export CC=gcc
export CXX=g++
alias nv="nvim"
alias sudo="sudo "
alias vim="nvim"
alias did="vim +'normal Go' +'r!date' ~/Documents/did.txt"

alias lcat='pygmentize -g -O style=colorful,linenos=1 | grep -P "^\d\d\d\d:"'
alias ccat='pygmentize -g'
alias hcat='highlight -n -O ansi --force'
alias tcat='highlight -O ansi --force'

alias dc="docker-compose"

export WINEPREFIX=~/.WineItunes
export WINEARCH=win32
export PATH=~/.npm-global/bin:$PATH
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx

PS1="\n\[\e[30;01m\](\[\e[31;01m\]\w\[\e[30;01m\])\[\e[30;1m\]\n\[\e[30;1m\](\[\e[34m\]\$(/bin/date +'%a %b %e %-I:%M:%S %Z %Y')\[\e[30;1m\])\n\[\e[30;1m\](\[\e[32;1m\]\u @ \h\[\e[30;1m\])-> \[\e[0m\]"

export LANG=en_US.UTF-8

alias grep="grep --color"

alias openurl="x-www-browser"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
#xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/usr/lib/dart/bin:$HOME/.local/bin:/snap/bin:/usr/local/gradle/gradle-4.6/bin:/usr/local/kotlinc/bin:/usr/local/android-studio/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin:/usr/sbin:/local/bin:/usr/local/bin:/sbin:/usr/games:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/opt/android-sdk
export PATH=$PATH:$HOME/.cargo/bin:$HOME/yuzu/:$HOME/.nimble/bin:$HOME/nimlibs
export PATH=$PATH:$HOME/gcclibs/aarch64-linux-gnu/bin:$HOME/gcclibs/arm-linux-gnueabi/bin
export PATH=$HOME/.pub-cache/bin:$PATH
export PATH=$PATH:$HOME/flutter/bin
export GOROOT=/usr/lib/go-1.11/
export GOPATH=$HOME/go
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN
alias nim='$HOME/.nimble/bin/nim'
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=${DEVKITPRO}/devkitARM
export DEVKITA64=${DEVKITPRO}/devkitA64
export PATH=$PATH:$DEVKITA64/bin:$DEVKITPRO/tools/bin
export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$HOME/.opam/4.05.0/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$PATH
export LD_LIBRARY_PATH="$HOME/Qt/5.12.3/gcc_64/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:/lib:/usr/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu"
export LFS=/mnt/lfs
export PYTHONSTARTUP="$HOME/.pythonstartup"
export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export WINEPREFIX=~/.WineItunes
export WINEARCH=win32
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export PATH="/home/joey/Nim/bin:$HOME/.cargo/bin:$PATH"
