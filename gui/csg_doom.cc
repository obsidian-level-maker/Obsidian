//------------------------------------------------------------------------
//  CSG : DOOM and HEXEN output
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"  // ui_build.h

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "ui_chooser.h"

#include "csg_main.h"
#include "csg_local.h"

#include "dm_extra.h"
#include "g_doom.h"



// Properties
int solid_exfloor;    // disabled if <= 0
int liquid_exfloor;


static int extrafloor_tag;
static int extrafloor_slot;

static int map_bound_y1;


#define SEC_IS_SKY       (0x1 << 16)
#define SEC_PRIMARY_LIT  (0x2 << 16)
#define SEC_SHADOW       (0x4 << 16)


double light_dist_factor = 800.0;

bool smoother_lighting = false;


class doom_sector_c;
class doom_linedef_c;


class extrafloor_c
{
public:
  // dummy sector
  doom_sector_c * dummy_sec;

  std::string w_tex;

  std::vector<doom_sector_c *> users;

public:
  extrafloor_c() : dummy_sec(NULL), w_tex(), users()
  { }

  ~extrafloor_c()
  { } 

  bool Match(const extrafloor_c *other) const;
};


class doom_sector_c 
{
public:
  int f_h;
  int c_h;

  std::string f_tex;
  std::string c_tex;
  
  int light;
  int special;
  int tag;
  int mark;

  std::vector<extrafloor_c *> exfloors;

  int index;

  region_c *region;

  double mid_x, mid_y;  // invalid after DM_CoalesceSectors

  int misc_flags;
  int valid_count;

  bool unused;

public:
  doom_sector_c() : f_h(0), c_h(0), f_tex(), c_tex(),
                    light(64+80), //!!!!!
                    special(0), tag(0), mark(0),
                    exfloors(), index(-1),
                    region(NULL), misc_flags(0), valid_count(0),
                    unused(false)
  { }

  ~doom_sector_c()
  { }

  void MarkUnused()
  {
    unused = true;
  }

  bool isUnused() const
  {
    return unused;
  }

  bool SameExtraFloors(const doom_sector_c *other) const
  {
    if (exfloors.size() != other->exfloors.size())
      return false;

    for (unsigned int i = 0; i < exfloors.size(); i++)
    {
      extrafloor_c *E1 = exfloors[i];
      extrafloor_c *E2 = other->exfloors[i];

      if (E1 == E2)
        continue;

      if (! E1->Match(E2))
        return false;
    }

    return true;
  }

  bool Match(const doom_sector_c *other) const
  {
    // deliberately absent: misc_flags

    return (f_h == other->f_h) &&
           (c_h == other->c_h) &&
           (light == other->light) &&
           (special == other->special) &&
           (tag  == other->tag)  &&
           (mark == other->mark) &&
           (strcmp(f_tex.c_str(), other->f_tex.c_str()) == 0) &&
           (strcmp(c_tex.c_str(), other->c_tex.c_str()) == 0) &&
           SameExtraFloors(other);
  }

  int Write();
};


bool extrafloor_c::Match(const extrafloor_c *other) const
{
  if (strcmp(w_tex.c_str(), other->w_tex.c_str()) != 0)
    return false;

  SYS_ASSERT(dummy_sec && other->dummy_sec);

  return dummy_sec->Match(other->dummy_sec);
}


class doom_vertex_c 
{
public:
  int x, y;

  int index;

  // keep track of a few (but not all) linedefs touching this vertex.
  // this is used to detect colinear lines which can be merged.
  // (later it may be used for horizontal texture alignment)
  doom_linedef_c *lines[4];
 
public:
  doom_vertex_c() : x(0), y(0), index(-1)
  {
    lines[0] = lines[1] = lines[2] = lines[3] = NULL;
  }

  doom_vertex_c(int _x, int _y) : x(_x), y(_y), index(-1)
  {
    lines[0] = lines[1] = lines[2] = lines[3] = NULL;
  }

  ~doom_vertex_c()
  { }

  void AddLine(doom_linedef_c *L)
  {
    for (int i=0; i < 4; i++)
      if (! lines[i])
      {
        lines[i] = L; return;
      }
  }

  void ReplaceLine(doom_linedef_c *old_L, doom_linedef_c *new_L)
  {
    for (int i=0; i < 4; i++)
      if (lines[i] == old_L)
      {
        lines[i] = new_L;
        return;
      }
  }

  bool HasLine(const doom_linedef_c *L) const
  {
    for (int i=0; i < 4; i++)
      if (lines[i] == L)
        return true;

    return false;
  }

  doom_linedef_c *SecondLine(const doom_linedef_c *L) const
  {
    if (lines[2])  // three or more lines?
      return NULL;

    if (! lines[1])  // only one line?
      return NULL;

    if (lines[0] == L)
      return lines[1];

    SYS_ASSERT(lines[1] == L);
    return lines[0];
  }

  int Write();
};


class doom_sidedef_c 
{
public:
  std::string lower;
  std::string mid;
  std::string upper;

  int x_offset;
  int y_offset;

  doom_sector_c * sector;

  int index;
 
public:
  doom_sidedef_c() : lower("-"), mid("-"), upper("-"),
                     x_offset(0), y_offset(0),
                     sector(NULL), index(-1)
  { }

  ~doom_sidedef_c()
  { }

  int Write();

  inline bool SameTex(const doom_sidedef_c *T) const
  {
    return (strcmp(mid  .c_str(), T->mid  .c_str()) == 0) &&
           (strcmp(lower.c_str(), T->lower.c_str()) == 0) &&
           (strcmp(upper.c_str(), T->upper.c_str()) == 0);
  }
};


class doom_linedef_c 
{
public:
  doom_vertex_c *start;  // NULL means "unused linedef"
  doom_vertex_c *end;

  doom_sidedef_c *front;
  doom_sidedef_c *back;

  int flags;
  int type;   // 'special' in Hexen format
  int tag;

  u8_t args[5];

  double length;

