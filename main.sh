#!/bin/bash

csv_file=$1
if [ ! -f "$csv_file" ]; then
    echo "Usage: $0 <csv_file>"
    echo "File not found!"
    exit 1
fi

display_menu() {
    echo "1. Display number of rows and columns"
    echo "2. List unique values in a column"
    echo "3. Display column names"
    echo "4. Display the maximum and minimum value from the given column"
    echo "5. Display the most frequent value"
    echo "6. Calculate Summary Statistics"
    echo "7. Filter and extract rows"
    echo "8. Sort CSV File"
    echo "9. Exit"
}

displayRowAndColumn() {
    no_row=$(tail -n +2 "$csv_file" | wc -l) 
    echo "Number of rows: $no_row" 

    no_columns=$(head -n 1 "$csv_file" | grep -o ',' | wc -l)
    ((no_columns++))  # Increment by 1 to account for the last column
    echo "Number of columns: $no_columns"
}

listUniqueValue() {
    tail -n +2 "$csv_file" | sort | uniq
}

displayHeader() {
    head -n 1 "$csv_file"
}

maxAndMinValueFromColumn() {
    echo "Enter the column number: "
    read column_numb

    min=$(cut -d ',' -f "$column_numb" "$csv_file" | tail -n +2 | sort | head -n 1)
    max=$(cut -d ',' -f "$column_numb" "$csv_file" | tail -n +2 | sort -r | head -n 1)

    echo "$min is the minimum" 
    echo "$max is the maximum"
}



mostFrequentValue() {
    echo "Enter the column number: "
    read column_numb
    cut -d ',' -f "$column_numb" "$csv_file" | tail -n +2 | sort | uniq -c | sort -nr | head -n 1
}

calculateSummaryStatics() {
    echo "Enter the column number: "
    read column_numb
    count=0
    sum=0

    cut -d ',' -f "$column_numb" "$csv_file" | tail -n +2 > temp.txt

    while IFS= read -r line
    do
        sum=$((sum + line))
        count=$((count + 1))
    done < temp.txt

    mean=$((sum / count))
    echo "Mean: $mean"

    lines=$count

    if [[ $((lines % 2)) == 0 ]]
    then
        line1=$((lines / 2))
        line2=$((line1 + 1))
        value=$(cut -d ',' -f "$column_numb" "$csv_file"|sort |sed -n "${line1}p")
        value2=$(cut -d ',' -f "$column_numb" "$csv_file"|sort |sed -n "${line1}p")

        echo $value 
        echo $value2 
        lin=$((value + value2))

        median=$((lin / 2))
        echo "Median: $median"

    else {
        line=$((lines/2 +1))
        value=$(cut -d ',' -f "$column_numb" "$csv_file"|sort |sed -n "${line}p")
        echo "Median odd $value"
        }
    fi
}

filterAndExtractRowAndColumn(){
    echo "enter the column number: "
    read column_numb
    echo "enter the value: "
    read value
    awk -F ',' -v column_num="$column_numb" -v value="$value" '$column_num == value' "$csv_file"    
}

sortCsvFile (){
    echo "enter the column number: "
    read column_numb
    head -n 1 "$csv_file"
    tail -n +2 "$csv_file" | sort -t ',' -k"$column_numb"n
}

while true; do
    echo "-------------------------"
    echo "Enter your choice: "
    echo "-------------------------"
    display_menu
    read choice
    echo "$choice is your choice"

    case "$choice" in

        1) 
          displayRowAndColumn 
          ;;
        2) 
          listUniqueValue 
          ;;
        3) 
          displayHeader 
          ;;
        4) 
           maxAndMinValueFromColumn 
           ;;
        5) 
           mostFrequentValue 
           ;;
        6) 
           calculateSummaryStatics 
           ;;
        7) 
           filterAndExtractRowAndColumn 
           ;;
        8) 
           sortCsvFile 
           ;;
        9) exit 0 
           ;;
        *) 
           echo "please enter the number between 1 - 9" 
           ;;
    esac
done