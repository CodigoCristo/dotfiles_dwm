#!/usr/bin/env bash
#
# install.sh — Instalación automática de dotfiles_dwm
# Repositorio: https://github.com/CodigoCristo/dotfiles_dwm
#
# Uso:
#   chmod +x install.sh
#   ./install.sh
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Colores para los mensajes
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ---------------------------------------------------------------------------
# Comprobaciones previas
# ---------------------------------------------------------------------------
if [[ $EUID -eq 0 ]]; then
    error "No ejecutes este script como root. Se te pedirá sudo cuando sea necesario."
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    error "Este script está pensado para Arch Linux (o derivadas). No se encontró pacman."
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$REPO_DIR/config"

if [[ ! -d "$CONFIG_SRC" ]]; then
    error "No se encontró la carpeta 'config' en $REPO_DIR"
    error "Ejecuta este script desde la raíz del repositorio clonado."
    exit 1
fi

# ---------------------------------------------------------------------------
# 1. Paquetes oficiales
# ---------------------------------------------------------------------------
PACMAN_PKGS=(
    adw-gtk-theme alacritty alsa-plugins alsa-utils arandr
    brightnessctl cosmic-icon-theme dmenu dunst feh inotify-tools
    gnome-keyring gnome-themes-extra gnu-free-fonts gvfs
    kitty lsb-release lxappearance lxde-icon-theme ly
    mesa-utils opencl-mesa lib32-mesa lib32-mesa-utils
    pamixer pavucontrol pipewire-alsa pipewire-pulse
    polkit-gnome pulseaudio-alsa rofi slock
    thunar ttf-liberation-mono-nerd ttf-jetbrains-mono-nerd noto-fonts 
    ttf-nerd-fonts-symbols tumbler unclutter wget xclip 
    xdg-user-dirs xdotool xorg-server xorg-xinit xorg-xrandr
    xorg-xset xsel xss-lock xterm 
)

info "Instalando paquetes oficiales (${#PACMAN_PKGS[@]} paquetes)..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "Paquetes oficiales instalados."

# ---------------------------------------------------------------------------
# 2. yay (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v yay &>/dev/null; then
    info "yay no está instalado. Instalando desde AUR..."
    tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    (cd "$tmp_dir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
    ok "yay instalado."
else
    ok "yay ya está instalado."
fi

# ---------------------------------------------------------------------------
# 3. Paquetes AUR
# ---------------------------------------------------------------------------
AUR_PKGS=(
    dwm slstatus st ttf-noto-emoji-monochrome  
)

info "Instalando paquetes AUR (${#AUR_PKGS[@]} paquetes)..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"
ok "Paquetes AUR instalados."

# ---------------------------------------------------------------------------
# 4. Respaldo y copia de la configuración
# ---------------------------------------------------------------------------
if [[ -d "$HOME/.config" ]]; then
    backup_dir="$HOME/.config.bak.$(date +%Y%m%d_%H%M%S)"
    info "Respaldando ~/.config existente en $backup_dir"
    cp -r "$HOME/.config" "$backup_dir"
    ok "Respaldo creado."
fi

info "Copiando configuración a ~/.config ..."
mkdir -p "$HOME/.config"
cp -r "$CONFIG_SRC/." "$HOME/.config/"
ok "Configuración copiada."

# ---------------------------------------------------------------------------
# 5. Compilar e instalar herramientas suckless
# ---------------------------------------------------------------------------
SUCKLESS_TOOLS=(dwm st slock slstatus)

for tool in "${SUCKLESS_TOOLS[@]}"; do
    tool_dir="$HOME/.config/$tool"
    if [[ -d "$tool_dir" ]]; then
        info "Compilando e instalando $tool ..."
        (cd "$tool_dir" && sudo make clean install)
        ok "$tool instalado."
    else
        warn "No se encontró la carpeta $tool_dir, se omite."
    fi
done

# ---------------------------------------------------------------------------
# 6. Habilitar el servicio de ly (display manager)
# ---------------------------------------------------------------------------

info "Habilitando ly@tty1.service ..."
sudo systemctl enable "ly@tty1.service"
sudo cp backgroundarch.jpg /usr/share/pixmaps/backgroundarch.jpg

# ---------------------------------------------------------------------------
# Fin
# ---------------------------------------------------------------------------
echo
ok "¡Instalación completa!"
info "Reinicia el sistema. Con ly@tty${LY_TTY} habilitado, la sesión 'dwm' aparecerá en la pantalla de login en esa TTY."
info "Si prefieres usar startx en vez de ly, agrega 'exec dwm' a tu ~/.xinitrc y deshabilita ly con: sudo systemctl disable ly@tty${LY_TTY}.service"
