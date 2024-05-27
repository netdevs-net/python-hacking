#!/bin/bash

urlencode() {
  local encoded
  encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))")
  echo "$encoded"
}

# Function to perform a WHOIS lookup and extract domain details
lookup_domain_info() {
  local domain=$1
  local whois_output

  whois_output=$(whois "$domain")
  
  if [[ -z "$whois_output" ]]; then
	echo "$domain,,,,,,"
	return
  fi

  registrar=$(echo "$whois_output" | grep -i -m 1 "Registrar:" | awk -F: '{print ($2,$3,$4)}' | xargs)
  creation_date=$(echo "$whois_output" | grep -i -m 1 "Creation Date:" | awk -F: '{print $2}' | xargs)
  expiration_date=$(echo "$whois_output" | grep -i -m 1 "Expiration Date:" | awk -F: '{print $2}' | xargs)
  registrant_name=$(echo "$whois_output" | grep -i -m 1 "Registrant Name:" | awk -F: '{print $2}' | xargs)
  registrant_email=$(echo "$whois_output" | grep -i -m 1 "Registrant Email:" | awk -F: '{print $2}' | xargs)
  registrant_phone=$(echo "$whois_output" | grep -i -m 1 "Registrant Phone:" | awk -F: '{print $2}' | xargs)

  # Ensure default values if any of the fields are empty
  registrar=${registrar:-"N/A"}
  creation_date=${creation_date:-"N/A"}
  expiration_date=${expiration_date:-"N/A"}
  registrant_name=${registrant_name:-"N/A"}
  registrant_email=${registrant_email:-"N/A"}
  registrant_phone=${registrant_phone:-"N/A"}

  echo "$domain,$registrar,$creation_date,$expiration_date,$registrant_name,$registrant_email,$registrant_phone"
}

# Main script execution

# Check if whois command is available
if ! command -v whois &> /dev/null; then
  echo "whois command not found. Please install it and try again."
  exit 1
fi

# Check if domains.csv file exists
if [[ ! -f domains.csv ]]; then
  echo "domains.csv file not found!"
  exit 1
fi

# Output the header to the CSV file
echo "Domain,Registrar,Creation Date,Expiration Date,Registrant Name,Registrant Email,Registrant Phone" > domain_info.csv

# Read the list of domains from the file and process each domain
while IFS= read -r domain || [[ -n "$domain" ]]
do
  # Skip empty lines
  if [[ -z "$domain" ]]; then
	continue
  fi

  # Debug: Print the current domain being processed
  echo "Processing domain: $domain"

  # Perform lookup and append to CSV
  domain_info=$(lookup_domain_info "$domain")
  echo "$domain_info" >> domain_info.csv

  # Debug: Print the extracted domain info
  echo "Extracted info: $domain_info"

done < domains.csv