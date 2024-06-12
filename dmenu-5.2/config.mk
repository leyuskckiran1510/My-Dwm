# dmenu version
VERSION = 5.2

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

# X11INC = /usr/X11R6/include
# X11LIB = /usr/X11R6/lib
X11INC = $(PWD)/../libxft/include
X11LIB = $(PWD)/../libxft/src/.libs

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREETYPEINC = $(X11INC)/freetype2
#MANPREFIX = ${PREFIX}/man

# includes and libs
INCS = -I$(X11INC) -I$(FREETYPEINC)
LIBS = -L$(X11LIB) -lX11 $(XINERAMALIBS) $(FREETYPELIBS)

# flags
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\" $(XINERAMAFLAGS)
CFLAGS   = -std=c99 -pedantic -Wall -Os $(INCS) $(CPPFLAGS)
# LDFLAGS  = $(LIBS)
LDFLAGS = -Xlinker -rpath=$(X11LIB) $(LIBS)

# compiler and linker
CC = cc
