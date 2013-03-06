//------------------------------------------------------------------------
//  ARCHIVE Handling - WAD files
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
#include "lib_wad.h"


// #define LogPrintf  printf


//------------------------------------------------------------------------
//  WAD READING
//------------------------------------------------------------------------

static FILE *wad_R_fp;

static raw_wad_header_t  wad_R_header;
static raw_wad_lump_t * wad_R_dir;

bool WAD_OpenRead(const char *filename)
{
	wad_R_fp = fopen(filename, "rb");

	if (! wad_R_fp)
	{
		LogPrintf("WAD_OpenRead: no such file: %s\n", filename);
		return false;
	}

	LogPrintf("Opened WAD file: %s\n", filename);

	if (fread(&wad_R_header, sizeof(wad_R_header), 1, wad_R_fp) != 1)
	{
		LogPrintf("WAD_OpenRead: failed reading header\n");
		fclose(wad_R_fp);
		return false;
	}

	if (0 != memcmp(wad_R_header.magic+1, "WAD", 3))
	{
		LogPrintf("WAD_OpenRead: not a WAD file!\n");
		fclose(wad_R_fp);
		return false;
	}

	wad_R_header.num_lumps = LE_U32(wad_R_header.num_lumps);
	wad_R_header.dir_start = LE_U32(wad_R_header.dir_start);

	/* read directory */

	if (wad_R_header.num_lumps >= 5000)  // sanity check
	{
		LogPrintf("WAD_OpenRead: bad header (%d entries?)\n", wad_R_header.num_lumps);
		fclose(wad_R_fp);
		return false;
	}

	if (fseek(wad_R_fp, wad_R_header.dir_start, SEEK_SET) != 0)
	{
		LogPrintf("WAD_OpenRead: cannot seek to directory (at 0x%08x)\n", wad_R_header.dir_start);
		fclose(wad_R_fp);
		return false;
	}

	wad_R_dir = new raw_wad_lump_t[wad_R_header.num_lumps + 1];

	for (int i = 0; i < (int)wad_R_header.num_lumps; i++)
	{
		raw_wad_lump_t *L = &wad_R_dir[i];

		int res = fread(L, sizeof(raw_wad_lump_t), 1, wad_R_fp);

		if (res == EOF || res != 1 || ferror(wad_R_fp))
		{
			if (i == 0)
			{
				LogPrintf("WAD_OpenRead: could not read any dir-entries!\n");

				delete[] wad_R_dir;
				wad_R_dir = NULL;

				fclose(wad_R_fp);
				return false;
			}

			LogPrintf("WAD_OpenRead: hit EOF reading dir-entry %d\n", i);

			// truncate directory
			wad_R_header.num_lumps = i;
			break;
		}

		L->start  = LE_U32(L->start);
		L->length = LE_U32(L->length);

		//  DebugPrintf(" %4d: %08x %08x : %s\n", i, L->start, L->length, L->name);
	}

	return true; // OK
}


void WAD_CloseRead(void)
{
	fclose(wad_R_fp);

	LogPrintf("Closed WAD file\n");

	delete[] wad_R_dir;
	wad_R_dir = NULL;
}


int WAD_NumEntries(void)
{
	return (int)wad_R_header.num_lumps;
}


int WAD_FindEntry(const char *name)
{
	for (unsigned int i = 0; i < wad_R_header.num_lumps; i++)
	{
		char buffer[16];
		strncpy(buffer, wad_R_dir[i].name, 8);
		buffer[8] = 0;

		if (StringCaseCmp(name, buffer) == 0)
			return i;
	}

	return -1; // not found
}


int WAD_EntryLen(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);

	return wad_R_dir[entry].length;
}


const char * WAD_EntryName(int entry)
{
	static char name_buf[16];

	SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);

	// entries are often not NUL terminated, hence return a static copy
	strncpy(name_buf, wad_R_dir[entry].name, 8);
	name_buf[8] = 0;

	return name_buf;
}


bool WAD_ReadData(int entry, int offset, int length, void *buffer)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);
	SYS_ASSERT(offset >= 0);
	SYS_ASSERT(length > 0);

	raw_wad_lump_t *L = &wad_R_dir[entry];

	if ((u32_t)offset + (u32_t)length > L->length)  // EOF
		return false;

	if (fseek(wad_R_fp, L->start + offset, SEEK_SET) != 0)
		return false;

	int res = fread(buffer, length, 1, wad_R_fp);
	return (res == 1);
}


