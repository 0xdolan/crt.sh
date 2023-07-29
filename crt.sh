#!/bin/bash

# Author: @0xdolan
# Github: github.com/0xdolan/crt.sh
# Description: A simple bash script to interact with crt.sh website to get certificate information
# Dependencies: curl, jq
# Date: July 2023

# Define constants
BASE_URL="https://crt.sh/?q=%25."

# Function to display usage information
usage() {
    echo "Usage: bash $0 <domain> [-nv | -cn | -in | -id | -entry_timestamp | -not_before | -not_after | -serial_number]"
    exit 1
}

# Check if domain argument is provided
if [ -z "$1" ]; then
    usage
fi

# Construct the API URL
DOMAIN="$1"
URL="$BASE_URL$DOMAIN&output=json"

# Check and process the optional argument
if [ -n "$2" ]; then
    case "$2" in
    "-nv" | "name_value") FIELD=".name_value" ;;
    "-cn") FIELD=".common_name" ;;
    "-in") FIELD=".issuer_name" ;;
    "-id") FIELD=".id" ;;
    "-entry_timestamp") FIELD=".entry_timestamp" ;;
    "-not_before") FIELD=".not_before" ;;
    "-not_after") FIELD=".not_after" ;;
    "-serial_number") FIELD=".serial_number" ;;
    *) usage ;;
    esac
    # Fetch and process the data based on the chosen field
    curl -s "$URL" | jq -r ".[]$FIELD" | sed 's/\*\.//g' | sort -u
else
    # Fetch and display the entire JSON output
    curl -s "$URL" | jq -r
fi
