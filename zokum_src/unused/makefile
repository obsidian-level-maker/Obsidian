# zennode makefile for Linux

CC       = g++
CFLAGS  += -g -O -fstrength-reduce -fno-rtti
#CFLAGS  += -fomit-frame-pointer -foptimize-sibling-calls
#CFLAGS  += -fbranch-probabilities
#CFLAGS  += -fprofile-arcs
#WARNINGS = -Wall -Wno-format -Winline
#CC       = /opt/intel/compiler60/ia32/bin/icc
#CFLAGS   = -g -O3
#CFLAGS   = -fpermissive -O3 -pipe -march=k8
#CFLAGS	  = -O0 -g -pipe 
#CFLAGS   = -O2 -pipe -static
CFLAGS   = -O2 -pipe -fomit-frame-pointer -foptimize-sibling-calls -fbranch-probabilities
#CFLAGS    = -O2 -pipe -m32 -fomit-frame-pointer
INCLUDES = -I../doom -I../common
#TARGETS  = ZokumBSP bspdiff bspinfo compare
TARGETS = zokumbsp
LINKFLAGS = -static
LINKFLAGS =

CFLAGS  += -D__LINUX__

ifdef WIN32
CFLAGS  += -D__WIN32__
endif

ifdef DEBUG
CFLAGS  += -DDEBUG
LOGGER   = ../common/logger/logger.o ../common/logger/string.o
CFLAGS  += -fexceptions
LOGGER  += ../common/logger/linux-logger.o
LIBS    += -lpthread -lrt
endif

.cpp.o:
	$(CC) -c $(CFLAGS) $(WARNINGS) $(INCLUDES) -o $@ $<

.SUFFIXES: .cpp .o

all: $(TARGETS)

depend: clean

clean:
	rm -rf {.,../doom/,../common/logger}/{*.o,*~} $(TARGETS)

zokumbsp:quicksort.o preprocess.o zenmain.o zennode.o zenreject.o zenrmb.o blockmap.o console.o endoom.o ../doom/wadlist.o ../doom/wad.o ../doom/level.o $(LOGGER)
	$(CC) $(LIBS) -o $@ $^ $(LINKFLAGS)

bspdiff: bspdiff.o console.o ../doom/wad.o ../doom/wadlist.o ../doom/level.o $(LOGGER)
	$(CC) $(LIBS) -o $@ $^ $(LINKFLAGS)

bspinfo: bspinfo.o console.o ../doom/wad.o ../doom/wadlist.o ../doom/level.o $(LOGGER)
	$(CC) $(LIBS) -o $@ $^ $(LINKFLAGS)

compare: compare.o console.o ../doom/wad.o ../doom/wadlist.o ../doom/level.o $(LOGGER)
	$(CC) $(LIBS) -o $@ $^ $(LINKFLAGS)

zenreject.o: \
	zenreject.cpp	\
	zenreject-util.cpp	\
	../common/common.hpp	\
	../doom/level.hpp	\
	zennode.hpp		\
	console.hpp		\
	geometry.hpp

zennode.o: \
	zennode.cpp		\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/level.hpp	\
	zennode.hpp		\
	console.hpp

zenMain.o: \
	zenMain.cpp		\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp	\
	console.hpp		\
	zennode.hpp

zenreject.o: \
	zenreject.cpp		\
	../common/common.hpp	\
	../doom/level.hpp	\
	zennode.hpp		\
	console.hpp		\
	geometry.hpp

zenrmb.o: \
	zenrmb.cpp		\
	../common/common.hpp	\
	../doom/level.hpp	\
	zennode.hpp

blockmap.o: \
	blockmap.cpp		\
	../common/common.hpp	\
	../doom/level.hpp	\
	zennode.hpp		\
	endoom.hpp


console.o: \
	console.cpp		\
	../doom/level.hpp	\
	../common/common.hpp	\
	console.hpp		\

wadlist.o: \
	../doom/wadlist.cpp     \
	../common/common.hpp    \
	../doom/wadlist.hpp     \
	../doom/level.hpp

../doom/wad.o: \
	../doom/wad.cpp		\
	../common/common.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp

../doom/level.o: \
	../doom/level.cpp	\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp

bspdiff.o: \
	bspdiff.cpp		\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp	\
	console.hpp

bspinfo.o: \
	bspinfo.cpp		\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp	\
	console.hpp

compare.o: \
	compare.cpp		\
	../common/common.hpp	\
	../common/logger.hpp	\
	../doom/wad.hpp		\
	../doom/level.hpp	\
	console.hpp

quicksort.o: \
	../common/common.hpp \
	quicksort.cpp \
	quicksort.hpp 

endoom.o: \
	endoom.cpp \
	endoom.hpp

preprocess.o: \
	preprocess.cpp \
	preprocess.hpp 
