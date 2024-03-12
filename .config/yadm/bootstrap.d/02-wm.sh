#! /usr/bin/env bash

set -e

function write_file_sudo() {
    echo "$1" | sudo tee -a "$2" >/dev/null
}

echo -e "\n\nBootstrap WM\n"

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"
[[ "$distro" != 'arch' ]] && { echo "Skipping on $distro"; exit 0; }

packages=(
    sddm i3-gaps picom redshift
    i3lock i3lock-fancy-multimonitor
    xorg xorg-setxkbmap xkb-switch
    xf86-video-vesa xf86-input-libinput
    polybar rofi dunst feh flameshot shutter alacritty blueberry
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

if [[ ! -d "$icon_dir/Papirus" ]]; then
    echo -e "\n\nExtracting Papirus icons"
    tar -xzf "$icon_dir/Papirus.tar.gz" -C "$icon_dir"
fi

if [[ ! -d "$icon_dir/Sweet-cursors" ]]; then
    echo -e "\nExtracting Sweet cursors"
    tar -xzf "$icon_dir/Sweet-cursors.tar.gz" -C "$icon_dir"
fi

if [[ ! -d "$theme_dir/Sweet-mars" ]]; then
    echo -e "\nExtracting Sweet-mars theme"
    tar -xzf "$theme_dir/Sweet-mars.tar.gz" -C "$theme_dir"
fi

echo -e "\nEnabling sddm.service"
sudo systemctl enable sddm.service

echo -e "\nCopying SDDM config"
sudo install -Dm 644 -t /etc/sddm.conf.d ~/sddm.conf.d/*

echo -e "\nChange SDDM theme background"
HOME_ESCAPED=${HOME//\//\\\/}; sudo sed -i "s/^Background=\(.*\)$/Background=\"$HOME_ESCAPED\/.background\"/g" /usr/share/sddm/themes/Sugar-Candy/theme.conf

if [[ "$HOSTNAME" == 'naboo' ]]; then
    echo -e "\nCreating libinput config"
    file='/etc/X11/xorg.conf.d/30-touchpad.conf'
    write_file_sudo 'Section "InputClass"' "$file"
    write_file_sudo "    Identifier \"$(sudo libinput list-devices | grep -i '^device:.*touchpad' | cut -d: -f2 | xargs)\"" "$file"
    write_file_sudo '    Driver "libinput"' "$file"
    write_file_sudo '    Option "Tapping" "on"' "$file"
    write_file_sudo '    Option "NaturalScrolling" "true"' "$file"
    write_file_sudo 'EndSection' "$file"
fi

