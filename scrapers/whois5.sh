#!/bin/bash

# Function to URL encode a string using Python3 (optional for future use)
urlencode() {
  local encoded
  encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))")
  echo "$encoded"
}

# Function to perform WHOIS lookup and extract domain details
lookup_domain_info() {
  local domain="$1"
  local whois_output

  # Perform WHOIS lookup and handle potential empty response
  whois_output=$(whois "$domain")
  if [[ -z "$whois_output" ]]; then
	printf '"%s","%s","%s","%s","%s","%s","%s"\n' "$domain" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A"
	return
  fi

  # Extract registrar (handle potential colons or commas)
  # registrar=$(echo "$whois_output" | grep -i -m 2 "Registrar:" | awk -F: '{print $2}' | tr -d ',' | xargs)
  registrar=$(echo "$whois_output" | sed -n '/Registrar:/s/^.*Registrar: //p' | head -n 1 | tr -d ',' | xargs || echo "N/A")


  # Extract other details using grep, awk, and xargs
  creation_date=$(echo "$whois_output" | grep -i -m 1 "Creation Date:" | awk -F: '{print $2}' | xargs)
  expiration_date=$(echo "$whois_output" | grep -i -m 1 "Expiration Date:" | awk -F: '{print $2}' | xargs)
  registrant_name=$(echo "$whois_output" | grep -i -m 1 "Registrant Name:" | awk -F: '{print $2}' | xargs)
  registrant_email=$(echo "$whois_output" | grep -i -m 1 "Registrant Email:" | awk -F: '{print $2}' | xargs)
  registrant_phone=$(echo "$whois_output" | grep -i -m 1 "Registrant Phone:" | awk -F: '{print $2}' | xargs)

  # Set default values for any empty fields
  registrar=${registrar:-"N/A"}
  creation_date=${creation_date:-"N/A"}
  expiration_date=${expiration_date:-"N/A"}
  registrant_name=${registrant_name:-"N/A"}
  registrant_email=${registrant_email:-"N/A"}
  registrant_phone=${registrant_phone:-"N/A"}

  # Print domain details in CSV format
  printf '"%s","%s","%s","%s","%s","%s","%s"\n' "$domain" "$registrar" "$creation_date" "$expiration_date" "$registrant_name" "$registrant_email" "$registrant_phone"
}

# Main script execution

# Check for whois command availability
if ! command -v whois &> /dev/null; then
  echo "Error: whois command not found. Please install it and try again."
  exit 1
fi

# Check for domains.csv file existence
if [[ ! -f domains.csv ]]; then
  echo "Error: domains.csv file not found!"
  exit 1
fi

# Write header to CSV file
echo '"Domain","Registrar","Creation Date","Expiration Date","Registrant Name","Registrant Email","Registrant Phone"' > domain_info.csv

# Read domains from file and process each
while IFS= read -r domain || [[ -n "$domain" ]]
do
  # Skip empty lines
  if [[ -z "$domain" ]]; then
	continue
  fi

  # Informative message about processing current domain
  echo "Processing domain: $domain"

  # Perform WHOIS lookup and extract information
  domain_info=$(lookup_domain_info "$domain")

  # Append extracted information to CSV file
  echo "$domain_info" >> domain_info.csv

  # Informative message about extracted information (optional)
  # echo "Extracted info: $domain_info"

done < domains.csv
