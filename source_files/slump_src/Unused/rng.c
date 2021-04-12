/*
 * Copyright 2000 David Chess; Copyright 2005 Sam Trenholme
 *
 * Slump is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later
 * version.
 *
 * Slump is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Slump; see the file GPL.  If not, write to the Free
 * Software Foundation, 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Additionally, while not required for redistribution of this program, 
 * the following requests are made when making a derived version of 
 * this program:
 * 
 * - Slump's code is partly derived from the Doom map generator 
 *   called SLIGE, by David Chess.  Please inform David Chess of 
 *   any derived version that you make.  His email address is at 
 *   the domain "theogeny.com" with the name "chess" placed before 
 *   the at symbol.
 *
 * - Please do not call any derivative of this program SLIGE.
 *
 */

#include "rng-api-fst.h"
#include <stdlib.h>
#include <sys/types.h>
typedef unsigned char boolean;

#define R_TABLE_SIZE 1024
u_int32_t r_table[R_TABLE_SIZE]; /* table of number of times a given linenum
			            has been used for rng purposes*/
u_int32_t seed = 0;
static int rng_is_init = 0;
keyInstance r_seedInst;
cipherInstance r_cipherInst;
BYTE r_inBlock[17],r_outBlock[17],r_binSeed[17];
BYTE r_seedMaterial[320]; /* We may not eventually need this */

/* Clear the rtable and input block */
void clear_data() {
	int counter;
	for(counter = 0 ; counter < R_TABLE_SIZE ; counter++) 
		r_table[counter] = 0;
	for(counter = 0 ; counter < 16 ; counter++) 
		r_inBlock[counter] = 0;
	}

/* Initialize the random number generator */
void init_rng() {
	clear_data();
	/* "Slump ver. 0.002" needs 16 bytes:   0123456789abcdef */
	makeKey(&r_seedInst, DIR_ENCRYPT, 128, "Slump ver. 0.003");
	cipherInit(&r_cipherInst, MODE_ECB, NULL);
	}

void rng_set_seed(unsigned int seed) {
	clear_data();
	r_inBlock[5] = (seed & 0x7f00) >> 8;
	r_inBlock[6] = seed & 0xff;
}

/* Set up a new level */
void rng_set_level(int episode, int map, int mission, unsigned int seed,
                   int rooms) {
	seed &= 0x7fff; /* 32768 differnet worlds */
	/* printf("rng_set_level: %d %d %d %d\n",episode,map,mission,seed); *//* DEBUG */
	clear_data();
	r_inBlock[0] = episode & 0xff;
	r_inBlock[1] = map & 0xff;
	r_inBlock[2] = mission & 0xff;
        /* Bytes three and four reserved for the high bits of the seed */
	r_inBlock[5] = (seed & 0x7f00) >> 8;
	r_inBlock[6] = seed & 0xff;
        r_inBlock[7] = rooms;
        /* Bytes 8-10 still available */
}

/* Roll a zero-origin n-sided die */
int roll(int linenum,int n)
{
  u_int32_t toss;
  if(rng_is_init == 0) {
	  init_rng();
	  rng_is_init = 1;
  }
  r_inBlock[11] = linenum & 0xff;
  r_inBlock[10] = (linenum & 0xff00) >> 8;
  r_inBlock[15] = r_table[linenum] & 0xff;
  r_inBlock[14] = (r_table[linenum] & 0xff00) >> 8;
  r_inBlock[13] = (r_table[linenum] & 0xff0000) >> 16;
  r_inBlock[12] = (r_table[linenum] & 0xff000000) >> 24;
  r_table[linenum]++;
  if (n<1) return 0;
  if(blockEncrypt(&r_cipherInst, &r_seedInst, r_inBlock, 128, r_outBlock) 
		 != 128) {
	 printf("Fatal: RNG broken!\n");
	 exit(1);
         } 
  /*for(toss=0;toss<16;toss++){printf("%02x ",r_inBlock[toss]);}printf("\n");*/
  toss = (r_outBlock[12] & 0xff);
  toss <<= 8;
  toss |= (r_outBlock[13] & 0xff);
  toss <<= 8;
  toss |= (r_outBlock[14] & 0xff);
  toss <<= 8;
  toss |= (r_outBlock[15] & 0xff);
  return (toss % n);
}

/* Return 1 n percent of the time, else 0 */
boolean rollpercent(int linenum,int n)
{
  return (roll(linenum + 500,100)<n);
}

