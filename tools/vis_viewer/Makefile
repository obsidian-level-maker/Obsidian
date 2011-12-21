#----------------------------------------------------------------
# Vis Viewer
#
# GNU Makefile for Unix/Linux
#----------------------------------------------------------------

PROGRAM=VisViewer

CXX=g++

LIB_LOC=../lib_linux

FLTK_DIR=$(LIB_LOC)/fltk-1.1.10

OPTIMISE=-O1 -g

# operating system choices: UNIX WIN32
OS=UNIX


#--- Internal stuff from here -----------------------------------

FLTK_FLAGS=-I$(FLTK_DIR)
FLTK_LIBS=$(FLTK_DIR)/lib/libfltk_images.a \
          $(FLTK_DIR)/lib/libfltk.a \
          -lX11 -lXext -lpng -ljpeg

CXXFLAGS=$(OPTIMISE) -Wall -D$(OS) $(FLTK_FLAGS)
LDFLAGS=-L/usr/X11R6/lib
LIBS=-lm -lz $(FLTK_LIBS)


OBJS=main.o ../obj_linux/vis_buffer.o


#--- Targets and Rules ------------------------------------------

all: $(PROGRAM)

clean:
	rm -f $(PROGRAM) *.o core core.* ERRS

$(PROGRAM): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS) $(LIBS)

.PHONY: all clean

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
