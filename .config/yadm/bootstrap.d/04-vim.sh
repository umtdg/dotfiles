#!/usr/bin/env bash

set -e

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"


function ubuntu_install() {
    sudo apt-get install -y vim-gtk
}

function arch_install() {
    yay -S --needed --noconfirm gvim
}

echo -e "\n\nBootstrap VIM\n"
${distro}_install

vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'

