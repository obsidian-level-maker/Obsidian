//------------------------------------------------------------------------
//  2.5D CSG : DOOM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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
#include "dm_glbsp.h"
#include "dm_level.h"
#include "dm_wad.h"


#define TEMP_FILENAME    "temp/out.wad"


// Properties
static char *level_name;
static char *error_tex;

static int solid_exfloor;    // disabled if <= 0
static int liquid_exfloor;

extern bool wad_hexen;  // FIXME


#define VOID_INDEX  -2

static int extrafloor_tag;
static int extrafloor_slot;



class sector_info_c;


class extrafloor_c
{
public:
  sector_info_c * sec;

  std::string w_tex;

  std::vector<sector_info_c *> users;

public:
   extrafloor_c() : sec(NULL), w_tex(), users() { }
  ~extrafloor_c() { } 

  bool Match(const extrafloor_c *other) const;
};


class sector_info_c 
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
  
public:
  sector_info_c() : f_h(0), c_h(0), f_tex(), c_tex(),
                    light(255), special(0), tag(0), mark(0),
                    exfloors(), index(-1)
  { }

  ~sector_info_c()
  { }

  bool SameExtraFloors(const sector_info_c *other) const
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

  bool Match(const sector_info_c *other) const
  {
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
};


static std::vector<sector_info_c *> dm_sectors;
static std::vector<extrafloor_c *>  dm_exfloors;

int bounds_x1, bounds_y1;
int bounds_x2, bounds_y2;


bool extrafloor_c::Match(const extrafloor_c *other) const
{
  SYS_ASSERT(sec && other->sec);

  if (strcmp(w_tex.c_str(), other->w_tex.c_str()) != 0)
    return false;

  return sec->Match(other->sec);
}


void CSG2_Doom_TestAreas(void)
{
  // for debugging only: each csg_brush_c becomes a single sector
  // on the map.
 
  for (unsigned int k = 0; k < all_brushes.size(); k++)
  {
    csg_brush_c *P = all_brushes[k];
    
    int sec_idx = DM_NumSectors();

    DM_AddSector(I_ROUND(P->z1), P->b_face->tex.c_str(),
                 I_ROUND(P->z2), P->t_face->tex.c_str(),
                 192, 0, 0);

    int side_idx = DM_NumSidedefs();

    DM_AddSidedef(sec_idx, "-", P->w_face->tex.c_str(), "-", 0, 0);

    int vert_base = DM_NumVertexes();

    for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
    {
      int j2 = (j1 + 1) % (int)P->verts.size();

      area_vert_c *v1 = P->verts[j1];
   // area_vert_c *v2 = P->verts[j2];

      DM_AddVertex(I_ROUND(v1->x), I_ROUND(v1->y));

      DM_AddLinedef(vert_base+j1, vert_base+j2, side_idx, -1,
                    0, 1 /*impassible*/, 0, NULL /* args */);
    }
  }
}

void CSG2_Doom_TestRegions(void)
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
 
    DM_AddSector(0,flat, 144,flat, 255,(int)R->areas.size(),(int)R->gaps.size());

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


//------------------------------------------------------------------------

#if 0
static csg_brush_c * FindExtraFloor(merge_region_c *R, double z1, double z2)
{
  csg_brush_c *best = NULL;

  for (unsigned int k=0; k < R->areas.size(); k++)
  {
    csg_brush_c *E = R->areas[k];

    if (! (E->z1 > z1 && E->z2 < z2))
      continue;

    // we prefer the one closest to the top (because when the engine
    // adds an extrafloor, the upper region stays the same and the
    // lower regions gets the lighting/special from the extrafloor).

    if (! best || E->z2 > best->z2) 
    {
      best = E;
    }
  }

  return best;
}
#endif


void DetermineMapBounds(void)
{
  double min_x, min_y, min_z;
  double max_x, max_y, max_z;

  CSG2_GetBounds(min_x, min_y, min_z,  max_x, max_y, max_z);

  // rounding is OK since the bounds have been padded
  bounds_x1 = I_ROUND(min_x);
  bounds_y1 = I_ROUND(min_y);

  bounds_x2 = I_ROUND(max_x);
  bounds_y2 = I_ROUND(max_y);
}


