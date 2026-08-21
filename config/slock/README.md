# Kris's build of slock (flexipatch)

My build of [slock](https://tools.suckless.org/slock/), the simple X display locker.

This build is based on [slock-flexipatch](https://github.com/bakkeby/slock-flexipatch), which uses preprocessor directives to manage patches. This allows easy toggling of features without manual patching.

---

## How Patches Work (Preprocessor Directives)

Unlike traditional slock patching, this build uses C preprocessor directives to include/exclude patches at compile time. To enable or disable a patch, edit `patches.h` and set the value to `1` (enabled) or `0` (disabled):

```c
#define DPMS_PATCH 1       /* enabled */
#define DWM_LOGO_PATCH 0   /* disabled */
```

Then rebuild:
```bash
sudo make clean install
```

All patch options are documented in `patches.h`.

---

## Available Patches

This is currently a **vanilla build** with no patches enabled. The following patches are available to toggle on in `patches.h`:

| Patch | Description |
|-------|-------------|
| alpha | Transparency support (pair with a compositor for blur) |
| auto_timeout | Run a command after a specified period of inactivity |
| background_image | Custom background image on lock screen (requires Imlib2) |
| blur_pixelated_screen | Blur/pixelate a screenshot as the lock background (requires Imlib2) |
| capscolor | Additional color to indicate Caps Lock state |
| color_message | Lock screen message with 24-bit ANSI color codes (requires Xinerama) |
| controlclear | Suppress failure color on control key presses with empty buffer |
| dpms | Auto shut off monitor after configurable inactivity |
| dwm_logo | Draw the dwm logo, color changes with state |
| failure_command | Run a command after N incorrect password attempts |
| keypress_feedback | Random blocks on screen as keypress feedback |
| mediakeys | Allow media keys (volume, skip) while locked |
| message | Display a text message on the lock screen (requires Xinerama) |
| pamauth | PAM authentication instead of shadow (default config for Arch) |
| quickcancel | Cancel lock by moving mouse within a time window |
| secret_password | Execute commands on special password entry |
| terminalkeys | Terminal-style key bindings (Ctrl+U, etc.) for password input |
| unlockscreen | Keep screen visible but lock input |
| visual_unlock | `-u` flag to lock input without showing lock screen |
| xresources | Read colors from Xresources |

---

## Installation

```bash
git clone https://github.com/krisyotam/slock
cd slock
sudo make clean install
```

---

## Configuration

### Enabling/Disabling Patches

Edit `patches.h` to toggle patches:

```c
#define CAPSCOLOR_PATCH 1    /* Enable caps lock color */
#define DPMS_PATCH 1         /* Enable monitor power management */
```

### Customizing Settings

Edit `config.def.h` for:
- Lock screen colors
- User/group settings
- Patch-specific options (timeouts, messages, etc.)

After editing, rebuild:
```bash
rm config.h && sudo make clean install
```

---

## My Other Suckless Repos

- [dwm](https://github.com/krisyotam/dwm) - dynamic window manager
- [st](https://github.com/krisyotam/st) - simple terminal
- [dmenu](https://github.com/krisyotam/dmenu) - application launcher
- [dwmblocks](https://github.com/krisyotam/dwmblocks) - modular status bar

---

## Credits

- Based on [slock-flexipatch](https://github.com/bakkeby/slock-flexipatch) by bakkeby
- [suckless.org](https://tools.suckless.org/slock/) for the original slock

---

## Contact

- Kris Yotam <krisyotam@protonmail.com>
- [https://krisyotam.com](https://krisyotam.com)
