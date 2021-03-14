/*
    Routines for building a Doom map's BLOCKMAP lump.
    Copyright (C) 2002 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/
#include <stdio.h>
#include <string.h>

#include "zdbsp.h"
#include "templates.h"
#include "tarray.h"
#include "blockmapbuilder.h"

#undef BLOCK_TEST

FBlockmapBuilder::FBlockmapBuilder (FLevel &level)
	: Level (level)
{
	BuildBlockmap ();
}

#ifdef BLOCK_TEST
inline int PointOnSide (int x, int y, int x1, int y1, int dx, int dy)
{
	int foo = DMulScale32 ((y-y1) << 16, dx<<16, (x1-x)<<16, (dy)<<16);
	//return abs(foo) < 4 ? 0 : foo;
	return foo > 0;
}

int BoxOnSide (int bx1, int by1, int bx2, int by2,
					 int lx1, int ly1, int lx2, int ly2)
{
	int p1;
	int p2;
		
	if (ly1 == ly2)
	{
		p1 = by1 > ly1;
		p2 = by2 > ly1;
	}
	else if (lx1 == lx2)
	{
		p1 = bx2 < lx1;
		p2 = bx1 < lx1;
	}
	else if (((ly2-ly1) ^ (lx2-lx1)) >= 0)
	{
		p1 = PointOnSide (bx1, by1, lx1, ly1, lx2-lx1, ly2-ly1);
		p2 = PointOnSide (bx2, by2, lx1, ly1, lx2-lx1, ly2-ly1);
	}
	else
	{
		p1 = PointOnSide (bx2, by1, lx1, ly1, lx2-lx1, ly2-ly1);
		p2 = PointOnSide (bx1, by2, lx1, ly1, lx2-lx1, ly2-ly1);
	}

	return (p1 == p2) ? 0 : 1;
}
#endif

WORD *FBlockmapBuilder::GetBlockmap (int &size)
{
#ifdef BLOCK_TEST
	FILE *f = fopen ("blockmap.lmp", "rb");
	if (f)
	{
		size_t fsize;
		fseek (f, 0, SEEK_END);
		fsize = ftell (f);
		fseek (f, 0, SEEK_SET);
		short *stuff = (short *)alloca (fsize);
		fread (stuff, 2, fsize/2, f);
		fclose (f);

		if ((WORD)stuff[0] != BlockMap[0] ||
			(WORD)stuff[1] != BlockMap[1] ||
			(WORD)stuff[2] != BlockMap[2] ||
			(WORD)stuff[3] != BlockMap[3])
		{
			printf ("different blockmap sizes\n");
			goto notest;
		}
		int i, x, y;

		for (i = 0; i < stuff[2] * stuff[3]; ++i)
		{
			WORD i1, i2;
			i1 = stuff[4+i] + 1;
			while (stuff[i1] != -1)
			{
				i2 = BlockMap[4+i] + 1;
				while (BlockMap[i2] != 0xffff)
				{
					if (BlockMap[i2] == stuff[i1])
						break;
					i2++;
				}
				if (BlockMap[i2] == 0xffff)
				{
					y = i / stuff[2];
					x = i - y * stuff[2];
					int l = stuff[i1];
					// If a diagonal line passed near a block (within 2 or 4 units, I think),
					// it could be considered in the block even if it's really outside it,
					// so if things differ, see if DoomBSP was at fault.
					if (BoxOnSide (
						stuff[0] + 128*x, stuff[1] + 128*y,
						stuff[0] + 128*x + 127, stuff[1] + 128*y + 127,
						Vertices[Lines[l].v1].x, Vertices[Lines[l].v1].y,
						Vertices[Lines[l].v2].x, Vertices[Lines[l].v2].y))
					{
					  printf ("not in cell %4d: line %4d [%2d,%2d] : (%5d,%5d)-(%5d,%5d)\n", i, stuff[i1],
						x, y,
						stuff[0] + 128*x, stuff[1] + 128*y,
						stuff[0] + 128*x + 127, stuff[1] + 128*y + 127
						);
					}
				}
				i1 ++;
			}
			i1 = BlockMap[4+i] + 1;
			while (BlockMap[i1] != 0xffff)
			{
				i2 = stuff[4+i] + 1;
				while (stuff[i2] != -1)
				{
					if ((WORD)stuff[i2] == BlockMap[i1])
						break;
					i2++;
				}
				if (stuff[i2] == -1)
				{
					y = i / BlockMap[2];
					x = i - y * BlockMap[2];
					int l = BlockMap[i1];
					if (!BoxOnSide (
						(short)BlockMap[0] + 128*x, (short)BlockMap[1] + 128*y,
						(short)BlockMap[0] + 128*x + 127, (short)BlockMap[1] + 128*y + 127,
						Vertices[Lines[l].v1].x, Vertices[Lines[l].v1].y,
						Vertices[Lines[l].v2].x, Vertices[Lines[l].v2].y))
					{
					  printf ("EXT in cell %4d: line %4d [%2d,%2d] : (%5d,%5d)-(%5d,%5d)\n", i, (short)BlockMap[i1],
						x, y,
						(short)BlockMap[0] + 128*x, (short)BlockMap[1] + 128*y,
						(short)BlockMap[0] + 128*x + 127, (short)BlockMap[1] + 128*y + 127
						);
					}
				}
				i1 ++;
			}
		}
	}
notest:
#endif
	size = BlockMap.Size();
	return &BlockMap[0];
}

void FBlockmapBuilder::BuildBlockmap ()
{
	TArray<WORD> *BlockLists, *block, *endblock;
	WORD adder;
	int bmapwidth, bmapheight;
	int minx, maxx, miny, maxy;
	WORD line;

	if (Level.NumVertices <= 0)
		return;

	// Get map extents for the blockmap
	minx = Level.MinX >> FRACBITS;
	miny = Level.MinY >> FRACBITS;
	maxx = Level.MaxX >> FRACBITS;
	maxy = Level.MaxY >> FRACBITS;

/*
	// DoomBSP did this to give the map a margin when drawing it
	// in a window on NeXT machines. It's not necessary, but
	// it lets me verify my output against DoomBSP's for correctness.
	minx -= 8;
	miny -= 8;
	maxx += 8;
	maxy += 8;

	// And DeepBSP seems to do this.
	minx &= ~7;
	miny &= ~7;
*/
	bmapwidth =	 ((maxx - minx) >> BLOCKBITS) + 1;
	bmapheight = ((maxy - miny) >> BLOCKBITS) + 1;

	adder = WORD(minx);			BlockMap.Push (adder);
	adder = WORD(miny);			BlockMap.Push (adder);
	adder = WORD(bmapwidth);	BlockMap.Push (adder);
	adder = WORD(bmapheight);	BlockMap.Push (adder);

	BlockLists = new TArray<WORD>[bmapwidth * bmapheight];

	for (line = 0; line < Level.NumLines(); ++line)
	{
		int x1 = Level.Vertices[Level.Lines[line].v1].x >> FRACBITS;
		int y1 = Level.Vertices[Level.Lines[line].v1].y >> FRACBITS;
		int x2 = Level.Vertices[Level.Lines[line].v2].x >> FRACBITS;
		int y2 = Level.Vertices[Level.Lines[line].v2].y >> FRACBITS;
		int dx = x2 - x1;
		int dy = y2 - y1;
		int bx = (x1 - minx) >> BLOCKBITS;
		int by = (y1 - miny) >> BLOCKBITS;
		int bx2 = (x2 - minx) >> BLOCKBITS;
		int by2 = (y2 - miny) >> BLOCKBITS;

		block = &BlockLists[bx + by * bmapwidth];
		endblock = &BlockLists[bx2 + by2 * bmapwidth];

		if (block == endblock)	// Single block
		{
			block->Push (line);
		}
		else if (by == by2)		// Horizontal line
		{
			if (bx > bx2)
			{
				swap (block, endblock);
			}
			do
			{
				block->Push (line);
				block += 1;
			} while (block <= endblock);
		}
		else if (bx == bx2)	// Vertical line
		{
			if (by > by2)
			{
				swap (block, endblock);
			}
			do
			{
				block->Push (line);
				block += bmapwidth;
			} while (block <= endblock);
		}
		else				// Diagonal line
		{
			int xchange = (dx < 0) ? -1 : 1;
			int ychange = (dy < 0) ? -1 : 1;
			int ymove = ychange * bmapwidth;
			int adx = abs (dx);
			int ady = abs (dy);

			if (adx == ady)		// 45 degrees
			{
				int xb = (x1 - minx) & (BLOCKSIZE-1);
				int yb = (y1 - miny) & (BLOCKSIZE-1);
				if (dx < 0)
				{
					xb = BLOCKSIZE-xb;
				}
				if (dy < 0)
				{
					yb = BLOCKSIZE-yb;
				}
				if (xb < yb)
					adx--;
			}
			if (adx >= ady)		// X-major
			{
				int yadd = dy < 0 ? -1 : BLOCKSIZE;
				do
				{
					int stop = (Scale ((by << BLOCKBITS) + yadd - (y1 - miny), dx, dy) + (x1 - minx)) >> BLOCKBITS;
					while (bx != stop)
					{
						block->Push (line);
						block += xchange;
						bx += xchange;
					}
					block->Push (line);
					block += ymove;
					by += ychange;
				} while (by != by2);
				while (block != endblock)
				{
					block->Push (line);
					block += xchange;
				}
				block->Push (line);
			}
			else					// Y-major
			{
				int xadd = dx < 0 ? -1 : BLOCKSIZE;
				do
				{
					int stop = (Scale ((bx << BLOCKBITS) + xadd - (x1 - minx), dy, dx) + (y1 - miny)) >> BLOCKBITS;
					while (by != stop)
					{
						block->Push (line);
						block += ymove;
						by += ychange;
					}
					block->Push (line);
					block += xchange;
					bx += xchange;
				} while (bx != bx2);
				while (block != endblock)
				{
					block->Push (line);
					block += ymove;
				}
				block->Push (line);
			}
		}
	}

	BlockMap.Reserve (bmapwidth * bmapheight);
	CreatePackedBlockmap (BlockLists, bmapwidth, bmapheight);
	delete[] BlockLists;
}

