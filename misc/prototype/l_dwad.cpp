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

// this includes everything we need
#include "defs.h"


#define DEBUG_DIR   1
#define DEBUG_LUMP  0

#define APPEND_BLKSIZE  256
#define LEVNAME_BUNCH   20


// Global variables
wad_c *the_wad;
level_c *the_level;


//------------------------------------------------------------------------

lump_c::lump_c(const raw_wad_entry_t& entry) :
	flags(0), data(NULL), space(0), lev_info(NULL)
{
	name = UtilStrNDup(entry.name, 8);

	start  = UINT32(entry.start);
	length = UINT32(entry.length);
}

lump_c::~lump_c()
{
	delete lev_info;

	if (data)
		UtilFree((void*)data);

	if (name)
		UtilFree((void*)name);
}


level_c::~level_c()
{
	for (lump_c *cur = (lump_c *)children.pop_front(); cur != NULL;
	             cur = (lump_c *)children.pop_front())
	{
		delete cur;
	}
}

lump_c::lump_c(const char *_name) :
	name(NULL), start(-1), length(0),
	flags(0), data(NULL), space(0), lev_info(NULL)
{
	if (_name)
		name = UtilStrDup(_name);
}


wad_c::wad_c() :
	in_file(NULL), kind(-1),
	num_entries(0), dir_start(-1), dir(),
	level_names(NULL), num_level_names(0),
	current_level(NULL)
{
	// nothing
}

wad_c::~wad_c()
{
	if (in_file)
		fclose(in_file);

	/* free directory entries */
	for (lump_c *cur = (lump_c *)dir.pop_front(); cur != NULL;
	             cur = (lump_c *)dir.pop_front())
	{
		delete cur;
	}

	/* free the level names */
	if (level_names)
	{
		for (int i = 0; i < num_level_names; i++)
			UtilFree((void *) level_names[i]);

		UtilFree(level_names);
	}
}

level_c::level_c(lump_c *_lump, int _flags) :
	lump(_lump), flags(_flags), children()
{
	// nothing
}


//------------------------------------------------------------------------
//  READ SUPPORT
//------------------------------------------------------------------------


#define NUM_LEVEL_LUMPS  12
#define NUM_GL_LUMPS     5

static const char *level_lumps[NUM_LEVEL_LUMPS]=
{
	"THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", 
	"SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP",
	"BEHAVIOR",  // <-- hexen support
	"SCRIPTS"  // -JL- Lump with script sources (Vavoom)
};

static const char *gl_lumps[NUM_GL_LUMPS]=
{
	"GL_VERT", "GL_SEGS", "GL_SSECT", "GL_NODES",
	"GL_PVS"  // -JL- PVS (Potentially Visible Set) lump
};


//
// CheckMagic
//
static bool CheckMagic(const char type[4])
{
	if ((type[0] == 'I' || type[0] == 'P') && 
		 type[1] == 'W' && type[2] == 'A' && type[3] == 'D')
	{
		return true;
	}

	return false;
}


//
// CheckLevelName
//
bool wad_c::CheckLevelName(const char *name)
{
	for (int i = 0; i < num_level_names; i++)
	{
		if (strcmp(level_names[i], name) == 0)
			return true;
	}

	return false;
}

static bool HasGLPrefix(const char *name)
{
	return (name[0] == 'G' && name[1] == 'L' && name[2] == '_');
}


//
// CheckLevelLumpName
//
// Tests if the entry name is one of the level lumps.
//
static bool CheckLevelLumpName(const char *name)
{
	for (int i = 0; i < NUM_LEVEL_LUMPS; i++)
	{
		if (strcmp(name, level_lumps[i]) == 0)
			return true;
	}

	return false;
}


//
// CheckGLLumpName
//
// Tests if the entry name matches one of the GL lump names.
//
static bool CheckGLLumpName(const char *name)
{
	for (int i = 0; i < NUM_GL_LUMPS; i++)
	{
		if (strcmp(name, gl_lumps[i]) == 0)
			return true;
	}

	return false;
}


//
// ReadHeader
//
// Returns true if successful, or FALSE if there was a problem (in
// which case the error message as been setup).
//
bool wad_c::ReadHeader()
{
	raw_wad_header_t header;

	size_t len = fread(&header, sizeof(header), 1, in_file);

	if (len != 1)
	{
		PrintWarn("Trouble reading wad header: %s\n", strerror(errno));
		return false;
	}

	if (! CheckMagic(header.type))
	{
		PrintWarn("This file is not a WAD file : bad magic\n");
		return false;
	}

	kind = (header.type[0] == 'I') ? IWAD : PWAD;

	num_entries = UINT32(header.num_entries);
	dir_start   = UINT32(header.dir_start);

	return true;
}


