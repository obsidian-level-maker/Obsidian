#
#  --- AJBSP ---
#
#  Makefile for Linux and BSD systems.
#  Requires GNU make.
#

PROGRAM=ajbsp

# prefix choices: /usr  /usr/local  /opt
PREFIX ?= /usr/local

# for BSD systems use: $(PREFIX)/man
MANDIR ?= $(PREFIX)/share/man

# CXX=clang++-6.0
# CXX=g++ -m32   (to compile 32-bit binary on 64-bit system)

# flags controlling the dialect of C++
# [ the code is old-school C++ without modern features ]
CXX_DIALECT=-std=c++03 -fno-exceptions -fno-rtti -fno-strict-aliasing -fwrapv

WARNINGS=-Wall -Wextra -Wshadow -Wno-unused-parameter
OPTIMISE=-O2 -g
STRIP_FLAGS=--strip-unneeded

# default flags for compiler, preprocessor and linker
CXXFLAGS ?= $(OPTIMISE) $(WARNINGS)
CPPFLAGS ?=
LDFLAGS ?= $(OPTIMISE)
LIBS ?=

# general things needed by AJBSP
CXXFLAGS += $(CXX_DIALECT)
LIBS += -lm

# uncomment this for a fully statically linked binary:
# LDFLAGS += -static

# I needed this when using -m32 and -static together:
# LDFLAGS += -L/usr/lib/gcc/i686-linux-gnu/6/

MAN_PAGE=$(PROGRAM).6

OBJ_DIR=obj_linux

DUMMY=$(OBJ_DIR)/zzdummy


#----- Object files ----------------------------------------------

OBJS = \
	$(OBJ_DIR)/bsp_level.o \
	$(OBJ_DIR)/bsp_node.o  \
	$(OBJ_DIR)/bsp_util.o  \
	$(OBJ_DIR)/lib_util.o  \
	$(OBJ_DIR)/lib_file.o  \
	$(OBJ_DIR)/main.o      \
	$(OBJ_DIR)/w_wad.o

$(OBJ_DIR)/%.o: src/%.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<


#----- Targets -----------------------------------------------

all: $(DUMMY) $(PROGRAM)

clean:
	rm -f $(PROGRAM) $(OBJ_DIR)/*.[oa]
	rm -f core core.* ERRS

# this is used to create the OBJ_DIR directory
$(DUMMY):
	mkdir -p $(OBJ_DIR)
	@touch $@

$(PROGRAM): $(OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS) $(LIBS)

stripped: all
	strip $(STRIP_FLAGS) $(PROGRAM)

# note that DESTDIR is usually left undefined, and is mainly
# useful when making packages for Debian/RedHat/etc...

install: stripped
	install -d -m 755 $(DESTDIR)$(PREFIX)/bin
	install -o root -m 755 $(PROGRAM) $(DESTDIR)$(PREFIX)/bin/
	install -d -m 755 $(DESTDIR)$(MANDIR)/man6
	install -o root -m 644 doc/$(MAN_PAGE) $(DESTDIR)$(MANDIR)/man6/

uninstall:
	rm -f -v $(DESTDIR)$(PREFIX)/bin/$(PROGRAM)
	rm -f -v $(DESTDIR)$(MANDIR)/man6/$(MAN_PAGE)

.PHONY: all clean stripped install uninstall

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
