#----------------------------------------------------------------
# Testing Makefile
#----------------------------------------------------------------

all:
	rm -f TEST.wad
	$(MAKE) TEST.wad

TEST.wad:
	lua run_it.lua $(SEED)
	wadlc TEMP.txt TEMP.wad
	glbsp -pack TEMP.wad -o TEST.wad

clean:
	rm -f TEMP.txt TEST*.wad TEMP.wad

.PHONY: all clean run_it

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