static void MakeExtraFloor(merge_region_c *R, sector_info_c *sec,
                           merge_gap_c *T, merge_gap_c *B)
{
#if 0 // OLD CODE
  // T is the top-most brush.  Find the bottom-most brush
  // which is connected to T (via intersecting brushes).
  csg_brush_c *B = T;

  for (;;)
  {
    bool changed = false;

    for (unsigned int k=0; k < R->areas.size(); k++)
    {
      csg_brush_c *A = R->areas[k];

      if (A->z1 < B->z1 - EPSILON &&
          A->z2 > B->z1 - EPSILON)
///       A->z2 < T->z2 + EPSILON)
      {
        B = A; changed = true;
      }
    }

    if (! changed)
      break;
  }
#endif

  // find the brush which we will use for the side texture
  csg_brush_c *MID = NULL;
  double best_h = 0;

  for (unsigned int j = 0; j < R->areas.size(); j++)
  {
    csg_brush_c *A = R->areas[j];

    if (A->z1 > B->t_brush->z1 - EPSILON &&
        A->z2 < T->b_brush->z2 + EPSILON)
    {
      double h = A->z2 - A->z1;

      // TODO: priorities

//      if (MID && fabs(h - best_h) < EPSILON)
//      { /* same height, prioritise */ }

      if (h > best_h)
      {
        best_h = h;
        MID = A;
      }
    }
  }

  SYS_ASSERT(MID);


  extrafloor_c *EF = new extrafloor_c();

  EF->w_tex = MID->w_face->tex;

  EF->users.push_back(sec);


  EF->sec = new sector_info_c();

  EF->sec->f_h = I_ROUND(B->t_brush->z1);
  EF->sec->c_h = I_ROUND(T->b_brush->z2);

  EF->sec->f_tex = B->t_brush->b_face->tex.c_str();
  EF->sec->c_tex = T->b_brush->t_face->tex.c_str();

  // FIXME !!!! light, special


  sec->exfloors.push_back(EF);

  dm_exfloors.push_back(EF);
}


static void CreateOneSector(merge_region_c *R)
{
  // completely solid (no gaps) ?
  if (R->gaps.size() == 0)
  {
    R->index = 0;
    return;
  }


  csg_brush_c *B = R->gaps[0]->b_brush;
  csg_brush_c *T = R->gaps[R->gaps.size()-1]->t_brush;

  sector_info_c *sec = new sector_info_c;

  sec->f_h = I_ROUND(B->z2);
  sec->c_h = I_ROUND(T->z1);

  if (sec->c_h < sec->f_h)
      sec->c_h = sec->f_h;

  if ((B->bflags | T->bflags) & BRU_F_Door)
    sec->c_h = sec->f_h;
  else if ((B->bflags | T->bflags) & BRU_F_SkyClose)
    sec->c_h = sec->f_h + 2;

  sec->f_tex = B->t_face->tex;
  sec->c_tex = T->b_face->tex;

  sec->light = (sec->c_tex[1] == '_') ? 208 : 160;  // FIXME: TEMP HACK
  sec->mark  = MAX(B->mark, T->mark);

  if (B->sec_kind > 0)
  {
    sec->special = B->sec_kind;
    sec->tag     = B->sec_tag;
  }
  else if (T->sec_kind > 0)
  {
    sec->special = T->sec_kind;
    sec->tag     = T->sec_tag;
  }
  else
  {
    sec->special = 0;

    if (B->sec_tag > 0)
      sec->tag = B->sec_tag;
    else if (T->sec_tag > 0)
      sec->tag = T->sec_tag;
    else
      sec->tag = 0;
  }


  R->index = (int)dm_sectors.size();

  dm_sectors.push_back(sec);


  // find brushes floating in-between --> make extrafloors

  // Note: top-to-bottom is the most natural order, because when
  // the engine adds an extrafloor into a sector, the upper part
  // remains the same and the lower part gets the new properties
  // (lighting/special) from the extrafloor.

  if (solid_exfloor > 0)
  {
    for (unsigned int g = R->gaps.size() - 1; g > 0; g--)
    {
      merge_gap_c *T = R->gaps[g];
      merge_gap_c *B = R->gaps[g-1];

      MakeExtraFloor(R, sec, T, B);
    }
  }
  // FIXME: else ????


#if 0  // OLD CODE
  double exfloor_z1 = B->z2 + 1;
  double exfloor_z2 = T->z1 - 1;

  for (;;)
  {
    csg_brush_c *EF = FindExtraFloor(R, exfloor_z1, exfloor_z2);

    if (! EF)
      break;

    exfloor_z2 = MakeExtraFloor(R, sec, EF) - 1;
  }
#endif
}