void FBlockmapBuilder::CreateUnpackedBlockmap (TArray<WORD> *blocks, int bmapwidth, int bmapheight)
{
	TArray<WORD> *block;
	WORD zero = 0;
	WORD terminator = 0xffff;

	for (int i = 0; i < bmapwidth * bmapheight; ++i)
	{
		BlockMap[4+i] = WORD(BlockMap.Size());
		BlockMap.Push (zero);
		block = &blocks[i];
		for (unsigned int j = 0; j < block->Size(); ++j)
		{
			BlockMap.Push ((*block)[j]);
		}
		BlockMap.Push (terminator);
	}
}

static unsigned int BlockHash (TArray<WORD> *block)
{
	int hash = 0;
	WORD *ar = &(*block)[0];
	for (size_t i = 0; i < block->Size(); ++i)
	{
		hash = hash * 12235 + ar[i];
	}
	return hash & 0x7fffffff;
}

static bool BlockCompare (TArray<WORD> *block1, TArray<WORD> *block2)
{
	size_t size = block1->Size();

	if (size != block2->Size())
	{
		return false;
	}
	if (size == 0)
	{
		return true;
	}
	WORD *ar1 = &(*block1)[0];
	WORD *ar2 = &(*block2)[0];
	for (size_t i = 0; i < size; ++i)
	{
		if (ar1[i] != ar2[i])
		{
			return false;
		}
	}
	return true;
}

