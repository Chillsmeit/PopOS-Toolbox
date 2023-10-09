#!/bin/bash
clear
themes_configure () {
	# Install Themes
	while true; do
	Menu_OneMessage "Do you want to install and configure themes?"

	# Read user choice
	read -p "Enter your choice (y/n): " answer_themes

	# If user chose yes
	if answer_yes "$answer_themes"; then
		
		
		# Display Menu for installing dependencies
		clear
		messagecolor=$red
		Menu_TwoMessages "Installing dependencies" "Please wait..."
		
		# Send global output to logfile
		exec > logs/themes_log.txt 2>&1
		
		# Export Array of required package names
		required_dependencies=(
		"gnome-shell-extensions"
		"gnome-tweaks"
		"gnome-shell-extension-prefs"
		"sound-theme-freedesktop"
		"libsass1"
		"sassc"
		"fonts-powerline"
		"alacritty"
		"python3"
		"python3-pip"
		"python-is-python3"
		"python3-nautilus"
		"python3-gi"
		)

		# Load dependencies_install.sh
		source "src/dependencies_install.sh"
		dependencies_install

		# Enable User Extensions in Gnome
		gsettings set org.gnome.shell disable-user-extensions false

		# Export Array of required flatpak names
		required_flatpaks=("com.mattjakeman.ExtensionManager")

		# Load flatpaks_install.sh
		source "src/flatpaks_install.sh"
		flatpaks_install

		# Check if User Shell Theme extension is installed
		required_extensions=("user-theme@gnome-shell-extensions.gcampax.github.com")

		# Load extensions_install.sh
		source "src/extensions_install.sh"
		extensions_install

		# Enable themes shell Extension
		genable="gnome-extensions enable"
		$genable user-theme@gnome-shell-extensions.gcampax.github.com

		# Send global output back to terminal
		exec > /dev/tty 2>&1
		
		# Display Menu for dependencies installed
		clear
		messagecolor=$green
		Menu_OneMessage "Dependencies installed ✔"
		sleep 2
		
		# Display Menu for Downloading Themes
		clear
		messagecolor=$red
		Menu_TwoMessages "Downloading themes" "Please wait..."
		
		# Send global output to logfile
		exec >> logs/themes_log.txt 2>&1

		# Create Themes Directory in Home Folder
		mkdir $HOME/Themes
		cd $HOME/Themes || exit
		
		# Download Themes
		git clone https://github.com/vinceliuice/Colloid-gtk-theme
		git clone https://github.com/vinceliuice/Colloid-icon-theme
		git clone https://github.com/vinceliuice/vimix-gtk-themes
		git clone https://github.com/vinceliuice/WhiteSur-icon-theme
		git clone https://github.com/vinceliuice/Jasper-gtk-theme
		
		cd $script_directory || exit
		
		# Make scripts executable
		chmod +x $HOME/Themes/*/*
		
		# Send global output back to terminal
		exec > /dev/tty 2>&1
		
		# Display Menu for Downloading Themes
		clear
		messagecolor=$green
		Menu_OneMessage "Themes downloaded ✔"
		sleep 2
		
		# Display Menu for Downloading Themes
		clear
		messagecolor=$red
		Menu_TwoMessages "Installing themes" "Please wait..."
		
		# Send global output to logfile
		exec >> logs/themes_log.txt 2>&1

		# Install Themes
		sudo $HOME/Themes/Colloid-gtk-theme/install.sh || exit
		sudo $HOME/Themes/Colloid-gtk-theme/install.sh || exit
		sudo $HOME/Themes/Colloid-icon-theme/install.sh || exit
		sudo $HOME/Themes/Colloid-icon-theme/cursors/install.sh || exit
		sudo $HOME/Themes/vimix-gtk-themes/install.sh || exit
		sudo $HOME/Themes/WhiteSur-icon-theme/install.sh || exit
		sudo $HOME/Themes/Jasper-gtk-theme/install.sh || exit

		# Send global output back to terminal
		exec > /dev/tty 2>&1
		
		# Display Menu for installing themes
		clear
		messagecolor=$green
		Menu_OneMessage "Themes installed ✔"
		sleep 2
		
		# Display Menu for Configuring themes
		clear
		messagecolor=$red
		Menu_TwoMessages "Configuring themes" "Please wait..."
		
		# Send global output to logfile
		exec >> logs/themes_log.txt 2>&1

		# Schema directory variable to make change extensions settings
		gchange="gsettings --schemadir ~/.local/share/gnome-shell/extensions/\$extension_name/schemas/ set \$extension_id"

		# Set user theme in the Gnome extension
		extension_name="user-theme@gnome-shell-extensions.gcampax.github.com"
		extension_id="org.gnome.shell.extensions.user-theme"
		eval "$gchange name 'Jasper-Dark'"

		# Set Themes
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
		gsettings set org.gnome.desktop.interface cursor-theme 'Colloid-cursors'
		gsettings set org.gnome.desktop.interface gtk-theme 'vimix-dark-doder'
		gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'
		
		# Enable FreeDesktop Sound Themes
		gsettings set org.gnome.desktop.sound theme-name 'freedesktop'
		
		# Set Desktop Backgrounds
		gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/pop/tony-webster-97532.jpg"
		gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/pop/tony-webster-97532.jpg"
		
		# Disable Mouse Accelaration
		gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
		
		# Disable Middle Click/ScrollWhell Click Paste
		gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
		
		# Show Desktop Icons
		gsettings set org.gnome.desktop.background show-desktop-icons true
		
		# Enable Minimize, Maximize and Close button layout
		gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
		
		# Disable Lid Close Sleep/Suspend/Shutdown on AC Power
		gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing'
		
		# Disable Lid Close Sleep/Suspend/Shutdown on Battery Power
		gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing'
		
		# Disable Sleep Inactivity on AC Power
		gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
		
		# Disable Sleep Inactivity on Battery Power
		gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
		
		# Disable Power Button Sleep/Suspend/Shutdown
		gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'nothing'
		
		# Disable System Location
		gsettings set org.gnome.system.location enabled false
		
		# Disable Weather Automatic Location
		gsettings set org.gnome.Weather automatic-location false
		
		# Disable Show Applications Icon in Top Bar
		gsettings set org.gnome.shell.extensions.pop-cosmic show-applications-button false
		
		# Disable Show Workspaces Button in Top Bar
		gsettings set org.gnome.shell.extensions.pop-cosmic show-workspaces-button false
		
		# Set Clock Alignement to Center in Top Bar
		gsettings set org.gnome.shell.extensions.pop-cosmic clock-alignment 'CENTER'
		
		# Set Dock Position Bottom or Top
		gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

		# Set Dock Background Color
		gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#292b2e'

		# Set Dock Opacity Color
		gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.80
		
		# Enable Custom Dock Color Support
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
		
		# Enable Minimize or Previews in the Dock when clicking Apps
		gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

		# Set Dock Autohide On
		gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

		# Disable Show Mounted Drives in the Dock
		gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

		# Disable Show Trash in Dock
		gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

		# Show Home Folder in Desktop
		gsettings set org.gnome.shell.extensions.ding show-home true

		# Show Trash Icon in Desktop
		gsettings set org.gnome.shell.extensions.ding show-trash true

		# Disable Link Emblem in linked folders in Desktop
		gsettings set org.gnome.shell.extensions.ding show-link-emblem false

		# Enable Mounted Drives in Desktop
		gsettings set org.gnome.shell.extensions.ding show-volumes true

		# Change Gnome Document Font
		gsettings set org.gnome.desktop.interface document-font-name 'Roboto Slab 11'

		# Change Gnome font to Noto Sans
		gsettings set org.gnome.desktop.interface font-name 'Noto Sans 10'

		# Change Gnome font to Ubuntu Medium
		gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Ubuntu Medium 10'

		# Set Text Scalling Factor to 1.05
		gsettings set org.gnome.desktop.interface text-scaling-factor 1.05

		# Set Top Bar Clock Format to 24h
		gsettings set org.gnome.desktop.interface clock-format '24h'

		# Disable Clock Show Date in Top Bar
		gsettings set org.gnome.desktop.interface clock-show-date false

		# Enable Hot Corners (quick mouse to top left corner workspace)
		gsettings set org.gnome.desktop.interface enable-hot-corners true

		# Show Battery Percentage
		gsettings set org.gnome.desktop.interface show-battery-percentage true

		# Set Super+A Keybind for Application Menu
		gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"

		# Set Alt+Tab Keybind for Application Switching
		gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"

		# Set Super+Tab Alternative Application Switching
		gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
		
		# Change Applications menu Color
		sudo -S sed -i "2s|.*|background-color: rgba(41,43,46,1);|" /usr/share/gnome-shell/extensions/pop-cosmic@system76.com/dark.css
		
		# Change Applications menu Opacity
		sudo -S sed -E -i "2s|(background-color: rgba\([0-9]+,[0-9]+,[0-9]+),?[0-9.]*\)|\1,1)|" /usr/share/gnome-shell/extensions/pop-cosmic@system76.com/dark.css
		
		# Set Dock Color
		gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#292b2e'
		
		# Enable Custom Color Support
		gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
		
		# Disable Pop!_OS Ugly Yellow Tint
		sudo sed -i 's/ext\.overlay\.visible = true;/ext.overlay.visible = false;/g' /usr/share/gnome-shell/extensions/pop-shell@system76.com/launcher.js
		
		# Change Dock Opacity
		gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.7
		
		# Set Alacritty as default terminal
		gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/alacritty
		gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
		
		# Install plugin for Alacritty in Nautilus
		pip install nautilus-open-any-terminal
		
		# Remove Gnome-Terminal plugin for Nautilus
		sudo apt-get remove nautilus-extension-gnome-terminal -y
		
		# Configure Alacritty Plugin Behaviour
		sudo glib-compile-schemas /usr/share/glib-2.0/schemas
		glib-compile-schemas ~/.local/share/glib-2.0/schemas/
		gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
		gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
		gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
		gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
		
		# Pin Alacritty to Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'com.alacritty.Alacritty.desktop']/")"
		
		# Unpin Gnome Terminal from Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'org.gnome.Terminal.desktop', //")"
		
		# Unpin Launcher from Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'pop-cosmic-launcher.desktop', //")"
		
		# Unpin Workspaces from Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'pop-cosmic-workspaces.desktop', //")"
		
		# Unpin Applications from Dock
		gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'pop-cosmic-applications.desktop', //")"
		
		# Send global output back to terminal
		exec > /dev/tty 2>&1
		
		# Display Menu for configuring themes
		clear
		messagecolor=$green
		Menu_OneMessage "Themes configured ✔"
		sleep 2
		clear

		while true; do
			Menu_OneMessage "Do you want to restart the Gnome Shell?"

			#Ask Update Question
			read -p "Enter your choice (y/n): " answer_shell

			if answer_yes "$answer_shell"; then
				
				clear
				messagecolor=$red
				Menu_OneMessage "Restarting Gnome Shell..."
				sleep 2
				killall -3 gnome-shell
				sleep 4
				break
				
			elif answer_no "$answer_shell"; then
				break
				
			else
				echo "Invalid Choice"
			fi
		done
			
		# Install and Configure Conky
		source "src/conky_install.sh"
		conky_install
		
		break

		elif answer_no "$answer_themes"; then
			break
		else
			echo "Invalid answer"
		fi
	done
	}