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

show_header "Installing Platforms Tools annd Android-28 Compiler..."
sdkmanager "platform-tools" "platforms;android-28" && show_success "SDK packages installed successful." || show_error "Failed to install SDK packages."

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
ANDROID_SDK_ROOT="export ANDROID_SDK_ROOT=/usr/lib/android-sdk"
PATH_ANDROID_BIN="export PATH=\$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:\$PATH"
PARH_ANDROID_TOOLS="export PATH=\$ANDROID_SDK_ROOT/platform-tools:\$PATH"

#Checking if the Environment Variable alreeady exist on the file
if grep -xq "$ANDROID_SDK_ROOT" ~/.bashrc
then
    show_info "Android SDK Root is already defined!"
else
    sudo echo $ANDROID_SDK_ROOT >> ~/.bashrc && show_success "ANDROID_SDK_ROOT wrote successful." || show_error "Failed to write ANDROID_SDK_ROOT."
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

#loading configs from bashrc
source ~/.bashrc

show_header "Well Done!!! Everything was set up! :)"

show_info "Please, to use the sdkmanager and android-tools, close and open again the terminal or just run this command:"
show_info "source ~/.bashrc"