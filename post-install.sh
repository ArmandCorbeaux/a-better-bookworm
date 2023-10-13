#!/usr/bin/env bash
#
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
# 1- APT - SOURCES.LIST - ADD BACKPORTS REPOSITORY
################################################################################

# # Check if backports entry already exists in sources.list
# if sudo grep -q "$dist_codename-backports" /etc/apt/sources.list; then
#     echo "Backports repository entry already exists. Nothing to do."
# else
#     # Add the backports repository entry to sources.list
#     echo "Adding backports repository entry..."
#     echo "deb http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
#     echo "deb-src http://deb.debian.org/debian $dist_codename-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list > /dev/null
#     echo "Backports repository entry added."
# fi


################################################################################
# 2 - APT - SOURCES.LIST - ADD CONTRIB AND NON-FREE ENTRIES
################################################################################

# # Create a new sources.list.tmp file to store the modified contents
# sudo cp /etc/apt/sources.list /etc/apt/sources.list.tmp

# # Flag to track if modifications are made
# sources_list_modifications_made=false

# # Iterate over the lines in the original sources.list file
# while IFS= read -r line; do

#   # If the line starts with deb or deb-src
#   if [[ $line =~ ^deb.* ]]; then

#     # Check if contrib non-free is already in the line
#     if [[ ! $line =~ "contrib non-free" ]]; then

#       # Add contrib non-free to the line
#       modified_line="$line contrib non-free"

#       # Replace the original line with the modified line in the temporary file
#       sudo sed -i "s|$line|$modified_line|" /etc/apt/sources.list.tmp
#       # Set the modifications flag to true
#       sources_list_modifications_made=true
#     fi

#   fi

# done < /etc/apt/sources.list

# if [ "$sources_list_modifications_made" = true ]; then
#   echo "'contrib non-free' entries added in /etc/apt/sources.list"
#   # Replace the original sources.list file with the modified temporary file
#   sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
# else
#   sudo rm /etc/apt/sources.list.tmp
# fi


################################################################################
# 3 - APT - SOURCES.LIST - DISABLE DEB-SRC LINES
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
# 4 - CHANGE BTRFS FLAGS IN FSTAB
################################################################################

# Variable to track if changes were made
fstab_modifications_made=false

# Check each line in /etc/fstab
while IFS= read -r line; do
  if [[ "$line" == *"btrfs"* ]] && [[ "$line" == *"defaults"* ]]; then
    # Replace 'defaults' with 'ssd,discard=async,autodefrag,compress=zstd'
    updated_line=$(echo "$line" | sed 's/defaults/ssd,discard=async,autodefrag,compress=zstd,noatime/')
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
# 5 - INSTALL MINIMAL GNOME DESKTOP
################################################################################

echo "Install minimal Gnome Desktop"
sudo apt update
sudo apt install gnome-shell gnome-console gnome-tweaks nautilus -y --quiet
sudo apt autoremove --purge gnome-shell-extension-prefs -y --quiet
# don't need gnome-shell-extension-prefs as gnome-shell-extension-manager will be installed and performs the same stuff

################################################################################
# 6 - INSTALL SOME TOOLS
################################################################################
sudo apt install curl git -y

sudo apt install cups -y

sudo apt install python3-venv python3-pip -y

################################################################################
# 7 -CUSTOMIZE BOOT
################################################################################
echo "Customize Boot Splash"

# install plymouth-theme and set theme to use OEM Bios Logo
sudo apt install plymouth-themes -y
sudo plymouth-set-default-theme -R bgrt
echo "Plymouth splash has been changed."

# Customize GRUB values
NEW_GRUB_TIMEOUT=0  # Immediatly load the kernel
NEW_GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0 amd_pstate=passive amd_pstate.shared_mem=1 initcall_blacklist=acpi_cpufreq_init"  # Show plymouth theme
NEW_GRUB_BACKGROUND=""  # No background
GRUB_PATH="/etc/default/grub"

# Change the GRUB_TIMEOUT value
sudo sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$NEW_GRUB_TIMEOUT/" $GRUB_PATH
# Change the GRUB_CMDLINE_LINUX_DEFAULT value
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_GRUB_CMDLINE_LINUX_DEFAULT\"/" $GRUB_PATH
# Change the GRUB_BACKGROUND value
sudo sed -i "s/GRUB_BACKGROUND=.*/GRUB_BACKGROUND=\"$NEW_GRUB_BACKGROUND\"/" $GRUB_PATH

sudo update-grub
echo "GRUB settings have been changed."

################################################################################
# 8 - ADD ZRAMSWAP
################################################################################
echo "Install and configure swap spaces"
sudo apt -t $dist_codename-backports install zram-tools -y

# ZRAM - desired values
ALGO="zstd"
PERCENT=100
PRIORITY=100

# ZRAM - uncomment and modify the values
sudo sed -i "s/#\s*ALGO=.*/ALGO=\"$ALGO\"/" /etc/default/zramswap
sudo sed -i "s/#\s*PERCENT=.*/PERCENT=$PERCENT/" /etc/default/zramswap
sudo sed -i "s/#\s*PRIORITY=.*/PRIORITY=$PRIORITY/" /etc/default/zramswap

