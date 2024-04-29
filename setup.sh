#!/bin/bash

# Lets Do Some Initial Updates
sudo apt-get update
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg2 software-properties-common

# I am going to ask you what to install
echo "Please respond 'yes' or 'no' to the following installation prompts."

echo "Install Node.js and yarn?"
read install_node
echo "Install Docker?"
read install_docker
echo "Install MongoDB?"
read install_mongodb
echo "Install Redis?"
read install_redis
echo "Install Ruby and Tmux?"
read install_ruby_tmux
echo "Install Python?"
read install_python
echo "Install ZSH and Oh My Zsh?"
read install_zsh
echo "Install Ansible?"
read install_ansible

# Node.js and Yarn
if [[ "$install_node" == "yes" ]]; then
    curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get install -y nodejs yarn
fi

# Docker
if [[ "$install_docker" == "yes" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-compose
    sudo usermod -aG docker $USER
fi

# MongoDB
if [[ "$install_mongodb" == "yes" ]]; then
    wget -qO - https://www.mongodb.org/static/pgp/server_latest.asc | sudo apt-key add -
    echo "deb [arch=amd64,arm64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/latest multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo mkdir -p /data/db
    sudo chown -R `id -un` /data/db
fi

# Redis
if [[ "$install_redis" == "yes" ]]; then
    sudo add-apt-repository ppa:chris-lea/redis-server -y
    sudo apt-get update
    sudo apt-get install -y redis
fi

# Ruby and Tmux
if [[ "$install_ruby_tmux" == "yes" ]]; then
    sudo apt install -y ruby tmux
    sudo gem install tmuxinator
fi

# Python
if [[ "$install_python" == "yes" ]]; then
    sudo apt-get install -y python3-pip
    pip3 install --upgrade pip
fi

# ZSH and Oh My Zsh
if [[ "$install_zsh" == "yes" ]]; then
    sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Ansible
if [[ "$install_ansible" == "yes" ]]; then
    sudo apt-get install -y ansible
fi

# General utilities
echo "Installing general utilities..."
sudo apt-get install -y build-essential jq parallel

# Final configuration and clean up
echo "Finalizing setup..."
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "Installation completed!"
