#!/bin/bash

# Function to list PREROUTING rules without IP substitution
list_rules() {
    sudo iptables -t nat -L PREROUTING --line-numbers
}

# Function to add a new DNAT redirection rule
add_rule() {
    read -p "Enter the source port: " source_port
    read -p "Enter the destination IP: " dest_ip
    read -p "Enter the destination port: " dest_port

    sudo iptables -t nat -A PREROUTING -p tcp --dport $source_port -j DNAT --to-destination $dest_ip:$dest_port
    echo "Rule added successfully!"
}

# Function to remove a firewall rule
remove_rule() {
    list_rules   # List the PREROUTING rules
    read -p "Enter the rule number you want to remove: " rule_number
    sudo iptables -t nat -D PREROUTING $rule_number
    echo "Rule removed successfully!"
}

# Main logic for firewall functionality
option=""

while true; do
    # Display menu options
    echo "----- Firewall Menu -----"
    echo "1. List PREROUTING rules"
    echo "2. Add a new rule"
    echo "3. Remove an existing rule"
    echo "4. Exit"

    read -p "Choose an option: " option

    case $option in
        1) list_rules;;
        2) add_rule;;
        3) remove_rule;;
        4) echo "Exiting the firewall script."
           break;;
        *) echo "Invalid option. Please try again."; continue;;
    esac
done
