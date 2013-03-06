//------------------------------------------------------------------------
//  ARCHIVE Handling - GRP files
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "headers.h"
#include "main.h"

#include <list>

#include "lib_util.h"
#include "lib_grp.h"


// #define LogPrintf  printf


//------------------------------------------------------------------------
//  GRP READING
//------------------------------------------------------------------------

static FILE *grp_R_fp;

static raw_grp_header_t  grp_R_header;
static raw_grp_lump_t * grp_R_dir;
static u32_t * grp_R_starts;


static const byte grp_magic_data[12] =
{
	0xb4, 0x9a, 0x91, 0xac, 0x96, 0x93,
	0x89, 0x9a, 0x8d, 0x92, 0x9e, 0x91
};


bool GRP_OpenRead(const char *filename)
{
	grp_R_fp = fopen(filename, "rb");

	if (! grp_R_fp)
	{
		LogPrintf("GRP_OpenRead: no such file: %s\n", filename);
		return false;
	}

	LogPrintf("Opened GRP file: %s\n", filename);

	if (fread(&grp_R_header, sizeof(grp_R_header), 1, grp_R_fp) != 1)
	{
		LogPrintf("GRP_OpenRead: failed reading header\n");
		fclose(grp_R_fp);
		return false;
	}

	if (grp_R_header.magic[0] != 'K')
	{
		LogPrintf("GRP_OpenRead: not a GRP file!\n");
		fclose(grp_R_fp);
		return false;
	}

	grp_R_header.num_lumps = LE_U32(grp_R_header.num_lumps);

	/* read directory */

	if (grp_R_header.num_lumps >= 5000)  // sanity check
	{
		LogPrintf("GRP_OpenRead: bad header (%d entries?)\n", grp_R_header.num_lumps);
		fclose(grp_R_fp);
		return false;
	}

	grp_R_dir = new raw_grp_lump_t[grp_R_header.num_lumps + 1];
	grp_R_starts = new u32_t[grp_R_header.num_lumps + 1];

	u32_t L_start = sizeof(raw_grp_header_t) +
		sizeof(raw_grp_lump_t) * grp_R_header.num_lumps;

	for (int i = 0; i < (int)grp_R_header.num_lumps; i++)
	{
		raw_grp_lump_t *L = &grp_R_dir[i];

		int res = fread(L, sizeof(raw_grp_lump_t), 1, grp_R_fp);

		if (res == EOF || res != 1 || ferror(grp_R_fp))
		{
			if (i == 0)
			{
				LogPrintf("GRP_OpenRead: could not read any dir-entries!\n");

				delete[] grp_R_dir;
				grp_R_dir = NULL;

				fclose(grp_R_fp);
				return false;
			}

			LogPrintf("GRP_OpenRead: hit EOF reading dir-entry %d\n", i);

			// truncate directory
			grp_R_header.num_lumps = i;
			break;
		}

		L->length = LE_U32(L->length);

		grp_R_starts[i] = L_start;
		L_start += L->length;

		//  DebugPrintf(" %4d: %08x %08x : %s\n", i, L->start, L->length, L->name);
	}

	return true; // OK
}


void GRP_CloseRead(void)
{
	fclose(grp_R_fp);

	LogPrintf("Closed GRP file\n");

	delete[] grp_R_dir;
	delete[] grp_R_starts;

	grp_R_dir = NULL;
	grp_R_starts = NULL;
}


int GRP_NumEntries(void)
{
	return (int)grp_R_header.num_lumps;
}


int GRP_FindEntry(const char *name)
{
	for (unsigned int i = 0; i < grp_R_header.num_lumps; i++)
	{
		char buffer[16];
		strncpy(buffer, grp_R_dir[i].name, 12);
		buffer[12] = 0;

		if (StringCaseCmp(name, buffer) == 0)
			return i;
	}

	return -1; // not found
}


int GRP_EntryLen(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

	return grp_R_dir[entry].length;
}


const char * GRP_EntryName(int entry)
{
	static char name_buf[16];

	SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

	// entries are often not NUL terminated, hence return a static copy
	strncpy(name_buf, grp_R_dir[entry].name, 12);
	name_buf[12] = 0;

	return name_buf;
}