//
// ReadDirEntry
//
void wad_c::ReadDirEntry()
{
	raw_wad_entry_t entry;

	size_t len = fread(&entry, sizeof(entry), 1, in_file);

	if (len != 1)
		FatalError("Trouble reading wad directory");

	lump_c *lump = new lump_c(entry);

#if DEBUG_DIR
	PrintDebug("Read dir entry... %s\n", lump->name);
#endif

	dir.push_back(lump);
}

//
// Level name helper
//
void wad_c::AddLevelName(const char *name)
{
	if ((num_level_names % LEVNAME_BUNCH) == 0)
	{
		level_names = (const char **) UtilRealloc((void *)level_names,
				(num_level_names + LEVNAME_BUNCH) * sizeof(const char *));
	}

	level_names[num_level_names++] = UtilStrDup(name);
}

//
// DetermineLevelNames
//
void wad_c::DetermineLevelNames()
{
	for (lump_c *L = (lump_c*)dir.begin(); L != NULL; L = L->LumpNext())
	{
		// check if the next four lumps after the current lump match the
		// level-lump or GL-lump names.

		int i;
		lump_c *N;

		int normal_count = 0;
		int gl_count = 0;

		for (i = 0, N = L->LumpNext();
		     (i < 4) && (N != NULL);
			 i++, N = N->LumpNext())
		{
			if (strcmp(N->name, level_lumps[i]) == 0)
				normal_count++;

			if (strcmp(N->name, gl_lumps[i]) == 0)
				gl_count++;
		}

		if (normal_count != 4 && gl_count != 4)
			continue;

#if DEBUG_DIR
		PrintDebug("Found level name: %s\n", L->name);
#endif

		// check for invalid name and duplicate levels
		if (normal_count == 4 && strlen(L->name) > 5)
			PrintWarn("Bad level '%s' in wad (name too long)\n", L->name);
		else if (CheckLevelName(L->name))
			PrintWarn("Level name '%s' found twice in wad\n", L->name);
		else
			AddLevelName(L->name);
	}
}

//
// ProcessDirEntry
//
void wad_c::ProcessDirEntry(lump_c *lump)
{
	// --- LEVEL MARKERS ---

	if (CheckLevelName(lump->name))
	{
		lump->lev_info = new level_c(lump);

		current_level = lump->lev_info;

#if DEBUG_DIR
		PrintDebug("Process level... %s\n", lump->name);
#endif

		dir.push_back(lump);
		return;
	}

	// --- LEVEL LUMPS ---

	if (current_level)
	{
		if (HasGLPrefix(current_level->name()) ?
		    CheckGLLumpName(lump->name) : CheckLevelLumpName(lump->name))
		{
			// check for duplicates
			if (FindLump(lump->name, current_level))
			{
				PrintWarn("Duplicate entry '%s' ignored in %s\n",
						lump->name, current_level->name());

				delete lump;
				return;
			}

#if DEBUG_DIR
			PrintDebug("        |--- %s\n", lump->name);
#endif
			// link it in
			current_level->children.push_back(lump);
			return;
		}

		// non-level lump -- end previous level and fall through.
		current_level = NULL;
	}

	// --- ORDINARY LUMPS ---

#if DEBUG_DIR
	PrintDebug("Process dir... %s\n", lump->name);
#endif

	if (CheckLevelLumpName(lump->name))
		PrintWarn("Level lump '%s' found outside any level\n", lump->name);
	else if (CheckGLLumpName(lump->name))
		PrintWarn("GL lump '%s' found outside any level\n", lump->name);

	// link it in
	dir.push_back(lump);
}

//
// ReadDirectory
//
void wad_c::ReadDirectory()
{
	fseek(in_file, dir_start, SEEK_SET);

	for (int i = 0; i < num_entries; i++)
	{
		ReadDirEntry();
	}

	DetermineLevelNames();

	// finally, unlink all lumps and process each one in turn

	list_c temp(dir);

	dir.clear();

	for (lump_c *cur = (lump_c *) temp.pop_front(); cur;
	             cur = (lump_c *) temp.pop_front())
	{
		ProcessDirEntry(cur);
	}
}


/* ---------------------------------------------------------------- */


//
// FindLump
//
lump_c *wad_c::FindLump(const char *name, level_c *level)
{
	listnode_c *begin = level ? level->children.begin() : dir.begin();

	for (lump_c *L = (lump_c*)begin; L != NULL; L = L->LumpNext())
	{
		if (UtilStrCaseCmp(L->name, name) == 0)
			return L;
	}

	return NULL;  // not found
}



