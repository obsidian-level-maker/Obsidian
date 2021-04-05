/*
    WAD-handling routines.
    Copyright (C) 2002-2006 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/
#include "wad.h"

static const char MapLumpNames[12][9] =
{
	"THINGS",
	"LINEDEFS",
	"SIDEDEFS",
	"VERTEXES",
	"SEGS",
	"SSECTORS",
	"NODES",
	"SECTORS",
	"REJECT",
	"BLOCKMAP",
	"BEHAVIOR",
	"SCRIPTS"
};

static const bool MapLumpRequired[12] =
{
	true,	// THINGS
	true,	// LINEDEFS
	true,	// SIDEDEFS
	true,	// VERTEXES
	false,	// SEGS
	false,	// SSECTORS
	false,	// NODES
	true,	// SECTORS
	false,	// REJECT
	false,	// BLOCKMAP
	false,	// BEHAVIOR
	false	// SCRIPTS
};

static const char GLLumpNames[5][9] =
{
	"GL_VERT",
	"GL_SEGS",
	"GL_SSECT",
	"GL_NODES",
	"GL_PVS"
};

FWadReader::FWadReader (const char *filename)
	: Lumps (NULL), File (NULL)
{
	File = fopen (filename, "rb");
	if (File == NULL)
	{
		throw std::runtime_error("Could not open input file");
	}

	SafeRead (&Header, sizeof(Header));
	if (Header.Magic[0] != 'P' && Header.Magic[0] != 'I' &&
		Header.Magic[1] != 'W' &&
		Header.Magic[2] != 'A' &&
		Header.Magic[3] != 'D')
	{
		fclose (File);
		File = NULL;
		throw std::runtime_error("Input file is not a wad");
	}

	Header.NumLumps = LittleLong(Header.NumLumps);
	Header.Directory = LittleLong(Header.Directory);

	if (fseek (File, Header.Directory, SEEK_SET))
	{
		throw std::runtime_error("Could not read wad directory");
	}

	Lumps = new WadLump[Header.NumLumps];
	SafeRead (Lumps, Header.NumLumps * sizeof(*Lumps));

	for (int i = 0; i < Header.NumLumps; ++i)
	{
		Lumps[i].FilePos = LittleLong(Lumps[i].FilePos);
		Lumps[i].Size = LittleLong(Lumps[i].Size);
	}
}

FWadReader::~FWadReader ()
{
	if (File)	fclose (File);
	if (Lumps)	delete[] Lumps;
}

bool FWadReader::IsIWAD () const
{
	return Header.Magic[0] == 'I';
}

int FWadReader::NumLumps () const
{
	return Header.NumLumps;
}

int FWadReader::FindLump (const char *name, int index) const
{
	if (index < 0)
	{
		index = 0;
	}
	for (; index < Header.NumLumps; ++index)
	{
		if (strnicmp (Lumps[index].Name, name, 8) == 0)
		{
			return index;
		}
	}
	return -1;
}

int FWadReader::FindMapLump (const char *name, int map) const
{
	int i, j, k;
	++map;

	for (i = 0; i < 12; ++i)
	{
		if (strnicmp (MapLumpNames[i], name, 8) == 0)
		{
			break;
		}
	}
	if (i == 12)
	{
		return -1;
	}

	for (j = k = 0; j < 12; ++j)
	{
		if (strnicmp (Lumps[map+k].Name, MapLumpNames[j], 8) == 0)
		{
			if (i == j)
			{
				return map+k;
			}
			k++;
		}
	}
	return -1;
}

bool FWadReader::isUDMF (int index) const
{
	index++;

	if (strnicmp(Lumps[index].Name, "TEXTMAP", 8) == 0)
	{
		// UDMF map
		return true;
	}
	return false;
}


bool FWadReader::IsMap (int index) const
{
	int i, j;

	if (isUDMF(index)) return true;

	index++;

	for (i = j = 0; i < 12; ++i)
	{
		if (strnicmp (Lumps[index+j].Name, MapLumpNames[i], 8) != 0)
		{
			if (MapLumpRequired[i])
			{
				return false;
			}
		}
		else
		{
			j++;
		}
	}
	return true;
}

int FWadReader::FindGLLump (const char *name, int glheader) const
{
	int i, j, k;
	++glheader;

	for (i = 0; i < 5; ++i)
	{
		if (strnicmp (Lumps[glheader+i].Name, name, 8) == 0)
		{
			break;
		}
	}
	if (i == 5)
	{
		return -1;
	}

	for (j = k = 0; j < 5; ++j)
	{
		if (strnicmp (Lumps[glheader+k].Name, GLLumpNames[j], 8) == 0)
		{
			if (i == j)
			{
				return glheader+k;
			}
			k++;
		}
	}
	return -1;
}

bool FWadReader::IsGLNodes (int index) const
{
	if (index + 4 >= Header.NumLumps)
	{
		return false;
	}
	if (Lumps[index].Name[0] != 'G' ||
		Lumps[index].Name[1] != 'L' ||
		Lumps[index].Name[2] != '_')
	{
		return false;
	}
	index++;
	for (int i = 0; i < 4; ++i)
	{
		if (strnicmp (Lumps[i+index].Name, GLLumpNames[i], 8) != 0)
		{
			return false;
		}
	}
	return true;
}

int FWadReader::SkipGLNodes (int index) const
{
	index++;
	for (int i = 0; i < 5 && index < Header.NumLumps; ++i, ++index)
	{
		if (strnicmp (Lumps[index].Name, GLLumpNames[i], 8) != 0)
		{
			break;
		}
	}
	return index;
}

bool FWadReader::MapHasBehavior (int map) const
{
	return FindMapLump ("BEHAVIOR", map) != -1;
}

int FWadReader::NextMap (int index) const
{
	if (index < 0)
	{
		index = 0;
	}
	else
	{
		index++;
	}
	for (; index < Header.NumLumps; ++index)
	{
		if (IsMap (index))
		{
			return index;
		}
	}
	return -1;
}

int FWadReader::LumpAfterMap (int i) const
{
	int j, k;

	if (isUDMF(i))
	{
		// UDMF map
		i += 2;
		while (strnicmp(Lumps[i].Name, "ENDMAP", 8) != 0 && i < Header.NumLumps)
		{
			i++;
		}
		return i+1;	// one lump after ENDMAP
	}

	i++;
	for (j = k = 0; j < 12; ++j)
	{
		if (strnicmp (Lumps[i+k].Name, MapLumpNames[j], 8) != 0)
		{
			if (MapLumpRequired[j])
			{
				break;
			}
		}
		else
		{
			k++;
		}
	}
	return i+k;
}

void FWadReader::SafeRead (void *buffer, size_t size)
{
	if (fread (buffer, 1, size, File) != size)
	{
		throw std::runtime_error("Failed to read");
	}
}

const char *FWadReader::LumpName (int lump)
{
	static char name[9];
	strncpy (name, Lumps[lump].Name, 8);
	name[8] = 0;
	return name;
}

FWadWriter::FWadWriter (const char *filename, bool iwad)
	: File (NULL)
{
	File = fopen (filename, "wb");
	if (File == NULL)
	{
		throw std::runtime_error("Could not open output file");
	}

	WadHeader head;

	if (iwad)
	{
		head.Magic[0] = 'I';
	}
	else
	{
		head.Magic[0] = 'P';
	}
	head.Magic[1] = 'W';
	head.Magic[2] = 'A';
	head.Magic[3] = 'D';

	SafeWrite (&head, sizeof(head));
}

FWadWriter::~FWadWriter ()
{
	if (File)
	{
		Close ();
	}
}

void FWadWriter::Close ()
{
	if (File)
	{
		int32_t head[2];

		head[0] = LittleLong(Lumps.Size());
		head[1] = LittleLong(ftell (File));

		SafeWrite (&Lumps[0], sizeof(WadLump)*Lumps.Size());
		fseek (File, 4, SEEK_SET);
		SafeWrite (head, 8);
		fclose (File);
		File = NULL;
	}
}

void FWadWriter::CreateLabel (const char *name)
{
	WadLump lump;

	strncpy (lump.Name, name, 8);
	lump.FilePos = LittleLong(ftell (File));
	lump.Size = 0;
	Lumps.Push (lump);
}

void FWadWriter::WriteLump (const char *name, const void *data, int len)
{
	WadLump lump;

	strncpy (lump.Name, name, 8);
	lump.FilePos = LittleLong(ftell (File));
	lump.Size = LittleLong(len);
	Lumps.Push (lump);

	SafeWrite (data, len);
}

void FWadWriter::CopyLump (FWadReader &wad, int lump)
{
	BYTE *data;
	int size;

	ReadLump<BYTE> (wad, lump, data, size);
	if (data != NULL)
	{
		WriteLump (wad.LumpName (lump), data, size);
		delete[] data;
	}
}

void FWadWriter::StartWritingLump (const char *name)
{
	CreateLabel (name);
}

void FWadWriter::AddToLump (const void *data, int len)
{
	SafeWrite (data, len);
	Lumps[Lumps.Size()-1].Size += len;
}

void FWadWriter::SafeWrite (const void *buffer, size_t size)
{
	if (fwrite (buffer, 1, size, File) != size)
	{
		fclose (File);
		File = NULL;
		throw std::runtime_error(
			"Failed to write. Check that this directory is writable and\n"
			"that you have enough free disk space.");
	}
}

FWadWriter &FWadWriter::operator << (BYTE val)
{
	AddToLump (&val, 1);
	return *this;
}

FWadWriter &FWadWriter::operator << (WORD val)
{
	val = LittleShort(val);
	AddToLump ((BYTE *)&val, 2);
	return *this;
}

FWadWriter &FWadWriter::operator << (SWORD val)
{
	val = LittleShort(val);
	AddToLump ((BYTE *)&val, 2);
	return *this;
}

FWadWriter &FWadWriter::operator << (DWORD val)
{
	val = LittleLong(val);
	AddToLump ((BYTE *)&val, 4);
	return *this;
}

FWadWriter &FWadWriter::operator << (fixed_t val)
{
	val = LittleLong(val);
	AddToLump ((BYTE *)&val, 4);
	return *this;
}