bool GRP_ReadData(int entry, int offset, int length, void *buffer)
{
	SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);
	SYS_ASSERT(offset >= 0);
	SYS_ASSERT(length > 0);

	int L_start = grp_R_starts[entry];

	if ((u32_t)offset + (u32_t)length > grp_R_dir[entry].length)  // EOF
		return false;

	if (fseek(grp_R_fp, L_start + offset, SEEK_SET) != 0)
		return false;

	int res = fread(buffer, length, 1, grp_R_fp);
	return (res == 1);
}


void GRP_ListEntries(void)
{
	printf("--------------------------------------------------\n");

	if (grp_R_header.num_lumps == 0)
	{
		printf("GRP file is empty\n");
	}
	else
	{
		for (int i = 0; i < (int)grp_R_header.num_lumps; i++)
		{
			raw_grp_lump_t *L = &grp_R_dir[i];

			int L_start = grp_R_starts[i];

			printf("%4d: +%08x %08x : %s\n", i+1, L_start, L->length,
					GRP_EntryName(i));
		}
	}

	printf("--------------------------------------------------\n");
}


//------------------------------------------------------------------------
//  GRP WRITING
//------------------------------------------------------------------------

static FILE *grp_W_fp;

static std::list<raw_grp_lump_t> grp_W_directory;

static raw_grp_lump_t grp_W_lump;

// hackish workaround for the GRP format which places the
// directory before all the data files.
#define MAX_GRP_WRITE_ENTRIES  96


bool GRP_OpenWrite(const char *filename)
{
	grp_W_fp = fopen(filename, "wb");

	if (! grp_W_fp)
	{
		LogPrintf("GRP_OpenWrite: cannot create file: %s\n", filename);
		return false;
	}

	LogPrintf("Created GRP file: %s\n", filename);

	// write out a dummy header
	raw_grp_header_t header;
	memset(&header, 0, sizeof(header));

	fwrite(&header, sizeof(raw_grp_header_t), 1, grp_W_fp);
	fflush(grp_W_fp);

	// write out a dummy directory
	for (int i = 0; i < MAX_GRP_WRITE_ENTRIES; i++)
	{
		raw_grp_lump_t entry;
		memset(&entry, 0, sizeof(entry));

		sprintf(entry.name, "__%03d.ZZZ", i);

		entry.length = LE_U32(1);

		fwrite(&entry, sizeof(entry), 1, grp_W_fp);
	}

	fflush(grp_W_fp);

	return true;
}


void GRP_CloseWrite(void)
{
	// add dummy data for the dummy entries
	byte zero_buf[MAX_GRP_WRITE_ENTRIES];
	memset(zero_buf, 0, sizeof(zero_buf));

	fwrite(zero_buf, sizeof(zero_buf), 1, grp_W_fp);

	fflush(grp_W_fp);

	// write the _real_ GRP header

	fseek(grp_W_fp, 0, SEEK_SET);

	raw_grp_header_t header;

	for (unsigned int i = 0; i < sizeof(header.magic); i++)
		header.magic[i] = ~grp_magic_data[i];

	header.num_lumps = LE_U32(MAX_GRP_WRITE_ENTRIES); /// grp_W_directory.size());

	fwrite(&header, sizeof(header), 1, grp_W_fp);
	fflush(grp_W_fp);

	// write the _real_ directory

	LogPrintf("Writing GRP directory\n");

	std::list<raw_grp_lump_t>::iterator WDI;

	for (WDI = grp_W_directory.begin(); WDI != grp_W_directory.end(); WDI++)
	{
		raw_grp_lump_t *L = & (*WDI);

		fwrite(L, sizeof(raw_grp_lump_t), 1, grp_W_fp);
	}

	fflush(grp_W_fp);
	fclose(grp_W_fp);

	LogPrintf("Closed GRP file\n");

	grp_W_directory.clear();
}


void GRP_NewLump(const char *name)
{
	// FIXME: proper error messages
	SYS_ASSERT(grp_W_directory.size() < MAX_GRP_WRITE_ENTRIES);

	SYS_ASSERT(strlen(name) <= 12);

	memset(&grp_W_lump, 0, sizeof(grp_W_lump));

	strncpy(grp_W_lump.name, name, 12);
}


bool GRP_AppendData(const void *data, int length)
{
	if (length == 0)
		return true;

	SYS_ASSERT(length > 0);

	if (fwrite(data, length, 1, grp_W_fp) != 1)
		return false;

	grp_W_lump.length += (u32_t)length;
	return true; // OK
}


void GRP_FinishLump(void)
{
	// fix endianness
	grp_W_lump.length = LE_U32(grp_W_lump.length);

	grp_W_directory.push_back(grp_W_lump);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