  // similar linedef touching our start (end) vertex, or NULL if none.
  // only takes front sidedefs into account.
  // used for texture aligning.
  doom_linedef_c *sim_prev;
  doom_linedef_c *sim_next;

public:
  doom_linedef_c() : start(NULL), end(NULL),
                     front(NULL), back(NULL),
                     flags(0), type(0), tag(0), length(0),
                     sim_prev(NULL), sim_next(NULL)
  {
    args[0] = args[1] = args[2] = args[3] = args[4] = 0;
  }

  ~doom_linedef_c()
  { }

  void CalcLength()
  {
    length = ComputeDist(start->x, start->y, end->x, end->y);
  }

  inline doom_vertex_c *OtherVertex(const doom_vertex_c *V) const
  {
    if (start == V)
      return end;

    SYS_ASSERT(end == V);
    return start;
  }

  inline bool Valid() const
  {
    return (start != NULL);
  }

  void Kill()
  {
    start = end = NULL;
  }

  void Flip()
  {
    std::swap(start, end);
    std::swap(front, back);
  }

  inline bool ShouldFlip() const
  {
    if (! front)
      return true;

    if (! back)
      return false;

    doom_sector_c *F = front->sector;
    doom_sector_c *B = back->sector;

    if (F->f_h != B->f_h) return (F->f_h > B->f_h);
    if (F->c_h != B->c_h) return (F->c_h < B->c_h);

    return false;
  }

  inline bool CanMergeSides(const doom_sidedef_c *A, const doom_sidedef_c *B) const
  {
    if (! A || ! B)
      return (!A && !B);

    if (A->sector != B->sector)
      return false;

    // X offsets not done here

    if (A->y_offset != B->y_offset &&
        A->y_offset != IVAL_NONE   &&
        B->y_offset != IVAL_NONE)
      return false;

    return A->SameTex(B);
  }

  bool ColinearWith(const doom_linedef_c *B) const
  {
    int adx = end->x - start->x;
    int ady = end->y - start->y;

    int bdx = B->end->x - B->start->x;
    int bdy = B->end->y - B->start->y;

    return (adx * bdy == bdx * ady);
  }

  bool CanMerge(const doom_linedef_c *B) const
  {
    if (! ColinearWith(B))
      return false;

    // test sidedefs
    doom_sidedef_c *B_front = B->front;
    doom_sidedef_c *B_back  = B->back;

///---  if ((V == end) == (V == B->end))
///---    std::swap(B_front, B_back);

    if (! CanMergeSides(back,  B_back) ||
        ! CanMergeSides(front, B_front))
      return false;

    if (  front->x_offset == IVAL_NONE ||
        B_front->x_offset == IVAL_NONE)
      return true;

    int diff = B_front->x_offset - (front->x_offset + I_ROUND(length));

    // the < 4 accounts for precision loss after multiple merges
    return abs(diff) < 4; 
  }

  void Merge(doom_linedef_c *B)
  {
    SYS_ASSERT(B->start == end);

    end = B->end;

    B->end->ReplaceLine(B, this);

    // fix X offset on back sidedef
    if (back && back->x_offset != IVAL_NONE)
      back->x_offset += I_ROUND(B->length);

    B->Kill();

    CalcLength();
  }

  bool isFrontSimilar(const doom_linedef_c *P) const
  {
    if (! back && ! P->back)
      return (strcmp(front->mid.c_str(), P->front->mid.c_str()) == 0);

    if (back && P->back)
      return front->SameTex(P->front);

    const doom_linedef_c *L = this;

    if (back)
      std::swap(L, P);

    // now L is single sided and P is double sided.

///---  if (P->mid[0] != '-')
///---    return false;

    // allow either upper or lower to match
    return (strcmp(L->front->mid.c_str(), P->front->lower.c_str()) == 0) ||
           (strcmp(L->front->mid.c_str(), P->front->upper.c_str()) == 0);
  }

  void Write();
};



static std::vector<doom_vertex_c *>  dm_vertices;
static std::vector<doom_linedef_c *> dm_linedefs;
static std::vector<doom_sidedef_c *> dm_sidedefs;
static std::vector<doom_sector_c *>  dm_sectors;
static std::vector<extrafloor_c *>   dm_exfloors;

static std::map<int, unsigned int>   dm_vertex_map;


//------------------------------------------------------------------------

void DM_FreeStuff(void)
{
  int i;

  for (i=0; i < (int)dm_vertices.size(); i++) delete dm_vertices[i];
  for (i=0; i < (int)dm_linedefs.size(); i++) delete dm_linedefs[i];
  for (i=0; i < (int)dm_sidedefs.size(); i++) delete dm_sidedefs[i];
  for (i=0; i < (int)dm_sectors .size(); i++) delete dm_sectors [i];
  for (i=0; i < (int)dm_exfloors.size(); i++) delete dm_exfloors[i];

  dm_vertices.clear();
  dm_linedefs.clear();
  dm_sidedefs.clear();
  dm_sectors. clear();
  dm_exfloors.clear();

  dm_vertex_map.clear();
}


#if 0

void DM_WriteDoom(void);  // forward


void Doom_TestBrushes(void)
{
  // for debugging only: each csg_brush_c becomes a single
  // sector on the map.
 
  DM_StartWAD("brush_test.wad");
  DM_BeginLevel();

  for (unsigned int k = 0; k < all_brushes.size(); k++)
  {
    csg_brush_c *P = all_brushes[k];
    
    int sec_idx = DM_NumSectors();

    const char *b_tex = P->b.face.getStr("tex", "LAVA1");
    const char *t_tex = P->t.face.getStr("tex", "LAVA1");

    DM_AddSector(I_ROUND(P->b.z), b_tex, I_ROUND(P->t.z), t_tex, 192, 0, 0);

    int side_base = DM_NumSidedefs();
    int vert_base = DM_NumVertexes();

    for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
    {
      int j2 = (j1 + 1) % (int)P->verts.size();

      brush_vert_c *v1 = P->verts[j1];

      const char *w_tex = v1->face.getStr("tex", "CRACKLE4");

      DM_AddVertex(I_ROUND(v1->x), I_ROUND(v1->y));

      DM_AddSidedef(sec_idx, "-", w_tex, "-", 0, 0);

      DM_AddLinedef(vert_base+j2, vert_base+j1, side_base+j1, -1,
                    0, 1 /*impassible*/, 0, NULL /* args */);
    }
  }

  DM_EndLevel("MAP01");
  DM_EndWAD();
}


