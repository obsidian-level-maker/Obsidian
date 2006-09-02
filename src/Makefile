#----------------------------------------------------------------
# Testing Makefile
#----------------------------------------------------------------

all:
	rm -f TEST.wad
	$(MAKE) TEST.wad

TEST.wad:
	lua run_it.lua $(SEED)
	./wadlc TEST.txt TEMP.wad
	glbsp -pack TEMP.wad -o TEST.wad

clean:
	rm -f TEST.txt TEST*.wad TEMP.wad
	cd gui && $(MAKE) clean

test: TEST.wad
	chocolate-doom -iwad ~/doom/doom2.wad -file TEST.wad -warp 1

backup: clean
	test ! -z $(VER)  # VER must be set
	cd .. && tar cvzf ~/backups/oblige_ng_$(VER).tgz ObligeNG

.PHONY: all clean run_it test backup

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
