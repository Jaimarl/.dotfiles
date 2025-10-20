#--- Вспомогательные функции ----------------------------------------
color_echo() {
    local color=$1
    local message=$2
    local reset='\033[0m'
    
    case $color in
        black)   color_code='\033[0;30m' ;;
        red)     color_code='\033[0;31m' ;;
        green)   color_code='\033[0;32m' ;;
        yellow)  color_code='\033[0;33m' ;;
        blue)    color_code='\033[0;34m' ;;
        magenta) color_code='\033[0;35m' ;;
        cyan)    color_code='\033[0;36m' ;;
        white)   color_code='\033[0;37m' ;;
        *)       color_code='\033[0m' ;;
    esac
    
    echo ""
    echo -e "${color_code}${message}${reset}"
}


#--- Запрет запуска с sudo ------------------------------------------
if [ -n "$SUDO_UID" ]; then
    color_echo "red" "Не запускайте скрипт с sudo"
    exit 1
fi


#--- Подтверждение установки ----------------------------------------
while true; do
    read -p "Начать установку? (y/n) " answer
    case $answer in
        [Yy]* | "" ) break;;
        [Nn]* ) exit 1;;
        * ) exit 1;;
    esac
done


#--- Симлинк директории дотфайлов -----------------------------------
ln -sf ~/.local/share/.dotfiles ~/


#--- Установка Yay --------------------------------------------------
if ! pacman -Q yay &> /dev/null; then
    color_echo "green" "Установка Yay"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd
    rm -rf yay
fi


#--- Установка необходимых пакетов ----------------------------------
# Пакеты Pacman
color_echo "green" "Установка пакетов (Pacman)"
sudo pacman -S --noconfirm waybar discord telegram-desktop fish btop nvtop\
    cava hyprshot hyprpicker  yazi rofi firefox code qbittorrent rofi mpv\
    eog noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-dejavu\
    ttf-liberation pavucontrol pipewire-pulse swaync hyprlock starship fzf\
    trash-cli udisks2 imagemagick swww cpio meson cmake unzip fastfetch

# Пакеты AUR
color_echo "green" "Установка пакетов (AUR)"
yay -S --noconfirm spotify equicord-installer-bin otf-geist-mono-nerd apple-fonts\
    wlogout catppuccin-gtk-theme-macchiato anicli-ru adwsteamgtk spicetify-cli

# Discord
color_echo "green" "Установка Equicord"
sudo Equilotl -install -location /opt/discord

# Плагины Hyprland
color_echo "green" "Обновление hyprpm"
hyprpm update
color_echo "green" "Установка плагинов Hyprland"
hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
hyprpm enable split-monitor-workspaces
hyprpm reload

# Сервис эквалайзера hyprlock
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now cava-to-file.service
systemctl --user start --now cava-to-file.service

# GTK тема и иконки
color_echo "green" "Установка темы GTK"
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme/
./install.sh -s catppuccin -t purple
cd
rm -rf Colloid-icon-theme/

echo "GTK_THEME=catppuccin-macchiato-mauve-standard+default" | sudo tee -a /etc/environment
gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Purple-Catppuccin-Dark'


#--- Создание симлинков на конфиги ----------------------------------
for item in ~/.dotfiles/config/*; do
    item_name=$(basename "$item")
    
    if [ -e ~/.config/"$item_name" ]; then
        rm -rf ~/.config/"$item_name"
    fi

    ln -sf "$item" ~/.config/
done

ln -sf ~/.dotfiles/assets/background.png ~/.dotfiles/config/wlogout
