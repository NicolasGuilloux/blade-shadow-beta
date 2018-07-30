# Outil de debuggage pour Shadow Beta Linux

Cet outil permet de diagnostiquer les problèmes qui empêchent votre Client Shadow de se lancer.

## Installation et lancement

L'outil nécessite Python3 et vainfo.

- Arch: `sudo pacman -S libva-utils`
- Debian et variantes: `sudo apt install vainfo`
- Solus: `sudo eopkg it libva-utils`

Pour lancer l'application: `python3 main.py`.
Si vous ne disposez pas de GTK, ou si l'interface ne fonctionne pas, vous pouvez visualiser un rapport dans le terminal : `python3 report.py`
