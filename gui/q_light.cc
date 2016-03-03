//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2012  Andrew Apted
//  Copyright (C) 1996-1997  Id Software, Inc.
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
//
//  Using various bits from the Quake1 'light' program source.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#include "csg_main.h"
#include "csg_quake.h"


#if 0  // fixme: quake defaults

#define DEFAULT_LIGHTLEVEL  150
#define DEFAULT_SUNLEVEL    30
#define DEFAULT_FACTOR      2.0  // radius multiplier

#else

#define DEFAULT_LIGHTLEVEL  192
#define DEFAULT_SUNLEVEL    208
#define DEFAULT_FACTOR      1.0

#endif


#define LOW_LIGHT  20


// 0 = normal, -1 = fast, +1 = best
int qk_lighting_quality;

bool qk_color_lighting;


qLightmap_c::qLightmap_c(int w, int h, int value) :
    width(w), height(h), num_styles(1), samples(data),
    offset(-1), score(-1), average(-1)
{
	if (width * height > SMALL_LIGHTMAP)
		samples = new byte[width * height];

	current_pos = samples;

	styles[0] = 0;
	styles[1] = styles[2] = styles[3] = 255;  // unused

	if (value >= 0)
		Fill(value);
}

qLightmap_c::~qLightmap_c()
{
	if (samples != data)
		delete[] samples;
}


void qLightmap_c::Fill(int value)
{
	for (int i = 0 ; i < width*height ; i++)
		samples[i] = value;
}


bool qLightmap_c::hasStyle(byte style) const
{
	if (style == 0)
		return true;

	return	(styles[1] == style) ||
			(styles[2] == style) ||
			(styles[3] == style);
}


bool qLightmap_c::AddStyle(byte style)
{
	SYS_ASSERT(! isFlat());

	if (num_styles > 4)
		return false;

	styles[num_styles] = style;

	byte *new_samples = new byte[width * height * (num_styles+1)];

	memcpy(new_samples, samples, width * height * num_styles);

	num_styles++;

	if (samples != data)
		delete[] samples;

	samples = new_samples;

	current_pos = samples + width * height * (num_styles-1);

	return true;
}


void qLightmap_c::CalcScore()
{
	// determine range and average
	int low  = data[0];
	int high = data[0];

	float avg = 0;

	for (int i = 0 ; i < width*height ; i++)
	{
		low  = MIN(low,  samples[i]);
		high = MAX(high, samples[i]);

		avg  += samples[i];
	}

	avg /= (float)(width * height);

	average = CLAMP(0, I_ROUND(avg), 255);

	// now calculate score
	score = (width * height) * 2 + (high - low);
}


void qLightmap_c::Flatten()
{
	if (isFlat())
		return;

	if (score < 0)
		CalcScore();

	width = height = 1;

	data[0] = average;

	if (samples != data)
	{
		delete[] samples;

		samples = data;
	}

	current_pos = NULL;
}


void qLightmap_c::Write(qLump_c *lump)
{
	if (isFlat())
		return;

	offset = lump->GetSize();

	int total = width * height * num_styles;

	if (! qk_color_lighting)
	{
		lump->Append(samples, total);
		return;
	}

	// convert to R/G/B triplets
	for (int i = 0 ; i < total ; i++)
	{
		lump->Append(&samples[i], 1);
		lump->Append(&samples[i], 1);
		lump->Append(&samples[i], 1);
	}
}


int qLightmap_c::CalcOffset() const
{
	if (isFlat())
	{
		int value = (int)samples[0];

		return QCOM_FlatLightOffset(CLAMP(0, value, 255));
	}
	else
	{
		return offset;
	}
}


//------------------------------------------------------------------------

static std::vector<qLightmap_c *> qk_all_lightmaps;

static qLump_c *lightmap_lump;


void QCOM_FreeLightmaps()
{
	for (unsigned int i = 0 ; i < qk_all_lightmaps.size() ; i++)
		delete qk_all_lightmaps[i];

	qk_all_lightmaps.clear();
}


int QCOM_FlatLightOffset(int value)
{
	SYS_ASSERT(0 <= value && value <= 255);

	if (value > 128)
	{
		value = 64 + value / 2;
	}

	if (qk_color_lighting)
		value *= 3;

	return value * FLAT_LIGHTMAP_SIZE;
}