sysctl_values_to_add=(
  "vm.page-cluster=0"
  "vm.swappiness=180"
  "vm.watermark_boost_factor=0"
  "vm.watermark_scale_factor=125"
)

# Append values to sysctl.conf
for value in "${sysctl_values_to_add[@]}"; do
  echo "$value" | sudo tee -a /etc/sysctl.conf
done

################################################################################
# 9 - FLATPAK - ADD SOFTWARE STORE
################################################################################

echo "Add flatpak support"
sudo apt install gnome-software-plugin-flatpak -y
echo "Add FlatHub repository"
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak update

################################################################################
# 10 - FLATPAK - ADD SOFTWARES
################################################################################
# List of Flatpak applications to install
flathub_applications_list=(
  "com.mattjakeman.ExtensionManager" # gnome-shell-extension-manager
  "io.github.realmazharhussain.GdmSettings" # personalize GDM settings
  "io.missioncenter.MissionCenter" # resource monitoring
  "org.gnome.Evince" # document viewer
  "org.gnome.Loupe" # image viewer
#  "org.gnome.Snapshot" # camera viewer
#  "org.gnome.Totem" # video player
#  "org.gnome.font-viewer" # font viewer
#  "org.gnome.seahorse.Application" # password and key handler
  "org.gnome.Firmware" # hardware firmware updater
#  "org.gnome.Boxes" # Virtual Machine
#  "org.gnome.Connections" # access with VNC and RDP
)

# Iterate through the applications and install them
for flathub_app in "${flathub_applications_list[@]}"; do
  flatpak install "$flathub_app" -y
done

################################################################################
# 11- APT - ADD EXTRA REPOSITORIES
################################################################################

# Function to add a repository
add_repository() {
    echo "Adding $1 repository"

    key_url=$2
    repository_url=$3
    keyring_path="/usr/share/keyrings/$1.gpg"
    archs=$4

    curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring_path"

    echo "deb [arch=$archs signed-by=$keyring_path] $repository_url" | sudo tee "/etc/apt/sources.list.d/$1.list"
}

# Add OneDrive Linux repository
add_repository "onedrive" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key" "https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./" "$(dpkg --print-architecture)"

# Add Docker repository
add_repository "docker" "https://download.docker.com/linux/debian/gpg" "https://download.docker.com/linux/debian $dist_codename stable" "$(dpkg --print-architecture)"

# Add Google Cloud SDK repository
#add_repository "google-cloud-sdk" "https://packages.cloud.google.com/apt/doc/apt-key.gpg" "https://packages.cloud.google.com/apt cloud-sdk main" "$(dpkg --print-architecture)"

# # Add Steam repository
# add_repository "steam" "https://repo.steampowered.com/steam/archive/stable/steam.gpg" "https://repo.steampowered.com/steam/ stable steam" "amd64,i386"

# sudo dpkg --add-architecture i386

# update the apt list
sudo apt update

################################################################################
# 12 - SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################
# Create a temporary directory for deb files
mkdir -p ./temp_deb
touch ./temp_deb/safely_delete_this_directory

# Function to extract the latest Docker Desktop deb package URL
get_latest_docker_url() {
    local docker_url=$(curl -sL "https://docs.docker.com/desktop/install/debian/" | grep -oP 'https://desktop.docker.com/linux/main/amd64/docker-desktop-\d+\.\d+\.\d+-amd64.deb' | head -n 1)
    echo "$docker_url"
}