void Doom_TestClip(void)
{
  // for Quake1 debugging only....

  DM_StartWAD("clip_test.wad");
  DM_BeginLevel();

  DM_WriteDoom();

  DM_EndLevel("MAP01");
  DM_EndWAD();
}


void DM_TestRegions(void)
{
  // for debugging only: each merge_region becomes a single
  // sector on the map.

  unsigned int i;

  for (i = 0; i < mug_vertices.size(); i++)
  {
    merge_vertex_c *V = mug_vertices[i];
    
    V->index = (int)i;

    DM_AddVertex(I_ROUND(V->x), I_ROUND(V->y));
  }


  for (i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    R->index = (int)i;

    const char *flat = "FLAT1";
 
    DM_AddSector(0,flat, 144,flat, 255,(int)R->brushes.size(),(int)R->gaps.size());

    const char *tex = R->faces_out ? "COMPBLUE" : "STARTAN3";

    DM_AddSidedef(R->index, tex, "-", tex, 0, 0);
  }


  for (i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);

    DM_AddLinedef(S->start->index, S->end->index,
                  S->front ? S->front->index : -1,
                  S->back  ? S->back->index  : -1,
                  0, 1 /*impassible*/, 0,
                  NULL /* args */);
  }
}
#endif


//------------------------------------------------------------------------

static void DM_MakeExtraFloor(doom_sector_c *sec, 
                              region_c *R, gap_c *T, gap_c *B)
{
#if 0  // TODO

  // find the brush which we will use for the side texture
  csg_brush_c *MID = NULL;
  double best_h = 0;

  // FIXME use f_sides/b_sides (FindSideFace)
  for (unsigned int j = 0; j < R->brushes.size(); j++)
  {
    csg_brush_c *A = R->brushes[j];

    if (A->b.z > B->t_brush->b.z - Z_EPSILON &&
        A->t.z < T->b_brush->t.z + Z_EPSILON)
    {
      double h = A->t.z - A->b.z;

      // TODO: priorities

//      if (MID && fabs(h - best_h) < Z_EPSILON)
//      { /* same height, prioritise */ }

      if (h > best_h)
      {
        best_h = h;
        MID = A;
      }
    }
  }

  SYS_ASSERT(MID);


  extrafloor_c *EF = new extrafloor_c;

  dm_exfloors.push_back(EF);

//FIXME !!!!  EF->w_tex = MID->w_face->tex;

  EF->users.push_back(sec);


  EF->dummy_sec = new doom_sector_c;

  EF->dummy_sec->f_h = I_ROUND(B->t_brush->b.z);
  EF->dummy_sec->c_h = I_ROUND(T->b_brush->t.z);

//FIXME !!!!  EF->dummy_sec->f_tex = B->t_brush->b_face->tex.c_str();
//FIXME !!!!  EF->dummy_sec->c_tex = T->b_brush->t_face->tex.c_str();


  // FIXME !!!! light, special


  sec->exfloors.push_back(EF);
#endif
}


static void DM_DoExtraFloors(doom_sector_c *S, region_c *R)
{
  // Note: top-to-bottom is the most natural order, because when
  // the engine adds an extrafloor into a sector, the upper part
  // remains the same and the lower part gets the new properties
  // (lighting/special) from the extrafloor.

  for (unsigned int g = R->gaps.size() - 1; g > 0; g--)
  {
    gap_c *T = R->gaps[g];
    gap_c *B = R->gaps[g-1];

    if (solid_exfloor > 0)
    {
      DM_MakeExtraFloor(S, R, T, B);
    }
    else
    {
      LogPrintf("WARNING: discarding extrafloor @ (%1.0f %1.0f)\n");
    }
  }
}


static void DM_DoLightingBrush(doom_sector_c *S, region_c *R)
{
  for (unsigned int i = 0; i < R->brushes.size(); i++)
  {
    csg_brush_c *B = R->brushes[i];

    if (B->bkind != BKIND_Light)
      continue;

    if (B->t.z < S->f_h+1 || B->b.z > S->c_h-1)
      continue;

    csg_property_set_c *t_face = &B->t.face;
    csg_property_set_c *b_face = &B->b.face;

    double raw = b_face->getInt("light", t_face->getInt("light"));
    int light = I_ROUND(raw * 256);

    if (light < 0)
    {
      // don't put shadow in closed doors
      if (S->f_h < S->c_h)
        S->misc_flags |= SEC_SHADOW;
      continue;
    }

    if (light > S->light)
    {
      S->light = light;
      S->misc_flags |= SEC_PRIMARY_LIT;
    }
  }
}


static void DM_MakeSector(region_c *R)
{
  // completely solid (no gaps) ?
  if (R->gaps.size() == 0)
  {
    R->index = -1;
    return;
  }


  doom_sector_c *S = new doom_sector_c;

  S->region = R;

  R->index = (int)dm_sectors.size();

  dm_sectors.push_back(S);


  R->GetMidPoint(&S->mid_x, &S->mid_y);


  csg_brush_c *B = R->gaps.front()->bottom;
  csg_brush_c *T = R->gaps.back() ->top;

  csg_property_set_c *f_face = &B->t.face;
  csg_property_set_c *c_face = &T->b.face;

  // determine floor and ceiling heights
  double f_delta = f_face->getDouble("delta_z");
  double c_delta = c_face->getDouble("delta_z");

  S->f_h = I_ROUND(B->t.z + f_delta);
  S->c_h = I_ROUND(T->b.z + c_delta);

  if (S->c_h < S->f_h)
      S->c_h = S->f_h;


  S->f_tex = f_face->getStr("tex", dummy_plane_tex.c_str());
  S->c_tex = c_face->getStr("tex", dummy_plane_tex.c_str());

  int f_mark = f_face->getInt("mark");
  int c_mark = c_face->getInt("mark");

  S->mark = f_mark ? f_mark : c_mark;


  // floors have priority over ceilings
  int f_kind = f_face->getInt("kind");
  int c_kind = c_face->getInt("kind");

  int f_tag = f_face->getInt("tag");
  int c_tag = c_face->getInt("tag");

  if (f_kind || ! c_kind)
  {
    S->special = f_kind;
    S->tag = (f_tag > 0) ? f_tag : c_tag;
  }
  else
  {
    S->special = c_kind;
    S->tag = (c_tag > 0) ? c_tag : f_tag;
  }


  int f_light = f_face->getInt("light");
  int c_light = c_face->getInt("light");

  if (f_light > 0 || c_light > 0)
  {
    S->light = (int)(256 * MAX(f_light, c_light));
    S->misc_flags |= SEC_PRIMARY_LIT;
  }

  if (T->bkind == BKIND_Sky)
    S->misc_flags |= SEC_IS_SKY;


  DM_DoLightingBrush(S, R);


  // find brushes floating in-between --> make extrafloors

  DM_DoExtraFloors(S, R);
}


