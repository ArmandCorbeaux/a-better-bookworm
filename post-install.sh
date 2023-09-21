#!/usr/bin/env bash
#
# Post-installation script for a debian 12 bookworm minimal install
# Must have :
# - user with sudo rights
# - system installed on a btrfs partition

################################################################################
# CHECK OS ENVIRONMENT
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
# APT - SOURCES.LIST - ADD BACKPORTS REPOSITORY
################################################################################

# Check if backports entry already exists in sources.list
if sudo grep -q "$dist_codename-backports" /etc/apt/sources.list; then
    echo "Backports repository entry already exists. Nothing to do."
else
    # Add the backports repository entry to sources.list
    echo "Adding backports repository entry..."
    echo "deb http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "deb-src http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "Backports repository entry added."
fi


################################################################################
# APT - SOURCES.LIST - ADD CONTRIB AND NON-FREE ENTRIES
################################################################################

# Create a new sources.list.tmp file to store the modified contents
sudo cp /etc/apt/sources.list /etc/apt/sources.list.tmp

# Flag to track if modifications are made
sources_list_modifications_made=false

# Iterate over the lines in the original sources.list file
while IFS= read -r line; do

  # If the line starts with deb or deb-src
  if [[ $line =~ ^deb.* ]]; then

    # Check if contrib non-free is already in the line
    if [[ ! $line =~ "contrib non-free" ]]; then

      # Add contrib non-free to the line
      modified_line="$line contrib non-free"

      # Replace the original line with the modified line in the temporary file
      sudo sed -i "s|$line|$modified_line|" /etc/apt/sources.list.tmp
      # Set the modifications flag to true
      sources_list_modifications_made=true
    fi

  fi

done < /etc/apt/sources.list

if [ "$sources_list_modifications_made" = true ]; then
  echo "'contrib non-free' entries added in /etc/apt/sources.list"
  # Replace the original sources.list file with the modified temporary file
  sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
else
  sudo rm /etc/apt/sources.list.tmp
fi


################################################################################
# APT - SOURCES.LIST - DISABLE DEB-SRC LINES
################################################################################

# Temp file to store modified lines
temp_file=$(mktemp)
sources_list_modifications_made=false

# Read the sources.list file line by line
while IFS= read -r line; do
  # If the line starts with deb-src
  if [[ $line =~ ^deb-src.* ]]; then
    # Add # to the beginning of the line
    echo "#$line" >> "$temp_file"
    sources_list_modifications_made=true
  else
    echo "$line" >> "$temp_file"
  fi
done < "/etc/apt/sources.list"

if [ "$sources_list_modifications_made" = true ]; then
  # Replace the original file with the modified content
  sudo mv "$temp_file" "/etc/apt/sources.list"
  echo "deb-src lines have been disabled in the sources.list file."
else
  # No changes were made
  rm "$temp_file"
  echo "No changes were made to the sources.list file."
fi


################################################################################
# APT - UPDATE SYSTEM WITH BACKPORTS PACKAGES
################################################################################

sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports full-upgrade -y --quiet

################################################################################
# CHANGE BTRFS FLAGS IN FSTAB
################################################################################

# Variable to track if changes were made
fstab_modifications_made=false

# Check each line in /etc/fstab
while IFS= read -r line; do
  if [[ "$line" == *"btrfs"* ]] && [[ "$line" == *"default"* ]]; then
    # Replace 'default' with 'ssd,discard=async,autodefrag,compress=zstd'
    updated_line=$(echo "$line" | sed 's/default/ssd,discard=async,autodefrag,compress=zstd,noatime/')
    echo "Replacing line: $line"
    echo "With: $updated_line"

    # Use sudo to update the file
    sudo sed -i "s|$line|$updated_line|" /etc/fstab

    # Set changes_made to true
    fstab_modifications_made=true
  fi
done < /etc/fstab

# Check if changes were made and echo appropriate message
if [ "$fstab_modifications_made" = true ]; then
  echo "Changes were made to /etc/fstab to tweak btrfs for electronic storage."
else
  echo "No changes were made to /etc/fstab."
fi

################################################################################
# INSTALL MINIMAL GNOME DESKTOP
################################################################################

echo "Install minimal Gnome Desktop"
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install gnome-shell gnome-console gnome-tweaks nautilus -y --quiet >> /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt autoremove --purge gnome-shell-extension-prefs -y --quiet >> /dev/null # don't need gnome-shell-extension-prefs as gnome-shell-extension-manager will be installed and performs the same stuff

