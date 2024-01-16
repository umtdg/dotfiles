#!/bin/bash
blue="%{F#5E81AC}"
red="%{F#BF616A}"

declare -A battery_map=(
   ['10']="󰤾"
   ['20']="󰤿"
   ['30']="󰥀"
   ['40']="󰥁"
   ['50']="󰥂"
   ['60']="󰥃"
   ['70']="󰥄"
   ['80']="󰥅"
   ['90']="󰥆"
   ['100']="󰥈"
)

icon=""
color=''
if bluetoothctl show | grep -q "Powered: yes"; then
    color="$blue"
else
    color="$red"
fi

icon="${color}${icon}"
output="$icon"
dev_mac="$(bluetoothctl info | grep 'Device' | cut -d' ' -f2)"
if [ "$dev_mac" != '(null)' ]; then
    percentage="$(bluetoothctl info | grep 'Battery Percentage' | cut -d'(' -f2 | cut -d ')' -f1)"
    percentage="$(awk -v n="$percentage" 'BEGIN{print int(n / 10) * 10}')"
    battery="${battery_map[$percentage]}"

    output="$icon $battery $percentage%"
fi

echo "$output"

