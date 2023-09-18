#!/bin/bash
clear
updates() {
	# Check Updates
	while true; do
	Main_Menu_Upper_Text
	echo -e "${orange}|░${lightgray}       Do you want to update and upgrade the system?        ${orange}░|"
	Main_Menu_Bottom_Text

	#Ask Update Question
	read -p "Enter your choice (y/n): " answer_update
	
	if answer_yes "$answer_update"; then
		clear
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                         Updating...                        ${orange}░|"
		Main_Menu_Bottom_Text
		sudo apt-get update -y > logfile.log 2>&1 
		sudo apt-get upgrade -y > logfile.log 2>&1
		sudo apt-get autoremove -y > logfile.log 2>&1
		Main_Menu_Upper_Text
		echo -e "${orange}|░${green}                       Updates Done...                      ${orange}░|"
		Main_Menu_Bottom_Text
		sleep 2
		while true; do
			clear
			Main_Menu_Upper_Text
			echo -e "${orange}|░${red}            Reboot needed. Do you want to reboot?           ${orange}░|"
			Main_Menu_Bottom_Text
			read -p "Enter your choice (y/n): " answer_reboot
			if answer_yes "$answer_reboot"; then
				sudo reboot
				break
			elif answer_no "$answer_reboot"; then
				break 2
			else
				echo "Invalid answer"
			fi
			done
	elif answer_no "$answer_update"; then
		Main_Menu_Upper_Text
		echo -e "${orange}|░${red}                     Skipping Updates...                    ${orange}░|"
		Main_Menu_Bottom_Text
		sleep 1
		break
	else
		echo "Invalid answer"
	fi
	done
	echo "Done"
}