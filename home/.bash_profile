source ~/.bashrc
source ~/.bash_aliases

# Setting PATH for Python 3.10
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

[[ -f ~/.bashrc ]] && source ~/.bashrc # ghcup-env

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/joey/.lmstudio/bin"
# End of LM Studio CLI section

. "$HOME/.cargo/env"
