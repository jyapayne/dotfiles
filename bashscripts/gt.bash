gt(){
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    query=$1

    if [ $query == '-l' ]; then
        wmctrl -l
        return
    fi

    wins=$(wmctrl -l | grep -i $1 | cut -d' ' -f5-)
    #echo ${wins[@]}
    relWins=($(printf "%s\n" "$wins" | grep -i "$query"))
    
    numElements=${#relWins[@]}
   # echo ${relWins[@]}
   # echo $numElements
    if [ $numElements -gt 1 ]; then

        printf "%s\n" "$wins" | grep -i "$query" | sed '/./=' | sed '/./N; s/\n/ - /' | grep -i "$query"
        echo ''
        read -p "Which window would you like to go to? (Enter a number or q to quit) " win
       
        if [ "$win" == "" ] || [ "$win" == "q" ];then
            return 1
        elif ! [[ "$win" =~ ^[0-9]+$ ]] ; then
            exec >&2; echo "error: Not a number"; return 1
        else 
            echo '' 
            echo ${relWins[$((win-1))]}
            wmctrl -F -a ${relWins[$((win-1))]} 
            wmctrl -F -a ${relWins[$((win-1))]} 
        fi

    elif [[ $numElements -gt 0 ]];then
        wmctrl -F -a ${relWins[0]} 
        wmctrl -F -a ${relWins[0]}
    fi
    IFS=$SAVEIFS
}