static void CoalesceSectors(void)
{
  for (int loop=0; loop < 99; loop++)
  {
    int changes = 0;

    for (unsigned int i = 0; i < mug_segments.size(); i++)
    {
      merge_segment_c *S = mug_segments[i];

      if (! S->front || ! S->back)
        continue;

      if (S->front->index <= 0 || S->back->index <= 0)
        continue;
      
      // already merged?
      if (S->front->index == S->back->index)
        continue;

      sector_info_c *F = dm_sectors[S->front->index];
      sector_info_c *B = dm_sectors[S->back ->index];

      if (F->Match(B))
      {
        S->front->index = MIN(S->front->index, S->back->index);
        S->back ->index = S->front->index;

        changes++;
      }
    }

fprintf(stderr, "CoalesceSectors: changes = %d\n", changes);

    if (changes == 0)
      return;
  }
}

static void CoalesceExtraFloors(void)
{
  for (int loop=0; loop < 99; loop++)
  {
    int changes = 0;

    for (unsigned int i = 0; i < mug_segments.size(); i++)
    {
      merge_segment_c *S = mug_segments[i];

      if (! S->front || ! S->back)
        continue;

      if (S->front->index <= 0 || S->back->index <= 0)
        continue;

      sector_info_c *F = dm_sectors[S->front->index];
      sector_info_c *B = dm_sectors[S->back ->index];
      
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

fprintf(stderr, "CoalesceExtraFloors: changes = %d\n", changes);

    if (changes == 0)
      break;
  }
}

static void AssignExtraFloorTags(void)
{
  for (unsigned int j = 0; j < mug_regions.size(); j++)
  {
    merge_region_c *R = mug_regions[j];

    if (R->index <= 0)
      continue;

    sector_info_c *S = dm_sectors[R->index];

    if (S->exfloors.size() > 0 && S->tag <= 0)
    {
      S->tag = extrafloor_tag++;
    }
  }
}

static void CreateSectors(void)
{
  dm_sectors.clear();

  // #0 represents VOID (removed later)
  dm_sectors.push_back(new sector_info_c);

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    CreateOneSector(R);
  }

  CoalesceSectors();

  AssignExtraFloorTags();

  CoalesceExtraFloors();
}


//------------------------------------------------------------------------

static void WriteExtraFloor(sector_info_c *sec, extrafloor_c *EF)
{
  if (EF->sec->index >= 0)
    return;

  EF->sec->index = DM_NumSectors();

  DM_AddSector(EF->sec->f_h, EF->sec->f_tex.c_str(),
               EF->sec->c_h, EF->sec->c_tex.c_str(),
               EF->sec->light, EF->sec->special, EF->sec->tag);


  extrafloor_slot++;


  int x1 = bounds_x1 +       (extrafloor_slot % 32) * 64;
  int y1 = bounds_y1 - 128 - (extrafloor_slot / 32) * 64;

  if (extrafloor_slot & 1024) x1 += 2200;
  if (extrafloor_slot & 2048) y1 -= 2200;

  if (extrafloor_slot & 4096)
    Main_FatalError("Too many extrafloors! (over %d)%d\n", extrafloor_slot);

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

///---  DM_AddLinedef(vert_ref+0, vert_ref+1, side_ref, -1,
///---                400 /* EDGE !! */,
///---                sec->tag,
///---
///---  DM_AddLinedef(vert_ref+1, vert_ref+2, side_ref, -1, 0,1,0, NULL);
///---  DM_AddLinedef(vert_ref+2, vert_ref+3, side_ref, -1, 0,1,0, NULL);
///---  DM_AddLinedef(vert_ref+3, vert_ref+0, side_ref, -1, 0,1,0, NULL);
}


