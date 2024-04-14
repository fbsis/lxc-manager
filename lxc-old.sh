#!/bin/bash

# Function to list PREROUTING rules without IP substitution
list_rules() {
    sudo iptables -t nat -L PREROUTING --line-numbers
}

# Function to display the list of LXC containers with name and IP in table format
display_containers() {
    echo "List of LXC containers with name and IP:"
    lxc list --format=table
}

# Function to add a new DNAT redirection rule
add_rule() {
    display_containers  # Display the list of LXC containers with name and IP

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

# Function to list LXC containers
list_containers() {
    echo "List of LXC containers:"
    lxc list -c ns --format csv | tail -n +2
}

# Function to enter an LXC container by name
enter_container() {
    clear  # Clear the terminal screen before prompting user to enter an LXC container
    containers=$(lxc list -c ns --format csv | tail -n +2)
    
    echo "Available containers:"
    echo "$containers"
    
    read -p "Enter the name of the container you want to enter: " container_name

    # Check if the container exists
    if lxc info $container_name &> /dev/null; then
        echo "Entering the container $container_name"
        lxc exec $container_name -- /bin/bash
    else
        echo "Container $container_name does not exist."
    fi
}

# Function to create an LXC container
create_container() {
    read -p "Enter the name of the new LXC container: " container_name

    lxc launch ubuntu:22.04 $container_name
    lxc config set $container_name security.nesting true
    lxc config set $container_name security.syscalls.intercept.mknod true
    lxc config set $container_name security.syscalls.intercept.setxattr true

    lxc restart $container_name

    echo "LXC container $container_name created successfully."
}

# Main logic
option=""

while true; do
    # Display menu options
    echo "----- Menu -----"
    echo "1. List PREROUTING rules"
    echo "2. Add a new rule"
    echo "3. Remove an existing rule"
    echo "4. List LXC containers"
    echo "5. Enter an LXC container by name"
    echo "6. Create a new LXC container"
    echo "7. Exit"

    read -p "Choose an option: " option

    case $option in
        1) list_rules;;
        2) add_rule;;
        3) remove_rule;;
        4) list_containers;;
        5) enter_container;;
        6) create_container;;
        7) echo "Exiting the script."
           break;;
        *) echo "Invalid option. Please try again."; continue;;
    esac
done
