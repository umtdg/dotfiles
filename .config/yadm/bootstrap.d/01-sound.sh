#!/usr/bin/env bash

set -e

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"


function ubuntu_install() {
    echo "Skipping on Ubuntu"
}

function arch_install() {
    yay -S --needed --noconfirm --noeditmenu --nodiffmenu --nocleanmenu --nocleanafter \
        libpipewire pipewire-alsa pipewire-pulse pipewire-audio pipewire \
        libpulse alsa-lib alsa-utils \
        playerctl pavucontrol easyeffects \
        lsp-plugins zita-convolver calf libbs2b zam-plugins
}


echo -e "\n\nBootstrap sound\n"
${distro}_install

