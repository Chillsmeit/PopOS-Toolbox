#!/bin/bash
extensions_install() {
    for extension in "${required_extensions[@]}"; do
        # Check if the extension is installed
        if ! gnome-extensions list | grep -q "$extension"; then
            echo "Installing Gnome extension: $extension"
            busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Extensions InstallRemoteExtension s "$extension"
        else
            echo "Gnome extension $extension is already installed."
        fi
    done
}