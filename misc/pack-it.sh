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

if [ ! -d x_doom ]; then
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

cd ..

src=oblige
dest=PACK-RAT

mkdir $dest

#
#  Lua scripts
#
mkdir $dest/scripts
cp -av $src/scripts/*.* $dest/scripts

mkdir $dest/games
cp -av $src/games/*.* $dest/games

mkdir $dest/engines
cp -av $src/engines/*.* $dest/engines

mkdir $dest/modules
cp -av $src/modules/*.* $dest/modules

mkdir $dest/prefabs
cp -av $src/prefabs/*.* $dest/prefabs

#
#  Data files
#
mkdir $dest/data
mkdir $dest/modules/data

cp -av $src/data/*.lmp $dest/data || true
cp -av $src/data/*.wad $dest/data || true
cp -av $src/data/*.pak $dest/data || true

mkdir $dest/data/doom1_boss
mkdir $dest/data/doom2_boss

cp -av $src/data/doom1_boss/*.* $dest/data/doom1_boss
cp -av $src/data/doom2_boss/*.* $dest/data/doom2_boss

#
#  Executables
#

mkdir $dest/tools

if [ $mode == "linux" ]
then
cp -av $src/Oblige $dest
cp -av $src/tools/qsavetex/qsavetex $dest/tools
else
cp -av $src/Oblige.exe $dest
cp -av $src/tools/qsavetex/qsavetex.exe $dest/tools
fi

#
#  Documentation
#
cp -av $src/GPL.txt $dest
cp -av $src/TODO.txt $dest
cp -av $src/README.txt $dest
cp -av $src/WISHLIST.txt $dest
cp -av $src/CHANGES.txt $dest
cp -av $src/AUTHORS.txt $dest

### cat $src/web/main.css $src/web/index.html > $dest/README.htm

#
# all done
#
echo "------------------------------------"
echo "mv PACK-RAT Oblige-X.XX"
echo "zip -l -r oblige-XXX-win.zip Oblige-X.XX"
echo ""

