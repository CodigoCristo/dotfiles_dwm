# ~/.dwm/autostart_blocking.sh
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
[ -x "$HOME/.config/dwm/screen.sh" ] && "$HOME/.config/dwm/screen.sh"
xsetroot -cursor_name left_pt
