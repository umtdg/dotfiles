#!/usr/bin/env bash

source common.sh

function configure_yay() {
  yay_path='/usr/bin/yay'
  aur_url='https://aur.archlinux.org/yay.git'

  log -i "Install and configure yay"
  [[ -f "$yay_path" ]] && { log -i "yay is already installed"; return 0; }

  log -i "Cloning yay"
  tempdir="$(mktemp -d)"
  git clone -q "$aur_url" "$tempdir"

  pushd "$tempdir" >/dev/null 2>&1 || { log -e "Failed to change directory to $tempdir"; return 1; }
  log -i "Build and install yay"
  makepkg -si --needed --noconfirm || { log -e "Failed to build and install yay"; return 1; }
  popd >/dev/null 2>&1 || { log -e "Failed to exit directory $tempdir"; return 1; }

  rm -rf "$tempdir"

  log -i "Copying pacman hooks"
  sudo install -Dm 644 -t /etc/pacman.d/hooks ~/pacman_hooks/*.hook || \
    { log -e "Failed to copy pacman hooks"; return 1; }

  log -i "Enabling --combinedupgrade option for yay"
  yay --save \
    --combinedupgrade \
    --cleanmenu=false \
    --diffmenu=false \
    --editmenu=false \
    --cleanafter=false
}

configure_yay

log -i "Installing AUR packages"
yay "${pacman_opts[@]}" - < packages.aur.txt
