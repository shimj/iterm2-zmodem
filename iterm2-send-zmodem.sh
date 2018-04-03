#!/bin/bash
# Author: Matt Mastracci (matthew@mastracci.com)
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script
# licensed under cc-wiki with attribution required 
# Remainder of script public domain

osascript -e 'tell application "iTerm2" to version' > /dev/null 2>&1 && NAME=iTerm2 || NAME=iTerm
FILES=`osascript -e 'tell application "'$NAME'" to activate' -e 'tell application "'$NAME'" to set theList to choose file with prompt "Please select files" with multiple selections allowed' -e 'set filelist to ""' -e 'repeat with a from 1 to length of theList' -e 'set filelist to filelist & "\"" & (do shell script ("echo " & (quoted form of POSIX path of item a of theList as Unicode text) & "")) & "\" "' -e 'end repeat'`
if [[ $FILES = "" ]]; then
	echo Cancelled.
	# Send ZModem cancel
	echo -e \\x18\\x18\\x18\\x18\\x18
	sleep 1
	echo
	echo \# Cancelled transfer
else
	eval /usr/local/bin/sz $FILES -e -b
	sleep 1
	echo
	echo \# Received $FILES
fi
