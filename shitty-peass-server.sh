#!/bin/bash

RED="\e[31m"
ENDCOLOR="\e[0m"

if [[ "$1" == "smb" || "$1" == "http" ]]; then
    echo -ne "\n"
    eza -T /usr/share/peass-ng
    echo -ne "\n"

    if [[ "$1" == "http" ]]; then
        sudo updog -d /usr/share/peass-ng/ -p 80
    else
        sudo smbserver.py -smb2support share /usr/share/peass-ng/
    fi
else
    echo -e "${RED}[x]${ENDCOLOR} Invalid option\n"
    echo "Usage: shitty-peass-server [smb|http]"
fi