static int WriteVertex(merge_vertex_c *V)
{
  if (V->index < 0)
  {
    V->index = DM_NumVertexes();

    DM_AddVertex(I_ROUND(V->x), I_ROUND(V->y));
  }

  return V->index;
}


static int WriteSector(sector_info_c *S)
{
  if (S->index < 0)
  {
    for (unsigned int k = 0; k < S->exfloors.size(); k++)
    {
      WriteExtraFloor(S, S->exfloors[k]);
    }

    S->index = DM_NumSectors();

    DM_AddSector(S->f_h, S->f_tex.c_str(),
                 S->c_h, S->c_tex.c_str(),
                 S->light, S->special, S->tag);
  }

  return S->index;
}


static std::string FindSideTexture(double z, merge_segment_c *G,
                                   merge_region_c *F, merge_region_c *B)
{
  if (! B)
    return std::string(error_tex ? error_tex : "FIREBLU1");  // FIXME

  // TODO: find texture in line loops using segment 'G'

  // TODO: check for multiple matches, prioritise

  unsigned int k;

  // examine *back* region
  for (k = 0; k < B->areas.size(); k++)
  {
    csg_brush_c *A = B->areas[k];

    if ((z > A->z1 - EPSILON) && (z < A->z2 + EPSILON))
      return A->w_face->tex;
  }

  // none found ???  FIXME use closest area
  return std::string("FIREBLU1");
}

static int WriteSidedef(merge_segment_c *G, merge_region_c *F, merge_region_c *B)
{
  if (! (F && F->index > 0))
    return -1;

  sector_info_c *S = dm_sectors[F->index];

  int sec_num = WriteSector(S);

  int side_ref = DM_NumSidedefs();

  if (B && B->index > 0)
  {
    sector_info_c *BS = dm_sectors[B->index];

    double fz = (S->f_h + BS->f_h) / 2.0;
    double cz = (S->c_h + BS->c_h) / 2.0;

    std::string lower = FindSideTexture(fz, G, F, B);
    std::string upper = FindSideTexture(cz, G, F, B);

    std::string rail = "-"; // TODO = FindRailTexture( xxx )

    DM_AddSidedef(sec_num, lower.c_str(), rail.c_str(), upper.c_str(), 0, 0);
  }
  else
  {
    double z = (S->f_h + S->c_h) / 2.0;

    std::string wall = FindSideTexture(z, G, F, B);

    DM_AddSidedef(sec_num, "-", wall.c_str(), "-", 0, 0);
  }

  return side_ref;
}


static void WriteLinedefs(void)
{
  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *G = mug_segments[i];

    SYS_ASSERT(G);
    SYS_ASSERT(G->start);

    if (! G->front && ! G->back)
      continue;

    // if same sector on both sides, skip the line, unless
    // we have a rail texture or a special line.
    if (G->front && G->back && G->front->index == G->back->index)
    {
      // FIXME: check for a rail texture (on any line)

      // FIXME: check for a special line-type (on any line)
      continue;
    }

    int front_idx = WriteSidedef(G, G->front, G->back);
    int back_idx  = WriteSidedef(G, G->back, G->front);

    if (front_idx < 0 && back_idx < 0)
      continue;

    int v1 = WriteVertex(G->start);
    int v2 = WriteVertex(G->end);

    if (front_idx < 0)
    {
      front_idx = back_idx;
      back_idx  = -1;

      int TMP = v1; v1 = v2; v2 = TMP;
    }

    int flags = 0;

    if (back_idx < 0)
      flags |= MLF_BlockAll;

    if (back_idx >= 0 && front_idx >= 0)
    {
      flags |= MLF_TwoSided;

      flags |= MLF_LowerUnpeg | MLF_UpperUnpeg;
    }

    DM_AddLinedef(v1, v2, front_idx, back_idx,
                  0 /* type */, flags,
                  0 /* tag */, NULL /* args */);
  }

  SYS_ASSERT(DM_NumVertexes() > 0);
}


