#!/bin/bash

RED="\e[31m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

if [[ "$#" -ne 2 ]]; then
    echo -e "\n${RED}[x]${ENDCOLOR} Must provide OS and port number to listen"
    echo -e "${YELLOW}[!]${ENDCOLOR} OS options: windows or linux"

    echo -e "\nUsage: shitty-revshell-listener.sh <OS> <PORT>"
    exit 1
else
    if uname -r | grep -q "microsoft"; then
        copy='/mnt/c/Windows/System32/clip.exe'
    elif [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
        copy='xclip -selection clipboard'
    else
        copy='wl-copy'
    fi
    if [[ "$1" == "linux" ]]; then
        echo -n "stty rows 46 cols 190" | $copy
        echo -e "\n${BLUE}[!]${ENDCOLOR} Fix stty size on the reverse shell"
        echo -e "${BLUE}[!]${ENDCOLOR} ${YELLOW}stty rows 46 cols 190${ENDCOLOR} copied to clipboard\n"
        stty raw -echo && rcat l -ie "/usr/bin/script -qc /bin/bash /dev/null; export TERM=xterm-256color; alias ls='ls --color=auto'; alias grep='grep --color=auto';" "$2" && reset
    elif [[ "$1" == "windows" ]]; then
        echo -ne "\n"
        rlwrap nc -lvnp "$2"
    else
        echo -e "\n${RED}[x]${ENDCOLOR} Invalid option\n"
    fi
fi
