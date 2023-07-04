//------------------------------------------------------------------------
//  ARCHIVE Handling : ZIP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2009-2017 Andrew Apted
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

#ifndef LIB_ZIP_H_
#define LIB_ZIP_H_

#include <filesystem>

#include "sys_type.h"

/* ZIP reading */

bool ZIPF_OpenRead(const char *filename);
void ZIPF_CloseRead();

int ZIPF_NumEntries(void);
int ZIPF_FindEntry(const char *name);
int ZIPF_EntryLen(int entry);
const char *ZIPF_EntryName(int entry);

bool ZIPF_ReadData(int entry, int offset, int length, void *buffer);

/* ZIP writing */

bool ZIPF_OpenWrite(const std::filesystem::path &filename);
void ZIPF_CloseWrite();

void ZIPF_NewLump(const char *name);
bool ZIPF_AppendData(const void *data, int length);
void ZIPF_FinishLump();

/* ----- ZIP file structures ---------------------- */

#pragma pack(push, 1)
struct raw_zip_local_header_t {
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
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_zip_local_trailer_t {
    char magic[4];

    u32_t crc;
    u32_t compress_size;
    u32_t full_size;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_zip_central_header_t {
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
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_zip_end_of_directory_t {
    char magic[4];

    u16_t this_disk;
    u16_t central_dir_disk;

    u16_t disk_entries;
    u16_t total_entries;

    u32_t dir_size;
    u32_t dir_offset;

    u16_t comment_length;
};
#pragma pack(pop)

// magic signatures:
constexpr const char *ZIPF_CENTRAL_MAGIC = "PK\x01\x02";
constexpr const char *ZIPF_LOCAL_MAGIC = "PK\x03\x04";
constexpr const char *ZIPF_END_MAGIC = "PK\x05\x06";
constexpr const char *ZIPF_APPEND_MAGIC = "PK\x07\x08";

// bit flags:
constexpr unsigned int ZIPF_FLAG_ENCRYPTED = 1 << 0;
constexpr unsigned int ZIPF_FLAG_HAS_TRAILER = 1 << 3;

// compression methods:
constexpr int ZIPF_COMP_STORE = 0;
constexpr int ZIPF_COMP_DEFLATE = 8;

// version numbers:
constexpr unsigned int ZIPF_REQ_VERSION = 0x00A;
constexpr unsigned int ZIPF_MADE_VERSION = 0x314;

// external attributes:
constexpr unsigned int ZIPF_ATTRIB_NORMAL = 0x81A4 << 16;

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
