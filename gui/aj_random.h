
/**********************
   AJ RANDOM LIBRARY
***********************

by Andrew Apted, July 2014


The code herein is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this code.  Use at your own risk.

Permission is granted to anyone to use this code for any purpose,
including commercial applications, and to freely redistribute and
modify it.  An acknowledgement would be nice but is not required.

________________

ACKNOWLEDGEMENTS
________________

The RNG algorithm used is 'JKISS32' by (I presume) George Marsaglia,
described in David Jones's paper titled "Good Practice in (Pseudo)
Random Number Generation for Bioinformatics Applications".

_____

ABOUT
_____

This is a simple header-file library for generating fairly decent
random numbers, which is very fast and needs very little state.
I have tested it with 'dieharder' (albeit not extensively) and I am
satisfied that it is working properly.

Note that this generator is NOT suitable for cryptography.

In the file which you want to contain the implementation, add the
following _before_ the inclusion of this header :

    #define AJ_RANDOM_IMPLEMENTATION

____________

DEPENDENCIES
____________

No other libraries.

Requires a unsigned 32-bit integer type (uint32_t).
If you do not #define it yourself, then the C99 header <stdint.h>
is included to get it.

_______

C USAGE
_______

aj_rand_t is a structure containing the state for a single random
number generator.  A pointer to this structure must be passed to
all these C API functions.  The fields should not be externally
modified, but they can be saved/restored if necessary.

// initialize seed the generator with a 32-bit value.
// THE GENERATOR WILL NOT WORK BEFORE IT HAS BEEN SEEDED.

void aj_rand_Seed(aj_rand_t *R, uint32_t seed)

// for some applications you may want to supply more seed bits,
// which can be done with this function.  There are four 32-bit
// integers here, s1 to s4, where s1 is the most important one to
// contain a good seed, s2/s3 are of medium importance, and s4
// is almost useless.
//
// Some ideas for getting bits:
//    time() and/or gettimeofday() or GetTickCount()
//    read some bytes from /dev/urandom [for Linux]
//    a string hash of gethostname()
//    getpid(), getppid(), getuid()  [for Unixes]

void aj_rand_FullSeed(aj_rand_t *R, uint32_t s1, uint32_t s2,
									uint32_t s3, uint32_t s4)

// FIXME : Document rest of C API

_________

C++ USAGE
_________

aj_Random_c myRand;

myRand.Seed(12345);

myRand.Int() --> produce a 32 bit unsigned int

myRand.Double() --> produce a double in range [0.0 - 1.0)

[ a few more methods : see class definition below.... ]

*/


/* ---------------- API ------------------ */

#ifndef __AJ_RANDOM_API_H__
#define __AJ_RANDOM_API_H__

#ifndef uint32_t
#include <stdint.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
	uint32_t x, y, z, w, c;

} aj_rand_t;


void aj_rand_Seed(aj_rand_t *R, uint32_t seed);
void aj_rand_FullSeed(aj_rand_t *R, uint32_t s1, uint32_t s2,
									uint32_t s3, uint32_t s4);

unsigned int aj_rand_Int(aj_rand_t *R);
double aj_rand_Double(aj_rand_t *R);

int aj_rand_IntRange(aj_rand_t *R, int low, int high);
double aj_rand_DoubleRange(aj_rand_t *R, double low, double high);
double aj_rand_Skew(aj_rand_t *R, double mid, double dist);

#ifdef __cplusplus
}
#endif


/******  C++ API  ******/

#ifdef __cplusplus
class aj_Random_c
{
private:
	aj_rand_t R;

public:
	aj_Random_c()
	{
		R.x = R.y = R.z = R.w = R.c = 1;
	}

	~aj_Random_c()
	{ }

	void Seed(uint32_t seed)
	{
		aj_rand_Seed(&R, seed);
	}

	void FullSeed(uint32_t s1, uint32_t s2,
				  uint32_t s3, uint32_t s4 = 0)
	{
		aj_rand_FullSeed(&R, s1, s2, s3, s4);
	}

