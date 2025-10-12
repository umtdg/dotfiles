#!/usr/bin/env bash

source common.sh

function usage() {
  echo 'l | libinput  configure libinput'
  echo 'i | icon      configure icon theme'
  echo 'g | gtk       configure gtk theme'
  echo 's | sddm      configure sddm'
  echo 'z | zsh       configure zsh'
  echo 'v | vim       configure vim'
  echo 'd | docker    configure docker'
  echo 'S | services  enable and start required systemctl services'
  echo 'x | x11       configure X11'
  echo 'h | help      show this help message and exit'
}

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
  HOME_ESCAPED=${HOME//\//\\\/};
  sudo sed -i "s/^Background=\(.*\)$/Background=\"$HOME_ESCAPED\/.background\"/g" "$sddm_themes_dir/Sugar-Candy/theme.conf"

  log -i "Copying SDDM config"
  sudo install -Dm 644 -t /etc/sddm.conf.d ~/sddm.conf.d/*
}

# TODO: This should be changed to adapt the new fixed configuration
function configure_libinput() {
  file='/etc/X11/xorg.conf.d/30-touchpad.conf'
  if [[ "$HOSTNAME" == 'naboo' ]] && ! grep -iq 'Section "InputClass"' "$file"; then
    log -i "Creating libinput config for touchpad"
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

declare -A commands=(
  ['l']='configure_libinput'
  ['libinput']='configure_libinput'
  ['i']='configure_icon_theme'
  ['icon']='configure_icon_theme'
  ['g']='configure_gtk_theme'
  ['gtk']='configure_gtk_theme'
  ['s']='configure_sddm'
  ['sddm']='configure_sddm'
  ['z']='configure_zsh'
  ['zsh']='configure_zsh'
  ['v']='configure_vim'
  ['vim']='configure_vim'
  ['d']='configure_docker'
  ['docker']='configure_docker'
  ['S']='configure_services'
  ['service']='configure_services'
  ['x']='configure_x11'
  ['x11']='configure_x11'
)

while true; do
  read -r -p 'configure> ' choice

  if [ -n "${commands[$choice]}" ]; then
    "${commands[$choice]}"
    continue
  fi

  case "$choice" in
    h|help) usage; ;;
    q|quit) exit 0; ;;
    *) echo "Unkown option: $choice"; exit 1; ;;
  esac
done

