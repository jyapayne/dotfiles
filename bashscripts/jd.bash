#!/bin/bash -x
declare PROMPT_COMMAND="_execBeforePrompt"

source $HOME/bashscripts/gt.bash
source $HOME/bashscripts/message.bash

_execBeforePrompt(){

    echo -ne "\033]0;${PWD/$HOME/~}\007"
    _cache "d$PWD"
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

cacheFile="$(eval echo ~${USER})/.jdcache"

_cache(){
    path="$1"
    if [[ $PWD == "/" ]]; then
        path=$(echo "$1" | sed -e '0,/\//s/\///')
    fi
    if [ -z "$1" ]; then
        cat $cacheFile

    else
        touch $cacheFile
        #for var in $1; do
            isin=$(_cachecontains $path)
            if [ $isin -eq 0 ]; then
                echo "$path" >> $cacheFile
            fi
        #done >> $cacheFile
    fi
}

_cachecontains(){
    touch $cacheFile
    if [ -n "$1" ]; then
        a=$(grep "$1" $cacheFile)
        if [ -n "$a" ]; then
            echo 1
            return
        fi
    fi
    echo 0

}

_cachefind(){
    touch $cacheFile
    fType=$2
    query=$1
    if [[ "$query" != "" ]]; then
        grep "^$fType" $cacheFile | sed -e 's/.\(.*\)/\1/' | grep -i "$query"
        if [[ "$?" == "1" ]];then
            return 0
        fi
        return 1
    fi
    return 0
}
#while read line
#do
#     echo hi $line
# done <<< "`ls -1d *`"

#ls -1RAp | grep -v /\$ 
jd(){
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    #grabs all of the folders in the current subdirectory
    local suffix=""
    OPTIND=1
    while getopts "hf:s:p:" flag 
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
        s)
            grep --color=always --include="*$suffix" -r -n -i "$OPTARG"  * | sed -e "s/:/ +/" | sed -e "s/:/ --/" | sed -e "s/^/vim /"
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

_jd(){
    
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    local cur=${COMP_WORDS[COMP_CWORD]}
    cur=${cur//\"/}

    ftype=${COMP_WORDS[1]}

    if [[ "$ftype" == "-f" ]]; then
        fs=$(_cachefind "$cur" "f" )
    else
        fs=$(_cachefind "$cur" "d" )
    fi

    t=$(printf "%s\n\b" "$fs" | grep -i "$cur" )

    COMPREPLY=( $( compgen  -P\" -S\" -W "$t" -X "\!*$cur*" ) )
    
    IFS=$SAVEIFS

}

complete -F _jd jd

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

_checkCache(){
    fType=$2
    query=${1//\*/\.\*}
    ccont="$(_cachefind "$query" "$fType")"
    if [[ "$?" != "0" ]];then
        relevantDirs=($(printf "%s\n" "$ccont" | grep -i "$query"))
        numElements=${#relevantFolders[@]}
        
        if [[ "${relevantDirs[0]}" == "$query" ]]; then

            echo $query


            if [[ $fType == "f" ]];then
                xdg-open $query 2>/dev/null
                return 0
            fi

            cd $query
            return 0
        fi


        echo

        printf "%s\n" "$ccont" | grep -i "$query" | sed '/./=' | sed '/./N; s/\n/ - /' | grep -i "$query"
        
        echo
         
        if [[ $fType == "d" ]]; then
            read -p "Which cached folder? (Enter a number, c to continue to search, or q to quit) " fold
        else
            read -p "Which cached file? (Enter a number, c to continue to search, or q to quit) " fold
        fi

        if [ "$fold" == "" ] || [[ "$fold" == "c" ]];then
            return 1
        elif [ "$fold" == "q" ];then
            return 0
        elif ! [[ "$fold" =~ ^[0-9]+$ ]] ; then
            exec >&2; echo "error: Not a number"; return 0
        else
            choice=${relevantDirs[$((fold-1))]}
        fi

        if [[ $fType == "f" ]];then
            read -p "Which application would you like to open it with? (Enter for default)" app
        fi

        echo

        if [[ "$fold" != "" ]] && [[ $fold != "c" ]];then
            echo $choice

           
            if [[ $fType == "f" ]];then
                if [ "$app" == "" ]; then
                    xdg-open $choice 2>/dev/null
            
                else
                    $app $choice 2>/dev/null
                fi

                return 0
            fi

            cd $choice
            return 0
        fi
    fi
    return 1

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

q(){
    sysname="$1"
    testing="\/home\/runner\/testing\/"
    relSys=($(compgen -d $testing | cut -d/ -f5 | grep -i $sysname))
    relDirs=($(compgen -d $testing | grep -i $sysname | sed -e "s/$/\/queue/"))
    message $sysname relSys[@] relDirs[@] "Which queue folder would you like to go to?" "cd"
    
}

_q(){

    #SAVEIFS=$IFS
    #IFS=$(echo -en "\n\b")

    sysname="$1"
    direcs="$(compgen -d "\/home\/runner\/testing\/" | cut -d/ -f5)"

    local cur=${COMP_WORDS[COMP_CWORD]}

    fs=$direcs

    t=$(printf "%s\n\b" "$fs" | grep -i "$cur" )

    COMPREPLY=( $( compgen -W "${direcs}" -- ${cur} ) )
    
    #IFS=$SAVEIFS

}
complete -F _q q

