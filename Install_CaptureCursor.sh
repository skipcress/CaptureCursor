#!/bin/sh
gitRepoPath="https://github.com/skipcress/CaptureCursor.git"

# Function checks if failure occurred, and if so exits script 
function exit_on_fail() {
	if [[ $? -gt 0 ]]; then
		echo -e "\n\033[31mInstaller failed because the last process exited with an unexpected exit code.\033[31m\n"
		exit 1
	fi
}

# Function installs Homebrew
function install_brew() {
	echo -e "\033[32mInstalling Homebrew...exit\033[32m\n"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# 1. Install dependencies
echo -e "\n\033[32m#########################################################################\033[32m"
echo -e "\033[32m##### Installing software dependencies (this may take some time)... #####\033[32m"
echo -e "\033[32m#########################################################################\033[32m\n"

# Install XCode
echo -e "\n\033[32mInstalling XCode Command Line Developer Tools (if not already installed)\nPress the "Install" button, then agree to the ULA to complete this installation.\033[32m\n"
xcode-select --install
exit_on_fail

# Install git
echo -e "\033[32mInstalling git (if not already installed)\nFollow prompts to install software.\033[32m\n"
git --version
exit_on_fail

which -s brew
if [[ $? != 0 ]]; then
	# Install Homebrew
	install_homebrew
	exit_on_fail
else
	# Update Homebrew
	echo -e "\033[32mUpdating Homebrew...\033[32m\n"
	brew update
	exit_on_fail
fi

# Install CLIClick
echo -e "\033[32mInstalling or updating cliclick...\033[32m\n"
brew install cliclick
exit_on_fail

# 2. Copying files
echo -e "\n\033[32m########################################\033[32m"
echo -e "\033[32m##### Copying files from GitHub... #####\033[32m"
echo -e "\033[32m########################################\033[32m\n"

echo -e "\n\033[32mCreating temp directory...\033[32m"
mkdir ~/Documents/CaptureCursor
exit_on_fail
echo -e "\033[32mMoving to temp directory...\033[32m"
exit_on_fail
cd ~/Documents/CaptureCursor
echo -e "\033[32mUsing git to fetch necessary files...\033[32m"
git clone $gitRepoPath
exit_on_fail

# 3. Compiling application
echo -e "\n\033[32m########################################\033[32m"
echo -e "\033[32m##### Compiling the Application... #####\033[32m"
echo -e "\033[32m########################################\033[32m\n"

osacompile -o ~/Documents/CaptureCursor.app ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.applescript
exit_on_fail

# 4. Install application
echo -e "\n\033[32#######################################\033[32m"
echo -e "\033[32m##### Installing the Application #####\033[32m"
echo -e "\033[32m######################################\033[32m\n"

echo -e "\n\033[32mEnter the password to your machine when prompted...\033[32m"
echo -e "\n\033[32mCopying base script...\033[32m\n"
sudo cp ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.sh /usr/local/bin
exit_on_fail
echo -e "\033[32mCopying compiled application...\033[32m\n"
sudo cp -R ~/Documents/CaptureCursor/CaptureCursor.app /Applications/
exit_on_fail
echo -e "\033[32mCopying new icon to Resources directory...\033[32m\n"
sudo cp ~/Documents/CaptureCursor/CaptureCursor/MacOS/CaptureCursor.icns /Applications/CaptureCursor.app/Contents/Resources/applet.icns
exit_on_fail

# 5. Cleaning up temporary files
echo -e "\n\033[32m#######################################\033[32m"
echo -e "\033[32m##### Cleaning up Temporary Files #####\033[32m"
echo -e "\033[32m#######################################\033[32m\n"

rm -rf ~/Documents/CaptureCursor

# All operations complete
echo -e "\n\033[32m####################################\033[32m"
echo -e "\033[32m##### All Operations Complete! #####\033[32m"
echo -e "\033[32m####################################\033[32m\n"

echo -e "\n\033[32mCaptureCursor is now installed. You may now close this terminal window.\033[32m"
