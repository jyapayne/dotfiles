source ~/.bashrc
source ~/.bash_aliases
. "$HOME/.cargo/env"

# Setting PATH for Python 3.10
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env