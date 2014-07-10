#!/bin/bash

if [ "$1" == "--help" ]
then
	echo "USAGE: test-many  oblige_options..."
	exit
fi

if [ ! -d lua_src ]
then
	echo "Run this script from the top level."
	exit 1
fi

for (( ; 1 ; )) do
  misc/test-it.sh $*
  sleep 30
done

# --- editor settings ---
# vi:ts=4:sw=4:noexpandtab
