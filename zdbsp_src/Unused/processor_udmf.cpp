/*
    Reads and writes UDMF maps
    Copyright (C) 2009 Christoph Oelckers

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


#include <float.h>
#include "processor.h"
#include "sc_man.h"

typedef double real64;
typedef unsigned int uint32;
typedef signed int int32;
#include "xs_Float.h"


class StringBuffer
{
	const static size_t BLOCK_SIZE = 100000;
	const static size_t BLOCK_ALIGN = sizeof(size_t);

	TDeletingArray<char *> blocks;
	size_t currentindex;

	char *Alloc(size_t size)
	{
		if (currentindex + size >= BLOCK_SIZE)
		{
			// Block is full - get a new one!
			char *newblock = new char[BLOCK_SIZE];
			blocks.Push(newblock);
			currentindex = 0;
		}
		size = (size + BLOCK_ALIGN-1) &~ (BLOCK_ALIGN-1);
		char *p = blocks[blocks.Size()-1] + currentindex;
		currentindex += size;
		return p;
	}
public:

	StringBuffer()
	{
		currentindex = BLOCK_SIZE;
	}

	char * Copy(const char * p)
	{
		return p != NULL? strcpy(Alloc(strlen(p)+1) , p) : NULL;
	}
};

StringBuffer stbuf;


//===========================================================================
//
// Parses a 'key = value;' line of the map
//
//===========================================================================

const char *FProcessor::ParseKey(const char *&value)
{
	SC_MustGetString();
	const char *key = stbuf.Copy(sc_String);
	SC_MustGetStringName("=");

	sc_Number = INT_MIN;
	sc_Float = DBL_MIN;
	if (!SC_CheckFloat())
	{
		SC_MustGetString();
	}
	value = stbuf.Copy(sc_String);
	SC_MustGetStringName(";");
	return key;
}

bool FProcessor::CheckKey(const char *&key, const char *&value)
{
	SC_SavePos();
	SC_MustGetString();
	if (SC_CheckString("="))
	{
		SC_RestorePos();
		key = ParseKey(value);
		return true;
	}
	SC_RestorePos();
	return false;
}

int CheckInt(const char *key)
{
	if (sc_Number == INT_MIN)
	{
		SC_ScriptError("Integer value expected for key '%s'", key);
	}
	return sc_Number;
}

double CheckFloat(const char *key)
{
	if (sc_Float == DBL_MIN)
	{
		SC_ScriptError("Floating point value expected for key '%s'", key);
	}
	return sc_Float;
}

fixed_t CheckFixed(const char *key)
{
	double val = CheckFloat(key);
	if (val < -32768 || val > 32767)
	{
		SC_ScriptError("Fixed point value is out of range for key '%s'\n\t%.2f should be within [-32768,32767]", key, val / 65536);
	}
	return xs_Fix<16>::ToFix(val);
}

//===========================================================================
//
// Parse a thing block
//
//===========================================================================

void FProcessor::ParseThing(IntThing *th)
{
	SC_MustGetStringName("{");
	while (!SC_CheckString("}"))
	{
		const char *value;
		const char *key = ParseKey(value);

		// The only properties we need from a thing are
		// x, y, angle and type.

		if (!stricmp(key, "x"))
		{
			th->x = CheckFixed(key);
		}
		else if (!stricmp(key, "y"))
		{
			th->y = CheckFixed(key);
		}
		if (!stricmp(key, "angle"))
		{
			th->angle = (short)CheckInt(key);
		}
		if (!stricmp(key, "type"))
		{
			th->type = (short)CheckInt(key);
		}

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		th->props.Push(k);
	}
}

//===========================================================================
//
// Parse a linedef block
//
//===========================================================================

void FProcessor::ParseLinedef(IntLineDef *ld)
{
	SC_MustGetStringName("{");
	ld->v1 = ld->v2 = ld->sidenum[0] = ld->sidenum[1] = NO_INDEX;
	ld->special = 0;
	while (!SC_CheckString("}"))
	{
		const char *value;
		const char *key = ParseKey(value);

		if (!stricmp(key, "v1"))
		{
			ld->v1 = CheckInt(key);
			continue;	// do not store in props
		}
		else if (!stricmp(key, "v2"))
		{
			ld->v2 = CheckInt(key);
			continue;	// do not store in props
		}
		else if (Extended && !stricmp(key, "special"))
		{
			ld->special = CheckInt(key);
		}
		else if (Extended && !stricmp(key, "arg0"))
		{
			ld->args[0] = CheckInt(key);
		}
		if (!stricmp(key, "sidefront"))
		{
			ld->sidenum[0] = CheckInt(key);
			continue;	// do not store in props
		}
		else if (!stricmp(key, "sideback"))
		{
			ld->sidenum[1] = CheckInt(key);
			continue;	// do not store in props
		}

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		ld->props.Push(k);
	}
}

//===========================================================================
//
// Parse a sidedef block
//
//===========================================================================

void FProcessor::ParseSidedef(IntSideDef *sd)
{
	SC_MustGetStringName("{");
	sd->sector = NO_INDEX;
	while (!SC_CheckString("}"))
	{
		const char *value;
		const char *key = ParseKey(value);

		if (!stricmp(key, "sector"))
		{
			sd->sector = CheckInt(key);
			continue;	// do not store in props
		}

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		sd->props.Push(k);
	}
}

//===========================================================================
//
// Parse a sidedef block
//
//===========================================================================

void FProcessor::ParseSector(IntSector *sec)
{
	SC_MustGetStringName("{");
	while (!SC_CheckString("}"))
	{
		const char *value;
		const char *key = ParseKey(value);

		// No specific sector properties are ever used by the node builder
		// so everything can go directly to the props array.

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		sec->props.Push(k);
	}
}

//===========================================================================
//
// parse a vertex block
//
//===========================================================================

void FProcessor::ParseVertex(WideVertex *vt, IntVertex *vtp)
{
	vt->x = vt->y = 0;
	SC_MustGetStringName("{");
	while (!SC_CheckString("}"))
	{
		const char *value;
		const char *key = ParseKey(value);

		if (!stricmp(key, "x"))
		{
			vt->x = CheckFixed(key);
		}
		else if (!stricmp(key, "y"))
		{
			vt->y = CheckFixed(key);
		}

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		vtp->props.Push(k);
	}
}


//===========================================================================
//
// parses global map properties
//
//===========================================================================

void FProcessor::ParseMapProperties()
{
	const char *key, *value;

	// all global keys must come before the first map element.

	while (CheckKey(key, value))
	{
		if (!stricmp(key, "namespace"))
		{
			// all unknown namespaces are assumed to be standard.
			Extended = !stricmp(value, "\"ZDoom\"") || !stricmp(value, "\"Hexen\"") || !stricmp(value, "\"Vavoom\"");
		}

		// now store the key in its unprocessed form
		UDMFKey k = {key, value};
		Level.props.Push(k);
	}
}


//===========================================================================
//
// Main parsing function
//
//===========================================================================

void FProcessor::ParseTextMap(int lump)
{
	char *buffer;
	int buffersize;
	TArray<WideVertex> Vertices;

	ReadLump<char> (Wad, lump, buffer, buffersize);
	SC_OpenMem("TEXTMAP", buffer, buffersize);

	SC_SetCMode(true);
	ParseMapProperties();

	while (SC_GetString())
	{
		if (SC_Compare("thing"))
		{
			IntThing *th = &Level.Things[Level.Things.Reserve(1)];
			ParseThing(th);
		}
		else if (SC_Compare("linedef"))
		{
			IntLineDef *ld = &Level.Lines[Level.Lines.Reserve(1)];
			ParseLinedef(ld);
		}
		else if (SC_Compare("sidedef"))
		{
			IntSideDef *sd = &Level.Sides[Level.Sides.Reserve(1)];
			ParseSidedef(sd);
		}
		else if (SC_Compare("sector"))
		{
			IntSector *sec = &Level.Sectors[Level.Sectors.Reserve(1)];
			ParseSector(sec);
		}
		else if (SC_Compare("vertex"))
		{
			WideVertex *vt = &Vertices[Vertices.Reserve(1)];
			IntVertex *vtp = &Level.VertexProps[Level.VertexProps.Reserve(1)];
			vt->index = Vertices.Size();
			ParseVertex(vt, vtp);
		}
	}
	Level.Vertices = new WideVertex[Vertices.Size()];
	Level.NumVertices = Vertices.Size();
	memcpy(Level.Vertices, &Vertices[0], Vertices.Size() * sizeof(WideVertex));
	SC_Close();
	delete[] buffer;
}


//===========================================================================
//
// parse an UDMF map
//
//===========================================================================

void FProcessor::LoadUDMF()
{
	ParseTextMap(Lump+1);
}

//===========================================================================
//
// writes a property list
//
//===========================================================================

void FProcessor::WriteProps(FWadWriter &out, TArray<UDMFKey> &props)
{
	for(unsigned i=0; i< props.Size(); i++)
	{
		out.AddToLump(props[i].key, (int)strlen(props[i].key));
		out.AddToLump(" = ", 3);
		out.AddToLump(props[i].value, (int)strlen(props[i].value));
		out.AddToLump(";\n", 2);
	}
}

//===========================================================================
//
// writes an integer property
//
//===========================================================================

void FProcessor::WriteIntProp(FWadWriter &out, const char *key, int value)
{
	char buffer[20];

	out.AddToLump(key, (int)strlen(key));
	out.AddToLump(" = ", 3);
	sprintf(buffer, "%d;\n", value);
	out.AddToLump(buffer, (int)strlen(buffer));
}

//===========================================================================
//
// writes a UDMF thing
//
//===========================================================================

void FProcessor::WriteThingUDMF(FWadWriter &out, IntThing *th, int num)
{
	out.AddToLump("thing", 5);
	if (WriteComments)
	{
		char buffer[32];
		int len = sprintf(buffer, " // %d", num);
		out.AddToLump(buffer, len);
	}
	out.AddToLump("\n{\n", 3);
	WriteProps(out, th->props);
	out.AddToLump("}\n\n", 3);
}

//===========================================================================
//
// writes a UDMF linedef
//
//===========================================================================

void FProcessor::WriteLinedefUDMF(FWadWriter &out, IntLineDef *ld, int num)
{
	out.AddToLump("linedef", 7);
	if (WriteComments)
	{
		char buffer[32];
		int len = sprintf(buffer, " // %d", num);
		out.AddToLump(buffer, len);
	}
	out.AddToLump("\n{\n", 3);
	WriteIntProp(out, "v1", ld->v1);
	WriteIntProp(out, "v2", ld->v2);
	if (ld->sidenum[0] != NO_INDEX) WriteIntProp(out, "sidefront", ld->sidenum[0]);
	if (ld->sidenum[1] != NO_INDEX) WriteIntProp(out, "sideback", ld->sidenum[1]);
	WriteProps(out, ld->props);
	out.AddToLump("}\n\n", 3);
}

//===========================================================================
//
// writes a UDMF sidedef
//
//===========================================================================

void FProcessor::WriteSidedefUDMF(FWadWriter &out, IntSideDef *sd, int num)
{
	out.AddToLump("sidedef", 7);
	if (WriteComments)
	{
		char buffer[32];
		int len = sprintf(buffer, " // %d", num);
		out.AddToLump(buffer, len);
	}
	out.AddToLump("\n{\n", 3);
	WriteIntProp(out, "sector", sd->sector);
	WriteProps(out, sd->props);
	out.AddToLump("}\n\n", 3);
}

//===========================================================================
//
// writes a UDMF sector
//
//===========================================================================

void FProcessor::WriteSectorUDMF(FWadWriter &out, IntSector *sec, int num)
{
	out.AddToLump("sector", 6);
	if (WriteComments)
	{
		char buffer[32];
		int len = sprintf(buffer, " // %d", num);
		out.AddToLump(buffer, len);
	}
	out.AddToLump("\n{\n", 3);
	WriteProps(out, sec->props);
	out.AddToLump("}\n\n", 3);
}

//===========================================================================
//
// writes a UDMF vertex
//
//===========================================================================

void FProcessor::WriteVertexUDMF(FWadWriter &out, IntVertex *vt, int num)
{
	out.AddToLump("vertex", 6);
	if (WriteComments)
	{
		char buffer[32];
		int len = sprintf(buffer, " // %d", num);
		out.AddToLump(buffer, len);
	}
	out.AddToLump("\n{\n", 3);
	WriteProps(out, vt->props);
	out.AddToLump("}\n\n", 3);
}

//===========================================================================
//
// writes a UDMF text map
//
//===========================================================================

void FProcessor::WriteTextMap(FWadWriter &out)
{
	out.StartWritingLump("TEXTMAP");
	WriteProps(out, Level.props);
	for(int i = 0; i < Level.NumThings(); i++)
	{
		WriteThingUDMF(out, &Level.Things[i], i);
	}

	for(int i = 0; i < Level.NumOrgVerts; i++)
	{
		WideVertex *vt = &Level.Vertices[i];
		if (vt->index <= 0)
		{
			// not valid!
			throw std::runtime_error("Invalid vertex data.");
		}
		WriteVertexUDMF(out, &Level.VertexProps[vt->index-1], i);
	}

	for(int i = 0; i < Level.NumLines(); i++)
	{
		WriteLinedefUDMF(out, &Level.Lines[i], i);
	}

	for(int i = 0; i < Level.NumSides(); i++)
	{
		WriteSidedefUDMF(out, &Level.Sides[i], i);
	}

	for(int i = 0; i < Level.NumSectors(); i++)
	{
		WriteSectorUDMF(out, &Level.Sectors[i], i);
	}
}

//===========================================================================
//
// writes an UDMF map
//
//===========================================================================

void FProcessor::WriteUDMF(FWadWriter &out)
{
	out.CopyLump (Wad, Lump);
	WriteTextMap(out);
	if (ForceCompression) WriteGLBSPZ (out, "ZNODES");
	else WriteGLBSPX (out, "ZNODES");

	// copy everything except existing nodes, blockmap and reject
	for(int i=Lump+2; stricmp(Wad.LumpName(i), "ENDMAP") && i < Wad.NumLumps(); i++)
	{
		const char *lumpname = Wad.LumpName(i);
		if (stricmp(lumpname, "ZNODES") &&
			stricmp(lumpname, "BLOCKMAP") &&
			stricmp(lumpname, "REJECT"))
		{
			out.CopyLump(Wad, i);
		}
	}
	out.CreateLabel("ENDMAP");
}
