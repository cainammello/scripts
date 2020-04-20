#!/usr/bin/env bash

# ------ Imports ______
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

DIRETORIO_DOWNLOADS="$HOME/Downloads/Programs"
JAVA_NAME="jdk1.8.0_241"
mkdir $DIRETORIO_DOWNLOADS

show_header "Downloading jdk-8u241-linux-x64.tar.gz from the Google Drive ..."
wget -c --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1LmQz1mMfgrK4w8sDT2Gu6WTQRdUTuOBX' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1LmQz1mMfgrK4w8sDT2Gu6WTQRdUTuOBX" -O jdk-8u241-linux-x64.tar.gz && rm -rf /tmp/cookies.txt && show_success "Downloaded Java successful." || show_error "Failed to download Java."

show_header "Moving the downloaded file to ${DIRETORIO_DOWNLOADS} ..."
mv jdk-8u241-linux-x64.tar.gz $HOME/Downloads/Programs && show_success "Moved files successful." || show_error "Failed to move files."

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

show_header "Write and save these lines below at the end of the following opened file. After that close the that file."
show_info "JAVA_HOME=\"/usr/lib/jvm/${JAVA_NAME}\""
show_info "JRE_HOME=\"/usr/lib/jvm/${JAVA_NAME}/jre\""

show_header "P.S. For security reasons the command \"sudo echo \"JAVA_HOME=\"/usr/lib/jvm/$JAVA_NAME\" >> /etc/environment\" doesn´t work, ´cause the file /etc/environment has limited access permissions."

sudo gedit /etc/environment

show_header "Loading settings in environment file ..."

export JAVA_HOME=/usr/lib/jvm/${JAVA_NAME}
export JRE_HOME=/usr/lib/jvm/${JAVA_NAME}/jre

source /etc/environment
echo $JAVA_HOME

show_header "Checking if everything was successful ..."
java -version
javac -version

show_header "Well Done!!! Everything was set up! :)"