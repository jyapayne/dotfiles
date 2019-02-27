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
export PYTHONSTARTUP="$HOME/.pythonstartup"
export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
# User specific aliases and functions:
# alias vim="/usr/bin/vim.gtk"
alias ls="ls -h --color=auto"
export CC=gcc
export CXX=g++
alias nv="nvim"
alias did="vim +'normal Go' +'r!date' ~/Documents/did.txt"

alias lcat='pygmentize -g -O style=colorful,linenos=1 | grep -P "^\d\d\d\d:"'
alias ccat='pygmentize -g'
alias hcat='highlight -n -O ansi --force'
alias tcat='highlight -O ansi --force'

alias dc="docker-compose"

export WINEPREFIX=~/.WineItunes
export WINEARCH=win32

PS1="\n\[\e[30;01m\](\[\e[31;01m\]\w\[\e[30;01m\])\[\e[30;1m\]\n\[\e[30;1m\](\[\e[34m\]\$(/bin/date +'%a %b %e %-I:%M:%S %Z %Y')\[\e[30;1m\])\n\[\e[30;1m\](\[\e[32;1m\]\u @ \h\[\e[30;1m\])-> \[\e[0m\]"

export LANG=en_US.UTF-8

alias grep="grep --color"

alias openurl="x-www-browser"

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

#!/bin/bash
# Passing arguments to a function
gitrestore () {
    local file="$1"
    if [ -z "$file" ]
    then
        echo "Please specify a file!"
    else
        git checkout $(git rev-list -n 1 HEAD -- "$file")^ -- "$file"
        echo "File: $file restored!"
    fi
}

#DISPLAY=:0.0 xhost +
source ~/bashscripts/jd.bash

source ~/bashscripts/disable_trackpad.bash

HISTSIZE=50000
HISTFILESIZE=500000

export TERM=screen-256color
#source $HOME/.sdkman/bin/sdkman-init.sh
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
. $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
. /home/joey/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
