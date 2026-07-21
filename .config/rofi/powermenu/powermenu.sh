#!/usr/bin/env bash
# vim: ts=4 sts=4 sw=4 et
#
# Author: Aditya Shakya
# Mail: adi1090x@gmail.com
# Github  : @adi1090x
# Twitter : @adi1090x
#
# Created and tested on : rofi 1.6.0-1

theme="style"
dir="$HOME/.config/rofi/powermenu"

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock="󰌾"
logout=""

# Confirmation
confirm_exit() {
    rofi -dmenu \
        -i \
        -no-fixed-num-lines \
        -p "Are You Sure?: " \
        -theme "$dir/confirm.rasi"
}

confirm_and_take_action() {
    ans=$(confirm_exit &)
    if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
        "$@"
    elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
        exit 0
    fi
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$logout"

choice="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case $choice in
    "$shutdown")
        confirm_and_take_action systemctl poweroff
        ;;
    "$reboot")
        confirm_and_take_action systemctl reboot
        ;;
    "$lock")
        swaylock -e -f -i "$HOME/.lock.png"
        ;;
    "$logout")
        confirm_and_take_action swaymsg exit
        ;;
esac
