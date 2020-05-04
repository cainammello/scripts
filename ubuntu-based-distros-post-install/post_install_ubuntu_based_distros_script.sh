#!/usr/bin/env bash
# ----------------------------- IMPORTS ----------------------------- #
#Need this ${BASH_SOURCE%/*} to eferring to a file relative to executing script
source "${BASH_SOURCE%/*}/color_variables.sh"

# ------- VARIABLES INCLUDED --------- #
#DOWNLOADS_DIRECTORY
#PPAS_TO_ADD
#PROGRAMS_TO_DOWNLOAD
#URL_WINE_KEY
#URL_PPA_WINE
#SNAP_PROGRAMS_TO_INSTAL
#APT_PROGRAMS_TO_INSTALL
source "${BASH_SOURCE%/*}/variables_for_post_install_script.sh"

# ----------------------------- Start ---------------------------------- #
show_header "Removing eventual APT locks ..."
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

show_header "Creating directory do save files ..."
mkdir "$DOWNLOADS_DIRECTORY"

show_header "Adding/Setting dpkg 32 bits architecture ..."
sudo dpkg --add-architecture i386

show_header "Updating repository ..."
sudo apt update -y

show_header "Adding third-party repositories ..."
for ppa in "${!PPAS_TO_ADD[@]}"
  do
    echo "Adding $(highlight_text ${ppa}) to repositories source list ..."
    sudo add-apt-repository ${PPAS_TO_ADD[$ppa]} -y && show_success "PPA ${ppa} added successful." || show_error "Failed to add PPA ${ppa}."
    echo "--------------------------------------------------------"
done

show_header "Adding winehq key ..."
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
# ---------------------------------------------------------------------- #

show_header "Update the apt package list and install the dependencies necessary to fetch packages from https sources ...."
sudo apt install apt-transport-https ca-certificates curl make software-properties-common -y

# ------------------- VS CODE ------------------------------------------ #
show_header "Adding VS Code Repository ..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# ------------------- Sublime Text 3 ----------------------------------- #
show_header "Adding Sublime Text 3 Repository ..."
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

# ------------------- Node 12.16.1 && NPM 6.13.4 ----------------------- #
show_header "Adding Node 12.16.1 Source ..."
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# ---------------------------------------------------------------------- #

# ----------------------------- EXECUTION ----------------------------- #
show_header "Updating repository after adding the new repositories ..."
sudo apt update -y

show_header "Installing Programs from APT ..."
for app_name in ${APT_PROGRAMS_TO_INSTALL[@]}; do
  # Install only if it was not installed yet
  dpkg -s $app_name &> /dev/null 
  if [ $? -ne 0 ]
    then
      echo "Installing $(highlight_text ${app_name}) ..."
      sudo apt install ${app_name} -y && show_success "${app_name} installed successful." || show_error "Failed to install ${app_name}."
      echo "-----------------------------------------------------------------"
    else
      show_info "$app_name is already installed!"
      echo "-----------------------------------------------------------------"
  fi
done

# ------------------- Node Manager - N --------------------------------- #
# Need to install Git first
show_header "Clone and install Node Manager N ..."
git clone --depth=1 https://github.com/tj/n "$DOWNLOADS_DIRECTORY/n" && sudo make -C "$DOWNLOADS_DIRECTORY/n" install

show_header "Installing WineHQ ..."
sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

show_header "Downloading third-party softwares from wget ..."
for program in "${!PROGRAMS_TO_DOWNLOAD[@]}"
  do
    echo "Downloading $(highlight_text ${program}) ...";
    wget -c ${PROGRAMS_TO_DOWNLOAD[$program]} -P $DOWNLOADS_DIRECTORY && show_success "${program} downloaded successful." || show_error "Failed to download ${program}."
    echo "--------------------------------------------------------"
done

show_header "Installing .deb packages downloaded from the previous step ..."
sudo dpkg -i $DOWNLOADS_DIRECTORY/*.deb

show_header "Starting the detection of hardware sensors ..."
sudo sensors-detect

show_header "Adding the Flathub repository ..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y

show_header "Installing Snap packages ..."
for snap in ${SNAP_PROGRAMS_TO_INSTALL[@]}
  do
    echo "Installing $(highlight_text ${snap})..."
    sudo snap install ${snap} && show_success "Snap ${snap} installed successful." || show_error "Failed to install ${snap}."
    echo "--------------------------------------------------------"
done

# If Slack was not installed from APT, then install it from Snap.
dpkg -s slack-desktop &> /dev/null 
if [ $? -ne 0 ]
  then
    echo "Installing $(highlight_text Slack from Snap Store) ..."
    sudo snap install slack --classic
fi
# ---------------------------------------------------------------------- #

# Finalizing installation, updating and cleaning up the system.
show_header "Updating repository and distro ..."
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
flatpak update
#fix broken packages
show_header "fixing broken and remove unnecessary packages ..."
sudo apt update --fix-missing
sudo apt install -f
sudo apt --fix-broken install
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #

# ----------------------------- SET UP NVIDIA CARD DRIVER -------------- #
#prime-select query
#sudo prime-select nvidia
#prime-select query

show_info "Would you like to delete the installation files, folders and other files used in this installation? [y,n]"
read -n 1 answer
if [[ $answer =~ ^[Yy]$ ]]; then    
    sudo rm -r $DOWNLOADS_DIRECTORY packages.microsoft.gpg winehq.key && show_success "Everything deleted successful." || show_error "Error to delete some files or folders."
else
    show_info "Ok. The folders and files will be kept."
fi

show_header "Well Done!!! Everything was set up! :)"
