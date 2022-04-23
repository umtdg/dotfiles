#!/bin/bash

# Exit on error
set -o errexit
# Exit when undeclared variable is used
set -o nounset

# Colors
export c_default="\033[0m"
export c_blue="\033[1;34m"
export c_magenta="\033[1;35m"
export c_cyan="\033[1;36m"
export c_green="\033[1;32m"
export c_red="\033[1;31m"
export c_yellow="\033[1;33m"

# Echo like ... with flag type and display message colors
prompt() {
  case "${1}" in
  "-s")
      echo -e "  ${c_green}${2}${c_default}"
      ;; # print success message
  "-e")
      echo -e "  ${c_red}${2}${c_default}"
      ;; # print error message
  "-w")
      echo -e "  ${c_yellow}${2}${c_default}"
      ;; # print warning message
  "-i")
      echo -e "  ${c_cyan}${2}${c_default}"
      ;; # print info message
  esac
}

# Show help
helpify_title() {
  printf "${c_cyan}%s${c_blue}%s ${c_green}%s\n\n" "Usage: " "$0" "[OPTIONS...]"
  printf "${c_cyan}%s\n" "OPTIONS:"
}

helpify() {
  printf "  ${c_blue}%s ${c_green}%s\n ${c_magenta}%s. ${c_cyan}%s\n\n${c_default}" "${1}" "${2}" "${3}" "${4}"
}

usage() {
  helpify_title
  helpify "-a --alacritty --term --terminal"  ""    "Install alacritty" ""
  helpify "-z --zsh --shell"                  ""    "Install zsh" ""
  helpify "-i3 -wm --i3-gaps"                 ""    "Install i3-gaps" ""
  helpify "-p --bar --polybar"                ""    "Install polybar" ""
  helpify "-c --compositor --picom"           ""    "Install picom" ""
  helpify "-r --rofi"                         ""    "Install rofi" ""
  helpify "-v --vim --editor"                 ""    "Install vim" ""
  helpify "-f --fonts"                        ""    "Install fonts" ""
  helpify "--gnome"                           ""    "Copy Gnome extensions and terminal profiles" ""
  helpify "--extra"                           ""    "Install additional packages" ""
  helpify "--container"                       ""    "Setup container environment" ""
  helpify "--aur-dir"                         "DIR" "Directory where manually installed AUR packages will be downloaded" "Default is /tmp/aur"
  helpify "--keep-aur"                        ""    "Keep downloaded AUR packages" ""
  helpify "--noyay --no-yay"                  ""    "Do not use yay to install AUR packages" ""
  helpify "-d --dry-run"                      ""    "Dry run" ""
  helpify "-h --help"                         ""    "Show this message and exit" ""
}

# Install options
install_alacritty="no"
install_zsh="no"
install_i3="no"
install_polybar="no"
install_picom="no"
install_rofi="no"
install_vim="no"
install_fonts="no"
install_extra="no"
copy_gnome="no"
setup_container="no"
aur_dir="/tmp/aur"
keep_aur="no"
noyay="no"
dry_run="no"

pacman_opts=("--noconfirm" "--needed")
rsync_opts=("-avAHX")

# Install a single aur package
aur_install() {
  local package_dir="${aur_dir}/$1"

  mkdir -p "${aur_dir}"
  git clone "https://aur.archlinux.org/$1.git" "${aur_dir}/$1"
  pushd "${package_dir}"
  makepkg -si "${pacman_opts[@]}"
  popd
  [[ "${keep_aur}" = "no" ]] rm -rf "${package_dir}"
}

