#!/bin/bash

RED="\e[31m"
ENDCOLOR="\e[0m"

if [[ "$1" == "smb" || "$1" == "http" ]]; then
    echo -ne "\n"
    eza -T /usr/share/peass/
    echo -ne "\n"

    if [[ "$1" == "http" ]]; then
        python -m http.server 80 -d /usr/share/peass/
    else
        impacket-smbserver -smb2support share /usr/share/peass/
    fi
else
    echo -e "\n${RED}[x]${ENDCOLOR} Invalid option\n"
    echo "Usage: shitty-peass-server [smb|http]"
fi