void WAD_ListEntries(void)
{
	printf("--------------------------------------------------\n");

	if (wad_R_header.num_lumps == 0)
	{
		printf("WAD file is empty\n");
	}
	else
	{
		for (int i = 0; i < (int)wad_R_header.num_lumps; i++)
		{
			raw_wad_lump_t *L = &wad_R_dir[i];

			printf("%4d: +%08x %08x : %s\n", i+1, L->start, L->length,
					WAD_EntryName(i));
		}
	}

	printf("--------------------------------------------------\n");
}


//------------------------------------------------------------------------
//  WAD WRITING
//------------------------------------------------------------------------

static FILE *wad_W_fp;

static std::list<raw_wad_lump_t> wad_W_directory;

static raw_wad_lump_t wad_W_lump;


bool WAD_OpenWrite(const char *filename)
{
	wad_W_fp = fopen(filename, "wb");

	if (! wad_W_fp)
	{
		LogPrintf("WAD_OpenWrite: cannot create file: %s\n", filename);
		return false;
	}

	LogPrintf("Created WAD file: %s\n", filename);

	// write out a dummy header
	raw_wad_header_t header;
	memset(&header, 0, sizeof(header));

	fwrite(&header, sizeof(raw_wad_header_t), 1, wad_W_fp);
	fflush(wad_W_fp);

	return true;
}


void WAD_CloseWrite(void)
{
	fflush(wad_W_fp);

	// write the directory

	LogPrintf("Writing WAD directory\n");

	raw_wad_header_t header;

	memcpy(header.magic, "PWAD", sizeof(header.magic));

	header.dir_start = (int)ftell(wad_W_fp);
	header.num_lumps = 0;

	std::list<raw_wad_lump_t>::iterator WDI;

	for (WDI = wad_W_directory.begin(); WDI != wad_W_directory.end(); WDI++)
	{
		raw_wad_lump_t *L = & (*WDI);

		fwrite(L, sizeof(raw_wad_lump_t), 1, wad_W_fp);

		header.num_lumps++;
	}

	fflush(wad_W_fp);

	// finally write the _real_ WAD header

	header.dir_start = LE_U32(header.dir_start);
	header.num_lumps = LE_U32(header.num_lumps);

	fseek(wad_W_fp, 0, SEEK_SET);

	fwrite(&header, sizeof(header), 1, wad_W_fp);

	fflush(wad_W_fp);
	fclose(wad_W_fp);

	LogPrintf("Closed WAD file\n");

	wad_W_directory.clear();
}


void WAD_NewLump(const char *name)
{
	SYS_ASSERT(strlen(name) <= 8);  // FIXME: error

	memset(&wad_W_lump, 0, sizeof(wad_W_lump));

	strncpy(wad_W_lump.name, name, 8);

	wad_W_lump.start = (u32_t)ftell(wad_W_fp);
}


bool WAD_AppendData(const void *data, int length)
{
	if (length == 0)
		return true;

	SYS_ASSERT(length > 0);

	return (fwrite(data, length, 1, wad_W_fp) == 1);
}


void WAD_FinishLump(void)
{
	int len = (int)ftell(wad_W_fp) - (int)wad_W_lump.start;

	// pad lumps to a multiple of four bytes
	int padding = ALIGN_LEN(len) - len;

	if (padding > 0)
	{
		static u8_t zeros[4] = { 0,0,0,0 };

		fwrite(zeros, padding, 1, wad_W_fp);
	}

	// fix endianness
	wad_W_lump.start  = LE_U32(wad_W_lump.start);
	wad_W_lump.length = LE_U32(len);

	wad_W_directory.push_back(wad_W_lump);
}


//------------------------------------------------------------------------
//  WAD2 READING
//------------------------------------------------------------------------

static FILE *wad2_R_fp;

static raw_wad2_header_t  wad2_R_header;
static raw_wad2_lump_t * wad2_R_dir;

