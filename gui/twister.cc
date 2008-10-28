//------------------------------------------------------------------------
// TWISTER.CC
//------------------------------------------------------------------------
// Mersenne Twister random number generator -- a C++ class MTRand
// Based on code by Makoto Matsumoto, Takuji Nishimura, and Shawn Cokus
// Richard J. Wagner  v1.0  15 May 2003  rjwagner@writeme.com
//------------------------------------------------------------------------
// Simplified for use in ULTERIOR library : Andrew Apted, April 2005.
//------------------------------------------------------------------------

/* Please see the extensive comments in twister.h */

#include "headers.h"
#include "twister.h"

u32_t MT_rand_c::Rand(u32_t n)
{
	// Find which bits are used in integer 'n'
	// Optimized by Magnus Jonsson (magnus@smartelectronix.com)
	u32_t used = n;

	used |= used >> 1;
	used |= used >> 2;
	used |= used >> 4;
	used |= used >> 8;
	used |= used >> 16;
	
	// Draw numbers until one is found in [0,n]
	u32_t i;

	do
		i = Rand() & used;  // toss unused bits to shorten search
	while (i > n);

	return i;
}

double MT_rand_c::Rand_fp()
{
	// floating point in the range [0-1)
	// i.e. exact 0 is possible, but exact 1 is not
	// (though conversion to 'float' might round the value upto 1)

	int raw = Rand() & 0x7FFFFFFF;

	return (double)raw / 2147483648.0;
}

void MT_rand_c::Seed(u32_t the_seed)
{
	// Seed the generator with a simple u32_t
	Initialize(the_seed);
	Reload();
}

void MT_rand_c::Seed(const u32_t *bigSeed, int seedLength)
{
	// Seed the generator with an array of uint32's.
	// There are 2^19937-1 possible initial states.  This function allows
	// all of those to be accessed by providing at least 19937 bits (with a
	// default seed length of N = 624 uint32's).  Any bits above the lower 32
	// in each element are discarded.

	Initialize(19650218UL);

	int i = 1;
	int j = 0;
	int k = ( N > seedLength ? N : seedLength );

	for (; k; k--)
	{
		state[i] = state[i] ^ ((state[i-1] ^ (state[i-1] >> 30)) * 1664525UL);
		state[i] += (bigSeed[j] & 0xffffffffUL) + (u32_t) j;
		state[i] &= 0xffffffffUL;

		i++;
		if (i >= N)
		{
			state[0] = state[N-1];
			i = 1;
		}

		j++;
		if (j >= seedLength)
			j = 0;
	}

	for (k = N - 1; k; k--)
	{
		state[i] = state[i] ^ ((state[i-1] ^ (state[i-1] >> 30)) * 1566083941UL);
		state[i] -= i;
		state[i] &= 0xffffffffUL;

		i++;
		if (i >= N)
		{
			state[0] = state[N-1];
			i = 1;
		}
	}

	state[0] = 0x80000000UL;  // MSB is 1, assuring non-zero initial array
	Reload();
}

void MT_rand_c::Initialize(const u32_t the_seed)
{
	// Initialize generator state with seed
	// See Knuth TAOCP Vol 2, 3rd Ed, p.106 for multiplier.
	// In previous versions, most significant bits (MSBs) of the seed affect
	// only MSBs of the state array.  Modified 9 Jan 2002 by Makoto Matsumoto.

	u32_t *s = state;
	u32_t *r = state;

	*s++ = the_seed & 0xffffffffUL;

	for (int i = 1; i < N; i++, r++)
	{
		*s++ = (1812433253UL * (*r ^ (*r >> 30)) + i) & 0xffffffffUL;
	}
}

void MT_rand_c::Reload()
{
	// Generate N new values in state
	// Made clearer and faster by Matthew Bellew (matthew.bellew@home.com)
	u32_t *p = state;

	for (int i = N - M; i--; p++)
		*p = twist(p[M], p[0], p[1]);

	for (int j = M; --j; p++)
		*p = twist(p[M-N], p[0], p[1]);

	*p = twist(p[M-N], p[0], state[0]);

	left  = N;
	pNext = state;
}

void MT_rand_c::Save(u32_t *dest) const
{
	for (int i = 0; i < N; i++)
		*dest++ = state[i];

	*dest = left;
}

void MT_rand_c::Load(const u32_t *source)
{
	for (int i = 0; i < N; i++)
		state[i] = *source++;

	left = *source;
	pNext = &state[N-left];
}

