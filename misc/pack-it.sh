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

if [ ! -d lua_src ]; then
    echo "Run this script from the top level."
    exit 1
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

dest="Oblige-X.XX"

mkdir $dest

#
#  Lua scripts
#
cp -av scripts $dest/scripts
cp -av engines $dest/engines
cp -av modules $dest/modules

#
#  Games
#
cp -av games $dest/games

#
#  Prefabs
#
cp -av prefabs $dest/prefabs

#
#  Data files
#
cp -av data $dest/data

mkdir $dest/addons

#
#  Executables
#

if [ $mode == "linux" ]
then
cp -av Oblige $dest
else
cp -av Oblige.exe $dest
fi

#
#  Documentation
#
cp -av README.txt $dest
cp -av TODO.txt $dest
cp -av GPL.txt $dest
cp -av CHANGES.txt $dest
cp -av AUTHORS.txt $dest

#
# all done
#
echo "------------------------------------"
echo "zip -l -r oblige-XXX-win.zip Oblige-X.XX"
echo ""

