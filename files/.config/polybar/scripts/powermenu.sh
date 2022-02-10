#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
logout=" Logout"

# Confirmation
confirm_exit() {
    icon="<span font_size=\"medium\">$1</span>"
    text="<span font_size=\"medium\">$2</span>"
    echo -n "\u200e$icon \u2068$text\u2069"
	# rofi -dmenu\
	# 	-i\
	# 	-no-fixed-num-lines\
	# 	-p "Are You Sure? : "
}

# Variable passed to rofi
options="$lock\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -i -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl poweroff
        else
			exit 0
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl reboot
        else
			exit 0
        fi
        ;;
    $lock)
        ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			i3lock-fancy-multimonitor --blur=0x16
        else
			exit 0
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            i3-msg exit
        else
			exit 0
        fi
        ;;
esac