################################################################################
# INSTALL SOME TOOLS
################################################################################
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install curl git -y --quiet >> /dev/null

sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install cups -y --quiet >> /dev/null

sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install python3-venv python3-pip -y --quiet >> /dev/null

################################################################################
# CUSTOMIZE BOOT
################################################################################
echo "Customize Boot Splash"

# install plymouth-theme and set theme to use OEM Bios Logo
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports plymouth-themes -y --quiet >> /dev/null
sudo plymouth-set-default-theme -R bgrt >> /dev/null
echo "Plymouth splash has been changed."

# Customize GRUB values
NEW_GRUB_TIMEOUT=0  # Immediatly load the kernel
NEW_GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0"  # Show plymouth theme
NEW_GRUB_BACKGROUND=""  # No background
GRUB_PATH="/etc/default/grub"

# Change the GRUB_TIMEOUT value
sudo sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$NEW_GRUB_TIMEOUT/" $GRUB_PATH
# Change the GRUB_CMDLINE_LINUX_DEFAULT value
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_GRUB_CMDLINE_LINUX_DEFAULT\"/" $GRUB_PATH
# Change the GRUB_BACKGROUND value
sudo sed -i "s/GRUB_BACKGROUND=.*/GRUB_BACKGROUND=\"$NEW_GRUB_BACKGROUND\"/" $GRUB_PATH

sudo update-grub >> /dev/null
echo "GRUB settings have been changed."

################################################################################
# ADD ZRAMSWAP
################################################################################
echo "Install and configure ZRAM swap"
sudo DEBIAN_FRONTEND=noninteractive apt -t $dist_codename-backports zram-tools -y --quiet >> /dev/null

# Your desired values
ALGO="zstd"
PERCENT=25
PRIORITY=100

# Uncomment and modify the values
sudo sed -i "s/#\s*ALGO=.*/ALGO=\"$ALGO\"/" /etc/default/zramswap
sudo sed -i "s/#\s*PERCENT=.*/PERCENT=$PERCENT/" /etc/default/zramswap
sudo sed -i "s/#\s*PRIORITY=.*/PRIORITY=$PRIORITY/" /etc/default/zramswap

################################################################################
# FLATPAK - ADD SOFTWARE STORE
################################################################################

echo "Add flatpak support"
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install gnome-software-plugin-flatpak -y --quiet >> /dev/null
echo "Add FlatHub repository"
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak update

################################################################################
# FLATPAK - ADD SOFTWARES
################################################################################
# List of Flatpak applications to install
flathub_applications_list=(
  "com.mattjakeman.ExtensionManager"
  "io.github.realmazharhussain.GdmSettings"
  "io.missioncenter.MissionCenter"
  "org.gnome.Evince"
  "org.gnome.Loupe"
  "org.gnome.Snapshot"
  "org.gnome.Totem"
  "org.gnome.font-viewer"
  "org.gnome.seahorse.Application"
)

# Iterate through the applications and install them
for flathub_app in "${flathub_applications_list[@]}"; do
  flatpak install "$flathub_app" -y >> /dev/null
done
################################################################################
# APT - ADD EXTRA REPOSITORIES
################################################################################

# Function to add a repository
add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="/usr/share/keyrings/$1.gpg"

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [signed-by=$keyring_path] $repository_url" | sudo tee "/etc/apt/sources.list.d/$1.list" > /dev/null
}

# Add OneDrive Linux repository
add_repository "onedrive" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/"

# Add Docker repository
add_repository "docker" "https://download.docker.com/linux/debian/gpg" "https://download.docker.com/linux/debian"

# Add Google Cloud SDK repository
add_repository "google-cloud-sdk" "https://packages.cloud.google.com/apt/doc/apt-key.gpg" "https://packages.cloud.google.com/apt"

# Add Steam repository
add_repository "steam" "https://repo.steampowered.com/steam/archive/stable/steam.gpg" "https://repo.steampowered.com/steam/"

sudo dpkg --add-architecture i386

# update the apt list
sudo apt update

################################################################################
# SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################

################################################################################
# SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################

sudo apt install \
  libgl1-mesa-dri:amd64 \
  libgl1-mesa-dri:i386 \
  libgl1-mesa-glx:amd64 \
  libgl1-mesa-glx:i386 \
  steam-launcher \
  google-cloud-cli