# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

