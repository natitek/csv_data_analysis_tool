#!/bin/bash

display_menu(){
MENU=$(whiptail --title "Choose analysis options"  --menu "choices" 0 0 0 1 "Unique values" 2 "headers" 3 "max and min" 4 "rows and columns" 5 "stats for nums" 6 "sort" 3>&1 1>&2 2>&3 3>&-)
	
case $MENU in
1)
	echo "unique values"
	;;
2)
	echo "headers"
	;;
3)
	cho "max and min"
	;;
4)
	echo "rows and columns"
	;;
5)
	echo "status for nums"
	;;
6)
	echo "sort "
	;;
*)
echo "default MENU FOR ANALYSIS"
	;;
	esac
}


PICK=$(whiptail --title "CSV Analysis" --menu "CHOOSE" 0 0 0 "this" "open" 2 "settings" 3 "help" 4 "exit" 3>&1 1>&2 2>&3 3>&-)

case $PICK in
1)
	echo "1st"
	FILE_PATH=$(zenity --file-selection "choose csv")
	zenity --title "File Loaded" --info --text="{$FILE_PATH} loaded successfully" 8 78
	display_menu
	;;
2)
	echo "Settings"
	;;
3)
	echo "reminder"
	;;
4)
	echo "reminder2"
	;;
*)
	echo "default"
	;;
	esac



# regex on grep




