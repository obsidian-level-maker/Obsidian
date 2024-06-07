# Updates the "<localization>.po".

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
msgcat $LOCZFILE $TEMPLATEFILE -o $LOCZFILE.new --use-first --no-wrap
msguniq --no-wrap --use-first $LOCZFILE.new -o $LOCZFILE

sed -i "s=\"PO-Revision-Date:\s=\"PO-Revision-Date: $(date +'%Y-%m-%d %H:%M%z')\\n\"=1" $LOCZFILE
rm $LOCZFILE.new

echo Done!
