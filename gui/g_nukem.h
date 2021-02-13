//------------------------------------------------------------------------
//  2.5D CSG : NUKEM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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

#ifndef __OBLIGE_NUKEM_LEVEL_H__
#define __OBLIGE_NUKEM_LEVEL_H__

void NK_AddSector(int first_wall, int num_wall, int visibility,
                  int f_h, int f_pic,
                  int c_h, int c_pic, int c_flags,
                  int lo_tag=0, int hi_tag=0);

void NK_AddWall(int x, int y, int right, int back, int back_sec, 
                int flags, int pic, int mask_pic,
                int xscale, int yscale, int xpan, int ypan,
                int lo_tag=0, int hi_tag=0);

void NK_AddSprite(int x, int y, int z, int sec,
                  int flags, int pic, int angle,
                  int lo_tag=0, int hi_tag=0);

int NK_NumSectors();
int NK_NumWalls();
int NK_NumSprites();


/* ----- MAP structures ---------------------- */

typedef struct
{
	u32_t version;

	s32_t pos_x;
	s32_t pos_y;
	s32_t pos_z;

	u16_t angle;
	u16_t sector;

} PACKEDATTR raw_nukem_map_t;

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

} PACKEDATTR raw_nukem_sector_t;

#define SECTOR_F_PARALLAX    (1 << 0)
#define SECTOR_F_SLOPED      (1 << 1)
#define SECTOR_F_RELATIVE    (1 << 6)

#define SECTOR_F_SWAP_XY     (1 << 2)
#define SECTOR_F_DOUBLED     (1 << 3)
#define SECTOR_F_FLIP_X      (1 << 4)
#define SECTOR_F_FLIP_Y      (1 << 5)


typedef struct
{
	s32_t x, y;

	u16_t right_wall;
	u16_t back_wall;
	u16_t back_sec;

	u16_t flags;

	u16_t pic;
	u16_t mask_pic;

	s8_t shade;
	u8_t palette;

	u8_t xscale, yscale;
	u8_t xpan,   ypan;

	u16_t lo_tag, hi_tag;
	u16_t extra;

} PACKEDATTR raw_nukem_wall_t;

#define WALL_F_BLOCKING    (1 << 0)
#define WALL_F_ONE_WAY     (1 << 5)
#define WALL_F_GUN_BLOCK   (1 << 6)

#define WALL_F_SWAP_LOWER  (1 << 1)
#define WALL_F_PEGGED      (1 << 2)
#define WALL_F_MASKED      (1 << 4)

#define WALL_F_FLIP_X      (1 << 3)
#define WALL_F_FLIP_Y      (1 << 8)

#define WALL_F_TRANS33     (1 << 7)
#define WALL_F_TRANS66     (1 << 9)  // requires TRANS33 too


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

} PACKEDATTR raw_nukem_sprite_t;

#define SPRITE_F_BLOCKING    (1 << 0)
#define SPRITE_F_SUBMERGED   (1 << 7)
#define SPRITE_F_GUN_BLOCK   (1 << 8)

#define SPRITE_F_TRANS33     (1 << 1)
#define SPRITE_F_TRANS66     (1 << 9)  // requires TRANS33 too
#define SPRITE_F_ONE_SIDED   (1 << 6)
#define SPRITE_F_INVISIBLE   (1 << 15)

#define SPRITE_F_IS_WALL     (1 << 4)
#define SPRITE_F_IS_FLOOR    (1 << 5)
#define SPRITE_F_FLIP_X      (1 << 2)
#define SPRITE_F_FLIP_Y      (1 << 3)


/* ----- ART structures ---------------------- */

typedef struct
{
	u32_t version;

	u32_t num_pics;
	u32_t first_pic;
	u32_t last_pic;

	// s16_t width[NUM_PICS];
	// s16_t height[NUM_PICS];
	// s32_t anim[NUM_PICS];

	// block_of_pixels_t pics[NUM_PICS];

} PACKEDATTR raw_art_header_t;


#endif /* __OBLIGE_NUKEM_LEVEL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
