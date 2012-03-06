#
#  Brusher
#
#  Makefile for Unix
#

PROGRAM=brusher

CC=gcc
CXX=g++
CFLAGS= -g3 -Wall -DUNIX
CXXFLAGS=$(CFLAGS)
LDFLAGS=
LIBS=-lm

OBJS=./main.o     \
     ./level.o    \
     ./system.o   \
     ./util.o     \
     ./wad.o


# ----- TARGETS ------------------------------------------------------

all:    $(PROGRAM)

clean:
	rm -f $(PROGRAM) *.o core core.* ERRS debug.txt

$(PROGRAM): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $(PROGRAM) $(LDFLAGS) $(LIBS)

bin: all
	strip --strip-unneeded $(PROGRAM)

.PHONY: all clean bin install

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
