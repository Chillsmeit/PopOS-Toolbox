#!/bin/bash
clear
extensions () {
	# Confirmation Menu
	while true; do
	Main_Menu_Upper_Text
	echo -e "${orange}|░${lightgray}    Do you want to install and configure the extensions?${orange}    ░|"
	Main_Menu_Bottom_Text

	# Read user choice
	read -p "Enter your choice (y/n): " answer_extensions

	# If user chose yes
	if answer_yes "$answer_extensions"; then
		
		# Display Menu for installing dependencies
		clear
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                 Installing dependencies...${orange}                 ░|"
		Main_Menu_Bottom_Text
		
		# Write all terminal output to log file
		exec > logs/subscript_log.txt 2>&1
		
		# Export Array of required dependencies
		export required_dependencies=(
		"gnome-shell-extensions"
		"gnome-shell-extension-prefs"
		"gnome-tweaks"
		)
		
		# Load installdependencies.sh
		source "subscripts/installdependencies.sh"
		# Execute installdependencies function to check if extensions are already installed and install if they're not
		installdependencies

		# Display Menu for installing extensions
		{
		clear
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                 Installing extensions...${orange}                 ░|"
		Main_Menu_Bottom_Text
		} > /dev/tty # Temporarily disable sending output to log file

		# Export Array of required extensions
		export required_extensions=(
		"volume-mixer@evermiss.net"
		"avatar@pawel.swiszcz.com"
		"blur-my-shell@aunetx"
		"custom-hot-corners-extended@G-dH.github.com"
		"freon@UshakovVasilii_Github.yahoo.com"
		"gamemode@christian.kellner.me"
		"gsconnect@andyholmes.github.io"
		"just-perfection-desktop@just-perfection"
		"noannoyance@daase.net"
		"openweather-extension@jenslody.de"
		"pi-hole@fnxweb.com"
		"rounded-window-corners@yilozt"
		"tophat@fflewddur.github.io"
		"user-theme@gnome-shell-extensions.gcampax.github.com"
		)

		# Load installextensions.sh
		source "subscripts/installextensions.sh"
		# Execute installextensions function to check if extensions are already installed and install if they're not
		installextensions

		# Enable User Themes Extension if it was installed
		genable="gnome-extensions enable"
		$genable user-theme@gnome-shell-extensions.gcampax.github.com

		# Disable Installed Extensions before configuring them
		gdisable="gnome-extensions disable"
		$gdisable volume-mixer@evermiss.net
		$gdisable avatar@pawel.swiszcz.com
		$gdisable blur-my-shell@aunetx
		$gdisable custom-hot-corners-extended@G-dH.github.com
		$gdisable freon@UshakovVasilii_Github.yahoo.com
		$gdisable gamemode@christian.kellner.me
		$gdisable gsconnect@andyholmes.github.io
		$gdisable just-perfection-desktop@just-perfection
		$gdisable noannoyance@daase.net
		$gdisable openweather-extension@jenslody.de
		$gdisable pi-hole@fnxweb.com
		$gdisable rounded-window-corners@yilozt
		$gdisable tophat@fflewddur.github.io

		# Display Menu for installing flatpaks
		{
		clear
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                 Installing flatpaks...${orange}                 ░|"
		Main_Menu_Bottom_Text
		} > /dev/tty # Temporarily disable sending output to log file

		# Export Array of required flatpaks
		export required_flatpaks=(
		"com.mattjakeman.ExtensionManager"
		)

		# Load installflatpaks.sh
		source "subscripts/installflatpaks.sh"
		# Execute installflatpaks function to check if flatpaks are already installed and install if they're not
		installflatpaks
		
		# In the future, to manually list current schema settings, you need to do:
		# gsettings --schemadir ~/.local/share/gnome-shell/extensions/avatar@pawel.swiszcz.com/schemas/ list-recursively org.gnome.shell.extensions.avatar
		# To check the extension ID, you need to do:
		# open ~.local/share/gnome-shell/extensions/avatar@pawel.swiszcz.com/schemas/org.gnome.shell.extensions.avatar.gschema.xml
		# look for the schemaid
		
		# Display Menu for extension configuration
		{
		clear
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                 Configuring extensions...${orange}                 ░|"
		Main_Menu_Bottom_Text
		} > /dev/tty # Temporarily disable sending output to log file
		
		# Schema directory variable to make change extensions settings
		gchange="gsettings --schemadir ~/.local/share/gnome-shell/extensions/\$extension_name/schemas/ set \$extension_id"
		
		######################################
		# Configure Application Volume Mixer #
		######################################
		extension_name="volume-mixer@evermiss.net"
		extension_id="net.evermiss.mymindstorm.volume-mixer"
		eval "$gchange filter-mode 'block'"
		eval "$gchange filtered-apps []"
		eval "$gchange show-description false"
		eval "$gchange show-icon true"

		##########################
		# Configure Avatar Panel #
		##########################
		extension_name="avatar@pawel.swiszcz.com"
		extension_id="org.gnome.shell.extensions.avatar"
		eval "$gchange avatar-icon-size 0"
		eval "$gchange avatar-shadow true"
		eval "$gchange avatar-shadow-user-name true"
		eval "$gchange buttons-background ''"
		eval "$gchange buttons-icon-size 29"
		eval "$gchange buttons-position 0"
		eval "$gchange custom-buttons-background false"
		eval "$gchange dnd-icon-name 'notifications-symbolic'"
		eval "$gchange dnd-icon-name-disabled 'notifications-disabled-symbolic'"
		eval "$gchange dnd-use-icon true"
		eval "$gchange horizontal-mode false"
		eval "$gchange name-style-dark false"
		eval "$gchange order-avatar 0"
		eval "$gchange order-mpris 1"
		eval "$gchange order-top-image 2"
		eval "$gchange set-custom-panel-menu-width 0"
		eval "$gchange show-buttons false"
		eval "$gchange show-media-center false"
		eval "$gchange show-name true"
		eval "$gchange show-system-name true"
		eval "$gchange show-top-image false"
		eval "$gchange system-name-position 0"
		eval "$gchange top-image ''"
		eval "$gchange top-image-size-height 70"
		eval "$gchange top-image-size-width 450"
		
		########################
		# Configure Blur Shell #
		########################
		extension_name="blur-my-shell@aunetx"
		extension_id="org.gnome.shell.extensions.blur-my-shell"
		eval "$gchange brightness 0.0"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange color-and-noise true"
		eval "$gchange debug false"
		eval "$gchange hacks-level 3"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 0"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.appfolder"
		eval "$gchange blur true"
		eval "$gchange brightness 0.6"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 30"
		eval "$gchange style-dialogs 1"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.applications"
		eval "$gchange blacklist \"[\\\"Plank\\\"]\""
		eval "$gchange blur true"
		eval "$gchange blur-on-overview false"
		eval "$gchange brightness 1.0"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize true"
		eval "$gchange enable-all false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange opacity 162"
		eval "$gchange sigma 30"
		eval "$gchange whitelist []"

		extension_id="org.gnome.shell.extensions.blur-my-shell.dash-to-dock"
		eval "$gchange blur false"
		eval "$gchange brightness 1.0"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange override-background true"
		eval "$gchange sigma 2"
		eval "$gchange static-blur true"
		eval "$gchange style-dash-to-dock 2"
		eval "$gchange unblur-in-overview false"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.dash-to-panel"
		eval "$gchange blur-original-panel true"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.hidetopbar"
		eval "$gchange compatibility false"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.lockscreen"
		eval "$gchange blur true"
		eval "$gchange brightness 0.6"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 30"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.overview"
		eval "$gchange blur false"
		eval "$gchange brightness 0.6"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 30"
		eval "$gchange style-components 1"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.panel"
		eval "$gchange blur true"
		eval "$gchange brightness 0.5"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize true"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange override-background true"
		eval "$gchange override-background-dynamically false"
		eval "$gchange sigma 13"
		eval "$gchange static-blur false"
		eval "$gchange style-panel 0"
		eval "$gchange unblur-in-overview true"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.screenshot"
		eval "$gchange blur true"
		eval "$gchange brightness 0.6"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 30"
		
		extension_id="org.gnome.shell.extensions.blur-my-shell.window-list"
		eval "$gchange blur true"
		eval "$gchange brightness 0.6"
		eval "$gchange color '(0.0, 0.0, 0.0, 0.0)'"
		eval "$gchange customize false"
		eval "$gchange noise-amount 0.0"
		eval "$gchange noise-lightness 0.0"
		eval "$gchange sigma 30"

		###################
		# Configure Freon #
		###################		

		# Export Array of required dependencies for Freon
		export required_dependencies=("lm-sensors")
		
		# Load installdependencies.sh
		source "subscripts/installdependencies.sh"
		# Execute installdependencies function to check if dependencies are already installed and install if they're not
		installdependencies

		
		extension_name="freon@UshakovVasilii_Github.yahoo.com"
		extension_id="org.gnome.shell.extensions.freon"
		eval "$gchange group-rotationrate true"
		eval "$gchange group-temperature true"
		eval "$gchange group-voltage true"
		eval "$gchange panel-box-index 0"
		eval "$gchange position-in-panel 'left'"
		eval "$gchange show-decimal-value false"
		eval "$gchange show-icon-on-panel true"
		eval "$gchange show-power true"
		eval "$gchange show-power-unit true"
		eval "$gchange show-rotationrate true"
		eval "$gchange show-rotationrate-unit true"
		eval "$gchange show-temperature true"
		eval "$gchange show-temperature-unit true"
		eval "$gchange show-voltage true"
		eval "$gchange show-voltage-unit true"
		eval "$gchange unit 'centigrade'"
		eval "$gchange update-time 5"
		eval "$gchange use-drive-hddtemp false"
		eval "$gchange use-drive-nvmecli false"
		eval "$gchange use-drive-smartctl false"
		eval "$gchange use-drive-udisks2 false"
		eval "$gchange use-generic-liquidctl false"
		eval "$gchange use-generic-lmsensors true"
		
		clear
		while true; do
			clear
			exec > /dev/tty 2>&1
			Main_Menu_Upper_Text
			echo -e "${orange}|░${lightgray}                   Which GPU do you have?${orange}                   ░|"
			echo -e "${orange}|░                                                            ░|"
			echo -e "${orange}|░${lightgray}   1. AMD${orange}                                                   ░|"
			echo -e "${orange}|░${lightgray}   2. NVIDIA${orange}                                                ░|"
			echo -e "${orange}|░${lightgray}   3. NVIDIA Bumblebee (FOSS Optimus Driver for Laptops)${orange}    ░|"
			Main_Menu_Bottom_Text
			
			read -p "Choose a number: " gpu_choice

			
			if [[ "$gpu_choice" == "1" ]]; then
				# Append to existing log file
				exec >> logs/subscript_log.txt 2>&1
				extension_name="freon@UshakovVasilii_Github.yahoo.com"
				extension_id="org.gnome.shell.extensions.freon"
				eval "$gchange use-gpu-aticonfig true"
				eval "$gchange use-gpu-nvidia false"
				eval "$gchange use-gpu-bumblebeenvidia false"
				break
			elif [[ "$gpu_choice" == "2" ]]; then
				# Append to existing log file
				exec >> logs/subscript_log.txt 2>&1
				extension_name="freon@UshakovVasilii_Github.yahoo.com"
				extension_id="org.gnome.shell.extensions.freon"
				eval "$gchange use-gpu-aticonfig false"
				eval "$gchange use-gpu-nvidia true"
				eval "$gchange use-gpu-bumblebeenvidia false"
				break
			elif [[ "$gpu_choice" == "3" ]]; then
				# Append to existing log file
				exec >> logs/subscript_log.txt 2>&1
				extension_name="freon@UshakovVasilii_Github.yahoo.com"
				extension_id="org.gnome.shell.extensions.freon"
				eval "$gchange use-gpu-aticonfig false"
				eval "$gchange use-gpu-nvidia false"
				eval "$gchange use-gpu-bumblebeenvidia true"
				break
			else
				clear
				Main_Menu_Upper_Text
				echo -e "${orange}|░${red}                   Invalid Choice${orange}                   ░|"
				Main_Menu_Bottom_Text
				pause 2
			fi
		done

		######################
		# Configure Gamemode #
		######################
		extension_name="gamemode@christian.kellner.me"
		extension_id="org.gnome.shell.extensions.gamemode"
		eval "$gchange active-color 'rgb(237,51,59)'"	
		eval "$gchange active-tint true"		
		eval "$gchange always-show-icon true"	
		eval "$gchange emit-notifications false"	
			
		#############################
		# Configure Just Perfection #
		#############################
		extension_name="just-perfection-desktop@just-perfection"
		extension_id="org.gnome.shell.extensions.just-perfection"
		eval "$gchange accessibility-menu false"	
		eval "$gchange activities-button true"		
		eval "$gchange activities-button-icon-monochrome true"	
		eval "$gchange activities-button-icon-path ''"
		eval "$gchange activities-button-label true"
		eval "$gchange aggregate-menu true"
		eval "$gchange alt-tab-icon-size 0"
		eval "$gchange alt-tab-small-icon-size 0"
		eval "$gchange alt-tab-window-preview-size 0"
		eval "$gchange animation 1"
		eval "$gchange app-menu true"
		eval "$gchange app-menu-icon true"
		eval "$gchange app-menu-label true"
		eval "$gchange background-menu true"
		eval "$gchange calendar true"
		eval "$gchange clock-menu true"
		eval "$gchange clock-menu-position 0"
		eval "$gchange clock-menu-position-offset 0"
		eval "$gchange controls-manager-spacing-size 0"
		eval "$gchange dash true"
		eval "$gchange dash-icon-size 0"
		eval "$gchange dash-separator true"
		eval "$gchange double-super-to-appgrid true"
		eval "$gchange events-button true"
		eval "$gchange gesture true"
		eval "$gchange hot-corner false"
		eval "$gchange keyboard-layout true"
		eval "$gchange looking-glass-height 0"
		eval "$gchange looking-glass-width 0"
		eval "$gchange notification-banner-position 1"
		eval "$gchange osd true"
		eval "$gchange osd-position 0"
		eval "$gchange panel true"
		eval "$gchange panel-arrow true"
		eval "$gchange panel-button-padding-size 0"
		eval "$gchange panel-corner-size 0"
		eval "$gchange panel-icon-size 0"
		eval "$gchange panel-in-overview true"
		eval "$gchange panel-indicator-padding-size 0"
		eval "$gchange panel-notification-icon true"
		eval "$gchange panel-size 0"
		eval "$gchange power-icon true"
		eval "$gchange quick-settings true"
		eval "$gchange ripple-box true"
		eval "$gchange screen-recording-indicator true"
		eval "$gchange screen-sharing-indicator true"
		eval "$gchange search true"
		eval "$gchange show-apps-button true"
		eval "$gchange startup-status 1"
		eval "$gchange switcher-popup-delay true"
		eval "$gchange theme false"
		eval "$gchange top-panel-position 0"
		eval "$gchange type-to-search true"
		eval "$gchange weather true"
		eval "$gchange window-demands-attention-focus false"		
		eval "$gchange window-menu-take-screenshot-button true"
		eval "$gchange window-picker-icon true"
		eval "$gchange window-preview-caption true"
		eval "$gchange window-preview-close-button true"
		eval "$gchange workspace true"
		eval "$gchange workspace-background-corner-size 0"
		eval "$gchange workspace-popup true"
		eval "$gchange workspace-switcher-should-show false"
		eval "$gchange workspace-switcher-size 0"
		eval "$gchange workspace-wrap-around false"
		eval "$gchange workspaces-in-app-grid true"
		eval "$gchange world-clock true"
		
		#########################
		# Configure OpenWeather #
		#########################
		extension_name="openweather-extension@jenslody.de"
		extension_id="org.gnome.shell.extensions.openweather"
		eval "$gchange actual-city 0"
		eval "$gchange appid ''"
		eval "$gchange center-forecast true"
		eval "$gchange days-forecast 5"
		eval "$gchange decimal-places 1"
		eval "$gchange delay-ext-init 7"
		eval "$gchange disable-forecast false"
		eval "$gchange expand-forecast false"
		eval "$gchange geolocation-appid-mapquest ''"
		eval "$gchange geolocation-provider 'openstreetmaps'"
		eval "$gchange location-text-length 0"
		eval "$gchange menu-alignment 75.0"
		eval "$gchange owm-api-translate false"
		eval "$gchange position-in-panel 'right'"
		eval "$gchange position-index 10"
		eval "$gchange prefs-default-height 600"
		eval "$gchange prefs-default-width 700"
		eval "$gchange pressure-unit 'kPa'"
		eval "$gchange refresh-interval-current 600"
		eval "$gchange refresh-interval-forecast 3600"
		eval "$gchange show-comment-in-forecast true"
		eval "$gchange show-comment-in-panel false"
		eval "$gchange show-text-in-panel true"
		eval "$gchange translate-condition true"
		eval "$gchange unit 'celsius'"
		eval "$gchange use-default-owm-key true"
		eval "$gchange use-system-icons true"
		eval "$gchange weather-provider 'openweathermap'"
		eval "$gchange wind-direction false"
		eval "$gchange wind-speed-unit 'kph'"
		
		####################################
		# Configure Rounded Window Corners #
		####################################
		extension_name="rounded-window-corners@yilozt"
		extension_id="org.gnome.shell.extensions.rounded-window-corners"		
		eval "$gchange black-list \"['conky']\""
		eval "$gchange border-color '(0.5, 0.5, 0.5, 1.0)'"
		eval "$gchange border-width 0"
		eval "$gchange debug-mode false"
		eval "$gchange enable-preferences-entry false"
		eval "$gchange focused-shadow \"{'horizontal_offset': 0, 'vertical_offset': 4, 'blur_offset': 28, 'spread_radius': 4, 'opacity': 60}\""
		eval "$gchange global-rounded-corner-settings \"{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <false>, 'fullscreen': <false>}>, 'border_radius': <uint32 12>, 'smoothing': <uint32 0>, 'enabled': <true>}\""
		eval "$gchange settings-version uint32 5"
		eval "$gchange skip-libadwaita-app false"
		eval "$gchange skip-libhandy-app false"
		eval "$gchange tweak-kitty-terminal false"
		eval "$gchange unfocused-shadow \"{'horizontal_offset': 0, 'vertical_offset': 2, 'blur_offset': 12, 'spread_radius': -1, 'opacity': 65}\""

		####################
		# Configure TopHat #
		####################
		# Export Array of required dependencies for Freon
		export required_dependencies=("gir1.2-gtop-2.0")
		
		# Load installdependencies.sh
		source "subscripts/installdependencies.sh"
		# Execute installdependencies function to check if extensions are already installed and install if they're not
		installdependencies
		
		extension_name="tophat@fflewddur.github.io"
		extension_id="org.gnome.shell.extensions.tophat"
		eval "$gchange cpu-display 'chart'"
		eval "$gchange cpu-show-cores true"
		eval "$gchange disk-display 'chart'"
		eval "$gchange disk-monitor-mode 'storage'"
		eval "$gchange mem-display 'chart'"
		eval "$gchange meter-bar-width 0.6"
		eval "$gchange meter-fg-color '#1dacd6'"
		eval "$gchange mount-to-monitor '/'"
		eval "$gchange network-usage-unit 'bytes'"
		eval "$gchange position-in-panel 'left'"
		eval "$gchange refresh-rate 'medium'"
		eval "$gchange show-animations true"
		eval "$gchange show-cpu true"
		eval "$gchange show-disk true"
		eval "$gchange show-icons true"
		eval "$gchange show-mem true"
		eval "$gchange show-net false"
		
		# Remove KDEConnect because it sucks in Gnome, GSConnect was installed which works better
		sudo apt-get remove kdeconnect -y
		
		# Enable extensions after being configured and installed
		$genable volume-mixer@evermiss.net
		$genable avatar@pawel.swiszcz.com
		$genable blur-my-shell@aunetx
		$genable freon@UshakovVasilii_Github.yahoo.com
		$genable gamemode@christian.kellner.me
		$genable gsconnect@andyholmes.github.io
		$genable just-perfection-desktop@just-perfection
		$genable noannoyance@daase.net
		$genable openweather-extension@jenslody.de
		$genable pi-hole@fnxweb.com
		$genable rounded-window-corners@yilozt
		$genable tophat@fflewddur.github.io
		
        # Disable sending output to log file
		exec > /dev/tty 2>&1
		# Exit this subscript and go back to the main menu
		break

	# If user chose no
	elif answer_no "$answer_extensions"; then
		break # Exit this subscript and go back to the main menu
	
	# If user inputs something besides yes/no/y/n
	else
		echo "Invalid Choice"
	fi
done
}