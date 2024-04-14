#!/bin/bash

# Function to list LXC containers
list_containers() {
    echo "List of LXC containers:"
    lxc list -c ns --format csv | tail -n +2
}

# Function to enter an LXC container by name
enter_container() {
    containers=$(lxc list -c ns --format csv | tail -n +2)

    echo "Available containers:"
    echo "$containers"

    read -p "Enter the name of the container you want to enter: " container_name

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

# Main logic for LXC functionality
option=""

while true; do
    # Display menu options
    echo "----- LXC Menu -----"
    echo "1. List LXC containers"
    echo "2. Enter an LXC container by name"
    echo "3. Create a new LXC container"
    echo "4. Exit"

    read -p "Choose an option: " option

    case $option in
        1) list_containers;;
        2) enter_container;;
        3) create_container;;
        4) echo "Exiting the LXC script."
           break;;
        *) echo "Invalid option. Please try again."; continue;;
    esac
done
