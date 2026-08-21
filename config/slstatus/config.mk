# slstatus version
VERSION = 1.1

# customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# --- detección automática de microarquitectura ---
MARCH = -march=native -mtune=native

# flags
CPPFLAGS = -I$(X11INC) -DALSA -D_DEFAULT_SOURCE -DVERSION=\"${VERSION}\"

# --- flags de RELEASE (máxima optimización) ---
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Wno-unused-parameter \
           -O3 ${MARCH} -flto -fomit-frame-pointer -pipe \
           -fdata-sections -ffunction-sections

LDFLAGS  = -L$(X11LIB) -s -lasound -flto -O3 -Wl,--gc-sections -Wl,-O1

# --- flags de DEBUG (para desarrollo, comenta arriba y usa esto) ---
#CFLAGS  = -std=c99 -pedantic -Wall -Wextra -Wno-unused-parameter -g -O0
#LDFLAGS = -L$(X11LIB) -lasound

# OpenBSD: add -lsndio
# FreeBSD: add -lkvm -lsndio
LDLIBS   = -lX11

# compiler and linker
CC = cc
