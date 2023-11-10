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
# 1- CROSS SCRIPTS FUNCTIONS
################################################################################
 source ./reused_functions.sh

################################################################################
# 1 - EXECUTE SCRIPTS
################################################################################

URL=https://github.com/ArmandCorbeaux/better-bookworm/raw/dev

LIST_OF_SCRIPTS=(
#    01-repo_backports.sh
)

# GET INDIVIDUAL SCRIPTS & LAUNCH THEM
for SCRIPT in "${LIST_OF_SCRIPTS[@]}"; do
    wget "$URL/$SCRIPT"
    bash "./$SCRIPT"
    rm -f "./$SCRIPT"
done

# END OF OPERATIONS
rm -f "./install.sh"

echo "System will reboot"
sleep 5
sudo reboot