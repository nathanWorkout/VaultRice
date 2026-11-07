#!/usr/bin/env bash
set -euo pipefail

THEME="${1:?}"
WALL="${2:-}"
THEME_DIR="$HOME/.config/themes/$THEME"
COLORS="$THEME_DIR/colors.css"
ZATHURA_CONFIG="$HOME/.config/zathura/zathurarc"

[[ -d "$THEME_DIR" ]] || exit 1
[[ -f "$COLORS" ]] || exit 1
printf '%s\n' "$THEME" > "$HOME/.config/themes/current"

render_style_if_missing() {
    local target="$1"
    local template="$2"

    [[ -f "$target" ]] && return
    cp "$template" "$target"
    while IFS='=' read -r key val; do
        [[ -n "$key" && -n "$val" ]] || continue
        sed -i "s|$key|$val|g" "$target"
    done < "$COLORS"
}

render_style_if_missing "$THEME_DIR/waybar.css" "$HOME/.config/themes/templates/waybar.css.tpl"
render_style_if_missing "$THEME_DIR/rofi.rasi" "$HOME/.config/themes/templates/rofi.rasi.tpl"
render_style_if_missing "$THEME_DIR/swaync.css" "$HOME/.config/themes/templates/swaync.css.tpl"
render_style_if_missing "$THEME_DIR/zathura.conf" "$HOME/.config/themes/templates/zathura.conf.tpl"

KDE_COLOR_SCHEME="$HOME/.local/share/color-schemes/$THEME.colors"
mkdir -p "$(dirname "$KDE_COLOR_SCHEME")"
cp "$HOME/.config/themes/templates/kde-colors.colors.tpl" "$KDE_COLOR_SCHEME"
while IFS='=' read -r key val; do
    case "$key" in
        QBG|QBGALT|QFG|QACCENT|ACCENT_FG|ERROR)
            hex="${val#\#}"
            printf -v red '%d' "0x${hex:0:2}"
            printf -v green '%d' "0x${hex:2:2}"
            printf -v blue '%d' "0x${hex:4:2}"
            rgb="$red,$green,$blue"
            sed -i "s|RGB_$key|$rgb|g" "$KDE_COLOR_SCHEME"
            ;;
    esac
done < "$COLORS"
sed -i "s|THEME_NAME|$THEME|g" "$KDE_COLOR_SCHEME"
KDE_GLOBALS="$HOME/.config/kdeglobals"
kwriteconfig6 --file "$KDE_GLOBALS" --group General --key ColorScheme "$THEME"
kwriteconfig6 --file "$KDE_GLOBALS" --group Icons --key Theme breeze-dark
group=""
while IFS= read -r line; do
    case "$line" in
        \[*\])
            group="${line#\[}"
            group="${group%\]}"
            ;;
        *=*)
            if [[ "$group" == Colors:* || "$group" == WM ]]; then
                key="${line%%=*}"
                val="${line#*=}"
                kwriteconfig6 --file "$KDE_GLOBALS" --group "$group" --key "$key" "$val"
            fi
            ;;
    esac
done < "$KDE_COLOR_SCHEME"

QT6CT_COLORS="$HOME/.config/qt6ct/colors"
QT6CT_PALETTE="$QT6CT_COLORS/$THEME.conf"
mkdir -p "$QT6CT_COLORS"
cp "$HOME/.config/themes/templates/qt6ct-palette.conf.tpl" "$QT6CT_PALETTE"
while IFS='=' read -r key val; do
    case "$key" in
        QBG|QBGALT|QFG|QACCENT|ACCENT_FG)
            color="#ff${val#\#}"
            sed -i "s|$key|$color|g" "$QT6CT_PALETTE"
            ;;
    esac
done < "$COLORS"
kwriteconfig6 --file "$HOME/.config/qt6ct/qt6ct.conf" --group Appearance --key style Fusion
kwriteconfig6 --file "$HOME/.config/qt6ct/qt6ct.conf" --group Appearance --key custom_palette true
kwriteconfig6 --file "$HOME/.config/qt6ct/qt6ct.conf" --group Appearance --key color_scheme_path "$QT6CT_PALETTE"
QT6CT_QSS_DIR="$HOME/.config/qt6ct/qss"
QT6CT_QSS="$QT6CT_QSS_DIR/rice.qss"
mkdir -p "$QT6CT_QSS_DIR"
cp "$HOME/.config/themes/templates/qt6ct.qss.tpl" "$QT6CT_QSS"
while IFS='=' read -r key val; do
    case "$key" in
        QBGALT|QBG|QFG|QACCENT|ACCENT_FG|DIR_BG)
            sed -i "s|$key|$val|g" "$QT6CT_QSS"
            ;;
    esac
done < "$COLORS"
kwriteconfig6 --file "$HOME/.config/qt6ct/qt6ct.conf" --group Interface --key stylesheets "$QT6CT_QSS"
kwriteconfig6 --file "$HOME/.config/qt6ct/qt6ct.conf" --group Appearance --key icon_theme breeze-dark

# Waybar
sed -i "s|@import \".*\"; /\* theme \*/|@import \"$THEME_DIR/waybar.css\"; /* theme */|" "$HOME/.config/waybar/style.css"

# Zathura
mkdir -p "$(dirname "$ZATHURA_CONFIG")"
if grep -qE '^include ".*/themes/[^/]+/zathura.conf"$' "$ZATHURA_CONFIG"; then
    sed -i "s|^include \".*/themes/[^/]*/zathura.conf\"$|include \"$THEME_DIR/zathura.conf\"|" "$ZATHURA_CONFIG"
else
    printf '\ninclude "%s/zathura.conf"\n' "$THEME_DIR" >> "$ZATHURA_CONFIG"
fi

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