//
// FindLevel
//
level_c *wad_c::FindLevel(const char *map_name)
{
	lump_c *L;

	for (L = (lump_c*)dir.begin(); L != NULL; L = L->LumpNext())
	{
		if (! L->lev_info)
			continue;

		if (UtilStrCaseCmp(L->name, map_name) == 0)
			return L->lev_info;
	}

	return NULL;  // not found
}

//
// FirstLevel
//
level_c * wad_c::FirstLevel()
{
	lump_c *L;

	for (L = (lump_c*)dir.begin(); L != NULL; L = L->LumpNext())
	{
		if (L->lev_info)
			return L->lev_info;
	}

	return NULL;  // not found
}

//
// CacheLump
//
void wad_c::CacheLump(lump_c *lump)
{
	size_t len;

#if DEBUG_LUMP
	PrintDebug("Caching... %s (%d)\n", lump->name, lump->length);
#endif

	if (lump->length == 0)
		return;

	lump->data = UtilCalloc(lump->length);

	fseek(in_file, lump->start, SEEK_SET);

	len = fread(lump->data, lump->length, 1, in_file);

	if (len != 1)
	{
		if (current_level)
			PrintWarn("Trouble reading lump '%s' in %s\n",
					lump->name, current_level->name());
		else
			PrintWarn("Trouble reading lump '%s'\n", lump->name);
	}
}


//
// wad_c::Load
//
wad_c *wad_c::Load(const char *filename)
{
	wad_c *wad = new wad_c();

	// open input wad file & read header
	wad->in_file = fopen(filename, "rb");

	if (! wad->in_file)
	{
		PrintWarn("Cannot open WAD file %s : %s", filename, strerror(errno));
		return NULL;
	}

	if (! wad->ReadHeader())
		return NULL;

	PrintDebug("Opened %cWAD file : %s\n", (wad->kind == IWAD) ? 'I' : 'P', 
			filename); 
	PrintDebug("Reading %d dir entries at 0x%X\n", wad->num_entries, 
			wad->dir_start);

	// read directory
	wad->ReadDirectory();

	wad->current_level = NULL;

	return wad;
}


//------------------------------------------------------------------------
//  WRITE SUPPORT
//------------------------------------------------------------------------

//
// Append
//
void lump_c::Append(const void *n_data, int n_len)
{
	if (n_len == 0)
		return;

	if (length == 0)
	{
		space = MAX(n_len, APPEND_BLKSIZE);
		data = UtilCalloc(space);
	}
	else if (space < n_len)
	{
		space = MAX(n_len, APPEND_BLKSIZE);
		data = UtilRealloc(data, length + space);
	}

	memcpy(((char *)data) + length, n_data, n_len);

	length += n_len;
	space  -= n_len;
}

//
// CreateLump
//
lump_c *wad_c::CreateLump(const char *name, level_c *level)
{
	if (FindLump(name, level))
	{
		if (level)
			InternalError("Lump %s already exists in level %s\n", name, level->name());
		else
			InternalError("Lump %s already exists in WAD.\n", name);
	}

	lump_c *lump = new lump_c(name);

	if (level)
		level->children.push_back(lump);
	else
		dir.push_back(lump);
	
	return lump;
}

//
// CreateLevel
//
level_c *wad_c::CreateLevel(const char *name)
{
	lump_c *L = CreateLump(name);

	L->lev_info = new level_c(L); 

	return L->lev_info;
}


//
// SortLumps
//
// Algorithm is pretty simple: for each of the names, if a matching
// lump exists, move it to the head of the list.  By going backwards
// through the names, we ensure the correct order.
//
void level_c::SortLumps()
{
	for (int i = NUM_LEVEL_LUMPS + NUM_GL_LUMPS - 1; i >= 0; i--)
	{
		const char *cur_name = (i < NUM_LEVEL_LUMPS) ? level_lumps[i] :
							   gl_lumps[i - NUM_LEVEL_LUMPS];

		for (lump_c *L = (lump_c*)children.begin(); L != NULL; L = L->LumpNext())
		{
			if (UtilStrCaseCmp(L->name, cur_name) != 0)
				continue;

			children.remove(L);
			children.push_front(L);

			// continue with next name (important !!)
			break;
		}
	}
}

//
// WriteHeader
//
void wad_c::WriteHeader()
{
	raw_wad_header_t header;

	switch (kind)
	{
		case IWAD:
			strncpy(header.type, "IWAD", 4);
			break;

		case PWAD:
			strncpy(header.type, "PWAD", 4);
			break;

		default:
			AssertFail("WriteHeader: bad wad kind %d\n", kind);
			return;  /* NOT REACHED */
	}

	header.num_entries = UINT32(num_entries);
	header.dir_start   = UINT32(dir_start);

	size_t len = fwrite(&header, sizeof(header), 1, out_file);

	if (len != 1)
		PrintWarn("Trouble writing wad header\n");
}



