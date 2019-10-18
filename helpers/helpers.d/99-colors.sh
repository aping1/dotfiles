cols=$(tput cols)

ANSI_COLORS=({0..15})
ANSI_EXT_COLOR=({16..231})
ANSI_EXT_GRAYSCALE=({232..255})
BUFFER=4
STOP=$(( cols / 1 ))
COUNTER=0

for i in ${ANSI_COLORS[@]} ${(Oa)ANSI_COLORS[@]} ; do
        echo -en "\e[0m\n${i} \e[48;5;${i}m"
    for j in ${ANSI_COLORS[@]} ${(Oa)ANSI_COLORS[@]} ; do
        SIZE_OF="[${COUNTER}/${STOP} BG=${i} FG=${j}]"
        SIZE_OF=${#SIZE_OF}
        # echo " [[ ${STOP} -le 0 || $(( COUNTER += SIZE_OF + BUFFER )) -lt $((STOP - BUFFER)) ]] "
        if [[ $(( COUNTER += SIZE_OF + BUFFER )) -lt $((STOP - SIZE_OF)) || ${STOP} -le 0 ]] ; then
            echo -en "\e[38;5;${j}m[$((COUNTER))/${STOP} BG=${i} FG=${j}] " ;
        else
            COUNTER=0; echo -en "\e[0m\n${i} \e[48;5;${i}m \e[38;5;${j}m[${COUNTER}/${STOP} BG=${i} FG=${j}] " ;
        fi
    done
done
echo -ne "\e[0m"
