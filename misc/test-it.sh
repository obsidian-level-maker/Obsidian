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
GAMES=("doom1" "ultdoom" "doom2" "tnt" "plutonia")
index=$(($RANDOM % 5))
def_game=${GAMES[$index]}

declare -a ENGINES
ENGINES=("nolimit" "boom" "edge" "legacy" "zdoom" "gzdoom")
index=$(($RANDOM % 6))
def_engine=${ENGINES[$index]}

declare -a SIZES
SIZES=("epi" "prog" "mixed" "small" "regular" "large")
index=$(($RANDOM % 6))
def_size=${SIZES[$index]}

declare -a THEMES
THEMES=("mixed" "jumble" "original")
index=$(($RANDOM % 3))
def_theme=${THEMES[$index]}

set -x
./Oblige -d seed=${seed} length=${def_length} \
		game=${def_game} engine=${def_engine} \
		size=${def_size} theme=${def_theme} \
		$@ -b ${base}.out --log ${base}.log
set +x

# --- editor settings ---
# vi:ts=4:sw=4:noexpandtab
