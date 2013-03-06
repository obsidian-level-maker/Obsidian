//------------------------------------------------------------------------
//  ARCHIVE Handling : ZIP files
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2009-2011 Andrew Apted
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

#ifndef __OBLIGE_LIB_ZIP_H__
#define __OBLIGE_LIB_ZIP_H__


/* ZIP reading */

bool ZIPF_OpenRead(const char *filename);
void ZIPF_CloseRead(void);

int  ZIPF_NumEntries(void);
int  ZIPF_FindEntry(const char *name);
int  ZIPF_EntryLen(int entry);
const char * ZIPF_EntryName(int entry);

bool ZIPF_ReadData(int entry, int offset, int length, void *buffer);

void ZIPF_ListEntries(void);


/* ZIP writing */

bool ZIPF_OpenWrite(const char *filename);
void ZIPF_CloseWrite(void);

void ZIPF_NewLump(const char *name);
bool ZIPF_AppendData(const void *data, int length);
void ZIPF_FinishLump(void);


/* ----- ZIP file structures ---------------------- */

typedef struct
{
	char magic[4];

	u16_t req_version;

	u16_t flags;
	u16_t comp_method;
	u16_t file_time;  // MS-DOS format
	u16_t file_date;  //

	u32_t crc;            //
	u32_t compress_size;  // these are zero when there is a trailer
	u32_t full_size;      //

	u16_t name_length;
	u16_t extra_length;

	/* byte filename[]; */

} PACKEDATTR raw_zip_local_header_t;


typedef struct
{
	char magic[4];

	u32_t crc;
	u32_t compress_size;
	u32_t full_size;

} PACKEDATTR raw_zip_local_trailer_t;


typedef struct
{
	char magic[4];

	u16_t made_version;
	u16_t req_version;

	u16_t flags;
	u16_t comp_method;
	u16_t file_time;  // MS-DOS format
	u16_t file_date;  //

	u32_t crc;
	u32_t compress_size;
	u32_t full_size;

	u16_t name_length;
	u16_t extra_length;
	u16_t comment_length;

	u16_t start_disk;

	u16_t internal_attrib;
	u32_t external_attrib;

	// offset to the local header for this file
	u32_t local_offset;

	/* byte filename[]; */

} PACKEDATTR raw_zip_central_header_t;


typedef struct
{
	char magic[4];

	u16_t this_disk;
	u16_t central_dir_disk;

	u16_t disk_entries;
	u16_t total_entries;

	u32_t dir_size;
	u32_t dir_offset;

	u16_t comment_length;

} PACKEDATTR raw_zip_end_of_directory_t;


// magic signatures:
#define ZIPF_LOCAL_MAGIC    "PK\003\004"
#define ZIPF_CENTRAL_MAGIC  "PK\001\002"
#define ZIPF_APPEND_MAGIC   "PK\007\010"
#define ZIPF_END_MAGIC      "PK\005\006"

// bit flags:
#define ZIPF_FLAG_ENCRYPTED     (1 << 0)
#define ZIPF_FLAG_HAS_TRAILER   (1 << 3)

// compression methods:
#define ZIPF_COMP_STORE    0
#define ZIPF_COMP_DEFLATE  8

// version numbers:
#define ZIPF_REQ_VERSION   0x00a
#define ZIPF_MADE_VERSION  0x314

// external attributes:
#define ZIPF_ATTRIB_NORMAL  (0x81A4 << 16)  // mode "644"


#endif /* __OBLIGE_LIB_ZIP_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
