#!/usr/bin/env bash

# COLORS
# Reset
Reset=`tput sgr0`       # Text Reset
# Regular Colors
Black=`tput setaf 0`        # Black
Red=`tput setaf 1`          # Red
Green=`tput setaf 2`        # Green
Yellow=`tput setaf 3`       # Yellow
Blue=`tput setaf 4`         # Blue
Purple=`tput setaf 5`       # Purple
Cyan=`tput setaf 6`         # Cyan
White=`tput setaf 7`        # White
# Background Colors
Background_Black=`tput setab 0`
Background_Red=`tput setab 1`
Background_Green=`tput setab 2`
Background_Yellow=`tput setab 3`
Background_Blue=`tput setab 4`
Background_Purple=`tput setab 5`
Background_Cyan=`tput setab 6`
Background_White=`tput setab 7`

#Functions
show_success() {
  echo -e "${Green} $@ ${Reset}"
}

show_error() {
  echo -e "${Red} $@ ${Reset}"
}

show_header() {
  echo -e "${Background_Blue} $@ ${Reset}" 
}

show_info() {
  echo ""
  echo -e "${Cyan} $@ ${Reset}"
}

highlight_text() {
  echo -e "`tput smul`${Yellow}$@${Reset}" 
}
