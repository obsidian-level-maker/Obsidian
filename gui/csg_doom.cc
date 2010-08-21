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
int solid_exfloor = 400;    // disabled if <= 0
int liquid_exfloor;


static int extrafloor_tag;
static int extrafloor_slot;

static int map_bound_y1;


#define SEC_IS_SKY       (0x1 << 16)
#define SEC_PRIMARY_LIT  (0x2 << 16)
#define SEC_SHADOW       (0x4 << 16)


double light_dist_factor = 800.0;

bool smoother_lighting = false;

#define COLINEAR_THRESHHOLD  0.24


#define MTF_ALL_SKILLS  (MTF_Easy | MTF_Medium | MTF_Hard)

#define MTF_HEXEN_CLASSES  (32 + 64 + 128)
#define MTF_HEXEN_MODES    (256 + 512 + 1024)


class extrafloor_c;
class dummy_sector_c;

class doom_linedef_c;


static bool EXFL_Match(extrafloor_c *A, extrafloor_c *B);


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

  void AddExtrafloor(extrafloor_c *EF)
  {
    exfloors.push_back(EF);
  }

  bool SameExtraFloors(const doom_sector_c *other) const
  {
    if (exfloors.size() != other->exfloors.size())
      return false;

    for (unsigned int i = 0 ; i < exfloors.size() ; i++)
    {
      extrafloor_c *A = exfloors[i];
      extrafloor_c *B = other->exfloors[i];

      if (A == B || EXFL_Match(A, B))
        continue;

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


///---bool extrafloor_c::Match(const extrafloor_c *other) const
///---{
///---  if (strcmp(w_tex.c_str(), other->w_tex.c_str()) != 0)
///---    return false;
///---
///---  SYS_ASSERT(dummy_sec && other->dummy_sec);
///---
///---  return dummy_sec->Match(other->dummy_sec);
///---}


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
    // never merge a pure horizontal/vertical with a diagonal
    if (start->x == end->x)
      return B->start->x == B->end->x;

    if (start->y == end->y)
      return B->start->y == B->end->y;

    if (B->start->x == B->end->x || B->start->y == B->end->y)
      return false;

    float adx = end->x - start->x;
    float ady = end->y - start->y;
    float a_len = sqrt(adx*adx + ady*ady);

    float bdx = B->end->x - B->start->x;
    float bdy = B->end->y - B->start->y;
    float b_len = sqrt(bdx*bdx + bdy*bdy);

    adx /= a_len;  bdx /= b_len;
    ady /= a_len;  bdy /= b_len;

    double d = fabs(adx * bdy - bdx * ady);

//  fprintf(stderr, "Colinear Lines: d=%1.4f\n", d);
//  fprintf(stderr, "  A:(%d %d) .. (%d %d) : %+d %+d\n", start->x,start->y, end->x,end->y, end->x - start->x, end->y - start->y);
//  fprintf(stderr, "  B:(%d %d) .. (%d %d) : %+d %+d\n", B->start->x,B->start->y, B->end->x,B->end->y, B->end->x - B->start->x, B->end->y - B->start->y);

    return d < COLINEAR_THRESHHOLD;
  }

  bool CanMerge(const doom_linedef_c *B) const
  {
    if (! ColinearWith(B))
      return false;

    // test sidedefs
    doom_sidedef_c *B_front = B->front;
    doom_sidedef_c *B_back  = B->back;

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

static std::vector<dummy_sector_c *> dm_dummies;
static std::vector<extrafloor_c *>   dm_exfloors;

static std::map<int, unsigned int>   dm_vertex_map;


//------------------------------------------------------------------------

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

static void DM_ExtraFloors(doom_sector_c *S, region_c *R);


static void DM_LightingBrush(doom_sector_c *S, region_c *R)
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


  DM_LightingBrush(S, R);


  // find brushes floating in-between --> make extrafloors

  DM_ExtraFloors(S, R);
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
    }
  }

  // fprintf(stderr, "DM_CoalescePass  changes:%d\n", changes);

  return changes;
}


static void DM_CoalesceSectors()
{
  while (DM_CoalescePass() > 0)
  { }

  // Note: we cannot remove & delete the unused sectors since the
  // region_c::index fields would need to be updated as well.
}


