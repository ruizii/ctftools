#!/bin/bash

RED="\e[31m"
BLUE="\e[34m"
MAGENTA="\e[35m"
ENDCOLOR="\e[0m"

function help() {
    echo ""

    echo -e "${BLUE}shitty-port-forward.sh${ENDCOLOR} - Generador de ${MAGENTA}netsh${ENDCOLOR} de redireccion de puertos."

    echo ""

    echo -e "Sintaxis:"
    echo -e "\t${BLUE}shitty-port-forward.sh${ENDCOLOR} ${MAGENTA}IP PUERTO${ENDCOLOR}"
    echo -e "\t${BLUE}shitty-port-forward.sh${ENDCOLOR} ${MAGENTA}-h${ENDCOLOR}"

    echo ""

    # WSL solo escucha en 127.0.0.1 por defecto. Esto no puede cambiarse
    echo -e "Descripcion:"
    echo -e "\tGenera comandos ${MAGENTA}netsh${ENDCOLOR} para redireccionar el puerto en la interfaz especificada al mismo puerto en ${MAGENTA}127.0.0.1${ENDCOLOR}."
    echo -e "\tDe esta manera, los servicios de ${MAGENTA}WSL${ENDCOLOR} son accesibles desde redes externas, ya que ${MAGENTA}WSL${ENDCOLOR} escucha solo en ${MAGENTA}127.0.0.1${ENDCOLOR}."
    echo -e "\n\tSe generan 2 comandos:"
    echo -e "\n\t\t- El primero es para crear la regla de redireccion de puertos."
    echo -e "\t\t- El segundo es para eliminarla."

    echo ""

    echo -e "Ejemplo:"
    echo -e "\t${BLUE}shitty-port-forward.sh${ENDCOLOR} 10.10.14.7 1234"
}

function error() {
    echo -e "${RED}[x]${ENDCOLOR} Error! $1"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$2" == "-h" ]] || [[ "$2" == "--help" ]] || [[ "$3" == "-h" ]] || [[ "$3" == "--help" ]]; then
    help
    exit 0
fi

if [[ "$#" -ne 2 ]]; then
    echo ""
    error "Uso incorrecto"
    exit 1
fi

address="$1"
port="$2"

if ! grep -P '^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$' -q <<<"$address"; then
    echo ""
    error "IP Invalida"
    exit 1
fi

if ! [[ $port =~ ^[0-9]+$ ]]; then
    echo ""
    error "El puerto debe ser un numero"
    exit 1
fi

if [[ $port -gt 65535 ]] || [[ $port -lt 1 ]]; then
    echo ""
    error "Numero de puerto invalido"
    exit 1
fi

echo ""

echo -ne "\t${BLUE}[+]${ENDCOLOR} "
echo -e "sudo netsh interface portproxy ${BLUE}add${ENDCOLOR} v4tov4 listenport=${BLUE}${port}${ENDCOLOR} listenaddress=${BLUE}${address}${ENDCOLOR} connectport=${BLUE}${port}${ENDCOLOR} connectaddress=${BLUE}127.0.0.1${ENDCOLOR}"

echo -ne "\t${BLUE}[+]${ENDCOLOR} "
echo -e "sudo netsh interface portproxy ${BLUE}delete${ENDCOLOR} v4tov4 listenport=${BLUE}${port}${ENDCOLOR} listenaddress=${BLUE}${address}${ENDCOLOR}"
