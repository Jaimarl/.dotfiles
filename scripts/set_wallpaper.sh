WALLPAPER_PATH="$1"

if [ $# -eq 0 ]; then
    echo "Не указан путь к изображению"
    exit 1
fi

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Файл '$WALLPAPER_PATH' не существует"
    exit 1
fi

if ! file --mime-type "$WALLPAPER_PATH" | grep -q \ image/; then
    echo "'$WALLPAPER_PATH' не является изображением"
    exit 1
fi

swww img "$WALLPAPER_PATH"
magick "$WALLPAPER_PATH" -blur 0x12 -level 8%,115%,1 ~/.dotfiles/assets/background.png