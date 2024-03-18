//------------------------------------------------------------------------
//  ARCHIVE Handling - GRP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "lib_grp.h"

#include <algorithm>
#include <list>

#include "lib_util.h"
#include "physfs.h"
#include "sys_debug.h"
#include "sys_endian.h"

//------------------------------------------------------------------------
//  GRP READING
//------------------------------------------------------------------------

static PHYSFS_File *grp_R_fp;

static raw_grp_header_t grp_R_header;
static raw_grp_lump_t  *grp_R_dir;
static uint32_t        *grp_R_starts;

static const uint8_t grp_magic_data[GRP_MAGIC_LEN] = {0xb4, 0x9a, 0x91, 0xac, 0x96, 0x93,
                                                      0x89, 0x9a, 0x8d, 0x92, 0x9e, 0x91};

bool GRP_OpenRead(const char *filename)
{
    grp_R_fp = PHYSFS_openRead(filename);

    if (!grp_R_fp)
    {
        LogPrintf("GRP_OpenRead: no such file: %s\n", filename);
        return false;
    }

    LogPrintf("Opened GRP file: %s\n", filename);

    if ((PHYSFS_readBytes(grp_R_fp, &grp_R_header, sizeof(grp_R_header)) / sizeof(grp_R_header)) != 1)
    {
        LogPrintf("GRP_OpenRead: failed reading header\n");
        PHYSFS_close(grp_R_fp);
        return false;
    }

    if (grp_R_header.magic[0] != 'K')
    {
        LogPrintf("GRP_OpenRead: not a GRP file!\n");
        PHYSFS_close(grp_R_fp);
        return false;
    }

    grp_R_header.num_lumps = AlignedLittleEndianU32(grp_R_header.num_lumps);

    /* read directory */

    if (grp_R_header.num_lumps >= 5000) // sanity check
    {
        LogPrintf("GRP_OpenRead: bad header (%u entries?)\n", grp_R_header.num_lumps);
        PHYSFS_close(grp_R_fp);
        return false;
    }

    grp_R_dir    = new raw_grp_lump_t[grp_R_header.num_lumps + 1];
    grp_R_starts = new uint32_t[grp_R_header.num_lumps + 1];

    uint32_t L_start = sizeof(raw_grp_header_t) + sizeof(raw_grp_lump_t) * grp_R_header.num_lumps;

    for (int i = 0; i < (int)grp_R_header.num_lumps; i++)
    {
        raw_grp_lump_t *L = &grp_R_dir[i];

        size_t res = (PHYSFS_readBytes(grp_R_fp, L, sizeof(raw_grp_lump_t)) / sizeof(raw_grp_lump_t));
        if (res != 1)
        {
            if (i == 0)
            {
                LogPrintf("GRP_OpenRead: could not read any dir-entries!\n");
                GRP_CloseRead();
                return false;
            }

            LogPrintf("GRP_OpenRead: hit EOF reading dir-entry %d\n", i);

            // truncate directory
            grp_R_header.num_lumps = i;
            break;
        }

        L->length = AlignedLittleEndianU32(L->length);

        grp_R_starts[i] = L_start;
        L_start += L->length;
    }

    return true; // OK
}

void GRP_CloseRead(void)
{
    PHYSFS_close(grp_R_fp);

    LogPrintf("Closed GRP file\n");

    delete[] grp_R_dir;
    delete[] grp_R_starts;

    grp_R_dir    = NULL;
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
        char buffer[GRP_NAME_LEN + 4];

        strncpy(buffer, grp_R_dir[i].name, GRP_NAME_LEN);
        buffer[GRP_NAME_LEN] = 0;

        if (StringCaseCompareASCII(name, buffer) == 0)
        {
            return i;
        }
    }

    return -1; // not found
}

int GRP_EntryLen(int entry)
{
    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

    return grp_R_dir[entry].length;
}

const char *GRP_EntryName(int entry)
{
    static char name_buf[GRP_NAME_LEN + 4];

    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

    // entries are often not NUL terminated, hence return a static copy
    strncpy(name_buf, grp_R_dir[entry].name, GRP_NAME_LEN);
    name_buf[GRP_NAME_LEN] = 0;

    return name_buf;
}

