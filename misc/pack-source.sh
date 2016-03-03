#!/bin/bash
set -e

if [ ! -d glbsp_src ]; then
  echo "Run this script from the top level."
  exit 1
fi

echo "Creating the source package for Oblige..."

dest="Oblige-X.XX-source"

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

rm -f $dest/data/*.wad
rm -f $dest/data/*.pak

#
#  C++ Source code
#
mkdir $dest/gui
cp -av gui/*.[chr]* $dest/gui
cp -av gui/*.ico $dest/gui
cp -av Makefile* $dest/

mkdir $dest/lua_src
cp -av lua_src/*.[chr]* $dest/lua_src
cp -av lua_src/COPY* $dest/lua_src

mkdir $dest/glbsp_src
cp -av glbsp_src/*.[chrt]* $dest/glbsp_src

mkdir $dest/ajpoly_src
cp -av ajpoly_src/*.[chrt]* $dest/ajpoly_src

mkdir $dest/physfs_src
cp -av physfs_src/*.[chrt]* $dest/physfs_src

mkdir $dest/misc
cp -av misc/pack*.sh $dest/misc

mkdir $dest/obj_linux
mkdir $dest/obj_linux/lua
mkdir $dest/obj_linux/glbsp
mkdir $dest/obj_linux/ajpoly
mkdir $dest/obj_linux/physfs

mkdir $dest/obj_win32
mkdir $dest/obj_win32/lua
mkdir $dest/obj_win32/glbsp
mkdir $dest/obj_win32/ajpoly
mkdir $dest/obj_win32/physfs

#
#  Documentation
#
cp -av *.txt $dest

rm -f $dest/LOGS.txt
rm -f $dest/CONFIG.txt
rm -f $dest/OPTIONS.txt

cp -av doc $dest/doc

#
# all done
#
echo "------------------------------------"
echo "zip -l -r oblige-XXX-source.zip Oblige-X.XX-source"

