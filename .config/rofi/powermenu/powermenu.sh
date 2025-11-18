#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# column_circle     column_square     column_rounded     column_alt
# card_circle     card_square     card_rounded     card_alt
# dock_circle     dock_square     dock_rounded     dock_alt
# drop_circle     drop_square     drop_rounded     drop_alt
# full_circle     full_square     full_rounded     full_alt
# row_circle      row_square      row_rounded      row_alt

theme="card_circle"
dir="$HOME/.config/rofi/powermenu"

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock="󰌾"
logout=""

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme "$dir/confirm.rasi"
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case $chosen in
    "$shutdown")
      ans=$(confirm_exit &)
      if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
        systemctl poweroff
      elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
        exit 0
      fi
      ;;
    "$reboot")
      ans=$(confirm_exit &)
      if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
        systemctl reboot
      elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
        exit 0
      fi
      ;;
    "$lock")
      swaylock -e -f -i $HOME/.lock.png
      ;;
    "$logout")
      ans=$(confirm_exit &)
      if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
        swaymsg exit
      elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
        exit 0
      fi
      ;;
esac
