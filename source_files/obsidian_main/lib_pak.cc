//------------------------------------------------------------------------
//  ARCHIVE handling - Quake1/2 PAK files
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

#include <list>

#include "headers.h"
#include "main.h"

#ifdef HAVE_PHYSFS
#include "physfs.h"
#endif

#include "lib_pak.h"
#include "lib_util.h"

// #define LogPrintf  printf

//------------------------------------------------------------------------
//  PAK READING
//------------------------------------------------------------------------

#ifdef HAVE_PHYSFS
static PHYSFS_File *r_pak_fp;
#else
static FILE *r_pak_fp;
#endif

static raw_pak_header_t r_header;

static raw_pak_entry_t *r_directory;

bool PAK_OpenRead(const char *filename) {
#ifdef HAVE_PHYSFS
    r_pak_fp = PHYSFS_openRead(filename);
#else
    r_pak_fp = fopen(filename, "rb");
#endif

    if (!r_pak_fp) {
        LogPrintf("PAK_OpenRead: no such file: %s\n", filename);
        return false;
    }

    LogPrintf("Opened PAK file: %s\n", filename);

#ifdef HAVE_PHYSFS
    if ((PHYSFS_readBytes(r_pak_fp, &r_header, sizeof(r_header)) /
         sizeof(r_header)) != 1)
#else
    if (fread(&r_header, sizeof(r_header), 1, r_pak_fp) != 1)
#endif
    {
        LogPrintf("PAK_OpenRead: failed reading header\n");
#ifdef HAVE_PHYSFS
        PHYSFS_close(r_pak_fp);
#else
        fclose(r_pak_fp);
#endif
        return false;
    }

    if (memcmp(r_header.magic.data(), PAK_MAGIC, 4) != 0) {
        LogPrintf("PAK_OpenRead: not a PAK file!\n");
#ifdef HAVE_PHYSFS
        PHYSFS_close(r_pak_fp);
#else
        fclose(r_pak_fp);
#endif
        return false;
    }

    r_header.dir_start = LE_U32(r_header.dir_start);
    r_header.entry_num = LE_U32(r_header.entry_num);

    // convert directory length to entry count
    r_header.entry_num /= sizeof(raw_pak_entry_t);

    /* read directory */

    if (r_header.entry_num >= 5000)  // sanity check
    {
        LogPrintf("PAK_OpenRead: bad header (%u entries?)\n",
                  static_cast<unsigned int>(r_header.entry_num));
#ifdef HAVE_PHYSFS
        PHYSFS_close(r_pak_fp);
#else
        fclose(r_pak_fp);
#endif
        return false;
    }

#ifdef HAVE_PHYSFS
    if (!PHYSFS_seek(r_pak_fp, r_header.dir_start))
#else
    if (fseek(r_pak_fp, r_header.dir_start, SEEK_SET) != 0)
#endif
    {
        LogPrintf("PAK_OpenRead: cannot seek to directory (at 0x%u)\n",
                  static_cast<unsigned int>(r_header.dir_start));
#ifdef HAVE_PHYSFS
        PHYSFS_close(r_pak_fp);
#else
        fclose(r_pak_fp);
#endif
        return false;
    }

    r_directory = new raw_pak_entry_t[r_header.entry_num + 1];

    for (int i = 0; i < (int)r_header.entry_num; i++) {
        raw_pak_entry_t *E = &r_directory[i];

#ifdef HAVE_PHYSFS
        size_t res = (PHYSFS_readBytes(r_pak_fp, E, sizeof(raw_pak_entry_t)) /
                      sizeof(raw_pak_entry_t));
        if (res != 1)
#else
        int res = fread(E, sizeof(raw_pak_entry_t), 1, r_pak_fp);
        if (res == EOF || res != 1 || ferror(r_pak_fp))
#endif
        {
            if (i == 0) {
                LogPrintf("PAK_OpenRead: could not read any dir-entries!\n");
                PAK_CloseRead();
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
    }

    return true;  // OK
}

void PAK_CloseRead(void) {
#ifdef HAVE_PHYSFS
    PHYSFS_close(r_pak_fp);
#else
    fclose(r_pak_fp);
#endif

    LogPrintf("Closed PAK file\n");

    delete[] r_directory;
    r_directory = NULL;
}

int PAK_NumEntries(void) { return (int)r_header.entry_num; }

int PAK_FindEntry(const char *name) {
    for (unsigned int i = 0; i < r_header.entry_num; i++) {
        if (StringCaseCmp(name, r_directory[i].name.data()) == 0) {
            return i;
        }
    }

    return -1;  // not found
}

int PAK_EntryLen(int entry) {
    SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);

    return r_directory[entry].length;
}

const char *PAK_EntryName(int entry) {
    SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);

    return r_directory[entry].name.data();
}

