#----------------------------------------------------------------
# Vis Viewer
#
# GNU Makefile for Unix/Linux
#----------------------------------------------------------------

PROGRAM=VisViewer

CXX=g++

LIB_LOC=../linux_lib

FLTK_DIR=$(LIB_LOC)/fltk-1.1.9
LUA_DIR=$(LIB_LOC)/lua-5.1.2
GLBSP_DIR=$(LIB_LOC)/glbsp-2.24

OPTIMISE=-O1 -g

# operating system choices: UNIX WIN32
OS=UNIX


#--- Internal stuff from here -----------------------------------

FLTK_FLAGS=-I$(FLTK_DIR)
FLTK_LIBS=$(FLTK_DIR)/lib/libfltk_images.a \
          $(FLTK_DIR)/lib/libfltk.a \
          -lX11 -lXext -lpng -ljpeg

LUA_FLAGS=-I$(LUA_DIR)/src
LUA_LIBS=$(LUA_DIR)/src/liblua.a

GLBSP_FLAGS=-I$(GLBSP_DIR)/src
GLBSP_LIBS=$(GLBSP_DIR)/libglbsp.a

CXXFLAGS=$(OPTIMISE) -Wall -D$(OS) \
         $(FLTK_FLAGS) $(LUA_FLAGS) $(GLBSP_FLAGS)
LDFLAGS=-L/usr/X11R6/lib
LIBS=-lm -lz $(FLTK_LIBS) $(LUA_LIBS) $(GLBSP_LIBS)


OBJS=main.o


#--- Targets and Rules ------------------------------------------

all: clean $(PROGRAM)

clean:
	rm -f $(PROGRAM) *.o core core.* ERRS

$(PROGRAM): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS) $(LIBS)

.PHONY: all clean

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
