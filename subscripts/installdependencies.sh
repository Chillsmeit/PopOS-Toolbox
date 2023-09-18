#!/bin/bash
installdependencies() {
    for dep in "${required_dependencies[@]}"; do
        # Check if the dependency is installed
        if ! dpkg -l | grep -q "^ii  $dep "; then
            echo "$dep is not installed. Installing now..."
            pkexec apt-get install -y "$dep"
        else
            echo "$dep is already installed."
        fi
    done
}