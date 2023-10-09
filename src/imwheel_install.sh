#!/bin/bash
# Answer is yes function
imwheel_install(){
	# Display Menu for installing dependencies
	clear
	messagecolor=$red
	Menu_TwoMessages "Installing dependencies" "Please wait..."

	# Array of required dependencies
	required_dependencies=("imwheel")
		
	# Load dependencies_install.sh
	source "src/dependencies_install.sh"
		
	# Execute dependencies_install function to check if extensions are already installed and install if they're not
	dependencies_install > logs/extensions_log.txt 2>&1 # Send output from dependencies_install function to logfile
	
	# Create imwheel file if it doesn't exist
	if [ ! -f ~/.imwheelrc ]; then
		cat >~/.imwheelrc<<EOF
"^(discord-screenaudio|discord|steam|divolt-desktop|whatsapp-desktop-linux|revolt-desktop)$"
None,      Up,   Button4, 2
None,      Down, Button5, 2
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
EOF
	fi
	
	mkdir -p "$HOME/.imwheel"
	touch "$HOME/.imwheel/imwheel.sh"
	chmod +x "$HOME/.imwheel/imwheel.sh"
	
	cat >"$HOME/.imwheel/imwheel.sh"<<EOF
imwheel -kill -b "4 5"
EOF
	# Create autostart directory if it doesn't exist
	mkdir -p "$HOME/.config/autostart"

	# Create .desktop entry to launch conky
	touch "$HOME/.config/autostart/imwheel.desktop"
	chmod +x "$HOME/.config/autostart/imwheel.desktop"
	cat <<EOF > "$HOME/.config/autostart/imwheel.desktop"
[Desktop Entry]
Name=imwheel
Exec="$HOME/.imwheel/imwheel.sh"
Terminal=false
Type=Application
EOF
}