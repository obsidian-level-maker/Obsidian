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

