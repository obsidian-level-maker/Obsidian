ROBJECTS=rng-alg-fst.o rng-api-fst.o
OBJECTS=$(ROBJECTS)
TABLES=rng-32bit-tables.h

#FLAGS = -g -Wall
FLAGS = -O3 -fpack-struct
#FLAGS = -g

all: slump

clean:
	rm -f $(ROBJECTS) core make_32bit_tables $(TABLES) \
		slump slump1 *.wad SLUMP.OUT foo* slump0 slump3 *.o

rng-alg-fst.o: rng-alg-fst.c rng-alg-fst.h $(TABLES)
	$(CC) -c $(FLAGS) -o rng-alg-fst.o rng-alg-fst.c

rng-api-fst.o: rng-alg-fst.o rng-api-fst.h 
	$(CC) -c $(FLAGS) -o rng-api-fst.o rng-api-fst.c

make_32bit_tables: make_32bit_tables.c
	$(CC) -o make_32bit_tables make_32bit_tables.c

rng-32bit-tables.h: make_32bit_tables
	./make_32bit_tables > rng-32bit-tables.h

rng.o: rng.c rng-alg-fst.o rng-api-fst.o
	$(CC) -c $(FLAGS) -o rng.o rng.c

dump.o: dump.c slump.h
	$(CC) -c $(FLAGS) -o dump.o dump.c

slump.o: slump.c $(ROBJECTS) slump.h
	$(CC) -c $(FLAGS) -o slump.o slump.c

slump: main.c rng.o slump.o dump.o $(ROBJECTS) slump.h
	$(CC) $(FLAGS) -o slump main.c rng.o slump.o dump.o $(ROBJECTS)

