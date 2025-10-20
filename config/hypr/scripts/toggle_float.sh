is_floating=$(hyprctl activewindow | awk -F": " '/floating:/ {print $2}')

if [[ $is_floating == "1" ]]; then
    hyprctl dispatch togglefloating
else
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact 1280 720
    hyprctl dispatch centerwindow
fi