void FBlockmapBuilder::CreatePackedBlockmap (TArray<WORD> *blocks, int bmapwidth, int bmapheight)
{
	WORD buckets[4096];
	WORD *hashes, hashblock;
	TArray<WORD> *block;
	WORD zero = 0;
	WORD terminator = 0xffff;
	WORD *array;
	int i, hash;
	int hashed = 0, nothashed = 0;

	hashes = new WORD[bmapwidth * bmapheight];

	memset (hashes, 0xff, sizeof(WORD)*bmapwidth*bmapheight);
	memset (buckets, 0xff, sizeof(buckets));

	for (i = 0; i < bmapwidth * bmapheight; ++i)
	{
		block = &blocks[i];
		hash = BlockHash (block) % 4096;
		hashblock = buckets[hash];
		while (hashblock != 0xffff)
		{
			if (BlockCompare (block, &blocks[hashblock]))
			{
				break;
			}
			hashblock = hashes[hashblock];
		}
		if (hashblock != 0xffff)
		{
			BlockMap[4+i] = BlockMap[4+hashblock];
			hashed++;
		}
		else
		{
			hashes[i] = buckets[hash];
			buckets[hash] = WORD(i);
			BlockMap[4+i] = WORD(BlockMap.Size());
			BlockMap.Push (zero);
			array = &(*block)[0];
			for (size_t j = 0; j < block->Size(); ++j)
			{
				BlockMap.Push (array[j]);
			}
			BlockMap.Push (terminator);
			nothashed++;
		}
	}

	delete[] hashes;

//	printf ("%d blocks written, %d blocks saved\n", nothashed, hashed);
}