static void DM_CreateSectors()
{
  for (unsigned int i = 0; i < all_regions.size(); i++)
  {
    DM_MakeSector(all_regions[i]);
  }
}


static void DM_LightingFloodFill()
{
#if 0  // !!!!! TODO

  int i;
  std::vector<doom_sector_c *> active;

  int valid_count = 1;

  for (i = 1; i < (int)dm_sectors.size(); i++)
  {
    doom_sector_c *S = dm_sectors[i];

    if (S->misc_flags & SEC_PRIMARY_LIT)
    {
      active.push_back(dm_sectors[i]);
      S->valid_count = valid_count;
    }
  }

  while (! active.empty())
  {
    valid_count++;

//fprintf(stderr, "LightingFloodFill: active=%d\n", active.size());

    std::vector<doom_sector_c *> changed;

    for (i = 0; i < (int)active.size(); i++)
    {
      doom_sector_c *S = active[i];

      for (int k = 0; k < (int)S->region->segs.size(); k++)
      {
        merge_segment_c *G = S->region->segs[k];

        if (! G->front || ! G->back)
          continue;

        if (G->front->index < 0 || G->back->index < 0)
          continue;

        doom_sector_c *F = dm_sectors[G->front->index];
        doom_sector_c *B = dm_sectors[G->back ->index];

        if (! (F==S || B==S))
          continue;

        if (B == S)
          std::swap(F, B);

        if (B->misc_flags & SEC_PRIMARY_LIT)
          continue;

        int light = MIN(F->light, 176);

        SYS_ASSERT(B != F);

        double dist = ComputeDist(F->mid_x,F->mid_y, B->mid_x,B->mid_y);

        double A = log(light) / log(2);
        double L2 = pow(2, A - dist / light_dist_factor);

        light = (int)L2;

        // less light through closed doors
        if (F->f_h >= B->c_h || B->f_h >= F->c_h)
          light -= 32;

        if (B->light >= light)
          continue;

        // spread brighter light into back sector
          
        B->light = light;

        if (B->valid_count != valid_count)
        {
          B->valid_count = valid_count;
          changed.push_back(B);
        }
      }
    }

    std::swap(active, changed);
  }

//fprintf(stderr, "LightingFloodFill EMPTY\n");

  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    doom_sector_c *S = dm_sectors[i];

    if (smoother_lighting)
      S->light = ((S->light + 1) / 8) * 8;
    else
      S->light = ((S->light + 3) / 16) * 16;

    if ((S->misc_flags & SEC_SHADOW))
      S->light -= (S->light > 168) ? 48 : 32;

    if (S->light <= 64)
      S->light = 96;
    else if (S->light < 112)
      S->light = 112;
    else if (S->light > 255)
      S->light = 255;
  }
#endif
}


static int DM_CoalescePass()
{
int changes = 0;
int diffs = 0;
int sames = 0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->index < 0)
      continue;

    doom_sector_c *D1 = dm_sectors[R->index];

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      region_c *N = S->partner ? S->partner->region : NULL;

      if (!N || N->index < 0)
        continue;

      doom_sector_c *D2 = dm_sectors[N->index];

      // use '>' so that we only check the relationship once
      if (N->index > R->index && D2->Match(D1))
      {
        D2->MarkUnused();

        N->index = R->index;

        changes++;
      }

if (N) {
if (N->index == R->index) sames++; else diffs++; }

    }
  }

fprintf(stderr, "DM_CoalescePass  changes:%d sames:%d diffs:%d\n", changes, sames, diffs);

  return changes;
}


static void DM_CoalesceSectors()
{
  while (DM_CoalescePass() > 0)
  { }

  // Note: we cannot remove & delete the unused sectors since the
  // region_c::index fields would need to be updated as well.
}


static void DM_CoalesceExtraFloors()
{
#if 0  // TODO

  for (int loop=0; loop < 99; loop++)
  {
    int changes = 0;

    for (unsigned int i = 0; i < mug_segments.size(); i++)
    {
      merge_segment_c *S = mug_segments[i];

      if (! S->front || ! S->back)
        continue;

      if (S->front->index < 0 || S->back->index < 0)
        continue;

      doom_sector_c *F = dm_sectors[S->front->index];
      doom_sector_c *B = dm_sectors[S->back ->index];
      
      for (unsigned int j = 0; j < F->exfloors.size(); j++)
      for (unsigned int k = 0; k < B->exfloors.size(); k++)
      {
        extrafloor_c *E1 = F->exfloors[j];
        extrafloor_c *E2 = B->exfloors[k];

        // already merged?
        if (E1 == E2)
          continue;

        if (! E1->Match(E2))
          continue;

        // don't merge with special stuff
        if (F->tag < 9000 || B->tag < 9000)
          continue;
        
        // limit how many sectors we can share
        if (E1->users.size() + E2->users.size() > 8)
          continue;

        // choose one of them. Using the minimum pointer is a
        // bit arbitrary, but is repeatable and transitive.
        extrafloor_c * EF    = MIN(E1, E2);
        extrafloor_c * other = MAX(E1, E2);

        F->exfloors[j] = EF;
        B->exfloors[k] = EF;

        // transfer the users
        while (other->users.size() > 0)
        {
          EF->users.push_back(other->users.back());
          other->users.pop_back();
        }

        changes++;
      }
    }

// fprintf(stderr, "CoalesceExtraFloors: changes = %d\n", changes);

    if (changes == 0)
      break;
  }
#endif
}


