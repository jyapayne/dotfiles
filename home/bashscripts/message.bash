message(){
    #if [ -z $1 ];then
    #    echo "message [query] (elements) (selection items) [selection message] [command]"
    #    return
    #fi
    query="$1"
    elements=("${!2}")
    selitems=("${!3}")
    msg="$4"
    command="$5"

    numElements=${#elements[@]}
    
    # echo ${relWins[@]}
    # echo $numElements
        
    if [ $numElements -gt 1 ]; then

        printf "%s\n" "${elements[@]}" | grep -i "$query" | sed '/./=' | sed '/./N; s/\n/ - /' | grep -i "$query"
        echo ''
        read -p "$msg (Enter q to quit) " sel
           
        if [ "$sel" == "" ] || [ "$sel" == "q" ];then
            return 1
        elif ! [[ "$sel" =~ ^[0-9]+$ ]] ; then
            exec >&2; echo "error: Not a number"; return 1
        else 
            echo '' 
            echo ${selitems[$((sel-1))]}
            $command ${selitems[$((sel-1))]} 
        fi

    else
        $command ${selitems[0]}
    fi
 
}
