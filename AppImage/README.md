# AppImage

**Alex^#1629** built an AppImage that should work on most recent (>2017) distributions. Please, [create an issue](https://github.com/NicolasGuilloux/blade-shadow-beta/issues/new) if it fails on your distribution. Compatibility could be further extended if Blade would compile their application for Ubuntu 16.04 LTS. It could be improved soon when the unified version will be released.

The AppImage embeds Ubuntu Bionic (18.04) libs, Qt 5.9.5 and the official Shadow Beta application. However, it requires a **working libVA** on your system and a **compatible GLIBC**.

To use the AppImage, [download the AppImage](https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage) to the folder you want, make it executable with `sudo chmod a+x shadowbeta-linux-x86_64.AppImage` and run it. It will check the compatibility of your system and hardware, and if confirmed, offer to create a menu entry by placing a .desktop file in ~/.local/share/applications/. We recommend to do so as it will then be listed in the Application Menu of your distribution.

For lazy guys, just execute these commands that will download the file in the the ~/.local/shadowbeta, make it executable and run it:

```
mkdir ~/.local/share/Shadowbeta
cd ~/.local/share/Shadowbeta/
wget https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage
chmod +x shadowbeta-linux-x86_64.AppImage
./shadowbeta-linux-x86_64.AppImage
```

Extra options are available, please check `./shadowbeta-linux-x86_64.AppImage --help`.
