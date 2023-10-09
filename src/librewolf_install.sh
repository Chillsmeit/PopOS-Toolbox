#!/bin/bash
librewolf_install() {
clear

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
		
		sudo -v

		# Array of required dependencies
		required_dependencies=(
		"wget"
		"gnupg"
		"lsb-release"
		"apt-transport-https"
		"ca-certificates"
		)

		# Load dependencies_install.sh
		source "src/dependencies_install.sh"

		# Execute dependencies_install function to check if extensions are already installed and install if they're not
		dependencies_install > logs/librewolf_log.txt 2>&1 # Send output from dependencies_install function to logfile

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

		# Create a new Firefox profile with the username as the profile name
		librewolf -CreateProfile "$(whoami)-profile"
		
		# Find the directory of the newly created profile
		librewolf_profiledir=$(find "$HOME/.librewolf/" -type d -name "*$(whoami)-profile*")
		
		# Save the folder name of the newly created profile
		librewolf_profilefoldername=$(basename "$librewolf_profiledir")

		Menu_TwoMessages "Opening Librewolf to create the default profile" "Please Wait..."
		nohup librewolf &> /dev/null & # Open Librewolf temporarly to create the config files
		sleep 4
		killall librewolf # Kill Librewolf

		Menu_TwoMessages "Changing default profile" "Please Wait..."
	
		# Assign Created Profile as Default
		sed -i "/.*\[Install.*/{n;s/Default=.*/Default=$librewolf_profilefoldername/}" "$HOME/.librewolf/profiles.ini"

		# Remove Default=1 from Librewolf profiles.ini
		sed -i '/Default=1/d' "$HOME/.librewolf/profiles.ini"

		# Add Default=1 to the profile that was created
		if ! grep -A1 "Name=$(whoami)-profile" "$HOME/.librewolf/profiles.ini" | grep -q "Default=1"; then
    			sed -i "/Name=$(whoami)-profile/a Default=1" "$HOME/.librewolf/profiles.ini"
		fi

		# Check if the directory was found then configure user.js and chrome
		if [ ! -z "$librewolf_profiledir" ]; then
			git clone https://github.com/Chillsmeit/SmoothScrollFirefox
			mv "SmoothScrollFirefox/Profiles/Snappier.js" "$librewolf_profiledir/user.js"
			if ! grep -qFf "SmoothScrollFirefox/Firefox_Tweaks/tweaks.js" "$librewolf_profiledir/user.js"; then
				cat "SmoothScrollFirefox/Firefox_Tweaks/tweaks.js" >> "$librewolf_profiledir/user.js"
			fi
			mv "SmoothScrollFirefox/Firefox_Tweaks/chrome" "$librewolf_profiledir"
			rm -rf "SmoothScrollFirefox"
		else
			Menu_OneMessage "No Profile Directory Found"
			read -p
			break
		fi
		
		# Links for extensions
		extension_urls=(
		"https://addons.mozilla.org/en-US/firefox/addon/absolute-enable-right-click/"
		"https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/"
		"https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/"
		"https://addons.mozilla.org/en-US/firefox/addon/clearurls/"
		"https://addons.mozilla.org/en-US/firefox/addon/fastforwardteam/"
		"https://addons.mozilla.org/en-US/firefox/addon/istilldontcareaboutcookies/"
		"https://addons.mozilla.org/en-US/firefox/addon/mal-sync/"
		"https://addons.mozilla.org/en-US/firefox/addon/noscript/"
		"https://addons.mozilla.org/en-US/firefox/addon/return-youtube-dislikes/"
		"https://addons.mozilla.org/en-US/firefox/addon/simplelogin/"
		"https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/"
		"https://addons.mozilla.org/en-US/firefox/addon/traduzir-paginas-web/"
		"https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
		"https://addons.mozilla.org/en-US/firefox/addon/violentmonkey/"
		"https://gitlab.com/magnolia1234/bpc-uploads/-/raw/master/bypass_paywalls_clean-latest.xpi"
		)
		
		# Load librewolf_extensions.sh
		source "src/librewolf_extensions.sh"
		
		# Execute installbrowserextensions function to check if extensions are already installed and install if they're not
		librewolf_extensions_install >> logs/librewolf_log.txt 2>&1 # Send output from installbrowserextensions function to logfile

		# Execute renamebrowserextensions function to check if extensions are already installed and install if they're not
		librewolf_extensions_rename >> logs/librewolf_log.txt 2>&1 # Send output from renamebrowserextensions function to logfile
	
		# Unpin Firefox from Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'firefox.desktop', //")"
		
		# Pin Librewolf to Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'librewolf.desktop']/")"
		
		break

	elif answer_no "$answer_libre"; then # If user chose no
	break # Exit this script and go back to the main menu

	# If user inputs something besides yes/no/y/n
	else
		echo "Invalid Choice"
	fi
done
}