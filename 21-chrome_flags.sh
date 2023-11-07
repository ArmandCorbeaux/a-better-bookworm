#!/bin/bash

#################################################################################
# 21 - Improve support of Wayland for Google Chrome
#################################################################################

# Get the path to the `/etc/environment` file.
environment_file="/etc/environment"

# Add the Google Chrome Wayland and PipeWire flags to the `/etc/environment` file.
echo "CHROME_FLAGS=\"--ozone-platform=wayland --enable-features=UsePipeWire --enable-features=Vulkan\"" | sudo tee -a ${environment_file}
