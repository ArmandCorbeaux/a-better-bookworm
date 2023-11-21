#!/bin/bash

# Post-installation script for a debian 12 bookworm minimal install
# Must have :
# - user with sudo rights
# - system installed on a btrfs partition

BRANCH="dev"
URL="https://github.com/ArmandCorbeaux/better-bookworm/raw/$BRANCH"

LIST_OF_SCRIPTS=(
001-repo_backports.sh
002-repo_contrib_nonfree.sh
003-repo_disable_src.sh
101-btrfs_fstab.sh
111-boot_tweak.sh
121-zram_swap.sh
131-multigen_lru.sh
201-minimal_gnome_desktop.sh
211-printer_support.sh
221-misc_tools.sh
231-python_tools.sh
301-flatpak_support.sh
302-flatpak_softwares.sh
401-docker_desktop.sh
402-docker_desktop_enable_per_user.sh
411-onedrive_install.sh
412-onedrive_enable_per_user.sh
421-google_chrome.sh
431-visual_code.sh
432-visual_code_customize_per_user.sh
441-steam_client.sh
442-steam_protonge_per_user.sh
#451-oracle_java_jdk.sh
461-minecraft_client.sh
701-specific_fonts_install.sh
711-icon_theme.sh
721-cursor-theme.sh
731-gnome_shell_settings_per_user.sh
732-gnome-shortcut_organization_per_user.sh
741-gnome_shell_extensions_per_user.sh
742-gnome_extensions_settings_per_user.sh
751-gdm3_settings.sh
#801-gcloud_cli.sh
991-wifi_migrate.sh
)

################################################################################
# 0 - CHECK OS ENVIRONMENT
################################################################################

lsb_release_path=$(which lsb_release 2> /dev/null)
dist_name=$(lsb_release -si)
dist_version=$(lsb_release -sr)
dist_codename=$(lsb_release -sc)

if [[ "$dist_name" != "Debian" ]] || [[ "$dist_version" != "12" ]]; then
    echo "Sorry. This script is only for Debian 12 Bookworm"
    exit 1
fi

# Check if the user has sudo privileges

if ! sudo -v; then
    echo "This script requires sudo privileges. Exiting."
    exit 1
fi

# Check if running as root

if [[ $EUID -eq 0 ]]; then
    echo "This script should not be run as root. Please run it as a regular user with sudo."
    exit 1
fi

################################################################################
# 1 - EXECUTE SCRIPTS
################################################################################

# Clear shell screen before install
clear

# GET INDIVIDUAL SCRIPTS & LAUNCH THEM
for SCRIPT in "${LIST_OF_SCRIPTS[@]}"; do
    wget "$URL/$SCRIPT" -q --show-progress
    bash "./$SCRIPT"
    rm -f "./$SCRIPT"
# debug pause
#    read -s -n 1 -p "/!\ ... press a key ..."
done

# END OF OPERATIONS
rm -f "./install.sh"

echo "System will reboot"
sleep 5
sudo reboot