static void DM_AssignExtraFloorTags(void)
{
#if 0  // TODO

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    if (R->index < 0)
      continue;

    doom_sector_c *S = dm_sectors[R->index];

    if (S->exfloors.size() > 0 && S->tag <= 0)
    {
      S->tag = extrafloor_tag;

      extrafloor_tag += 1;
    }
  }
#endif
}


//------------------------------------------------------------------------

static doom_vertex_c * DM_MakeVertex(int x, int y)
{
  // look for existing vertex
  int combo = (x << 16) + y;

  if (dm_vertex_map.find(combo) != dm_vertex_map.end())
  {
    return dm_vertices[dm_vertex_map[combo]];
  }

  // create new one
  doom_vertex_c * V = new doom_vertex_c(x, y);

  dm_vertex_map[combo] = dm_vertices.size();

  dm_vertices.push_back(V);

  return V;
}


static int NaturalXOffset(doom_linedef_c *G, int side)
{
  double along;
  
  if (side == 0)
    along = AlongDist(0, 0,  G->start->x, G->start->y, G->end->x, G->end->y);
  else
    along = AlongDist(0, 0,  G->end->x, G->end->y, G->start->x, G->start->y);

  return I_ROUND(- along);
}

#if 0
static int CalcXOffset(merge_segment_c *G, int side, brush_vert_c *V, double x_offset) 
{
  double along = 0;
  
  if (V)
  {
    if (side == 0)
      along = ComputeDist(V->x, V->y, G->start->x, G->start->y);
    else
      along = ComputeDist(V->x, V->y, G->end->x, G->end->y);
  }

  return (int)(along + x_offset);
}
#endif

static int CalcRailYOffset(brush_vert_c *rail, int base_h)
{
  int y_offset = I_ROUND(rail->parent->b.z) - base_h;

  return y_offset;   ///--- MAX(0, y_offset);
}


static void DM_GetTexture(snag_c *S, csg_brush_c *B,
                          std::string & tex)
{
  SYS_ASSERT(B);

  brush_vert_c *vert = NULL;

  // FIXME !!!  find brush_Vert using snag

  if (! vert)
    vert = B->verts[0];

  SYS_ASSERT(vert);

  csg_property_set_c *face = &vert->face;

  tex = face->getStr("tex", dummy_wall_tex.c_str());
}


static doom_sidedef_c * DM_MakeSidedef(
    doom_sector_c *front, doom_sector_c *back,
    brush_vert_c *rail, bool *l_peg, bool *u_peg)
{
  if (! front)
    return NULL;


  doom_sidedef_c *SD = new doom_sidedef_c;

  SD->sector = front;

  dm_sidedefs.push_back(SD);


  // the 'natural' X/Y offsets
  SD->x_offset = IVAL_NONE;  //--- NaturalXOffset(G, side);
  SD->y_offset = - front->c_h;


#if 0  // FIXME : OLD BUT GOOD

  if (B && B->index >= 0)
  {
    doom_sector_c *BS = dm_sectors[B->index];

    csg_brush_c *l_brush = B->gaps.front()->b_brush;
    csg_brush_c *u_brush = B->gaps.back() ->t_brush;

    SYS_ASSERT(l_brush && u_brush);

    brush_vert_c *l_vert = G->FindSide(l_brush);
    brush_vert_c *u_vert = G->FindSide(u_brush);

    if (! l_vert) l_vert = l_brush->verts[0];
    if (! u_vert) u_vert = u_brush->verts[0];

    SYS_ASSERT(l_vert && u_vert);

    csg_property_set_c *lower_W = &l_vert->face;
    csg_property_set_c *upper_W = &u_vert->face;

    SD->lower = lower_W->getStr("tex", dummy_wall_tex.c_str());
    SD->upper = upper_W->getStr("tex", dummy_wall_tex.c_str());

    if (lower_W->getInt("peg")) *l_peg = true;
    if (upper_W->getInt("peg")) *u_peg = true;

    csg_property_set_c *rail_W = rail ? &rail->face : NULL;

    if (rail_W)
    {
      SD->mid = rail_W->getStr("tex", "-");

      *l_peg = false;
    }

    int r_ox = IVAL_NONE;
    if (rail_W) r_ox = rail_W->getInt("x_offset", r_ox);

    int l_ox = lower_W->getInt("x_offset", IVAL_NONE);
    int l_oy = lower_W->getInt("y_offset", IVAL_NONE);

    int u_ox = upper_W->getInt("x_offset", IVAL_NONE);
    int u_oy = upper_W->getInt("y_offset", IVAL_NONE);

    if (r_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, rail, r_ox);
    else if (l_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, l_vert, l_ox);
    else if (u_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, u_vert, u_ox);

    if (rail_W)
      SD->y_offset = CalcRailYOffset(rail, MAX(S->f_h, BS->f_h));
    else if (l_oy != IVAL_NONE)
      SD->y_offset = l_oy;
    else if (u_oy != IVAL_NONE)
      SD->y_offset = u_oy;
  }
  else  // one-sided line
  {
    double mz = (S->f_h + S->c_h) / 2.0;

    brush_vert_c *m_vert = CSG_FindSideVertex(G, mz, side == 1, true);

    brush_vert_c *m_side = CSG_FindSideFace(G, mz, side == 1, m_vert);

    if (! m_side)
    {
      SD->mid = dummy_wall_tex.c_str();
    }
    else
    {
      csg_property_set_c *mid_W = &m_side->face;

      SD->mid = mid_W->getStr("tex", dummy_wall_tex.c_str());

      if (mid_W->getInt("peg")) *l_peg = true;

      int ox = mid_W->getInt("x_offset", IVAL_NONE);
      int oy = mid_W->getInt("y_offset", IVAL_NONE);

      if (ox != IVAL_NONE)
        SD->x_offset = CalcXOffset(G, side, m_vert, ox);

      if (oy != IVAL_NONE)
        SD->y_offset = oy;
    }
  }
#endif

  if (! back)
  {
    SD->mid = "STARTAN3";
  }
  else
  {
    SD->lower = "ASHWALL4";
    SD->upper = "COMPBLUE";
  }

  return SD;
}


