#!/usr/bin/env bash
set -euo pipefail

THEME="${1:?}"
WALL="${2:-}"
THEME_DIR="$HOME/.config/themes/$THEME"
COLORS="$THEME_DIR/colors.css"

[[ -d "$THEME_DIR" ]] || exit 1

# Waybar
sed -i "s|@import \".*\"; /\* theme \*/|@import \"$THEME_DIR/waybar.css\"; /* theme */|" "$HOME/.config/waybar/style.css"

# Rofi
sed -i "s|@import \".*\" /\* theme \*/|@import \"$THEME_DIR/rofi.rasi\" /* theme */|" "$HOME/.config/rofi/type-2/shared/colors.rasi"

# Swaync
sed -i "s|@import \".*\"; /\* theme \*/|@import \"$THEME_DIR/swaync.css\"; /* theme */|" "$HOME/.config/swaync/style.css"

# Starship
cp "$HOME/.config/starship/starship.toml.tpl" "$HOME/.config/starship.toml"
while IFS='=' read -r key val; do
    [[ -n "$key" && -n "$val" ]] || continue
    sed -i "s|$key|$val|g" "$HOME/.config/starship.toml"
done < "$COLORS"

# Hyprland
cp "$HOME/.config/hypr/modules/decorations.lua.tpl" "$HOME/.config/hypr/modules/decorations.lua"
while IFS='=' read -r key val; do
    [[ -n "$key" && -n "$val" ]] || continue
    sed -i "s|$key|$val|g" "$HOME/.config/hypr/modules/decorations.lua"
done < "$COLORS"
hyprctl reload

# Quickshell
cp "$HOME/.config/quickshell/theme-switcher/shell.qml.tpl" "/tmp/shell.qml.tmp"
while IFS='=' read -r key val; do
    [[ -n "$key" && -n "$val" ]] || continue
    sed -i "s|$key|$val|g" "/tmp/shell.qml.tmp"
done < "$COLORS"
mv "/tmp/shell.qml.tmp" "$HOME/.config/quickshell/theme-switcher/shell.qml"

# Wallpaper
[[ -f "$WALL" ]] && awww img "$WALL" --transition-type wave --transition-duration 1 &

# Reload
pkill -SIGUSR2 waybar 2>/dev/null || { pkill waybar 2>/dev/null; sleep 0.2; waybar &>/dev/null & }
swaync-client --reload-css
