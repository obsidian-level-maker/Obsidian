//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2012 Andrew Apted
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

#ifndef __QUAKE_LIGHTING_H__
#define __QUAKE_LIGHTING_H__

class quake_face_c;


// the maximum size of a face's lightmap in Quake I/II
#define FLAT_LIGHTMAP_SIZE  (17*17)


#define SMALL_LIGHTMAP  16

class qLightmap_c
{
public:
	int width, height;
	int num_styles;

	byte * samples;
	byte * current_pos;

	// for small maps, store data directly here
	byte data[SMALL_LIGHTMAP];

	byte styles[4];

	// final offset in lightmap lump (if not flat)
	int offset;

	// these not valid until CalcScore()
	int score;
	int average;

public:
	qLightmap_c(int w, int h, int value = -1);

	~qLightmap_c();

	inline bool isFlat() const
	{
		return (width == 1 && height == 1 && num_styles == 1);
	}

	void Fill(int value);

	inline void Set(int s, int t, int raw)
	{
		raw >>= 8;

		if (raw < 0)   raw = 0;
		if (raw > 255) raw = 255;

		current_pos[t * width + s] = raw;
	}

	bool hasStyle(byte style) const;

	// returns false if too many styles
	bool AddStyle(byte style);

	// transfer from blocklights[] array
	void Store();

	void CalcScore();

	void Flatten();

	void Write(qLump_c *lump);

	int CalcOffset() const;

private:
	void Store_Fast();
	void Store_Normal();
	void Store_Best();
};


typedef enum
{
  LTK_Normal = 0,
  LTK_Sun,
}
quake_light_kind_e;


typedef struct
{
	int kind;

	float x, y, z;
	float radius;
	float factor;

	int level;  // 16.8 fixed point
	int style;
}
quake_light_t;


/***** VARIABLES **********/

extern bool qk_color_lighting;

extern int qk_lighting_quality;

extern std::vector<quake_light_t> qk_all_lights;


/***** FUNCTIONS **********/

void QCOM_FindLights();
void QCOM_FreeLights();

void QCOM_FreeLightmaps();

int QCOM_FlatLightOffset(int value);

void QCOM_BuildLightingLump(int lump, int max_size);

void QCOM_LightAllFaces();


#endif /* __QUAKE_LIGHTING_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