#if 0
static brush_vert_c *FindSpecialVert(merge_segment_c *G)
{
  doom_sector_c *FS = NULL;
  doom_sector_c *BS = NULL;

  if (G->front && G->front->index >= 0)
    FS = dm_sectors[G->front->index];

  if (G->back && G->back->index >= 0)
    BS = dm_sectors[G->back->index];

  if (!BS && !FS)
    return NULL;

  int min_f = +9999;
  int max_c = -9999;

  if (FS)
  {
    min_f = MIN(min_f, FS->f_h);
    max_c = MAX(max_c, FS->c_h);
  }

  if (BS)
  {
    min_f = MIN(min_f, BS->f_h);
    max_c = MAX(max_c, BS->c_h);
  }

  min_f -= 2;
  max_c += 2;


  brush_vert_c *minor = NULL;


  for (int side = 0; side < 2; side++)
  {
    unsigned int count = (side == 0) ? G->f_sides.size() : G->b_sides.size();

    for (unsigned int k=0; k < count; k++)
    {
      brush_vert_c *V = (side == 0) ? G->f_sides[k] : G->b_sides[k];

///---      if (! V->face)
///---        continue;

      if (V->parent->bkind == BKIND_Rail)
        continue;

      if (V->parent->b.z < (double)max_c &&
          V->parent->t.z > (double)min_f)
      {
/*
DebugPrintf("SEGMENT (%1.0f,%1.0f) --> (%1.0f,%1.0f) SIDE:%d LINE_KIND:%d\n",
            G->start->x, G->start->y, G->end  ->x, G->end  ->y,
            side, V->line_kind);
DebugPrintf("   BRUSH RANGE: %1.0f --> %1.0f  tex:%s\n",
            V->parent->b.z, V->parent->t.z, V->parent->w_face->tex.c_str());
DebugPrintf("   FS: %p  f_h:%d c_h:%d f_tex:%s\n",
            FS, FS ? FS->f_h : -1, FS ? FS->c_h : -1, FS ? FS->f_tex.c_str() : "");
DebugPrintf("   BS: %p  f_h:%d c_h:%d f_tex:%s\n",
            BS, BS ? BS->f_h : -1, BS ? BS->c_h : -1, BS ? BS->f_tex.c_str() : "");
*/
        if (V->face.getStr("kind"))
          return V;

        if (V->face.getStr("tag") || V->face.getStr("flags"))
          minor = V;
      }
    }
  }

  return minor;
}

static brush_vert_c *FindRailVert(merge_segment_c *G)
{
  doom_sector_c *FS = NULL;  // FIXME: duplicate code
  doom_sector_c *BS = NULL;

  if (G->front && G->front->index >= 0)
    FS = dm_sectors[G->front->index];

  if (G->back && G->back->index >= 0)
    BS = dm_sectors[G->back->index];

  if (!BS && !FS)
    return NULL;

  int min_f = +9999;
  int max_c = -9999;

  if (FS)
  {
    min_f = MIN(min_f, FS->f_h);
    max_c = MAX(max_c, FS->c_h);
  }

  if (BS)
  {
    min_f = MIN(min_f, BS->f_h);
    max_c = MAX(max_c, BS->c_h);
  }

  min_f -= 2;
  max_c += 2;


  for (int side = 0; side < 2; side++)
  {
    unsigned int count = (side == 0) ? G->f_sides.size() : G->b_sides.size();

    for (unsigned int k=0; k < count; k++)
    {
      brush_vert_c *V = (side == 0) ? G->f_sides[k] : G->b_sides[k];

      if (V->parent->bkind != BKIND_Rail)
        continue;

///---      if (! V->face)
///---        continue;

      if (V->parent->b.z > max_c || V->parent->b.z < min_f)
        continue;

      const char *tex = V->face.getStr("tex", "-");

      if (tex[0] == '-' && !V->face.getStr("kind") && !V->face.getStr("flags"))
        continue;

      // found one
      return V;
    }
  }

  return NULL;
}
#endif


static void DM_MakeLine(region_c *R, snag_c *S)
{
  region_c *N = S->partner ? S->partner->region : NULL;

  // if same sector on both sides, skip the line
  // FIXME: don't skip when has rail texture
  if (N && N->index == R->index)
    return;

  // for two-sided snags, only make one linedef from the pair
  if (S->seen)
    return;

  S->seen = true;

  if (S->partner)
    S->partner->seen = true;

  // skip snags which would become zero length linedefs
  int x1 = I_ROUND(S->x1);
  int y1 = I_ROUND(S->y1);

  int x2 = I_ROUND(S->x2);
  int y2 = I_ROUND(S->y2);

  if (x1 == x2 && y1 == y2)
  {
    fprintf(stderr, "WARNING: degenerate linedef @ (%1.0f %1.0f)\n", S->x1, S->y1);
    return;
  }


  if (y1 < map_bound_y1) map_bound_y1 = y1;
  if (y2 < map_bound_y1) map_bound_y1 = y2;


  doom_sector_c *front = dm_sectors[R->index];
  doom_sector_c *back  = NULL;

  if (N && N->index >= 0)
    back = dm_sectors[N->index];


  doom_linedef_c *L = new doom_linedef_c();

  dm_linedefs.push_back(L);


  L->start = DM_MakeVertex(x1, y1);
  L->end   = DM_MakeVertex(x2, y2);

  L->start->AddLine(L);
  L->end  ->AddLine(L);

  L->CalcLength();


  brush_vert_c *spec = NULL; //!!!  FindSpecialVert(G);
  brush_vert_c *rail = NULL; //!!!  FindRailVert(G);

  bool l_peg = false;
  bool u_peg = false;

  L->front = DM_MakeSidedef(front, back, rail, &l_peg, &u_peg);
  L->back  = DM_MakeSidedef(back, front, rail, &l_peg, &u_peg);

  SYS_ASSERT(L->front || L->back);


  // TODO: a way to ensure a certain orientation (two-sided lines only)

  if (L->ShouldFlip())
    L->Flip();


  if (! L->back)
    L->flags |= MLF_BlockAll;
  else
    L->flags |= MLF_TwoSided | MLF_LowerUnpeg | MLF_UpperUnpeg;

  if (l_peg) L->flags ^= MLF_LowerUnpeg;
  if (u_peg) L->flags ^= MLF_UpperUnpeg;


  if (rail)
  {
    L->flags |= rail->face.getInt("flags");

    if (! spec && rail->face.getStr("kind"))
      spec = rail;
  }

  if (spec)
  {
    L->flags |= spec->face.getInt("flags");

    L->type = spec->face.getInt("kind");
    L->tag  = spec->face.getInt("tag");

    spec->face.getHexenArgs(L->args);
  }
}


