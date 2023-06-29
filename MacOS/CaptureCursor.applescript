tell application "Terminal"
	do script "/usr/local/bin/CaptureCursor.sh"
	set scriptWindow to the front window
	tell application "System Events"
		tell process "Terminal"
			set frontmost to true
		end tell
	end tell
	repeat
		set scriptRunning to busy of scriptWindow
		if scriptRunning is false then
			close scriptWindow
			exit repeat
		end if
	end repeat
end tell
