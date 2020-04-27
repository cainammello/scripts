#!/usr/bin/env bash

# ----------------------------- VARIABLES ----------------------------- #
DOWNLOADS_DIRECTORY="$HOME/Downloads/Programs"

# PPA
declare -A PPAS_TO_ADD=(
  ["Libra TBag"]="ppa:libratbag-piper/piper-libratbag-git"
  ["Lutris"]="ppa:lutris-team/lutris"
  ["Graphics Drivers"]="ppa:graphics-drivers/ppa"
  ["Peek"]="ppa:peek-developers/stable"
  ["Android Studio"]="ppa:maarten-fonville/android-studio"
  ["VLC"]="ppa:videolan/master-daily"
  ["QBittorrent"]="ppa:qbittorrent-team/qbittorrent-stable"
  ["Win USB Installer"]="ppa:nilarimogard/webupd8"
  ["flatpak"]="ppa:alexlarsson/flatpak"
)

#URLS .deb packages
declare -A PROGRAMS_TO_DOWNLOAD=(
  ["Google Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  ["Simple Note"]="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"
  ["Zoom"]="https://zoom.us/client/latest/zoom_amd64.deb"
  ["Device Driver Manager"]="http://packages.linuxmint.com/pool/main/m/mintdrivers/mintdrivers_1.4.5_all.deb"
  ["Paper Icons Theme"]="https://snwh.org/paper/download.php?owner=snwh&ppa=ppa&pkg=paper-icon-theme,18.04"
  ["Bleachbit"]="https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1910.deb"
)

#WINE
URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"

#URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb"
#URL_INSYNC="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.0.20.40428-bionic_amd64.deb"

#SNAP Programs
SNAP_PROGRAMS_TO_INSTALL=(
  youtube-music-desktop-app insomnia wps-office-multilang
  #vlc slack --classic spotify skype --classic photogimp
)

#Apt Programs
APT_PROGRAMS_TO_INSTALL=(
  #Codecs - audio/video
  ubuntu-restricted-extras build-essential 
  #nvidia-driver-440 nvidia-prime nvidia-settings

  #Utilities #Screenshot - https://flameshot.js.org/#/
  snapd flatpak gnome-software-plugin-flatpak virtualbox deepin-screenshot flameshot peek axel qbittorrent gnome-tweaks gnome-tweak-tool lm-sensors psensor woeusb easystroke vlc qtwayland5

  #Game and libs
  steam-installer steam-devices steam:i386
  lutris libvulkan1 libvulkan1:i386 libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386
  libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

  #Dependencies for Device Driver Manager
  gir1.2-xapp-1.0 libxapp1 xapps-common

  #Setup Mouse - https://diolinux.com.br/2019/05/configure-o-seu-mouse-logitech-no-linux.html
  ratbagd piper

  #developer
  git-all nodejs python-pip python-virtualenv code code-insiders slack-desktop sublime-text
)

# ---------------------------------------------------------------------- #
