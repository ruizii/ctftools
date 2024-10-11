#!/bin/bash

RED="\e[31m"
ENDCOLOR="\e[0m"

outfile="scan.txt"
quick_outfile="quick_scan.txt"
url=""
quick=0
positional_amount=0

trap ctrl_c INT

function ctrl_c() {
    sudo rm -f "$outfile"
    echo -e "\n${RED}[x]${ENDCOLOR} Aborting scan" >&2
    exit 1
}

while [ "$#" -gt 0 ]; do
    case "$1" in
    -u)
        url="$1"
        shift 2
        ;;
    -o)
        outfile="$2"
        quick_outfile="$2"
        shift 2
        ;;
    -q)
        quick=1
        shift 1
        ;;

    --url=*)
        url="${1#*=}"
        shift 1
        ;;

    --quick)
        quick=1
        shift 1
        ;;

    --outfile=*)
        outfile="${1#*=}"
        quick_outfile="${1#*=}"
        shift 1
        ;;

    -*)
        echo -e "${RED}[x]${ENDCOLOR} Invalid option: $1" >&2
        exit 1
        ;;
    *)
        positional_amount=$((positional_amount + 1))
        if [[ "$positional_amount" -gt 1 ]]; then
            echo -e "${RED}[X]${ENDCOLOR} Can't have more than 1 positional argument" >&2
            exit 1
        fi
        url="$1"
        shift 1
        ;;
    esac
done

if [[ -z "$url" ]]; then
    echo -e "${RED}[x]${ENDCOLOR} Please provide IP address or domain name to scan" >&2
    exit 1
fi

if [[ "$quick" -eq 1 ]]; then
    if [[ -f /etc/arch-release ]]; then
        sudo nmap -sS -p- --open --min-rate=3000 -vvv "$url" -oN "$quick_outfile" | bat -pp -l python
        sudo chown "$USER":"$USER" "$quick_outfile"
    else
        sudo nmap -sS -p- --open --min-rate=3000 -vvv "$url" -oN "$quick_outfile" | batcat -pp -l python
        sudo chown "$USER":"$USER" "$quick_outfile"
    fi
    exit 0
fi

if [[ -f /etc/arch-release ]]; then
    sudo nmap -sS -p- -sCV -T4 --open -vvv "$url" -oN "$outfile" | bat -pp -l python
    sudo chown "$USER":"$USER" "$outfile"
else
    sudo nmap -sS -p- -sCV -T4 --open -vvv "$url" -oN "$outfile" | batcat -pp -l python
    sudo chown "$USER":"$USER" "$outfile"
fi
