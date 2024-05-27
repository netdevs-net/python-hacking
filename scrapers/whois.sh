#!/bin/bash

# Store the list of domains in an array
while read domain
do
  # Output the header
  echo "Domain,Registrar,Creation Date,Expiration Date"

  # Perform a WHOIS lookup for each domain
  whois_output=$(whois "$domain")

  # Extract the relevant information from the WHOIS output
  registrar=$(echo "$whois_output" | grep "Registrar:" | awk '{print $2}')
  creation_date=$(echo "$whois_output" | grep "Creation Date:" | awk '{print $3}')
  expiration_date=$(echo "$whois_output" | grep "Expiration Date:" | awk '{print $3}')
  registrant_name=$(echo "$whois_output" | grep "Registrant Name:" )
  registrant_email=$(echo "$whois_output" | grep "Registrant Email:" )
  registrant_phone=$(echo "$whois_output" | grep "Registrant Phone:" )
  
  # Output the information in a row
  echo "$domain,$registrar,$creation_date,$expiration_date" | tr -d '\n' >> domain_info.csv

done < domains.csv

