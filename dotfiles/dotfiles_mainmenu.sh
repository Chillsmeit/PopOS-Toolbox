#!/bin/bash
# Sudo check
if [[ $EUID -eq 0 ]]; then
	echo "Please do not run this script as sudo"
	exit 0
fi
clear

# Check if subscripts folder exists
if [ ! -d "subscripts" ]; then
    echo "The 'subscripts' folder does not exist in the current directory."
    echo "Please follow the instructions"
    exit 1
fi

mkdir -p logs

# Main Menu
Main_Menu_Upper_Text() {
	clear
	echo -e "${orange}          ████████████████████████████████████████████ ${resetcolor}"
	echo -e "${orange}          █▓▓▒▒░░ Chillsmeit Pop!_OS Installer ░░▒▒▓▓█${resetcolor}"
	echo -e "${orange}|██████████████████████████████████████████████████████████████|${resetcolor}"
	echo -e "${orange}|░                                                            ░|"
	echo -e "${orange}|░                                                            ░|"
}
Main_Menu_Core_Text() {
	echo -e "${orange}|░${lightgray}           1. Update and Upgrade System ${orange}                    ░|"
	echo -e "${orange}|░${lightgray}           2. Install & Configure Gnome Extensions ${orange}         ░|"
	echo -e "${orange}|░${lightgray}           3. Install & Configure Gnome Themes ${orange}             ░|"
	echo -e "${orange}|░${lightgray}           4. Exit ${orange}                                         ░|"
}
Main_Menu_Bottom_Text() {
	echo -e "${orange}|░                                                            ░|"
	echo -e "${orange}|░                                                            ░|"
	echo -e "${orange}|██████████████████████████████████████████████████████████████|${resetcolor}"
	echo -e ""
}

Read_Main_Menu_Choice() {
	case $1 in
		1)
			source "subscripts/updates.sh"
			updates
			;;
		2)
			source "subscripts/extensions.sh"
			extensions
			;;
		3)
			source "subscripts/themes.sh"
			themes
			;;
		4)
			echo "Exiting"
			exit 0
			;;
		*)
			;;
	esac
}

# Answer is yes function
function answer_yes() {
	case "$1" in
		[Yy]|[Yy][Ee][Ss])
			return 0
			;;
		*)
			return 1
			;;
	esac
}

# Answer is no function
function answer_no() {
	case "$1" in
		[Nn]|[Nn][Oo])
			return 0
			;;
		*)
			return 1
			;;
	esac
}

# Color variables
green='\e[32m'
red='\e[31m'
orange='\e[38;5;214m'
lightgray='\033[00;37m'
resetcolor='\e[0m'

# Make subscripts executable
chmod a+x subscripts/*

# This needs to be last in this script
# Main Menu loop
while true; do
	Main_Menu_Upper_Text
	Main_Menu_Core_Text
	Main_Menu_Bottom_Text
	read -rp "Enter your choice: " choice
	Read_Main_Menu_Choice "$choice"
done