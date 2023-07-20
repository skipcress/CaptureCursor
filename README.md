# CaptureCursor
A MacOS application intended to be run in conjunction with ProPresenter, which will move the cursor to the nearest screen edge.

To install:
1. Download the file "Install_CaptureCursor.sh" to your Downloads directory
2. Open a terminal instance. To do this, you can use the keyboard shortcut CTRL+Space, type the word "Temrinal" and hit Enter
3. Copy the following command and paste it into your terminal window, hit Enter, and enter the password to your computer when prompted (you will not see your password as you type it, this is normal):<br/>sudo chmod +x ~/Downloads/Install_CaptureCursor.sh
4. Copy the following command and paste it into your teminal window, hit Enter, and follow the prompts:<br/>~/Downloads/Install_CaptureCursor.sh
5. Grant Accessibility privilages to the Terminal application. The exact steps to do this will depend on your version of MacOS. You will need to use the plus button to search for the Terminal app in order to add it. You can find the app under: /Applications/Utilities/Temrinal

Currently only supported on MacOS.

Once CaptureCursor is installed, you can find it by launching Launchpad, just like most other applications. You can also pin it to your Dock.

# TROUBLESHOOTING

1. <b>Update Homebrew is failing</b><br>On older versions of MacOS where Homebrew (and Apple) no longer support the OS, updating Homebrew may fail. Provided Homebrew is installed on the machine, you can simply comment out line 56 of Install_CaptureCursor.sh by adding a hash (#) before the line as such:<br><br>\# brew update --debug --verbose<br><br>
2. <b>Cursor is still allowed to leave the bounds of the primary display</b><br>If the screen resolution detected by the script is incorrect, the cursor will not be properly retained. You can confirm this by checking the reported resolution detected by the script in the terminal output. To correct this, you can hardcode these values in CaptureCursor.sh (which is located at /usr/local/bin/CaptureCursor.sh). Note: this file is owned by admin, you will need to use escalated permissions to edit the file. To hardcode the screen resolution, first comment out lines 34 and 37 by adding a hash (#) before each line as such:<br><br>\# X=$(system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $2;}')<br>\# Y=$(system_profiler SPDisplaysDataType | grep Resolution | awk 'NR==1{print $4;}')<br><br>...next, just after line 37 add the following lines, where [X RESOLUTION] and [Y RESOLUTION] are the actual dimensions of your monitor:<br><br>X=[X RESOLUTION]<br>Y=[Y RESOLUTION]
