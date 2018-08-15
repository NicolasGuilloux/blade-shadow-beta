# Install Shadow Beta on Linux

The Shadow application by Blade (https://shadow.tech) is available in Beta for Ubuntu 17.10 and 18.04. This repository extends compatibility to additional distributions using a standalone AppImage application that embeds most dependencies and requires no installation, or using scripts to get the missing dependencies on your OS and install/update the vanilla Shadow application. Tools to check the compatibility of your system and hardware are also available separately (shadow-tools) or bundled within the AppImage.

A sexy website has been created to summarise everything on this git: https://nicolasguilloux.github.io/blade-shadow-beta/

The AppImage is confirmed to work on the following distributions, but is likely compatible with others (let us know):
 - Arch Linux
 - Debian
 - Solus (the i965 Intel driver for video hardware decoding (package libva-intel-driver in eopkg) in Solus Stable is currently not compatible, but it will be updated within days; this is only relevant if you are using your Intel GPU as your active GPU)

 Installation scripts currently support:
- Arch Linux
- Debian
- Linux Mint

Note that none of these solutions are compatible with Nvidia GPUs yet, unless hardware decoding of H.264 and/or H.265 is taken care of by your Intel GPU instead; this is a limitation of the Shadow application.

The scripts were written by the [Shadow Discord](https://discord.gg/shadowtech) community and are not affiliated with the Blade company. There is no guarantee whatsoever that the scripts will work for you. Use them at your own risk, preferably after reviewing them yourself. The AppImage should be harmless, worst case scenario is it does not work.


# VA Drivers

The Shadow application requires your machine to support hardware decoding for H.264 or H.265, it will not work with software decoding. You can check whether hardware decoding is enabled by installing `vainfo` (Ubuntu, Linux Mint, Debian) or `libva-utils` (Arch, Solus) from the software center of your distribution, and then running `vainfo` in the terminal. If "H264" or "HEVC" show up in the output, you are good to go. Otherwise, you probably need drivers for VAAPI. Several options are available based on your GPU, please use the following documentation to enable hardware decoding on your machine:

- Debian based: https://doc.ubuntu-fr.org/vaapi
- Arch Linux: https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Installing_VA-API

If your active GPU is an Intel chipset and you have no dedicated GPU, you will need the i965 Intel driver. On an APT-based distribution, install the driver with: `sudo apt install i965-va-driver`. On Solus, install it with `sudo eopkg it libva-intel-driver`.


# AppImage

**Alex^#1629** built an AppImage that should work on most recent (>2017) distributions. Please, [create an issue](https://github.com/NicolasGuilloux/blade-shadow-beta/issues/new) if it fails on your distribution. Compatibility could be further extended if Blade would compile their application for Ubuntu 16.04 LTS. It could be improved soon when the unified version will be released.

The AppImage embeds Ubuntu Bionic (18.04) libs, Qt 5.9.5 and the official Shadow Beta application. However, it requires a **working libVA** on your system and a **compatible GLIBC**.

To use the AppImage, [download the AppImage](https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage) to the folder you want, make it executable with `sudo chmod a+x shadowbeta-linux-x86_64.AppImage` and run it. It will check the compatibility of your system and hardware, and if confirmed, offer to create a menu entry by placing a .desktop file in ~/.local/share/applications/. We recommend to do so as it will then be listed in the Application Menu of your distribution.

For lazy guys, just execute these commands that will download the file in the the ~/.local/Shadow\ Beta, make it executable and run it:

```
mkdir ~/.local/share/Shadow\ Beta
cd ~/.local/share/Shadow\ Beta/
wget https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage
chmod +x shadowbeta-linux-x86_64.AppImage
./shadowbeta-linux-x86_64.AppImage
```

Extra options are available, please check `./shadowbeta-linux-x86_64.AppImage --help`.


# Scripts

The below scripts are meant to be run by your normal user, do not execute them as root. They will prompt for the root password if needed.

## Arch Linux

An AUR package is available. If it is not working after installation, please follow the tutorial or the Bash files: https://aur.archlinux.org/packages/shadow-beta

A detailed tutorial is also available: https://support.shadow.tech/hc/fr/community/posts/360012569613-Shadow-Beta-sur-Arch-Linux?flash_digest=093ef96dce0b9104156420b2389ad119e8b9f9bd

First, go to the directory where the script is located and make it executable: `cd Arch && chmod +x *`.

For the first install, launch install-arch.sh: `./install-arch.sh`.

For updates, launch only update-arch.sh: `./update-arch.sh`.


## Debian

Make the script executable: `chmod +x Debian/*`

To install or update Shadow bêta, simply launch the script and follow instructions: `Debian/install_debian.sh`.


## Linux Mint

No script is necessary for Linux Mint, but the extra package `gstreamer1.0-vaapi` is required. Install it with: `sudo apt install gstreamer1.0-vaapi` then install the vanilla Shadow Beta .deb file.


## Solus

**The Solus install script is not working yet. An updated version taking care of the extra dependencies will be available soon. Meanwhile, the AppImage works, and is the recommended solution.**

See issues in this [gist](https://gist.github.com/Kabouik/f738c03f5dbb8a363870e4eddced3e54) or this [ticket](https://dev.solus-project.com/T6736) on dev-solus.org.

Go to the folder where the script is located and make it executable: `cd Solus && chmod +x *`

Then, run the script: `./install_solus.sh`


# Thanks

Thanks to **Alex^#1629** on Discord for being available every time somebody needs to kill a bug. Thanks a lot for the wonderful AppImage!

Thanks to **raphco#0312** on Discord for being the guinea pig for Arch.

Thanks to **PofMagicfingers** for the corrections on the Arch scripts.

Thanks to **kabouik#7008** for relentlessly bothering us to add support for Solus.

You can talk to us on the [French Shadow Discord](https://discord.gg/shadowtech).
