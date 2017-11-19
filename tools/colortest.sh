#!/bin/bash
for i in $(seq 0 16); do for j in $(seq 0 16); do [[ $j == 7 ]] && echo; printf "%02s %02s" ${i} ${j} ; echo -ne '\e[38;5;'${i}'m \e[48;5;'${j}'m butts \e[0m'; done ; echo; done
