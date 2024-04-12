#!/bin/bash


################################################################################
# 601 - APPIMAGED
################################################################################
#
# Job :     App AppImaged daemon on the system for the current user
#
# Author :  Armand CORBEAUX
# Date :    2023-11-30
#
# Impact :  user
#
# Inputs :  URL, DEST_DIR
# Outputs : 
#
# More informations :
#           Create a script ato enable AppImaged daemon service for current users
#
# Bugs :
#           

# URL de la page de release
URL="https://api.github.com/repos/probonopd/go-appimage/releases/tags/continuous"

# Répertoire de destination
DEST_DIR="$HOME/Applications"

# Récupérer les informations JSON de la page de release
release_info=$(curl -s $URL)

# Extraire l'URL de téléchargement de la dernière version x86_64 à partir des informations JSON
download_url=$(echo $release_info | grep -o '"browser_download_url": *"[^"]*appimaged-[0-9]*-x86_64\.AppImage"' | grep -o '"[^"]*"' | grep -o 'https://.*' | sed 's/"$//')

# Télécharger le fichier dans le répertoire de destination
wget --content-disposition $download_url -P $DEST_DIR

# Rendre le fichier exécutable
chmod +x "$DEST_DIR/$(basename $download_url)"

# Exécuter le fichier
"~/$DEST_DIR/$(basename $download_url)"
