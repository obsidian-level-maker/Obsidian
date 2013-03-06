//------------------------------------------------------------------------
//  ARCHIVE handling - Quake1/2 PAK files
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
#include "lib_pak.h"


// #define LogPrintf  printf


//------------------------------------------------------------------------
//  PAK READING
//------------------------------------------------------------------------

static FILE *r_pak_fp;

static raw_pak_header_t r_header;

static raw_pak_entry_t * r_directory;


bool PAK_OpenRead(const char *filename)
{
	r_pak_fp = fopen(filename, "rb");

	if (! r_pak_fp)
	{
		LogPrintf("PAK_OpenRead: no such file: %s\n", filename);
		return false;
	}

	LogPrintf("Opened PAK file: %s\n", filename);

	if (fread(&r_header, sizeof(r_header), 1, r_pak_fp) != 1)
	{
		LogPrintf("PAK_OpenRead: failed reading header\n");
		fclose(r_pak_fp);
		return false;
	}

	if (memcmp(r_header.magic, PAK_MAGIC, 4) != 0)
	{
		LogPrintf("PAK_OpenRead: not a PAK file!\n");
		fclose(r_pak_fp);
		return false;
	}

	r_header.dir_start = LE_U32(r_header.dir_start);
	r_header.entry_num = LE_U32(r_header.entry_num);

	// convert directory length to entry count
	r_header.entry_num /= sizeof(raw_pak_entry_t);

	/* read directory */

	if (r_header.entry_num >= 5000)  // sanity check
	{
		LogPrintf("PAK_OpenRead: bad header (%d entries?)\n", r_header.entry_num);
		fclose(r_pak_fp);
		return false;
	}

	if (fseek(r_pak_fp, r_header.dir_start, SEEK_SET) != 0)
	{
		LogPrintf("PAK_OpenRead: cannot seek to directory (at 0x%08x)\n", r_header.dir_start);
		fclose(r_pak_fp);
		return false;
	}

	r_directory = new raw_pak_entry_t[r_header.entry_num + 1];

	for (int i = 0; i < (int)r_header.entry_num; i++)
	{
		raw_pak_entry_t *E = &r_directory[i];

		int res = fread(E, sizeof(raw_pak_entry_t), 1, r_pak_fp);

		if (res == EOF || res != 1 || ferror(r_pak_fp))
		{
			if (i == 0)
			{
				LogPrintf("PAK_OpenRead: could not read any dir-entries!\n");

				delete[] r_directory;
				r_directory = NULL;

				fclose(r_pak_fp);
				return false;
			}

			LogPrintf("PAK_OpenRead: hit EOF reading dir-entry %d\n", i);

			// truncate directory
			r_header.entry_num = i;
			break;
		}

		// make sure name is NUL terminated.
		E->name[55] = 0;

		E->offset = LE_U32(E->offset);
		E->length = LE_U32(E->length);

		//  DebugPrintf(" %4d: %08x %08x : %s\n", i, E->offset, E->length, E->name);
	}

	return true; // OK
}


void PAK_CloseRead(void)
{
	fclose(r_pak_fp);

	LogPrintf("Closed PAK file\n");

	delete[] r_directory;
	r_directory = NULL;
}


int PAK_NumEntries(void)
{
	return (int)r_header.entry_num;
}


int PAK_FindEntry(const char *name)
{
	for (unsigned int i = 0; i < r_header.entry_num; i++)
	{
		if (StringCaseCmp(name, r_directory[i].name) == 0)
			return i;
	}

	return -1; // not found
}


int PAK_EntryLen(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);

	return r_directory[entry].length;
}


const char * PAK_EntryName(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);

	return r_directory[entry].name;
}


void PAK_FindMaps(std::vector<int>& entries)
{
	entries.resize(0);

	for (int i = 0; i < (int)r_header.entry_num; i++)
	{
		raw_pak_entry_t *E = &r_directory[i];

		const char *name = E->name;

		if (strncmp(name, "maps/", 5) != 0)
			continue;

		name += 5;

		// ignore the ammo boxes
		if (strncmp(name, "b_", 2) == 0)
			continue;

		while (*name && *name != '/' && *name != '.')
			name++;

		if (strcmp(name, ".bsp") == 0)
		{
			entries.push_back(i);

			//    DebugPrintf("Found map [%d] : '%s'\n", i, E->name);
		}
	}
}