bool WAD2_OpenRead(const char *filename)
{
	wad2_R_fp = fopen(filename, "rb");

	if (! wad2_R_fp)
	{
		LogPrintf("WAD2_OpenRead: no such file: %s\n", filename);
		return false;
	}

	LogPrintf("Opened WAD2 file: %s\n", filename);

	if (fread(&wad2_R_header, sizeof(wad2_R_header), 1, wad2_R_fp) != 1)
	{
		LogPrintf("WAD2_OpenRead: failed reading header\n");
		fclose(wad2_R_fp);
		return false;
	}

	if (memcmp(wad2_R_header.magic, WAD2_MAGIC, 4) != 0)
	{
		LogPrintf("WAD2_OpenRead: not a WAD2 file!\n");
		fclose(wad2_R_fp);
		return false;
	}

	wad2_R_header.num_lumps = LE_U32(wad2_R_header.num_lumps);
	wad2_R_header.dir_start = LE_U32(wad2_R_header.dir_start);

	/* read directory */

	if (wad2_R_header.num_lumps >= 5000)  // sanity check
	{
		LogPrintf("WAD2_OpenRead: bad header (%d entries?)\n", wad2_R_header.num_lumps);
		fclose(wad2_R_fp);
		return false;
	}

	if (fseek(wad2_R_fp, wad2_R_header.dir_start, SEEK_SET) != 0)
	{
		LogPrintf("WAD2_OpenRead: cannot seek to directory (at 0x%08x)\n", wad2_R_header.dir_start);
		fclose(wad2_R_fp);
		return false;
	}

	wad2_R_dir = new raw_wad2_lump_t[wad2_R_header.num_lumps + 1];

	for (int i = 0; i < (int)wad2_R_header.num_lumps; i++)
	{
		raw_wad2_lump_t *L = &wad2_R_dir[i];

		int res = fread(L, sizeof(raw_wad2_lump_t), 1, wad2_R_fp);

		if (res == EOF || res != 1 || ferror(wad2_R_fp))
		{
			if (i == 0)
			{
				LogPrintf("WAD2_OpenRead: could not read any dir-entries!\n");

				delete[] wad2_R_dir;
				wad2_R_dir = NULL;

				fclose(wad2_R_fp);
				return false;
			}

			LogPrintf("WAD2_OpenRead: hit EOF reading dir-entry %d\n", i);

			// truncate directory
			wad2_R_header.num_lumps = i;
			break;
		}

		// make sure name is NUL terminated.
		L->name[15] = 0;

		L->start  = LE_U32(L->start);
		L->length = LE_U32(L->length);
		L->u_len  = LE_U32(L->u_len);

		//  DebugPrintf(" %4d: %08x %08x : %s\n", i, L->start, L->length, L->name);
	}

	return true; // OK
}


void WAD2_CloseRead(void)
{
	fclose(wad2_R_fp);

	LogPrintf("Closed WAD2 file\n");

	delete[] wad2_R_dir;
	wad2_R_dir = NULL;
}


int WAD2_NumEntries(void)
{
	return (int)wad2_R_header.num_lumps;
}


int WAD2_FindEntry(const char *name)
{
	for (unsigned int i = 0; i < wad2_R_header.num_lumps; i++)
	{
		if (StringCaseCmp(name, wad2_R_dir[i].name) == 0)
			return i;
	}

	return -1; // not found
}


int WAD2_EntryLen(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad2_R_header.num_lumps);

	return wad2_R_dir[entry].u_len;
}


const char * WAD2_EntryName(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad2_R_header.num_lumps);

	return wad2_R_dir[entry].name;
}


int WAD2_EntryType(int entry)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad2_R_header.num_lumps);

	if (wad2_R_dir[entry].compression != 0)
		return TYP_COMPRESSED;

	return wad2_R_dir[entry].type;
}

bool WAD2_ReadData(int entry, int offset, int length, void *buffer)
{
	SYS_ASSERT(entry >= 0 && entry < (int)wad2_R_header.num_lumps);
	SYS_ASSERT(offset >= 0);
	SYS_ASSERT(length > 0);

	raw_wad2_lump_t *L = &wad2_R_dir[entry];

	if ((u32_t)offset + (u32_t)length > L->length)  // EOF
		return false;

	if (fseek(wad2_R_fp, L->start + offset, SEEK_SET) != 0)
		return false;

	int res = fread(buffer, length, 1, wad2_R_fp);

	return (res == 1);
}