static void DM_CreateLinedefs()
{
  for (unsigned int i = 0; i < all_regions.size(); i++)
  {
    region_c *R = all_regions[i];

    if (R->index < 0)
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      DM_MakeLine(R, R->snags[k]);
    }
  }
}


//------------------------------------------------------------------------

static void DM_TryMergeLine(doom_linedef_c *A)
{
  doom_vertex_c *V = A->end;

  doom_linedef_c *B = V->SecondLine(A);

  if (! B)
    return;

  // we only handle the case where B's start == A's end
  // (which is still the vast majority of mergeable cases)

  if (V != B->start)
    return;

  SYS_ASSERT(B->Valid());

  if (A->CanMerge(B))
    A->Merge(B);
}


static void DM_MergeColinearLines(void)
{
  for (int pass = 0; pass < 4; pass++)
    for (int i = 0; i < (int)dm_linedefs.size(); i++)
      if (dm_linedefs[i]->Valid())
        DM_TryMergeLine(dm_linedefs[i]);
}


static doom_linedef_c * DM_FindSimilarLine(doom_linedef_c *L, doom_vertex_c *V)
{
  doom_linedef_c *best = NULL;
  int best_score = -1;

  for (int i = 0; i < 4; i++)
  {
    doom_linedef_c *M = V->lines[i];

    if (! M) break;
    if (M == L) continue;

    if (! L->isFrontSimilar(M))
      continue;

    int score = 0;

    if (! L->back && ! M->back)
      score += 20;

    if (L->ColinearWith(M))
      score += 10;

    if (score > best_score)
    {
      best = M;
      best_score = score;
    }
  }

  return best;
}


static void DM_AlignTextures(void)
{
  // Algorithm:  FIXME out of date
  //
  // 1) assign every linedef a "prev_matcher" field (forms a chain)
  //    [POSSIBILITY: similar field for back sidedefs]
  //
  // 2) give every linedef with no prev_matcher the NATURAL X offset
  //
  // 3) iterate over all linedefs, use prev_matcher chain to align X offsets

  int i;

  for (i = 0; i < (int)dm_linedefs.size(); i++)
  {
    doom_linedef_c *L = dm_linedefs[i];
    if (! L->Valid())
      continue;

    L->sim_prev = DM_FindSimilarLine(L, L->start);
    L->sim_next = DM_FindSimilarLine(L, L->end);

    if (L->front->x_offset == IVAL_NONE && ! L->sim_prev && ! L->sim_next)
      L->front->x_offset = NaturalXOffset(L, 0);
    
    if (L->back && L->back->x_offset == IVAL_NONE)
      L->back->x_offset = NaturalXOffset(L, 1);
  }

  for (int pass = 8; pass >= 0; pass--)
  {
    int naturals = 0;
    int prev_count = 0;
    int next_count = 0;

    for (i = 0; i < (int)dm_linedefs.size(); i++)
    {
      doom_linedef_c *L = dm_linedefs[i];
      if (! L->Valid())
        continue;

      if (L->front->x_offset == IVAL_NONE)
      {
        int mask = (1 << pass) - 1;

        if ((i & mask) == 0)
        {
          L->front->x_offset = NaturalXOffset(L, 0);
          naturals++;
        }
        continue;
      }

      doom_linedef_c *P = L;
      doom_linedef_c *N = L;

      while (P->sim_prev && P->sim_prev->front->x_offset == IVAL_NONE)
      {
        P->sim_prev->front->x_offset = P->front->x_offset - I_ROUND(P->sim_prev->length);
        P = P->sim_prev;
        prev_count++;
      }

      while (N->sim_next && N->sim_next->front->x_offset == IVAL_NONE)
      {
        N->sim_next->front->x_offset = N->front->x_offset + I_ROUND(N->length);
        N = N->sim_next;
        next_count++;
      }
    }

    DebugPrintf("AlignTextures pass %d : naturals:%d prevs:%d nexts:%d\n",
                pass, naturals, prev_count, next_count);
  }
}


//------------------------------------------------------------------------

int doom_vertex_c::Write()
{
  if (index < 0)  // not written yet?
  {
    index = DM_NumVertexes();

    DM_AddVertex(x, y);
  }

  return index;
}


int doom_sector_c::Write()
{
  if (index < 0)  // not written yet?
  {
    index = DM_NumSectors();

    DM_AddSector(f_h, f_tex.c_str(),
                 c_h, c_tex.c_str(),
                 light, special, tag);

    for (unsigned int k = 0; k < exfloors.size(); k++)
    {
//!!!! FIXME        WriteExtraFloor(this, exfloors[k]);
    }
  }

  return index;
}


int doom_sidedef_c::Write()  
{
  if (index < 0)  // not written yet?
  {
    index = DM_NumSidedefs();

    SYS_ASSERT(sector);

    int sec_index = sector->Write();

    DM_AddSidedef(sec_index, lower.c_str(), mid.c_str(),
                  upper.c_str(), x_offset & 1023, y_offset);
  }

  return index;
}


void doom_linedef_c::Write()
{
  SYS_ASSERT(start && end);

  int v1 = start->Write();
  int v2 = end  ->Write();

  int f = front ? front->Write() : -1;
  int b = back  ? back ->Write() : -1;

  DM_AddLinedef(v1, v2, f, b, type, flags, tag, args);
}


