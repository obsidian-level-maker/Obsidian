//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
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

  byte * samples;

  // for small maps, store data directly here
  byte data[SMALL_LIGHTMAP];

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
    return (width == 1 && height == 1);
  }

  void Fill(int value);

  inline void Set(int s, int t, int raw)
  {
    raw >>= 8;

    if (raw < 0)   raw = 0;
    if (raw > 255) raw = 255;

    samples[t * width + s] = raw;
  }

  void Store();  // transfer from blocklights[] array

  void CalcScore();

  void Flatten();

  void Write(qLump_c *lump);

  int CalcOffset() const;

private:
  void Store_Fast();
  void Store_Normal();
  void Store_Best();
};


/***** VARIABLES **********/

extern bool qk_color_lighting;

extern int qk_lighting_quality;


/***** FUNCTIONS **********/

void BSP_InitLightmaps();
void BSP_FreeLightmaps();

qLightmap_c * BSP_NewLightmap(int w, int h);

int QCOM_FlatLightOffset(int value);

void QCOM_BuildLightmap(int lump, int max_size);

void QCOM_LightAllFaces();


#endif /* __QUAKE_LIGHTING_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