static char LetterForType(u8_t type)
{
	switch (type)
	{
		case TYP_NONE:    return 'x';
		case TYP_LABEL:   return 'L';
		case TYP_PALETTE: return 'C';
		case TYP_QTEX:    return 'T';
		case TYP_QPIC:    return 'P';
		case TYP_SOUND:   return 'S';
		case TYP_MIPTEX:  return 'M';

		default: return '?';
	}
}


void WAD2_ListEntries(void)
{
	printf("--------------------------------------------------\n");

	if (wad2_R_header.num_lumps == 0)
	{
		printf("WAD2 file is empty\n");
	}
	else
	{
		for (int i = 0; i < (int)wad2_R_header.num_lumps; i++)
		{
			raw_wad2_lump_t *L = &wad2_R_dir[i];

			printf("%4d: +%08x %08x %c : %s\n", i+1, L->start, L->length,
					LetterForType(L->type), L->name);
		}
	}

	printf("--------------------------------------------------\n");
}


//------------------------------------------------------------------------
//  WAD2 WRITING
//------------------------------------------------------------------------

static FILE *wad2_W_fp;

static std::list<raw_wad2_lump_t> wad2_W_directory;

static raw_wad2_lump_t wad2_W_lump;


bool WAD2_OpenWrite(const char *filename)
{
	wad2_W_fp = fopen(filename, "wb");

	if (! wad2_W_fp)
	{
		LogPrintf("WAD2_OpenWrite: cannot create file: %s\n", filename);
		return false;
	}

	LogPrintf("Created WAD2 file: %s\n", filename);

	// write out a dummy header
	raw_wad2_header_t header;
	memset(&header, 0, sizeof(header));

	fwrite(&header, sizeof(raw_wad2_header_t), 1, wad2_W_fp);
	fflush(wad2_W_fp);

	return true;
}


void WAD2_CloseWrite(void)
{
	fflush(wad2_W_fp);

	// write the directory

	LogPrintf("Writing WAD2 directory\n");

	raw_wad2_header_t header;

	memcpy(header.magic, WAD2_MAGIC, 4);

	header.dir_start = (int)ftell(wad2_W_fp);
	header.num_lumps = 0;

	std::list<raw_wad2_lump_t>::iterator WDI;

	for (WDI = wad2_W_directory.begin(); WDI != wad2_W_directory.end(); WDI++)
	{
		raw_wad2_lump_t *L = & (*WDI);

		fwrite(L, sizeof(raw_wad2_lump_t), 1, wad2_W_fp);

		header.num_lumps++;
	}

	fflush(wad2_W_fp);

	// finally write the _real_ WAD2 header

	header.dir_start = LE_U32(header.dir_start);
	header.num_lumps = LE_U32(header.num_lumps);

	fseek(wad2_W_fp, 0, SEEK_SET);

	fwrite(&header, sizeof(header), 1, wad2_W_fp);

	fflush(wad2_W_fp);
	fclose(wad2_W_fp);

	LogPrintf("Closed WAD2 file\n");

	wad2_W_directory.clear();
}


void WAD2_NewLump(const char *name, int type)
{
	SYS_ASSERT(strlen(name) <= 15);

	memset(&wad2_W_lump, 0, sizeof(wad2_W_lump));

	strcpy(wad2_W_lump.name, name);

	wad2_W_lump.type  = type;
	wad2_W_lump.start = (u32_t)ftell(wad2_W_fp);
}


bool WAD2_AppendData(const void *data, int length)
{
	if (length == 0)
		return true;

	SYS_ASSERT(length > 0);

	return (fwrite(data, length, 1, wad2_W_fp) == 1);
}


void WAD2_FinishLump(void)
{
	int len = (int)ftell(wad2_W_fp) - (int)wad2_W_lump.start;

	// pad lumps to a multiple of four bytes
	int padding = ALIGN_LEN(len) - len;

	if (padding > 0)
	{
		static u8_t zeros[4] = { 0,0,0,0 };

		fwrite(zeros, padding, 1, wad2_W_fp);
	}

	// fix endianness
	wad2_W_lump.start  = LE_U32(wad2_W_lump.start);
	wad2_W_lump.length = LE_U32(len);
	wad2_W_lump.u_len  = LE_U32(len);

	wad2_W_directory.push_back(wad2_W_lump);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
