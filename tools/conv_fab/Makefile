
all: conv_fab

CC=gcc
CFLAGS=-g1 -fno-strict-aliasing

OBJS=	main.o display.o \
	analyze.o blockmap.o glbsp.o level.o  \
	reject.o system.o util.o wad.o

conv_fab: $(OBJS)
	gcc -o $@ $(OBJS) -lm -lz

clean:
	rm -f conv_fab *.o

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
