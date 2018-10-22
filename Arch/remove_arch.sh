#!/bin/bash

# Author:   Nicolas Guilloux
# Website:  https://nicolasguilloux.eu/
# Email:    novares.x@gmail.com

if [ -d "/opt/shadowbeta" ]; then
  files=(
  "/opt/shadowbeta/"
  "~/.cache/blade/"
  "~/.config/blade/"
  "~/.config/shadowbeta/"
  "/usr/share/applications/shadow-beta.desktop"
  "/usr/share/doc/shadow-beta/changelog.gz"
  "/usr/share/icons/hicolor/512x512/apps/shadow-beta.png"
  )
  echo "Shadow is already installed on /opt/shadowbeta"
  echo  -e "\033[33;7mIt will be removed, and all settings will be lost\033[0m"
  echo "This script will remove the following folders and files : "
  printf '     %s\n' "${files[@]}"
  echo ""
  read -r -p "Do you want to continue? [Y/n] " input
  case $input in
    [nN][oO]|[nN])
      exit 1
      ;;
    *)

      echo "Removing Shadow Beta..."
      for file in "${files[@]}"; do
        sudo rm -Rf "$file"
      done

      ;;
  esac
fi


exit 0;
