#
# Makefile for Unix/Linux
#
# (Note: requires GNU make)
#

# --- variables that can be overridden ---

PROGRAM=qsavetex

CXX=g++

OPTIM=-g -O2

CPPFLAGS=-I.
CXXFLAGS=-Wall $(OPTIM) -fno-rtti -DUNIX

LDFLAGS=-Xlinker --warn-common


# ----- OBJECTS and LIBRARIES ------------------------------------------

OBJS=	u_file.o   \
	u_util.o   \
	im_tex.o   \
	pakfile.o  \
	main.o

LIBS=-lm -lpng


# ----- TARGETS ------------------------------------------------------

all: $(PROGRAM)

clean:
	rm -f $(PROGRAM) *.o core core.* ERRS

relink:
	rm -f $(PROGRAM)
	$(MAKE) $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(OBJS) -o $(PROGRAM) $(LIBS)


.PHONY: all clean relink

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
