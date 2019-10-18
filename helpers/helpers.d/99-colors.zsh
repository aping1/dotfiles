
ANSI_COLORS=({0..15})
ANSI_EXT_COLOR=({16..231})
ANSI_EXT_GRAYSCALE=({232..255})
BUFFER=4

function print_ansi_colors () {
    local cols=$(tput cols)
    local req_cols=4
    local WORD=""
    for i in ${ANSI_COLORS[@]} ${(Oa)ANSI_COLORS[@]} ; do
        local _COUNTER=0
        # clear and set bg
        echo -en "\e[0m\n${i} \e[48;5;${i}m"
        for j in ${ANSI_COLORS[@]} ${(Oa)ANSI_COLORS[@]} ; do
            local _BASELINE=$(printf -- '[ BG=%-3s FG=%-3s ]' "${i}" "${j}")
            local _WORD="${1:-"${COUNTER}/${cols}"}"
            local SIZE_OF=${#_WORD}
            local _BASELINE_SIZEOF=${#_BASELINE}
            local _BUFFER_SPACE=$((  cols / req_cols  ))
            while [[ $(( _BUFFER_SPACE )) -ge $(( _BASELINE_SIZEOF + SIZE_OF ))  ]]; do  
                [[  ${_req_cols} -le 0 || ${req_cols} -ge  ${_cols} ]] && return 
                _BUFFER_SPACE=$((  cols / --req_cols ))
                echo  "SPLITS $cols /  $req_cols = $_BUFFER_SPACE [$SIZE_OF + $_BASELINE_SIZEOF]"
            done
            # echo  "SPLITS $cols /  $req_cols = $_BUFFER_SPACE [$SIZE_OF + $_BASELINE_SIZEOF]"
            # echo " [[ ${cols} -le 0 || $(( COUNTER += SIZE_OF + BUFFER )) -lt $((cols- BUFFER)) ]] "
            if [[ $(( COUNTER )) -ge $(( cols - _BUFFER_SPACE )) || ${cols} -le 0 ]] ; then
                COUNTER=0; echo -en "\e[0m\n${i} \e[48;5;${i}m"
                echo
            fi
            echo -en "\e[38;5;${j}m"
            printf -- '[ %s %-'$(( _BUFFER_SPACE - _BASELINE_SIZEOF ))'s BG=%-3s FG=%-3s ]' "$(( _BUFFER_SPACE ))" "${_WORD}" "${i}" "${j}"
            COUNTER=$(( COUNTER + _BUFFER_SPACE ))
            
        done
    done
    echo -ne "\e[0m"
}


