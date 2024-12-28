# dotfiles

My dotfiles using [yadm](https://github.com/TheLocehiliosan/yadm)

Rofi configuration is stripped from [here](https://github.com/adi1090x/rofi)

```
OS: Arch Linux
WM: i3-gaps + polybar
Compositor: picom
Shell: zsh
Terminal: alacritty
Editor: LunarVim
Notification Daemon: dunst
Theme: Orchis Dark
Icons: Papirus Dark
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
$ yadm clone https://umtdg.com/dotfiles.git
```

### Yadm Bootstrap

There are script to somewhat automate package installation and configuration under `~/.config/yadm/bootstrap.d`.
There is also a script `~/.config/yadm/bootstrap` which runs each script in `~/.config/yadm/bootstrap.d` alphabetically
but I haven't tested it yet.

- `10-install.sh` - Installs all packages in `packages.txt`
- `11-install-aur.sh` - Installs [yay]() from AUR and installs all packages in `packages.aur.txt`
- `20-configure.sh` - Helpful script to eliminate some manual configuration.
    Do `h<Enter>` or `help<Enter>` inside the script to see what is available.

## Helpful Scripts

- `adwaita_theme.sh` - GTK-3/4 theme changer for Adwaita
- `end-sudo-session` - Force sudo to require password again
- `fanc` - Fan control through `/proc/acpi/ibm/fan`
- `ffmpeg_bulk_convert` - Bulk convert media files in directory while keeping the directory structure
- `mountbtrfs` - Mount btrfs volume with pre-set options
- `mountntfs` - Mount ntfs volume with pre-set options
- `mountvera` - Mount/Umount/List VeraCrypt containers in specified directory
- `net_failover` - Continuously check network failures by pinging gateway address and use
    NetworkManager to disconnect and reconnect or send an arping to gateway
- `randomhex` - Generate random string of given length using lowercase letters and numbers from `/dev/urandom`
- `randompass` - Generate random string of given length using uppercase, lowercase letters, numbers and special symbols from `/dev/urandom`
- `shred-rec` - Shred directory recursively
- `sort-by-size` - Display top 10 largest files/directories in a directory
- `yaycache` - Do `paccache` on both pacman cache and yay cache

## License

Licensed under [MIT](https://github.com/umtdg/dotfiles/blob/main/LICENSE)
