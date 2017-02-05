export PATH=$HOME/Qt/5.5/gcc_64/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin:/usr/sbin:/local/bin:/usr/local/bin:/sbin:/usr/games:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/opt/android-sdk:/usr/local/Trolltech/Qt-4.8.6/bin
export PATH=$PATH:$HOME/Nim/bin:$HOME/Swift/usr/bin:$HOME/.nimble/bin:$HOME/nimlibs
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export PATH=/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$PATH
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:/lib:/usr/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu"
export LFS=/mnt/lfs
export PYTHONSTARTUP="$HOME/.pythonstartup"
#export WINEPREFIX=$HOME/prefix32
#export WINEARCH='win32'
export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256m"
alias vim="/usr/bin/vim"
# User specific aliases and functions:
alias ls="ls -h --color=auto"

PS1="\n\[\e[30;01m\](\[\e[31;01m\]\w\[\e[30;01m\])-(\[\e[33;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')B\[\e[30;1m\])\[\e[30;1m\]\n\[\e[30;1m\](\[\e[34m\]\$(/bin/date)\[\e[30;1m\])\n\[\e[30;1m\](\[\e[32;1m\]\u @ \h\[\e[30;1m\])-> \[\e[0m\]"

export LANG=en_US.UTF-8

export TERM=xterm

alias grep="grep --color"

alias openurl="x-www-browser"

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion



#DISPLAY=:0.0 xhost +
source ~/bashscripts/jd.bash

HISTSIZE=50000
HISTFILESIZE=500000

#st(){
#    while read line;do
#        sudo apt-get install -y "$line"
#    done < "b.txt"
#}
#if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
#    export TERM=xterm-256color
#fi
