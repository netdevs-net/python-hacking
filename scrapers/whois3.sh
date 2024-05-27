#!/bin/bash

# Output the header to the CSV file
echo "Domain,Registrar,Creation Date,Expiration Date,Registrant Name,Registrant Email,Registrant Phone" > domain_info.csv

# Check if the domains.csv file exists
if [[ ! -f domains.csv ]]; then
  echo "domains.csv file not found!"
  exit 1
fi

# Read the list of domains from a file and process each domain
while IFS= read -r domain
do
  # Debug: Print the current domain being processed
  echo "Processing domain: $domain"

  # Perform a WHOIS lookup for each domain
  whois_output=$(whois "$domain")

  # Debug: Print the WHOIS output
  # echo "WHOIS output for $domain:"
  # echo "$whois_output"

  # Extract the relevant information from the WHOIS output
  registrar=$(echo "$whois_output" | grep -i "Registrar:" | awk -F: '{print $2}' | xargs)
  creation_date=$(echo "$whois_output" | grep -i "Creation Date:" | awk -F: '{print $2}' | xargs)
  expiration_date=$(echo "$whois_output" | grep -i "Expiration Date:" | awk -F: '{print $2}' | xargs)
  registrant_name=$(echo "$whois_output" | grep -i "Registrant Name:" | awk -F: '{print $2}' | xargs)
  registrant_email=$(echo "$whois_output" | grep -i "Registrant Email:" | awk -F: '{print $2}' | xargs)
  registrant_phone=$(echo "$whois_output" | grep -i "Registrant Phone:" | awk -F: '{print $2}' | xargs)

  # Output the information in a row, appending to the CSV file
  echo "$domain,$registrar,$creation_date,$expiration_date,$registrant_name,$registrant_email,$registrant_phone" >> domain_info.csv

done < domains.csv