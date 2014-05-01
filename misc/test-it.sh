#!/bin/bash
# set -e

if [ $# -eq 0 ]
then
	echo "USAGE: test-it  seed  oblige_options..."
	exit
fi

if [ ! -d lua_src ]
then
	echo "Run this script from the top level."
	exit 1
fi

seed=$1
shift

base="test_${seed}"

# default values
def_length=game

declare -a GAMES
GAMES=("doom1" "doom2" "freedoom" "ultdoom" "tnt" "plutonia")
index=$(($RANDOM % ${#GAMES}))
def_game=${GAMES[$index]}

declare -a SIZES
SIZES=("prog" "mixed" "tiny" "small" "regular" "large")
index=$(($RANDOM % ${#SIZES}))
def_size=${SIZES[$index]}

declare -a THEMES
THEMES=("mixed" "mixed" "jumble" "original" "psycho")
index=$(($RANDOM % ${#THEMES}))
def_theme=${THEMES[$index]}

set -x
./Oblige --nolight seed=${seed} length=${def_length} \
		game=${def_game} size=${def_size} theme=${def_theme} \
		$@ -b ${base}.out > ${base}.log
set +x

# --- editor settings ---
# vi:ts=4:sw=4:noexpandtab
