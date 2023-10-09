#!/bin/bash
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
	echo -e "${orange}|░${lightgray}           4. Install & Configure Librewolf ${orange}                ░|"
	echo -e "${orange}|░${lightgray}           5. Install & Configure imwheel ${orange}                  ░|"
	echo -e "${orange}|░${lightgray}           6. Exit ${orange}                                         ░|"
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
			source "subscripts/librewolf.sh"
			librewolf
			;;
		5)
			source "subscripts/imwheel.sh"
			imwheel
			;;
		6)
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

Menu_OneMessage() {
    local message="$1"
    local total_width=60
    local message_length=${#message}
    
    # Calculate left and right paddings
    local left_padding=$(( (total_width - message_length) / 2 ))
    local right_padding=$(( total_width - message_length - left_padding ))

    clear
    Main_Menu_Upper_Text
    echo -e "${orange}|░${lightgray}$(printf "%${left_padding}s" "")${messagecolor}${message}$(printf "%${right_padding}s" "")${orange}░|${lightgray}"
    Main_Menu_Bottom_Text
}

Menu_TwoMessages() {
    local message1="$1"
    local message2="$2"
    local total_width=60

    local message1_length=${#message1}
    local message2_length=${#message2}
    
    # Calculate left and right paddings for message1
    local left_padding1=$(( (total_width - message1_length) / 2 ))
    local right_padding1=$(( total_width - message1_length - left_padding1 ))

    # Calculate left and right paddings for message2
    local left_padding2=$(( (total_width - message2_length) / 2 ))
    local right_padding2=$(( total_width - message2_length - left_padding2 ))
    
    # Use the global messagecolor if set, otherwise default to lightgray
    local local_messagecolor="${messagecolor:-$lightgray}"

    clear
    Main_Menu_Upper_Text
    echo -e "${orange}|░${lightgray}$(printf "%${left_padding1}s" "")${messagecolor}${message1}$(printf "%${right_padding1}s" "")${orange}░|${lightgray}"
    echo -e "${orange}|░${lightgray}$(printf "%${left_padding2}s" "")${messagecolor}${message2}$(printf "%${right_padding2}s" "")${orange}░|${lightgray}"
    Main_Menu_Bottom_Text
    
    # Unset the global messagecolor so it doesn't affect subsequent calls
    unset messagecolor
}