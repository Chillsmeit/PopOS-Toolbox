#!/bin/bash
clear
themes () {
	# Install Extensions
	while true; do
	Menu_OneMessage "Do you want to install and configure themes?"

	#Ask Update Question
	read -p "Enter your choice (y/n): " answer_themes

	if answer_yes "$answer_themes"; then

		# Export Array of required package names
		required_dependencies=(
		"gnome-shell-extensions"
		"gnome-tweaks"
		"gnome-shell-extension-prefs"
		"sound-theme-freedesktop"
		)
		
		# Execute missingpackages to check if packages are already installed
		source "subscripts/installdependencies.sh"
		installdependencies

		# Enable User Extensions in Gnome
		gsettings set org.gnome.shell disable-user-extensions false
		
		# Export Array of required flatpak names
		required_flatpaks=("com.mattjakeman.ExtensionManager")
		
		# Load installflatpaks.sh
		source "subscripts/installflatpaks.sh"
		installflatpaks

		# Check if User Shell Theme extension is installed
		required_extensions=("user-theme@gnome-shell-extensions.gcampax.github.com")
		
		# Load installextensions.sh and run installextensions
		source "subscripts/installextensions.sh"
		installextensions
		
		# Load extensions.sh for variables
		source "subscripts/extensions.sh"

		# Enable themes shell Extension
		$genable user-theme@gnome-shell-extensions.gcampax.github.com
		
		# Create Themes Directory in Home Folder
		mkdir $HOME/Themes
		cd $HOME/Themes
		
		# Download Themes
		git clone https://github.com/vinceliuice/Colloid-gtk-theme
		git clone https://github.com/vinceliuice/Colloid-icon-theme
		git clone https://github.com/vinceliuice/vimix-gtk-themes
		git clone https://github.com/vinceliuice/WhiteSur-icon-theme
		git clone https://github.com/vinceliuice/Jasper-gtk-theme
		
		cd $script_directory
		
		# Make subscripts executable
		chmod +x $HOME/Themes/*/*

		# Install Themes
		$HOME/Themes/Colloid-gtk-theme/install.sh || exit
		$HOME/Themes/Colloid-gtk-theme/install.sh || exit
		$HOME/Themes/Colloid-icon-theme/install.sh || exit
		$HOME/Themes/Colloid-icon-theme/cursors/install.sh || exit
		$HOME/Themes/vimix-gtk-themes/install.sh || exit
		$HOME/Themes/WhiteSur-icon-theme/install.sh || exit
		$HOME/Themes/Jasper-gtk-theme/install.sh || exit

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
		
		# Disable All Network Radios (Airplane Mode)
		nmcli radio all off
		
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
		
		# Install and Configure Conky
		source "subscripts/installconky.sh"
		installconky
		
		break

		elif answer_no "$answer_themes"; then
			break
		else
			echo "Invalid answer"
		fi
	done
}