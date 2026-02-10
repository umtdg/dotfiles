# dotfiles

My dotfiles using [yadm](https://github.com/TheLocehiliosan/yadm)

Rofi configuration is stripped from [here](https://github.com/adi1090x/rofi)

```
OS: Arch Linux
WM: Sway (wlroots)
Shell: zsh
Terminal: alacritty
Editor: Neovim
Launcher: rofi
Notification Daemon: dunst
Theme: Breeze Dark
Icons: Breeze Dark
Cursor: Breeze
Font: Noto Sans, Iosevka Nerd Fonts
```

## Installation

Install `yadm` using:
```
# pacman -S yadm
```

or if you have problems with wrongly recognized or not recognized alternative files due to `lsb-release`, use:
```
$ git clone -b prioritize_os_release https://github.com/umtdg/yadm.git
$ cd yadm
# install -Dm 755 yadm /usr/bin/yadm
```

Then do
```
$ yadm clone https://github.com/umtdg/dotfiles.git
```

### Yadm Bootstrap

Use the [bootstrap](https://github.com/umtdg/dotfiles/blob/main/.config/yadm/bootstrap) file to install
packages in [packages.txt](https://github.com/umtdg/dotfiles/blob/main/.config/yadm/packages.txt) and
[packages.aur.txt](https://github.com/umtdg/dotfiles/blob/main/.config/yadm/packages.aur.txt). The script
will also configure:
- Icon theme: TODO: this is not needed as of switching to `breeze`
- GTK theme: Sets `gtk-theme` and `color-scheme` using `gsettings`
- SDDM: Sets `Background=`, copies the config file to, and enables `sddm.service`
- ZSH: Links plugins installed using `pacman` or `yay` to `oh-my-zsh` custom location and changes current
  user's shell
- VIM: Runs `vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'` to initialize `vim-plug` and install plugins
- Nvim: Clone [my Neovim config](https://github.com/umtdg/nvim)
- Services: Enables and starts the following services:
    - `vmware-networks-configuration.service`
    - `vmware-networks.service`
    - `vmware-usbarbitrator.service`
    - `pipewire.service`
    - `pipewire-pulse.service`
    - `bluetooth.service`
- X11: Creates XDG home directories
- ENV: Sets some needed global environment variables in `/etc/environment`:
    - `XDG_CONFIG_HOME=\"/home/$USER/.config\"`
    - `XDG_CACHE_HOME=\"/home/$USER/.cache\"`
    - `XDG_DATA_HOME=\"/home/$USER/.local/share\"`
    - `XDG_STATE_HOME=\"/home/$USER/.local/state\"`
    - `XDG_DATA_DIRS="/usr/local/share:/usr/share"`
    - `XDG_CONFIG_DIRS="/etc/xdg"`
    - `ELECTRON_OZONE_PLATFORM_HINT=wayland`
    - `QT_QPA_PLATFORM=wayland`
    - `QT_QPA_PLATFORMTHEME=qt6ct`
- PAM: Adds `pam_gnome_keyring.so` to `auth` and `session`
- /mnt: Creates and sets permissions of mountpoints
- fstab: Adds internal drives to `/etc/fstab` only for a single pc
- makepkg: Enable `ccache`, set packager variables and set source/package directories to a common directory
- Docker: Adds current user to `docker` group
- Spotify: Install Spotify using `spotify-launcher` and change its arguments to use wayland

## Helpful Scripts

- `adwaita_theme.sh` - GTK-3/4 theme changer for Adwaita
- `end-sudo-session` - Force sudo to require password again
- `fanc` - Fan control for Lenovo/IBM through `/proc/acpi/ibm/fan`
- `ffmpeg_bulk_convert` - Bulk convert media files in directory while keeping the directory structure
- `mountssd500` - Mount/Unmount an external drive with one NTFS and one BTRFS filesystem.
- `mountvera` - Mount/Umount/List VeraCrypt containers in specified directory
- `net_failover` - Continuously check network failures by pinging gateway address and use
  NetworkManager to disconnect and reconnect or send an arping to gateway
- `randomhex` - Generate random string of given length using lowercase letters and numbers from `/dev/urandom`
- `randompass` - Generate random string of given length using uppercase, lowercase letters, numbers and special symbols   from `/dev/urandom`
- `sort-by-size` - Display top 10 largest files/directories in a directory
- `webapp-install` - The same script as [omarchy-webapp-install](https://github.com/basecamp/omarchy/blob/dev/bin/omarchy-webapp-install)
- `webapp-launch` - The same script as [omarchy-launch-webapp](https://github.com/basecamp/omarchy/blob/dev/bin/omarchy-launch-webapp)

## License

Licensed under [MIT](https://github.com/umtdg/dotfiles/blob/main/LICENSE)
