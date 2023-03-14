#! /usr/bin/env bash

set -e

echo -e "\n\nBootstrap WM\n"

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"
[[ "$distro" != 'arch' ]] && { echo "Skipping on $distro"; exit 0; }

packages=(
    sddm i3-gaps picom
    i3lock i3lock-fancy-multimonitor
    xorg xorg-setxkbmap xkb-switch
    xf86-video-vesa xf86-input-libinput
    polybar rofi dunst feh flameshot shutter alacritty
    firefox thunderbird copyq megasync-bin lxappearance
    teams signal-desktop whatsapp-nativefier spotify discord
    thunar thunar-volman thunar-archive-plugin
    polkit polkit-qt5 polkit-gnome
    sddm-theme-sugar-candy-git sweet-gtk-theme sweet-gtk-theme-dark
)
opts=(
    -S --needed
    --noconfirm
    --noeditmenu
    --nodiffmenu
    --nocleanmenu
    --nocleanafter
)

if [[ "$HOST" == 'tatooine' ]]; then
    packages+=(nvidia-lts nvidia-utils nvidia-settings)
fi

yay "${opts[@]}" "${packages[@]}"

icon_dir="$HOME/.icons"
theme_dir="$HOME/.themes"
mkdir -p "$icon_dir" "$theme_dir"

echo -e "\n\nExtracting Papirus icons"
tar -xzf "$icon_dir/Papirus.tar.gz" -C "$icon_dir"

echo -e "\nExtracting Sweet cursor"
tar -xzf "$icon_dir/Sweet-cursors.tar.gz" -C "$icon_dir"

echo -e "\nExtracting Sweet-mars theme"
tar -xzf "$theme_dir/Sweet-mars.tar.gz" -C "$theme_dir"

echo -e "\nEnabling sddm.service"
sudo systemctl enable sddm.service

