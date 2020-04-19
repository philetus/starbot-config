#!/bin/bash

date_formatted=$(date "+%a %Y-%m-%d %H:%M:%S")

battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)
if [ $battery_status = "Discharging" ];
then
    battery_emoji='⚡🔋'
else
    battery_emoji='⚡🔌'
fi

echo "${battery_percentage}%${battery_emoji} ${date_formatted}"