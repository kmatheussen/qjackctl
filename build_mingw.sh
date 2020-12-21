#!/bin/sh

if [[ $1 == "32" ]] ; then
    MINGW=mingw32
    ARCH=i686-w64-mingw32.static
fi

if [[ $1 == "64" ]] ; then
    MINGW=mingw64
    ARCH=x86_64-w64-mingw32.static
    #ARCH=x86_64-w64-mingw32.shared
fi

CC=$ARCH-gcc
CXX=$ARCH-g++
PKG=$ARCH-pkg-config

if [ -z $MINGW ] ; then
    echo "Must either run \"$0 32\" (for 32 bit build) or  \"$0 64\" (for 64 bit build)"
    exit -1
fi

set -e
set -x


function clean_and_configure {
    echo "*** Cleaning and configuring"

    rm -f is_configured
   
    if [ -f Makefile ] ;  then
        $MINGW-make clean
    fi
    
    make -f Makefile.git clean
    ./autogen.sh

    echo "ARCH: $ARCH"
    
    $ARCH-qmake-qt5
#    $ARCH-qmake-qt5 # It compiles, but complains about missing windows plugin.

    cp mingw/mingw_config.h src/config.h

    touch is_configured
}



########## PATCH
###################################

if ! grep "CONFIG += static" src/src.pro ; then
    echo "Can not find CONFIG+=static in src/src.pro"
    exit -1

fi

if ! grep "RC_FILE = ../mingw/icon/resfile.rc" src/src.pro ; then
    echo "Can not find RC_FILE = ../mingw/icon/resfile.rc in  src/src.pro"
    exit -1
fi




########## CONFIGURE
###################################

if [ ! -f src/config.h ] ; then
    clean_and_configure
fi

if [[ `diff mingw/mingw_config.h src/config.h` ]] ; then
    clean_and_configure
fi

if [ -f mingw_last_build_type.txt ] ; then
    if [[ ! $1 == `cat mingw_last_build_type.txt` ]] ; then
        clean_and_configure
    fi
fi

#clean_and_configure

echo $1 >mingw_last_build_type.txt


if [ ! -f is_configured ] ; then
    clean_and_configure
fi



######### BUILD
####################################

EXTRAFLAGS="-I`pwd`/mingw/weakjack -I`pwd`/mingw/include -DNO_JACK_METADATA -DUSE_WEAK_JACK `$PKG --cflags portaudio-2.0`" # `$PKG --libs --static Qt5Core`"
# 
#-I`pwd`/mingw/$1/portaudio/include

# compile weakjack
$CC $EXTRAFLAGS mingw/weakjack/weak_libjack.c -Wall -c -O2 -o weak_libjack.o
$CXX $EXTRAFLAGS mingw/find_jack_library.cpp -Wall -c -O2 `$PKG --cflags Qt5Core` -std=gnu++11 -o find_jack_library.o

EXTRALDFLAGS="`$PKG --static --libs Qt5Core` `$PKG --libs portaudio-2.0`" #/newhd/fedora19stuff/mxe_verynew/usr/x86_64-w64-mingw32.static/lib/libportaudio.a" # `$PKG --libs portaudio-2.0`" #/home/kjetil/jack2/windows/Release64/bin/libportaudio_x86_64.a #-lportaudio #/home/kjetil/mxe/usr/i686-w64-mingw32.static/lib/libportaudio.a
#`$PKG --libs portaudio-2.0`

make -j8 CC="$CC $EXTRAFLAGS" CXX="$CXX $EXTRAFLAGS" LINK="EXTRALDFLAGS=\"$EXTRALDFLAGS\" ../mingw/linker$1.sh $CXX" LINKER="EXTRALDFLAGS=\"$EXTRALDFLAGS\" ../mingw/linker$1.sh $CXX"



######### DIST
###################################

rm -fr $MINGW
mkdir $MINGW

cp src/release/qjackctl.exe $MINGW/
mingw-strip $MINGW/qjackctl.exe

