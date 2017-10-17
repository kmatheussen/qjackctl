#!/bin/sh

$@ ../weak_libjack.o ../find_jack_library.o $EXTRALDFLAGS -ldsound -lwinmm -luuid -lsetupapi -lole32 

# /home/kjetil/mxe/usr/i686-w64-mingw32.static/lib/libgnurx.a