bool GRP_ReadData(int entry, int offset, int length, void *buffer)
{
    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);
    SYS_ASSERT(offset >= 0);
    SYS_ASSERT(length > 0);

    int L_start = grp_R_starts[entry];

    if ((uint32_t)offset + (uint32_t)length > grp_R_dir[entry].length)
    { // EOF
        return false;
    }

    if (!PHYSFS_seek(grp_R_fp, L_start + offset))
    {
        return false;
    }

    size_t res = (PHYSFS_readBytes(grp_R_fp, buffer, length) / length);

    return (res == 1);
}

//------------------------------------------------------------------------
//  GRP WRITING
//------------------------------------------------------------------------

static FILE *grp_W_fp = nullptr;

static std::list<raw_grp_lump_t> grp_W_directory;

static raw_grp_lump_t grp_W_lump;

// hackish workaround for the GRP format which places the
// directory before all the data files.
#define GRP_MAX_LUMPS 200

bool GRP_OpenWrite(const std::filesystem::path &filename)
{
#ifdef _WIN32
    grp_W_fp = _wfopen(filename.c_str(), L"wb");
#else
    grp_W_fp = fopen(filename.generic_u8string().c_str(), "wb");
#endif

    if (!grp_W_fp)
    {
        LogPrintf("GRP_OpenWrite: cannot create file: %s\n", filename.u8string().c_str());
        return false;
    }

    LogPrintf("Created GRP file: %s\n", filename.u8string().c_str());

    // write out a dummy header
    raw_grp_header_t header;
    memset(&header, 0, sizeof(header));

    fwrite(&header, sizeof(raw_grp_header_t), 1, grp_W_fp);
    fflush(grp_W_fp);

    // write out a dummy directory
    for (int i = 0; i < GRP_MAX_LUMPS; i++)
    {
        raw_grp_lump_t entry;
        memset(&entry, 0, sizeof(entry));

        std::string name = StringFormat("__%03d.ZZZ", i + 1);
        std::copy(name.data(), name.data() + name.size(), entry.name);

        entry.length = AlignedLittleEndianU32(1);

        fwrite(&entry, sizeof(entry), 1, grp_W_fp);
    }

    fflush(grp_W_fp);

    return true;
}

void GRP_CloseWrite(void)
{
    // add dummy data for the dummy entries
    uint8_t zero_buf[GRP_MAX_LUMPS];
    memset(zero_buf, 0, sizeof(zero_buf));

    fwrite(zero_buf, sizeof(zero_buf), 1, grp_W_fp);

    fflush(grp_W_fp);

    // write the _real_ GRP header

    fseek(grp_W_fp, 0, SEEK_SET);

    raw_grp_header_t header;

    for (unsigned int i = 0; i < GRP_MAGIC_LEN; i++)
    {
        header.magic[i] = ~grp_magic_data[i];
    }

    header.num_lumps = AlignedLittleEndianU32(GRP_MAX_LUMPS);

    fwrite(&header, sizeof(header), 1, grp_W_fp);
    fflush(grp_W_fp);

    // write the _real_ directory

    LogPrintf("Writing GRP directory\n");

    std::list<raw_grp_lump_t>::iterator WDI;

    for (WDI = grp_W_directory.begin(); WDI != grp_W_directory.end(); ++WDI)
    {
        raw_grp_lump_t *L = &(*WDI);

        fwrite(L, sizeof(raw_grp_lump_t), 1, grp_W_fp);
    }

    fflush(grp_W_fp);
    fclose(grp_W_fp);
    grp_W_fp = nullptr;

    LogPrintf("Closed GRP file\n");

    grp_W_directory.clear();
}

void GRP_NewLump(std::string name)
{
    if (grp_W_directory.size() >= GRP_MAX_LUMPS)
    {
        ErrorPrintf("GRP_NewLump: too many lumps (> %d)\n", GRP_MAX_LUMPS);
    }

    if (name.size() > GRP_NAME_LEN)
    {
        ErrorPrintf("GRP_NewLump: name too long: '%s'\n", name.c_str());
    }

    memset(&grp_W_lump, 0, sizeof(grp_W_lump));

    std::copy(name.data(), name.data() + name.size(), grp_W_lump.name);
}

bool GRP_AppendData(const void *data, int length)
{
    if (length == 0)
    {
        return true;
    }

    SYS_ASSERT(length > 0);

    if (!fwrite(data, length, 1, grp_W_fp))
    {
        return false;
    }

    grp_W_lump.length += (uint32_t)length;
    return true; // OK
}

void GRP_FinishLump(void)
{
    // fix endianness
    grp_W_lump.length = AlignedLittleEndianU32(grp_W_lump.length);

    grp_W_directory.push_back(grp_W_lump);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