# Download deb files
declare -A deb_urls=(
    ["Google_Chrome"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    ["Hyper_Terminal"]="https://releases.hyper.is/download/deb"
    ["Microsoft_Visual_Code"]="http://go.microsoft.com/fwlink/?LinkID=760868"
    ["Valve_Steam"]="https://media.steampowered.com/client/installer/steam.deb"
    ["Docker_Desktop"]=$(get_latest_docker_url)
)

for app in "${!deb_urls[@]}"; do
    wget "${deb_urls[$app]}" -O "./temp_deb/${app// /_}.deb"
done

# Install deb packages
sudo apt install ./temp_deb/*.deb -y

# Clean up the temporary directory
rm -Rf ./temp_deb

################################################################################
# 13 - SYSTEM - GET SOME EXTRA SOFTWARES
################################################################################

# sudo apt install \
#   libgl1-mesa-dri:amd64 \
#   libgl1-mesa-dri:i386 \
#   libgl1-mesa-glx:amd64 \
#   libgl1-mesa-glx:i386 \
#   steam-launcher \
#   -y

# sudo apt install \
#   google-cloud-cli \
#   -y

sudo apt install \
  onedrive \
  -y

################################################################################
# 14 - SYSTEM - ENABLE SERVICES
################################################################################
systemctl --user enable docker-desktop
systemctl --user enable onedrive

################################################################################
# 15 - GNOME - INSTALL GNOME-SHELL EXTENSIONS
################################################################################

# gnome-shell-extension URLs
extension_urls=(
  "https://extensions.gnome.org/extension-data/tiling-assistantleleat-on-github.v43.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/onedrivediegomerida.com.v11.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v84.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/BingWallpaperineffable-gmail.com.v45.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/caffeinepatapon.info.v51.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip"
)

# Install each extension
for url in "${extension_urls[@]}"; do
  gnome-extensions install "$url"
done

# enable extensions
extension_uuid=(
  "BingWallpaper@ineffable-gmail.com"
  "onedrive@diegomerida.com"
  "dash-to-dock@micxgx.gmail.com"
  "appindicatorsupport@rgcjonas.gmail.com"
  "tiling-assistant@leleat-on-github"
  "caffeine@patapon.info"
)

for uuid in "${extension_uuid[@]}"; do
  gnome-extension enable "$uuid"
done

################################################################################
# 16 - FONTS WITH LIGATURE - INSTALL
################################################################################
# URL of the GitHub releases page
GITHUB_URL="https://github.com/ryanoasis/nerd-fonts/releases"

# Fetch the HTML content of the GitHub releases page
HTML=$(curl -s "$GITHUB_URL")

# Extract the download link for the latest release
LATEST_RELEASE=$(echo "$HTML" | grep -o -m 1 -P 'https://github.com/ryanoasis/nerd-fonts/releases/download/v\d+\.\d+\.\d+/FiraCode\.zip')

# Download the font using curl
curl -L -o "FiraCode.zip" "$LATEST_RELEASE"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "FiraCode Nerd Font downloaded successfully."
else
  echo "Failed to download FiraCode Nerd Font."
fi

# Download Victor Mono Font with wget
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip

# Now extract the fonts
unzip ./Firacode.zip -d FiraCode
unzip ./VictorMonoAll.zip -d VictorMonoAll
sudo mv Firacode /usr/share/fonts/truetype
sudo mv VictorMonoAll/TTF /usr/share/fonts/VictorMono
rm -Rf FiraCode
rm -Rf VictorMonoAll

################################################################################
# 17 - Enable MGLRU kernel feature as a service
################################################################################

SERVICE_FILE_CONTENT="[Unit]
Description=Multi-Gen LRU Enabler Service
ConditionPathExists=/sys/kernel/mm/lru_gen/enabled

[Service]
Type=oneshot
ExecStart=/bin/bash -c \"/bin/echo y > /sys/kernel/mm/lru_gen/enabled\"
ExecStartPost=/bin/bash -c \"/bin/echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms\"

[Install]
WantedBy=default.target
"

SERVICE_FILE_PATH="/etc/systemd/system/mglru.service"

# Save the service file content to the specified location
echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE_PATH" > /dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Start and enable the mglru service
sudo systemctl start mglru.service
sudo systemctl enable mglru.service

echo "mglru.service created and enabled."

################################################################################
# 18 - Get Latest Proton-GE relase and install it in steam folder
################################################################################
# Define the GitHub repository and API URL
REPO_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

# Fetch the latest release URL
RELEASE_URL=$(curl -s $REPO_URL | grep -o "https://.*\.tar\.gz" | head -n 1)

# Extract the release filename
RELEASE_FILENAME=$(basename "$RELEASE_URL")

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Download the release
curl -L -o "$TEMP_DIR/$RELEASE_FILENAME" "$RELEASE_URL"

# Extract the release
tar -xzvf "$TEMP_DIR/$RELEASE_FILENAME" -C "$TEMP_DIR"
rm "$TEMP_DIR/$RELEASE_FILENAME"
# Copy the uncompressed folder to the desired location
cp -r "$TEMP_DIR/"* ~/.steam/root/compatibilitytools.d/

# Clean up temporary files and directories
rm -rf "$TEMP_DIR"

echo "Latest release has been downloaded, extracted, and copied to ~/.steam/root/compatibilitytools.d/"

################################################################################
# 19 - Install MoreWaita and Bibata Amber Cursor
################################################################################
git clone https://github.com/somepaulo/MoreWaita.git
cd MoreWaita
sudo ./install.sh
cd ..
rm -Rf MoreWaita

# Specify the version (update this to the latest version)
version="2.0.4"
download_url="https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/Bibata-Modern-Amber.tar.xz"

# Create a temporary directory for downloading and extracting the file
temp_dir=$(mktemp -d)

# Download the file
echo "Downloading Bibata-Modern-Amber.tar.xz..."
curl -sL -o "$temp_dir/Bibata-Modern-Amber.tar.xz" "$download_url"

# Uncompress the file
echo "Extracting Bibata-Modern-Amber.tar.xz..."
tar -xJf "$temp_dir/Bibata-Modern-Amber.tar.xz" -C "$temp_dir"

# Copy the folder to /usr/share/icons/
echo "Copying Bibata-Modern-Amber to /usr/share/icons/..."
sudo cp -r "$temp_dir/Bibata-Modern-Amber" /usr/share/icons/

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "Bibata-Modern-Amber has been copied to /usr/share/icons/"
