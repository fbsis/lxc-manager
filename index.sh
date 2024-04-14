#!/bin/bash

# Função para selecionar o assunto (firewall ou LXC) e chamar o script correspondente
select_subject() {
    read -p "Choose the subject (firewall or LXC): " subject

    case $subject in
        firewall)
            echo "Running Firewall Script..."
            chmod +x firewall.sh
            ./firewall.sh 
            ;;
        LXC|lxc)
            echo "Running LXC Script..."
            chmod +x lxc.sh
            ./lxc.sh 
            ;;
        *)
            echo "Invalid subject. Please choose either 'firewall' or 'LXC'."
            ;;
    esac
}

# Chamada da função para selecionar o assunto
select_subject
