#!/bin/bash
set -e

echo "Creating the source package for Oblige..."

cd ../..

src=oblige
dest=PACK-SRC

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
#  Source code
#
mkdir $dest/gui
cp -av $src/gui/*.[chr]* $dest/gui
cp -av $src/gui/*.ico $dest/gui
cp -av $src/Makefile.* $dest/

mkdir $dest/tools
mkdir $dest/tools/qsavetex
cp -av $src/tools/qsavetex/*.[ch]* $dest/tools/qsavetex
cp -av $src/tools/qsavetex/Makefile* $dest/tools/qsavetex

mkdir $dest/misc
cp -av $src/misc/pack*.sh $dest/misc

#
#  Data files
#
mkdir $dest/data
cp -av $src/data/*.lmp $dest/data || true
cp -av $src/data/*.wad $dest/data || true
cp -av $src/data/*.pak $dest/data || true

mkdir $dest/data/doom1_boss
mkdir $dest/data/doom2_boss

cp -av $src/data/doom1_boss/*.* $dest/data/doom1_boss
cp -av $src/data/doom2_boss/*.* $dest/data/doom2_boss

#
#  Documentation
#
mkdir $dest/doc
cp -av $src/doc/*.* $dest/doc

cp -av $src/GPL.txt $dest
cp -av $src/TODO.txt $dest
cp -av $src/README.txt $dest
cp -av $src/WISHLIST.txt $dest
cp -av $src/CHANGES.txt $dest
cp -av $src/AUTHORS.txt $dest

#
# all done
#
echo "------------------------------------"
echo "All done."

