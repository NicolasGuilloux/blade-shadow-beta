#!/bin/bash

set -e

# Install Shadow Beta for Arch Linux

# Author:   Nicolas Guilloux
# Website:  https://nicolasguilloux.eu/
# Email:    novares.x@gmail.com

# Contributors: PofMagicfingers

# Dependencies
#    gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

# ----------------------- Dependancies ----------------------- #

echo "Installing dependencies..."
sudo pacman --needed -S gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

echo "Correct Libjson-c"
sudo ln -f /usr/lib/libjson-c.so /usr/lib/libjson-c.so.3

echo "Correct Libubsan"
sudo cp /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.1/libubsan.so.0 /usr/lib/

echo "Fix the font issue"
sudo ln -sf /usr/share/fonts/TTF /usr/share/fonts/truetype

echo "Install the new version of Shadow"
exec ./update_arch.sh
