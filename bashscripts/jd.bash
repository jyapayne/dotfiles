#!/bin/bash -x
declare PROMPT_COMMAND="_execBeforePrompt"

source $HOME/bashscripts/gt.bash
source $HOME/bashscripts/message.bash

_execBeforePrompt(){

    echo -ne "\033]0;${PWD/$HOME/~}\007"
}

ds(){
    du -ch 2>/dev/null| /bin/grep -P "\ttotal" | /bin/sed "s/\ttotal//"
}

ut ()
{
    if [ -z "$1" ]; then
        return;
    fi;
    local upto=$1;
    cd "${PWD/\/$upto\/*//$upto}"
}

trap _restoreIFS SIGINT

_restoreIFS(){
    IFS=$(echo -en " \t\n")
}

_ut ()
{
    SIFS=$IFS
    IFS=$'/\t\n'
    local cur=${COMP_WORDS[COMP_CWORD]}
    cur=${cur//\"/}

    dirss=$PWD
    COMPREPLY=( $( compgen -P\" -S\" -W "$dirss" -- "$cur" ) )
    IFS=$SIFS
}
complete -F _ut ut


jd(){
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    #grabs all of the folders in the current subdirectory
    local suffix=""
    local insensitive="-i"
    OPTIND=1
    while getopts "hf:s:p:t" flag
    do
        case $flag in
        h)
            _jdhelp
            return
            ;;
        f)

            _findDirs "$OPTARG" "f" "$3"
            return
            ;;
        p)
            suffix="$OPTARG"
            ;;
        t)
            insensitive=""
            ;;
        s)
            grep --color=always --exclude-dir=".webassets-cache" \
                 --exclude-dir="dist" \
                 --exclude-dir="node_modules" --include="*$suffix" \
                 -r -n $insensitive "$OPTARG"  * | \
                 sed -e "s/:/ +/" | sed -e "s/:/ --/" | sed -e "s/^/vim /"
            return
            ;;

        \?)
            echo Invalid argument.
            _jdhelp
            return
            ;;
        :)
            echo
            return
            ;;
        esac

        #echo "$flag" $OPTIND $OPTARG
    done

    _findDirs "$1" "d" "$2"

    IFS=$SAVEIFS


}

_jdhelp(){

    echo
    echo "jd [-f] QUERY [depth]"
    echo

    echo "Search for files or folders."

    printf "%-20s %-30s\n" "-f" "Searches files instead of directories"
    printf "%-20s %-30s\n" "-h" "Display this message"
    printf "%-20s %-30s\n" "-s" "Search files recursively in current dir."
    printf "%-20s %-30s\n" "depth" "A number from 0-N that specifies the depth to search."
    printf "%-20s %-50s\n" "" "No flag is needed, just enter the number after the query."

}

_findDirs(){
    query=${1//\*/\.\*}
    fType="$2"
    depth="$3"

    if [[ $fType == "d" ]]; then

        if [[ "$depth" == "" ]]; then

            direcs=$(ls -AR 2>/dev/null | grep ":$" | sed -e 's/\(.*\)./\1/' -e 's/..\(.*\)/\1/')

        else
            if [ $depth -gt 4 ]; then
                direcs=$(ls -AR 2>/dev/null | grep ":$" | sed -e 's/\(.*\)./\1/' -e 's/..\(.*\)/\1/' | cut -d/ -f-$depth | uniq)
            else
                direcs=$(find -maxdepth $depth -type d 2>/dev/null | sed -e 's/..\(.*\)/\1/')
            fi

        fi
    else
        old=$query
        query="$1"
        if [[ "$depth" == "" ]]; then
            direcs=$(find . -type f -iname \*$query\* -print 2>/dev/null | sed -e 's/..\(.*\)/\1/')
        else
            direcs=$(find . -maxdepth $depth -type f -iname \*$query\* -print 2>/dev/null | sed -e 's/..\(.*\)/\1/')
        fi
        query=$old
    fi

    relevantDirs=($(printf "%s\n" "$direcs" | grep -i "$query"))
    numElements=${#relevantDirs[@]}

    if [[ "${relevantDirs[0]}" == "$query" ]]; then

        echo $query


        if [[ $fType == "f" ]];then
            xdg-open $query 2>/dev/null
            return
        fi

        cd $query
        return
    fi

    if [ $numElements -gt 0 ]; then
        echo

        if [[ $fType == "f" ]];then
            printf "%s\n" "$direcs" | grep -i "$query" | sed 's/^/-> vim /' | grep -i "$query"
        else
            printf "%s\n" "$direcs" | grep -i "$query" | sed 's/^/-> cd /' | grep -i "$query"
        fi
        echo
    fi
}

rme(){
    patt="$1"
    except="$2"

    epatt=$(ls | grep "$1.*$2")

    rms=$(ls | grep $1)

    for rs in $rms; do
        if [[ $rs != "*$except*" ]] && [[ $rs != "*$patt*" ]]; then
            rm "-rf" $rs

        fi
    done

}
