#ifndef __PROCESSOR_H__
#define __PROCESSOR_H__

#ifdef _MSC_VER
#pragma once
#endif

#include "wad.h"
#include "doomdata.h"
#include "workdata.h"
#include "tarray.h"
#include "nodebuild.h"
#include "blockmapbuilder.h"
#include <zlib.h>

class ZLibOut
{
public:
	ZLibOut (FWadWriter &out);
	~ZLibOut ();

	ZLibOut &operator << (BYTE);
	ZLibOut &operator << (WORD);
	ZLibOut &operator << (SWORD);
	ZLibOut &operator << (DWORD);
	ZLibOut &operator << (fixed_t);
	void Write (BYTE *data, int len);

private:
	enum { BUFFER_SIZE = 8192 };

	z_stream Stream;
	BYTE Buffer[BUFFER_SIZE];

	FWadWriter &Out;
};

class FProcessor
{
public:
	FProcessor (FWadReader &inwad, int lump);

	void Write (FWadWriter &out);

private:
	void LoadUDMF();
	void LoadThings ();
	void LoadLines ();
	void LoadVertices ();
	void LoadSides ();
	void LoadSectors ();
	void GetPolySpots ();

	MapNodeEx *NodesToEx (const MapNode *nodes, int count);
	MapSubsectorEx *SubsectorsToEx (const MapSubsector *ssec, int count);
	MapSegGLEx *SegGLsToEx (const MapSegGL *segs, int count);

	BYTE *FixReject (const BYTE *oldreject);
	bool CheckForFracSplitters(const MapNodeEx *nodes, int count);

	void WriteLines (FWadWriter &out);
	void WriteVertices (FWadWriter &out, int count);
	void WriteSectors (FWadWriter &out);
	void WriteSides (FWadWriter &out);
	void WriteSegs (FWadWriter &out);
	void WriteSSectors (FWadWriter &out) const;
	void WriteNodes (FWadWriter &out) const;
	void WriteBlockmap (FWadWriter &out);
	void WriteReject (FWadWriter &out);

	void WriteGLVertices (FWadWriter &out, bool v5);
	void WriteGLSegs (FWadWriter &out, bool v5);
	void WriteGLSegs5 (FWadWriter &out);
	void WriteGLSSect (FWadWriter &out, bool v5);
	void WriteGLNodes (FWadWriter &out, bool v5);

	void WriteBSPZ (FWadWriter &out, const char *label);
	void WriteGLBSPZ (FWadWriter &out, const char *label);

	void WriteVerticesZ (ZLibOut &out, const WideVertex *verts, int orgverts, int newverts);
	void WriteSubsectorsZ (ZLibOut &out, const MapSubsectorEx *subs, int numsubs);
	void WriteSegsZ (ZLibOut &out, const MapSegEx *segs, int numsegs);
	void WriteGLSegsZ (ZLibOut &out, const MapSegGLEx *segs, int numsegs, int nodever);
	void WriteNodesZ (ZLibOut &out, const MapNodeEx *nodes, int numnodes, int nodever);

	void WriteBSPX (FWadWriter &out, const char *label);
	void WriteGLBSPX (FWadWriter &out, const char *label);

	void WriteVerticesX (FWadWriter &out, const WideVertex *verts, int orgverts, int newverts);
	void WriteSubsectorsX (FWadWriter &out, const MapSubsectorEx *subs, int numsubs);
	void WriteSegsX (FWadWriter &out, const MapSegEx *segs, int numsegs);
	void WriteGLSegsX (FWadWriter &out, const MapSegGLEx *segs, int numsegs, int nodever);
	void WriteNodesX (FWadWriter &out, const MapNodeEx *nodes, int numnodes, int nodever);

	void WriteNodes2 (FWadWriter &out, const char *name, const MapNodeEx *zaNodes, int count) const;
	void WriteSSectors2 (FWadWriter &out, const char *name, const MapSubsectorEx *zaSubs, int count) const;
	void WriteNodes5 (FWadWriter &out, const char *name, const MapNodeEx *zaNodes, int count) const;
	void WriteSSectors5 (FWadWriter &out, const char *name, const MapSubsectorEx *zaSubs, int count) const;

	const char *ParseKey(const char *&value);
	bool CheckKey(const char *&key, const char *&value);
	void ParseThing(IntThing *th);
	void ParseLinedef(IntLineDef *ld);
	void ParseSidedef(IntSideDef *sd);
	void ParseSector(IntSector *sec);
	void ParseVertex(WideVertex *vt, IntVertex *vtp);
	void ParseMapProperties();
	void ParseTextMap(int lump);

	void WriteProps(FWadWriter &out, TArray<UDMFKey> &props);
	void WriteIntProp(FWadWriter &out, const char *key, int value);
	void WriteThingUDMF(FWadWriter &out, IntThing *th, int num);
	void WriteLinedefUDMF(FWadWriter &out, IntLineDef *ld, int num);
	void WriteSidedefUDMF(FWadWriter &out, IntSideDef *sd, int num);
	void WriteSectorUDMF(FWadWriter &out, IntSector *sec, int num);
	void WriteVertexUDMF(FWadWriter &out, IntVertex *vt, int num);
	void WriteTextMap(FWadWriter &out);
	void WriteUDMF(FWadWriter &out);

	FLevel Level;

	TArray<FNodeBuilder::FPolyStart> PolyStarts;
	TArray<FNodeBuilder::FPolyStart> PolyAnchors;

	bool Extended;
	bool isUDMF;

	FWadReader &Wad;
	int Lump;
};

#endif //__PROCESSOR_H__
