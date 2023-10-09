#!/bin/bash
librewolf() {
clear
	# Load installdependencies.sh
	source "subscripts/yes_no.sh"
	
	# Confirmation Menu
	while true; do
	Menu_OneMessage "Do you want to install and configure Librewolf?"

	# Read user choice
	read -p "Enter your choice (y/n): " answer_libre

	# If user chose yes
	if answer_yes "$answer_libre"; then
		
		# Display Menu for installing dependencies
		clear
		messagecolor=$red
		Menu_TwoMessages "Installing librewolf" "Please wait..."

		# Array of required dependencies
		required_dependencies=(
		"wget"
		"gnupg"
		"lsb-release"
		"apt-transport-https"
		"ca-certificates"
		)

		# Load installdependencies.sh
		source "subscripts/installdependencies.sh"

		# Execute installdependencies function to check if extensions are already installed and install if they're not
		installdependencies > logs/extensions_log.txt 2>&1 # Send output from installdependencies function to logfile
		
		sudo -v

		distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)

		wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/librewolf.gpg

sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

		sudo apt update -y && sudo apt install librewolf -y
		
		Menu_TwoMessages "Temporarly opening Librewolf to create profile" "Please Wait..."
		nohup librewolf &> /dev/null & # Open Librewolf temporarly to create the config files
		sleep 4
		killall librewolf # Kill Librewolf
		
		# Find the directory with "default-default" in its name and check if prefs.js, settings and storage folder exist
		librewolf_profiledir=$(find "$HOME/.librewolf/" -type d -name "*default-default*" -exec sh -c 'test -f "$1/prefs.js" && test -d "$1/settings" && test -d "$1/storage"' _ {} \; -print -quit)

		# Check if the directory was found
		if [ ! -z "$librewolf_profiledir" ]; then
			git clone https://github.com/Chillsmeit/SmoothScrollFirefox
			mv "SmoothScrollFirefox/Profiles/Snappier.js" "$librewolf_profiledir/user.js"
			if ! grep -qFf "SmoothScrollFirefox/Firefox_Tweaks/tweaks.js" "$librewolf_profiledir/user.js"; then
    				cat "SmoothScrollFirefox/Firefox_Tweaks/tweaks.js" >> "$librewolf_profiledir/user.js"
			fi
			mv "SmoothScrollFirefox/Firefox_Tweaks/chrome" "$librewolf_profiledir"
			rm -rf "SmoothScrollFirefox"
		else
			echo "No profile directory found"
			sleep 2
			break
		fi
		break

	elif answer_no "$answer_libre"; then # If user chose no
	break # Exit this subscript and go back to the main menu

	# If user inputs something besides yes/no/y/n
	else
		echo "Invalid Choice"
	fi
done
}