bool PAK_ReadData(int entry, int offset, int length, void *buffer)
{
	SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);
	SYS_ASSERT(offset >= 0);
	SYS_ASSERT(length > 0);

	raw_pak_entry_t *E = &r_directory[entry];

	if ((u32_t)offset + (u32_t)length > E->length)  // EOF
		return false;

	if (fseek(r_pak_fp, E->offset + offset, SEEK_SET) != 0)
		return false;

	int res = fread(buffer, length, 1, r_pak_fp);

	return (res == 1);
}


void PAK_ListEntries(void)
{
	printf("--------------------------------------------------\n");

	if (r_header.entry_num == 0)
	{
		printf("PAK file is empty\n");
	}
	else
	{
		for (int i = 0; i < (int)r_header.entry_num; i++)
		{
			raw_pak_entry_t *E = &r_directory[i];

			printf("%4d: +%08x %08x : %s\n", i+1, E->offset, E->length, E->name);
		}
	}

	printf("--------------------------------------------------\n");
}


//------------------------------------------------------------------------
//  PAK WRITING
//------------------------------------------------------------------------

static FILE *w_pak_fp;

static std::list<raw_pak_entry_t> w_pak_dir;

static raw_pak_entry_t w_pak_entry;


bool PAK_OpenWrite(const char *filename)
{
	w_pak_fp = fopen(filename, "wb");

	if (! w_pak_fp)
	{
		LogPrintf("PAK_OpenWrite: cannot create file: %s\n", filename);
		return false;
	}

	LogPrintf("Created PAK file: %s\n", filename);

	// write out a dummy header
	raw_pak_header_t header;
	memset(&header, 0, sizeof(header));

	fwrite(&header, sizeof(raw_pak_header_t), 1, w_pak_fp);
	fflush(w_pak_fp);

	return true;
}


void PAK_CloseWrite(void)
{
	fflush(w_pak_fp);

	// write the directory

	LogPrintf("Writing PAK directory\n");

	raw_pak_header_t header;

	memcpy(header.magic, PAK_MAGIC, 4);

	header.dir_start = (int)ftell(w_pak_fp);
	header.entry_num = 0;

	std::list<raw_pak_entry_t>::iterator PDI;

	for (PDI = w_pak_dir.begin(); PDI != w_pak_dir.end(); PDI++)
	{
		raw_pak_entry_t *E = & (*PDI);

		fwrite(E, sizeof(raw_pak_entry_t), 1, w_pak_fp);

		header.entry_num++;
	}

	fflush(w_pak_fp);

	// finally write the _real_ PAK header
	header.entry_num *= sizeof(raw_pak_entry_t);

	header.dir_start = LE_U32(header.dir_start);
	header.entry_num = LE_U32(header.entry_num);

	fseek(w_pak_fp, 0, SEEK_SET);

	fwrite(&header, sizeof(header), 1, w_pak_fp);

	fflush(w_pak_fp);
	fclose(w_pak_fp);

	LogPrintf("Closed PAK file\n");

	w_pak_dir.clear();
}


void PAK_NewLump(const char *name)
{
	SYS_ASSERT(strlen(name) <= 55);

	memset(&w_pak_entry, 0, sizeof(w_pak_entry));

	strcpy(w_pak_entry.name, name);

	w_pak_entry.offset = (u32_t)ftell(w_pak_fp);
}


bool PAK_AppendData(const void *data, int length)
{
	if (length == 0)
		return true;

	SYS_ASSERT(length > 0);

	return (fwrite(data, length, 1, w_pak_fp) == 1);
}


void PAK_FinishLump(void)
{
	int len = (int)ftell(w_pak_fp) - (int)w_pak_entry.offset;

	// pad lumps to a multiple of four bytes
	int padding = ALIGN_LEN(len) - len;

	if (padding > 0)
	{
		static u8_t zeros[4] = { 0,0,0,0 };

		fwrite(zeros, padding, 1, w_pak_fp);
	}

	// fix endianness
	w_pak_entry.offset = LE_U32(w_pak_entry.offset);
	w_pak_entry.length = LE_U32(len);

	w_pak_dir.push_back(w_pak_entry);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
