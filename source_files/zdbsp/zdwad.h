#ifndef __WAD_H__
#define __WAD_H__

#ifdef _MSC_VER
#pragma once
#endif

#include <stdio.h>
#include <string.h>
#include <filesystem>
#include <fstream>

#include "tarray.h"
#include "zdbsp.h"
#include "lib_util.h"

struct WadHeader {
    char Magic[4];
    int32_t NumLumps;
    int32_t Directory;
};

struct WadLump {
    int32_t FilePos;
    int32_t Size;
    char Name[8];
};

class FWadReader {
   public:
    FWadReader(std::filesystem::path filename);
    ~FWadReader();

    bool IsIWAD() const;
    bool isUDMF(int lump) const;
    int FindLump(const char *name, int index = 0) const;
    int FindMapLump(const char *name, int map) const;
    int FindGLLump(const char *name, int glheader) const;
    const char *LumpName(int lump);
    bool IsMap(int index) const;
    bool IsGLNodes(int index) const;
    int SkipGLNodes(int index) const;
    bool MapHasBehavior(int map) const;
    int NextMap(int startindex) const;
    int LumpAfterMap(int map) const;
    int NumLumps() const;
    void Close();

    // VC++ 6 does not support template member functions in non-template
    // classes!
    template <class T>
    friend void ReadLump(FWadReader &wad, int index, T *&data, int &size);

   private:
    WadHeader Header;
    WadLump *Lumps;
    std::ifstream File;
};

template <class T>
void ReadLump(FWadReader &wad, int index, T *&data, int &size) {
    if ((unsigned)index >= (unsigned)wad.Header.NumLumps) {
        data = NULL;
        size = 0;
        return;
    }
    wad.File.seekg(wad.Lumps[index].FilePos);
    if (wad.File.tellg() != wad.Lumps[index].FilePos) {
        throw std::runtime_error("Failed to seek");        
    }
    size = wad.Lumps[index].Size / sizeof(T);
    data = new T[size];
    wad.File.read(reinterpret_cast<char *>(data), size * sizeof(T));
    if (wad.File.gcount() != size * sizeof(T)) {
        throw std::runtime_error("Failed to read lump");
    }
}

template <class T>
void ReadMapLump(FWadReader &wad, const char *name, int index, T *&data,
                 int &size) {
    ReadLump(wad, wad.FindMapLump(name, index), data, size);
}

class FWadWriter {
   public:
    FWadWriter(std::filesystem::path filename, bool iwad);
    ~FWadWriter();

    void CreateLabel(const char *name);
    void WriteLump(const char *name, const void *data, int len);
    void CopyLump(FWadReader &wad, int lump);
    void Close();

    // Routines to write a lump in segments.
    void StartWritingLump(const char *name);
    void AddToLump(const void *data, int len);

    FWadWriter &operator<<(BYTE);
    FWadWriter &operator<<(WORD);
    FWadWriter &operator<<(SWORD);
    FWadWriter &operator<<(DWORD);
    FWadWriter &operator<<(fixed_t);

   private:
    TArray<WadLump> Lumps;
    std::ofstream File;
};

#ifdef _MSC_VER
#define strncasecmp _strnicmp
#endif

#endif  //__WAD_H__
