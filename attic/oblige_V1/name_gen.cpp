//------------------------------------------------------------------------
//  READABLE NAME Generation
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "defs.h"

namespace name_gen
{
/* private data */

uint32_g xor_values[32*2] =
{
	0x0184e0cb, 0x5ff666ac,
	0x1ed91c34, 0xfc3cfb81,
	0xffd14769, 0x17235246,
	0xc126ce98, 0x9fceccd6,
	0xd4118805, 0x1b9c217a,
	0x5efaca22, 0xa4fa5272,
	0xceda18b5, 0x4d679294,
	0xf8ed82fd, 0x00f90c31,
	0x78effad3, 0xc0302486,
	0x6f2488be, 0x2f259eb9,
	0xae18c28c, 0x33026c62,
	0x30f74370, 0xfaf23b51,
	0xe988d2ff, 0xf83ce076,
	0x97164e1c, 0xccb0d44a,
	0x294fc698, 0xe6ec0e24,
	0x49053502, 0x67957e11,
	0xa3529eb2, 0xb218da0b,
	0xad91efc0, 0x18b20586,
	0xd9ee5970, 0x6d802fcd,
	0xac677d41, 0x45aadb09,
	0x25bd7f5a, 0xf4aa1709,
	0x73729abe, 0x1955f57a,
	0xb7ff82fe, 0xc2fd4555,
	0x651ce530, 0xaca14345,
	0x3cf1625d, 0xdc1da391,
	0x45c2c40c, 0x490ad6f7,
	0x55d470ca, 0xe45368b2,
	0x466d30fd, 0xfd23f935,
	0x03c79884, 0x7014eaf0,
	0x46f9edee, 0xdde97ef1,
	0xca8bd6ef, 0x593b967c,
	0xc40e2d97, 0xeea252d1
};

/* Spicing algorithm:
 *     For each bit in the original value, XOR-in a random value which
 *     depends on the bit value (two choices per bit number).
 *
 *     The XORing cascades: it affects future choices of the random value.
 *
 *     The bit being tested is never modified.  That way we know which
 *     random value is needed to undo the change.
 */

uint32_g AddSpice(uint32_g val)
{
	for (uint32_g bit = 0; bit < 32; bit++)
	{
		uint32_g mask = (1U << bit);
		uint32_g offset = (val & mask) ? 1 : 0;

		val ^= (xor_values[bit*2 + offset] & ~mask);
	}

	return val;
}

uint32_g RemoveSpice(uint32_g val)
{
	for (uint32_g bit = 32; bit > 0; )
	{
		bit--;

		uint32_g mask = (1U << bit);
		uint32_g offset = (val & mask) ? 1 : 0;

		val ^= (xor_values[bit*2 + offset] & ~mask);
	}

	return val;
}


void Test()
{
	printf("------ SPICE TEST ------------------\n");

	for (uint32_g i = 0; i < 32; i++)
	{
		uint32_g R1 = random() & 0xFFFF;
		uint32_g R2 = random() & 0xFFFF;

		uint32_g value  = (i < 16) ? i : ((R1 << 16U) | R2);
		uint32_g spiced = AddSpice(value);
		uint32_g back   = RemoveSpice(spiced);

		printf("0x%08x -> 0x%08x -> 0x%08x\n", value, spiced, back);

		SYS_ASSERT(back == value);
	}

	printf("------------------------------------\n");
}


//------------------------------------------------------------------------

#if 0

/* Naming algorithm:
 *    A simple finite-state-machine.  Use 4 bits to choose a
 *    starting letter.  Then for each 3-bit value choose the
 *    next letter using the table for the current letter.
 *
 *    Hence only 31-bit seeds are supported (4 + 3 * 9).
 *
 *    Subsequent processing needed to make bad combinations
 *    more palatable.
 */

const char *letter_set[16] =
{
	"a" "ktpsfnyw",
	"e" "ktpsfnyw",
	"i" "ktpsfnlr",
	"o" "ktpsfnyw",
	"u" "ktpsfnlr",

	"y" "aeioulrn",
	"l" "aeiouyst",
	"r" "aeiouhsn",

	"k" "aeioulrw",
	"t" "aeiouhrw",
	"p" "aeiouhlr",
	"s" "aeiouhnt",

	"f" "aeiouylr",
	"h" "aeiouykn",
	"n" "aeioufkt",
	"w" "aeiouyhr"
};


void EncodeRawWord(char *buf, uint32_g seed)
{
	uint32_g L = (seed & 15);
	seed >>= 4;

	int i;
	for (i = 0; i < 10; i++)
	{
		buf[i] = letter_set[L][0];

		char NX = letter_set[L][1 + (seed & 7)];
		seed >>= 3;

		for (L = 0; L < 16; L++)
			if (letter_set[L][0] == NX)
				break;

		SYS_ASSERT(L != 16);
	}

	buf[i] = 0;
}

uint32_g DecodeRawWord(const char *buf)
{
	//@@@
}


void RemoveNiceness(char *buf, const char *name)
{
	//@@@
}

void AddNiceness(char *buf)
{
	//@@@
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

const char *Encode(uint32_g seed)
{
	seed = AddSpice(seed);

	char buf[32];

	EncodeRawWord(buf, seed);
	AddNiceness(buf);

	return UtilStrDup(buf);
}

uint32_g Decode(const char *name)
{
	char buf[32];

	RemoveNiceness(buf, name);

	uint32_g seed = DecodeRawWord(buf);
	seed = RemoveSpice(seed);

	return seed;
}

#endif

//------------------------------------------------------------------------

void JumpWithSpeed(double accel, double dist)
{
	double z = 0;
	double x = -dist;

	double mom_X = 0;
	double mom_Z = 0;

	double radius = 16.0;
	double friction = 0.9063;
	double gravity = 1.0;
	double drag = 1.00;

	int tic = 0;

	for (; z > -4096.0; tic++)
	{
		if (x <= 0)  // on ground
		{
			mom_X += accel;
		}

		// P_XYMovement, which handles step-ups, is called before P_ZMovement.
		x += mom_X;

		if (x > -radius)
		{
			PrintDebug("x = %+4.1f  z = %+4.1f  BX %+1.0f  BZ %+1.0f\n", x, z,
					floor((x + radius*2) / 64.0), floor((z + 24.0) / 64.0));
					// mom_X, mom_Z);
		}

		if (x <= 0)  // on ground
		{
			mom_X = mom_X * friction;
		}
		else
		{
			z += mom_Z;

			mom_X = mom_X * drag;

			// duplicate weird calc in Doom source
			if (fabs(mom_Z) < 0.1)
				mom_Z -= gravity;

			mom_Z = (mom_Z - gravity) * drag;
		}
	}

	PrintDebug("\n");
}

void JumpTest()
{
	PrintDebug("---WALKING----------------------------------------\n");
	JumpWithSpeed(1.5625 / 2.0, 512);

	PrintDebug("---RUNNING----------------------------------------\n");
	JumpWithSpeed(1.5625 / 1.0, 512);

	PrintDebug("---STRAFE-RUNNING---------------------------------\n");
	JumpWithSpeed(1.5625 * 1.42, 512);
}

}  // namespace name_gen
