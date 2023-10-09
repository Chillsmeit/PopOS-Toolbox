#!/bin/bash
refind (){
	# Confirmation Menu
	while true; do
	Menu_OneMessage "Do you want to install and configure refind?"

	# Read user choice
	read -p "Enter your choice (y/n): " answer_extensions

	# If user chose yes
	if answer_yes "$answer_refind"; then
		
		# Display Menu for installing dependencies
		clear
		messagecolor=$red
		Menu_TwoMessages "Installing dependencies" "Please wait..."

		# Array of required dependencies
		required_dependencies=("refind")
		
		# Load dependencies_install.sh
		source "src/dependencies_install.sh"
		
		# Execute dependencies_install function to check if extensions are already installed and install if they're not
		dependencies_install > logs/extensions_log.txt 2>&1 # Send output from dependencies_installfunction to logfile