[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt prompt_subst
PROMPT='%F{black}%B(%F{red}%~%F{black})%f%b
%F{black}%B(%F{blue}$(/bin/date +"%a %b %e %-I:%M:%S %Z %Y")%F{black})%f%b
%F{black}%B(%F{green}%n%F{black})-> %f%b'
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/anaconda3/bin:/opt/homebrew/bin:/opt/homebrew/lib:/opt/homebrew/include:/usr/local/bin:$PATH"

# OS-specific ls colors/flags
if [[ $OSTYPE == darwin* ]]; then
  export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
  alias ls='ls -G'
  # Run Homebrew without pyenv shims in PATH
  alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
else
  alias ls='ls -h --color=auto'
fi

export CC=gcc
export CXX=g++
alias nv='nvim'
alias vim='nvim'
alias did="nvim +'normal Go' +'r!date' ~/.did.txt"
alias sshvalheim='ssh 192.168.1.173'
alias sshminecraft='ssh 192.168.1.232'


# Colorized cat variants
alias lcat='pygmentize -g -O style=colorful,linenos=1 | grep -P "^\d\d\d\d:"'
alias ccat='pygmentize -g'
alias hcat='highlight -n -O ansi --force'
alias tcat='highlight -O ansi --force'
alias grep='grep --color'

alias dc='docker-compose'

# Functions
gitrestore() {
  local file=$1
  if [[ -z $file ]]; then
    echo "Please specify a file!"
  else
    git checkout "$(git rev-list -n 1 HEAD -- "$file")"^ -- "$file"
    echo "File: $file restored!"
  fi
}

gitbasebranch() {
  echo "$(git show-branch -a \
    | grep '\*' \
    | grep -v "$(git rev-parse --abbrev-ref HEAD)" \
    | head -n1 \
    | sed 's/.*\[\(.*\)\].*/\1/' \
    | sed 's/[\^~].*//')"
}

# History (zsh uses SAVEHIST instead of HISTFILESIZE)
HISTSIZE=50000
SAVEHIST=500000
HISTFILE=$HOME/.zsh_history
# And some useful history options:
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY

export TERM=xterm-256color

. "$HOME/.langflow/uv/env"