# Install every package in packages and aur_packages
install_packages() {
  prompt -i "Pacman: ${packages[*]}"
  prompt -i "AUR: ${aur_packages[*]}"

  if [ "${noyay}" = "no" ]; then
    prompt -i "Using yay to install AUR packages"
  else
    prompt -i "Manually installing AUR packages"

  if [ "${dry_run}" = "no" ]; then
    if [ "${noyay}" = "no" ]; then
      yay -S "${pacman_opts[@]}" "${packages[@]}" "${aur_packages[@]}"
    else
      sudo pacman -S "${pacman_opts[@]}" "${packages[@]}"
      for pkg in "${aur_packages[@]}"; do
        aur_install "${pkg}"
      done
    fi
  fi

  unset packages
  unset aur_packages
}

# Copy every file in config_files to destination
copy_files() {
  prompt -i "Copying files"
  prompt -i "File list: ${config_files[*]}"
  prompt -i "Destination: ${destination}"
  # prompt -i "Command: rsync ${rsync_opts[@]} ${config_files[@]} ${destination}"

  rsync "${rsync_opts[@]}" "${config_files[@]}" "${destination}"

  unset config_files
  unset destination
}

do_requirements() {
  prompt -i "Installing requirements"

  packages=("base-devel" "rsync" "curl" "wget" "git")
  aur_packages=()

  if [ "${dry_run}" = "no" ]; then
    if [ "${noyay}" = "no" ]; then
      if ! pacman -Qi yay >/dev/null 2>&1; then
        aur_install yay
      fi
    fi
  fi

  install_packages
}

do_alacritty() {
  prompt -i "Installing alacritty"

  packages=("alacritty")
  aur_packages=()
  install_packages

  config_files=("files/.config/alacritty")
  destination="$HOME/.config/"
  copy_files
}

do_zsh() {
  prompt -i "Installing zsh"

  packages=("zsh")
  aur_packages=()

  install_packages

  local ZSH_DIR="$HOME/.oh-my-zsh"
  if [ "${dry_run}" = "no" ]; then
    [[ -d "${ZSH_DIR}" ]] && rm -rf "${ZSH_DIR}"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "${ZSH_CUSTOM:-${ZSH_DIR}/custom}/themes/powerlevel10k"

    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-${ZSH_DIR}/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "${ZSH_CUSTOM:-${ZSH_DIR}/custom}/plugins/zsh-syntax-highlighting"
  else
    prompt -i "Installing oh-my-zsh"
    [[ -d "${ZSH_DIR}" ]] && prompt -i "Removing old oh-my-zsh installation"

    prompt -i "Clone powerlevel10k"
    prompt -i "Clone zsh-autosuggestions"
    prompt -i "Clone zsh-syntax-highlighting"
  fi

  config_files=("files/.zshrc" "files/.p10k.zsh")
  destination="$HOME/"
  copy_files
}

while [[ $# -gt 0 ]];; do
  case "$1" in
    -a|--alacritty|--term|--terminal)
      install_alacritty="yes"
      shift ;;
    -z|--zsh|--shell)
      install_zsh="yes"
      shift ;;
    -i3|-wm|--i3-gaps)
      install_i3="yes"
      shift ;;
    -p|--bar|--polybar)
      install_polybar="yes"
      shift ;;
    -c|--compositor|--picom)
      install_picom="yes"
      shift ;;
    -r|--rofi)
      install_rofi="yes"
      shift ;;
    -v|--vim|--editor)
      install_vim="yes"
      shift ;;
    -f|--fonts)
      install_fonts="yes"
      shift ;;
    --gnome)
      configure_gnome="yes"
      shift ;;
    --extra)
      install_extra="yes"
      shift ;;
    --container)
      setup_container="yes"
      shift ;;
    --aur-dir)
      aur_dir="$2"
      shift 2 ;;
    --keep-aur)
      keep_aur="yes"
      shift ;;
    --noyay|--no-yay)
      noyay="yes"
      shift ;;
    -d|--dry-run)
      dry_run="yes"
      rsync_opts+=("-n")
      shift ;;
    -h|--help)
      usage
      exit 0
    *)
      prompt -e "Unkown option $1"
      usage
      exit 1
    esac
done
