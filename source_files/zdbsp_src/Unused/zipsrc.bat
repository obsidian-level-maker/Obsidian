zip -9 %1 COPYING Makefile *.cpp *.h *.c *.rc CMakeLists.txt unused/* zlib/*.c zlib/*.h zlib/CMakeLists.txt 
kzip b%1 COPYING Makefile *.cpp *.h *.c *.rc CMakeLists.txt unused/* zlib/*.c zlib/*.h zlib/CMakeLists.txt 
zipmix %1 b%1
del b%1