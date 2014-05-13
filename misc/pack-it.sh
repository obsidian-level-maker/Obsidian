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

dest=PACK-RAT

mkdir $dest

#
#  Lua scripts
#
mkdir $dest/scripts
cp -av scripts/*.* $dest/scripts

mkdir $dest/engines
cp -av engines/*.* $dest/engines

mkdir $dest/modules
cp -av modules/*.* $dest/modules

#
#  Game data
#
svn export games $dest/games

#
#  Data files
#
mkdir $dest/data
mkdir $dest/modules/data

cp -av data/*.lmp $dest/data || true
cp -av data/*.wad $dest/data || true
cp -av data/*.pak $dest/data || true

mkdir $dest/data/doom1_boss
mkdir $dest/data/doom2_boss

cp -av data/doom1_boss/*.* $dest/data/doom1_boss
cp -av data/doom2_boss/*.* $dest/data/doom2_boss

#
#  Executables
#

mkdir $dest/tools

if [ $mode == "linux" ]
then
cp -av Oblige $dest
##  cp -av tools/qsavetex/qsavetex $dest/tools
else
cp -av Oblige.exe $dest
##  cp -av tools/qsavetex/qsavetex.exe $dest/tools
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
echo "mv PACK-RAT Oblige-X.XX"
echo "zip -l -r oblige-XXX-win.zip Oblige-X.XX"
echo ""

