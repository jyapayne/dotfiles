set -U fish_user_paths $HOME/Nim/bin /usr/local/bin $HOME/.nimble/bin $HOME/nimlibs $fish_user_paths

# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
source ~/bashscripts/jd.fish
set -U fish_prompt_pwd_dir_length 0
set -x PYTHONSTARTUP "$HOME/.pythonstartup"
set -x LD_LIBRARY_PATH "/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:/lib:/usr/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu"

function prompt_pwd --description 'Print the current working directory, NOT shortened to fit the prompt'
    if test "$PWD" != "$HOME"
        printf "%s" (echo $PWD|sed -e 's|/private||' -e "s|^$HOME|~|")
    else
        echo '~'
    end

end

function disable_trackpad
    set ID (xinput --list | grep "ALPS DualPoint TouchPad" | grep -o -P 'id=(\d+)' | sed 's/id=//g')
    xinput set-prop "$ID" "Device Enabled" 0

    set ID (xinput --list | grep "ALPS DualPoint Stick" | grep -o -P 'id=(\d+)' | sed 's/id=//g')
    xinput set-prop "$ID" "Device Enabled" 0
end

alias grep "grep --color"

alias ls "ls -h --color=auto"

function fish_prompt
    echo
    set_color 777 --bold
    printf "("

    set_color red
    printf (prompt_pwd)

    set_color 777
    printf ")"
    #printf ")-("

    #set_color yellow
    #printf (ls -1 | wc -l | sed 's: ::g')
    #printf " files, "
    #printf (ls -lah | grep -m 1 total | sed 's/total //')
    #printf "B"

    #set_color 777
    #printf ")"

    echo

    #set_color blue
    #printf (date "+%a %b %e %I:%M:%S %Z %Y")
    #echo

    set_color 777
    printf "("

    set_color green
    printf (whoami)
    printf "@"
    printf (hostname)

    set_color 777
    printf ") -> "

end

function fish_greeting
    fortune -a
end
