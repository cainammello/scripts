#!/usr/bin/env bash
# ----------------------------- IMPORTS ----------------------------- #
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

API_DIRECTORY="$HOME/Development/HeavyConnect/HC-Api"

show_header "Creating HeavyConnect folder directory ..."
mkdir -p $HC_DIRECTORY

show_header "Cloning the project from GitHub ..."
git clone https://github.com/HeavyConnected/HC-Api.git $API_DIRECTORY && show_success "Project cloned successful." || show_error "Failed to clone project."

show_header "Installing dependencies ..."
sudo apt update -y

show_header "Installing Python VirtualEnv"
sudo apt install python-virtualenv -y && show_success "Python VirtualEnv installed successful." || show_error "Failed to install Python VirtualEnv."

show_header "Installing Python 3 PIP"
sudo apt install python3-pip -y && show_success "Python 3 PIP installed successful." || show_error "Failed to install Python 3 PIP."

show_header "Going to project folder ..."
cd $API_DIRECTORY && show_success "Now at ${API_DIRECTORY}." || show_error "Failed to go to directory project."

show_header "Checkouting into 'developer' branch ..."
git checkout developer
git config credential.helper store
git pull origin developer

show_header "Start virtualenv with Python 3.6 ..."
virtualenv -p python3 env3 && show_success "VirtualEnv created successful." || show_error "Failed to create VirtualEnv."

show_header "Activating the created environment ..."
source ./env3/bin/activate && show_success "VirtualEnv activated successful." || show_error "Failed to activate VirtualEnv."

show_header "Installing Project Dependencies ..."
pip install -r requirements.txt && show_success "Project dependencies installed successful." || show_error "Failed to install project dependencies."

show_info "Do you wanna install NGINX to redirecting the Dashboard to your local API? [y,n]"
read -n 1 answer
if [[ $answer =~ ^[Yy]$ ]]; then    
	show_header "Install NGINX ...."
	sudo apt install nginx -y && show_success "NGINX installed successful." || show_error "Failed to install NGINX."

	show_header "Adding the st-client andress host to System Host File ..."
	echo "127.0.0.1   st-client.heavyconnect.com" | sudo tee -a /etc/hosts && show_success "st-client andress added successful." || show_error "Failed to add st-client andress."

	ST_CLIENT_NGINX_CONFIG="###################################
							# Starting block for: st-client
							###################################

							server {
							    listen               80; 
							    server_name st-client.heavyconnect.com;
							    location / {
							        proxy_pass  http://st-client.heavyconnect.com:8000;
							    }
							}
							server {
							    listen               443;
							    ssl                  on;
							    ssl_certificate      /etc/ssl/certs/nginx-selfsigned.crt;
							    ssl_certificate_key  /etc/ssl/private/nginx-selfsigned.key;
							    keepalive_timeout    70;
							    server_name st-client.heavyconnect.com;
							    location / {
							        proxy_pass  http://st-client.heavyconnect.com:8000;
							    }

							###################################
							# Ending block for: st-client
							###################################"

	show_header "Adding st-client confi to NGINX default server file ..."
	echo $ST_CLIENT_NGINX_CONFIG | sudo tee -a /etc/nginx/sites-available/default && show_success "st-client config added successful." || show_error "Failed to add st-client config."

	show_header "Restarting NGINX server ..."
	sudo service nginx restart && show_header "NGINX installed and set up successful. NGINX Server is running ..." || show_error "Error to install and to run NGINX server."
else
    show_info "Ok."
fi

show_header "Well Done!!! Everything was set up! :)"

show_header "Running the API ..."
./run_api.py DEVELOPMENT
