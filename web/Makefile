# 
# MAKEFILE : WEB SITE
#

all:
	mkdir -p out
	cp *.css out/
	cp pics/*.* out/
	htp -quiet index.htp out/index.html

clean:
	rm -f out/*.html
	rm -f out/*.css
	rm -f out/*.png

.PHONY: all clean

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
