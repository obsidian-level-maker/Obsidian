#----------------------------------------------------------------
# Makefile for dumpbsp tools
#----------------------------------------------------------------

# TODO : the q1 and q2 tools

all: dumpbsp_q3

clean: clean_q3

.PHONY: all clean clean_q3


#----------------------------------------------------------------
# Q3 DUMPBSP tool
#----------------------------------------------------------------

Q3_TOOLS_DIR=/home/aapted/other/Quake-III-Arena

Q3_LIB_DIR=$(Q3_TOOLS_DIR)/common

CC=gcc

CFLAGS=-O0 -g3 -Wall -I$(Q3_LIB_DIR)

LDFLAGS=

LIBS=-lm

OBJS=dumpbsp_q3.o

Q3_LIB_OBJS=\
	obj_q3/aselib.o     \
	obj_q3/cmdlib.o     \
	obj_q3/md4.o        \
	obj_q3/polylib.o    \
	obj_q3/threads.o    \
	obj_q3/bspfile.o    \
	obj_q3/imagelib.o   \
	obj_q3/mathlib.o    \
	obj_q3/mutex.o      \
	obj_q3/scriplib.o   \
	obj_q3/trilib.o

obj_q3/%.o: $(Q3_LIB_DIR)/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

dumpbsp_q3: $(OBJS) $(Q3_LIB_OBJS)
	$(CC) -Wl,--warn-common $^ -o $@ $(LDFLAGS) $(LIBS)

clean_q3:
	rm -f dumpbsp_q3
	rm -f dumpbsp_q3.o obj_q3/*.o
	rm -f ERRS

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