qLightmap_c * QCOM_NewLightmap(int w, int h)
{
	qLightmap_c *lmap = new qLightmap_c(w, h);

	qk_all_lightmaps.push_back(lmap);

	return lmap;
}


static void WriteFlatBlock(int level, int count)
{
	byte datum = (byte)level;

	for ( ; count > 0 ; count--)
		lightmap_lump->Append(&datum, 1);
}


void QCOM_BuildLightingLump(int lump, int max_size)
{
	lightmap_lump = BSP_NewLump(lump);

	// at the start are a bunch of completely flat lightmaps.
	// for the overbright range (129-255) there are half as many.

	int i;
	int flat_size = FLAT_LIGHTMAP_SIZE * (qk_color_lighting ? 3 : 1);

	for (i = 0 ; i < 128 ; i++)
	{
		WriteFlatBlock(i, flat_size);
		max_size -= flat_size;
	}

	for (i = 128 ; i < 256 ; i += 2)
	{
		WriteFlatBlock(i, flat_size);
		max_size -= flat_size;
	}


	// from here on 'max_size' is in PIXELS (not bytes)
	if (qk_color_lighting)
		max_size /= 3;


	// FIXME !!!! : check if lump would overflow, if yes then flatten some maps


	for (unsigned int k = 0 ; k < qk_all_lightmaps.size() ; k++)
	{
		qLightmap_c *L = qk_all_lightmaps[k];

		L->Write(lightmap_lump);
	}
}


//------------------------------------------------------------------------

// Lighting variables

static quake_face_c *lt_face;

static double lt_plane_normal[3];
static double lt_plane_dist;

static double lt_texorg[3];
static double lt_worldtotex[2][3];
static double lt_textoworld[2][3];

static quake_bbox_c lt_face_bbox;

static int lt_W, lt_H;
static int lt_tex_mins[2];

static quake_vertex_c lt_points[18*18*4];

static int blocklights[18*18*4];  // * 4 for oversampling

static int lt_current_style;


static void CalcFaceVectors(quake_face_c *F)
{
	const quake_plane_c * plane = &F->node->plane;

	lt_plane_normal[0] = plane->nx;
	lt_plane_normal[1] = plane->ny;
	lt_plane_normal[2] = plane->nz;

	lt_plane_dist = plane->CalcDist();

	if (F->node_side == 1)
	{
		lt_plane_dist = -lt_plane_dist;

		for (int k = 0 ; k < 3 ; k++)
			lt_plane_normal[k] = -lt_plane_normal[k];
	}


	lt_worldtotex[0][0] = F->s[0];
	lt_worldtotex[0][1] = F->s[1];
	lt_worldtotex[0][2] = F->s[2];

	lt_worldtotex[1][0] = F->t[0];
	lt_worldtotex[1][1] = F->t[1];
	lt_worldtotex[1][2] = F->t[2];


	// calculate a normal to the texture axis.  points can be moved
	// along this without changing their S/T
	static quake_plane_c texnormal;

	texnormal.nx = F->s[2] * F->t[1] - F->s[1] * F->t[2];
	texnormal.ny = F->s[0] * F->t[2] - F->s[2] * F->t[0];
	texnormal.nz = F->s[1] * F->t[0] - F->s[0] * F->t[1];

	texnormal.Normalize();

	// flip it towards plane normal
	double distscale = texnormal.nx * lt_plane_normal[0] +
		texnormal.ny * lt_plane_normal[1] +
		texnormal.nz * lt_plane_normal[2];

	if (distscale < 0)
	{
		distscale = -distscale;
		texnormal.Flip();
	}

	// distscale is the ratio of the distance along the texture normal
	// to the distance along the plane normal
	distscale = 1.0 / distscale;

	for (int i = 0 ; i < 2 ; i++)
	{
		double len_sq = lt_worldtotex[i][0] * lt_worldtotex[i][0] +
						lt_worldtotex[i][1] * lt_worldtotex[i][1] +
						lt_worldtotex[i][2] * lt_worldtotex[i][2];

		double dist = lt_worldtotex[i][0] * lt_plane_normal[0] +
					  lt_worldtotex[i][1] * lt_plane_normal[1] +
					  lt_worldtotex[i][2] * lt_plane_normal[2];

		dist = dist * distscale / len_sq;

		lt_textoworld[i][0] = lt_worldtotex[i][0] - texnormal.nx * dist;
		lt_textoworld[i][1] = lt_worldtotex[i][1] - texnormal.ny * dist;
		lt_textoworld[i][2] = lt_worldtotex[i][2] - texnormal.nz * dist;
	}


	// calculate texorg on the texture plane
	lt_texorg[0] = - F->s[3] * lt_textoworld[0][0] - F->t[3] * lt_textoworld[1][0];
	lt_texorg[1] = - F->s[3] * lt_textoworld[0][1] - F->t[3] * lt_textoworld[1][1];
	lt_texorg[2] = - F->s[3] * lt_textoworld[0][2] - F->t[3] * lt_textoworld[1][2];

	// project back to the face plane

	// AJA: I assume the "- 1" here means the sampling points are 1 unit
	//      away from the face.
	double o_dist = lt_texorg[0] * lt_plane_normal[0] +
					lt_texorg[1] * lt_plane_normal[1] +
					lt_texorg[2] * lt_plane_normal[2] -
					lt_plane_dist - 1.0;

	o_dist *= distscale;

	lt_texorg[0] -= texnormal.nx * o_dist;
	lt_texorg[1] -= texnormal.ny * o_dist;
	lt_texorg[2] -= texnormal.nz * o_dist;
}


