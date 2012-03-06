//------------------------------------------------------------------------
//  LEVEL : Level structures & read/write functions.
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

#ifndef __BRUSHER_LEVEL_H__
#define __BRUSHER_LEVEL_H__


/* ----- The level structures ---------------------- */

typedef struct raw_vertex_s
{
  sint16_g x, y;
}
raw_vertex_t;

typedef struct raw_v2_vertex_s
{
  sint32_g x, y;
}
raw_v2_vertex_t;


typedef struct raw_linedef_s
{
  uint16_g start;     // from this vertex...
  uint16_g end;       // ... to this vertex
  uint16_g flags;     // linedef flags (impassible, etc)
  uint16_g type;      // linedef type (0 for none, 97 for teleporter, etc)
  sint16_g tag;       // this linedef activates the sector with same tag
  uint16_g sidedef1;  // right sidedef
  uint16_g sidedef2;  // left sidedef (only if this line adjoins 2 sectors)
}
raw_linedef_t;

typedef struct raw_hexen_linedef_s
{
  uint16_g start;        // from this vertex...
  uint16_g end;          // ... to this vertex
  uint16_g flags;        // linedef flags (impassible, etc)
  uint8_g  type;         // linedef type
  uint8_g  specials[5];  // hexen specials
  uint16_g sidedef1;     // right sidedef
  uint16_g sidedef2;     // left sidedef
}
raw_hexen_linedef_t;

#define LINEFLAG_TWO_SIDED  4

#define HEXTYPE_POLY_START     1
#define HEXTYPE_POLY_EXPLICIT  5


typedef struct raw_sidedef_s
{
  sint16_g x_offset;  // X offset for texture
  sint16_g y_offset;  // Y offset for texture

  char upper_tex[8];  // texture name for the part above
  char lower_tex[8];  // texture name for the part below
  char mid_tex[8];    // texture name for the regular part

  uint16_g sector;    // adjacent sector
}
raw_sidedef_t;


typedef struct raw_sector_s
{
  sint16_g floor_h;   // floor height
  sint16_g ceil_h;    // ceiling height

  char floor_tex[8];  // floor texture
  char ceil_tex[8];   // ceiling texture

  uint16_g light;     // light level (0-255)
  uint16_g special;   // special behaviour (0 = normal, 9 = secret, ...)
  sint16_g tag;       // sector activated by a linedef with same tag
}
raw_sector_t;


typedef struct raw_thing_s
{
  sint16_g x, y;      // position of thing
  sint16_g angle;     // angle thing faces (degrees)
  uint16_g type;      // type of thing
  uint16_g options;   // when appears, deaf, etc..
}
raw_thing_t;


// -JL- Hexen thing definition
typedef struct raw_hexen_thing_s
{
  sint16_g tid;       // thing tag id (for scripts/specials)
  sint16_g x, y;      // position
  sint16_g height;    // start height above floor
  sint16_g angle;     // angle thing faces
  uint16_g type;      // type of thing
  uint16_g options;   // when appears, deaf, dormant, etc..

  uint8_g special;    // special type
  uint8_g arg[5];     // special arguments
} 
raw_hexen_thing_t;

#define PO_ANCHOR_TYPE      3000
#define PO_SPAWN_TYPE       3001
#define PO_SPAWNCRUSH_TYPE  3002


/* ----- Class representations ---------------------- */

class sector_c;
class linedef_c;


class vertex_c
{
public:
  // coordinates
  double x, y;

  // vertex index.  Always valid after loading and pruning of unused
  // vertices has occurred.  For GL vertices, bit 30 will be set.
  int index;

  // linedefs that touch this vertex
  std::vector<linedef_c *> lines;

  vertex_c(int _idx, const raw_vertex_t *raw);
  vertex_c(int _idx, const raw_v2_vertex_t *raw);
  ~vertex_c();
};

#define IS_GL_VERTEX  (1 << 30)


