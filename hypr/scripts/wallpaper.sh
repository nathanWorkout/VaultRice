#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/gruvbox"

CHOSEN=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) \
  | xargs -I{} basename {} \
  | sort \
  | rofi -dmenu -theme ~/.config/rofi/type-2/style-7.rasi -p "Wallpaper : ")

[ -z "$CHOSEN" ] && exit 0

awww img "$WALLPAPER_DIR/$CHOSEN" --transition-type wave --transition-duration 1
