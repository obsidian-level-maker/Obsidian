//------------------------------------------------------------------------
//  ARCHIVE Handling - WAD and GRP files
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


/* GRP reading */

bool GRP_OpenRead(const char *filename);
void GRP_CloseRead(void);

int  GRP_NumEntries(void);
int  GRP_FindEntry(const char *name);
int  GRP_EntryLen(int entry);
const char * GRP_EntryName(int entry);

bool GRP_ReadData(int entry, int offset, int length, void *buffer);

void GRP_ListEntries(void);


/* GRP writing */

bool GRP_OpenWrite(const char *filename);
void GRP_CloseWrite(void);

void GRP_NewLump(const char *name);
bool GRP_AppendData(const void *data, int length);
void GRP_FinishLump(void);



/* ----- WAD structure ---------------------- */

typedef struct
{
  char magic[4];

  u32_t num_lumps;
  u32_t dir_start;
}
raw_wad_header_t;


typedef struct
{
  u32_t start;
  u32_t length;

  char name[8];
}
raw_wad_lump_t;


/* ----- GRP structure ---------------------- */

typedef struct
{
  char magic[12];
  u32_t num_lumps;
}
raw_grp_header_t;


typedef struct
{
  char name[12];
  u32_t length;
}
raw_grp_lump_t;


#endif /* __OBLIGE_LIB_WAD_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
