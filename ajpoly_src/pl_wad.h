//------------------------------------------------------------------------
//
//  AJ-Polygonator (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#ifndef __AJPOLY_WAD_H__
#define __AJPOLY_WAD_H__


// directory entry

class lump_c
{
public:
	// name of lump
	char name[10];

	// offset to start of lump
	int start;

	// length of lump
	int length;

	// various flags
	int flags;
 
 	// # of following lumps (if a level), otherwise zero
	int children;

public:
	lump_c(const char *_name, int _start, int _len) :
		start(_start), length(_len),
		flags(0), children(0)
	{
		strcpy(name, _name);
	}

	~lump_c()
	{ }
};


// wad header

class wad_c
{
private:
	FILE *fp;

	// directory entries
	std::vector<lump_c *> lumps;

	// current data from ReadLump()
	byte * data_block;
	int    data_len;

public:
	wad_c() : fp(NULL), lumps(), data_block(NULL), data_len()
	{ }

	virtual ~wad_c();

	// open the wad file for reading and load the directory.
	// returns NULL on error (and an error message will have been set).
	// just delete the wad to close it.
	static wad_c * Open(const char *filename);

	// find a particular level in the directory and return its
	// index number, or -1 if it cannot be found.
	// use "*" as the name to find the first level.
	int FindLevel(const char *name);

	// read lump contents into memory.  only one lump can be read
	// at a time -- the wad code takes care of allocation / freeing.
	//
	// the 'length' variable will be set to the lump's length.
	// when 'level' is >= 0, the lump is part of a particular level.
	// returns NULL if the lump cannot be found.
	byte * ReadLump(const char *name, int *length, int level = -1);

private:
	bool ReadDirectory();
	bool ReadDirEntry();
	void DetermineLevels();

	int FindLump(const char *name, int level = -1);
	byte * AllocateData(int length);
	void FreeData();
};


extern wad_c * the_wad;


#endif /* __AJPOLY_WAD_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
