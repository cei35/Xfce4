# Xfce4

Script for automatic installation of Xfce4.

## Requirements

 - Must be __root__ or have sudo privileges
 - The script uses __pacman__ package manager

 - Use librewolf instead of firefox if __yay__ is installed

## Usage

Run the script with the target username (the user who will get Xfce4) as the first argument:

```bash
./install.sh <user>
```

## Packages

 - Uses __LightDM__ as login manager
 - Uses __plank__ as the dock
 - Uses __evince__ as pdf viewer

## Theme

GTK Theme: __Materia Dark__

Icon theme: __Papirus Dark__

Font: __JetBrainsMono Nerd Font__

### Plank

Plank is automatically installed and configured instead of xfce4-panel.

- __code-oss__
- __librewolf__ (default Web Browser, fork of Firefox)
- __libreoffice writer__
- __keepassxc__
- __mousepad__
- __thunar__
- __virtualbox__
- __xfce4-terminal__

## TODO

 - Fix the background configuration issue
 - Add support for __Wayland__

 - Consider merging with the [Hyprland Repo](https://github.com/cei35/hyprland) to clean up and centralized GUI installations.