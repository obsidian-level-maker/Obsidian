//------------------------------------------------------------------------
// LEVEL : Level structures & read/write functions.
//------------------------------------------------------------------------
//
//  GL-Friendly Node Builder (C) 2000-2007 Andrew Apted
//
//  Based on 'BSP 2.3' by Colin Reed, Lee Killough and others.
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

#ifndef __GLBSP_LEVEL_H__
#define __GLBSP_LEVEL_H__

#include "structs.h"
#include "wad.h"


struct sector_s;
struct seg_s;


// a wall_tip is where a wall meets a vertex
typedef struct wall_tip_s
{
  // link in list.  List is kept in ANTI-clockwise order.
  struct wall_tip_s *next;
  struct wall_tip_s *prev;
  
  // angle that line makes at vertex (degrees).
  angle_g angle;

  // sectors on each side of wall.  Left is the side of increasing
  // angles, right is the side of decreasing angles.  Either can be
  // NULL for one sided walls.
  struct sector_s *left;
  struct sector_s *right;
}
wall_tip_t;


typedef struct vertex_s
{
  // coordinates
  double x, y;

  // vertex index.  Always valid after loading and pruning of unused
  // vertices has occurred.  For GL vertices, bit 30 will be set.
  int index;

  // reference count.  When building normal node info, unused vertices
  // will be pruned.
  int ref_count;

  // set of wall_tips
  wall_tip_t *tip_set;
}
vertex_t;

#define IS_GL_VERTEX  (1 << 30)


typedef struct sector_s
{
  // sector index.  Always valid after loading & pruning.
  int index;

  // reference count.  When building normal nodes, unused sectors will
  // be pruned.
  int ref_count;

  // heights
  int floor_h, ceil_h;

  // textures
  char floor_tex[8];
  char ceil_tex[8];

  // attributes
  int light;
  int special;
  int tag;

  struct seg_s * seg_list;

  // suppress superfluous mini warnings
  int warned_facing;
  char warned_unclosed;
}
sector_t;


typedef struct sidedef_s
{
  // adjacent sector.  Can be NULL (invalid sidedef)
  sector_t *sector;

  // offset values
  int x_offset, y_offset;

  // texture names
  char upper_tex[8];
  char lower_tex[8];
  char mid_tex[8];
  
  // sidedef index.  Always valid after loading & pruning.
  int index;

  // reference count.  When building normal nodes, unused sidedefs will
  // be pruned.
  int ref_count;

  // usually NULL, unless this sidedef is exactly the same as a
  // previous one.  Only used during the pruning phase.
  struct sidedef_s *equiv;

  // this is true if the sidedef is on a special line.  We don't merge
  // these sidedefs together, as they might scroll, or change texture
  // when a switch is pressed.
  int on_special;
}
sidedef_t;


typedef struct linedef_s
{
  // link for list
  struct linedef_s *next;

  vertex_t *start;    // from this vertex...
  vertex_t *end;      // ... to this vertex

  sidedef_t *right;   // right sidedef
  sidedef_t *left;    // left sidede, or NULL if none

  // line is marked two-sided
  char two_sided;

  char is_border;

  // prefer not to split
  char is_precious;

  int flags;
  int type;
  int tag;

  // Hexen support
  int specials[5];
  
  // linedef index.  Always valid after loading & pruning of zero
  // length lines has occurred.
  int index;
}
linedef_t;


typedef struct thing_s
{
  int x, y;
  int type;
  int options;

  // other info (angle, and hexen stuff) omitted.  We don't need to
  // write the THING lump, only read it.

  // Always valid (thing indices never change).
  int index;
}
thing_t;


typedef struct seg_s
{
  // link for list
  struct seg_s *next;

  vertex_t *start;   // from this vertex...
  vertex_t *end;     // ... to this vertex

  // linedef that this seg goes along, or NULL if miniseg
  linedef_t *linedef;

  // adjacent sector, or NULL if invalid sidedef or miniseg
  sector_t *sector;

  // 0 for right, 1 for left
  int side;

  // seg on other side, or NULL if one-sided.  This relationship is
  // always one-to-one -- if one of the segs is split, the partner seg
  // must also be split.
  struct seg_s *partner;

  // seg index.  Only valid once the seg has been added to a
  // subsector.  A negative value means it is invalid -- there
  // shouldn't be any of these once the BSP tree has been built.
  int index;

  // precomputed data for faster calculations
  double psx, psy;
  double pex, pey;
  double pdx, pdy;

  double p_length;
  double p_angle;
  double p_para;
  double p_perp;

  // linedef that this seg initially comes from.  For "real" segs,
  // this is just the same as the 'linedef' field above.  For
  // "minisegs", this is the linedef of the partition line.
  linedef_t *source_line;
}
seg_t;


typedef struct subsec_s
{
  // sector this belongs to (possibly 'void_sector')
  sector_t *sector;

  // list of segs
  seg_t *seg_list;

  // count of segs
  int seg_count;

  // subsector index.  Always valid, set when the subsector is
  // initially created.
  int index;

  // approximate middle point
  double mid_x;
  double mid_y;
}
subsec_t;


typedef struct bbox_s
{
  int minx, miny;
  int maxx, maxy;
}
bbox_t;


/* ----- Level data arrays ----------------------- */

extern int num_vertices;
extern int num_linedefs;
extern int num_sidedefs;
extern int num_sectors;
extern int num_things;
extern int num_segs;
extern int num_subsecs;

extern int num_normal_vert;
extern int num_gl_vert;
extern int num_complete_seg;

// map limits
extern int limit_x1, limit_y1;
extern int limit_x2, limit_y2;

extern sector_t * void_sector;

// currently processed sector
extern sector_t * build_sector;


/* ----- function prototypes ----------------------- */

// allocation routines
vertex_t *NewVertex(void);
linedef_t *NewLinedef(void);
sidedef_t *NewSidedef(void);
sector_t *NewSector(void);
thing_t *NewThing(void);
seg_t *NewSeg(void);
subsec_t *NewSubsec(void);
wall_tip_t *NewWallTip(void);

// lookup routines
vertex_t *LookupVertex(int index);
linedef_t *LookupLinedef(int index);
sidedef_t *LookupSidedef(int index);
sector_t *LookupSector(int index);
thing_t *LookupThing(int index);
seg_t *LookupSeg(int index);
subsec_t *LookupSubsec(int index);

// load all level data for the current level
void LoadLevel(void);

// free all level data
void FreeLevel(void);

// save the newly computed info
void SaveLevel(void);

#endif /* __GLBSP_LEVEL_H__ */
