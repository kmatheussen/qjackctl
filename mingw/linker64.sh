#!/bin/sh

set -e
set -x

$@ ../weak_libjack.o ../find_jack_library.o $EXTRALDFLAGS -ldsound -lwinmm -luuid -lsetupapi -lole32 

#/home/kjetil/jack2/windows/Release64/bin/libportaudio_x86_64.a
#-Wl,--allow-multiple-definition
