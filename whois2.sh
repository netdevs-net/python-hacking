#!/bin/bash

# Function to perform WHOIS lookup and extract information
get_domain_info() {
  domain="$1"
  whois_output=$(whois $domain 2>&1)  # Capture standard output and error (2>&1)

  # Check if WHOIS lookup failed (non-zero exit code)
  if [[ $? -ne 0 ]]; then
	echo "Error: WHOIS lookup failed for $domain" >&2  # Write error message to standard error
	return 1  # Indicate error by returning non-zero exit code
  fi

  # Extract registrar (handle potential missing value)
  registrar=$(echo "$whois_output" | grep "Registrar:" | awk '{print $2}') || echo "N/A"

  # Extract creation date (handle potential missing value)
  creation_date=$(echo "$whois_output" | grep "Creation Date:" | awk '{print $3}') || echo "N/A"

  # Extract expiration date (handle potential missing value)
  expiration_date=$(echo "$whois_output" | grep "Expiration Date:" | awk '{print $3}') || echo "N/A"

  # Extract additional information (optional)
  # registrant_name=$(echo "$whois_output" | grep "Registrant Name:" | awk '{print $2}')
  # registrant_email=$(echo "$whois_output" | grep "Registrant Email:" | awk '{print $2}')
  # registrant_phone=$(echo "$whois_output" | grep "Registrant Phone:" | awk '{print $2}')

  # Return extracted information (optional for modifying output)
  # echo "$domain,$registrar,$creation_date,$expiration_date,$registrant_name,$registrant_email,$registrant_phone"
  echo "$domain,$registrar,$creation_date,$expiration_date"
}

# Read domains from file
while read -r domain; do
  # Output header (only once)
  if [[ $line_number -eq 1 ]]; then
	echo "Domain,Registrar,Creation Date,Expiration Date"
	line_number=$((line_number+1))
  fi

  # Perform WHOIS lookup and get information
  domain_info=$(get_domain_info "$domain")

  # Check if WHOIS lookup failed (returned non-zero exit code from function)
  if [[ $? -eq 1 ]]; then
	continue  # Skip to next domain if WHOIS lookup failed
  fi

  # Output domain information in a row
  echo "$domain_info" | tr -d '\n' >> domain_info.csv

done < domains.csv 