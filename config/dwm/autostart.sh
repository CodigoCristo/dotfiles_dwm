# ~/.dwm/autostart.sh
xss-lock --transfer-sleep-lock -- slock &
# nm-applet &
# picom &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
feh --bg-scale /usr/share/pixmaps/backgroundarch.jpg &
dunst &
slstatus &
#eval "$(gnome-keyring-daemon --start --components=secrets)" &
export SSH_AUTH_SOCK
