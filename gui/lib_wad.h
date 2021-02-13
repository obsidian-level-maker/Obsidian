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

#ifndef __OBLIGE_LIB_WAD_H__
#define __OBLIGE_LIB_WAD_H__


/* WAD reading */

bool WAD_OpenRead(const char *filename);
void WAD_CloseRead(void);

int  WAD_NumEntries(void);
int  WAD_FindEntry(const char *name);
int  WAD_EntryLen(int entry);
const char * WAD_EntryName(int entry);

bool WAD_ReadData(int entry, int offset, int length, void *buffer);

void WAD_ListEntries(void);


/* WAD writing */

bool WAD_OpenWrite(const char *filename);
void WAD_CloseWrite(void);

void WAD_NewLump(const char *name);
bool WAD_AppendData(const void *data, int length);
void WAD_FinishLump(void);



/* WAD2 reading */

bool WAD2_OpenRead(const char *filename);
void WAD2_CloseRead(void);

int  WAD2_NumEntries(void);
int  WAD2_FindEntry(const char *name);
int  WAD2_EntryLen(int entry);
int  WAD2_EntryType(int entry);
const char * WAD2_EntryName(int entry);

bool WAD2_ReadData(int entry, int offset, int length, void *buffer);

void WAD2_ListEntries(void);


/* WAD2 writing */

bool WAD2_OpenWrite(const char *filename);
void WAD2_CloseWrite(void);

void WAD2_NewLump(const char *name, int type = 0);
bool WAD2_AppendData(const void *data, int length);
void WAD2_FinishLump(void);


/* ----- WAD structure (Doom) ---------------------- */

typedef struct
{
	char magic[4];

	u32_t num_lumps;
	u32_t dir_start;

} PACKEDATTR raw_wad_header_t;


typedef struct
{
	u32_t start;
	u32_t length;

	char name[8];

} PACKEDATTR raw_wad_lump_t;


/* ----- WAD2 structures (Quake) ---------------------- */

typedef struct
{
	char magic[4];

	u32_t num_lumps;
	u32_t dir_start;

} PACKEDATTR raw_wad2_header_t;

#define WAD2_MAGIC  "WAD2"


typedef struct
{
	u32_t start;
	u32_t length;  // compressed
	u32_t u_len;   // uncompressed

	u8_t  type;
	u8_t  compression;
	u8_t  _pad[2];

	char  name[16];  // must be null terminated

} PACKEDATTR raw_wad2_lump_t;

// compression method (from Quake1 source)
#define CMP_NONE  0
#define CMP_LZSS  1

// lump types (from Quake1 source)
#define TYP_NONE      0
#define TYP_LABEL     1
#define TYP_PALETTE  64
#define TYP_QTEX     65
#define TYP_QPIC     66
#define TYP_SOUND    67
#define TYP_MIPTEX   68

// this value is only returned from WAD2_EntryType()
#define TYP_COMPRESSED  256


#endif /* __OBLIGE_LIB_WAD_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
