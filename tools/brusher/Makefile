#
#  Brusher
#
#  Makefile for Unix
#

PROG=doom2obj

CC=gcc
CXX=g++
CFLAGS= -g3 -Wall -DUNIX
CXXFLAGS=$(CFLAGS)
LDFLAGS=-L/usr/X11R6/lib
LIBS=-lm

OBJS=./main.o     \
     ./level.o    \
     ./system.o   \
     ./util.o     \
     ./wad.o


# ----- TARGETS ------------------------------------------------------

all:    $(PROG)

clean:
	rm -f $(PROG) *.o core core.* ERRS d2b_debug.txt

$(PROG): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $(PROG) $(LDFLAGS) $(LIBS)

bin: all
	strip --strip-unneeded $(PROG)

.PHONY: all clean bin install

