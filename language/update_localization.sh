#!/bin/bash

# Updates the "<localization>.po".

PACKAGEERR=""

function check_if_installed {
	if ! which $1 > /dev/null; then
		[ -z "$2" ] && PACKAGENAME="$1" || PACKAGENAME="$2"
		echo "check_if_installed(): Cannot find the \"$1\" program (from the package \"$2\")."
		PACKAGEERR="true"
	fi
}

check_if_installed sed
check_if_installed date coreutils
check_if_installed msgcat gettext
check_if_installed msguniq gettext

[ -n "$PACKAGEERR" ] && echo && exit 2


[ -z "$1" ] && echo "Usage: $0 <file.po>" && exit 1

if [ -f "$1" ]; then
	LOCZFILE="$1"
elif [ -f "$1.po" ]; then
	LOCZFILE="$1.po"
else
	echo "Loczlization file not found."
	exit 2
fi

# Stop the script at the first error:
set -e

TEMPLATEFILE="TEMPLATE_Obsidian.po"

echo Updating $LOCZFILE with $TEMPLATEFILE...
msgcat --use-first --no-wrap -o $LOCZFILE.new $LOCZFILE $TEMPLATEFILE
msguniq --use-first --no-wrap -o $LOCZFILE $LOCZFILE.new

sed -i "0,/PO-Revision-Date/{s=\"PO-Revision-Date:\s.\+=\"PO-Revision-Date: $(date +'%Y-%m-%d %H:%M%z')\\\\n\"=1}" $LOCZFILE
rm $LOCZFILE.new

echo Done!
