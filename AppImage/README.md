# AppImage

**Alex^#1629** built an AppImage that work on (almost) every recent (>2017) distribution. Please, if a distribution fails to launch the AppImage, create an Issue entry on this git.
It could support more if Blade would compile for Ubuntu 16.04 LTS. It could be improved soon when the unified version will be released.

The AppImage embeds Ubuntu Bionic libs, Qt 5.9.5 and official Shadow Beta version. However it requires a **working libVA** on your system and a **compatible GLIBC**.

Currently supported and tested by the AppImage:
 - Arch Linux
 - Debian
 - Solus

To install the AppImage, download the AppImage first, put it where you want, make it executable and start it. We advice to create a Menu Entry, which will make the AppImage available in the Application Menu.

For lazy guys, just execute this command that will download the file in the the .local/Shadow\ Beta folder, make it executable and start it.

```
mkdir ~/.local/share/Shadow\ Beta
cd ~/.local/share/Shadow\ Beta/
wget https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/AppImage/shadowbeta-linux-x86_64.AppImage
chmod +x shadowbeta-linux-x86_64.AppImage
./shadowbeta-linux-x86_64.AppImage
```
