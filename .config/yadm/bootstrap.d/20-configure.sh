#!/usr/bin/env bash

source common.sh

# TODO: Find a way to automatically download Sweet Cursors
function configure_icon_theme() {
  log -i "Configuring icon and cursor theme"

  log -i "Creating directories"
  icons_dir="$HOME/.icons"
  mkdir -pv "$icons_dir"

  log -w "Manually download Sweet Cursors from 'https://www.gnome-look.org/p/1393084' and enter the file path"
  read -r -p "Path to downloaded file (leave empty to skip): " archive_path

  if [ -n "$archive_path" ]; then
    log -i "Installing Sweet Cursors from archive $archive_path"
    tar -xvf "$archive_path" -C "$icons_dir"

    mkdir -pv "$icons_dir/default"
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

  log -i "Changing SDDM theme background"
  sddm_themes_dir='/usr/share/sddm/themes'
  sudo install -Dm 644 ~/.background "$sddm_themes_dir/Backgrounds/Background.png"
  sudo sed -i "s/^Background=\(.*\)$/Background=\"Background.png\"/g" "$sddm_themes_dir/Sugar-Candy/theme.conf"

  log -i "Copying SDDM config"
  sudo install -Dm 644 -t /etc/sddm.conf.d ~/sddm.conf.d/*
}

function configure_zsh() {
  zsh_custom_dir="${ZSH_CUSTOM:-/usr/share/oh-my-zsh/custom}"
  zsh_theme='powerlevel10k'
  zsh_plugins=('zsh-autosuggestions' 'zsh-syntax-highlighting' 'zsh-fzf-plugin')

  log -i "Installing ZSH theme '$zsh_theme' and plugins ${zsh_plugins[*]} to $zsh_custom_dir"
  sudo ln -sfv "/usr/share/zsh-theme-$zsh_theme" "$zsh_custom_dir/themes/$zsh_theme"
  for plugin in "${zsh_plugins[@]}"; do
    sudo ln -sfv "/usr/share/zsh/plugins/$plugin" "$zsh_custom_dir/plugins/$plugin"
  done

  log -i "Changing $USER's shell"
  sudo chsh -s /usr/bin/zsh "$USER"
}

function configure_vim() {
  log -i "Vim first run"
  vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
}

function configure_docker() {
  log -i "Adding $USER to docker group"
  sudo usermod -aG docker "$USER"
}

function configure_services() {
  log -i "Enabling and starting vmware-networks service"
  sudo systemctl enable --now vmware-networks.service

  log -i "Enabling and starting vmware-networks-configuration service"
  sudo systemctl enable --now vmware-networks-configuration.service

  log -i "Enabling and starting Vmware vmware-usbarbitrator"
  sudo systemctl enable --now vmware-usbarbitrator.service

  log -i "Enabling and starting pipewire service"
  systemctl --user enable --now pipewire

  log -i "Enabling and starting pipewire-pulse service"
  systemctl --user enable --now pipewire-pulse

  log -i "Enabling and starting bluetooth service"
  sudo systemctl enable --now bluetooth
}

function configure_x11() {
  log -i "Creating XDG user directories"
  xdg-user-dirs-update --force
}

function configure_env() {
  log -i 'Configuring /etc/environment'
  {
    echo "XDG_CONFIG_HOME=\"/home/$USER/.config\""
    echo "XDG_CACHE_HOME=\"/home/$USER/.cache\""
    echo "XDG_DATA_HOME=\"/home/$USER/.local/share\""
    echo "XDG_STATE_HOME=\"/home/$USER/.local/state\""
    echo
    echo 'XDG_DATA_DIRS="/usr/local/share:/usr/share"'
    echo 'XDG_CONFIG_DIRS="/etc/xdg"'
    echo
    echo 'ELECTRON_OZONE_PLATFORM_HINT=wayland'
    echo 'QT_QPA_PLATFORM=wayland'
  } | sudo tee -a /etc/environment
}

function configure_pam() {
  log -i 'Configure pam_gnome_keyring.so'

  declare pam_file=/etc/pam.d/login
  if grep -iq pam_gnome_keyring.so "$pam_file"; then
    log -i "pam_gnome_keyring.so is already in $pam_file"
    return
  fi

  {
    echo
    echo 'auth       optional     pam_gnome_keyring.so'
    echo 'session    optional     pam_gnome_keyring.so auto_start'
  } | sudo tee -a "$pam_file"
}

function configure_mnt() {
  log -i 'Creating common mount points'
  sudo mkdir -pv /mnt/{backup,sandisk,ssd500/{ntfs,btrfs}}

  log -i 'Setting ownership of ntfs/btrfs mount points'
  sudo chown -R "$USER:$USER" /mnt/ssd500/ntfs
  sudo chown -R "$USER:$USER" /mnt/ssd500/btrfs

  if [[ "$HOSTNAME" == 'tatooine' ]]; then
    log -i "Creating host ($HOSTNAME) specific mount points"
    sudo mkdir -pv /mnt/{localdisk,windows}

    log -i 'Setting ownership of ntfs/btrfs mount points'
    sudo chown -$ "$USER:$USER" /mnt/localdisk
    sudo chown -$ "$USER:$USER" /mnt/windows
  fi
}

function configure_fstab() {
  if [[ "$HOSTNAME" == 'tatooine' ]]; then
    log -i 'Appending auto-mounts to fstab'
    {
      echo
      echo '# 2 TiB Seagate'
      echo 'UUID=0698E25298E23FB3 /mnt/localdisk ntfs rw,relatime,nofail,exec,x-gvfs-show,uid=1000,gid=1000,umask=022 0 0'
    } | sudo tee -a /etc/fstab

    {
      echo
      echo '# Windows'
      echo 'UUID=4E023FFA023FE61D /mnt/windows   ntfs rw,relatime,nofail,exec,x-gvfs-show,uid=1000,gid=1000,umask=022 0 0'
    } | sudo tee -a /etc/fstab
  fi
}

# TODO: Install spotify via spotify-launcher and create a desktop entry to run via wayland
function configure_spotify() {
}

configure_mnt
configure_fstab
configure_env
configure_pam
configure_services

configure_sddm
configure_icon_theme 
configure_gtk_theme 
configure_x11

configure_zsh
configure_vim
configure_docker