static void WriteThings(void)
{
  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    int type = atoi(E->name.c_str());

    if (type <= 0)
      continue; // FIXME: WARNING

    // FIXME!!!! thing height
    double h = 0;

    DM_AddThing(I_ROUND(E->x), I_ROUND(E->y), I_ROUND(h), type,
                   0, /* FIXME: angle */
                   7, /* FIXME: options */
                   0, /* FIXME: tid */
                   0, /* FIXME: special */
                   NULL /* args */);
  }
}


void DM_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  //
  // Algorithm:
  //
  // 1) reserve sector #0 to represent VOID space (removed later)
  // 2) create a sector for each region
  // 3) coalesce neighbouring sectors with same properties
  //    - mark border segments as unused
  //    - mark vertices with all unused segs as unused
  // 4) profit!

//CSG2_Doom_TestAreas();
//return;

  CSG2_MergeAreas();

  CSG2_MakeMiniMap();

//CSG2_Doom_TestRegions();
//return;
 
  extrafloor_tag  = 9000;
  extrafloor_slot = 0;

  DetermineMapBounds();

  CreateSectors();

///  WriteDummies();

  WriteLinedefs();

  WriteThings();

  // FIXME: Free everything
}


//------------------------------------------------------------------------


class doom_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  doom_game_interface_c() : filename(NULL)
  { }

  ~doom_game_interface_c()
  {
    StringFree(filename);
  }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);

private:
  bool BuildNodes(const char *target_file);
};


bool doom_game_interface_c::Start()
{
  filename = Select_Output_File("wad");

  if (! filename)  // cancelled
    return false;

  if (! DM_StartWAD(TEMP_FILENAME))
    return false;

  main_win->build_box->ProgInit(2);

  main_win->build_box->ProgBegin(1, 100, BUILD_PROGRESS_FG);
  main_win->build_box->ProgStatus("Making levels");

  return true;
}


bool doom_game_interface_c::BuildNodes(const char *target_file)
{
  DebugPrintf("TARGET FILENAME: [%s]\n", target_file);

  // backup any existing wad

  if (FileExists(target_file))
  {
    char *backup_name = ReplaceExtension(target_file, "bak");

    LogPrintf("Backing up existing file to %s\n", backup_name);

    if (! FileCopy(target_file, backup_name))
      LogPrintf("WARNING: unable to create backup!\n");

    StringFree(backup_name);
  }

  return DM_BuildNodes(TEMP_FILENAME, target_file);
}


bool doom_game_interface_c::Finish(bool build_ok)
{
  DM_EndWAD(); // FIXME:check return??

  if (build_ok)
  {
    build_ok = BuildNodes(filename);
  }

  // tidy up
  FileDelete(TEMP_FILENAME);

  return build_ok;
}


void doom_game_interface_c::BeginLevel()
{
  // nothing needed
}


void doom_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "hexen_format") == 0)
  {
    if (value[0] == '0' || tolower(value[0]) == 'f')
      wad_hexen = false;
    else
      wad_hexen = true;
  }
  else if (StringCaseCmp(key, "error_tex") == 0)
  {
    error_tex = StringDup(value);
  }
  else if (StringCaseCmp(key, "solid_exfloor") == 0)
  {
    solid_exfloor = atoi(value);
  }
  else if (StringCaseCmp(key, "liquid_exfloor") == 0)
  {
    liquid_exfloor = atoi(value);
  }
  else
  {
    LogPrintf("WARNING: unknown DOOM property: %s=%s\n", key, value);
  }
}


void doom_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  DM_BeginLevel();

  DM_WriteDoom();

  DM_EndLevel(level_name);

  StringFree(level_name);
  level_name = NULL;

  if (error_tex)
  {
    StringFree(error_tex);
    error_tex = NULL;
  }
}


game_interface_c * Doom_GameObject()
{
  return new doom_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
