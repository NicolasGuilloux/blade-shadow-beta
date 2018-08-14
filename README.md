# Install Shadow Beta on Linux

This repository will gather a bunch of script to install and update Shadow Beta on several Linux Distributions. It also hosts a AppImage for more compatibility.

Currently supported by the scripts:
- Arch Linux
- Debian
- Linux Mint

Currently supported and tested by the AppImage:
 - Arch Linux
 - Debian
 - Solus

These scripts are designed by Shadow Discord community and have no link with Blade company.
Moreover, there is no guarantee that the scripts will work for you.

As you will install programs, you will need the root rights with the "sudo" command. Please install it before running these scripts.
Moreover, don't start the scripts as root. Use you current user account.


# AppImage

Alex built an AppImage that work on (almost) every recent (>2017) distribution. Please, if a distribution fails to launch the AppImage, create an Issue entry on this git.
It could support more if Blade would compile for Ubuntu 16.04 LTS. It could be improved soon when the unified version will be released.

The AppImage embeds Ubuntu Bionic libs, Qt 5.9.5 and official Shadow Beta version. However it requires a **working libVA** on your system and a **compatible GLIBC**.

To install the AppImage, download the AppImage first, put it where you want, make it executable and start it. We advice to create a Menu Entry, which will make the AppImage available in the Application Menu.

For lazy guys, just execute this command that will download the file in the the .local/Shadow\ Beta folder, make it executable and start it.

```
mkdir ~/.local/share/Shadow\ Beta
cd ~/.local/share/Shadow\ Beta/
wget https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage
chmod +x shadowbeta-linux-x86_64.AppImage
./shadowbeta-linux-x86_64.AppImage
```


# Scripts

## Arch Linux

An AUR package is available. If it's not working after installation, please follow the tutorial or the Bash files. https://aur.archlinux.org/packages/shadow-beta

A detailed tutorial is available : https://support.shadow.tech/hc/fr/community/posts/360012569613-Shadow-Beta-sur-Arch-Linux?flash_digest=093ef96dce0b9104156420b2389ad119e8b9f9bd

First, go in the directory and make script executable: `cd Arch && chmod +x *`.

For the first install, launch install-arch.sh script: `./install-arch.sh`.

For the next update, launch only update-arch.sh script: `./update-arch.sh`.


## Debian

First, make the script executable: `chmod +x Debian/*`

To install or update Shadow bêta, simply launch the script and follow it: `Debian/install_debian.sh`.


## Linux Mint

Linux Mint needs the extra package `gstreamer1.0-vaapi`. Execute the command: `sudo apt install gstreamer1.0-vaapi`


## Solus

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

Thanks to **Alex^#1629** on Discord for being available everytime somebody needs to kill some bugs. Thanks a lot for the wonderful AppImage !

Thanks to **raphco#0312** on Discord for being the guinea pig for Arch.

Thanks to **PofMagicfingers** for the corrections on the Arch scripts.

Thanks to **kabouik#7008** for helping us on Solus and killing some Solus bugs.
