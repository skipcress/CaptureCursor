#!/bin/sh

# Checks if process is already running
processCount=$(ps -ef | grep 'CaptureCursor.sh' | wc -l)
if [ $processCount -gt 4 ]; then
	exit 0;
fi

# Checks if cursor is outide bounds of primary monitor
# if so, moves the cursor to center point of monitor
function move_cursor() {
	echo "Checking if cursor is in primary screen bounds..."
	if [ "$CX" -gt "$X" ] || [ "$CY" -gt "$Y" ] || [ "$CX" -lt 0 ] || [ "$CY" -lt 0 ]; then
		cliclick m:$((X / 2)),$((Y / 2)) p
		echo "Cursor moved to: x=$((X / 2)), y=$((Y / 2))"
	else
		echo "Cursor is within bounds, no action taken."
	fi
}

# Pads input with leading zeros, up to 5 digits
function pad() {
	printf "%05d" $1
}

# Clears the screen on exit
function cleanup() {
	clear
	exit 0
}

# Handles script termination
trap cleanup SIGINT 

# Gets width of primary monitor
 X=$(system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $2;}')

# Gets height of primary monitor
 Y=$(system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $4;}')

# Clears screen, and prints monitor resolution to console
clear
echo "Resolution detected for primary monitor: ${X}x${Y}"
echo ""

# Sets variable that specifies frequency of cursor location check
sleepSecs=3

# Counter keeps track of iterations
counter=0

# Infinite loop gets current cursor location, and passes it to move_cursor()
while true 
do
	CX=$(cliclick p | awk 'BEGIN { FS = "," }; {print $1}')
	CY=$(cliclick p | awk 'BEGIN { FS = "," }; {print $2}')
	move_cursor $CX $CY $X $Y
	
	echo ""
	((counter++))
	echo -e "$(pad $counter): Sleeping for $sleepSecs second(s) - \033[32mPress CTRL+C to exit\033[0m"
	sleep $sleepSecs
done
