#!/bin/bash
clear
updates() {
	clear
	# Confirmation Menu
	while true; do
	Menu_OneMessage "Do you want to update and upgrade the system?"

	#Ask Update Question
	read -p "Enter your choice (y/n): " answer_update
	
	if answer_yes "$answer_update"; then
		messagecolor=$red
		Menu_TwoMessages "Updating system" "Please wait..."
		{ sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y && flatpak update -y; } > logs/updates_log.txt 2>&1
		
		messagecolor=$green
		Menu_OneMessage "System updated!"
		sleep 1
		while true; do
			Menu_TwoMessages "If this is a first time setup"  "A Reboot is needed. Do you want to reboot?"
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
		break
	else
		echo "Invalid answer"
	fi
	done
}