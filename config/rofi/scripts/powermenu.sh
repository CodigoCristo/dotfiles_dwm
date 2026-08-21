#!/bin/bash
# powermenu.sh — adaptado para dwm (el original usaba i3-msg y betterlockscreen)

option1="⏻  Apagar"
option2="↺  Reiniciar"
option3="⏾  Suspender"
option4="🔒  Bloquear"
option5="⏏  Cerrar sesión"

chosen=$(echo -e "$option1\n$option2\n$option3\n$option4\n$option5" | rofi -dmenu \
    -p "Sistema" \
    -theme-str 'window {width: 400px; border-radius: 4px;}' \
    -theme-str 'inputbar {border-radius: 4px;}' \
    -theme-str 'element {border-radius: 4px; padding: 14px 16px;}' \
    -theme-str 'listview {columns: 1; lines: 5; spacing: 6px;}' \
    -no-custom)

case "$chosen" in
    "$option1") systemctl poweroff ;;
    "$option2") systemctl reboot ;;
    "$option3") systemctl suspend ;;
    "$option4") slock ;;                     # cambiado de betterlockscreen a slock (ya lo tienes instalado)
    "$option5") pkill -TERM -x dwm ;;        # cambiado de "i3-msg exit" — dwm 6.3+ maneja SIGTERM para salir limpio
esac
