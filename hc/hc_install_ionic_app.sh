#!/usr/bin/env bash
# ----------------------------- IMPORTS ----------------------------- #
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

HC_FOLDER="$HOME/Development/HeavyConnect"
TEMP_DOWNLOAD_DIRECTORY_FOLDER="$HOME/Development/HeavyConnect/temp-download"
FILE_NAME="HC-Ionic"

show_header "Installing these specific versions of Cordova, Ionic and SASS, globally dependencies ..."
show_header "Install cordova@6.5.0 globally ..."
sudo npm install -g cordova@6.5.0 --allow-root && show_success "Cordova@6.5.0 installed successful." || show_error "Failed to install Grunt-Cli."

show_header "Installing ionic@2.0.0 globally ..."
sudo npm install -g ionic@2.0.0 --allow-root && show_success "Ionic@2.0.0 installed successful." || show_error "Failed to install Bower."

show_header "Installing Sass globally ..."
sudo npm install -g sass --allow-root && show_success "Sass installed successful." || show_error "Failed to install Bower."

show_header "Installing Gulp-Cli globally ..."
sudo npm install --g gulp-cli --allow-root && show_success "Gulp-Cli installed successful." || show_error "Failed to install Gulp-Cli."

show_header "Creating Download Directory Folder ..."
mkdir -p $TEMP_DOWNLOAD_DIRECTORY_FOLDER && show_success "Directory created successful." || show_error "Failed to create directory."

show_header "Downloading HeavyConnect Ionic APP from the Google Drive ..."
wget -c --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1MFqRdR5PK_f4hh-Yd7kYGy-J60ZzNPdS' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1MFqRdR5PK_f4hh-Yd7kYGy-J60ZzNPdS" -O $TEMP_DOWNLOAD_DIRECTORY_FOLDER/$FILE_NAME.zip && rm -rf /tmp/cookies.txt && show_success "Downloaded HC APP successful." || show_error "Failed to download HC APP."

show_header "Extracting the downloaded file to HeavyConnect folder ..."
unzip $TEMP_DOWNLOAD_DIRECTORY_FOLDER/$FILE_NAME.zip -d $HC_FOLDER && show_success "Unziped HC APP to HeavyConnect directory successful." || show_error "Failed to unzip HC APP to HeavyConnect directory."

show_header "Removing MACOS folder from HC APP ..."
rm -rf $HC_FOLDER/__MACOSX && show_success "Directory removed successful." || show_error "Failed to remove directory."

show_header "Going to project folder ..."
cd $HC_FOLDER/$FILE_NAME/

show_header "Setting up git ..."
show_header "Git Init ..."
git init && show_success "Git init successful." || show_error "Git init failed."

show_header "Add Git Remote ..."
git remote add origin https://github.com/HeavyConnected/HC-Ionic.git && show_success "Remote origin added successful." || show_error "Remote origin add failed."

git remote -v

git config credential.helper store
git fetch origin && show_success "Git branches fetched successful." || show_error "Git branches fetch failed."

show_header "Git reset ..."
git reset --hard origin/developer && show_success "Git reset successful." || show_error "Git reset failed."

show_header "Changing branch to developer branch ..."
git checkout -b developer origin/developer && show_success "Changed to developer branch successful." || show_error "Changed to developer branch failed."

git pull origin developer

show_header "Go to ${FILE_NAME} folder ..."
cd $FILE_NAME 

show_header "Running npm install ..."
npm install && show_success "NPM install successful." || show_error "NPM install failed."

show_header "Installing  gulp-sass@3.0.0 ..."
npm install gulp-sass@3.0.0 && show_success "Install gulp-sass@3.0.0 successful." || show_error "Install gulp-sass@3.0.0 failed."

show_info "Would you like to delete the installation files, folders and other files used in this installation? [y,n]"
read -n 1 answer
if [[ $answer =~ ^[Yy]$ ]]; then    
    sudo rm -r $TEMP_DOWNLOAD_DIRECTORY_FOLDER && show_success "Everything deleted successful." || show_error "Error to delete some files or folders."
else
    show_info "Ok. The folders and files will be kept."
fi

show_header "Well Done!!! Everything was set up! :)"

show_header "Running project ..."

show_header "Rebuilding node-sass ..."
npm rebuild node-sass && show_success "Rebuilded node-sass successful." || show_error "Rebuild node-sass failed."

gulp || ./node_modules/.bin/gulp

show_header "Running the APP ..."
ionic serve


