#!/bin/sh
gitRepoPath="https://github.com/skipcress/CaptureCursor.git"

# Function checks if failure occurred, and if so exits script 
function exit_on_fail() {
	if [[ $? -gt 0 ]]; then
		echo "\n\033[31mInstaller failed because the last process exited with an unexpected exit code.\033[0m\n"
		exit 1
	fi
}

# Function installs Homebrew
function install_brew() {	
	echo "\033[32mInstalling Homebrew...\033[0m\n" 	
  	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Function escalates user privilages
function escalate_privilages() {
	echo "\n\033[32mEnter the password to your computer if prompted...\033[0m"
	sudo echo > /dev/null
}

# 1. Install dependencies
echo "\n\033[32m#########################################################################\033[0m"
echo "\033[32m##### Installing software dependencies (this may take some time)... #####\033[0m"
echo "\033[32m#########################################################################\033[0m\n"

## Install XCode
#echo "\n\033[32mChecking if XCode Command Line Developer Tools are installed...\033[0m"
#xcode-select -p > /dev/null
#if [[ $? -gt 0 ]]; then
#	echo "\n\033[32mXCode not installed; installing XCode...\033[0m\n"
#	echo "\033[32mPress the 'Install' button, then agree to the ULA to complete this installation.\033[0m\n"
# 	xcode-select --install
#	exit_on_fail
#else
#	echo "\n\033[32mXCode already installed.\033[0m\n"
#fi

echo "\n\033[32mChecking if Homebrew is installed...\033[0m\n"
which -s brew > /dev/null
if [[ $? != 0 ]]; then
	# Install Homebrew
 	escalate_privilages
	install_homebrew
	exit_on_fail
else
	# Update Homebrew
	echo "\033[32mUpdating Homebrew...\033[0m\n"
	brew update
	exit_on_fail
fi

# Install git
echo "\n\033[32mInstalling git (if not already installed)\nFollow prompts to install software.\033[0m\n"
git --version
exit_on_fail

# Install CLIClick
echo "\033[32mInstalling or updating cliclick...\033[0m\n"
brew install cliclick
exit_on_fail

# 2. Copying files
echo "\n\033[32m########################################\033[0m"
echo "\033[32m##### Copying files from GitHub... #####\033[0m"
echo "\033[32m########################################\033[0m\n"

echo "\n\033[32mCreating temp directory...\033[0m"
mkdir ~/Documents/CaptureCursor
exit_on_fail
echo "\033[32mMoving to temp directory...\033[0m"
exit_on_fail
cd ~/Documents/CaptureCursor
echo "\033[32mUsing git to fetch necessary files...\033[0m"
git clone $gitRepoPath
exit_on_fail

# 3. Compiling application
echo "\n\033[32m########################################\033[0m"
echo "\033[32m##### Compiling the Application... #####\033[0m"
echo "\033[32m########################################\033[0m\n"

osacompile -o ~/Documents/CaptureCursor/CaptureCursor.app ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.applescript
exit_on_fail

# 4. Install application
echo "\n\033[32#######################################\033[0m"
echo "\033[32m##### Installing the Application #####\033[0m"
echo "\033[32m######################################\033[0m\n"

escalate_privilages
echo "\n\033[32mCopying base script...\033[0m\n"
sudo cp ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.sh /usr/local/bin
exit_on_fail
echo "\n\033[32mMaking base script executable...\033[0m\n"
sudo chmod +x /usr/local/bin/CaptureCursor.sh
exit_on_fail
echo "\n\033[32mCopying compiled application...\033[0m\n"
sudo cp -R ~/Documents/CaptureCursor/CaptureCursor.app /Applications/
exit_on_fail
echo "\n\033[32mCopying new icon to Resources directory...\033[0m\n"
sudo cp ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.icns /Applications/CaptureCursor.app/Contents/Resources/applet.icns
exit_on_fail

# 5. Cleaning up temporary files
echo "\n\033[32m#######################################\033[0m"
echo "\033[32m##### Cleaning up Temporary Files #####\033[0m"
echo "\033[32m#######################################\033[0m\n"

echo "\n\033[32mDeleting temp folder (any failures at this stage will not effect the running of the application)...\033[0m\n"
rm -rf ~/Documents/CaptureCursor

# All operations complete
echo "\n\033[32m####################################\033[0m"
echo "\033[32m##### All Operations Complete! #####\033[0m"
echo "\033[32m####################################\033[0m\n"

echo "\n\033[32mCaptureCursor is now installed. You may now close this terminal window.\033[0m"
