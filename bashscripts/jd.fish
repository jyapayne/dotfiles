function ds
    du -ch 2>/dev/null| /bin/grep -P "\ttotal" | /bin/sed "s/\ttotal//"
end

function _jdhelp

    echo
    echo "jd [-f] QUERY [depth]"
    echo

    echo "Search for files or folders."

    printf "%-20s %-30s\n" "-f" "Searches files instead of directories"
    printf "%-20s %-30s\n" "-t" "Case sensitive mode"
    printf "%-20s %-30s\n" "-p" "Search files by suffix"
    printf "%-20s %-30s\n" "-h" "Display this message"
    printf "%-20s %-30s\n" "-s" "Search files recursively in current dir."
    printf "%-20s %-30s\n" "depth" "A number from 0-N that specifies the depth to search."
    printf "%-20s %-50s\n" "" "No flag is needed, just enter the number after the query."

end

function _findDirs
    set query $argv[1]
    set fType $argv[2]
    set depth $argv[3]

    if [ "$fType" = "d" ]

        if [ "$depth" = "" ]

            set direcs (ls -AR 2>/dev/null | grep ':$' | sed -e 's/\(.*\)./\1/' -e 's/..\(.*\)/\1/')

        else
            if test "$depth" -gt 4
                set direcs (ls -AR 2>/dev/null | grep ':$' | sed -e 's/\(.*\)./\1/' -e 's/..\(.*\)/\1/' | cut -d/ -f-$depth | uniq)
            else
                set direcs (find -maxdepth "$depth" -type d 2>/dev/null | sed -e 's/..\(.*\)/\1/')
            end

        end
    else
        set old $query
        set query $argv[1]
        if [ "$depth" = "" ]
            set direcs (find . -type f -iname \*$query\* -print 2>/dev/null | sed -e 's/..\(.*\)/\1/')
        else
            set direcs (find . -maxdepth "$depth" -type f -iname \*$query\* -print 2>/dev/null | sed -e 's/..\(.*\)/\1/')
        end
        set query $old
    end

    set relevantDirs (printf "%s\n" $direcs | grep -i "$query")
    set numElements (echo "$relevantDirs" | wc -w )

    if test "$relevantDirs[1]" -eq "$query"

        echo $query

        if [ $fType = "f" ]
            xdg-open $query 2>/dev/null
            return
        end

        cd $query
        return
    end

    if test "$numElements" -gt 0
        echo

        if [ $fType = "f" ]
            printf "%s\n" $direcs | grep -i "$query" | sed 's/^/-> vim /' | grep -i "$query"
        else
            printf "%s\n" $direcs | grep -i "$query" | sed 's/^/-> cd /' | grep -i "$query"
        end
        echo
    end
end


function jd
    set insensitive -i
    set depth ""

    getopts $argv | while read -l key value
        switch $key
            case d
                set depth $value
            case f
                _findDirs $value "f" ""
                return
            case t
                set -e insensitive
            case p
                set suffix "$value"
            case s
                grep --color=always --exclude-dir=".webassets-cache" \
                     --exclude-dir="dist" \
                     --exclude-dir="node_modules" --include="*$suffix" \
                     -r -n $insensitive "$value" * | \
                     sed -e "s/:/ +/" | sed -e "s/:/ --/" | sed -e "s/^/vim /"
                return
            case h
                _jdhelp
                return
            case '*'
                _findDirs $argv[1] "d" ""
                return
        end
    end
    _jdhelp
end

function read_prompt
    echo "Which window would you like to go to? (Enter a number or q to quit) "
end

function gt
    set query $argv[1]

    if test $query -eq '-l'
        wmctrl -l
        return
    end

    set wins (wmctrl -l | grep -i "$query" | cut -d' ' -f5-)
    #echo ${wins[@]}
    set relWins (printf "%s\n" $wins | grep -i "$query")

    set numElements (echo "$relWins" | wc -w )
   # echo ${relWins[@]}
   # echo $numElements
    if test $numElements -gt 1

        printf "%s\n" $wins | grep -i "$query" | sed '/./=' | sed '/./N; s/\n/ - /' | grep -i "$query"
        echo ''
        read -p read_prompt win

        if [ "$win" = "" ]
            return 1
        else if [ "$win" = "q" ]
            return 1
        else if not echo $win | grep -q -E '^[0-9]+$'
            echo "error: Not a number"; return 1
        else
            wmctrl -F -a $relWins[$win]
            wmctrl -F -a $relWins[$win]
        end

    else if test $numElements -gt 0
        wmctrl -F -a $relWins[0]
        wmctrl -F -a $relWins[0]
    end
end
