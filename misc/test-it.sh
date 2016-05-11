#!/bin/bash

if [ "$1" == "--help" ]
then
	echo "USAGE: test-it  oblige_options..."
	exit
fi

if [ ! -d lua_src ]
then
	echo "Run this script from the top level."
	exit 1
fi

seed=$RANDOM

echo "SEED = " ${seed}

base="test_${seed}"

# default values
def_length=game

declare -a GAMES
GAMES=("doom2" "doom2" "freedoom" "tnt" "tnt" "plutonia" "heretic")
index=$(($RANDOM % 7))
def_game=${GAMES[$index]}

declare -a ENGINES
ENGINES=("nolimit" "boom" "edge" "legacy" "zdoom")
index=$(($RANDOM % 5))
def_engine=${ENGINES[$index]}

declare -a SIZES
SIZES=("prog" "mixed" "small" "regular" "large")
index=$(($RANDOM % 5))
def_size=${SIZES[$index]}

declare -a THEMES
THEMES=("mixed" "mixed" "jumble" "original")
index=$(($RANDOM % 4))
def_theme=${THEMES[$index]}

set -x
./Oblige -d seed=${seed} length=${def_length} \
		game=${def_game} engine=${def_engine} \
		size=${def_size} theme=${def_theme} \
		$@ -b ${base}.out > ${base}.log
set +x

# --- editor settings ---
# vi:ts=4:sw=4:noexpandtab
