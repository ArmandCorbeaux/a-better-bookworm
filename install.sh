#!/bin/bash

# Post-installation script for a debian 12 bookworm minimal install
# Must have :
# - user with sudo rights
# - system installed on a btrfs partition

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

URL=https://github.com/ArmandCorbeaux/better-bookworm/raw/dev

LIST_OF_SCRIPTS=(
#    01-repo_backports.sh
#    02-repo_contrib_nonfree.sh
    03-repo_disable_src.sh
    04-btrfs_fstab.sh
    05-minimal_gnome_desktop.sh
    06-misc_tools.sh
    07-boot_tweak.sh
    08-zram_swap.sh
    09-flatpak_support.sh
    10-flatpak_softwares.sh
    11.1-docker_desktop.sh
    11.2-onedrive.sh
#    11.3-gcp.sh
    12-extra_softwares.sh
    13-gnome_shell_extensions.sh
    14-fonts.sh
    15-multigen_lru.sh
    16-proton-ge.sh
    17-icons_and_cursor.sh
    18-gnome43_settings.sh
    19-gdm3_settings.sh
    20-wifi_migrate.sh
    21-chrome_flags.sh
)

# GET INDIVIDUAL SCRIPTS & LAUNCH THEM
for SCRIPT in "${LIST_OF_SCRIPTS[@]}"; do
    wget "$URL/$SCRIPT"
    bash "./$SCRIPT"
    rm "./$SCRIPT"
done

# END OF OPERATIONS
rm "./install.sh"

echo "System will reboot"
sleep 5
sudo reboot