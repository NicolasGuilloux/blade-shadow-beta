# Install Shadow Beta on Linux

This repository will gather a bunch of script to install and update Shadow Beta on several Linux Distributions.

Currently supported:
- Arch Linux
- Debian

These scripts are designed by Shadow Discord community and have no link with Blade company.
Moreover, there is no guarantee that the scripts will work for you.

As you will install programs, you will need the root rights with the "sudo" command. Please install it before running these scripts.
Moreover, don't start the scripts as root. Use you current user account.


# Arch Linux

A detailed tutorial is available : https://support.shadow.tech/hc/fr/community/posts/360012569613-Shadow-Beta-sur-Arch-Linux?flash_digest=093ef96dce0b9104156420b2389ad119e8b9f9bd

First, go in the directory and make script executable: `cd Arch && chmod +x *`.

For the first install, launch install-arch.sh script: `./install-arch.sh`.

For the next update, launch only update-arch.sh script: `./update-arch.sh`.


# Debian

First, make the script executable: `chmod +x Debian/*`

To install or update Shadow bêta, simply launch the script and follow it: `Debian/install_debian.sh`.


# Thanks

Thanks to Alex^#1629 on Discord for being available everytime somebody needs to kill some bugs.

Thanks to raphco#0312 on Discord for being the guinea pig for Arch.

Thanks to PofMagicfingers for the corrections on the Arch scripts.