	inline uint32_t Int()
	{
		return aj_rand_Int(&R);
	}

	inline double Double()
	{
		return aj_rand_Double(&R);
	}

	inline int IntRange(int low, int high)
	{
		return aj_rand_IntRange(&R, low, high);
	}

	inline double DoubleRange(double low, double high)
	{
		return aj_rand_DoubleRange(&R, low, high);
	}

	inline double Skew(double mid = 0.0, double dist = 1.0)
	{
		return aj_rand_Skew(&R, mid, dist);
	}
};
#endif

#endif /* __AJ_RANDOM_API_H__ */


/* -------------- IMPLEMENTATION ---------------- */

#ifdef AJ_RANDOM_IMPLEMENTATION

#include <math.h>  /* ldexp */


static void ajrand__WarmUp(aj_rand_t *R)
{
	/* warm up the generator : discard some initial values */

	int loop;

	for (loop = 0 ; loop < 1000 ; loop++)
	{
		aj_rand_Int(R);
	}
}


void aj_rand_Seed(aj_rand_t *R, uint32_t seed)
{
	R->x = 1;
	R->y = (seed & 0xcccccccc) | 1;
	R->z = (seed & 0x33333333);
	R->w = 12345678;
	R->c = 0;

	ajrand__WarmUp(R);
}


void aj_rand_FullSeed(aj_rand_t *R, uint32_t s1, uint32_t s2,
					  uint32_t s3, uint32_t s4)
{
	R->y = s1;

	if (R->y == 0)
		R->y = 1;

	R->z = s2;
	R->w = s3;
	R->c = 1;

	R->x = s4;

	ajrand__WarmUp(R);
}


uint32_t aj_rand_Int(aj_rand_t *R)
{
	uint32_t t;

	/* y is an 'xorshift' generator, y must never be 0 */
	R->y ^= (R->y << 5);
	R->y ^= (R->y >> 7);
	R->y ^= (R->y << 22);

	/* the 'add-with-carry' (AWC) generator */
	t = R->z + R->w + R->c;

	R->z = R->w;
	R->c = (t & 0x80000000) >> 31;
	R->w = (t & 0x7fffffff);

	/* simple accumulator */
	R->x += 1411392427;

	/* combine three generators into one result */
	return R->y + R->w + R->x;
}


double aj_rand_Double(aj_rand_t *R)
{
	uint32_t a;  /* Upper 26 bits */
	uint32_t b;  /* Lower 27 bits */

	double res;

	a = aj_rand_Int(R) & 0x3ffffff;
	b = aj_rand_Int(R) & 0x7ffffff;

	res = ldexp(a * (double)0x8000000 + b, -53);

	return res;
}


int aj_rand_IntRange(aj_rand_t *R, int low, int high)
{
	uint32_t range, mod, limit, val;

	if (low >= high)
		return low;

	range = high - low + 1;

	/* compute remainder of (2 ^ 32) % range */
	mod = 0xffffffff % range;
	mod =  (mod + 1) % range;

	/* values above this would induce a bias into the result,
	 * so we must skip them.
	 */
	limit = 0xffffffff - mod;

	do
	{
		val = aj_rand_Int(R);

	} while (val > limit);

	val = val % range;

	return low + (int)val;
}


double aj_rand_DoubleRange(aj_rand_t *R, double low, double high)
{
	double val;

	if (low >= high)
		return low;

	val = aj_rand_Double(R);

	return low + val * (high - low);
}


double aj_rand_Skew(aj_rand_t *R, double mid, double dist)
{
	/* this is a poor man's normal distribution */

	double val;

	val  = aj_rand_Double(R);
	val -= aj_rand_Double(R);
	val += aj_rand_Double(R);
	val -= aj_rand_Double(R);

	return mid + dist * val / 2.0;
}

#endif  /* AJ_RANDOM_IMPLEMENTATION */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
