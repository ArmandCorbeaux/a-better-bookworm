#!/bin/bash

#################################################################################
# 991 - Migrate Wi-Fi connection from ifupdown to NetworkManager
################################################################################
#
# Job :     Transfert informations from ifupdown to NetworkManager
#
# Author :  Armand CORBEAUX
# Date :    2023-11-15
#
# Impact :  system wide
#
# Inputs :  /etc/network/interfaces
# Outputs : /etc/network/interfaces, nmcli
#
# More informations :
#           https://wiki.debian.org/NetworkManager
#           Migrate WiFi and Ethernet settings to Network-Manager

# Backup the current /etc/network/interfaces file
sudo cp /etc/network/interfaces /etc/network/interfaces.backup

# Function to get the Wi-Fi interface name from /etc/network/interfaces
get_wifi_interface() {
    local wifi_interface
    wifi_interface=$(sudo awk -F ' ' '/iface.*inet dhcp/ {print $2}' /etc/network/interfaces)
    if [ -n "$wifi_interface" ]; then
        echo "$wifi_interface"
    else
        echo "Wi-Fi interface not found in /etc/network/interfaces"
        exit 1
    fi
}

# Get the Wi-Fi interface name, SSID, password from /etc/network/interfaces.backup
wifi_interface=$(get_wifi_interface)
ssid=$(sudo grep -i 'wpa-ssid' /etc/network/interfaces | awk '{print $2}')
password=$(sudo grep -i 'wpa-psk' /etc/network/interfaces | awk '{print $2}')

# Shutdown Wi-Fi connection
sudo ifdown $wifi_interface &> /dev/null

# Clean /etc/network/interfaces file with only loopback configuration
echo "auto lo" | sudo tee /etc/network/interfaces &> /dev/null
echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces &> /dev/null

# Restart services
sudo service wpa_supplicant restart
sudo service NetworkManager restart
# Wait for initialization
sleep 10
# Connect to Wi-Fi
sudo nmcli device wifi connect $ssid password $password ifname $wifi_interface

# Undo changes if Wi-Fi migration has failed
if ! sudo nmcli device wifi show &> /dev/null; then
    # Check for Ethernet connection
    if ! sudo nmcli device show | grep -q ethernet; then
        echo "Neither Wi-Fi nor Ethernet interface available. Back to the initial state."
        sudo mv /etc/network/interfaces.backup /etc/network/interfaces
        exit 1
    else
        echo "Ethernet connection available. Skipping rollback."
    fi
fi

# If Wi-Fi migration is successful, remove backup file
sudo rm /etc/network/interfaces.backup

