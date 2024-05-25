#!/bin/bash

display_menu() {
	MENU=$(whiptail --title "$FILE_PATH.$extension loaded successfully" --menu "choices" 0 0 0 1 "Unique values" 2 "headers" 3 "max and min" 4 "rows and columns" 5 "stats for nums" 6 "sort" 3>&1 1>&2 2>&3 3>&-)

	case $MENU in
	1)
		echo "unique values"
		;;
	2)
		displayHeader
		;;
	3)
		maxAndMinValueFromColumn
		;;
	4)
		displayRowAndColumn
		;;
	5)
		calculateSummaryStatics
		;;
	6)
		sortCsvFile
		;;
	*)
		echo "default MENU FOR ANALYSIS"
		;;
	esac
}

displayRowAndColumn() {
	no_row=$(tail -n +2 "$FILE_PATH_FULL" | wc -l)

	# echo "Number of rows: $no_row"

	no_columns=$(head -n 1 "$FILE_PATH_FULL" | grep -o ',' | wc -l)
	((no_columns++)) # Increment by 1 to account for the last column

	whiptail --title "Rows and Columns" --msgbox "columns: $no_columns & Rows : $no_row " 0 0
	# echo "Number of columns: $no_columns"
}
filterAndExtractRowAndColumn() {
	echo "enter the column number: "
	read column_numb
	echo "enter the value: "
	read value
	awk -F ',' -v column_num="$column_numb" -v value="$value" '$column_num == value' "$FILE_PATH_FULL"
}

maxAndMinValueFromColumn() {
	# echo "Enter the column number: "
	# read column_numb
	column_numb=$(whiptail --title "Enter the column number" --inputbox "column number" 0 0 3>&1 1>&2 2>&3 3>&-)

	min=$(cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | tail -n +2 | sort | head -n 1)
	max=$(cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | tail -n +2 | sort -r | head -n 1)

	whiptail --title "min and max" --infobox "$min is the minimum : $max is the maximum" 0 0
	# echo "$min is the minimum"
	echo "$max is the maximum"
}

calculateSummaryStatics() {

	# read column_numb
	column_numb=$(whiptail --title "Enter the column number" --inputbox "column number" 0 0 3>&1 1>&2 2>&3 3>&-)
	count=0
	sum=0

	cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | tail -n +2 >temp.txt

	while IFS= read -r line; do
		sum=$((sum + line))
		count=$((count + 1))
	done <temp.txt

	mean=$((sum / count))
	# echo "Mean: $mean"
	whiptail --title "mean" --infobox "Mean: $mean" 0 0

	lines=$count

	if [[ $((lines % 2)) == 0 ]]; then
		line1=$((lines / 2))
		line2=$((line1 + 1))
		value=$(cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | sort | sed -n "${line1}p")
		value2=$(cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | sort | sed -n "${line1}p")

		whiptail --title "Value 1 and 2" --infobox "Val 1 : $value | Val 2 : $value2 " 0 0
		# echo $value
		# echo $value2
		lin=$((value + value2))

		median=$((lin / 2))
		# echo "Median: $median"
		whiptail --title "median" --infobox "Median : $median" 0 0

	else
		{
			line=$((lines / 2 + 1))
			value=$(cut -d ',' -f "$column_numb" "$FILE_PATH_FULL" | sort | sed -n "${line}p")
			whiptail --title "Median odd " --infobox "Median odd $value " 0 0
			# echo "Median odd $value"
		}
	fi
}
displayHeader() {
	head -n 1 "$$FILE_PATH_FULL"
}

sortCsvFile() {
	echo "enter the column number: "
	read column_numb
	head -n 1 "$FILE_PATH_FULL"
	tail -n +2 "$FILE_PATH_FULL" | sort -t ',' -k"$column_numb"n
}

PICK=$(whiptail --title "CSV Analysis" --menu "CHOOSE" 0 0 0 1 "open" 2 "settings" 3 "help" 4 "exit" 3>&1 1>&2 2>&3 3>&-)

case $PICK in
1)
	FILE_PATH_FULL=$(zenity --file-selection "choose csv")
	filename=$(basename -- "$FILE_PATH_FULL")
	extension="${filename##*.}"
	FILE_PATH="${filename%.*}"
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
