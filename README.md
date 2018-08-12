# Install Shadow Beta on Linux

This repository will gather a bunch of script to install and update Shadow Beta on several Linux Distributions.

Currently supported:
- Arch Linux
- Debian
- Linux Mint

These scripts are designed by Shadow Discord community and have no link with Blade company.
Moreover, there is no guarantee that the scripts will work for you.

As you will install programs, you will need the root rights with the "sudo" command. Please install it before running these scripts.
Moreover, don't start the scripts as root. Use you current user account.


# AppImage

Alex is currently building an AppImage that will work on (almost) every distribution. The wrapper will be integrated to detect errors and propose fixes.


# Arch Linux

An AUR package is available. If it's not working after installation, please follow the tutorial or the Bash files. https://aur.archlinux.org/packages/shadow-beta

A detailed tutorial is available : https://support.shadow.tech/hc/fr/community/posts/360012569613-Shadow-Beta-sur-Arch-Linux?flash_digest=093ef96dce0b9104156420b2389ad119e8b9f9bd

First, go in the directory and make script executable: `cd Arch && chmod +x *`.

For the first install, launch install-arch.sh script: `./install-arch.sh`.

For the next update, launch only update-arch.sh script: `./update-arch.sh`.


# Debian

First, make the script executable: `chmod +x Debian/*`

To install or update Shadow bêta, simply launch the script and follow it: `Debian/install_debian.sh`.


# Linux Mint

Linux Mint needs the extra package `gstreamer1.0-vaapi`. Execute the command: `sudo apt install gstreamer1.0-vaapi`


# Solus

**The Solus installation isn't working right now. We're still working on it.**

A Gist has been open by kabouik: https://gist.github.com/Kabouik/f738c03f5dbb8a363870e4eddced3e54

To install Shadow beta, go in the Solus folder and make the script executable: `cd Solus && chmod +x *`

Then, launch the script: `./install_solus.sh`


# VA Drivers

Keep in mind that you will probably need drivers for VAAPI to make your graphics card well detected. Several options are available based on your GPU.

Please, use the documentation given by your distribution:

- Debian based: https://doc.ubuntu-fr.org/vaapi
- Arch Linux: https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Installing_VA-API

If a i965 driver is needed on Debian based, install the driver by executing the following command: `sudo apt install i965-va-driver`


# Thanks

Thanks to Alex^#1629 on Discord for being available everytime somebody needs to kill some bugs.

Thanks to raphco#0312 on Discord for being the guinea pig for Arch.

Thanks to PofMagicfingers for the corrections on the Arch scripts.

Thanks to kabouik#7008 for helping me on Solus.