class sector_c
{
public:
  // sector index.  Always valid after loading & pruning.
  int index;

  // heights
  int floor_h, ceil_h;
  int floor_under, ceil_over;

  // textures
  char floor_tex[10];
  char ceil_tex[10];

  // attributes
  int light;
  int special;
  int tag;

  std::vector<sector_c *> extrafloors;
  std::vector<linedef_c *>   ef_lines;

  std::vector<sector_c *> liquids;

  sector_c(int _idx, const raw_sector_t *raw);
  ~sector_c();
};


class sidedef_c
{
public:
  // adjacent sector.  Can be NULL (invalid sidedef)
  sector_c *sector;

  // offset values
  int x_offset, y_offset;

  // texture names
  char upper_tex[10];
  char lower_tex[10];
  char mid_tex[10];

  // sidedef index.  Always valid after loading & pruning.
  int index;

  sidedef_c(int _idx, const raw_sidedef_t *raw);
  ~sidedef_c();
};


class linedef_c
{
public:
  vertex_c *start;    // from this vertex...
  vertex_c *end;      // ... to this vertex

  sidedef_c *right;   // right sidedef
  sidedef_c *left;    // left sidede, or NULL if none

  // line is marked two-sided
  char two_sided;

  // zero length (line should be totally ignored)
  char zero_len;

  int flags;
  int type;
  int tag;

  // Hexen support
  int specials[5];

  // linedef index.  Always valid after loading & pruning of zero
  // length lines has occurred.
  int index;

  linedef_c(int _idx, const raw_linedef_t *raw);
  linedef_c(int _idx, const raw_hexen_linedef_t *raw);
  ~linedef_c();
};


class thing_c
{
public:
  int x, y;
  int type;
  int options;
  int angle;

  int height;  // Hexen field, height above ground

  // other info (hexen stuff) omitted. 

  // Always valid (thing indices never change).
  int index;

  thing_c(int _idx, const raw_thing_t *raw);
  thing_c(int _idx, const raw_hexen_thing_t *raw);
  ~thing_c();
};



/* ----- Level data arrays ----------------------- */

template <typename TYPE> class container_tp
{
public:
  int num;

private:
  TYPE ** arr;

  const char *const name;

public:
  container_tp(const char *type_name) : num(0), arr(NULL), name(type_name)
  {
  }
  
  ~container_tp()
  {
    if (arr)
      FreeAll();
  }

  void Allocate(int _num)
  {
    if (arr)
      FreeAll();

    num = _num;
    arr = new TYPE* [num];

    for (int i = 0; i < num; i++)
    {
      arr[i] = NULL;  
    }
  }

  void FreeAll()
  {
    for (int i = 0; i < num; i++)
    {
      if (arr[i] != NULL)
        delete arr[i];  
    }

    delete[] arr;

    num = 0;
    arr = NULL;
  }

  void Set(int index, TYPE *cur)
  {
    if (arr[index] != NULL)
      delete arr[index];

    arr[index] = cur;
  }

  TYPE *Get(int index)
  {
    if (index < 0 || index >= num)
    {
      FatalError("No such %s number #%d", name, index);
    }

    return arr[index];
  }
};

#define EXTERN_LEVELARRAY(TYPE, BASEVAR)  \
    extern container_tp<TYPE> BASEVAR;

EXTERN_LEVELARRAY(vertex_c,  lev_vertices)
EXTERN_LEVELARRAY(linedef_c, lev_linedefs)
EXTERN_LEVELARRAY(sidedef_c, lev_sidedefs)
EXTERN_LEVELARRAY(sector_c,  lev_sectors)
EXTERN_LEVELARRAY(thing_c,   lev_things)

/* ----- function prototypes ----------------------- */

// load all level data for the current level
void LoadLevel(const char *name);

// free all level data
void FreeLevel(void);




#endif /* __BRUSHER_LEVEL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
