#!/bin/bash

set -e

# Install Shadow Beta for Arch Linux using makepkg

# Author:   Nicolas Guilloux
# Website:  https://nicolasguilloux.eu/
# Email:    novares.x@gmail.com

# Contributors: PofMagicfingers

# Move to the AUR folder
cd AUR

# Build the package
makepkg

# Install the package
sudo pacman -U ./shadow-beta-*-x86_64.pkg.tar.xz
