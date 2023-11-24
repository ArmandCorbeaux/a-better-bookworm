#!/bin/bash

################################################################################
# 432 - VISUAL CODE CUSTOM SETTINGS
################################################################################
#
# Job :     Customize Visual Code
#
# Author :  Armand CORBEAUX
# Date :    2023-11-13
#
# Impact :  user
#
# Inputs :  FILE_PATH, VSCODE_SETTINGS, EXTENSIONS
# Outputs : apt
#
# More informations :
#           https://code.visualstudio.com/download
#
# Bugs :
#           fonts settings must not to be set with single quotes

FILE_PATH="$HOME/.config/Code/User/settings.json"

VSCODE_SETTINGS='{
    "window.titleBarStyle": "custom",
    "workbench.iconTheme": "material-icon-theme",
    "workbench.startupEditor": "none",
    "files.autoSave": "afterDelay",
    "editor.fontFamily": "Victor Mono,Noto Color Emoji,FiraCode Nerd Font",
    "editor.cursorStyle": "block",
    "files.exclude": {
        "**/.DS_Store": false,
        "**/.git": false,
        "**/.hg": false,
        "**/.svn": false,
        "**/CVS": false,
        "**/Thumbs.db": false
    },
    "editor.smoothScrolling": true,
    "editor.cursorSmoothCaretAnimation": "on",
    "editor.cursorBlinking": "expand",
    "editor.fontLigatures": true,
    "editor.fontVariations": true,
    "workbench.colorTheme": "Night Owl",
    "window.dialogStyle": "custom",
    "telemetry.telemetryLevel": "error",
    "git.autofetch": true,
    "terminal.integrated.fontFamily": "FiraCode Nerd Font,Noto Color Emoji,Victor Mono",
    "terminal.integrated.cursorBlinking": true,
    "terminal.integrated.smoothScrolling": true,
    "workbench.list.smoothScrolling": true,
    }'

VSCODE_EXTENSIONS=(
    PKief.material-icon-theme
    sdras.night-owl
    MS-CEINTL.vscode-language-pack-fr
    donjayamanne.python-environment-manager
    KevinRose.vsc-python-indent
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    njpwerner.autodocstring
    ms-azuretools.vscode-docker
    VisualStudioExptTeam.intellicode-api-usage-examples
    VisualStudioExptTeam.vscodeintellicode
    shd101wyy.markdown-preview-enhanced
)

# Create the VSCode json settings
mkdir -p "$(dirname "$FILE_PATH")"
echo "$VSCODE_SETTINGS" > "$FILE_PATH"

# Install VSCode extensions
for extension in "${VSCODE_EXTENSIONS[@]}"; do
    code --install-extension "$extension" &> /dev/null
done
