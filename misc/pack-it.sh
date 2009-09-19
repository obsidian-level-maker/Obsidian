#!/bin/bash
set -e

#
# Show help
#
if [ $# -eq 0 ]
then
    echo "USAGE: pack-it linux/win32"
    exit
fi

#
# Grab the mode
#
mode=$1
if [ $mode != "win32" ] && [ $mode != "linux" ]
then
    echo "Unknown mode: $mode"
    exit
fi

echo "Creating a $mode package for Oblige..."

cd ../..

src=Oblige
dest=PACK-RAT

mkdir $dest

#
#  Copy Lua scripts
#
mkdir $dest/scripts
cp -av $src/scripts/*.* $dest/scripts

mkdir $dest/games
cp -av $src/games/*.* $dest/games

mkdir $dest/engines
cp -av $src/engines/*.* $dest/engines

mkdir $dest/mods
cp -av $src/mods/*.* $dest/mods

#
#  Copy executables
#
mkdir $dest/data

if [ $mode == "linux" ]
then
cp -av $src/Oblige $dest
cp -av $src/qsavetex/qsavetex $dest/data
else
cp -av $src/Oblige.exe $dest
cp -av $src/qsavetex/qsavetex.exe $dest/data
fi

#
#  Copy documentation
#
cp -av $src/GPL.txt $dest
cp -av $src/TODO.txt $dest
cp -av $src/WISHLIST.txt $dest
cp -av $src/CHANGES.txt $dest

### cat $src/web/main.css $src/web/index.html > $dest/README.htm

#
# all done
#
echo "------------------------------------"
echo "Remember to fix README.htm:"
echo "  1. move the CSS"
echo "  2. remove SCREENSHOT section"
echo "  3. remove DOWNLOAD section"

