#!/bin/bash

# Install Shadow Beta for Arch Linux

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/

# Dependencies for the script
#    debtap wget

# Dependencies for Shadow
#    gconf libnotify libappindicator libxtst nss libcurl-compat libva libdrm freetype2 libbsd json-c opus sdl gcc7-libs ttf-dejavu

# ----------------------- Unstallation ----------------------- #

if [ -d "/opt/Shadow Beta" ]; then
    read -r -p "Shadow is already installed. Do you want to continue? [Y/n] " input
    case $input in
        [nN][oO]|[nN])
            exit 1
            ;;
        *)

        echo "Removing Shadow Beta"
        sudo rm -R /opt/Shadow\ Beta/
        rm -R ~/.cache/blade/
        rm -R ~/.config/blade/
        rm -R ~/.config/Shadow\ Beta/
        sudo rm /usr/share/applications/shadow-beta.desktop
        sudo rm /usr/share/doc/shadow-beta/changelog.gz
        sudo rm /usr/share/icons/hicolor/512x512/apps/shadow-beta.png
        ;;
    esac
fi


# ----------------------- Installation ----------------------- #

# Install wget
if [ $(command -v wget) == /dev/null ]; then
    sudo pacman -S wget
fi

# Install debtap
if [ $(command -v debtap) == /dev/null ]; then

    if [ $(command -v yay) >/dev/null ]; then
        echo "Install debtap with Yay"
        yay debtap
        sudo debtap -u

    elif [ $(command -v yaourt) >/dev/null ]; then
        echo "Install debtap with Yaourt"
        yaourt -S debtap
        sudo debtap -u

    elif [ $(command -v packer) >/dev/null ]; then
        echo "Install debtap with Packer"
        packer -s debtap
        sudo debtap -u

    elif [ $(command -v pacaur) >/dev/null ]; then
        echo "Install debtap with Pacaur"
        pacaur -s debtap
        sudo debtap -u

    else
        echo "Can't find the AUR package manager. Aborting."
        exit 1;
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

# Download the deb file
wget https://macosx.update.blade-group.fr/mpl/linux/beta/bionic/shadowbeta.deb

# Transform the deb file. Fill the fields.
debtap shadowbeta.deb

# Install Shadow Beta
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
if [ $(echo $XDG_SESSION_TYPE) != "x11" ]; then
    echo "Please change your session type for Xorg (x11). The current session type is $XDG_SESSION_TYPE."
fi
