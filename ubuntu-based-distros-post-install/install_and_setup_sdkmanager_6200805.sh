#!/usr/bin/env bash

# ------ Imports ______
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing 
source "${BASH_SOURCE%/*}/color_variables.sh"

DIRETORIO_DOWNLOADS="$HOME/Downloads/Programs"
ANDROID_SDK_DIR="/usr/lib/android-sdk/cmdline-tools"
ANDROID_SDK_FILE_NAME="android_sdk_6200805"

mkdir $DIRETORIO_DOWNLOADS && show_success "Directory created successful." || show_error "Failed to create directory."

show_header "Downloading android_sdk_6200805.zip from the Google Drive ..."
wget -c --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1S-JeFcMeo205J4iYGwjd1jnO_248ukK7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1S-JeFcMeo205J4iYGwjd1jnO_248ukK7" -O $DIRETORIO_DOWNLOADS/$ANDROID_SDK_FILE_NAME.zip && rm -rf /tmp/cookies.txt
#From google developer repository
#wget -c https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip -O $DIRETORIO_DOWNLOADS/$ANDROID_SDK_FILE_NAME.zip

sudo mkdir -p $ANDROID_SDK_DIR && show_success "Directory created successful." || show_error "Failed to create directory."

show_header "Extracting the downloaded file to $ANDROID_SDK_DIR ..."
sudo unzip $DIRETORIO_DOWNLOADS/$ANDROID_SDK_FILE_NAME.zip -d $ANDROID_SDK_DIR/ && show_success "Unziped to SDK Directory successful." || show_error "Failed to unzip to SDK Directory."

show_header "Giving the necessary permissions to Android SDK folder ..."
sudo chmod -R 777 /usr/lib/android-sdk/ && show_success "Gave necessary permissions successful." || show_error "Failed to give necessary permissions."

export ANDROID_SDK_ROOT=/usr/lib/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$PATH

show_header "Installing Platforms Tools, Android-28 Compiler and Build Tools ..."
sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" && show_success "SDK packages installed successful." || show_error "Failed to install SDK packages."

show_header "Accepting licenses ..."
sdkmanager --licenses

show_header "Updating Android SDK ..."
sdkmanager --update
sdkmanager --install

export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH

show_header "Show Sdkmanager and ADB versions..."
sdkmanager --version
adb --version

show_header "Setting Environment Variable ..."
ANDROID_VARIABLES_COMMENT="#Android PATH variable"

ANDROID_SDK_ROOT="export ANDROID_SDK_ROOT=/usr/lib/android-sdk"
ANDROID_HOME="export ANDROID_HOME=/usr/lib/android-sdk"
ANDROID_PATH="export PATH=/usr/lib/android-sdk:\$PATH"
PATH_ANDROID_BIN="export PATH=\$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:\$PATH"
PARH_ANDROID_TOOLS="export PATH=\$ANDROID_SDK_ROOT/platform-tools:\$PATH"

#Checking if the Environment Variable alreeady exist on the file
if grep -xq "$ANDROID_VARIABLES_COMMENT" ~/.bashrc; then
	show_info "PATH Variables already wrote"
else
	sudo echo "" >> ~/.bashrc
	sudo echo $ANDROID_VARIABLES_COMMENT >> ~/.bashrc
fi

if grep -xq "$ANDROID_SDK_ROOT" ~/.bashrc
then
    show_info "Android SDK Root is already defined!"
else
    sudo echo $ANDROID_SDK_ROOT >> ~/.bashrc && show_success "ANDROID_SDK_ROOT wrote successful." || show_error "Failed to write ANDROID_SDK_ROOT."
fi

if grep -xq "$ANDROID_HOME" ~/.bashrc
then
    show_info "Android ANDROID_HOME is already defined!"
else
    sudo echo $ANDROID_HOME >> ~/.bashrc && show_success "ANDROID_HOME wrote successful." || show_error "Failed to write ANDROID_HOME."
fi

if grep -xq "$ANDROID_PATH" ~/.bashrc
then
    show_info "Android ANDROID_PATH is already defined!"
else
    sudo echo $ANDROID_PATH >> ~/.bashrc && show_success "ANDROID_PATH wrote successful." || show_error "Failed to write ANDROID_PATH."
fi

if grep -xq "$PATH_ANDROID_BIN" ~/.bashrc
then
    show_info "Path to Android/bin is already defined!"
else
    sudo echo $PATH_ANDROID_BIN >> ~/.bashrc && show_success "PATH_ANDROID_BIN wrote successful." || show_error "Failed to write PATH_ANDROID_BIN."
fi

if grep -xq "$PARH_ANDROID_TOOLS" ~/.bashrc
then
    show_info "Path to Android/tools is already defined!"
else
    sudo echo $PARH_ANDROID_TOOLS >> ~/.bashrc && show_success "PARH_ANDROID_TOOLS wrote successful." || show_error "Failed to write PARH_ANDROID_TOOLS."
fi

show_header "Making sure that CURL is installed ..."
sudo apt install curl -y 
show_header "Install SDKMAN ..."
show_info "SDKMAN! is a tool for managing parallel versions of multiple Software Development Kits on most Unix based systems. It provides a convenient Command Line Interface (CLI) and API for installing, switching, removing and listing Candidates. Formerly known as GVM the Groovy enVironment Manager, it was inspired by the very useful RVM and rbenv tools, used at large by the Ruby community. https://sdkman.io/"
curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh" && show_success "SDKMAN installed successful." || show_error "Failed to install SDKMAN."

show_header "Checking SDKMAN version ..."
sdk version

show_header "Installing Gradle 6.3"
sdk install gradle 6.3 && show_success "Gradle 6.3 installed successful." || show_error "Failed to install Gradle 6.3."

show_info "Would you like to delete the installation files, folders and other files used in this installation? [y,n]"
read -n 1 answer
if [[ $answer =~ ^[Yy]$ ]]; then    
    sudo rm -r $DIRETORIO_DOWNLOADS && show_success "Everything deleted successful." || show_error "Error to delete some files or folders."
else
    show_info "Ok. The folders and files will be kept."
fi

show_header "Well Done!!! Everything was set up! :)"

show_info "Please, to use the sdkmanager and android-tools, close and open again the terminal or just run this command:"
show_info "source ~/.bashrc"