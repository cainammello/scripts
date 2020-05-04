#!/usr/bin/env bash

# ------ Imports ______
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

DIRETORIO_DOWNLOADS="$HOME/Downloads/Programs"
JAVA_NAME="jdk1.8.0_241"
mkdir $DIRETORIO_DOWNLOADS

show_header "Downloading jdk-8u241-linux-x64.tar.gz from the Google Drive ..."
#wget -c --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1LmQz1mMfgrK4w8sDT2Gu6WTQRdUTuOBX' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1LmQz1mMfgrK4w8sDT2Gu6WTQRdUTuOBX" -O jdk-8u241-linux-x64.tar.gz && rm -rf /tmp/cookies.txt && show_success "Downloaded Java successful." || show_error "Failed to download Java."

show_header "Moving the downloaded file to ${DIRETORIO_DOWNLOADS} ..."
#mv jdk-8u241-linux-x64.tar.gz $HOME/Downloads/Programs && show_success "Moved files successful." || show_error "Failed to move files."

sudo mkdir /usr/lib/jvm/ && show_success "Created jvm folder successful." || show_error "Failed to create jvm folder."

show_header "Extracting the downloaded file to /user/lib/jvm/ ..."
sudo tar xvf $DIRETORIO_DOWNLOADS/jdk-8u241-linux-x64.tar.gz --directory /usr/lib/jvm/ && show_success "Extracted successful." || show_error "Failed to create jvm folder."

show_header "Checking if the extractition was successful ..."
/usr/lib/jvm/$JAVA_NAME/bin/java -version

show_header "Setting ${JAVA_NAME} as default Java ..."
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/$JAVA_NAME/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/$JAVA_NAME/bin/javac 1

sudo update-alternatives --config java
sudo update-alternatives --config javac

update-alternatives --display java
update-alternatives --display javac

show_header "Setting Environment Variables ..."
JAVA_VARIABLES_COMMENT="#Java PATH variable"

JAVA_HOME="export JAVA_HOME=\"/usr/lib/jvm/${JAVA_NAME}\""
JAVA_JRE="export JRE_HOME=\"/usr/lib/jvm/${JAVA_NAME}/jre\""

JAVA_BIN="export PATH=/usr/lib/jvm/jdk1.8.0_241/bin:\$PATH"
JRE_BIN="export PATH=/usr/lib/jvm/jdk1.8.0_241/jre/bin:\$PATH"

#Checking if the Environment Variable alreeady exist on the file
if grep -xq "$JAVA_VARIABLES_COMMENT" ~/.bashrc; then
	show_info "PATH Variables already wrote"
else
	sudo echo "" >> ~/.bashrc
	echo $JAVA_VARIABLES_COMMENT >> ~/.bashrc
fi

if grep -xq "$JAVA_HOME" ~/.bashrc
then
    show_info "JAVA_HOME is already defined!"
else
    sudo echo $JAVA_HOME >> ~/.bashrc && show_success "JAVA_HOME wrote successful." || show_error "Failed to write JAVA_HOME."
fi

if grep -xq "$JAVA_JRE" ~/.bashrc
then
    show_info "JAVA_JRE is already defined!"
else
    sudo echo $JAVA_JRE >> ~/.bashrc && show_success "JAVA_JRE wrote successful." || show_error "Failed to write JAVA_JRE."
fi

if grep -xq "$JAVA_BIN" ~/.bashrc
then
    show_info "JAVA_BIN is already defined!"
else
    sudo echo $JAVA_BIN >> ~/.bashrc && show_success "JAVA_BIN wrote successful." || show_error "Failed to write JAVA_BIN."
fi

if grep -xq "$JRE_BIN" ~/.bashrc
then
    show_info "JRE_BIN is already defined!"
else
    sudo echo $JRE_BIN >> ~/.bashrc && show_success "JRE_BIN wrote successful." || show_error "Failed to write JRE_BIN."
fi

export PATH=/usr/lib/jvm/jdk1.8.0_241/bin:$PATH
export PATH=/usr/lib/jvm/jdk1.8.0_241/jre/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_241
export JRE_HOME=/usr/lib/jvm/${JAVA_NAME}/jre

show_header "Checking if everything was successful ..."
java -version
javac -version

show_info "Would you like to delete the installation files, folders and other files used in this installation? [y,n]"
read -n 1 answer
if [[ $answer =~ ^[Yy]$ ]]; then    
    sudo rm -r $DIRETORIO_DOWNLOADS && show_success "Everything deleted successful." || show_error "Error to delete some files or folders."
else
    show_info "Ok. The folders and files will be kept."
fi

show_header "Well Done!!! Everything was set up! :)"

show_info "Please, to use JAVA and its compiler, close and open again the terminal or just run this command:"
show_info "source ~/.bashrc"
