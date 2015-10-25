//------------------------------------------------------------------------
// TWISTER.h
//------------------------------------------------------------------------
// Mersenne Twister random number generator -- a C++ class MTRand
// Based on code by Makoto Matsumoto, Takuji Nishimura, and Shawn Cokus
// Richard J. Wagner  v1.0  15 May 2003  rjwagner@writeme.com
//------------------------------------------------------------------------
// Simplified for use in ULTERIOR library : Andrew Apted, April 2005.
//------------------------------------------------------------------------

#ifndef __UTIL_M_MERSENNE_TWISTER__
#define __UTIL_M_MERSENNE_TWISTER__

// The Mersenne Twister is an algorithm for generating random numbers.  It
// was designed with consideration of the flaws in various other generators.
// The period, 2^19937-1, and the order of equidistribution, 623 dimensions,
// are far greater.  The generator is also fast; it avoids multiplication and
// division, and it benefits from caches and pipelines.  For more information
// see the inventors' web page at http://www.math.keio.ac.jp/~matumoto/emt.html

// Reference
// M. Matsumoto and T. Nishimura, "Mersenne Twister: A 623-Dimensionally
// Equidistributed Uniform Pseudo-Random Number Generator", ACM Transactions on
// Modeling and Computer Simulation, Vol. 8, No. 1, January 1998, pp 3-30.

// Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
// Copyright (C) 2000 - 2003, Richard J. Wagner
// All rights reserved.                          
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//   1. Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//
//   2. Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//   3. The names of its contributors may not be used to endorse or promote 
//      products derived from this software without specific prior written 
//      permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// The original code included the following notice:
//
//     When you use this, send an email to: matumoto@math.keio.ac.jp
//     with an appropriate reference to your work.
//
// It would be nice to CC: rjwagner@writeme.com and Cokus@math.washington.edu
// when you write.

// Not thread safe (unless auto-initialization is avoided and each thread has
// its own MTRand object)

class MT_rand_c
{
// Data
public:
	enum { N = 624 };       // length of state vector
	enum { SAVE = N + 1 };  // length of array for save()

private:
	enum { M = 397 };  // period parameter

	u32_t state[N];    // internal state
	u32_t *pNext;      // next value to get from state

	int left;          // number of values left before reload needed

//Methods
public:
	// initialize with a simple integer
	MT_rand_c(u32_t the_seed) { Seed(the_seed); }
	~MT_rand_c() { }

	// Do NOT use for CRYPTOGRAPHY without securely hashing several returned
	// values together, otherwise the generator state can be learned after
	// reading 624 consecutive values.

	// Access to 32-bit random numbers
	inline u32_t Rand();      // integer in [0..2^32-1]
	u32_t Rand(u32_t n);      // integer in [0..n] for n < 2^32

	double Rand_fp();   // floating point in [0..1) 

	// Re-seeding functions (same behavior as constructor)
	void Seed(u32_t the_seed);
	void Seed(const u32_t *bigSeed, int seedLength);

	// Saving and loading generator state
	void Save(u32_t *dest) const;     // to array of size SAVE
	void Load(const u32_t *source);   // from such array

private:
	void Initialize(u32_t the_seed);
	void Reload();

	inline u32_t hiBit(u32_t u) const { return u & 0x80000000UL; }
	inline u32_t loBit(u32_t u) const { return u & 0x00000001UL; }
	inline u32_t loBits(u32_t u) const { return u & 0x7fffffffUL; }
	inline u32_t mixBits(u32_t u, u32_t v) const
		{ return hiBit(u) | loBits(v); }
	inline u32_t twist(u32_t m, u32_t s0, u32_t s1) const
		{ return m ^ (mixBits(s0,s1)>>1) ^ (-loBit(s1) & 0x9908b0dfUL); }
};

//------------------------------------------------------------------------
//  IMPLEMENTATION
//------------------------------------------------------------------------

inline u32_t MT_rand_c::Rand()
{
	// Pull a 32-bit integer from the generator state
	// Every other access function simply transforms the numbers extracted here
	
	if (left == 0)
		Reload();

	left--;

	u32_t s1 = *pNext++;

	s1 ^= (s1 >> 11);
	s1 ^= (s1 <<  7) & 0x9d2c5680UL;
	s1 ^= (s1 << 15) & 0xefc60000UL;

	return (s1 ^ (s1 >> 18));
}

#endif // __UTIL_M_MERSENNE_TWISTER__
