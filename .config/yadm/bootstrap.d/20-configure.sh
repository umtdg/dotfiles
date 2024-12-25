#!/usr/bin/env bash

source common.sh

function configure_icon_theme() {
  log -i "Configuring icon and cursor theme"

  log -i "Creating directories"
  icons_dir="$HOME/.icons"
  mkdir -p "$icons_dir"

  log -w "Manually download Sweet Cursors from 'https://www.gnome-look.org/p/1393084' and enter the file path"
  read -r -p "Path to downloaded file (leave empty to skip): " archive_path

  if [ -n "$archive_path" ]; then
    log -i "Installing Sweet Cursors from archive $archive_path"
    tar -xvf "$archive_path" -C "$icons_dir"
    ln -sfv "$icons_dir/Sweet-cursors/index.theme" "$icons_dir/default/index.theme"
  fi
}

function configure_gtk_theme() {
  log -i "Changing Adwaita theme to Orchis-Dark"
  "$HOME/bin/adwaita_theme.sh" -f -t Orchis-Dark
}

function configure_sddm() {
  log -i "Enabling SSDM service"
  sudo systemctl enable sddm.service

  sddm_themes_dir='/usr/share/sddm/themes'
  log -w "Manually download Sugar Candy SDDM theme from 'https://store.kde.org/p/1312658' and enter the file path"
  read -r -p "Path to downloaded file (leave empty to skip): " archive_path

  if [ -n "$archive_path" ]; then
    log -i "Installing SDDM theme from archive $archive_path"
    sudo tar -xvf "$archive_path" -C "$sddm_themes_dir"

    log -i "Changing SDDM theme background"
    HOME_ESCAPED=${HOME//\//\\\/};
    sudo sed -i "s/^Background=\(.*\)$/Background=\"$HOME_ESCAPED\/.background\"/g" "$sddm_themes_dir/"

    log -i "Copying SDDM config"
    sudo install -Dm 644 -t /etc/sddm.conf.d ~/sddm.conf.d/*
  fi
}

function configure_libinput() {
  if [[ "$HOSTNAME" == 'naboo' ]]; then
    log -i "Creating libinput config for touchpad"
    file='/etc/X11/xorg.conf.d/30-touchpad.conf'
    {
      echo 'Section "InputClass"'
      echo "    Identifier \"$(sudo libinput list-devices | grep -i '^device:.*touchpad' | cut -d: -f2 | xargs)\""
      echo '    Driver "libinput"'
      echo '    Option "Tapping" "on"'
      echo '    Option "NaturalScrolling" "true"'
      echo 'EndSection'
    } | sudo tee -a "$file"
  fi
}

function configure_zsh() {
  zsh_custom_dir="${ZSH_CUSTOM:-/usr/share/oh-my-zsh/custom}"
  zsh_theme='powerlevel10k'
  zsh_plugins=('zsh-autosuggestions' 'zsh-syntax-highlighting' 'zsh-fzf-plugin')

  log -i "Installing ZSH theme '$zsh_theme' and plugins ${zsh_plugins[*]} to $zsh_custom_dir"
  sudo ln -sfv "/usr/share/zsh-theme-$zsh_theme" "$zsh_custom_dir/themes/$zsh_theme"
  for plugin in "${zsh_plugins[@]}"; do
    sudo ln -sfv "/usr/share/zsh/$plugin" "$zsh_custom_dir/plugins/$plugin"
  done

  log -i "Changing $USER's shell"
  sudo chsh -s /usr/bin/zsh "$USER"
}

function configure_vim() {
  log -i "Vim first run"
  vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'

  log -i "Install LunarVim Nightly"
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
}

function configure_docker() {
  log -i "Adding $USER to docker group"
  sudo usermod -aG docker "$USER"
}

function configure_vmware() {
  log -i "Enabling VmWare network and usbarbitrator services"
  sudo systemctl enable --now \
    vmware-networks-configuration.service \
    vmware-networks.service \
    vmware-usbarbitrator.service
}

configure_libinput
configure_icon_theme
configure_gtk_theme
configure_zsh
