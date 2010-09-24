#!/bin/bash
set -e

echo "Creating the source package for Oblige..."

cd ../..

src=oblige
dest=PACK-SRC

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

mkdir $dest/prefabs
cp -av $src/prefabs/*.* $dest/prefabs

#
#  Copy source code
#
mkdir $dest/gui
cp -av $src/gui/*.[chr]* $dest/gui
cp -av $src/gui/*.ico $dest/gui
cp -av $src/gui/Makefile.* $dest/gui

mkdir $dest/qsavetex
cp -av $src/qsavetex/*.[ch]* $dest/qsavetex
cp -av $src/qsavetex/Makefile* $dest/qsavetex

mkdir $dest/vis_viewer
cp -av $src/vis_viewer/*.[ch]* $dest/vis_viewer
cp -av $src/vis_viewer/Makefile* $dest/vis_viewer
cp -av $src/vis_viewer/DATA* $dest/vis_viewer

mkdir $dest/misc
cp -av $src/misc/pack*.sh $dest/misc

#
#  Data files
#
mkdir $dest/data
cp -av $src/data/*.lmp $dest/data || true
cp -av $src/data/*.wad $dest/data || true
cp -av $src/data/*.pak $dest/data || true

#
#  Copy documentation
#
mkdir $dest/doc
cp -av $src/doc/*.* $dest/doc

cp -av $src/GPL.txt $dest
cp -av $src/TODO.txt $dest
cp -av $src/README.txt $dest
cp -av $src/WISHLIST.txt $dest
cp -av $src/CHANGES.txt $dest

#
# all done
#
echo "------------------------------------"
echo "All done."

