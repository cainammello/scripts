#!/usr/bin/env bash
# ----------------------------- IMPORTS ----------------------------- #
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

DASHBOARD_DIRECTORY="$HOME/Development/HeavyConnect/dashboard"

mkdir -p $DASHBOARD_DIRECTORY

show_header "Cloning the project from GitHub ..."
git clone https://github.com/HeavyConnected/dashboard.git $DASHBOARD_DIRECTORY && show_success "Project cloned successful." || show_error "Failed to clone project."
    
show_header "Installing dependencies ..."
show_header "Install grunt-cli globally ..."
sudo npm install -g grunt-cli --allow-root && show_success "Grunt-Cli installed successful." || show_error "Failed to install Grunt-Cli."

show_header "Installing bower globally ..."
sudo npm install -g bower --allow-root && show_success "Bower installed successful." || show_error "Failed to install Bower."

show_header "Going to project folder ..."
cd $DASHBOARD_DIRECTORY

show_header "Checkouting into 'developer' branch ..."
git checkout developer
git config credential.helper store
git pull origin developer

show_header "Installing grunt locally ..."
npm install grunt && show_success "Grunt installed successful." || show_error "Failed to install Grunt."

show_header "Installing project dependencies ..." 
npm install && show_success "Dependencies installed successful." || show_error "Failed to installed dependencies." 

show_header "Installing Protractor for Automated Tests ..."
sudo npm install -g protractor --allow-root
sudo webdriver-manager update

show_header "Well Done!!! Everything was set up! :)"

show_header "Running project ..."
npm start

