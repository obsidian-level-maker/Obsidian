#ifndef __DOOMDATA_H__
#define __DOOMDATA_H__

#ifdef _MSC_VER
#pragma once
#endif

#include "tarray.h"

enum
{
	BOXTOP, BOXBOTTOM, BOXLEFT, BOXRIGHT
};

struct UDMFKey
{
	const char *key;
	const char *value;
};

struct MapVertex
{
	short x, y;
};

struct WideVertex
{
	fixed_t x, y;
	int index;
};

struct MapSideDef
{
	short	textureoffset;
	short	rowoffset;
	char	toptexture[8];
	char	bottomtexture[8];
	char	midtexture[8];
	WORD	sector;
};

struct IntSideDef
{
	// the first 5 values are only used for binary format maps
	short	textureoffset;
	short	rowoffset;
	char	toptexture[8];
	char	bottomtexture[8];
	char	midtexture[8];

	int sector;

	TArray<UDMFKey> props;
};

struct MapLineDef
{
	WORD	v1;
	WORD	v2;
	short	flags;
	short	special;
	short	tag;
	WORD	sidenum[2];
};

struct MapLineDef2
{
	WORD	v1;
	WORD	v2;
	short	flags;
	unsigned char	special;
	unsigned char	args[5];
	WORD	sidenum[2];
};

struct IntLineDef
{
	DWORD v1;
	DWORD v2;
	int flags;
	int special;
	int args[5];
	DWORD sidenum[2];

	TArray<UDMFKey> props;
};

struct MapSector
{
	short	floorheight;
	short	ceilingheight;
	char	floorpic[8];
	char	ceilingpic[8];
	short	lightlevel;
	short	special;
	short	tag;
};

struct IntSector
{
	// none of the sector properties are used by the node builder
	// so there's no need to store them in their expanded form for
	// UDMF. Just storing the UDMF keys and leaving the binary fields
	// empty is enough
	MapSector data;

	TArray<UDMFKey> props;
};

struct MapSubsector
{
	WORD	numlines;
	WORD	firstline;
};

struct MapSubsectorEx
{
	DWORD	numlines;
	DWORD	firstline;
};

struct MapSeg
{
	WORD	v1;
	WORD	v2;
	WORD	angle;
	WORD	linedef;
	short	side;
	short	offset;
};

struct MapSegEx
{
	DWORD	v1;
	DWORD	v2;
	WORD	angle;
	WORD	linedef;
	short	side;
	short	offset;
};

struct MapSegGL
{
	WORD	v1;
	WORD	v2;
	WORD	linedef;
	WORD	side;
	WORD	partner;
};

struct MapSegGLEx
{
	DWORD	v1;
	DWORD	v2;
	DWORD	linedef;
	WORD	side;
	DWORD	partner;
};

#define NF_SUBSECTOR	0x8000
#define NFX_SUBSECTOR	0x80000000

struct MapNode
{
	short 	x,y,dx,dy;
	short 	bbox[2][4];
	WORD	children[2];
};

struct MapNodeExO
{
	short	x,y,dx,dy;
	short	bbox[2][4];
	DWORD	children[2];
};

struct MapNodeEx
{
	int		x,y,dx,dy;
	short	bbox[2][4];
	DWORD	children[2];
};

struct MapThing
{
	short		x;
	short		y;
	short		angle;
	short		type;
	short		flags;
};

struct MapThing2
{
	unsigned short thingid;
	short		x;
	short		y;
	short		z;
	short		angle;
	short		type;
	short		flags;
	char		special;
	char		args[5];
};

struct IntThing
{
	unsigned short thingid;
	fixed_t		x;	// full precision coordinates for UDMF support
	fixed_t		y;
	// everything else is not needed or has no extended form in UDMF
	short		z;
	short		angle;
	short		type;
	short		flags;
	char		special;
	char		args[5];

	TArray<UDMFKey> props;
};

struct IntVertex
{
	TArray<UDMFKey> props;
};

struct FLevel
{
	FLevel ();
	~FLevel ();

	WideVertex *Vertices;		int NumVertices;
	TArray<IntVertex>			VertexProps;
	TArray<IntSideDef>			Sides;
	TArray<IntLineDef>			Lines;
	TArray<IntSector>			Sectors;
	TArray<IntThing>			Things;
	MapSubsectorEx *Subsectors;	int NumSubsectors;
	MapSegEx *Segs;				int NumSegs;
	MapNodeEx *Nodes;			int NumNodes;
	WORD *Blockmap;				int BlockmapSize;
	BYTE *Reject;				int RejectSize;

	MapSubsectorEx *GLSubsectors;	int NumGLSubsectors;
	MapSegGLEx *GLSegs;				int NumGLSegs;
	MapNodeEx *GLNodes;				int NumGLNodes;
	WideVertex *GLVertices;			int NumGLVertices;
	BYTE *GLPVS;					int GLPVSSize;

	int NumOrgVerts;

	DWORD *OrgSectorMap;			int NumOrgSectors;

	fixed_t MinX, MinY, MaxX, MaxY;

	TArray<UDMFKey> props;

	void FindMapBounds ();
	void RemoveExtraLines ();
	void RemoveExtraSides ();
	void RemoveExtraSectors ();

	int NumSides() const { return Sides.Size(); }
	int NumLines() const { return Lines.Size(); }
	int NumSectors() const { return Sectors.Size(); }
	int NumThings() const { return Things.Size(); }
};

const int BLOCKSIZE = 128;
const int BLOCKFRACSIZE = BLOCKSIZE<<FRACBITS;
const int BLOCKBITS = 7;
const int BLOCKFRACBITS = FRACBITS+7;

#endif //__DOOMDATA_H__
