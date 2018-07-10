#!/bin/bash

# Install Shadow Beta for Arch Linux

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/

# Dependencies
#    gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

# ----------------------- Dependancies ----------------------- #

sudo pacman -S gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

# Correct Libjson-c
sudo ln /usr/lib/libjson-c.so /usr/lib/libjson-c.so.3

# Correct Libubsan
sudo cp /usr/lib/gcc/x86_64-pc-linux-gnu/7.3.1/libubsan.so.0 /usr/lib/

# Fix the font issue
sudo ln -s /usr/share/fonts/TTF /usr/share/fonts/truetype


# Install the new version of Shadow
./update-arch.sh

exit 0;
