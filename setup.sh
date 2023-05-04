#!/usr/bin/env bash

function create_link_if_not_exists() {
    if [ ! -e "$1" ]; then
        ln -sf "$2" "$1"
    fi
}

function git_clone_if_not_exists() {
    if [ ! -d "$1" ]; then
        git clone "$2" "$1"
    fi
}

# Setup KAMP
klipperAdaptiveMeshingPurgingDir=~/Klipper-Adaptive-Meshing-Purging
if [ ! -d "$klipperAdaptiveMeshingPurgingDir" ]; then
    git clone https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git "$klipperAdaptiveMeshingPurgingDir"
fi
create_link_if_not_exists "$klipperAdaptiveMeshingPurgingDir"/Configuration ~/printer_data/config/KAMP

moonrakerConf=~/printer_data/config/moonraker.conf
if ! grep -q "update_manager Klipper-Adaptive-Meshing-Purging" "$moonrakerConf"; then
    cat <<EOT >> "$moonrakerConf"

[update_manager Klipper-Adaptive-Meshing-Purging]
type: git_repo
channel: dev
path: $klipperAdaptiveMeshingPurgingDir
origin: https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git
managed_services: klipper
primary_branch: main

EOT
fi

# Setup led_effect
DIR=~/klipper-led_effect
if [ ! -d "$DIR" ]; then
    git clone https://github.com/julianschill/klipper-led_effect.git $DIR
    (cd $DIR && ./install-led_effect.sh)
fi


# Setup Printer Config
printerConfigDir=~/printer-config
if [ ! -d "$printerConfigDir" ]; then
    git clone https://github.com/jamesprints/printer-config.git "$printerConfigDir"
fi
create_link_if_not_exists ~/printer_data/config/printer "$printerConfigDir"
create_link_if_not_exists ~/printer_data/config/printer-config-moonraker-update.conf "$printerConfigDir"/printer-config-moonraker-update.conf

if ! grep -q "include printer-config-moonraker-update" "$moonrakerConf"; then
    echo "[include printer-config-moonraker-update.conf]" >> "$moonrakerConf"
fi

# Ensure exclude_object
if ! grep -q "enable_object_processing: True" "$moonrakerConf"; then
    cat <<EOT >> "$moonrakerConf"

[file_manager]
enable_object_processing: True

EOT
fi