#if 0  // TODO
static void DM_CoalesceExtraFloors()
{

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
}
#endif


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


static int NaturalXOffset(doom_linedef_c *L, int side)
{
  double along;
  
  if (side == 0)
    along = AlongDist(0, 0,  L->start->x, L->start->y, L->end->x, L->end->y);
  else
    along = AlongDist(0, 0,  L->end->x, L->end->y, L->start->x, L->start->y);

  return I_ROUND(- along);
}


static int CalcXOffset(snag_c *S, brush_vert_c *V, int ox) 
{
  double along = 0;
  
  if (S)
  {
    along = ComputeDist(V->x, V->y, S->x2, S->y2);
  }

  return (int)(along + ox);
}


static int CalcYOffset(brush_vert_c *V, int oy, bool u_peg)
{
  // !!! FIXME: handle cut-offs (etc)
  return oy;
}


static int CalcRailYOffset(brush_vert_c *rail, doom_sector_c *F, doom_sector_c *B)
{
  int base_h = MAX(F->f_h, B->f_h);

  return I_ROUND(rail->parent->b.z) - base_h;
}


static doom_sidedef_c * DM_MakeSidedef(
    doom_sector_c *sec, doom_sector_c *back,
    snag_c *snag, snag_c *other,
    brush_vert_c *rail, bool *l_peg, bool *u_peg)
{
  if (! sec)
    return NULL;


  doom_sidedef_c *SD = new doom_sidedef_c;

  SD->sector = sec;

  dm_sidedefs.push_back(SD);


  // the 'natural' X/Y offsets
  SD->x_offset = IVAL_NONE;  // updated in DM_AlignTextures()
  SD->y_offset = - sec->c_h;


  brush_vert_c *lower = NULL;
  brush_vert_c *upper = NULL;

  const char *dummy_tex = dummy_wall_tex.c_str();

  // Note: 'snag' actually faces into the region _behind_ this sidedef

  if (! snag || snag->region->gaps.empty())
  {
    // ONE SIDED LINE

    if (snag)
    {
      double z = (sec->f_h + sec->c_h) / 2.0;
      lower = snag->FindOneSidedVert(z);
    }

    if (! lower)
    {
      SD->mid = dummy_tex;
    }
    else
    {
      SD->mid = lower->face.getStr("tex", dummy_tex);

      if (lower->face.getInt("peg"))
        *l_peg = true;

      int ox = lower->face.getInt("x_offset", IVAL_NONE);
      int oy = lower->face.getInt("y_offset", IVAL_NONE);

      if (ox != IVAL_NONE)
        SD->x_offset = CalcXOffset(snag, lower, ox);

      if (oy != IVAL_NONE)
        SD->y_offset = oy;  // !!! FIXME  CalcYOffset(upper, oy, ???)
    }
  }
  else
  {
    // Two Sided Line

    csg_brush_c *l_brush = snag->region->gaps.front()->bottom;
    csg_brush_c *u_brush = snag->region->gaps. back()->top;

    lower = snag->FindBrushVert(l_brush);
    upper = snag->FindBrushVert(u_brush);

    // fallback to something safe
    if (! lower) lower = l_brush->verts[0];
    if (! upper) upper = u_brush->verts[0];

    if (lower->face.getInt("peg")) *l_peg = true;
    if (upper->face.getInt("peg")) *u_peg = true;

    SD->lower = lower->face.getStr("tex", dummy_tex);
    SD->upper = upper->face.getStr("tex", dummy_tex);

    // offset handling
    int r_ox = IVAL_NONE;

    if (rail)
    {
      *l_peg = false;
      SD->mid = rail->face.getStr("tex", "-");
      r_ox = rail->face.getInt("x_offset", r_ox);
    }

    int l_ox = lower->face.getInt("x_offset", IVAL_NONE);
    int l_oy = lower->face.getInt("y_offset", IVAL_NONE);

    int u_ox = upper->face.getInt("x_offset", IVAL_NONE);
    int u_oy = upper->face.getInt("y_offset", IVAL_NONE);

    if (r_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(snag, rail,  r_ox);
    else if (l_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(snag, lower, l_ox);
    else if (u_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(snag, upper, u_ox);

    if (rail)
      SD->y_offset = CalcRailYOffset(rail, sec, back);
    else if (l_oy != IVAL_NONE)
      SD->y_offset = CalcYOffset(lower, l_oy, *u_peg);
    else if (u_oy != IVAL_NONE)
      SD->y_offset = CalcYOffset(upper, u_oy, *u_peg);
  }

  return SD;
}


static csg_property_set_c * DM_FindSpecial(snag_c *S, region_c *R1, region_c *R2)
{
  brush_vert_c *V;

  // we want the brushes for the floor or ceiling next to a linedef
  // to take precedence over any other brushes.  Hence the passes.

  for (int pass = 0 ; pass < 4 ; pass++)
  {
    int side = pass & 1;

    // try partner first
    snag_c *test_S = (side == 0) ? S->partner : S;

    if (! test_S)
      continue;

    if (pass < 2)
    {
      // region to test is one _behind_ the snag
      region_c *test_R = (side == 0) ? R1 : R2;

      if (! test_R || test_R->gaps.empty())
        continue;

      V = test_S->FindBrushVert(test_R->gaps.front()->bottom);

      if (V && V->face.getStr("kind"))
        return &V->face;
        
      V = test_S->FindBrushVert(test_R->gaps.back()->top);

      if (V && V->face.getStr("kind"))
        return &V->face;
    }
    else
    {
      // check every brush_vert in the snag
      for (unsigned int i = 0 ; i < test_S->sides.size() ; i++)
      {
        V = test_S->sides[i];

        if (V && V->face.getStr("kind"))
          return &V->face;
      }
    }
  }

  return NULL;
}


static brush_vert_c * DM_FindRail(snag_c *S, doom_sector_c *front, doom_sector_c *back)
{
  // railings require a two-sided line
  if (! front || ! back)
    return NULL;

  float f_max = MAX(front->f_h, back->f_h) + 4;
  float c_min = MIN(front->c_h, back->c_h) - 4;

  if (c_min >= f_max)
    return NULL;

  for (int side = 0 ; side < 2 ; side++)
  {
    snag_c *test_S = (side == 0) ? S->partner : S;

    if (! test_S)
      continue;

    for (unsigned int k = 0 ; k < test_S->sides.size() ; k++)
    {
      brush_vert_c *V = test_S->sides[k];

      if (V->parent->bkind != BKIND_Rail)
        continue;

      // is rail in lala land?
      if (V->parent->b.z > c_min || V->parent->t.z < f_max)
        continue;

      const char *tex = V->face.getStr("tex", "-");

      if (tex[0] == '-' && !V->face.getStr("kind"))
        continue;

      return V;  // found it
    }
  }

  return NULL;
}


static void DM_MakeLine(region_c *R, snag_c *S)
{
  region_c *N = S->partner ? S->partner->region : NULL;

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
    LogPrintf("WARNING: degenerate linedef @ (%1.0f %1.0f)\n", S->x1, S->y1);
    return;
  }


  if (y1 < map_bound_y1) map_bound_y1 = y1;
  if (y2 < map_bound_y1) map_bound_y1 = y2;


  doom_sector_c *front = dm_sectors[R->index];
  doom_sector_c *back  = NULL;

  if (N && N->index >= 0)
    back = dm_sectors[N->index];


  brush_vert_c *rail = DM_FindRail(S, front, back);

  // skip the line if same on both sides, except when it has a rail
  if (front == back && !rail)
    return;


  doom_linedef_c *L = new doom_linedef_c;

  dm_linedefs.push_back(L);


  L->start = DM_MakeVertex(x1, y1);
  L->end   = DM_MakeVertex(x2, y2);

  L->start->AddLine(L);
  L->end  ->AddLine(L);

  L->CalcLength();


  bool l_peg = false;
  bool u_peg = false;

  L->front = DM_MakeSidedef(front,  back, S->partner, S, rail, &l_peg, &u_peg);
  L->back  = DM_MakeSidedef( back, front, S, S->partner, rail, &l_peg, &u_peg);

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


  csg_property_set_c *spec = DM_FindSpecial(S, R, N);


  if (rail)
  {
    L->flags |= rail->face.getInt("flags");

    if (! spec && rail->face.getStr("kind"))
      spec = &rail->face;
  }

  if (spec)
  {
    L->type = spec->getInt("kind");
    L->tag  = spec->getInt("tag");

    L->flags |= spec->getInt("flags");

    spec->getHexenArgs(L->args);
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

static bool DM_TryMergeLine(doom_linedef_c *A)
{
  doom_vertex_c *V = A->end;

  doom_linedef_c *B = V->SecondLine(A);

  if (! B)
    return false;

  // we only handle the case where B's start == A's end
  // (which is still the vast majority of mergeable cases)

  if (V != B->start)
    return false;

  SYS_ASSERT(B->Valid());

  if (! A->CanMerge(B))
    return false;

  A->Merge(B);

  return true;
}


static void DM_MergeColinearLines(void)
{
  int count = 0;

  for (int pass = 0; pass < 4; pass++)
    for (int i = 0; i < (int)dm_linedefs.size(); i++)
      if (dm_linedefs[i]->Valid())
        DM_TryMergeLine(dm_linedefs[i]);
          count++;

  LogPrintf("Merged %d colinear lines\n");
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
  int i;
  int count = 0;

  for (i = 0 ; i < (int)dm_linedefs.size() ; i++)
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

  // when there are line loops where every x_offset is IVAL_NONE, then
  // it's a chicken and egg problem.  Hence we perform a bunch of passes,
  // the first pass checks every 256 lines for IVAL_NONE (which will then
  // propagate to similar neighbors), the next pass checks 128, 64, etc..

  for (int pass = 8 ; pass >= 0 ; pass--)
  {
    int naturals = 0;
    int prev_count = 0;
    int next_count = 0;

    for (i = 0 ; i < (int)dm_linedefs.size() ; i++)
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

    count += prev_count + next_count;

//  DebugPrintf("AlignTextures pass %d : naturals:%d prevs:%d nexts:%d\n",
//              pass, naturals, prev_count, next_count);
  }

  LogPrintf("Aligned %d textures\n", count);
}


//------------------------------------------------------------------------
//  EXTRAFLOOR STUFF
//------------------------------------------------------------------------

class dummy_sector_c
{
public:
  doom_sector_c *sector;

  doom_sector_c *pair;

  std::string texture;
  std::string flat;

  int ef_count;  // # of extrafloors sharing this dummy, MAX 8 !!

  int ef_type;
  int ef_flags;
  int ef_tag;

public:
  dummy_sector_c()
  { }

  ~dummy_sector_c()
  { }
};


class extrafloor_c
{
public:
  int top_h;
  int bottom_h;

  std::string top;  // textures
  std::string bottom;
  std::string wall;

  int index;

public:
  extrafloor_c() : top(), bottom(), wall(), index(-1)
  { }

  ~extrafloor_c()
  { } 

  bool Match(const extrafloor_c *other) const
  {
    return (   top_h == other->   top_h) &&
           (bottom_h == other->bottom_h) &&

           (strcmp(top.c_str(),    other->top.c_str())    == 0) &&
           (strcmp(bottom.c_str(), other->bottom.c_str()) == 0) &&
           (strcmp(wall.c_str(),   other->wall.c_str())   == 0);
  }
};


static bool EXFL_Match(extrafloor_c *A, extrafloor_c *B)
{
  return A->Match(B);
}


static void DM_MakeExtraFloor(doom_sector_c *sec, 
                              region_c *R, gap_c *gap1, gap_c *gap2)
{
  extrafloor_c *EF = new extrafloor_c;

  dm_exfloors.push_back(EF);

  sec->AddExtrafloor(EF);


  EF->top_h    = I_ROUND(gap2->bottom->t.z);
  EF->bottom_h = I_ROUND(gap1->   top->b.z);

  EF->top    = gap2->bottom->t.face.getStr("tex", dummy_plane_tex.c_str());
  EF->bottom = gap1->   top->b.face.getStr("tex", dummy_plane_tex.c_str());

  brush_vert_c *V = gap2->bottom->verts[0];

  EF->wall = V->face.getStr("tex", dummy_wall_tex.c_str());

  // TODO: sector special, tag
}


static void DM_ExtraFloors(doom_sector_c *S, region_c *R)
{
  if (liquid_exfloor && R->liquid)
  {
    // FIXME: make liquid extrafloor
    // DM_MakeLiquidFloor(S, R);
  }

  if (! solid_exfloor)
    return;

  // Note: top-to-bottom is the most natural order, because when
  // the engine adds an extrafloor into a sector, the upper part
  // remains the same and the lower part gets the new properties
  // (lighting/special) from the extrafloor.

  for (unsigned int g = R->gaps.size() - 1; g > 0; g--)
  {
    DM_MakeExtraFloor(S, R, R->gaps[g-1], R->gaps[g]);
  }
}


static int EXFL_CoalescePass()
{
  // TODO: sort extrafloors by Z, staggeredly compare

  int changes = 0;

  for (unsigned int i = 0 ; i < dm_linedefs.size() ; i++)
  {
    doom_linedef_c *L = dm_linedefs[i];

    if (! L->back)
      continue;

    doom_sector_c *front_S = L->front->sector;
    doom_sector_c * back_S = L-> back->sector;

    if (front_S == back_S)
      continue;

    for (unsigned int k = 0 ; k < front_S->exfloors.size() ; k++)
    for (unsigned int n = 0 ; n <  back_S->exfloors.size() ; n++)
    {
      extrafloor_c *E1 = front_S->exfloors[k];
      extrafloor_c *E2 =  back_S->exfloors[n];

fprintf(stderr, "__ testing %p (%d) + %p (%d)\n", E1,E1->index, E2,E2->index);
      if (E1 == E2 || E1->index == E2->index)
        continue;
      
      if (! E1->Match(E2))
        continue;

      int new_index = MIN(E1->index, E2->index);

      E1->index = new_index;
      E2->index = new_index;

      changes++;
    }
  }

fprintf(stderr, "EXFL_CoalescePass  changes:%d\n", changes);

  return changes;
}


static void DM_CoalesceExtraFloors()
{
  // FIXME: better method : simply sort dm_exfloors and find duplicates


  for (unsigned int k = 0 ; k < dm_exfloors.size() ; k++)
    dm_exfloors[k]->index = (int)k;

  while (EXFL_CoalescePass() > 0)
  { }

  // mark unused extrafloors and replace references
  int count = 0;

  for (unsigned int i = 0 ; i < dm_sectors.size() ; i++)
  {
    doom_sector_c *S = dm_sectors[i];

    for (unsigned int k = 0 ; k < S->exfloors.size() ; k++)
    {
      extrafloor_c *EF = S->exfloors[k];

      if (dm_exfloors[EF->index] != EF)
      {
        S->exfloors[k] = dm_exfloors[EF->index];
        EF->index = -1;

        count++;
      }
    }
  }

  LogPrintf("Merged %d extrafloors (of %u)\n", count, dm_exfloors.size());
}


static void EXFL_MakeDummy(doom_sector_c *S, extrafloor_c *EF)
{
  doom_sector_c *ACTUAL_DUMMY = new doom_sector_c;

  dm_sectors.push_back(ACTUAL_DUMMY);

  ACTUAL_DUMMY->f_h = EF->bottom_h;
  ACTUAL_DUMMY->c_h = EF->top_h;

  ACTUAL_DUMMY->f_tex = EF->bottom;
  ACTUAL_DUMMY->c_tex = EF->top;

  ACTUAL_DUMMY->light = 144;


  dummy_sector_c *dum = new dummy_sector_c;

  dm_dummies.push_back(dum);

  dum->sector = ACTUAL_DUMMY;
  dum->pair   = NULL;

  dum->texture = EF->wall;
  dum->flat    = "ZZZZ";

  dum->ef_count = 1;

  dum->ef_type  = solid_exfloor;
  dum->ef_flags = 1;
  dum->ef_tag   = S->tag;
}


static void DM_CombibulateExtraFloors()
{
  int tag = 10001;

  for (unsigned int i = 0 ; i < dm_sectors.size() ; i++)
  {
    doom_sector_c *S = dm_sectors[i];

    if (S->unused || S->exfloors.empty())
      continue;

    if (S->tag > 0)  // SHIT
      continue;

    S->tag = tag;  tag++;

    for (unsigned int k = 0 ; k < S->exfloors.size() ; k++)
    {
      extrafloor_c *EF = S->exfloors[k];

      EXFL_MakeDummy(S, EF);
    }
  }
}


static doom_sidedef_c * Dummy_Sidedef(dummy_sector_c *dum, int what)
{
  if (what == 0)
    return NULL;

  doom_sector_c *sec = dum->sector;

  if (what == 2 && dum->pair)
    sec = dum->pair;


  doom_sidedef_c *SD = new doom_sidedef_c;

  SD->sector = sec;

  dm_sidedefs.push_back(SD);


  SD->upper = dum->texture;
  SD->mid   = dum->texture;
  SD->lower = dum->texture;

  SD->x_offset = 0;
  SD->y_offset = 0;

  return SD;
}


static void Dummy_MakeLine(dummy_sector_c *dum, int split_min,
                           int x1, int y1, int x2, int y2,
                           int front, int back)
{
  // handle splitting via a single recurse

  if (split_min > 0 && (dum->ef_count >= split_min))
  {
    int mx = (x1 + x2) / 2;
    int my = (y1 + y2) / 2;

    Dummy_MakeLine(dum, -1, x1, y1, mx, my, front, back);
    Dummy_MakeLine(dum, -1, mx, my, x2, y2, front, back);

    return;
  }

  // front and back are 0 for VOID, 1 or 2 for SECTOR#

  if (front == 2 && ! dum->pair) front = 1;
  if ( back == 2 && ! dum->pair)  back = 1;

  if (front == back)
    return;


  doom_linedef_c *L = new doom_linedef_c;

  dm_linedefs.push_back(L);


  L->start = DM_MakeVertex(x1, y1);
  L->end   = DM_MakeVertex(x2, y2);

  L->CalcLength();


  L->front = Dummy_Sidedef(dum, front);
  L->back  = Dummy_Sidedef(dum, back);

  if (! L->front)
    L->Flip();


  L->flags = 1;

  if (split_min == 7)
  {
    L->type  = dum->ef_type;
    L->tag   = dum->ef_tag;
    L->flags = dum->ef_flags;
  }
}


static void DM_CreateDummies()
{
  for (unsigned int i = 0 ; i < dm_dummies.size() ; i++)
  {
    dummy_sector_c *dum = dm_dummies[i];

    // determine coordinate of bottom/left corner
    int x = ((int)i % 64 - 30) * 32;
    int y = map_bound_y1 - 128 - (i / 64) * 32;

    Dummy_MakeLine(dum, 5, x,y+16, x+16,y+16, 1,0);
    Dummy_MakeLine(dum, 6, x,y,    x+16,y,    0,2);
    Dummy_MakeLine(dum, 7, x,y,    x,y+16,    1,0);
    Dummy_MakeLine(dum, 8, x+16,y, x+16,y+16, 0,2);

    Dummy_MakeLine(dum, -1, x,y, x+16,y+16, 2,1);
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
  int options = E->props.getInt("flags", MTF_ALL_SKILLS);

  if (dm_sub_format == SUBFMT_Hexen)
  {
    if ((options & MTF_HEXEN_CLASSES) == 0)
      options |= MTF_HEXEN_CLASSES;

    if ((options & MTF_HEXEN_MODES) == 0)
      options |= MTF_HEXEN_MODES;
  }

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

void DM_FreeStuff(void)
{
  int i;

  for (i=0; i < (int)dm_vertices.size(); i++) delete dm_vertices[i];
  for (i=0; i < (int)dm_linedefs.size(); i++) delete dm_linedefs[i];
  for (i=0; i < (int)dm_sidedefs.size(); i++) delete dm_sidedefs[i];
  for (i=0; i < (int)dm_sectors .size(); i++) delete dm_sectors [i];

  for (i=0; i < (int)dm_exfloors.size(); i++) delete dm_exfloors[i];
  for (i=0; i < (int)dm_dummies .size(); i++) delete dm_dummies [i];

  dm_vertices.clear();
  dm_linedefs.clear();
  dm_sidedefs.clear();
  dm_sectors. clear();

  dm_exfloors.clear();
  dm_dummies .clear();

  dm_vertex_map.clear();
}


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


  DM_CreateLinedefs();

  DM_MergeColinearLines();
  DM_AlignTextures();

  map_bound_y1 -= (map_bound_y1 & 7) + 8;


  DM_CoalesceExtraFloors();
  DM_CombibulateExtraFloors();
  DM_CreateDummies();


  DM_WriteLinedefs();
  DM_WriteThings();

  DM_FreeStuff();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
