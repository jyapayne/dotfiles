# User specific aliases and functions:
# alias vim="/usr/bin/vim.gtk"
if [[ "$OSTYPE" == "darwin"* ]]; then
    export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
    alias ls="ls -G"
else
    alias ls="ls -h --color=auto"
fi
export CC=gcc
export CXX=g++
alias nv="nvim"
alias vim="nvim"
alias did="nvim +'normal Go' +'r!date' ~/Documents/did.txt"
alias sshvalheim="ssh 192.168.1.173"
alias sshminecraft="ssh 192.168.1.232"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

alias lcat='pygmentize -g -O style=colorful,linenos=1 | grep -P "^\d\d\d\d:"'
alias ccat='pygmentize -g'
alias hcat='highlight -n -O ansi --force'
alias tcat='highlight -O ansi --force'
alias grep='grep --color'

alias dc="docker-compose"

PS1="\n\[\e[30;01m\](\[\e[31;01m\]\w\[\e[30;01m\])\[\e[30;1m\]\n\[\e[30;1m\](\[\e[34m\]\$(/bin/date +'%a %b %e %-I:%M:%S %Z %Y')\[\e[30;1m\])\n\[\e[30;1m\](\[\e[32;1m\]\u\[\e[30;1m\])-> \[\e[0m\]"

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

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

gitbasebranch () {
    echo "$(git show-branch -a | grep '\*' | grep -v `git rev-parse --abbrev-ref HEAD` | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')"
}

#DISPLAY=:0.0 xhost +
source ~/bashscripts/jd.bash

source ~/bashscripts/disable_trackpad.bash

HISTSIZE=50000
HISTFILESIZE=500000

export TERM=xterm-256color
#source $HOME/.sdkman/bin/sdkman-init.sh
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
. $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
. /home/joey/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

