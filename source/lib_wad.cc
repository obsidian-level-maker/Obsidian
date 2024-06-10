//------------------------------------------------------------------------
//  ARCHIVE Handling - WAD files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#include "lib_wad.h"

#include <list>

#include "lib_util.h"
#include "main.h"
#include "physfs.h"
#include "sys_assert.h"
#include "sys_endian.h"

// #define LogPrintf  printf

//------------------------------------------------------------------------
//  WAD READING
//------------------------------------------------------------------------

static PHYSFS_File     *wad_R_fp;
static raw_wad_header_t wad_R_header;
static raw_wad_lump_t  *wad_R_dir;

bool WAD_OpenRead(std::string filename)
{

    wad_R_fp = PHYSFS_openRead(filename.c_str());

    if (!wad_R_fp)
    {
        LogPrintf("WAD_OpenRead: no such file: %s\n", filename.c_str());
        return false;
    }

    LogPrintf("Opened WAD file: %s\n", filename.c_str());

    if ((PHYSFS_readBytes(wad_R_fp, &wad_R_header, sizeof(wad_R_header)) / sizeof(wad_R_header)) != 1)
    {
        LogPrintf("WAD_OpenRead: failed reading header\n");
        PHYSFS_close(wad_R_fp);
        return false;
    }

    if (0 != memcmp(wad_R_header.magic + 1, "WAD", 3))
    {
        LogPrintf("WAD_OpenRead: not a WAD file!\n");
        PHYSFS_close(wad_R_fp);
        return false;
    }

    wad_R_header.num_lumps = LE_U32(wad_R_header.num_lumps);
    wad_R_header.dir_start = LE_U32(wad_R_header.dir_start);

    /* read directory */

    if (wad_R_header.num_lumps >= 5000) // sanity check
    {
        LogPrintf("WAD_OpenRead: bad header (%u entries?)\n", static_cast<unsigned int>(wad_R_header.num_lumps));
        PHYSFS_close(wad_R_fp);
        return false;
    }

    if (!PHYSFS_seek(wad_R_fp, wad_R_header.dir_start))
    {
        LogPrintf("WAD_OpenRead: cannot seek to directory (at 0x%u)\n",
                  static_cast<unsigned int>(wad_R_header.dir_start));
        PHYSFS_close(wad_R_fp);
        return false;
    }

    wad_R_dir = new raw_wad_lump_t[wad_R_header.num_lumps + 1];

    for (int i = 0; i < (int)wad_R_header.num_lumps; i++)
    {
        raw_wad_lump_t *L = &wad_R_dir[i];

        size_t res = (PHYSFS_readBytes(wad_R_fp, L, sizeof(raw_wad_lump_t)) / sizeof(raw_wad_lump_t));
        if (res != 1)
        {
            if (i == 0)
            {
                LogPrintf("WAD_OpenRead: could not read any dir-entries!\n");
                WAD_CloseRead();
                return false;
            }

            LogPrintf("WAD_OpenRead: hit EOF reading dir-entry %d\n", i);

            // truncate directory
            wad_R_header.num_lumps = i;
            break;
        }

        L->start  = LE_U32(L->start);
        L->length = LE_U32(L->length);
    }

    return true; // OK
}

void WAD_CloseRead(void)
{
    PHYSFS_close(wad_R_fp);

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

        if (StringCompare(name, buffer) == 0)
        {
            return i;
        }
    }

    return -1; // not found
}

int WAD_EntryLen(int entry)
{
    SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);

    return wad_R_dir[entry].length;
}

const char *WAD_EntryName(int entry)
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

    if ((uint32_t)offset + (uint32_t)length > L->length)
    { // EOF
        return false;
    }

    if (!PHYSFS_seek(wad_R_fp, L->start + offset))
    {
        return false;
    }

    return ((PHYSFS_readBytes(wad_R_fp, buffer, length) / length) == 1);
}

//------------------------------------------------------------------------
//  WAD WRITING
//------------------------------------------------------------------------

static std::ofstream wad_W_fp;

static std::list<raw_wad_lump_t> wad_W_directory;

static raw_wad_lump_t wad_W_lump;

bool WAD_OpenWrite(std::string filename)
{
    wad_W_fp.open(filename, std::ios::out | std::ios::binary);

    if (!wad_W_fp.is_open())
    {
        LogPrintf("WAD_OpenWrite: cannot create file: %s\n", filename.c_str());
        return false;
    }

    LogPrintf("Created WAD file: %s\n", filename.c_str());

    // write out a dummy header
    raw_wad_header_t header;
    memset(&header, 0, sizeof(header));

    wad_W_fp.write((const char *)&header, sizeof(raw_wad_header_t));
    wad_W_fp << std::flush;

    return true;
}

void WAD_CloseWrite(void)
{
    wad_W_fp << std::flush;

    // write the directory

    LogPrintf("Writing WAD directory\n");

    raw_wad_header_t header;

    memcpy(header.magic, "PWAD", sizeof(header.magic));

    header.dir_start = wad_W_fp.tellp();
    header.num_lumps = 0;

    std::list<raw_wad_lump_t>::iterator WDI;

    for (WDI = wad_W_directory.begin(); WDI != wad_W_directory.end(); ++WDI)
    {
        raw_wad_lump_t *L = &(*WDI);

        wad_W_fp.write((const char *)L, sizeof(raw_wad_lump_t));
        wad_W_fp << std::flush;

        header.num_lumps++;
    }

    wad_W_fp << std::flush;

    // finally write the _real_ WAD header

    header.dir_start = LE_U32(header.dir_start);
    header.num_lumps = LE_U32(header.num_lumps);

    wad_W_fp.seekp(0, std::ios::beg);

    wad_W_fp.write((const char *)&header, sizeof(header));

    wad_W_fp << std::flush;
    wad_W_fp.close();

    LogPrintf("Closed WAD file\n");

    wad_W_directory.clear();
}

void WAD_NewLump(std::string name)
{
    if (name.size() > 8)
    {
        Main::FatalError("WAD_NewLump: name too long: '%s'\n", name.c_str());
    }

    memset(&wad_W_lump, 0, sizeof(wad_W_lump));

    memcpy(wad_W_lump.name, name.data(), name.size());

    wad_W_lump.start = wad_W_fp.tellp();
}

bool WAD_AppendData(const void *data, int length)
{
    if (length == 0)
    {
        return true;
    }

    SYS_ASSERT(length > 0);

    return static_cast<bool>(wad_W_fp.write(static_cast<const char *>(data), length));
}

void WAD_FinishLump(void)
{
    const int len = static_cast<int>(wad_W_fp.tellp()) - static_cast<int>(wad_W_lump.start);

    // pad lumps to a multiple of four bytes
    int padding = ALIGN_LEN(len) - len;

    if (padding > 0)
    {
        static uint8_t zeros[4] = {0, 0, 0, 0};

        wad_W_fp.write((const char *)zeros, padding);
        wad_W_fp << std::flush;
    }

    // fix endianness
    wad_W_lump.start  = LE_U32(wad_W_lump.start);
    wad_W_lump.length = LE_U32(len);

    wad_W_directory.push_back(wad_W_lump);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
