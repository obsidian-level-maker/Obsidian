/*
    Reads wad files, builds nodes, and saves new wad files.
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

#include "processor.h"
//#include "rejectbuilder.h"

extern void ShowView (FLevel *level);

enum
{
	// Thing numbers used in Hexen maps
    PO_HEX_ANCHOR_TYPE = 3000,
    PO_HEX_SPAWN_TYPE,
    PO_HEX_SPAWNCRUSH_TYPE,

    // Thing numbers used in Doom and Heretic maps
    PO_ANCHOR_TYPE = 9300,
    PO_SPAWN_TYPE,
    PO_SPAWNCRUSH_TYPE,
	PO_SPAWNHURT_TYPE
};

FLevel::FLevel ()
{
	memset (this, 0, sizeof(*this));
}

FLevel::~FLevel ()
{
	if (Vertices)		delete[] Vertices;
	if (Subsectors)		delete[] Subsectors;
	if (Segs)			delete[] Segs;
	if (Nodes)			delete[] Nodes;
	if (Blockmap)		delete[] Blockmap;
	if (Reject)			delete[] Reject;
	if (GLSubsectors)	delete[] GLSubsectors;
	if (GLSegs)			delete[] GLSegs;
	if (GLNodes)		delete[] GLNodes;
	if (GLPVS)			delete[] GLPVS;
	if (OrgSectorMap)	delete[] OrgSectorMap;
}

FProcessor::FProcessor (FWadReader &inwad, int lump)
:
  Wad (inwad), Lump (lump)
{
	printf ("----%s----\n", Wad.LumpName (Lump));

	isUDMF = Wad.isUDMF(lump);

	if (isUDMF)
	{
		Extended = false;
		LoadUDMF();
	}
	else
	{
		Extended = Wad.MapHasBehavior (lump);
		LoadThings ();
		LoadVertices ();
		LoadLines ();
		LoadSides ();
		LoadSectors ();
	}

	if (Level.NumLines() == 0 || Level.NumVertices == 0 || Level.NumSides() == 0 || Level.NumSectors() == 0)
	{
		printf ("   Map is incomplete\n");
	}
	else
	{
		// Removing extra vertices is done by the node builder.
		Level.RemoveExtraLines ();
		if (!NoPrune)
		{
			Level.RemoveExtraSides ();
			Level.RemoveExtraSectors ();
		}

		if (BuildNodes)
		{
			GetPolySpots ();
		}

		Level.FindMapBounds ();
	}
}

void FProcessor::LoadThings ()
{
	int NumThings;

	if (Extended)
	{
		MapThing2 *Things;
		ReadMapLump<MapThing2> (Wad, "THINGS", Lump, Things, NumThings);

		Level.Things.Resize(NumThings);
		for (int i = 0; i < NumThings; ++i)
		{
			Level.Things[i].thingid = Things[i].thingid;
			Level.Things[i].x = LittleShort(Things[i].x) << FRACBITS;
			Level.Things[i].y = LittleShort(Things[i].y) << FRACBITS;
			Level.Things[i].z = LittleShort(Things[i].z);
			Level.Things[i].angle = LittleShort(Things[i].angle);
			Level.Things[i].type = LittleShort(Things[i].type);
			Level.Things[i].flags = LittleShort(Things[i].flags);
			Level.Things[i].special = Things[i].special;
			Level.Things[i].args[0] = Things[i].args[0];
			Level.Things[i].args[1] = Things[i].args[1];
			Level.Things[i].args[2] = Things[i].args[2];
			Level.Things[i].args[3] = Things[i].args[3];
			Level.Things[i].args[4] = Things[i].args[4];
		}
		delete[] Things;
	}
	else
	{
		MapThing *mt;
		ReadMapLump<MapThing> (Wad, "THINGS", Lump, mt, NumThings);

		Level.Things.Resize(NumThings);
		for (int i = 0; i < NumThings; ++i)
		{
			Level.Things[i].x = LittleShort(mt[i].x) << FRACBITS;
			Level.Things[i].y = LittleShort(mt[i].y) << FRACBITS;
			Level.Things[i].angle = LittleShort(mt[i].angle);
			Level.Things[i].type = LittleShort(mt[i].type);
			Level.Things[i].flags = LittleShort(mt[i].flags);
			Level.Things[i].z = 0;
			Level.Things[i].special = 0;
			Level.Things[i].args[0] = 0;
			Level.Things[i].args[1] = 0;
			Level.Things[i].args[2] = 0;
			Level.Things[i].args[3] = 0;
			Level.Things[i].args[4] = 0;
		}
		delete[] mt;
	}
}

void FProcessor::LoadLines ()
{
	int NumLines;

	if (Extended)
	{
		MapLineDef2 *Lines;

		ReadMapLump<MapLineDef2> (Wad, "LINEDEFS", Lump, Lines, NumLines);

		Level.Lines.Resize(NumLines);
		for (int i = 0; i < NumLines; ++i)
		{
			Level.Lines[i].special = Lines[i].special;
			Level.Lines[i].args[0] = Lines[i].args[0];
			Level.Lines[i].args[1] = Lines[i].args[1];
			Level.Lines[i].args[2] = Lines[i].args[2];
			Level.Lines[i].args[3] = Lines[i].args[3];
			Level.Lines[i].args[4] = Lines[i].args[4];
			Level.Lines[i].v1 = LittleShort(Lines[i].v1);
			Level.Lines[i].v2 = LittleShort(Lines[i].v2);
			Level.Lines[i].flags = LittleShort(Lines[i].flags);
			Level.Lines[i].sidenum[0] = LittleShort(Lines[i].sidenum[0]);
			Level.Lines[i].sidenum[1] = LittleShort(Lines[i].sidenum[1]);
			if (Level.Lines[i].sidenum[0] == NO_MAP_INDEX) Level.Lines[i].sidenum[0] = NO_INDEX;
			if (Level.Lines[i].sidenum[1] == NO_MAP_INDEX) Level.Lines[i].sidenum[1] = NO_INDEX;
		}
		delete[] Lines;
	}
	else
	{
		MapLineDef *ml;
		ReadMapLump<MapLineDef> (Wad, "LINEDEFS", Lump, ml, NumLines);

		Level.Lines.Resize(NumLines);
		for (int i = 0; i < NumLines; ++i)
		{
			Level.Lines[i].v1 = LittleShort(ml[i].v1);
			Level.Lines[i].v2 = LittleShort(ml[i].v2);
			Level.Lines[i].flags = LittleShort(ml[i].flags);
			Level.Lines[i].sidenum[0] = LittleShort(ml[i].sidenum[0]);
			Level.Lines[i].sidenum[1] = LittleShort(ml[i].sidenum[1]);
			if (Level.Lines[i].sidenum[0] == NO_MAP_INDEX) Level.Lines[i].sidenum[0] = NO_INDEX;
			if (Level.Lines[i].sidenum[1] == NO_MAP_INDEX) Level.Lines[i].sidenum[1] = NO_INDEX;

			// Store the special and tag in the args array so we don't lose them
			Level.Lines[i].special = 0;
			Level.Lines[i].args[0] = LittleShort(ml[i].special);
			Level.Lines[i].args[1] = LittleShort(ml[i].tag);
		}
		delete[] ml;
	}
}

void FProcessor::LoadVertices ()
{
	MapVertex *verts;
	ReadMapLump<MapVertex> (Wad, "VERTEXES", Lump, verts, Level.NumVertices);

	Level.Vertices = new WideVertex[Level.NumVertices];

	for (int i = 0; i < Level.NumVertices; ++i)
	{
		Level.Vertices[i].x = LittleShort(verts[i].x) << FRACBITS;
		Level.Vertices[i].y = LittleShort(verts[i].y) << FRACBITS;
		Level.Vertices[i].index = 0; // we don't need this value for non-UDMF maps
	}
}

void FProcessor::LoadSides ()
{
	MapSideDef *Sides;
	int NumSides;
	ReadMapLump<MapSideDef> (Wad, "SIDEDEFS", Lump, Sides, NumSides);

	Level.Sides.Resize(NumSides);
	for (int i = 0; i < NumSides; ++i)
	{
		Level.Sides[i].textureoffset = Sides[i].textureoffset;
		Level.Sides[i].rowoffset = Sides[i].rowoffset;
		memcpy(Level.Sides[i].toptexture, Sides[i].toptexture, 8);
		memcpy(Level.Sides[i].bottomtexture, Sides[i].bottomtexture, 8);
		memcpy(Level.Sides[i].midtexture, Sides[i].midtexture, 8);

		Level.Sides[i].sector = LittleShort(Sides[i].sector);
		if (Level.Sides[i].sector == NO_MAP_INDEX) Level.Sides[i].sector = NO_INDEX;
	}
	delete [] Sides;
}

void FProcessor::LoadSectors ()
{
	MapSector *Sectors;
	int NumSectors;

	ReadMapLump<MapSector> (Wad, "SECTORS", Lump, Sectors, NumSectors);
	Level.Sectors.Resize(NumSectors);

	for (int i = 0; i < NumSectors; ++i)
	{
		Level.Sectors[i].data = Sectors[i];
	}
}

void FLevel::FindMapBounds ()
{
	fixed_t minx, maxx, miny, maxy;

	minx = maxx = Vertices[0].x;
	miny = maxy = Vertices[0].y;

	for (int i = 1; i < NumVertices; ++i)
	{
			 if (Vertices[i].x < minx) minx = Vertices[i].x;
		else if (Vertices[i].x > maxx) maxx = Vertices[i].x;
			 if (Vertices[i].y < miny) miny = Vertices[i].y;
		else if (Vertices[i].y > maxy) maxy = Vertices[i].y;
	}

	MinX = minx;
	MinY = miny;
	MaxX = maxx;
	MaxY = maxy;
}

void FLevel::RemoveExtraLines ()
{
	int i, newNumLines;

	// Extra lines are those with 0 length. Collision detection against
	// one of those could cause a divide by 0, so it's best to remove them.

	for (i = newNumLines = 0; i < NumLines(); ++i)
	{
		if (Vertices[Lines[i].v1].x != Vertices[Lines[i].v2].x ||
			Vertices[Lines[i].v1].y != Vertices[Lines[i].v2].y)
		{
			if (i != newNumLines)
			{
				Lines[newNumLines] = Lines[i];
			}
			++newNumLines;
		}
	}
	if (newNumLines < NumLines())
	{
		int diff = NumLines() - newNumLines;

		printf ("   Removed %d line%s with 0 length.\n", diff, diff > 1 ? "s" : "");
	}
	Lines.Resize(newNumLines);
}

void FLevel::RemoveExtraSides ()
{
	BYTE *used;
	int *remap;
	int i, newNumSides;

	// Extra sides are those that aren't referenced by any lines.
	// They just waste space, so get rid of them.
	int NumSides = this->NumSides();

	used = new BYTE[NumSides];
	memset (used, 0, NumSides*sizeof(*used));
	remap = new int[NumSides];

	// Mark all used sides
	for (i = 0; i < NumLines(); ++i)
	{
		if (Lines[i].sidenum[0] != NO_INDEX)
		{
			used[Lines[i].sidenum[0]] = 1;
		}
		else
		{
			printf ("   Line %d needs a front sidedef before it will run with ZDoom.\n", i);
		}
		if (Lines[i].sidenum[1] != NO_INDEX)
		{
			used[Lines[i].sidenum[1]] = 1;
		}
	}

	// Shift out any unused sides
	for (i = newNumSides = 0; i < NumSides; ++i)
	{
		if (used[i])
		{
			if (i != newNumSides)
			{
				Sides[newNumSides] = Sides[i];
			}
			remap[i] = newNumSides++;
		}
		else
		{
			remap[i] = NO_INDEX;
		}
	}

	if (newNumSides < NumSides)
	{
		int diff = NumSides - newNumSides;

		printf ("   Removed %d unused sidedef%s.\n", diff, diff > 1 ? "s" : "");
		Sides.Resize(newNumSides);

		// Renumber side references in lines
		for (i = 0; i < NumLines(); ++i)
		{
			if (Lines[i].sidenum[0] != NO_INDEX)
			{
				Lines[i].sidenum[0] = remap[Lines[i].sidenum[0]];
			}
			if (Lines[i].sidenum[1] != NO_INDEX)
			{
				Lines[i].sidenum[1] = remap[Lines[i].sidenum[1]];
			}
		}
	}
	delete[] used;
	delete[] remap;
}

void FLevel::RemoveExtraSectors ()
{
	BYTE *used;
	DWORD *remap;
	int i, newNumSectors;

	// Extra sectors are those that aren't referenced by any sides.
	// They just waste space, so get rid of them.

	NumOrgSectors = NumSectors();
	used = new BYTE[NumSectors()];
	memset (used, 0, NumSectors()*sizeof(*used));
	remap = new DWORD[NumSectors()];

	// Mark all used sectors
	for (i = 0; i < NumSides(); ++i)
	{
		if ((DWORD)Sides[i].sector != NO_INDEX)
		{
			used[Sides[i].sector] = 1;
		}
		else
		{
			printf ("   Sidedef %d needs a front sector before it will run with ZDoom.\n", i);
		}
	}

	// Shift out any unused sides
	for (i = newNumSectors = 0; i < NumSectors(); ++i)
	{
		if (used[i])
		{
			if (i != newNumSectors)
			{
				Sectors[newNumSectors] = Sectors[i];
			}
			remap[i] = newNumSectors++;
		}
		else
		{
			remap[i] = NO_INDEX;
		}
	}

	if (newNumSectors < NumSectors())
	{
		int diff = NumSectors() - newNumSectors;
		printf ("   Removed %d unused sector%s.\n", diff, diff > 1 ? "s" : "");

		// Renumber sector references in sides
		for (i = 0; i < NumSides(); ++i)
		{
			if ((DWORD)Sides[i].sector != NO_INDEX)
			{
				Sides[i].sector = remap[Sides[i].sector];
			}
		}
		// Make a reverse map for fixing reject lumps
		OrgSectorMap = new DWORD[newNumSectors];
		for (i = 0; i < NumSectors(); ++i)
		{
			if (remap[i] != NO_INDEX)
			{
				OrgSectorMap[remap[i]] = i;
			}
		}

		Sectors.Resize(newNumSectors);
	}

	delete[] used;
	delete[] remap;
}

void FProcessor::GetPolySpots ()
{
	if (Extended && CheckPolyobjs)
	{
		int spot1, spot2, anchor, i;

		// Determine if this is a Hexen map by looking for things of type 3000
		// Only Hexen maps use them, and they are the polyobject anchors
		for (i = 0; i < Level.NumThings(); ++i)
		{
			if (Level.Things[i].type == PO_HEX_ANCHOR_TYPE)
			{
				break;
			}
		}

		if (i < Level.NumThings())
		{
			spot1 = PO_HEX_SPAWN_TYPE;
			spot2 = PO_HEX_SPAWNCRUSH_TYPE;
			anchor = PO_HEX_ANCHOR_TYPE;
		}
		else
		{
			spot1 = PO_SPAWN_TYPE;
			spot2 = PO_SPAWNCRUSH_TYPE;
			anchor = PO_ANCHOR_TYPE;
		}

		for (i = 0; i < Level.NumThings(); ++i)
		{
			if (Level.Things[i].type == spot1 ||
				Level.Things[i].type == spot2 ||
				Level.Things[i].type == PO_SPAWNHURT_TYPE ||
				Level.Things[i].type == anchor)
			{
				FNodeBuilder::FPolyStart newvert;
				newvert.x = Level.Things[i].x;
				newvert.y = Level.Things[i].y;
				newvert.polynum = Level.Things[i].angle;
				if (Level.Things[i].type == anchor)
				{
					PolyAnchors.Push (newvert);
				}
				else
				{
					PolyStarts.Push (newvert);
				}
			}
		}
	}
}

void FProcessor::Write (FWadWriter &out)
{
	if (Level.NumLines() == 0 || Level.NumSides() == 0 || Level.NumSectors() == 0 || Level.NumVertices == 0)
	{
		if (!isUDMF)
		{
			// Map is empty, so just copy it as-is
			out.CopyLump (Wad, Lump);
			out.CopyLump (Wad, Wad.FindMapLump ("THINGS", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("LINEDEFS", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("SIDEDEFS", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("VERTEXES", Lump));
			out.CreateLabel ("SEGS");
			out.CreateLabel ("SSECTORS");
			out.CreateLabel ("NODES");
			out.CopyLump (Wad, Wad.FindMapLump ("SECTORS", Lump));
			out.CreateLabel ("REJECT");
			out.CreateLabel ("BLOCKMAP");
			if (Extended)
			{
				out.CopyLump (Wad, Wad.FindMapLump ("BEHAVIOR", Lump));
				out.CopyLump (Wad, Wad.FindMapLump ("SCRIPTS", Lump));
			}
		}
		else
		{
			for(int i=Lump; stricmp(Wad.LumpName(i), "ENDMAP") && i < Wad.NumLumps(); i++)
			{
				out.CopyLump(Wad, i);
			}
			out.CreateLabel("ENDMAP");
		}
		return;
	}

	bool compress, compressGL, gl5 = false;

#ifdef BLOCK_TEST
	int size;
	BYTE *blockmap;
	ReadLump<BYTE> (Wad, Wad.FindMapLump ("BLOCKMAP", Lump), blockmap, size);
	if (blockmap)
	{
		FILE *f = fopen ("blockmap.lmp", "wb");
		if (f)
		{
			fwrite (blockmap, 1, size, f);
			fclose (f);
		}
		delete[] blockmap;
	}
#endif

	if (BuildNodes)
	{
		FNodeBuilder *builder = NULL;

		// ZDoom's UDMF spec requires compressed GL nodes.
		// No other UDMF spec has defined anything regarding nodes yet.
		if (isUDMF) 
		{
			BuildGLNodes = true;
			ConformNodes = false;
			GLOnly = true;
			CompressGLNodes = true;
		}
		
		try
		{
			if (HaveSSE2)
			{
				SSELevel = 2;
			}
			else if (HaveSSE1)
			{
				SSELevel = 1;
			}
			else
			{
				SSELevel = 0;
			}
			builder = new FNodeBuilder (Level, PolyStarts, PolyAnchors, Wad.LumpName (Lump), BuildGLNodes);
			if (builder == NULL)
			{
				throw std::runtime_error("   Not enough memory to build nodes!");
			}

			delete[] Level.Vertices;
			builder->GetVertices (Level.Vertices, Level.NumVertices);

			if (ConformNodes)
			{
				// When the nodes are "conformed", the normal and GL nodes use the same
				// basic information. This creates normal nodes that are less "good" than
				// possible, but it makes it easier to compare the two sets of nodes to
				// determine the correctness of the GL nodes.
				builder->GetNodes (Level.Nodes, Level.NumNodes,
					Level.Segs, Level.NumSegs,
					Level.Subsectors, Level.NumSubsectors);
				builder->GetVertices (Level.GLVertices, Level.NumGLVertices);
				builder->GetGLNodes (Level.GLNodes, Level.NumGLNodes,
					Level.GLSegs, Level.NumGLSegs,
					Level.GLSubsectors, Level.NumGLSubsectors);
			}
			else
			{
				if (BuildGLNodes)
				{
					builder->GetVertices (Level.GLVertices, Level.NumGLVertices);
					builder->GetGLNodes (Level.GLNodes, Level.NumGLNodes,
						Level.GLSegs, Level.NumGLSegs,
						Level.GLSubsectors, Level.NumGLSubsectors);

					if (!GLOnly)
					{
						// Now repeat the process to obtain regular nodes
						delete builder;
						builder = new FNodeBuilder (Level, PolyStarts, PolyAnchors, Wad.LumpName (Lump), false);
						if (builder == NULL)
						{
							throw std::runtime_error("   Not enough memory to build regular nodes!");
						}
						delete[] Level.Vertices;
						builder->GetVertices (Level.Vertices, Level.NumVertices);
					}
				}
				if (!GLOnly)
				{
					builder->GetNodes (Level.Nodes, Level.NumNodes,
						Level.Segs, Level.NumSegs,
						Level.Subsectors, Level.NumSubsectors);
				}
			}
			delete builder;
			builder = NULL;
		}
		catch (...)
		{
			if (builder != NULL)
			{
				delete builder;
			}
			throw;
		}
	}

	if (!isUDMF)
	{
		FBlockmapBuilder bbuilder (Level);
		WORD *blocks = bbuilder.GetBlockmap (Level.BlockmapSize);
		Level.Blockmap = new WORD[Level.BlockmapSize];
		memcpy (Level.Blockmap, blocks, Level.BlockmapSize*sizeof(WORD));

		Level.RejectSize = (Level.NumSectors()*Level.NumSectors() + 7) / 8;
		Level.Reject = NULL;

		switch (RejectMode)
		{
		case ERM_Rebuild:
			//FRejectBuilder reject (Level);
			//Level.Reject = reject.GetReject ();
			printf ("   Rebuilding the reject is unsupported.\n");
			// Intentional fall-through

		case ERM_DontTouch:
			{
				int lump = Wad.FindMapLump ("REJECT", Lump);

				if (lump >= 0)
				{
					ReadLump<BYTE> (Wad, lump, Level.Reject, Level.RejectSize);
					if (Level.RejectSize != (Level.NumOrgSectors*Level.NumOrgSectors + 7) / 8)
					{
						// If the reject is the wrong size, don't use it.
						delete[] Level.Reject;
						Level.Reject = NULL;
						if (Level.RejectSize != 0)
						{ // Do not warn about 0-length rejects
							printf ("   REJECT is the wrong size, so it will be removed.\n");
						}
						Level.RejectSize = 0;
					}
					else if (Level.NumOrgSectors != Level.NumSectors())
					{
						// Some sectors have been removed, so fix the reject.
						BYTE *newreject = FixReject (Level.Reject);
						delete[] Level.Reject;
						Level.Reject = newreject;
						Level.RejectSize = (Level.NumSectors() * Level.NumSectors() + 7) / 8;
					}
				}
			}
			break;

		case ERM_Create0:
			break;

		case ERM_CreateZeroes:
			Level.Reject = new BYTE[Level.RejectSize];
			memset (Level.Reject, 0, Level.RejectSize);
			break;
		}
	}

	if (ShowMap)
	{
#ifndef NO_MAP_VIEWER
		if(BuildNodes||BuildGLNodes)
		{
			ShowView (&Level);
		}
		else
		{
			puts("  ERROR: You can't view the nodes (-v) if you don't build them! (-N).");
		}
#else
		puts ("  This version of ZDBSP was not compiled with the map viewer enabled.");
#endif
	}
	
	if (!isUDMF)
	{

		if (Level.GLNodes != NULL )
		{
			gl5 = V5GLNodes ||
				  (Level.NumGLVertices > 32767) ||
				  (Level.NumGLSegs > 65534) ||
				  (Level.NumGLNodes > 32767) ||
				  (Level.NumGLSubsectors > 32767);
			compressGL = CompressGLNodes || (Level.NumVertices > 32767);
		}
		else
		{
			compressGL = false;
		}

		// If the GL nodes are compressed, then the regular nodes must also be compressed.
		compress = CompressNodes || compressGL ||
			(Level.NumVertices > 65535) ||
			(Level.NumSegs > 65535) ||
			(Level.NumSubsectors > 32767) ||
			(Level.NumNodes > 32767);

		out.CopyLump (Wad, Lump);
		out.CopyLump (Wad, Wad.FindMapLump ("THINGS", Lump));
		WriteLines (out);
		WriteSides (out);
		WriteVertices (out, compress || GLOnly ? Level.NumOrgVerts : Level.NumVertices);
		if (BuildNodes)
		{
			if (!compress)
			{
				if (!GLOnly)
				{
					WriteSegs (out);
					WriteSSectors (out);
					WriteNodes (out);
				}
				else
				{
					out.CreateLabel ("SEGS");
					out.CreateLabel ("SSECTORS");
					out.CreateLabel ("NODES");
				}
			}
			else
			{
				out.CreateLabel ("SEGS");
				if (compressGL)
				{
					if (ForceCompression) WriteGLBSPZ (out, "SSECTORS");
					else WriteGLBSPX (out, "SSECTORS");
				}
				else
				{
					out.CreateLabel ("SSECTORS");
				}
				if (!GLOnly)
				{
					if (ForceCompression) WriteBSPZ (out, "NODES");
					else WriteBSPX (out, "NODES");
				}
				else
				{
					out.CreateLabel ("NODES");
				}
			}
		}
		else
		{
			out.CopyLump (Wad, Wad.FindMapLump ("SEGS", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("SSECTORS", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("NODES", Lump));
		}
		WriteSectors (out);
		WriteReject (out);
		WriteBlockmap (out);
		if (Extended)
		{
			out.CopyLump (Wad, Wad.FindMapLump ("BEHAVIOR", Lump));
			out.CopyLump (Wad, Wad.FindMapLump ("SCRIPTS", Lump));
		}
		if (Level.GLNodes != NULL && !compressGL)
		{
			char glname[9];
			glname[0] = 'G';
			glname[1] = 'L';
			glname[2] = '_';
			glname[8] = 0;
			strncpy (glname+3, Wad.LumpName (Lump), 5);
			out.CreateLabel (glname);
			WriteGLVertices (out, gl5);
			WriteGLSegs (out, gl5);
			WriteGLSSect (out, gl5);
			WriteGLNodes (out, gl5);
		}
	}
	else
	{
		WriteUDMF(out);
	}
}

//
BYTE *FProcessor::FixReject (const BYTE *oldreject)
{
	int x, y, ox, oy, pnum, opnum;
	int rejectSize = (Level.NumSectors()*Level.NumSectors() + 7) / 8;
	BYTE *newreject = new BYTE[rejectSize];

	memset (newreject, 0, rejectSize);

	for (y = 0; y < Level.NumSectors(); ++y)
	{
		oy = Level.OrgSectorMap[y];
		for (x = 0; x < Level.NumSectors(); ++x)
		{
			ox = Level.OrgSectorMap[x];
			pnum = y*Level.NumSectors() + x;
			opnum = oy*Level.NumSectors() + ox;

			if (oldreject[opnum >> 3] & (1 << (opnum & 7)))
			{
				newreject[pnum >> 3] |= 1 << (pnum & 7);
			}
		}
	}
	return newreject;
}

MapNodeEx *FProcessor::NodesToEx (const MapNode *nodes, int count)
{
	if (count == 0)
	{
		return NULL;
	}

	MapNodeEx *Nodes = new MapNodeEx[Level.NumNodes];
	int x;

	for (x = 0; x < count; ++x)
	{
		WORD child;
		int i;

		for (i = 0; i < 4+2*4; ++i)
		{
			*((WORD *)&Nodes[x] + i) = LittleShort(*((WORD *)&nodes[x] + i));
		}
		for (i = 0; i < 2; ++i)
		{
			child = LittleShort(nodes[x].children[i]);
			if (child & NF_SUBSECTOR)
			{
				Nodes[x].children[i] = child + (NFX_SUBSECTOR - NF_SUBSECTOR);
			}
			else
			{
				Nodes[x].children[i] = child;
			}
		}
	}
	return Nodes;
}

MapSubsectorEx *FProcessor::SubsectorsToEx (const MapSubsector *ssec, int count)
{
	if (count == 0)
	{
		return NULL;
	}

	MapSubsectorEx *out = new MapSubsectorEx[Level.NumSubsectors];
	int x;

	for (x = 0; x < count; ++x)
	{
		out[x].numlines = LittleShort(ssec[x].numlines);
		out[x].firstline = LittleShort(ssec[x].firstline);
	}
	
	return out;
}

MapSegGLEx *FProcessor::SegGLsToEx (const MapSegGL *segs, int count)
{
	if (count == 0)
	{
		return NULL;
	}

	MapSegGLEx *out = new MapSegGLEx[count];
	int x;

	for (x = 0; x < count; ++x)
	{
		out[x].v1 = LittleShort(segs[x].v1);
		out[x].v2 = LittleShort(segs[x].v2);
		out[x].linedef = LittleShort(segs[x].linedef);
		out[x].side = LittleShort(segs[x].side);
		out[x].partner = LittleShort(segs[x].partner);
	}

	return out;
}

void FProcessor::WriteVertices (FWadWriter &out, int count)
{
	int i;
	WideVertex *vertdata = Level.Vertices;

	short *verts = new short[count * 2];

	for (i = 0; i < count; ++i)
	{
		verts[i*2] = LittleShort(vertdata[i].x >> FRACBITS);
		verts[i*2+1] = LittleShort(vertdata[i].y >> FRACBITS);
	}
	out.WriteLump ("VERTEXES", verts, sizeof(*verts)*count*2);
	delete[] verts;

	if (count >= 32768)
	{
		printf ("   VERTEXES is past the normal limit. (%d vertices)\n", count);
	}
}

void FProcessor::WriteLines (FWadWriter &out)
{
	int i;

	if (Extended)
	{
		MapLineDef2 *Lines = new MapLineDef2[Level.NumLines()];
		for (i = 0; i < Level.NumLines(); ++i)
		{
			Lines[i].special = Level.Lines[i].special;
			Lines[i].args[0] = Level.Lines[i].args[0];
			Lines[i].args[1] = Level.Lines[i].args[1];
			Lines[i].args[2] = Level.Lines[i].args[2];
			Lines[i].args[3] = Level.Lines[i].args[3];
			Lines[i].args[4] = Level.Lines[i].args[4];
			Lines[i].v1 = LittleShort(WORD(Level.Lines[i].v1));
			Lines[i].v2 = LittleShort(WORD(Level.Lines[i].v2));
			Lines[i].flags = LittleShort(WORD(Level.Lines[i].flags));
			Lines[i].sidenum[0] = LittleShort(WORD(Level.Lines[i].sidenum[0]));
			Lines[i].sidenum[1] = LittleShort(WORD(Level.Lines[i].sidenum[1]));
		}
		out.WriteLump ("LINEDEFS", Lines, Level.NumLines()*sizeof(*Lines));
		delete[] Lines;
	}
	else
	{
		MapLineDef *ld = new MapLineDef[Level.NumLines()];

		for (i = 0; i < Level.NumLines(); ++i)
		{
			ld[i].v1 = LittleShort(WORD(Level.Lines[i].v1));
			ld[i].v2 = LittleShort(WORD(Level.Lines[i].v2));
			ld[i].flags = LittleShort(WORD(Level.Lines[i].flags));
			ld[i].sidenum[0] = LittleShort(WORD(Level.Lines[i].sidenum[0]));
			ld[i].sidenum[1] = LittleShort(WORD(Level.Lines[i].sidenum[1]));
			ld[i].special = LittleShort(WORD(Level.Lines[i].args[0]));
			ld[i].tag = LittleShort(WORD(Level.Lines[i].args[1]));
		}
		out.WriteLump ("LINEDEFS", ld, Level.NumLines()*sizeof(*ld));
		delete[] ld;
	}
}

void FProcessor::WriteSides (FWadWriter &out)
{
	int i;
	MapSideDef *Sides = new MapSideDef[Level.NumSides()];

	for (i = 0; i < Level.NumSides(); ++i)
	{
		Sides[i].textureoffset = Level.Sides[i].textureoffset;
		Sides[i].rowoffset = Level.Sides[i].rowoffset;
		memcpy(Sides[i].toptexture, Level.Sides[i].toptexture, 8);
		memcpy(Sides[i].bottomtexture, Level.Sides[i].bottomtexture, 8);
		memcpy(Sides[i].midtexture, Level.Sides[i].midtexture, 8);
		Sides[i].sector = LittleShort(Level.Sides[i].sector);
	}
	out.WriteLump ("SIDEDEFS", Sides, Level.NumSides()*sizeof(*Sides));
	delete[] Sides;
}

void FProcessor::WriteSectors (FWadWriter &out)
{
	int i;
	MapSector *Sectors = new MapSector[Level.NumSectors()];

	for (i = 0; i < Level.NumSectors(); ++i)
	{
		Sectors[i] = Level.Sectors[i].data;
	}

	out.WriteLump ("SECTORS", Sectors, Level.NumSectors()*sizeof(*Sectors));
}

void FProcessor::WriteSegs (FWadWriter &out)
{
	int i;
	MapSeg *segdata;

	assert(Level.NumVertices < 65536);

	segdata = new MapSeg[Level.NumSegs];

	for (i = 0; i < Level.NumSegs; ++i)
	{
		segdata[i].v1 = LittleShort(WORD(Level.Segs[i].v1));
		segdata[i].v2 = LittleShort(WORD(Level.Segs[i].v2));
		segdata[i].angle = LittleShort(Level.Segs[i].angle);
		segdata[i].linedef = LittleShort(Level.Segs[i].linedef);
		segdata[i].side = LittleShort(Level.Segs[i].side);
		segdata[i].offset = LittleShort(Level.Segs[i].offset);
	}
	out.WriteLump ("SEGS", segdata, sizeof(*segdata)*Level.NumSegs);

	if (Level.NumSegs >= 65536)
	{
		printf ("   SEGS is too big for any port. (%d segs)\n", Level.NumSegs);
	}
	else if (Level.NumSegs >= 32768)
	{
		printf ("   SEGS is too big for vanilla Doom and some ports. (%d segs)\n", Level.NumSegs);
	}
}

void FProcessor::WriteSSectors (FWadWriter &out) const
{
	WriteSSectors2 (out, "SSECTORS", Level.Subsectors, Level.NumSubsectors);
}

void FProcessor::WriteSSectors2 (FWadWriter &out, const char *name, const MapSubsectorEx *subs, int count) const
{
	int i;
	MapSubsector *ssec;

	ssec = new MapSubsector[count];

	for (i = 0; i < count; ++i)
	{
		ssec[i].firstline = LittleShort((WORD)subs[i].firstline);
		ssec[i].numlines = LittleShort((WORD)subs[i].numlines);
	}
	out.WriteLump (name, ssec, sizeof(*ssec)*count);
	delete[] ssec;

	if (count >= 65536)
	{
		printf ("   %s is too big. (%d subsectors)\n", name, count);
	}
}

void FProcessor::WriteSSectors5 (FWadWriter &out, const char *name, const MapSubsectorEx *subs, int count) const
{
	int i;
	MapSubsectorEx *ssec;

	ssec = new MapSubsectorEx[count];

	for (i = 0; i < count; ++i)
	{
		ssec[i].firstline = LittleLong(subs[i].firstline);
		ssec[i].numlines = LittleLong(subs[i].numlines);
	}
	out.WriteLump (name, ssec, sizeof(*ssec)*count);
	delete[] ssec;
}

void FProcessor::WriteNodes (FWadWriter &out) const
{
	WriteNodes2 (out, "NODES", Level.Nodes, Level.NumNodes);
}

void FProcessor::WriteNodes2 (FWadWriter &out, const char *name, const MapNodeEx *zaNodes, int count) const
{
	int i, j;
	short *onodes, *nodes;

	nodes = onodes = new short[count * sizeof(MapNode)/2];

	for (i = 0; i < count; ++i)
	{
		nodes[0] = LittleShort(zaNodes[i].x >> 16);
		nodes[1] = LittleShort(zaNodes[i].y >> 16);
		nodes[2] = LittleShort(zaNodes[i].dx >> 16);
		nodes[3] = LittleShort(zaNodes[i].dy >> 16);
		nodes += 4;
		const short *inodes = (short *)&zaNodes[i].bbox[0][0];
		for (j = 0; j < 2*4; ++j)
		{
			nodes[j] = LittleShort(inodes[j]);
		}
		nodes += j;
		for (j = 0; j < 2; ++j)
		{
			DWORD child = zaNodes[i].children[j];
			if (child & NFX_SUBSECTOR)
			{
				*nodes++ = LittleShort(WORD(child - (NFX_SUBSECTOR + NF_SUBSECTOR)));
			}
			else
			{
				*nodes++ = LittleShort((WORD)child);
			}
		}
	}
	out.WriteLump (name, onodes, count * sizeof(MapNode));
	delete[] onodes;

	if (count >= 32768)
	{
		printf ("   %s is too big. (%d nodes)\n", name, count);
	}
}

void FProcessor::WriteNodes5 (FWadWriter &out, const char *name, const MapNodeEx *zaNodes, int count) const
{
	int i, j;
	MapNodeExO *const nodes = new MapNodeExO[count * sizeof(MapNodeEx)];

	for (i = 0; i < count; ++i)
	{
		const short *inodes = &zaNodes[i].bbox[0][0];
		short *coord = &nodes[i].bbox[0][0];
		for (j = 0; j < 2*4; ++j)
		{
			coord[j] = LittleShort(inodes[j]);
		}
		nodes[i].x = LittleShort(zaNodes[i].x >> 16);
		nodes[i].y = LittleShort(zaNodes[i].y >> 16);
		nodes[i].dx = LittleShort(zaNodes[i].dx >> 16);
		nodes[i].dy = LittleShort(zaNodes[i].dy >> 16);
		for (j = 0; j < 2; ++j)
		{
			nodes[i].children[j] = LittleLong(zaNodes[i].children[j]);
		}
	}
	out.WriteLump (name, nodes, count * sizeof(MapNodeEx));
	delete[] nodes;
}

void FProcessor::WriteBlockmap (FWadWriter &out)
{
	if (BlockmapMode == EBM_Create0)
	{
		out.CreateLabel ("BLOCKMAP");
		return;
	}

	size_t i, count;
	WORD *blocks;

	count = Level.BlockmapSize;
	blocks = Level.Blockmap;

	for (i = 0; i < count; ++i)
	{
		blocks[i] = LittleShort(blocks[i]);
	}
	out.WriteLump ("BLOCKMAP", blocks, int(sizeof(*blocks)*count));

#ifdef BLOCK_TEST
	FILE *f = fopen ("blockmap.lm2", "wb");
	if (f)
	{
		fwrite (blocks, count, sizeof(*blocks), f);
		fclose (f);
	}
#endif

	for (i = 0; i < count; ++i)
	{
		blocks[i] = LittleShort(blocks[i]);
	}

	if (count >= 65536)
	{
		printf ("   BLOCKMAP is so big that ports will have to recreate it.\n"
				"   Vanilla Doom cannot handle it at all. If this map is for ZDoom 2+,\n"
				"   you should use the -b switch to save space in the wad.\n");
	}
	else if (count >= 32768)
	{
		printf ("   BLOCKMAP is too big for vanilla Doom.\n");
	}
}

void FProcessor::WriteReject (FWadWriter &out)
{
	if (RejectMode == ERM_Create0 || Level.Reject == NULL)
	{
		out.CreateLabel ("REJECT");
	}
	else
	{
		out.WriteLump ("REJECT", Level.Reject, Level.RejectSize);
	}
}

void FProcessor::WriteGLVertices (FWadWriter &out, bool v5)
{
	int i, count = (Level.NumGLVertices - Level.NumOrgVerts);
	WideVertex *vertdata = Level.GLVertices + Level.NumOrgVerts;

	fixed_t *verts = new fixed_t[count*2+1];
	char *magic = (char *)verts;
	magic[0] = 'g';
	magic[1] = 'N';
	magic[2] = 'd';
	magic[3] = v5 ? '5' : '2';

	for (i = 0; i < count; ++i)
	{
		verts[i*2+1] = LittleShort(vertdata[i].x);
		verts[i*2+2] = LittleShort(vertdata[i].y);
	}
	out.WriteLump ("GL_VERT", verts, sizeof(*verts)*(count*2+1));
	delete[] verts;

	if (count > 65536)
	{
		printf ("   GL_VERT is too big. (%d GL vertices)\n", count/2);
	}
}

void FProcessor::WriteGLSegs (FWadWriter &out, bool v5)
{
	if (v5)
	{
		WriteGLSegs5 (out);
		return;
	}
	int i, count;
	MapSegGL *segdata;

	count = Level.NumGLSegs;
	segdata = new MapSegGL[count];

	for (i = 0; i < count; ++i)
	{
		if (Level.GLSegs[i].v1 < (DWORD)Level.NumOrgVerts)
		{
			segdata[i].v1 = LittleShort((WORD)Level.GLSegs[i].v1);
		}
		else
		{
			segdata[i].v1 = LittleShort(0x8000 | (WORD)(Level.GLSegs[i].v1 - Level.NumOrgVerts));
		}
		if (Level.GLSegs[i].v2 < (DWORD)Level.NumOrgVerts)
		{
			segdata[i].v2 = (WORD)LittleShort(Level.GLSegs[i].v2);
		}
		else
		{
			segdata[i].v2 = LittleShort(0x8000 | (WORD)(Level.GLSegs[i].v2 - Level.NumOrgVerts));
		}
		segdata[i].linedef = LittleShort((WORD)Level.GLSegs[i].linedef);
		segdata[i].side = LittleShort(Level.GLSegs[i].side);
		segdata[i].partner = LittleShort((WORD)Level.GLSegs[i].partner);
	}
	out.WriteLump ("GL_SEGS", segdata, sizeof(MapSegGL)*count);
	delete[] segdata;

	if (count >= 65536)
	{
		printf ("   GL_SEGS is too big for any port. (%d GL segs)\n", count);
	}
	else if (count >= 32768)
	{
		printf ("   GL_SEGS is too big for some ports. (%d GL segs)\n", count);
	}
}

void FProcessor::WriteGLSegs5 (FWadWriter &out)
{
	int i, count;
	MapSegGLEx *segdata;

	count = Level.NumGLSegs;
	segdata = new MapSegGLEx[count];

	for (i = 0; i < count; ++i)
	{
		if (Level.GLSegs[i].v1 < (DWORD)Level.NumOrgVerts)
		{
			segdata[i].v1 = LittleLong(Level.GLSegs[i].v1);
		}
		else
		{
			segdata[i].v1 = LittleLong(0x80000000u | ((int)Level.GLSegs[i].v1 - Level.NumOrgVerts));
		}
		if (Level.GLSegs[i].v2 < (DWORD)Level.NumOrgVerts)
		{
			segdata[i].v2 = LittleLong(Level.GLSegs[i].v2);
		}
		else
		{
			segdata[i].v2 = LittleLong(0x80000000u | ((int)Level.GLSegs[i].v2 - Level.NumOrgVerts));
		}
		segdata[i].linedef = LittleShort(Level.GLSegs[i].linedef);
		segdata[i].side = LittleShort(Level.GLSegs[i].side);
		segdata[i].partner = LittleLong(Level.GLSegs[i].partner);
	}
	out.WriteLump ("GL_SEGS", segdata, sizeof(MapSegGLEx)*count);
	delete[] segdata;
}

void FProcessor::WriteGLSSect (FWadWriter &out, bool v5)
{
	if (!v5)
	{
		WriteSSectors2 (out, "GL_SSECT", Level.GLSubsectors, Level.NumGLSubsectors);
	}
	else
	{
		WriteSSectors5 (out, "GL_SSECT", Level.GLSubsectors, Level.NumGLSubsectors);
	}
}

void FProcessor::WriteGLNodes (FWadWriter &out, bool v5)
{
	if (!v5)
	{
		WriteNodes2 (out, "GL_NODES", Level.GLNodes, Level.NumGLNodes);
	}
	else
	{
		WriteNodes5 (out, "GL_NODES", Level.GLNodes, Level.NumGLNodes);
	}
}

void FProcessor::WriteBSPZ (FWadWriter &out, const char *label)
{
	ZLibOut zout (out);

	if (!CompressNodes)
	{
		printf ("   Nodes are so big that compression has been forced.\n");
	}

	out.StartWritingLump (label);
	out.AddToLump ("ZNOD", 4);
	WriteVerticesZ (zout, &Level.Vertices[Level.NumOrgVerts], Level.NumOrgVerts, Level.NumVertices - Level.NumOrgVerts);
	WriteSubsectorsZ (zout, Level.Subsectors, Level.NumSubsectors);
	WriteSegsZ (zout, Level.Segs, Level.NumSegs);
	WriteNodesZ (zout, Level.Nodes, Level.NumNodes, 1);
}

void FProcessor::WriteGLBSPZ (FWadWriter &out, const char *label)
{
	ZLibOut zout (out);
	bool fracsplitters = CheckForFracSplitters(Level.GLNodes, Level.NumGLNodes);
	int nodever;

	if (!CompressGLNodes)
	{
		printf ("   GL Nodes are so big that compression has been forced.\n");
	}

	out.StartWritingLump (label);
	if (fracsplitters)
	{
		out.AddToLump ("ZGL3", 4);
		nodever = 3;
	}
	else if (Level.NumLines() < 65535)
	{
		out.AddToLump ("ZGLN", 4);
		nodever = 1;
	}
	else
	{
		out.AddToLump ("ZGL2", 4);
		nodever = 2;
	}
	WriteVerticesZ (zout, &Level.GLVertices[Level.NumOrgVerts], Level.NumOrgVerts, Level.NumGLVertices - Level.NumOrgVerts);
	WriteSubsectorsZ (zout, Level.GLSubsectors, Level.NumGLSubsectors);
	WriteGLSegsZ (zout, Level.GLSegs, Level.NumGLSegs, nodever);
	WriteNodesZ (zout, Level.GLNodes, Level.NumGLNodes, nodever);
}

void FProcessor::WriteVerticesZ (ZLibOut &out, const WideVertex *verts, int orgverts, int newverts)
{
	out << (DWORD)orgverts << (DWORD)newverts;

	for (int i = 0; i < newverts; ++i)
	{
		out << verts[i].x << verts[i].y;
	}
}

void FProcessor::WriteSubsectorsZ (ZLibOut &out, const MapSubsectorEx *subs, int numsubs)
{
	out << (DWORD)numsubs;

	for (int i = 0; i < numsubs; ++i)
	{
		out << (DWORD)subs[i].numlines;
	}
}

void FProcessor::WriteSegsZ (ZLibOut &out, const MapSegEx *segs, int numsegs)
{
	out << (DWORD)numsegs;

	for (int i = 0; i < numsegs; ++i)
	{
		out << (DWORD)segs[i].v1
			<< (DWORD)segs[i].v2
			<< (WORD)segs[i].linedef
			<< (BYTE)segs[i].side;
	}
}

void FProcessor::WriteGLSegsZ (ZLibOut &out, const MapSegGLEx *segs, int numsegs, int nodever)
{
	out << (DWORD)numsegs;

	if (nodever < 2)
	{
		for (int i = 0; i < numsegs; ++i)
		{
			out << (DWORD)segs[i].v1
				<< (DWORD)segs[i].partner
				<< (WORD)segs[i].linedef
				<< (BYTE)segs[i].side;
		}
	}
	else
	{
		for (int i = 0; i < numsegs; ++i)
		{
			out << (DWORD)segs[i].v1
				<< (DWORD)segs[i].partner
				<< (DWORD)segs[i].linedef
				<< (BYTE)segs[i].side;
		}
	}
}

void FProcessor::WriteNodesZ (ZLibOut &out, const MapNodeEx *nodes, int numnodes, int nodever)
{
	out << (DWORD)numnodes;

	for (int i = 0; i < numnodes; ++i)
	{
		if (nodever < 3)
		{
			out << (SWORD)(nodes[i].x >> 16)
				<< (SWORD)(nodes[i].y >> 16)
				<< (SWORD)(nodes[i].dx >> 16)
				<< (SWORD)(nodes[i].dy >> 16);
		}
		else
		{
			out << (DWORD)nodes[i].x
				<< (DWORD)nodes[i].y
				<< (DWORD)nodes[i].dx
				<< (DWORD)nodes[i].dy;
		}
		for (int j = 0; j < 2; ++j)
		{
			for (int k = 0; k < 4; ++k)
			{
				out << (SWORD)nodes[i].bbox[j][k];
			}
		}
		out << (DWORD)nodes[i].children[0]
			<< (DWORD)nodes[i].children[1];
	}
}

void FProcessor::WriteBSPX (FWadWriter &out, const char *label)
{
	if (!CompressNodes)
	{
		printf ("   Nodes are so big that extended format has been forced.\n");
	}

	out.StartWritingLump (label);
	out.AddToLump ("XNOD", 4);
	WriteVerticesX (out, &Level.Vertices[Level.NumOrgVerts], Level.NumOrgVerts, Level.NumVertices - Level.NumOrgVerts);
	WriteSubsectorsX (out, Level.Subsectors, Level.NumSubsectors);
	WriteSegsX (out, Level.Segs, Level.NumSegs);
	WriteNodesX (out, Level.Nodes, Level.NumNodes, 1);
}

void FProcessor::WriteGLBSPX (FWadWriter &out, const char *label)
{
	bool fracsplitters = CheckForFracSplitters(Level.GLNodes, Level.NumGLNodes);
	int nodever;

	if (!CompressGLNodes)
	{
		printf ("   GL Nodes are so big that extended format has been forced.\n");
	}

	out.StartWritingLump (label);
	if (fracsplitters)
	{
		out.AddToLump ("XGL3", 4);
		nodever = 3;
	}
	else if (Level.NumLines() < 65535)
	{
		out.AddToLump ("XGLN", 4);
		nodever = 1;
	}
	else
	{
		out.AddToLump ("XGL2", 4);
		nodever = 2;
	}
	WriteVerticesX (out, &Level.GLVertices[Level.NumOrgVerts], Level.NumOrgVerts, Level.NumGLVertices - Level.NumOrgVerts);
	WriteSubsectorsX (out, Level.GLSubsectors, Level.NumGLSubsectors);
	WriteGLSegsX (out, Level.GLSegs, Level.NumGLSegs, nodever);
	WriteNodesX (out, Level.GLNodes, Level.NumGLNodes, nodever);
}

void FProcessor::WriteVerticesX (FWadWriter &out, const WideVertex *verts, int orgverts, int newverts)
{
	out << (DWORD)orgverts << (DWORD)newverts;

	for (int i = 0; i < newverts; ++i)
	{
		out << verts[i].x << verts[i].y;
	}
}

void FProcessor::WriteSubsectorsX (FWadWriter &out, const MapSubsectorEx *subs, int numsubs)
{
	out << (DWORD)numsubs;

	for (int i = 0; i < numsubs; ++i)
	{
		out << (DWORD)subs[i].numlines;
	}
}

void FProcessor::WriteSegsX (FWadWriter &out, const MapSegEx *segs, int numsegs)
{
	out << (DWORD)numsegs;

	for (int i = 0; i < numsegs; ++i)
	{
		out << (DWORD)segs[i].v1
			<< (DWORD)segs[i].v2
			<< (WORD)segs[i].linedef
			<< (BYTE)segs[i].side;
	}
}

void FProcessor::WriteGLSegsX (FWadWriter &out, const MapSegGLEx *segs, int numsegs, int nodever)
{
	out << (DWORD)numsegs;

	if (nodever < 2)
	{
		for (int i = 0; i < numsegs; ++i)
		{
			out << (DWORD)segs[i].v1
				<< (DWORD)segs[i].partner
				<< (WORD)segs[i].linedef
				<< (BYTE)segs[i].side;
		}
	}
	else
	{
		for (int i = 0; i < numsegs; ++i)
		{
			out << (DWORD)segs[i].v1
				<< (DWORD)segs[i].partner
				<< (DWORD)segs[i].linedef
				<< (BYTE)segs[i].side;
		}
	}
}

void FProcessor::WriteNodesX (FWadWriter &out, const MapNodeEx *nodes, int numnodes, int nodever)
{
	out << (DWORD)numnodes;

	for (int i = 0; i < numnodes; ++i)
	{
		if (nodever < 3)
		{
			out << (SWORD)(nodes[i].x >> 16)
				<< (SWORD)(nodes[i].y >> 16)
				<< (SWORD)(nodes[i].dx >> 16)
				<< (SWORD)(nodes[i].dy >> 16);
		}
		else
		{
			out << (DWORD)nodes[i].x
				<< (DWORD)nodes[i].y
				<< (DWORD)nodes[i].dx
				<< (DWORD)nodes[i].dy;
		}
		for (int j = 0; j < 2; ++j)
		{
			for (int k = 0; k < 4; ++k)
			{
				out << (SWORD)nodes[i].bbox[j][k];
			}
		}
		out << (DWORD)nodes[i].children[0]
			<< (DWORD)nodes[i].children[1];
	}
}

bool FProcessor::CheckForFracSplitters(const MapNodeEx *nodes, int numnodes)
{
	for (int i = 0; i < numnodes; ++i)
	{
		if (0 != ((nodes[i].x | nodes[i].y | nodes[i].dx | nodes[i].dy) & 0x0000FFFF))
		{
			return true;
		}
	}
	return false;
}

// zlib lump writer ---------------------------------------------------------

ZLibOut::ZLibOut (FWadWriter &out)
	: Out (out)
{
	int err;

	Stream.next_in = Z_NULL;
	Stream.avail_in = 0;
	Stream.zalloc = Z_NULL;
	Stream.zfree = Z_NULL;
	err = deflateInit (&Stream, 9);

	if (err != Z_OK)
	{
		throw std::runtime_error("Could not initialize deflate buffer.");
	}

	Stream.next_out = Buffer;
	Stream.avail_out = BUFFER_SIZE;
}

ZLibOut::~ZLibOut ()
{
	int err;

	for (;;)
	{
		err = deflate (&Stream, Z_FINISH);
		if (err != Z_OK)
		{
			break;
		}
		if (Stream.avail_out == 0)
		{
			Out.AddToLump (Buffer, BUFFER_SIZE);
			Stream.next_out = Buffer;
			Stream.avail_out = BUFFER_SIZE;
		}
	}
	deflateEnd (&Stream);
	if (err != Z_STREAM_END)
	{
		throw std::runtime_error("Error deflating data.");
	}
	Out.AddToLump (Buffer, BUFFER_SIZE - Stream.avail_out);
}

void ZLibOut::Write (BYTE *data, int len)
{
	int err;

	Stream.next_in = data;
	Stream.avail_in = len;
	err = deflate (&Stream, 0);
	while (Stream.avail_out == 0 && err == Z_OK)
	{
		Out.AddToLump (Buffer, BUFFER_SIZE);
		Stream.next_out = Buffer;
		Stream.avail_out = BUFFER_SIZE;
		if (Stream.avail_in != 0)
		{
			err = deflate (&Stream, 0);
		}
	}
	if (err != Z_OK)
	{
		throw std::runtime_error("Error deflating data.");
	}
}

ZLibOut &ZLibOut::operator << (BYTE val)
{
	Write (&val, 1);
	return *this;
}

ZLibOut &ZLibOut::operator << (WORD val)
{
	val = LittleShort(val);
	Write ((BYTE *)&val, 2);
	return *this;
}

ZLibOut &ZLibOut::operator << (SWORD val)
{
	val = LittleShort(val);
	Write ((BYTE *)&val, 2);
	return *this;
}

ZLibOut &ZLibOut::operator << (DWORD val)
{
	val = LittleLong(val);
	Write ((BYTE *)&val, 4);
	return *this;
}

ZLibOut &ZLibOut::operator << (fixed_t val)
{
	val = LittleLong(val);
	Write ((BYTE *)&val, 4);
	return *this;
}
