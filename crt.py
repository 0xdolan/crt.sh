#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Author: @0xdolan
# Github: github.com/0xdolan/crt.sh
# Description: A simple python script to interact with crt.sh website to get certificate information
# Dependencies: requests, rich
# Date: July 2023


import argparse
import datetime
import json
import os

import requests
from rich.console import Console

console = Console()


class Crt:
    def __init__(self, domain):
        self.domain = domain
        self.url = f"https://crt.sh/?q=%25.{domain}&output=json"
        self.data = None
        self.result = None

    # Get certificate information from crt.sh
    def get_crt(self, number=0):
        try:
            response = requests.get(self.url)
            self.data = response.json()
            if number == 0:
                self.result = self.data
                return self.result
            else:
                self.result = self.data[:number]
                return self.result
        except Exception as e:
            console.print(f"[bold red]Error: {e}")

    # Save result to file in json format
    def save_result(self):
        today = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        current_dir = os.getcwd()
        file_name = f"{self.domain}_{today}.json"
        file_path = os.path.join(current_dir, file_name)
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(self.result, f, indent=4, default=str, ensure_ascii=False)
        console.print(f"[bold green]Result saved to file: {file_path}")


# Get arguments from command line
def get_args():
    parser = argparse.ArgumentParser(
        description="Get certificate information from crt.sh"
    )
    parser.add_argument(
        "-d",
        "--domain",
        type=str,
        required=True,
        help="Domain name to get certificate information",
    )
    parser.add_argument(
        "-n",
        "--number",
        type=int,
        help="Number of certificates to get, default is 0 (all)",
    )

    parser.add_argument("-j", "--json", action="store_true", help="Save result to file")
    args = parser.parse_args()
    return args


# Main function
def main():
    args = get_args()
    domain = args.domain
    number = args.number
    json = args.json

    crt = Crt(domain)
    result = crt.get_crt(number)

    if result:
        if json:
            crt.save_result()
        else:
            console.print(result)
    else:
        console.print("[bold red]No result found")


# Run main function
if __name__ == "__main__":
    main()
