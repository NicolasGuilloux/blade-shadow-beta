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

## Strace

The option `--strace` is buggued as `strace` disturbs the FUSE component of the AppImage. A workaround is to mount the AppImage dans to strace from the wrapper.

First, mount the AppImage using the following command: `./shadowbeta-linux-x86_64.AppImage --appimage-mount`. You will get a path to a folder.

From another terminal, go to this folder, and use the following command to start the strace: `strace -f  ./shadow-wrapper.pl  &> /var/tmp/strace_shadowbeta && tar -zcvf ~/strace_shadowbeta.tar.gz /var/tmp/strace_shadowbeta && rm /var/tmp/strace_shadowbeta`

Use your Shadow. When finished, close the launcher. Wait for the terminal to finish the process. When done, it should have created a archive in your user directory. This is what you should share.

You may now close the first terminal to unmount the AppImage.
