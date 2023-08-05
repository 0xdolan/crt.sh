#!/bin/bash

# Author: @0xdolan
# Github: https://github.com/0xdolan/crt.sh
# Description: This bash script interacts with the crt.sh website to retrieve certificate information.
# Dependencies: curl, jq
# Date: July 2023

# Define the base URL for crt.sh API
BASE_URL="https://crt.sh/?q=%25."

# Function to display usage information
display_usage() {
    echo "Usage: bash $0 <domain> [options]"
    echo "Options:"
    echo "  -nv | --name-value       Display certificate name value"
    echo "  -cn | --common-name      Display common name"
    echo "  -in | --issuer-name      Display issuer name"
    echo "  -id | --id               Display certificate ID"
    echo "  -entry_timestamp         Display entry timestamp"
    echo "  -not_before              Display not-before date"
    echo "  -not_after               Display not-after date"
    echo "  -serial_number           Display serial number"
    echo "  -h | --help              Display this help message"
    exit 1
}

# Check if a domain argument is provided
if [ -z "$1" ]; then
    display_usage
fi

# Handle help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_usage
fi

# Construct the API URL with the provided domain
DOMAIN="$1"
URL="$BASE_URL$DOMAIN&output=json"

# Check and process the optional argument
if [ -n "$2" ]; then
    case "$2" in
    "-nv" | "--name-value") FIELD=".name_value" ;;
    "-cn" | "--common-name") FIELD=".common_name" ;;
    "-in" | "--issuer-name") FIELD=".issuer_name" ;;
    "-id" | "--id") FIELD=".id" ;;
    "-entry_timestamp") FIELD=".entry_timestamp" ;;
    "-not_before") FIELD=".not_before" ;;
    "-not_after") FIELD=".not_after" ;;
    "-serial_number") FIELD=".serial_number" ;;
    *) display_usage ;;
    esac

    # Fetch and process the data based on the chosen field
    # Use curl to retrieve the data, jq to extract desired fields, sed to manipulate data, and sort to remove duplicates
    curl -s "$URL" | jq -r ".[]$FIELD" | sed 's/\*\.//g' | sort -u
else
    # Fetch and display the entire JSON output
    curl -s "$URL" | jq -r
fi
