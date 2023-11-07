# Debian Post-Install Script

**Supported version :** Debian 12 Bookworm

*Regarding to some news, this is like a "new OS based on Debian".*
*But the system remains a Debian, with just a brunch of adds which improves it.*

**The  bash script performs tasks to have a more modern desktop experience :**
- minimal Gnome Desktop (with printer support)
- some installed softwares (from official repositories) :
Google Chrome, Visual Studio Code, Hyper Terminal, Docker Desktop, Steam (and Proton-GE)
- add OneDrive support
- defaults installed extensions : tilling assistant, bing wallpaper, dash to dock, caffeine
- FlatPak is enabled by default (to have latest desktop utilities)

## Initial system installation
Don't create a "root" account : you must have a user with sudo rights.

Recommanded disk partitions :
- 1st has a 256MB size, and must be 'EFI' type
- 2nd takes all the free space available, and must be 'btrfs' type

Installed componants: only 'essential tools'.

## Howto Install script
1- Log into your session
2- Execute this commands :
```bash
wget https://github.com/ArmandCorbeaux/better-bookworm/raw/main/install.sh
bash ./install.sh
```
3- System reboot and GDM3 prompt

## Why this project?
I have wanted to create a script to batch all these actions that I perform manually or after with my mouse.

**It includes :**
- Fstab : tweaks for SSD or M2 storage
- Gnome : perform minimal installation to have a functionnal desktop
- Softwares : get the latest deb from official webpage and install them, or install the latest repository, fetch and install.
- Gnome-Shell-Extensions : to have a better shell experience
- Flatpak : have latest desktop softwares releases
- Tweaks perform some post-installation operation (start services, ...)
- Steam: get latest Proton-GE
- Customization : cursor, fonts and icons

## Google Chrome
Pipewire, Vulkan and Wayland flags are enabled by default

## ZRAM swap
Set to 400% of the available memory

## Icons and cursor
Icon pack : MoreWaita
Cursor : Bibata-Modern-Amber
## Installed Fonts
- Victor Mono (more for VS Code), FiraCode Nerd Fonts (more for Hyper Terminal), Noto Color Emoji

## Remaining bugs
Google Chrome : the 1st time you get the gnome desktop, you must log out. Else Google Chrome will hang at 1st launch
Docker Desktop : desktop icon has been hidden, nor it crashs docker-desktop service.
Gnome-Shell-Extension-Manager : slider is "on" but stays visually on the "off" position

## Will you add Adwaita user theme support?
It has been removed, because using custom themes breaks the light/dark theme switch of Gnome.

## What remains to improve
- Find a nice solution to periodically fetch latest releases for : Hyper Terminal,Docker-Desktop, Proton-GE, Bibata cursors, MoreWaita icon pack, FiraCode Nerd Font
**More technically :**
- Split the script into coherents parts of executed actions