//
// WriteLumpData
//
void wad_c::WriteLumpData(lump_c *lump)
{
	size_t len;
	int align_size;

#if DEBUG_LUMP
	PrintDebug("Writing... %s (%d)\n", lump->name, lump->length);
#endif

	if ((int)ftell(out_file) != lump->start)
		PrintWarn("Consistency failure writing %s (%08X != %08X)\n", 
				lump->name, (int)ftell(out_file), lump->start);

	if (lump->length == 0)
		return;

	len = fwrite(lump->data, lump->length, 1, out_file);

	if (len != 1)
		PrintWarn("Trouble writing lump %s\n", lump->name);

	align_size = AlignLen(lump->length) - lump->length;

	if (align_size > 0)
	{
		static const char zeros[4] = { 0, 0, 0, 0 };

		fwrite(zeros, 1, align_size, out_file);
	}
}


//
// WriteAllLumps
//
// Returns number of entries written.
//
int wad_c::WriteAllLumps(listnode_c *begin)
{
	int count = 0;

	for (lump_c *L = (lump_c*)begin; L != NULL; L = L->LumpNext())
	{
		WriteLumpData(L);
		count++;

		if (L->lev_info)
		{
			count += WriteAllLumps(L->lev_info->children.begin());
		}
	}

	fflush(out_file);

	return count;
}


//
// WriteDirEntry
//
void wad_c::WriteDirEntry(lump_c *lump)
{
	raw_wad_entry_t entry;

	strncpy(entry.name, lump->name, 8);

	entry.start  = UINT32(lump->start);
	entry.length = UINT32(lump->length);

	size_t len = fwrite(&entry, sizeof(entry), 1, out_file);

	if (len != 1)
		PrintWarn("Trouble writing wad directory\n");
}

//
// RecomputeDirectory
//
// Calculates all the lump offsets for the directory.
//
void wad_c::RecomputeDirectory()
{
	num_entries = 0;
	dir_start = sizeof(raw_wad_header_t);

	// run through all the lumps, recomputing the 'start' fields, the
	// number of lumps in the directory, the directory starting position,
	// and also sorting the lumps in the levels.

	for (lump_c *L = (lump_c*)dir.begin(); L != NULL; L = L->LumpNext())
	{
		L->start = dir_start;

		dir_start += AlignLen(L->length);
		num_entries++;

		level_c *lev = L->lev_info;

		if (! lev)
			continue;

		lev->SortLumps();

		for (lump_c *M = (lump_c*)lev->children.begin(); M != NULL; M = M->LumpNext())
		{
			M->start = dir_start;

			dir_start += AlignLen(M->length);
			num_entries++;
		}
	}
}


//
// WriteDirectory
//
// Returns number of entries written.
//
int wad_c::WriteDirectory(listnode_c *begin)
{
	int count = 0;

	for (lump_c *L = (lump_c *)begin; L; L = L->LumpNext())
	{
		WriteDirEntry(L);
		count++;

#if DEBUG_DIR
			PrintDebug("Write dir entry: %s\n", L->name);
#endif
		
		if (L->lev_info)
		{
#if DEBUG_DIR
			PrintDebug("{\n");
#endif
			count += WriteDirectory(L->lev_info->children.begin());
#if DEBUG_DIR
			PrintDebug("}\n");
#endif
		}
	}

	fflush(out_file);

	return count;
}

//
// wad_c::Save
//
bool wad_c::Save(const char *filename)
{
	PrintDebug("\n");
	PrintDebug("Saving WAD as %s\n\n", filename);

	if (kind < 0)
		kind = PWAD;

	RecomputeDirectory();

	// create output wad file & write the header
	out_file = fopen(filename, "wb");

	if (! out_file)
	{
		FatalError("Cannot open output WAD file: %s\n[%s]", filename, strerror(errno));
		return false; /* NOT REACHED */
	}

	WriteHeader();

	// now write all the lumps to the output wad
	int check1 = WriteAllLumps(dir.begin());

	// finally, write out the directory
	if ((int)ftell(out_file) != dir_start)
		PrintWarn("Consistency failure writing lump directory "
				"(%08X != %08X)\n", (int)ftell(out_file), dir_start);

	int check2 = WriteDirectory(dir.begin());

	if (check1 != num_entries || check2 != num_entries)
		InternalError("Write directory count consistency failure (%d,%d,%d)",
				check1, check2, num_entries);

	return true;
}

