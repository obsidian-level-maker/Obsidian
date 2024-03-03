//------------------------------------------------------------------------
//  WAD Reading / Writing
//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2001-2023  Andrew Apted
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

#include "bsp_wad.h"

#include <stdarg.h>
#include <string.h>  // memcpy

#include <algorithm>

#include "bsp_local.h"
#include "bsp_utility.h"
#include "dm_defs.h"
#include "sys_debug.h"
#include "sys_endian.h"
#include "sys_macro.h"
#define DEBUG_WAD 0

namespace ajbsp
{

#if DEBUG_WAD
#define FileMessage DebugPrintf
#define LumpWarning DebugPrintf
#else
void FileMessage(const char *format, ...) { (void)format; }

void LumpWarning(const char *format, ...) { (void)format; }
#endif

static constexpr uint8_t kMaxLevelLumps = 21;

//------------------------------------------------------------------------
//  C String Utility Functions
//------------------------------------------------------------------------

// Copies up to max characters of src into dest, and then applies a
// terminating zero (so dest must hold at least max+1 characters).
// The terminating zero is always applied (there is no reason not to)
static void CStringCopyMax(char *destination, const char *source, int max)
{
    for (; *source && max > 0; max--) { *destination++ = *source++; }

    *destination = 0;
}

static char *CStringNew(int length)
{
    // length does not include the trailing NUL.

    char *s = (char *)calloc(length + 1, 1);

    if (!s) ErrorPrintf("Out of memory (%d bytes for string)\n", length);

    return s;
}

static char *CStringDuplicate(const char *original, int limit = -1)
{
    if (!original) return nullptr;

    if (limit < 0)
    {
        char *s = strdup(original);

        if (!s) ErrorPrintf("Out of memory (copy string)\n");

        return s;
    }

    char *s = CStringNew(limit + 1);
    strncpy(s, original, limit);
    s[limit] = 0;

    return s;
}

static char *CStringUpper(const char *name)
{
    char *copy = CStringDuplicate(name);

    for (char *p = copy; *p; p++) *p = ToUpperASCII(*p);

    return copy;
}

static void CStringFree(const char *string)
{
    if (string) { free((void *)string); }
}

//------------------------------------------------------------------------
//  LUMP Handling
//------------------------------------------------------------------------

Lump::Lump(WadFile *parent, const char *name, int start, int length)
    : parent_(parent), lump_start_(start), lump_length_(length)
{
    // ensure lump name is uppercase
    name_ = CStringUpper(name);
}

Lump::Lump(WadFile *parent, const RawWadEntry *entry) : parent_(parent)
{
    // handle the entry name, which can lack a terminating NUL
    char buffer[10];
    strncpy(buffer, entry->name, 8);
    buffer[8] = 0;

    name_ = CStringDuplicate(buffer);

    lump_start_  = AlignedLittleEndianU32(entry->pos);
    lump_length_ = AlignedLittleEndianU32(entry->size);

#if DEBUG_WAD
    DebugPrintf("new lump '%s' @ %d len:%d\n", name, lump_start, lump_length);
#endif
}

Lump::~Lump() { CStringFree(name_); }

void Lump::MakeEntry(struct RawWadEntry *entry)
{
    // do a dance to avoid a compiler warning from strncpy(), *sigh*
    memset(entry->name, 0, 8);
    memcpy(entry->name, name_, strlen(name_));

    entry->pos  = AlignedLittleEndianU32(lump_start_);
    entry->size = AlignedLittleEndianU32(lump_length_);
}

void Lump::Rename(const char *new_name)
{
    CStringFree(name_);

    // ensure lump name is uppercase
    name_ = CStringUpper(new_name);
}

bool Lump::Seek(int offset)
{
    SYS_ASSERT(offset >= 0);

    return (fseek(parent_->file_pointer_, lump_start_ + offset, SEEK_SET) == 0);
}

bool Lump::Read(void *data, size_t length)
{
    SYS_ASSERT(data && length > 0);

    return (fread(data, length, 1, parent_->file_pointer_) == 1);
}

bool Lump::GetLine(char *buffer, size_t buffer_size)
{
    int cur_pos = -1;

    cur_pos = (int)ftell(parent_->file_pointer_);

    if (cur_pos < 0) return false;

    cur_pos -= lump_start_;

    if (cur_pos >= lump_length_) return false;  // EOF

    char *dest     = buffer;
    char *dest_end = buffer + buffer_size - 1;

    for (; cur_pos < lump_length_ && dest < dest_end; cur_pos++)
    {
        int mem_pos = 0;
        *dest++     = fgetc(parent_->file_pointer_);

        if (dest[-1] == '\n') break;

        if (parent_->file_pointer_ && ferror(parent_->file_pointer_))
            return false;

        if (parent_->file_pointer_ && feof(parent_->file_pointer_)) break;
    }

    *dest = 0;

    return true;  // OK
}

bool Lump::Write(const void *data, int length)
{
    SYS_ASSERT(data && length > 0);

    lump_length_ += length;

    return (fwrite(data, length, 1, parent_->file_pointer_) == 1);
}

void Lump::Printf(const char *message, ...)
{
    static char buffer[1024];

    va_list args;

    va_start(args, message);
    vsnprintf(buffer, sizeof(buffer), message, args);
    va_end(args);

    buffer[sizeof(buffer) - 1] = 0;

    Write(buffer, (int)strlen(buffer));
}

bool Lump::Finish()
{
    if (lump_length_ == 0) lump_start_ = 0;

    return parent_->FinishLump(lump_length_);
}

//------------------------------------------------------------------------
//  WAD Reading Interface
//------------------------------------------------------------------------

WadFile::WadFile(std::filesystem::path name, char mode, FILE *file_pointer)
    : mode_(mode),
      file_pointer_(file_pointer),
      kind_('P'),
      total_size_(0),
      directory_(),
      directory_start_(0),
      directory_count_(0),
      levels_(),
      patches_(),
      sprites_(),
      flats_(),
      tx_textures_(),
      begun_write_(false),
      insert_point_(-1)
{
    filename_ = name;
}

WadFile::~WadFile()
{
    FileMessage("Closing WAD file: %s\n", filename_.u8string().c_str());

    if (file_pointer_) fclose(file_pointer_);

    // free the directory_
    for (int k = 0; k < NumLumps(); k++) delete directory_[k];

    directory_.clear();

    filename_.clear();
}

WadFile *WadFile::Open(std::filesystem::path filename, char mode)
{
    SYS_ASSERT(mode == 'r' || mode == 'w' || mode == 'a');

    if (mode == 'w') return Create(filename, mode);

    FileMessage("Opening WAD file: %s\n", filename.u8string().c_str());

    FILE *fp = nullptr;

retry:
#ifdef _WIN32
    fp = _wfopen(filename.c_str(), (mode == 'r' ? L"rb" : L"r+b"));
#else
    fp = fopen(filename.generic_u8string().c_str(),
               (mode == 'r' ? "rb" : "r+b"));
#endif
    if (!fp)
    {
        // mimic the fopen() semantics
        if (mode == 'a' && errno == ENOENT) return Create(filename, mode);

        // if file is read-only, open in 'r' mode instead
        if (mode == 'a' && (errno == EACCES || errno == EROFS))
        {
            FileMessage("Open r/w failed, trying again in read mode...\n");
            mode = 'r';
            goto retry;
        }

        int what = errno;
        FileMessage("Open file failed: %s\n", strerror(what));
        return NULL;
    }

    if (!fp)
    {
        // mimic the fopen() semantics
        if (mode == 'a' && errno == ENOENT) return Create(filename, mode);

        // if file is read-only, open in 'r' mode instead
        if (mode == 'a' && (errno == EACCES || errno == EROFS))
        {
            FileMessage("Open r/w failed, trying again in read mode...\n");
            mode = 'r';
            goto retry;
        }

        int what = errno;
        FileMessage("Open file failed: %s\n", strerror(what));
        return nullptr;
    }

    WadFile *w = new WadFile(filename, mode, fp);

    // determine total size (seek to end)
    if (fseek(fp, 0, SEEK_END) != 0)
        ErrorPrintf("AJBSP: Error determining WAD size.\n");

    w->total_size_ = (int)ftell(fp);

#if DEBUG_WAD
    DebugPrintf("total_size = %d\n", w->total_size);
#endif

    if (w->total_size_ < 0) ErrorPrintf("AJBSP: Error determining WAD size.\n");

    w->ReadDirectory();
    w->DetectLevels();
    w->ProcessNamespaces();

    return w;
}

WadFile *WadFile::Create(std::filesystem::path filename, char mode)
{
    FileMessage("Creating new WAD file: %s\n", filename.u8string().c_str());

#ifdef _WIN32
    FILE *fp = _wfopen(filename.c_str(), L"wb");
#else
    FILE *fp = fopen(filename.generic_u8string().c_str(), "wb");
#endif

    if (!fp) return nullptr;

    WadFile *w = new WadFile(filename, mode, fp);

    // write out base header
    RawWadHeader header;

    memset(&header, 0, sizeof(header));
    memcpy(header.ident, "PWAD", 4);

    fwrite(&header, sizeof(header), 1, fp);
    fflush(fp);

    w->total_size_ = (int)sizeof(header);

    return w;
}

static int WhatLevelPart(const char *name)
{
    if (StringCaseCompareASCII(name, "THINGS") == 0) return 1;
    if (StringCaseCompareASCII(name, "LINEDEFS") == 0) return 2;
    if (StringCaseCompareASCII(name, "SIDEDEFS") == 0) return 3;
    if (StringCaseCompareASCII(name, "VERTEXES") == 0) return 4;
    if (StringCaseCompareASCII(name, "SECTORS") == 0) return 5;

    return 0;
}

static bool IsLevelLump(const char *name)
{
    if (StringCaseCompareASCII(name, "SEGS") == 0) return true;
    if (StringCaseCompareASCII(name, "SSECTORS") == 0) return true;
    if (StringCaseCompareASCII(name, "NODES") == 0) return true;
    if (StringCaseCompareASCII(name, "REJECT") == 0) return true;
    if (StringCaseCompareASCII(name, "BLOCKMAP") == 0) return true;
    if (StringCaseCompareASCII(name, "BEHAVIOR") == 0) return true;
    if (StringCaseCompareASCII(name, "SCRIPTS") == 0) return true;

    return WhatLevelPart(name) != 0;
}

static bool IsGLNodeLump(const char *name)
{
    if (StringCaseCompareMaxASCII(name, "GL_", 3) == 0) return true;

    return false;
}

Lump *WadFile::GetLump(int index)
{
    SYS_ASSERT(0 <= index && index < NumLumps());
    SYS_ASSERT(directory_[index]);

    return directory_[index];
}

Lump *WadFile::FindLump(const char *name)
{
    for (int k = 0; k < NumLumps(); k++)
        if (StringCaseCompareASCII(directory_[k]->name_, name) == 0)
            return directory_[k];

    return nullptr;  // not found
}

int WadFile::FindLumpNumber(const char *name)
{
    for (int k = 0; k < NumLumps(); k++)
        if (StringCaseCompareASCII(directory_[k]->name_, name) == 0) return k;

    return -1;  // not found
}

int WadFile::LevelLookupLump(int level_number, const char *name)
{
    int start  = LevelHeader(level_number);
    int finish = LevelLastLump(level_number);

    for (int k = start + 1; k <= finish; k++)
    {
        SYS_ASSERT(0 <= k && k < NumLumps());

        if (StringCaseCompareASCII(directory_[k]->name_, name) == 0) return k;
    }

    return -1;  // not found
}

int WadFile::LevelFind(const char *name)
{
    for (int k = 0; k < (int)levels_.size(); k++)
    {
        int index = levels_[k];

        SYS_ASSERT(0 <= index && index < NumLumps());
        SYS_ASSERT(directory_[index]);

        if (StringCaseCompareASCII(directory_[index]->name_, name) == 0)
            return k;
    }

    return -1;  // not found
}

int WadFile::LevelLastLump(int level_number)
{
    int start = LevelHeader(level_number);
    int count = 1;

    // UDMF level?
    if (LevelFormat(level_number) == kMapFormatUDMF)
    {
        while (count < kMaxLevelLumps && start + count < NumLumps())
        {
            if (StringCaseCompareASCII(directory_[start + count]->name_,
                                       "ENDMAP") == 0)
            {
                count++;
                break;
            }

            count++;
        }
    }
    else  // standard DOOM or HEXEN format
    {
        while (count < kMaxLevelLumps && start + count < NumLumps() &&
               (IsLevelLump(directory_[start + count]->name_) ||
                IsGLNodeLump(directory_[start + count]->name_)))
        {
            count++;
        }
    }

    return start + count - 1;
}

int WadFile::LevelFindByNumber(int number)
{
    // sanity check
    if (number <= 0 || number > 99) return -1;

    char buffer[10];
    int  index;

    // try MAP## first
    sprintf(buffer, "MAP%02d", number);

    index = LevelFind(buffer);
    if (index >= 0) return index;

    // otherwise try E#M#
    sprintf(buffer, "E%dM%d", OBSIDIAN_MAX(1, number / 10), number % 10);

    index = LevelFind(buffer);
    if (index >= 0) return index;

    return -1;  // not found
}

int WadFile::LevelFindFirst()
{
    if (levels_.size() > 0)
        return 0;
    else
        return -1;  // none
}

int WadFile::LevelHeader(int level_number)
{
    SYS_ASSERT(0 <= level_number && level_number < LevelCount());

    return levels_[level_number];
}

MapFormat WadFile::LevelFormat(int level_number)
{
    int start = LevelHeader(level_number);

    if (start + 2 < (int)NumLumps())
    {
        const char *name = GetLump(start + 1)->Name();

        if (StringCaseCompareASCII(name, "TEXTMAP") == 0) return kMapFormatUDMF;
    }

    if (start + kLumpBehavior < (int)NumLumps())
    {
        const char *name = GetLump(start + kLumpBehavior)->Name();

        if (StringCaseCompareASCII(name, "BEHAVIOR") == 0)
            return kMapFormatHexen;
    }

    return kMapFormatDoom;
}

Lump *WadFile::FindLumpInNamespace(const char *name, char group)
{
    int k;

    switch (group)
    {
        case 'P':
            for (k = 0; k < (int)patches_.size(); k++)
                if (StringCaseCompareASCII(directory_[patches_[k]]->name_,
                                           name) == 0)
                    return directory_[patches_[k]];
            break;

        case 'S':
            for (k = 0; k < (int)sprites_.size(); k++)
                if (StringCaseCompareASCII(directory_[sprites_[k]]->name_,
                                           name) == 0)
                    return directory_[sprites_[k]];
            break;

        case 'F':
            for (k = 0; k < (int)flats_.size(); k++)
                if (StringCaseCompareASCII(directory_[flats_[k]]->name_,
                                           name) == 0)
                    return directory_[flats_[k]];
            break;

        default:
            ErrorPrintf("AJBSP: FindLumpInNamespace: bad group '%c'\n", group);
    }

    return nullptr;  // not found!
}

void WadFile::ReadDirectory()
{
    // WISH: no fatal errors

    rewind(file_pointer_);

    RawWadHeader header;

    if (file_pointer_ && fread(&header, sizeof(header), 1, file_pointer_) != 1)
        ErrorPrintf("AJBSP: Error reading WAD header.\n");

    // WISH: check ident for PWAD or IWAD

    kind_ = header.ident[0];

    directory_start_ = AlignedLittleEndianS32(header.dir_start);
    directory_count_ = AlignedLittleEndianS32(header.num_entries);

    if (directory_count_ < 0 || directory_count_ > 32000)
        ErrorPrintf("AJBSP: Bad WAD header, too many entries (%d)\n",
                    directory_count_);

    if (file_pointer_ && fseek(file_pointer_, directory_start_, SEEK_SET) != 0)
        ErrorPrintf("AJBSP: Error seeking to WAD directory_.\n");

    for (int i = 0; i < directory_count_; i++)
    {
        RawWadEntry entry;

        if (file_pointer_ &&
            fread(&entry, sizeof(entry), 1, file_pointer_) != 1)
            ErrorPrintf("AJBSP: Error reading WAD directory_.\n");

        Lump *lump = new Lump(this, &entry);

        // WISH: check if entry is valid

        directory_.push_back(lump);
    }
}

void WadFile::DetectLevels()
{
    // Determine what lumps in the wad are level markers, based on the
    // lumps which follow it.  Store the result in the 'levels_' vector.
    // The test here is rather lax, since wads exist with a non-standard
    // ordering of level lumps.

    for (int k = 0; k + 1 < NumLumps(); k++)
    {
        int part_mask  = 0;
        int part_count = 0;

        // check for UDMF levels_
        if (StringCaseCompareASCII(directory_[k + 1]->name_, "TEXTMAP") == 0)
        {
            levels_.push_back(k);
#if DEBUG_WAD
            DebugPrintf("Detected level : %s (UDMF)\n", directory_[k]->name_);
#endif
            continue;
        }

        // check whether the next four lumps are level lumps
        for (int i = 1; i <= 4; i++)
        {
            if (k + i >= NumLumps()) break;

            int part = WhatLevelPart(directory_[k + i]->name_);

            if (part == 0) break;

            // do not allow duplicates
            if (part_mask & (1 << part)) break;

            part_mask |= (1 << part);
            part_count++;
        }

        if (part_count == 4)
        {
            levels_.push_back(k);

#if DEBUG_WAD
            DebugPrintf("Detected level : %s\n", directory_[k]->name_);
#endif
        }
    }

    // sort levels_ into alphabetical order
    SortLevels();
}

void WadFile::SortLevels()
{
    std::sort(levels_.begin(), levels_.end(),
              LevelNameComparisonPredicate(this));
}

static bool IsDummyMarker(const char *name)
{
    // matches P1_START, F3_END etc...

    if (strlen(name) < 3) return false;

    if (!strchr("PSF", ToUpperASCII(name[0]))) return false;

    if (!IsDigitASCII(name[1])) return false;

    if (StringCaseCompareASCII(name + 2, "_START") == 0 ||
        StringCaseCompareASCII(name + 2, "_END") == 0)
        return true;

    return false;
}

void WadFile::ProcessNamespaces()
{
    char active = 0;

    for (int k = 0; k < NumLumps(); k++)
    {
        const char *name = directory_[k]->name_;

        // skip the sub-namespace markers
        if (IsDummyMarker(name)) continue;

        if (StringCaseCompareASCII(name, "P_START") == 0 ||
            StringCaseCompareASCII(name, "PP_START") == 0)
        {
            if (active && active != 'P')
                LumpWarning("missing %c_END marker.\n", active);

            active = 'P';
            continue;
        }
        else if (StringCaseCompareASCII(name, "P_END") == 0 ||
                 StringCaseCompareASCII(name, "PP_END") == 0)
        {
            if (active != 'P') LumpWarning("stray P_END marker found.\n");

            active = 0;
            continue;
        }

        if (StringCaseCompareASCII(name, "S_START") == 0 ||
            StringCaseCompareASCII(name, "SS_START") == 0)
        {
            if (active && active != 'S')
                LumpWarning("missing %c_END marker.\n", active);

            active = 'S';
            continue;
        }
        else if (StringCaseCompareASCII(name, "S_END") == 0 ||
                 StringCaseCompareASCII(name, "SS_END") == 0)
        {
            if (active != 'S') LumpWarning("stray S_END marker found.\n");

            active = 0;
            continue;
        }

        if (StringCaseCompareASCII(name, "F_START") == 0 ||
            StringCaseCompareASCII(name, "FF_START") == 0)
        {
            if (active && active != 'F')
                LumpWarning("missing %c_END marker.\n", active);

            active = 'F';
            continue;
        }
        else if (StringCaseCompareASCII(name, "F_END") == 0 ||
                 StringCaseCompareASCII(name, "FF_END") == 0)
        {
            if (active != 'F') LumpWarning("stray F_END marker found.\n");

            active = 0;
            continue;
        }

        if (StringCaseCompareASCII(name, "TX_START") == 0)
        {
            if (active && active != 'T')
                LumpWarning("missing %c_END marker.\n", active);

            active = 'T';
            continue;
        }
        else if (StringCaseCompareASCII(name, "TX_END") == 0)
        {
            if (active != 'T') LumpWarning("stray TX_END marker found.\n");

            active = 0;
            continue;
        }

        if (active)
        {
            if (directory_[k]->Length() == 0)
            {
                LumpWarning("skipping empty lump %s in %c_START\n", name,
                            active);
                continue;
            }

#if DEBUG_WAD
            DebugPrintf("Namespace %c lump : %s\n", active, name);
#endif

            switch (active)
            {
                case 'P':
                    patches_.push_back(k);
                    break;
                case 'S':
                    sprites_.push_back(k);
                    break;
                case 'F':
                    flats_.push_back(k);
                    break;
                case 'T':
                    tx_textures_.push_back(k);
                    break;

                default:
                    ErrorPrintf("AJBSP: ProcessNamespaces: active = 0x%02x\n",
                                (int)active);
            }
        }
    }

    if (active) LumpWarning("Missing %c_END marker (at EOF)\n", active);
}

//------------------------------------------------------------------------
//  WAD Writing Interface
//------------------------------------------------------------------------

void WadFile::BeginWrite()
{
    if (mode_ == 'r')
        ErrorPrintf("AJBSP: WadFile::BeginWrite() called on read-only file\n");

    if (begun_write_)
        ErrorPrintf(
            "AJBSP: WadFile::BeginWrite() called again without EndWrite()\n");

    // put the size into a quantum state
    total_size_ = 0;

    begun_write_ = true;
}

void WadFile::EndWrite()
{
    if (!begun_write_)
        ErrorPrintf("AJBSP: WadFile::EndWrite() called without BeginWrite()\n");

    begun_write_ = false;

    WriteDirectory();

    // reset the insertion point
    insert_point_ = -1;
}

void WadFile::RemoveLumps(int index, int count)
{
    SYS_ASSERT(begun_write_);
    SYS_ASSERT(0 <= index && index < NumLumps());
    SYS_ASSERT(directory_[index]);

    int i;

    for (i = 0; i < count; i++) { delete directory_[index + i]; }

    for (i = index; i + count < NumLumps(); i++)
        directory_[i] = directory_[i + count];

    directory_.resize(directory_.size() - (size_t)count);

    // fix various arrays containing lump indices
    FixGroup(levels_, index, 0, count);
    FixGroup(patches_, index, 0, count);
    FixGroup(sprites_, index, 0, count);
    FixGroup(flats_, index, 0, count);
    FixGroup(tx_textures_, index, 0, count);

    // reset the insertion point
    insert_point_ = -1;
}

void WadFile::RemoveGLNodes(int level_number)
{
    SYS_ASSERT(begun_write_);
    SYS_ASSERT(0 <= level_number && level_number < LevelCount());

    int start  = LevelHeader(level_number);
    int finish = LevelLastLump(level_number);

    start++;

    while (start <= finish && IsLevelLump(directory_[start]->name_))
    {
        start++;
    }

    int count = 0;

    while (start + count <= finish &&
           IsGLNodeLump(directory_[start + count]->name_))
    {
        count++;
    }

    if (count > 0) RemoveLumps(start, count);
}

void WadFile::RemoveZNodes(int level_number)
{
    SYS_ASSERT(begun_write_);
    SYS_ASSERT(0 <= level_number && level_number < LevelCount());

    short start  = LevelHeader(level_number);
    short finish = LevelLastLump(level_number);

    for (; start <= finish; start++)
    {
        if (StringCaseCompareASCII(directory_[start]->name_, "ZNODES") == 0)
        {
            RemoveLumps(start, 1);
            break;
        }
    }
}

void WadFile::FixGroup(std::vector<int> &group, int index, int number_added,
                       int number_removed)
{
    bool did_remove = false;

    for (int k = 0; k < (int)group.size(); k++)
    {
        if (group[k] < index) continue;

        if (group[k] < index + number_removed)
        {
            group[k]   = -1;
            did_remove = true;
            continue;
        }

        group[k] += number_added;
        group[k] -= number_removed;
    }

    if (did_remove)
    {
        std::vector<int>::iterator ENDP;
        ENDP = std::remove(group.begin(), group.end(), -1);
        group.erase(ENDP, group.end());
    }
}

Lump *WadFile::AddLump(const char *name, int max_size)
{
    SYS_ASSERT(begun_write_);

    begun_max_size_ = max_size;

    int start = PositionForWrite(max_size);

    Lump *lump = new Lump(this, name, start, 0);

    // check if the insert_point_ is still valid
    if (insert_point_ >= NumLumps()) insert_point_ = -1;

    if (insert_point_ >= 0)
    {
        // fix various arrays containing lump indices
        FixGroup(levels_, insert_point_, 1, 0);
        FixGroup(patches_, insert_point_, 1, 0);
        FixGroup(sprites_, insert_point_, 1, 0);
        FixGroup(flats_, insert_point_, 1, 0);
        FixGroup(tx_textures_, insert_point_, 1, 0);

        directory_.insert(directory_.begin() + insert_point_, lump);

        insert_point_++;
    }
    else  // add to end
    {
        directory_.push_back(lump);
    }

    return lump;
}

void WadFile::RecreateLump(Lump *lump, int max_size)
{
    SYS_ASSERT(begun_write_);

    begun_max_size_ = max_size;

    int start = PositionForWrite(max_size);

    lump->lump_start_  = start;
    lump->lump_length_ = 0;
}

Lump *WadFile::AddLevel(const char *name, int max_size, int *level_number)
{
    int actual_point = insert_point_;

    if (actual_point < 0 || actual_point > NumLumps())
        actual_point = NumLumps();

    Lump *lump = AddLump(name, max_size);

    if (level_number) { *level_number = (int)levels_.size(); }

    levels_.push_back(actual_point);

    return lump;
}

void WadFile::InsertPoint(int index)
{
    // this is validated on usage
    insert_point_ = index;
}

int WadFile::HighWaterMark()
{
    int offset = (int)sizeof(RawWadHeader);

    for (int k = 0; k < NumLumps(); k++)
    {
        Lump *lump = directory_[k];

        // ignore zero-length lumps (their offset could be anything)
        if (lump->Length() <= 0) continue;

        int l_end = lump->lump_start_ + lump->lump_length_;

        l_end = ((l_end + 3) / 4) * 4;

        if (offset < l_end) offset = l_end;
    }

    return offset;
}

int WadFile::FindFreeSpace(int length)
{
    length = ((length + 3) / 4) * 4;

    // collect non-zero length lumps and sort by their offset
    std::vector<Lump *> sorted_dir;

    for (int k = 0; k < NumLumps(); k++)
    {
        Lump *lump = directory_[k];

        if (lump->Length() > 0) sorted_dir.push_back(lump);
    }

    std::sort(sorted_dir.begin(), sorted_dir.end(),
              Lump::OffsetComparisonPredicate());

    int offset = (int)sizeof(RawWadHeader);

    for (unsigned int k = 0; k < sorted_dir.size(); k++)
    {
        Lump *lump = sorted_dir[k];

        int lump_start = lump->lump_start_;
        int l_end      = lump->lump_start_ + lump->lump_length_;

        l_end = ((l_end + 3) / 4) * 4;

        if (l_end <= offset) continue;

        if (lump_start >= offset + length) continue;

        // the lump overlapped the current gap, so bump offset

        offset = l_end;
    }

    return offset;
}

int WadFile::PositionForWrite(int max_size)
{
    int want_pos;

    if (max_size <= 0)
        want_pos = HighWaterMark();
    else
        want_pos = FindFreeSpace(max_size);

    // determine if position is past end of file
    // (difference should only be a few bytes)
    //
    // Note: doing this for every new lump may be a little expensive,
    //       but trying to optimise it away will just make the code
    //       needlessly complex and hard to follow.

    if (fseek(file_pointer_, 0, SEEK_END) < 0)
        ErrorPrintf("AJBSP: Error seeking to new write position.\n");

    total_size_ = (int)ftell(file_pointer_);

    if (total_size_ < 0)
        ErrorPrintf("AJBSP: Error seeking to new write position.\n");

    if (want_pos > total_size_)
    {
        SYS_ASSERT(want_pos < total_size_ + 8);

        WritePadding(want_pos - total_size_);
    }
    else if (want_pos == total_size_)
    { /* ready to write */
    }
    else
    {
        if (fseek(file_pointer_, want_pos, SEEK_SET) < 0)
            ErrorPrintf("AJBSP: Error seeking to new write position.\n");
    }

#if DEBUG_WAD
    DebugPrintf("POSITION FOR WRITE: %d  (total_size %d)\n", want_pos,
                total_size);
#endif

    return want_pos;
}

bool WadFile::FinishLump(int final_size)
{
    fflush(file_pointer_);

    // sanity check
    if (begun_max_size_ >= 0)
        if (final_size > begun_max_size_)
            ErrorPrintf(
                "AJBSP: Internal Error: wrote too much in lump (%d > %d)\n",
                final_size, begun_max_size_);

    int pos = (int)ftell(file_pointer_);

    if (pos & 3) { WritePadding(4 - (pos & 3)); }

    fflush(file_pointer_);
    return true;
}

int WadFile::WritePadding(int count)
{
    static uint8_t zeros[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    SYS_ASSERT(1 <= count && count <= 8);

    fwrite(zeros, count, 1, file_pointer_);

    return count;
}

//
// IDEA : Truncate file to "total_size" after writing the directory_.
//
//        On Linux / MacOSX, this can be done as follows:
//                 - fflush(fp)   -- ensure STDIO has empty buffers
//                 - ftruncate(fileno(fp), total_size);
//                 - freopen(fp)
//
//        On Windows:
//                 - instead of ftruncate, use _chsize() or _chsize_s()
//                   [ investigate what the difference is.... ]
//

void WadFile::WriteDirectory()
{
    directory_start_ = PositionForWrite();
    directory_count_ = NumLumps();

#if DEBUG_WAD
    DebugPrintf("WriteDirectory...\n");
    DebugPrintf("dir_start:%d  dir_count:%d\n", dir_start, dir_count);
#endif

    for (int k = 0; k < directory_count_; k++)
    {
        Lump *lump = directory_[k];
        SYS_ASSERT(lump);

        RawWadEntry entry;

        lump->MakeEntry(&entry);

        if (fwrite(&entry, sizeof(entry), 1, file_pointer_) != 1)
            ErrorPrintf("AJBSP: Error writing WAD directory_.\n");
    }

    fflush(file_pointer_);

    total_size_ = (int)ftell(file_pointer_);

#if DEBUG_WAD
    DebugPrintf("total_size: %d\n", total_size);
#endif

    if (total_size_ < 0) ErrorPrintf("AJBSP: Error determining WAD size.\n");

    // update header at start of file

    rewind(file_pointer_);

    RawWadHeader header;

    memcpy(header.ident, (kind_ == 'I') ? "IWAD" : "PWAD", 4);

    header.dir_start   = AlignedLittleEndianU32(directory_start_);
    header.num_entries = AlignedLittleEndianU32(directory_count_);

    if (fwrite(&header, sizeof(header), 1, file_pointer_) != 1)
        ErrorPrintf("AJBSP: Error writing WAD header.\n");

    fflush(file_pointer_);
}

}  // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
