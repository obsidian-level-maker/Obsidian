#ifndef __WAD_H__
#define __WAD_H__

#ifdef _MSC_VER
#pragma once
#endif

#include <stdio.h>
#include <string.h>

#include "zdbsp.h"
#include "tarray.h"

struct WadHeader
{
	char	Magic[4];
	int32_t NumLumps;
	int32_t Directory;
};

struct WadLump
{
	int32_t FilePos;
	int32_t Size;
	char	Name[8];
};

class FWadReader
{
public:
	FWadReader (const char *filename);
	~FWadReader ();

	bool IsIWAD () const;
	bool isUDMF(int lump) const;
	int FindLump (const char *name, int index=0) const;
	int FindMapLump (const char *name, int map) const;
	int FindGLLump (const char *name, int glheader) const;
	const char *LumpName (int lump);
	bool IsMap (int index) const;
	bool IsGLNodes (int index) const;
	int SkipGLNodes (int index) const;
	bool MapHasBehavior (int map) const;
	int NextMap (int startindex) const;
	int LumpAfterMap (int map) const;
	int NumLumps () const;

	void SafeRead (void *buffer, size_t size);

// VC++ 6 does not support template member functions in non-template classes!
	template<class T>
	friend void ReadLump (FWadReader &wad, int index, T *&data, int &size);

private:
	WadHeader Header;
	WadLump *Lumps;
	FILE *File;
};


template<class T>
void ReadLump (FWadReader &wad, int index, T *&data, int &size)
{
	if ((unsigned)index >= (unsigned)wad.Header.NumLumps)
	{
		data = NULL;
		size = 0;
		return;
	}
	if (fseek (wad.File, wad.Lumps[index].FilePos, SEEK_SET))
	{
		throw std::runtime_error("Failed to seek");
	}
	size = wad.Lumps[index].Size / sizeof(T);
	data = new T[size];
	wad.SafeRead (data, size*sizeof(T));
}

template<class T>
void ReadMapLump (FWadReader &wad, const char *name, int index, T *&data, int &size)
{
	ReadLump (wad, wad.FindMapLump (name, index), data, size);
}


class FWadWriter
{
public:
	FWadWriter (const char *filename, bool iwad);
	~FWadWriter ();

	void CreateLabel (const char *name);
	void WriteLump (const char *name, const void *data, int len);
	void CopyLump (FWadReader &wad, int lump);
	void Close ();

	// Routines to write a lump in segments.
	void StartWritingLump (const char *name);
	void AddToLump (const void *data, int len);

	FWadWriter &operator << (BYTE);
	FWadWriter &operator << (WORD);
	FWadWriter &operator << (SWORD);
	FWadWriter &operator << (DWORD);
	FWadWriter &operator << (fixed_t);

private:
	TArray<WadLump> Lumps;
	FILE *File;

	void SafeWrite (const void *buffer, size_t size);
};

#endif //__WAD_H__
