#!/bin/bash
clear

# Color variables
green='\e[32m'
red='\e[38;5;196m'
orange='\e[38;5;214m'
lightgray='\033[00;37m'
resetcolor='\e[0m'

# Sudo check
if [[ $EUID -eq 0 ]]; then
	messagecolor=$red
	echo -e "${red}Please do not run this script as sudo! \nPlease read the instructions"
	read -r
	exit 1
fi

# Check if subscripts directory exists
if [ ! -d "subscripts" ]; then
    clear
    echo -e "${red}Can't find the 'subscripts' folder! \nPlease read the instructions"
    read -r
    exit 1
fi

# Check if .sh files exist
files=("extensions.sh" "installconky.sh" "installdependencies.sh" "installextensions.sh" "installflatpaks.sh" "menus.sh" "software.sh" "themes.sh" "updates.sh" "yes_no.sh")
for file in "${files[@]}"; do
    if [ ! -f "subscripts/$file" ]; then
        clear
        echo -e "${red}Can't find '$file' inside the 'subscripts' folder! \nPlease read the instructions"
        read -r
        exit 1
    fi
done

# Make subscripts executable
chmod a+x subscripts/*

# Load menus.sh
source "subscripts/menus.sh"
# Load yes_no.sh
source "subscripts/yes_no.sh"

# Determine the directory containing the script
script_directory="$(dirname "$0")"

# Create a directory to store logs
mkdir -p logs

# This needs to be last in this script
# Main Menu loop
while true; do
	Main_Menu_Upper_Text
	Main_Menu_Core_Text
	Main_Menu_Bottom_Text
	read -rp "Enter your choice: " choice
	Read_Main_Menu_Choice "$choice"
done