//------------------------------------------------------------------------
//  WAD : Wad file read/write functions.
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

#ifndef __OBLIGE_WAD_H__
#define __OBLIGE_WAD_H__


class level_c;



// directory entry

class lump_c : public listnode_c
{
public:
	lump_c(const char *_name = NULL);
	lump_c(const raw_wad_entry_t& entry);
	virtual ~lump_c();

	// name of lump
	const char *name;

	// offset/length of lump in wad
	int start;
	int length;

	// various flags
	int flags;

	// data of lump
	void *data;

	// amount of free space at end of data (for appending).
	int space;

	// level information, usually NULL
	level_c *lev_info;

public:
	inline lump_c *LumpNext() { return (lump_c*) NodeNext(); }
	inline lump_c *LumpPrev() { return (lump_c*) NodePrev(); }

	void Append(const void *n_data, int n_len);
};


// level information

class level_c
{
public:
	level_c(lump_c *_lump, int _flags = 0);
	virtual ~level_c();

	// associated lump in the wad
	lump_c *lump;

	// various flags
	int flags;

	// the child lumps
	list_c children;

public:
	inline const char *name() { return lump->name; }

	void SortLumps();
};


// wad header

class wad_c
{
	/* NOTE: This wad class has a very simplistic model.  You can use
	 *       it to read an existing WAD, and you can use it to create
	 *       a new WAD from scratch.  But you cannot load a wad, do
	 *       some modifications, then save it back.
	 */

public:
	wad_c();
	virtual ~wad_c();

public:
	enum { IWAD, PWAD };

	FILE *in_file;

	// kind of wad file (-1 if not opened yet)
	int kind;

	// number of entries in directory (original)
	int num_entries;

	// offset to start of directory
	int dir_start;

	// current directory entries
	list_c dir;

	// array of level names found
	const char ** level_names;
	int num_level_names;

public:
	/* ---- READ METHODS ---- */

	// open the input wad file and read the contents into memory.
	static wad_c *Load(const char *filename);

	bool CheckLevelName(const char *name);
	bool CheckLevelNameGL(const char *name);

	// find the level lump with the given name in the current level, and
	// return a reference to it.  Returns NULL if no such lump exists.
	// Level lumps are always present in memory (i.e. never marked
	// copyable).
	lump_c *FindLump(const char *name, level_c *level = NULL);

	// find a particular level in the wad directory, returning the
	// result, or NULL if not found.
	level_c *FindLevel(const char *map_name);
	level_c *FirstLevel();

	void CacheLump(lump_c *lump);

	/* ---- WRITE METHODS ---- */

	// save this wad into the given output file.  Returns true if
	// successful, or false if an error occurred.
	bool Save(const char *filename);

	lump_c *CreateLump(const char *name, level_c *level = NULL);
	level_c *CreateLevel(const char *name);

private:
	FILE *out_file;

	level_c *current_level;

	bool ReadHeader();
	void ReadDirEntry();
	void ReadDirectory();

	void ProcessDirEntry(lump_c *lump);

	void AddLevelName(const char *name);
	void DetermineLevelNames();

	/* ---- */

	static inline int AlignLen(int len)
	{
		return ((len + 3) & ~3);
	}

	void RecomputeDirectory();

	void WriteHeader();
	void WriteDirEntry(lump_c *lump);
	int  WriteDirectory(listnode_c *begin);
	int  WriteAllLumps(listnode_c *begin);
	void WriteLumpData(lump_c *lump);
};


/* ------ Global variables ------ */

extern wad_c *the_wad;
extern level_c *the_level;


#endif /* __OBLIGE_WAD_H__ */
