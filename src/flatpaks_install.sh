#!/bin/bash
flatpaks_install() {
    # Check if flatpak is installed
    if ! command -v flatpak &> /dev/null; then
        echo "Flatpak is not installed. Installing now..."
        sudo apt-get install -y flatpak
        # Adding the Flathub repository
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        sudo apt-get update -y
    fi
    
    for flatpak in "${required_flatpaks[@]}"; do
        # Check if the flatpak is installed
        if ! flatpak list --app | grep -q "$flatpak"; then
            echo "Installing Flatpak: $flatpak"
            flatpak install -y flathub "$flatpak"
        else
            echo "Flatpak $flatpak is already installed."
        fi
    done
}