void PAK_FindMaps(std::vector<int> &entries) {
    entries.resize(0);

    for (int i = 0; i < (int)r_header.entry_num; i++) {
        raw_pak_entry_t *E = &r_directory[i];

        const char *name = E->name.data();

        if (strncmp(name, "maps/", 5) != 0) {
            continue;
        }

        name += 5;

        // ignore the ammo boxes
        if (strncmp(name, "b_", 2) == 0) {
            continue;
        }

        while (*name && *name != '/' && *name != '.') {
            name++;
        }

        if (strcmp(name, ".bsp") == 0) {
            entries.push_back(i);
        }
    }
}

bool PAK_ReadData(int entry, int offset, int length, void *buffer) {
    SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);
    SYS_ASSERT(offset >= 0);
    SYS_ASSERT(length > 0);

    raw_pak_entry_t *E = &r_directory[entry];

    if ((uint32_t)offset + (uint32_t)length > E->length) {  // EOF
        return false;
    }

#ifdef HAVE_PHYSFS
    if (!PHYSFS_seek(r_pak_fp, E->offset + offset)) {
        return false;
    }

    size_t res = (PHYSFS_readBytes(r_pak_fp, buffer, length) / length);
#else
    if (fseek(r_pak_fp, E->offset + offset, SEEK_SET) != 0) return false;

    int res = fread(buffer, length, 1, r_pak_fp);
#endif

    return (res == 1);
}

//------------------------------------------------------------------------
//  PAK WRITING
//------------------------------------------------------------------------

static std::ofstream w_pak_fp;

static std::list<raw_pak_entry_t> w_pak_dir;

static raw_pak_entry_t w_pak_entry;

bool PAK_OpenWrite(const std::filesystem::path &filename) {
    w_pak_fp.open(filename, std::ios::out | std::ios::binary);

    if (!w_pak_fp) {
        LogPrintf("PAK_OpenWrite: cannot create file: %s\n", filename.u8string().c_str());
        return false;
    }

    LogPrintf("Created PAK file: %s\n", filename.u8string().c_str());

    // write out a dummy header
    raw_pak_header_t header;
    memset(&header, 0, sizeof(header));

    w_pak_fp.write(reinterpret_cast<const char *>(&header),
                   sizeof(raw_pak_header_t));
    w_pak_fp << std::flush;

    return true;
}

void PAK_CloseWrite(void) {
    w_pak_fp << std::flush;

    // write the directory

    LogPrintf("Writing PAK directory\n");

    raw_pak_header_t header;

    memcpy(header.magic.data(), PAK_MAGIC, 4);

    header.dir_start = w_pak_fp.tellp();
    header.entry_num = 0;

    std::list<raw_pak_entry_t>::iterator PDI;

    for (PDI = w_pak_dir.begin(); PDI != w_pak_dir.end(); PDI++) {
        raw_pak_entry_t *E = &(*PDI);

        w_pak_fp.write(reinterpret_cast<const char *>(E),
                       sizeof(raw_pak_entry_t));

        header.entry_num++;
    }

    w_pak_fp << std::flush;

    // finally write the _real_ PAK header
    header.entry_num *= sizeof(raw_pak_entry_t);

    header.dir_start = LE_U32(header.dir_start);
    header.entry_num = LE_U32(header.entry_num);

    w_pak_fp.seekp(0, std::ios::beg);

    w_pak_fp.write(reinterpret_cast<const char *>(&header), sizeof(header));

    w_pak_fp << std::flush;
    w_pak_fp.close();

    LogPrintf("Closed PAK file\n");

    w_pak_dir.clear();
}

void PAK_NewLump(const char *name) {
    SYS_ASSERT(strlen(name) <= 55);

    memset(&w_pak_entry, 0, sizeof(w_pak_entry));

    strcpy(w_pak_entry.name.data(), name);

    w_pak_entry.offset = w_pak_fp.tellp();
}

bool PAK_AppendData(const void *data, int length) {
    if (length == 0) {
        return true;
    }

    SYS_ASSERT(length > 0);

    return static_cast<bool>(
        w_pak_fp.write(static_cast<const char *>(data), length));
}

void PAK_FinishLump(void) {
    const int len = static_cast<int>(w_pak_fp.tellp()) -
                    static_cast<int>(w_pak_entry.offset);

    // pad lumps to a multiple of four bytes
    int padding = ALIGN_LEN(len) - len;

    if (padding > 0) {
        constexpr std::array<char, 4> zeros = {0, 0, 0, 0};

        w_pak_fp.write(zeros.data(), padding);
    }

    // fix endianness
    w_pak_entry.offset = LE_U32(w_pak_entry.offset);
    w_pak_entry.length = LE_U32(len);

    w_pak_dir.push_back(w_pak_entry);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
