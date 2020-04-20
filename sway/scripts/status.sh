#!/bin/bash

date_formatted=$(date "+%a %Y-%m-%d %H:%M:%S")

battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)
if [ $battery_status = "Discharging" ]
then
    battery_emoji='⚡🔋'
else
    battery_emoji='⚡🔌'
fi

# network status
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# grabs the "old" interface name before systemd renamed it
interface=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
access_point=$(wpa_cli status | awk -F= '($1=="ssid") {print $2}')

ping=$( \
  ping -c 1 google.com \
  | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1 \
)

if [ $network ]
then
  if [ $access_point ]
  then
    network_status="${access_point} ${ping} 🌎"
  else
    network_status="${interface} ${ping} 🌎"
  fi
else
  network_status="🌵"
fi

brightness="$(light | awk -F. '{print $1}') 🌞"

volume="$(pactl list sinks | grep '^[[:space:]]Volume:' | \
  head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' \
) 🔊"

muted=$(pacmd list-sinks | awk '($1=="muted:") {print $2}')

if [ $muted == "yes" ]
then
  volume="🔇"
fi

echo "$network_status | ${brightness} | ${battery_percentage} ${battery_emoji} | $volume | ${date_formatted}"
