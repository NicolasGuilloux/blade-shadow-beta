#!/bin/bash

set -e

# Install Shadow Beta for Arch Linux

# Author:   Nicolas Guilloux
# Website:  https://nicolasguilloux.eu/
# Email:    novares.x@gmail.com

# Contributors: PofMagicfingers

# Dependencies for the script
#    debtap wget

# Dependencies for Shadow
#    gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

# ----------------------- Uninstallation ----------------------- #

if [ -d "/opt/Shadow Beta" ]; then
  files=(
  "/opt/Shadow Beta/"
  "~/.cache/blade/"
  "~/.config/blade/"
  "~/.config/Shadow Beta/"
  "/usr/share/applications/shadow-beta.desktop"
  "/usr/share/doc/shadow-beta/changelog.gz"
  "/usr/share/icons/hicolor/512x512/apps/shadow-beta.png"
  )
  echo "Shadow is already installed on /opt/Shadow Beta"
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


# ----------------------- Installation ----------------------- #

echo "Install curl"
if ! [ -x "$(command -v curl)" ]; then
  sudo pacman --needed -S curl || echo "Failed to install curl." && exit -1
fi

echo "Install debtap"
if ! [ -x "$(command -v debtap)" ]; then

  if [ -x "$(command -v yay)" ]; then
    echo "Install debtap with Yay"
    yay debtap
    sudo debtap -u || echo "Failed!" && exit 1

  elif [ -x "$(command -v yaourt)" ]; then
    echo "Install debtap with Yaourt"
    yaourt -S debtap
    sudo debtap -u || echo "Failed!" && exit 2

  elif [ -x "$(command -v packer)" ]; then
    echo "Install debtap with Packer"
    packer -s debtap
    sudo debtap -u || echo "Failed!" && exit 3

  elif [ -x "$(command -v pacaur)" ]; then
    echo "Install debtap with Pacaur"
    pacaur -s debtap
    sudo debtap -u || echo "Failed!" && exit 4
  else
    echo "Can't find the AUR package manager. Aborting."
    exit 5;
  fi

else
  # Update debtap
  read -r -p "Update debtap? [Y/n] " input
  case $input in
    [nN][oO]|[nN])
      ;;
    *)

      sudo debtap -u
  esac
fi



# Go to temp folder
cd /var/tmp

echo "Download the deb file"
curl -L -O https://macosx.update.blade-group.fr/mpl/linux/beta/bionic/shadowbeta.deb

echo "Transform the deb file."
debtap -Q shadowbeta.deb

echo "Install Shadow Beta"
sudo pacman -U shadow-beta*.pkg.tar.xz

# Remove the temp files
rm shadowbeta.deb
rm shadow-beta*.pkg.tar.xz



# ----------------------- Other tweaks ----------------------- #

# Add user to the "input" group
if groups $USER | grep &>/dev/null '\binput\b'; then
  echo "Your user is already inside the groupe input. Everything is fine !"
else
  sudo gpasswd -a $USER input
  echo "Your user has been add to the groupe input. You may have to reboot your computer."
fi

# Check if the user uses Xorg
if [ "$XDG_SESSION_TYPE" != "x11" ]; then
  echo "Please change your session type for Xorg (x11). The current session type is $XDG_SESSION_TYPE."
fi
