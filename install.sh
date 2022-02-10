#!/bin/bash

# Exit on error
set -o errexit
# Exit when undeclared variable is used
set -o nounset

help() {
  echo "Usage: $0 [OPTIONS...]"
  echo "Options:"
  echo "  -f | Install fonts"
  echo "  -a | Install alacritty"
  echo "  -i | Install i3 gaps"
  echo "  -p | Install polybar"
  echo "  -z | Install zsh"
  echo "  -r | Install rofi"
  echo "  -s | Install spicetify"
  echo "  -v | Install vim"
  echo "  -u | Install some utility packages"
  echo "  -c | Setup container environment (k8s + minikube + docker)"
  echo "  -d | Dry run, do nothing, only print actions"
  echo "  -b | Install compositor, picom (fork of compton)"
  echo "  -n | Do not use yay to install packages. This will make AUR packages to be installed manually"
  echo "  -h | Show this message and exit"
}

install_fonts="no"
install_alacritty="no"
install_i3="no"
install_polybar="no"
install_zsh="no"
install_rofi="no"
install_spicetify="no"
install_vim="no"
install_utils="no"
install_picom="no"
setup_container_env="no"
dry_run="no"
use_yay="yes"

# Parse args
while getopts ":panzsrifdbuvcnh" opt; do
    case "${opt}" in
        f)
            install_fonts="yes" ;;
        a)
            install_alacritty="yes" ;;
        i)
            install_i3="yes" ;;
        p)
            install_polybar="yes" ;;
        z)
            install_zsh="yes" ;;
        r)
            install_rofi="yes" ;;
        s)
            install_spicetify="yes" ;;
        v)
            install_vim="yes" ;;
        u)
            install_utils="yes" ;;
        c)
            setup_container_env="yes" ;;
        d)
            dry_run="yes" ;;
        b)
            install_picom="yes" ;;
        n)
            use_yay="no" ;;
        h)
            help
            exit 0 ;;
        *)
            help
            exit 1 ;;
    esac
done
shift $((OPTIND-1))

# List of packages to be installed
packages=()
aur_packages=()

# List of configuration files and destination
config_files=()
destination=""

# Pacman options
pacman_opts=("--noconfirm" "--needed")
# Rsync options
rsync_opts=("-av")

aur_install () {
    name="$1"
    git clone "https://aur.archlinux.org/$name.git" "/tmp/$name"
    pushd "/tmp/$name"
    makepkg -si "${pacman_opts[@]}"
    popd
    rm -rf "/tmp/$name"
}

install () {
    echo "Installing packages"
    echo "Pacman: ${packages[*]}"
    echo "AUR: ${aur_packages[*]}"
    [[ "${use_yay}" = "yes" ]] && echo "Using yay to install AUR packages" \
                                || echo "Manually installing AUR packages"

    if [ "${dry_run}" = "no" ]; then
        sudo pacman -S --noconfirm --needed "${packages[@]}"
        if [ "${use_yay}" = "yes" ]; then
            yay -S "${pacman_opts[@]}" "${aur_packages[@]}"
        else
            for pkg in "${aur_packages[@]}"; do
                aur_install "$pkg"
            done
        fi
    fi

    unset packages
    unset aur_packages
}

copy () {
    rsync "${rsync_opts[@]}" "${config_files[@]}" "${destination}"

    unset config_files
    unset destination
}

# Install requirements to run this script
do_req () {
    packages=("base-devel" "rsync" "curl" "wget" "git" "makepkg")
    aur_packages=()
    install

    # If use_yay, then check if yay is installed
    # If not, install yay using git and makepkg
    if [ "${use_yay}" = "yes" ]; then
        if ! pacman -Qi yay; then
            aur_install yay
        fi
    fi
}

do_fonts () {
    packages=("ttf-iosevka-nerd")
    aur_packages=("ttf-meslo-nerd-font-powerlevel10k")
    install
}

do_utils () {
    packages=("neofetch" "figlet" "tar" "zip" "unzip" "unrar" "fzf" "thefuck" "figlet")
    aur_packages=("expressvpn")
    install
}

do_vim () {
    # Install packages
    packages=("gvim")
    aur_packages=()
    install

    # Install vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    config_files=("files/.vimrc")
    destination="$HOME/"
    copy

    vim +PlugInstall +qa
}

do_zsh () {
    packages=("zsh")
    aur_packages=()
    install

    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    # Clone zsh-autosuggestions and zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    # Copy configuration files
    config_files=("files/.zshrc" "files/.p10k.zsh")
    destination="$HOME/"
    copy
}

do_alacritty () {
    packages=("alacritty")
    aur_packages=()
    install

    # Copy config files
    config_files=("files/.config/alacritty")
    destination="$HOME/.config/"
    copy
}

do_picom () {
    packages=("picom")
    aur_packages=()

    install

    config_files=("files/.config/compton.conf")
    destination="$HOME/.config/"
    copy
}

do_rofi () {
    packages=("rofi")
    aur_packages=()
    install

    config_files=("files/rofi")
    destination="$HOME/.config/"
    copy
}

do_polybar () {
    packages=("polybar" "procps-ng" "playerctl")
    aur_packages=()
    install

    config_files=("files/.config/polybar")
    destination="$HOME/.config/"
    copy
}

do_i3 () {
    packages=("i3-gaps" "xss-lock" "flameshot" "playerctl" "feh"
                "xorg-setxkbmap" "xorg-xset" "xorg-xrandr" "xorg-xinput" "signal-desktop"
                "discord" "easyeffects" "thunderbird")
    aur_packages=("i3lock-fancy-multimonitor" "xkb-switch" "whatsapp-nativefier" "teams" "spotify" "prospect-mail-bin"
                "megasync-bin")
    install

    config_files=("files/.config/i3")
    destination=("$HOME/.config/")
    copy
}

if [ "${dry_run}" = "yes" ]; then
    rsync_opts+=("-n")
fi