static void DM_WriteExtraFloor(doom_sector_c *sec, extrafloor_c *EF)
{
#if 0  ///  FIXME  FIXME

  if (EF->sec->index >= 0)
    return;

  EF->sec->index = DM_NumSectors();

  DM_AddSector(EF->sec->f_h, EF->sec->f_tex.c_str(),
               EF->sec->c_h, EF->sec->c_tex.c_str(),
               EF->sec->light, EF->sec->special, EF->sec->tag);


  extrafloor_slot++;


  int x1 =                (extrafloor_slot % 64) * 32;
  int y2 = map_bound_y1 - (extrafloor_slot % 64) * 32;

  if (extrafloor_slot & 1024) x1 += 2200;
  if (extrafloor_slot & 2048) y1 -= 2200;

  if (extrafloor_slot & 4096)
    Main_FatalError("Too many extrafloors! (over %d)\n", extrafloor_slot);

  int x2 = x1 + 32;
  int y2 = y1 + 32;

  int xm = x1 + 16;
  int ym = y1 + 16;

  bool morev = (EF->users.size() > 4);

  int vert_ref = DM_NumVertexes();

  if (true)  DM_AddVertex(x1, y1);
  if (morev) DM_AddVertex(x1, ym);

  if (true)  DM_AddVertex(x1, y2);
  if (morev) DM_AddVertex(xm, y2);

  if (true)  DM_AddVertex(x2, y2);
  if (morev) DM_AddVertex(x2, ym);

  if (true)  DM_AddVertex(x2, y1);
  if (morev) DM_AddVertex(xm, y1);

 
  int side_ref = DM_NumSidedefs();

  DM_AddSidedef(EF->sec->index, "-", EF->w_tex.c_str(), "-", 0, 0);


  int vert_num = morev ? 8 : 4;

  for (int n = 0; n < vert_num; n++)
  {
    int type = 0;
    int tag  = 0;

    if (n < (int)EF->users.size())
    {
      type = solid_exfloor;
      tag  = EF->users[n]->tag;

      SYS_ASSERT(tag > 0);
    }

    DM_AddLinedef(vert_ref + (n), vert_ref + ((n+1) % vert_num),
                  side_ref, -1 /* side2 */,
                  type, 1 /* impassible */,
                  tag, NULL /* args */);
  }
#endif
}


static void DM_WriteLinedefs(void)
{
  // this triggers everything else (Sidedefs, Sectors, Vertices) to be
  // written as well.

  for (int i = 0; i < (int)dm_linedefs.size(); i++)
    if (dm_linedefs[i]->Valid())
      dm_linedefs[i]->Write();
}


static int ParseThingOptions(csg_property_set_c & props)
{
  int options = props.getInt("flags");

  // TODO: perhaps this should be done by the Lua code...

  // skill flags (they all default to 1)
  if (props.getInt("skill_easy",   -1) != 0) options |= ~MTF_Easy;
  if (props.getInt("skill_medium", -1) != 0) options |= ~MTF_Medium;
  if (props.getInt("skill_hard",   -1) != 0) options |= ~MTF_Hard;

  // mode flags
  if (props.getInt("mode_sp",   -1) == 0) options |= MTF_NotSP;
  if (props.getInt("mode_coop", -1) == 0) options |= MTF_NotCOOP;
  if (props.getInt("mode_dm",   -1) == 0) options |= MTF_NotDM;

  // other flags...
  if (props.getInt("ambush") > 0)  options |= MTF_Ambush;
  if (props.getInt("friend") > 0)  options |= MTF_Friend;   // MBF
  if (props.getInt("dormant") > 0) options |= MTF_Dormant;  // Eternity

  return options;
}


static void DM_WriteThing(doom_sector_c *S, csg_entity_c *E)
{
  int type = atoi(E->name.c_str());

  if (type <= 0)
  {
    LogPrintf("WARNING: bad doom entity number: '%s'\n",  E->name.c_str());
    return;
  }

  int x = I_ROUND(E->x);
  int y = I_ROUND(E->y);
  int h = I_ROUND(E->z) - S->f_h;

  if (h < 0) h = 0;

  // parse entity properties
  int angle   = E->props.getInt("angle");
  int tid     = E->props.getInt("tid");
  int special = E->props.getInt("special");

  int options = ParseThingOptions(E->props);

  byte args[5] = { 0,0,0,0,0 };

  E->props.getHexenArgs(args);

  DM_AddThing(x, y, h, type, angle, options, tid, special, args);
}


static void DM_WriteThings(void)
{
  // iterate through regions so that we know which sector each thing
  // is in, which in turn lets us determine height above the floor.

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->index < 0)
      continue;

    doom_sector_c *S = dm_sectors[R->index];

    for (unsigned int k = 0 ; k < R->entities.size() ; k++)
    {
      DM_WriteThing(S, R->entities[k]);
    }
  }
}


//------------------------------------------------------------------------

void CSG_DOOM_Write()
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  //
  // Algorithm:
  //
  // 1) reserve first sector to represent VOID space (never written)
  // 2) create a sector for each region
  // 3) coalesce neighbouring sectors with same properties
  //    - mark border segments as unused
  //    - mark vertices with all unused segs as unused
  // 4) profit!

/// Doom_TestRegions();
/// return;
 
  LogPrintf("DOOM CSG...\n");

  DM_FreeStuff();

  CSG_BSP(4.0);

  CSG_MakeMiniMap();

  extrafloor_tag  = 9000;
  extrafloor_slot = 0;

  map_bound_y1 = 9999;

  DM_CreateSectors();

  DM_LightingFloodFill();
  DM_CoalesceSectors();

///  DM_AssignExtraFloorTags();
///  DM_CoalesceExtraFloors();

  DM_CreateLinedefs();

  DM_MergeColinearLines();
  DM_AlignTextures();

  map_bound_y1 -= (map_bound_y1 & 7) + 8;

///  CreateeDummies();

  DM_WriteLinedefs();
  DM_WriteThings();

  DM_FreeStuff();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
