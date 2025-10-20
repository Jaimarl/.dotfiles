#--- Настройки ------------------------------------------------------
starship init fish | source
set fish_greeting


#--- Алиасы ---------------------------------------------------------
alias wp ~/.dotfiles/scripts/set_wallpaper.sh
alias ff "clear && fastfetch"


#--- Функции --------------------------------------------------------
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end