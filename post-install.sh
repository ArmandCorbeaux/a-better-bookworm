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
sudo apt -t "$dist_codename"-backports full-upgrade -y


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
sudo DEBIAN_FRONTEND=noninteractive apt autoremove --purge gnome-shell-extension-prefs -y --quiet >> /dev/null

################################################################################
# CUSTOMIZE BOOT
################################################################################
echo "Customize Boot Splash"

# install plymouth-theme and set theme to use OEM Bios Logo
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports plymouth-themes -y --quiet >> /dev/null
sudo plymouth-set-default-theme -R bgrt >> /dev/null

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

################################################################################
# ADD ZRAMSWAP
################################################################################
echo "Install ZRAM swap"
sudo DEBIAN_FRONTEND=noninteractive apt -t $dist_codename-backports zram-tools -y --quiet >> /dev/null

################################################################################
# FLATPAK SOFTWARE STORE
################################################################################

echo "Add flatpak support"
sudo DEBIAN_FRONTEND=noninteractive apt -t "$dist_codename"-backports install gnome-software-plugin-flatpak -y --quiet >> /dev/null
echo "Add FlatHub repository"
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak update

################################################################################
# APT - ADD EXTRA REPOSITORIES
################################################################################

echo "Add OneDrive Linux repository"

wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list


echo "Add Docker repository"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


echo "Add Google Cloud SDK repository"

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg

echo "Add Steam repository"
sudo tee /etc/apt/sources.list.d/steam-stable.list <<'EOF'
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
deb-src [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
EOF
curl https://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg
sudo dpkg --add-architecture i386

sudo apt-get install \
  libgl1-mesa-dri:amd64 \
  libgl1-mesa-dri:i386 \
  libgl1-mesa-glx:amd64 \
  libgl1-mesa-glx:i386 \
  steam-launcher