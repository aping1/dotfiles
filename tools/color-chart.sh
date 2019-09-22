#!/bin/bash

color=1
a=1

while [[ "$color" -lt 245 ]]; do
    for i in {1..16}; do 
        printf -- '\033[38;5;%sm%s \033[48;5;%sm%s \033[0m ' "$((color))" "bg=${color}" "$(( i ))" "fg=$(( i ))"
    done
    echo 
    ((color = color + 1))
done
