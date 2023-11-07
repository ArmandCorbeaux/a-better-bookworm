#!/bin/bash

#################################################################################
# 20 - Migrate Wi-Fi connection from ifupdown to NetworkManager
################################################################################

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

echo "Wi-Fi Interface: $wifi_interface"
echo "SSID: $ssid"
echo "Password: $password"

# shutdown Wi-Fi connection
sudo ifdown $wifi_interface

# Create a new /etc/network/interfaces file with only loopback configuration
echo "auto lo" | sudo tee /etc/network/interfaces
echo "iface lo inet loopback" | sudo tee -a /etc/network/interfaces

sudo service wpa_supplicant restart
sudo service NetworkManager restart
sleep 10
sudo nmcli device wifi connect $ssid password $password ifname $wifi_interface

# Check if the Wi-Fi interface is available
if ! sudo nmcli device wifi show &> /dev/null; then
    echo "Wi-Fi interface not available. Back to the initial state."
    sudo mv /etc/network/interfaces.backup /etc/network/interfaces
    exit 1
fi

sudo rm /etc/network/interfaces.backup
echo "Switched from ifupdown to NetworkManager for $wifi_interface."

