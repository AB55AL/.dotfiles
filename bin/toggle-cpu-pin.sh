#!/bin/sh

p=$(nproc)
if [ $p = 12 ]; then
  sudo systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,2,6,7,8
  sudo systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,2,6,7,8
  sudo systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,2,6,7,8
  notify-send -t 3000 CPUs "$(nproc)"
elif [ $p = 6 ]; then
  sudo systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
  sudo systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
  sudo systemctl set-property --runtime -- init.scope AllowedCPUs=0-11
  notify-send -t 3000 CPUs "$(nproc)"
fi

