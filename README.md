# Debian Post-Install Script

**Supported version :** Debian 12 Bookworm

The purpose is to provide a bash script which performs the various actions and optimizations after a minimal debian installation to provide an operating system.

## My objective :
- Create a script to batch all these actions that actually I perform manually
In a first time :
- Fstab : add options on the right UUID for the btrfs partition
- Gnome : perform minimal installation to have a functionnal desktop
- Source repository : add contrib, non-free, and backports (for the kernel)
- Software installation : get the latest deb from official webpage and install them, or install the latest repository, fetch and install.
- PErform some post-installation operation : service launch and icon hide (sorry, but docker-desktop has a bug when you launch it from the shortcut when it's started)
- Install gnome-shell-extension-(...) to have a better shell experience
- Flatpak : add repository, update the list and install applications
- Customization : get files and install them
- Steam: get latest proton-ge and install it in the right place
 
## My expained choices :

*And what kind of benefits I see with them :*

**Gnome desktop :**
- Simple, configurable and productive environment
- I have always like their guidelines since the beginning of the project
- I want to install **only the needed packages for a minimal but fully functionnal desktop environment**.

**Limited UI customization :**
- **No themes :** it breaks the libadwaita light/dark desktop features
- **Cursors :** I like to have something "modern" and "usable", which provides a specific and modern identity for my desktop. Bibata cursors have this meaning in my opinion.
- **Icons :** I want to **stay in the Adwaita style**, but expand it. And also **be able to perform some customizations of the folders**, to identify through the color where is my folder and what does it contain. That's why I choose MoreWaita and get some folders icons from Adwaita++.
- I like to have a **wallpaper which changes automatically everyday** and make me discover some nice places of the world. Bing wallpapers provide me this option.

**Use btrfs rather than ext4 :**
- **Snapshots** of the system can be perform if needed.
- It performs **automatic data compression**. Zstd seems to be the best choice between CPU use and compression ratio.
- There's **optimizations** for rewritable electronic chip storage systems with lilmited life time (SSD,M2, ...) *[ even if with calculations, progress have been perform since the beginning of the technology, and now they can be used more than 10 years... ]*

**Use ZramSwap rather than swap partition :**
- Zram creates a **swap space in memory**. And RAM has has quicker access than drive.
- It performs **automatic data compression**. Zstd seems to be the best choice between CPU use and compression ratio.
- In some point of view, ZRAM can be see as a process to perform RAM compression. And **virtually "expand" the available memory size** of the targetted computer.
- I know that if I need some extra swap space which use the drive, I can use dphys-swapfile.

**Use flatpak for some kind of applications rather than debian packages :**
- Flatpak can be used by all kinds of desktop applications, and aims to be **as agnostic as possible** regarding how applications are built. There are **no requirements** regarding which programming languages, build tools, toolkits or frameworks can be used.
- Desktop applications are **sandboxed**.
- Having the **latest versions** of the installed applications.
- **Expand the application store**.

**Add some sources repositories for applications from major companies :**
- Google Chrome, Microsoft Visual Studio Code, and Docker
- They are **widely used** and **well supported**.
- They are **in some way an "industry standard"**.
- Repositories provide **sometimes supported more up-to-date packages for the OS**.
- I don't think that "everything is bad in the world".

**Have some specific fonts :**
- I like the **"ligature support" feature**.
- I need to **easily read linesand words** 
- "Victor Mono" is actually my favorite font to code.
- "FiraCode Nerd Font" is actually my favorite font for my terminal.
- "Noto Color Emoji" is installed, as sometimes emoji are needed in CLI.

**Have a "modern terminal" :**
- Font ligature support
- Easy to use and configure
- Better if it's lighweight
- Functionnality can be extended if needed
- After looking after a terminal with these features, I have choosen Hyper Terminal.

**Have OneDrive support and use it to backup datas:**
- If you have a "Microsoft 365" account, I think that it's nice to be able to use the allowed space on OneDrive.
- Onedrive client on Linux has a feature to exclude temporary files and folders. As when a project is builded or developped.

**Add Steam client and Proton-GE:**
- An awesome work has been performed by Valve to improve compatibility with games.
- It permits to **execute with simplicity windows games**.
- Proton-GE provides an **easy way to execute FSR on all games**, and gains some FPS.
- Through Steam, I can **execute others launchers** from others stores. And I have fewer stuff to manage and think about.