static void CalcFaceExtents(quake_face_c *F)
{
	double min_s, min_t;
	double max_s, max_t;

	F->GetBounds(&lt_face_bbox);

	F->ST_Bounds(&min_s, &min_t, &max_s, &max_t);

///  lt_face_mid_s = (min_s + max_s) / 2.0;
///  lt_face_mid_t = (min_t + max_t) / 2.0;

	// -AJA- this matches the logic in the Quake engine.

	int bmin_s = (int)floor(min_s / 16.0);
	int bmin_t = (int)floor(min_t / 16.0);

	int bmax_s = (int)ceil(max_s / 16.0);
	int bmax_t = (int)ceil(max_t / 16.0);

	lt_tex_mins[0] = bmin_s;
	lt_tex_mins[1] = bmin_t;

	lt_W = MAX(2, bmax_s - bmin_s + 1);
	lt_H = MAX(2, bmax_t - bmin_t + 1);

/// fprintf(stderr, "FACE %p  EXTENTS %d %d\n", F, lt_W, lt_H);
}


static void CalcPoints()
{
	float s_start = lt_tex_mins[0] * 16.0;
	float t_start = lt_tex_mins[1] * 16.0;

	float s_step = 16.0;
	float t_step = 16.0;

	if (qk_lighting_quality > 0)  // "best" mode
	{
		s_step = 16 * (lt_W - 1) / (float)(lt_W*2 - 1);
		t_step = 16 * (lt_H - 1) / (float)(lt_H*2 - 1);

		lt_W *= 2;
		lt_H *= 2;
	}
	else if (qk_lighting_quality < 0)  // "fast" mode, 2x2 or 3x3 grid
	{
		s_step = 16 * (lt_W - 1);
		t_step = 16 * (lt_H - 1);

		if (lt_W < 5) lt_W = 2; else { lt_W = 3;  s_step /= 2.0; }
		if (lt_H < 5) lt_H = 2; else { lt_H = 3;  t_step /= 2.0; }
	}


	for (int t = 0 ; t < lt_H ; t++)
	for (int s = 0 ; s < lt_W ; s++)
	{
		float us = s_start + s * s_step;
		float ut = t_start + t * t_step;

		quake_vertex_c & V = lt_points[t * lt_W + s];

		V.x = lt_texorg[0] + lt_textoworld[0][0]*us + lt_textoworld[1][0]*ut;
		V.y = lt_texorg[1] + lt_textoworld[0][1]*us + lt_textoworld[1][1]*ut;
		V.z = lt_texorg[2] + lt_textoworld[0][2]*us + lt_textoworld[1][2]*ut;

		// TODO: adjust points which are inside walls
	}
}


static void ClearLightBuffer(int level)
{
	int total = lt_W * lt_H;

	for (int k = 0 ; k < total ; k++)
		blocklights[k] = level << 8;
}


void qLightmap_c::Store_Normal()
{
	const int *src   = &blocklights[0];
	const int *s_end = src + (width * height);

	byte *dest = current_pos;

	while (src < s_end)
	{
		int raw = *src++ >> 8;

		if (raw < 0)   raw = 0;
		if (raw > 255) raw = 255;

		*dest++ = raw;
	}
}


