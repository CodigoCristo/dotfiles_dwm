# dwm version
VERSION = 6.8

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREETYPEINC = ${X11INC}/freetype2
#MANPREFIX = ${PREFIX}/man

# includes and libs
INCS = -I${X11INC} -I${FREETYPEINC}
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS} -lXext

# --- detección automática de microarquitectura (v2/v3/v4/native) ---
# -march=native detecta tu CPU exacta y usa el set de instrucciones
# más alto que soporte (SSE4.2, AVX, AVX2, AVX512 si aplica).
MARCH = -march=native -mtune=native

# flags
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700L -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}

# --- flags de RELEASE (máxima optimización) ---
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations \
           -O3 ${MARCH} -flto -fomit-frame-pointer -pipe \
           -fdata-sections -ffunction-sections \
           ${INCS} ${CPPFLAGS}

LDFLAGS  = -flto -O3 -s -Wl,--gc-sections -Wl,-O1 ${LIBS}

# --- flags de DEBUG (para desarrollo, comenta arriba y usa esto) ---
#CFLAGS  = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
#LDFLAGS = ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc
