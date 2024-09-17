#!/bin/bash

# Checks if cursor is outide bounds of primary monitor
# if so, moves the cursor to the nearest monitor edge
function move_cursor() {
	if [ "$CX" -gt "$X" ]; then
		echo "Cursor moved (PRESS CTRL+C TO EXIT)"
		cliclick m:$X,$CY p
	fi
	if [ "$CX" -lt 0 ]; then
		echo "Cursor moved (PRESS CTRL+C TO EXIT)"
		cliclick m:0,$CY p
	fi
	if [ "$CY" -gt "$Y" ]; then
		echo "Cursor moved (PRESS CTRL+C TO EXIT)"
		cliclick m:$CX,$Y p
	fi
	if [ "$CY" -lt 0 ]; then
		echo "Cursor moved (PRESS CTRL+C TO EXIT)"
		cliclick m:$CX,0 p
	fi
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
sleepSecs=0.25

echo "Beginning cursor position monitoring; PRESS CTRL+C TO EXIT"

# Infinite loop gets current cursor location, and passes it to move_cursor()
while true 
do
	CX=$(/opt/homebrew/bin/cliclick p | awk 'BEGIN { FS = "," }; {print $1}')
	CY=$(/opt/homebrew/bin/cliclick p | awk 'BEGIN { FS = "," }; {print $2}')
	move_cursor $CX $CY $X $Y
	
	sleep $sleepSecs
done
