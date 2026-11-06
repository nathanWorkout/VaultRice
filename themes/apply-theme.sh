#!/usr/bin/env bash
set -euo pipefail

THEME="${1:?}"
WALL="${2:-}"
THEME_DIR="$HOME/.config/themes/$THEME"

[[ -d "$THEME_DIR" ]] || exit 1

# Waybar
sed -i "s|@import \".*\"; /\* theme \*/|@import \"$THEME_DIR/waybar.css\"; /* theme */|" "$HOME/.config/waybar/style.css"

# Rofi
sed -i "s|@import \".*\" /\* theme \*/|@import \"$THEME_DIR/rofi.rasi\" /* theme */|" "$HOME/.config/rofi/type-2/shared/colors.rasi"

# Swaync
sed -i "s|@import \".*\"; /\* theme \*/|@import \"$THEME_DIR/swaync.css\"; /* theme */|" "$HOME/.config/swaync/style.css"

# Starship — sed sur chaque variable du fichier couleurs
STARSHIP_COLORS="$THEME_DIR/starship.css"
STARSHIP_TPL="$HOME/.config/starship/starship.toml.tpl"
STARSHIP_OUT="$HOME/.config/starship.toml"

cp "$STARSHIP_TPL" "$STARSHIP_OUT"
while IFS='=' read -r key val; do
    [[ -n "$key" && -n "$val" ]] || continue
    sed -i "s|$key|$val|g" "$STARSHIP_OUT"
done < "$STARSHIP_COLORS"

# Hyprland decorations
HYPR_COLORS="$THEME_DIR/hyprland.css"
HYPR_TPL="$HOME/.config/hypr/modules/decorations.lua.tpl"
HYPR_OUT="$HOME/.config/hypr/modules/decorations.lua"

cp "$HYPR_TPL" "$HYPR_OUT"
while IFS='=' read -r key val; do
    [[ -n "$key" && -n "$val" ]] || continue
    sed -i "s|$key|$val|g" "$HYPR_OUT"
done < "$HYPR_COLORS"

hyprctl reload

# Wallpaper
[[ -f "$WALL" ]] && awww img "$WALL" --transition-type wave --transition-duration 1 &

# Reload
pkill -SIGUSR2 waybar 2>/dev/null || { pkill waybar 2>/dev/null; sleep 0.2; waybar &>/dev/null & }
swaync-client --reload-css