void qLightmap_c::Store_Fast()
{
	int W = width;
	int H = height;

	// the "super fast" mode uses a 2x2 or 3x3 grid.
	// result is just a bilinearly scaled version of that.

	for (int t = 0 ; t < H ; t++)
	for (int s = 0 ; s < W ; s++)
	{
		int bs = s * (lt_W-1) / W;
		int bt = t * (lt_H-1) / H;

		float xc = s * (lt_W-1) / (float)W - bs;
		float yc = t * (lt_H-1) / (float)H - bt;

		float value = (1-xc) * (1-yc) * blocklights[bt * lt_W + bs]
					+    xc  * (1-yc) * blocklights[bt * lt_W + bs + 1]
					+ (1-xc) *    yc  * blocklights[bt * lt_W + lt_W + bs]
					+    xc  *    yc  * blocklights[bt * lt_W + lt_W + bs + 1];

		Set(s, t, (int)value);
	}
}


void qLightmap_c::Store_Best()
{
	// the "best" mode visits 4 times as many points as normal,
	// then computes the average of each 2x2 block.

	int W = width;
	int H = height;

	for (int t = 0 ; t < H ; t++)
	for (int s = 0 ; s < W ; s++)
	{
		int value = blocklights[(t*2 + 0) * lt_W + (s*2 + 0)] +
					blocklights[(t*2 + 0) * lt_W + (s*2 + 1)] +
					blocklights[(t*2 + 1) * lt_W + (s*2 + 0)] +
					blocklights[(t*2 + 1) * lt_W + (s*2 + 1)];

		Set(s, t, value >> 2);
	}
}


void qLightmap_c::Store()
{
	switch (qk_lighting_quality)
	{
		case -1: Store_Fast();    break;
		case  0: Store_Normal();  break;
		case +1: Store_Best();    break;

		default:
				 Main_FatalError("INTERNAL ERROR: qk_lighting_quality = %d\n", qk_lighting_quality);
				 break;  /* NOT REACHED */
	}
}


//------------------------------------------------------------------------


std::vector<quake_light_t> qk_all_lights;


void QCOM_FreeLights()
{
	qk_all_lights.clear();
}


void QCOM_FindLights()
{
	QCOM_FreeLights();

	for (unsigned int i = 0 ; i < all_entities.size() ; i++)
	{
		csg_entity_c *E = all_entities[i];

		quake_light_t light;

		if (E->Match("light"))
			light.kind = LTK_Normal;
		else if (E->Match("oblige_sun"))
			light.kind = LTK_Sun;
		else
			continue;

		light.x = E->x;
		light.y = E->y;
		light.z = E->z;

		float default_level = (light.kind == LTK_Sun) ? DEFAULT_SUNLEVEL : DEFAULT_LIGHTLEVEL;

		float level  = E->props.getDouble("light", default_level);

		light.factor = E->props.getDouble("factor", DEFAULT_FACTOR);
		light.radius = level * light.factor;

		if (level < 1 || light.radius < 1)
			continue;

		light.level = (int) (level * (1 << 8));
		light.style = E->props.getInt("style", 0);

		qk_all_lights.push_back(light);
	}
}


static inline void Bump(int s, int t, int W, int value)
{
	blocklights[t * W + s] += value;
}


static void QCOM_ProcessLight(qLightmap_c *lmap, quake_light_t & light, int pass)
{
	// first pass is normal lights, other passes are for styled lights
	if (pass == 0)
	{
		if (light.style)
			return;
	}
	else
	{
		if (light.style == 0)
			return;

		// skip light if we processed that style in an earlier pass
		if (lt_current_style < 0 && lmap->hasStyle(light.style))
			return;

		// skip light unless it matches the current style
		if (lt_current_style > 0 && light.style != lt_current_style)
			return;
	}

	// skip lights which are behind the face
	float perp = lt_plane_normal[0] * light.x +
		lt_plane_normal[1] * light.y +
		lt_plane_normal[2] * light.z - lt_plane_dist;

	if (perp <= 0)
		return;

	// skip lights which are too far away
	if (light.kind == LTK_Sun)
	{
		SYS_ASSERT(lt_face->leaf);

		if (lt_face->leaf->cluster &&
				lt_face->leaf->cluster->ambient_dists[AMBIENT_SKY] > 4)
			return;
	}
	else
	{
		if (perp > light.radius)
			return;

		if (! lt_face_bbox.Touches(light.x, light.y, light.z, light.radius))
			return;
	}


	bool hit_it = false;

	for (int t = 0 ; t < lt_H ; t++)
	for (int s = 0 ; s < lt_W ; s++)
	{
		const quake_vertex_c & V = lt_points[t * lt_W + s];

		if (! QCOM_TraceRay(V.x, V.y, V.z, light.x, light.y, light.z))
			continue;

		hit_it = true;

		if (light.kind == LTK_Sun)
		{
			Bump(s, t, lt_W, light.level);
		}
		else
		{
			float dist = ComputeDist(V.x, V.y, V.z, light.x, light.y, light.z);

			if (dist < light.radius)
			{
				int value = light.level * (1.0 - dist / light.radius);

				Bump(s, t, lt_W, value);
			}
		}
	}

	// don't create a new style in the lightmap if the light never
	// touched the face (e.g. when on the other side of a wall).

	if (! hit_it)
		return;

	if (lt_current_style < 0)
	{
		lt_current_style = light.style;

		lmap->AddStyle(light.style);
	}
}


