#!/bin/bash
# set -e

if [ $# -eq 0 ]
then
	echo "USAGE: test-it <seed> [<length>]"
	exit
fi

seed=$1

length="game"

if [ $# -eq 2 ]
then
	length=$2
fi

if [ ! -d lua_src ]
then
	echo "Run this script from the top level."
	exit 1
fi

GAMES="doom2 doom1 freedoom ultdoom tnt plutonia"

SIZES="prog mixed tiny small regular large"

THEMES="mixed jumble original psycho"

for game in ${GAMES}; do
	for size in ${SIZES}; do
		for theme in ${THEMES}; do
			echo ""
			echo "==== $game / $size / $theme ===="
			echo ""

			base="test_${game}_${size}_${theme}"

			./Oblige --nolight seed=${seed} game=${game} size=${size} \
					 theme=${theme} -b ${base}.wad > ${base}.log
		done
	done
done

# --- editor settings ---
# vi:ts=4:sw=4:noexpandtab
