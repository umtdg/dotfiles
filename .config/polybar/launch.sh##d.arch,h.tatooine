#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for hwmon in /sys/class/hwmon/hwmon*; do
    hwmon_name=$(cat "$hwmon/name")
    case $hwmon_name in
        # amdgpu) HWMON_PATH_GPU="$hwmon" ;;
        nvme) HWMON_PATH_NVME="$hwmon" ;;
        nct6799) HWMON_PATH_MOBO_NCT="$hwmon" ;;
        k10temp) HWMON_PATH_K10TEMP="$hwmon" ;;
        asusec) HWMON_PATH_ASUSEC="$hwmon" ;;
        iwlwifi_1) HWMON_PATH_IWLWIFI="$hwmon" ;;
        *) ;;
    esac
done

export MOBOTEMP="$HWMON_PATH_MOBO_NCT/temp1_input"

export CPUTEMP="$HWMON_PATH_K10TEMP/temp1_input"
export CPUFAN_1="cat $HWMON_PATH_MOBO_NCT/fan4_input"
export CPUFAN_2="cat $HWMON_PATH_MOBO_NCT/fan2_input"

# export GPUTEMP="$HWMON_PATH_GPU/temp1_input"
# export GPUFAN="$HWMON_PATH_GPU/fan1_input"

export NVME_COMP="$HWMON_PATH_NVME/temp1_input"
export NVME_1="$HWMON_PATH_NVME/temp2_input"
export NVME_2="$HWMON_PATH_NVME/temp3_input"

polybar --reload mainbar &
MONITOR=HDMI-0 polybar --reload secondbar &
MONITOR=HDMI-1 polybar --reload secondbar &