void QCOM_LightFace(quake_face_c *F)
{
	lt_face = F;

	CalcFaceVectors(F);
	CalcFaceExtents(F);

	F->lmap = QCOM_NewLightmap(lt_W, lt_H);

	CalcPoints();

	for (int pass = 0 ; pass < 4 ; pass++)
	{
		lt_current_style = (pass == 0) ? 0 : -1;

		ClearLightBuffer(pass ? 0 : LOW_LIGHT);

		for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
		{
			QCOM_ProcessLight(F->lmap, qk_all_lights[i], pass);
		}

		if (lt_current_style >= 0)
			F->lmap->Store();
	}
}


void QLIT_TestingStuff(qLightmap_c *lmap)
{
	int W = lmap->width;
	int H = lmap->height;

	for (int t = 0 ; t < H ; t++)
	for (int s = 0 ; s < W ; s++)
	{
		const quake_vertex_c & V = lt_points[t*W + s];

		lmap->samples[t*W + s] = 80 + 40 * sin(V.z / 40.0);

	//  lmap->samples[t*W + s] = QCOM_TraceRay(V.x,V.y,V.z, 2e5,4e5,3e5) ? 80 : 40;
	}
}


void QCOM_LightMapModel(quake_mapmodel_c *model)
{
	float value = LOW_LIGHT;

	float mx = (model->x1 + model->x2) / 2.0;
	float my = (model->y1 + model->y2) / 2.0;
	float mz = (model->z1 + model->z2) / 2.0;

	for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
	{
		quake_light_t & light = qk_all_lights[i];

		if (! QCOM_TraceRay(mx, my, mz, light.x, light.y, light.z))
			continue;

		if (light.kind == LTK_Sun)
		{
			value += light.level;
		}
		else
		{
			float dist = ComputeDist(mx, my, mz, light.x, light.y, light.z);

			if (dist < light.radius)
			{
				value += light.level * (1.0 - dist / light.radius);
			}
		}
	}

	model->light = CLAMP(0, I_ROUND(value), 255);
}


void QCOM_LightAllFaces()
{
	LogPrintf("\nLighting World...\n");

	QCOM_FindLights();

	LogPrintf("found %u lights\n", qk_all_lights.size());

	QCOM_MakeTraceNodes();

	int lit_faces  = 0;
	int lit_luxels = 0;

	for (unsigned int i = 0 ; i < qk_all_faces.size() ; i++)
	{
		quake_face_c *F = qk_all_faces[i];    

		if (F->flags & (FACE_F_Sky | FACE_F_Liquid))
			continue;

		QCOM_LightFace(F);

		lit_faces++;
		lit_luxels += F->lmap->width * F->lmap->height;

		if (lit_faces % 400 == 0)
		{
			Main_Ticker();

			if (main_action >= MAIN_CANCEL)
				break;

			// fprintf(stderr, "lit %d faces (of %u)\n", lit_faces, qk_all_faces.size());
		}
	}

	LogPrintf("lit %d faces (of %u) using %d luxels\n",
			lit_faces, qk_all_faces.size(), lit_luxels);

// TODO: map models
#if 0
	for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
	{
		QCOM_LightMapModel(qk_all_mapmodels[i]);
	}
#endif

	QCOM_FreeLights();
	QCOM_FreeTraceNodes();
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
