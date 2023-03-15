#!/usr/bin/env bash

set -e

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"


function ubuntu_install() {
    sudo apt-get install -y build-essential git wget python3
}

function arch_install() {
    sudo pacman -S --noconfirm --needed \
        pacman-contrib base-devel git wget python gnupg openssh \
        xorg xf86-video-vesa xf86-input-libinput mlocate

    [[ -f '/usr/bin/yay' ]] && return 0
    [[ -d '/tmp/yay' ]] && rm -rf '/tmp/yay'
    git clone -q https://aur.archlinux.org/yay.git /tmp/yay

    pushd '/tmp/yay' >/dev/null 2>&1
    makepkg -si --needed --noconfirm
    popd >/dev/null 2>&1

    rm -rf '/tmp/yay'

    echo -e "\nCopying Pacman hooks"
    sudo install -Dm 644 -t /etc/pacman.d/hooks ~/pacman_hooks/*.hook

    yay --save --nocleanafter --nocleanmenu --nodiffmenu --noeditmenu --combinedupgrade
}


echo -e "\n\nBootstrap general distro stuff\n"
${distro}_install

