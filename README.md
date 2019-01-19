# Why this?

The Shadow cloud-computing application by Blade (https://shadow.tech) is available in Beta for Ubuntu 18.04. This repository extends compatibility to additional distributions using a standalone AppImage application that embeds most dependencies and requires no installation. Tools to check the compatibility of your system and hardware are also available separately (shadow-tools) or bundled within the AppImage.

A sexy website is in the works to summarize everything on this git: https://nicolasguilloux.github.io/blade-shadow-beta/

Check out our side-projects Discord: https://discord.gg/9HwHnHq

# How to use

The AppImage is confirmed to work on the following distributions, but is likely compatible with others (let us know).

|  Work on      |  Do not work on  |
|      :-:      |        :-:       |
| Ubuntu 18.04  | Ubuntu 16.04     |
| Linux Mint 19 | Linux Mint 18    |
| Debian 10+    | Debian 9         |
| Arch Linux    | GalliumOS 2.2    |
| Solus Budgie  |                  |
| Fedora 28     |                  |
| GalliumOS 3.0 |                  |

The scripts were written by the [Shadow Discord](https://discord.gg/shadowtech) community and are not affiliated with the Blade company. There is no guarantee whatsoever that the scripts will work for you. Use them at your own risk, preferably after reviewing them yourself. The AppImage should be harmless, worst case scenario is it does not work.

An additional folder is also present in the repository to support the [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository) installation. This initiative is led and maintained by **agentcobra#6142**. The folder is there to support him.

## VA Drivers

The Shadow application requires your machine to support hardware decoding for H.264 or H.265, it will not work with software decoding. You can check whether hardware decoding is enabled by installing `vainfo` (Ubuntu, Linux Mint, Debian) or `libva-utils` (Arch, Solus) from the repository of your distribution, and then running `vainfo` in the terminal. If "H264" or "HEVC" show up in the output, you are good to go. Otherwise, you probably need drivers for VAAPI, or your hardware is outdated. Several options are available based on your GPU, please use the following documentation to enable hardware decoding on your machine:

- Debian based: https://doc.ubuntu-fr.org/vaapi
- Arch Linux: https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Installing_VA-API

#### For most cases:

If your active GPU is an Intel chipset and you have no dedicated GPU, you will need the i965 Intel driver.
- Ubuntu: `sudo apt install i965-va-driver`
- Arch Linx: `sudo pacman -S libva-intel-driver`
- Solus: `sudo eopkg it libva-intel-driver`

For NVIDIA users, you have 2 options:
- Use the Nouveau driver and install the old NVIDIA firmware that provides support for the VA API.
- Use the Arekinath patch to provides VA API compatibility for recent NVIDIA cards.

In both cases, we strongly recommend you to follow this link: https://gitlab.com/aar642/shadowos-boot#support

## AppImage

**Alex^#1629** built an AppImage that should work on most recent (>2017) distributions. Please, [create an issue](https://github.com/NicolasGuilloux/blade-shadow-beta/issues/new) if it fails on your distribution. Compatibility could be further extended if Blade would compile their application for Ubuntu 16.04 LTS. It could be improved soon when the unified version will be released.

The AppImage embeds Ubuntu Bionic (18.04) libs and the official Shadow Beta application. However, it requires a **working libVA** on your system and a **compatible GLIBC**.

To use the AppImage, [download the AppImage](https://nicolasguilloux.github.io/blade-shadow-beta/#appimage) to the folder you want, make it executable with `chmod a+x shadowbeta-linux-x86_64.AppImage` and run it. It will check the compatibility of your system and hardware, and if confirmed, offer to create a menu entry by placing a .desktop file in `~/.local/share/applications/`. We recommend to do so as it will then be listed in the Application Menu of your distribution.

Extra options are available, please check `./shadowbeta-linux-x86_64.AppImage --help`.


# Acknowledgments

Thanks to **Alex^#1629** on Discord for being available every time somebody needs to kill a bug. Thanks a lot for the wonderful AppImage!

Thanks to **agentcobra#6142** on Discord for maintaining the AUR package and review my code. Many mistakes were corrected by you.

Thanks to **0x4cc3a96f#4425** for "mastering" Linux. We greatly appreciate all you help and efforts to make the Linux app better and better.

Thanks to **raphco#0312** on Discord for being the guinea pig for Arch.

Thanks to **PofMagicfingers** for the corrections on the Arch scripts.

Thanks to **kabouik#7008** for relentlessly bothering us to add support for Solus.

Thanks to **TheWolf#0985** and **Brother/Ilya#0013** for their help with the german translations.

You can talk to us on the [French Shadow Discord](https://discord.gg/shadowtech). We are also available on all other Discord but please, speak English so we can understand you ;)


# Miscalleneous


### Community projects

- [Shadow Live OS](https://gitlab.com/NicolasGuilloux/shadow-live-os): A live Linux that start Shadow and all needed components, ready out of the box !
- [ShadowOS Networked boot](https://gitlab.com/aar642/shadowos-boot): A small ISO (~1Mo) that use iPXE to boot the Shadow Live OS using network.
- [Shadow Kodi Addon](https://gitlab.com/NicolasGuilloux/shadow-kodi-addon/tree/master): A Kodi addon to start Kodi from the Kodi interface.
- [Shadow Gaming](https://discord.gg/5yhkeV5): A discord to share the configuration of the game and discuss about benchmark.

### Support

If you want to support me, rather than make donations, I prefer to use the referral program for Shadow. My code is `NICNC9DP`. You can also use the following link:  https://shop.shadow.tech/invite/NICNC9DP
