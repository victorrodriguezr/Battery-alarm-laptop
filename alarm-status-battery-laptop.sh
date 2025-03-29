#!/bin/bash

# Replace BAT0 with your actual battery identifier if different.
# BATTERY_PATH="/sys/class/power_supply/BAT0/capacity"
USER_ID=1000
export XDG_RUNTIME_DIR=/run/user/$USER_ID
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus

# Debugging: Print environment variables
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"

# Read the battery level
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
CHARGING_STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Check if the battery level is greater than or equal to 90
if [[ "$CHARGING_STATUS" == "Charging" ]] && [[ "$BATTERY_LEVEL" -ge 90 ]]; then
  # Send a desktop notification
   /usr/bin/notify-send "Battery Check" "Battery level is $BATTERY_LEVEL%, which is greater than or equal to 90%. Please consider unplugging your charger." -i battery-full-charged
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga
elif [[ "$CHARGING_STATUS" != "Charging" ]] && [[ "$BATTERY_LEVEL" -le 15 ]]; then
  # Send a desktop notification
   /usr/bin/notify-send "Battery Check" "Battery to low, please plug in your computer" -i battery-low
        paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
else
  echo "Battery level is $BATTERY_LEVEL%, no action needed."
fi