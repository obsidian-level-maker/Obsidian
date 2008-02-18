//------------------------------------------------------------------------
//  LEVEL building - DUKE3D format
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

#ifndef __OBLIGE_DUKE3D_STRUCTS_H__
#define __OBLIGE_DUKE3D_STRUCTS_H__


/* ----- MAP structures ---------------------- */

typedef struct
{
  u32_t version;

  u32_t pos_x;
  u32_t pos_y;
  u32_t pos_z;

  u16_t angle;
  u16_t sector;
}
raw_map_header_t;

#define DUKE_MAP_VERSION  7


typedef struct
{
  u16_t wall_ptr;
  u16_t wall_num;

  s32_t ceil_h;
  s32_t floor_h;

  u16_t ceil_flags;
  u16_t floor_flags;

  u16_t ceil_pic;
  s16_t ceil_slope;

  s8_t ceil_shade;
  u8_t ceil_palette;
  u8_t ceil_xpan;
  u8_t ceil_ypan;

  u16_t floor_pic;
  s16_t floor_slope;

  s8_t floor_shade;
  u8_t floor_palette;
  u8_t floor_xpan;
  u8_t floor_ypan;

  u8_t visibility;
  u8_t _pad;

  u16_t lo_tag;
  u16_t hi_tag;
  u16_t extra;
}
raw_sector_t;

#define SECTOR_F_PARALLAX    (1 << 0)
#define SECTOR_F_SLOPED      (1 << 1)
#define SECTOR_F_SWAP_XY     (1 << 2)
#define SECTOR_F_FLIP_X      (1 << 4)
#define SECTOR_F_FLIP_Y      (1 << 5)


typedef struct
{
  s32_t x, y;

  u16_t right_wall;
  u16_t back_wall;
  u16_t back_sec;

  u16_t flags;

  u16_t pic[2];

  s8_t shade;
  u8_t palette;

  u8_t xscale, yscale;
  u8_t xpan,   ypan;

  u16_t lo_tag, hi_tag;
  u16_t extra;
}
raw_wall_t;

#define WALL_F_BLOCKING    (1 << 0)
#define WALL_F_GUN_BLOCK   (1 << 6)
#define WALL_F_PEG_BOTTOM  (1 << 2)
#define WALL_F_MASKED      (1 << 4)
#define WALL_F_ONE_WAY     (1 << 5)
#define WALL_F_FLIP_X      (1 << 3)
#define WALL_F_FLIP_Y      (1 << 8)


typedef struct
{
  s32_t x, y, z;

  u16_t flags;
  u16_t pic;

  s8_t shade;
  u8_t palette;
  u8_t clip_dist;
  u8_t _pad;

  u8_t xscale,  yscale;
  s8_t xoffset, yoffset;

  u16_t sector;
  u16_t status;
  u16_t angle;

  u16_t owner;
  u16_t xvel, yvel, zvel;
  u16_t lo_tag, hi_tag;
  u16_t extra;
}
raw_sprite_t;

#define SPRITE_F_BLOCKING    (1 << 0)
#define SPRITE_F_GUN_BLOCK   (1 << 8)
#define SPRITE_F_IS_WALL     (1 << 4)
#define SPRITE_F_IS_FLOOR    (1 << 5)
#define SPRITE_F_FLIP_X      (1 << 2)
#define SPRITE_F_FLIP_Y      (1 << 3)
#define SPRITE_F_INVISIBLE   (1 << 15)


#endif /* __OBLIGE_DUKE3D_STRUCTS_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
