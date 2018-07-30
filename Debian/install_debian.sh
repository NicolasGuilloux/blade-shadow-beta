#!/bin/bash

set -e

# Install and Update Shadow Beta for Debian

# Author:   Nicolas Guilloux
# Website:  https://nicolasguilloux.eu/
# Email:    novares.x@gmail.com

# TODO: Use the bionic version
# 	A better way to integrate Qt

# ----------------------- Dependancies ----------------------- #

echo "Installing dependencies..."
sudo apt-get install libjson-c3 libsdl2-dev vainfo libgconf2-dev

# Go to the tmp folder
cd /var/tmp

if ! [ -d "/opt/Qt5.9.1" ]; then
    echo "Installing qt. This may take a while."
    wget http://download.qt.io/official_releases/qt/5.9/5.9.1/qt-opensource-linux-x64-5.9.1.run
    chmod a+x qt-opensource-linux-x64-5.9.1.run
    sudo ./qt-opensource-linux-x64-5.9.1.run

    rm qt-opensource-linux-x64-5.9.1.run
fi

mkdir debs_shadow
cd debs_shadow

if ! [ -f "/usr/bin/curl" ]; then
    wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/13787618/+files/curl_7.52.1-4ubuntu1.4_amd64.deb
fi

if ! [ -f "/usr/lib/x86_64-linux-gnu/libcurl.so.3" ]; then
    wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/13787618/+files/libcurl3_7.52.1-4ubuntu1.4_amd64.deb
fi

if ! [ -f "/lib/x86_64-linux-gnu/libssl.so.1.0.0" ]; then
    wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.0.0_1.0.2g-1ubuntu13.6_amd64.deb
fi

if ! [ -z "$(ls)" ]; then
    echo "Installing libssl, libcurl and curl if needed"
    sudo dpkg -i *.deb
fi

cd ../
rm -R debs_shadow



# ----------------------- Uninstallation ----------------------- #

if [ -d "/opt/Shadow Beta" ]; then
  files=(
  "~/.cache/blade/"
  "~/.config/blade/"
  "~/.config/Shadow Beta/"
  "/usr/share/applications/shadow-beta.desktop"
  "/usr/share/doc/shadow-beta/changelog.gz"
  "/usr/share/icons/hicolor/512x512/apps/shadow-beta.png"
  )
  echo "Shadow is already installed on /opt/Shadow Beta"
  echo  -e "\033[33;7mIt will be removed, and all settings will be lost\033[0m"
  echo "This script will remove shadow-beta (/opt/Shadow Beta) and the following folders and files : "
  printf '     %s\n' "${files[@]}"
  echo ""
  read -r -p "Do you want to continue? [Y/n] " input
  case $input in
    [nN][oO]|[nN])
      exit 1
      ;;
    *)

      echo "Removing Shadow Beta..."
      sudo apt -y remove shadow-beta
      for file in "${files[@]}"; do
        sudo rm -Rf "$file"
      done

      ;;
  esac
fi


# ----------------------- Installation ----------------------- #

echo "Download the deb file"
wget https://macosx.update.blade-group.fr/mpl/linux/beta/artful/shadowbeta.deb

echo "Install Shadow Beta"
sudo apt install ./shadowbeta.deb

rm shadowbeta.deb



# ----------------------- Other tweaks ----------------------- #

# Add user to the "input" group
if groups $USER | grep &>/dev/null '\binput\b'; then
  echo "Your user is already inside the groupe input. Everything is fine !"
else
  sudo adduser $USER input
  echo "Your user has been add to the groupe input. You may have to reboot your computer."
fi

# Check if the user uses Xorg
if [ "$XDG_SESSION_TYPE" != "x11" ]; then
  echo "Please change your session type for Xorg (x11). The current session type is $XDG_SESSION_TYPE."
fi

# Update the shortcut
echo "Changing the shortcut for the following:"
str="[Desktop Entry]
Name=Shadow Beta
Comment=Shadow launcher
Exec=bash -c \"LD_PRELOAD=/opt/Qt5.9.1/5.9.1/gcc_64/lib/libQt5Core.so:/opt/Qt5.9.1/5.9.1/gcc_64/lib/libQt5Gui.so:/opt/Qt5.9.1/5.9.1/gcc_64/lib/libQt5Xml.so:/opt/Qt5.9.1/5.9.1/gcc_64/lib/libQt5Svg.so:/opt/Qt5.9.1/5.9.1/gcc_64/lib/libQt5Widgets.so /opt/Shadow\ Beta/shadow-beta\"
Terminal=false
Type=Application
Icon=shadow-beta
Categories=Utility;"

echo "$str" | sudo tee /usr/share/applications/shadow-beta.desktop
