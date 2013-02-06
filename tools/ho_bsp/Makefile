####################################
#
# Makefile for UNIX and GCC
#
# Targets:
#    hobsp
#
#    all     : makes the library, cmdline program and docs
#    install : installs cmdline program
#    clean   : removes targets and intermediate files
#

CMD_NAME=hobsp

INSTALL_PREFIX=/usr/local

CC=gcc
CXX=g++
STRIP=strip --strip-unneeded

CFLAGS=-Wall -O2 -I./src -DUNIX -DINLINE_G=inline

LIBS=-lm -lz


# ----- GENERAL STUFF ----------------------------------------------

all:    $(CMD_NAME)

clean:
	rm -f $(CMD_NAME)
	rm -f obj_linux/*.o
	rm -f ./core ./ERRS ./gb_debug.txt 

.PHONY: all clean


# ----- OBJECTS ----------------------------------------------------

OBJS = \
	obj_linux/analyze.o  \
	obj_linux/glbsp.o    \
	obj_linux/level.o    \
	obj_linux/node.o     \
	obj_linux/seg.o      \
	obj_linux/system.o   \
	obj_linux/util.o     \
	obj_linux/wad.o      \
	\
	obj_linux/main.o

obj_linux/%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

# ----- TARGETS ----------------------------------------------

$(CMD_NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(LIBS)
	$(STRIP) $@

install: $(CMD_NAME)
	cp $(CMD_NAME) $(INSTALL_PREFIX)/bin/
	chown root $(INSTALL_PREFIX)/bin/$(CMD_NAME)
	chmod 755 $(INSTALL_PREFIX)/bin/$(CMD_NAME)

.PHONY: install

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
