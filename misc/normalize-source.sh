#!/bin/sh
find .. -iname \*.lua -exec sed -i -E -e 's/\r//' -e 's/\s+$//' -e 's/	/    /g' -e '$a\' \{\} \;
