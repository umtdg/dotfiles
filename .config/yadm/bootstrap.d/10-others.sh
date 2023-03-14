#!/usr/bin/env bash

set -e

echo -e "\n\nBootstrapping misc apps\n"

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"
[[ "$distro" != 'arch' ]] && { echo "Skipping on '$distro'" }

yay -S --noconfirm --noeditmenu --nodiffmenu --nocleanmenu --nocleanafter \
    ffmpeg vlc openvpn openvpn3 1password gitkraken expressvpn \
    veracrypt vmware-workstation vmware-keymaps \
    docker docker-buildx docker-compose docker-credential-pass

sudo usermod -aG docker $USER

