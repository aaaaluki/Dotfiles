#!/bin/sh
# https://wiki.archlinux.org/index.php/awesome#Autostart

function run {
  if ! pgrep -f $1 1>/dev/null ;
  then
    $@ 1>/dev/null &
  fi
}

# Set keyboard layout
run setxkbmap -layout "es"
run numlockx

# run compositor
run compton

# caffeine - don't autolock if video is playing
run caffeine

# fusuma use gestures
run fusuma

# screen settings (multimonitor, wallpaper)
run dm-background-checker
run autorandr -c
