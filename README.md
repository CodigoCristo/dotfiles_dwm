# dotfiles_dwm

Configuración personal de **dwm** (dynamic window manager) junto con las herramientas suckless (`st`, `slock`, `slstatus`) y el resto de aplicaciones que componen el entorno de escritorio.

## Stack principal

- **dwm** — Gestor de ventanas dinámico (suckless)
- **st** — Terminal suckless
- **slock** — Bloqueo de pantalla
- **slstatus** — Barra de estado para dwm
- **rofi / dmenu** — Lanzadores de aplicaciones
- **dunst** — Notificaciones
- **kitty** — Terminal alternativa

## Instalación rápida (automática)

Este repositorio incluye un script `install.sh` que instala todas las dependencias (oficiales y AUR), respalda tu `~/.config` actual, copia la configuración y compila `dwm`, `st`, `slock` y `slstatus` automáticamente.

```bash
git clone https://github.com/CodigoCristo/dotfiles_dwm.git
cd dotfiles_dwm
chmod +x install.sh
./install.sh
```

> Si prefieres hacerlo paso a paso o entender qué hace cada parte, sigue la instalación manual descrita más abajo.

## Dependencias

### Paquetes oficiales (repos de Arch)

```bash
sudo pacman -S --needed adw-gtk-theme alacritty alsa-plugins alsa-utils arandr \
    brightnessctl cosmic-icon-theme dmenu dunst feh inotify-tools \
    gnome-keyring gnome-themes-extra gnu-free-fonts gvfs \
    kitty lsb-release lxappearance lxde-icon-theme ly \
    mesa-utils opencl-mesa lib32-mesa lib32-mesa-utils \
    pamixer pavucontrol pipewire-alsa pipewire-pulse \ 
    polkit-gnome pulseaudio-alsa rofi slock \
    thunar ttf-liberation-mono-nerd ttf-jetbrains-mono-nerd noto-fonts \
    ttf-nerd-fonts-symbols tumbler unclutter wget xclip \
    xdg-user-dirs xdotool xorg-server xorg-xinit xorg-xrandr \
    xorg-xset xsel xss-lock xterm
```

### Paquetes AUR (instalados con `yay`)

```bash
yay -S --needed dwm slstatus st ttf-noto-emoji-monochrome
```

> Nota: `yay` en sí mismo debe instalarse primero manualmente (no puede instalarse con `yay -S yay`). Ver sección [Instalar yay](#instalar-yay-si-no-lo-tienes) más abajo.

## Instalar yay (si no lo tienes)

```bash
sudo pacman -S --needed git 
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Instalación de los dotfiles

1. Clona este repositorio:

   ```bash
   git clone https://github.com/CodigoCristo/dotfiles_dwm.git
   cd dotfiles_dwm
   ```

2. Respalda tu `~/.config` actual (por si acaso) y copia la carpeta `config`:

   ```bash
   cp -r ~/.config ~/.config.bak
   cp -r config/* ~/.config/
   ```

3. (Opcional) Copia también los archivos de zsh, si el repositorio incluye `.zshrc` u otros archivos sueltos fuera de `.config`:

   ```bash
   cp .zshrc ~/
   ```

## Compilar e instalar dwm, st, slock y slstatus

Cada una de estas herramientas suckless se compila desde su propia carpeta dentro de `~/.config` (o donde tengas su código fuente) usando `make`.

```bash
cd ~/.config/dwm
sudo make clean install

cd ~/.config/st
sudo make clean install

cd ~/.config/slock
sudo make clean install

cd ~/.config/slstatus
sudo make clean install
```

> Si alguna carpeta no compila, revisa el `config.mk` de cada programa: ahí se definen las rutas de includes/libs (X11, freetype, etc.) que pueden variar según tu instalación.

## Iniciar dwm

Si usas `ly` como display manager (incluido en la lista de paquetes), simplemente selecciona la sesión **dwm** en la pantalla de login.

Si prefieres iniciarlo manualmente desde la terminal (TTY) con `startx`, asegúrate de tener un `~/.xinitrc` con:

```bash
exec dwm
```

## Estructura del repositorio

```
.config/
├── dwm/         # Código fuente y config de dwm
├── st/          # Código fuente y config de la terminal st
├── slock/       # Código fuente y config del bloqueo de pantalla
├── slstatus/    # Código fuente y config de la barra de estado
├── rofi/        # Configuración de rofi
├── kitty/       # Configuración de kitty
├── dunst/       # Configuración de notificaciones
└── ...          # Resto de configuraciones (gtk, etc.)
```

## Screenshots

_Agregar capturas de pantalla del escritorio aquí._
