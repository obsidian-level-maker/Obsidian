//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017  Andrew Apted
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


#if 1  // fixme: quake defaults

#define DEFAULT_LIGHTLEVEL  150
#define DEFAULT_SUNLEVEL    30
#define DEFAULT_FACTOR      2.0  // radius multiplier

#else

#define DEFAULT_LIGHTLEVEL  192
#define DEFAULT_SUNLEVEL    208
#define DEFAULT_FACTOR      1.0

#endif


#define WHITE	MAKE_RGBA(255, 255, 255, 0)

#define LOW_LIGHT  8

float q3_LUXEL_SIZE = 12.0;


// 0 = normal, -1 = fast, +1 = best
int qk_lighting_quality;

bool qk_color_lighting;


qLightmap_c::qLightmap_c(int w, int h, int value) :
	width(w), height(h), num_styles(1), samples(),
	offset(-1), lx(-1), ly(-1),
	average(-1)
{
	lm_mat = new uv_matrix_c;

	samples = new rgb_color_t[width * height];

	current_pos = samples;

	styles[0] = 0;
	styles[1] = styles[2] = styles[3] = 255;  // unused

	if (value >= 0)
		Fill(value);
}

qLightmap_c::~qLightmap_c()
{
	delete lm_mat;

	delete[] samples;
}


void qLightmap_c::Fill(rgb_color_t value)
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
	if (num_styles > 4)
		return false;

	styles[num_styles] = style;

	rgb_color_t *new_samples = new rgb_color_t[width * height * (num_styles+1)];

	memcpy(new_samples, samples, width * height * num_styles * sizeof(rgb_color_t));

	num_styles++;

	delete[] samples;

	samples = new_samples;

	current_pos = samples + width * height * (num_styles-1);

	return true;
}


void qLightmap_c::CalcAverage()
{
	float avg_r = 0;
	float avg_g = 0;
	float avg_b = 0;

	for (int i = 0 ; i < width*height ; i++)
	{
		const rgb_color_t col = samples[i];

		avg_r += RGB_RED(col);
		avg_g += RGB_GREEN(col);
		avg_b += RGB_BLUE(col);
	}

	avg_r /= (float)(width * height);
	avg_g /= (float)(width * height);
	avg_b /= (float)(width * height);

	byte new_r = CLAMP(0, I_ROUND(avg_r), 255);
	byte new_g = CLAMP(0, I_ROUND(avg_g), 255);
	byte new_b = CLAMP(0, I_ROUND(avg_b), 255);

	average = MAKE_RGBA(new_r, new_g, new_b, 0);
}


void qLightmap_c::Write(qLump_c *lump)
{
	// (this only used for Q1 and Q2, not Q3)

	// grab the offset now...
	offset = lump->GetSize();

	int total = width * height * num_styles;

	for (int i = 0 ; i < total ; i++)
	{
		const rgb_color_t col = samples[i];

		byte val = RGB_GREEN(col);  // FIXME

		lump->Append(&val, 1);

		if (qk_color_lighting)  // Q2
		{
			lump->Append(&val, 1);
			lump->Append(&val, 1);
		}
	}
}


//------------------------------------------------------------------------

#define LIGHTMAP_WIDTH    128
#define LIGHTMAP_HEIGHT   128

class q3_lightmap_block_c
{
public:
	byte samples[LIGHTMAP_WIDTH][LIGHTMAP_HEIGHT][3];

	// index of first free luxel in each column of this block.
	// hence 0 is completely empty, LIGHTMAP_HEIGHT is completely full.
	int free_y[LIGHTMAP_WIDTH];

	int fail_count;

public:
	q3_lightmap_block_c() : fail_count(0)
	{
		memset(samples, 0, sizeof(samples));

		for (int i = 0 ; i < LIGHTMAP_WIDTH ; i++)
			free_y[i] = 0;
	}

	~q3_lightmap_block_c()
	{ }

	int Low_Y(int x, int w)
	{
		int y = 0;

		for ( ; w > 0 ; x++, w--)
			y = MAX(y, free_y[x]);

		return y;
	}

	int WastedArea(int x, int y, int w)
	{
		int area = 0;

		for ( ; w > 0 ; x++, w--)
			area += (y - free_y[x]);

		return area;
	}

	// attempt to allocate a block
	bool Alloc(int bw, int bh, int *bx, int *by)
	{
#if 0
		// skip when failure count reaches a certain limit
		if (fail_count & 64)
			return false;
#endif

		*bx = -1;
		*by = -1;

		int best_area = (1 << 30);

		// find column that will waste the least amount of space

		for (int x = 0 ; x < LIGHTMAP_WIDTH - bw + 1 ; x++)
		{
			int y = Low_Y(x, bw);

			if (y + bh > LIGHTMAP_HEIGHT)
				continue;

			int area = WastedArea(x, y, bw);

			if (area < best_area)
			{
				*bx = x;
				*by = y;

				best_area = area;
			}
		}

		if (*bx < 0)
		{
			fail_count++;
			return false;
		}

		// mark area as used

		for (int i = 0 ; i < bw ; i++)
		{
			free_y[*bx + i] = *by + bh;
		}

		return true;  // Ok
	}

	void Copy(qLightmap_c *lmap)
	{
		for (int y = 0 ; y < lmap->height ; y++)
		for (int x = 0 ; x < lmap->width  ; x++)
		{
			const rgb_color_t col = lmap->At(x, y);

			samples[lmap->lx + x][lmap->ly + y][0] = RGB_RED(col);
			samples[lmap->lx + x][lmap->ly + y][1] = RGB_GREEN(col);
			samples[lmap->lx + x][lmap->ly + y][2] = RGB_BLUE(col);
		}
	}

	void Write(qLump_c *lump) const
	{
		for (int y = 0 ; y < LIGHTMAP_HEIGHT ; y++)
		for (int x = 0 ; x < LIGHTMAP_WIDTH  ; x++)
		for (int c = 0 ; c < 3 ; c++)
		{
			lump->Append(&samples[x][y][c], 1);
		}
	}

	void SavePPM(FILE *fp)
	{
		fprintf(fp, "P6\n");
		fprintf(fp, "128 128\n");
		fprintf(fp, "255\n");

		for (int y = 0 ; y < LIGHTMAP_HEIGHT ; y++)
		for (int x = 0 ; x < LIGHTMAP_WIDTH  ; x++)
		for (int c = 0 ; c < 3 ; c++)
		{
			fputc(samples[x][y][c], fp);
		}
	}
};


static std::vector< q3_lightmap_block_c * > all_q3_light_blocks;


static int Q3_AllocLightBlock(int bw, int bh, int *bx, int *by)
{
	// returns the block index numebr

	SYS_ASSERT(bw <= LIGHTMAP_WIDTH);
	SYS_ASSERT(bh <= LIGHTMAP_HEIGHT);

	for (unsigned int k = 0 ; k < all_q3_light_blocks.size() ; k++)
	{
		q3_lightmap_block_c *BL = all_q3_light_blocks[k];

		if (BL->Alloc(bw, bh, bx, by))
			return (int)k;
	}

	// it did not fit in any existing block, create a new block

	int bnum = (int)all_q3_light_blocks.size();

	q3_lightmap_block_c *BL = new q3_lightmap_block_c;

	all_q3_light_blocks.push_back(BL);

	if (! BL->Alloc(bw, bh, bx, by))
		Main_FatalError("INTERNAL ERROR: failed to alloc LM in fresh block\n");

	return bnum;
}


//------------------------------------------------------------------------

static std::vector<qLightmap_c *> qk_all_lightmaps;

static qLump_c *lightmap_lump;


void QCOM_FreeLightmaps()
{
	for (unsigned int i = 0 ; i < qk_all_lightmaps.size() ; i++)
		delete qk_all_lightmaps[i];

	qk_all_lightmaps.clear();

	if (qk_game >= 3)
	{
		for (unsigned int k = 0 ; k < all_q3_light_blocks.size() ; k++)
			delete all_q3_light_blocks[k];

		all_q3_light_blocks.clear();
	}
}


static qLightmap_c * QCOM_NewLightmap(int w, int h)
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
	// (this is for Q1 and Q2 only)

	lightmap_lump = BSP_NewLump(lump);

	// at the start a single completely flat lightmap for map-models
	// [ this is horrible, should have proper lightmap ]

	int flat_size = FLAT_LIGHTMAP_SIZE * (qk_color_lighting ? 3 : 1);

	WriteFlatBlock(64, flat_size);

	max_size -= flat_size;

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


void QCOM_BuildQ3Lighting(int lump, int max_size)
{
	// pack individual lightmaps into the 128x128 blocks
	// [ this is lousy for memory usage.... ]

	for (unsigned int k = 0 ; k < qk_all_lightmaps.size() ; k++)
	{
		qLightmap_c *L = qk_all_lightmaps[k];

		SYS_ASSERT(L->offset >= 0);

		q3_lightmap_block_c *BL = all_q3_light_blocks[L->offset];
		SYS_ASSERT(BL);

		BL->Copy(L);
	}

	lightmap_lump = BSP_NewLump(lump);

	for (unsigned int b = 0 ; b < all_q3_light_blocks.size() ; b++)
	{
		q3_lightmap_block_c *BL = all_q3_light_blocks[b];

		BL->Write(lightmap_lump);
	}
}


//------------------------------------------------------------------------

// Lighting variables

static quake_face_c *lt_face;

static double lt_plane_normal[3];
static double lt_plane_dist;

static quake_bbox_c lt_face_bbox;

static int lt_W, lt_H;

static int lt_current_style;

#define MAX_LM_SIZE  64
#define MAX_EXTRAS   4	// oversampling

static quake_vertex_c lt_points[MAX_LM_SIZE * MAX_LM_SIZE * MAX_EXTRAS];

static int blocklights[MAX_LM_SIZE * MAX_LM_SIZE * MAX_EXTRAS][3];


static void Q1_CalcFaceStuff(quake_face_c *F)
{
	lt_plane_normal[0] = F->plane.nx;
	lt_plane_normal[1] = F->plane.ny;
	lt_plane_normal[2] = F->plane.nz;

	lt_plane_dist = F->plane.CalcDist();


	/* Calc Vectors... */

	double lt_texorg[3];
	double lt_worldtotex[2][3];
	double lt_textoworld[2][3];

	const uv_matrix_c *UV = &F->uv_mat;


	lt_worldtotex[0][0] = UV->s[0];
	lt_worldtotex[0][1] = UV->s[1];
	lt_worldtotex[0][2] = UV->s[2];

	lt_worldtotex[1][0] = UV->t[0];
	lt_worldtotex[1][1] = UV->t[1];
	lt_worldtotex[1][2] = UV->t[2];


	// calculate a normal to the texture axis.  points can be moved
	// along this without changing their S/T
	static quake_plane_c texnormal;

	texnormal.nx = UV->s[2] * UV->t[1] - UV->s[1] * UV->t[2];
	texnormal.ny = UV->s[0] * UV->t[2] - UV->s[2] * UV->t[0];
	texnormal.nz = UV->s[1] * UV->t[0] - UV->s[0] * UV->t[1];

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
	lt_texorg[0] = - UV->s[3] * lt_textoworld[0][0] - UV->t[3] * lt_textoworld[1][0];
	lt_texorg[1] = - UV->s[3] * lt_textoworld[0][1] - UV->t[3] * lt_textoworld[1][1];
	lt_texorg[2] = - UV->s[3] * lt_textoworld[0][2] - UV->t[3] * lt_textoworld[1][2];

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


	/* Calc Extents... */

	int lt_tex_mins[2];

	double min_s, min_t;
	double max_s, max_t;

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

	F->lmap = QCOM_NewLightmap(lt_W, lt_H);


	/* Calc Points... */

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


static void Q3_CalcFaceStuff(quake_face_c *F)
{
	float px = F->plane.x;
	float py = F->plane.y;
	float pz = F->plane.z;

	float nx = F->plane.nx;
	float ny = F->plane.ny;
	float nz = F->plane.nz;

	// this is constant for every vertex on the face
	// [ i.e. vert[i] * N == n_dist, where '*' is dot product ]
	double n_dist = px * nx + py * ny + pz * nz;

	lt_plane_normal[0] = nx;
	lt_plane_normal[1] = ny;
	lt_plane_normal[2] = nz;

	lt_plane_dist = F->plane.CalcDist();

	// compute T vector that basically goes "up" the slope of the
	// face's plane.  If the plane is purely vertical, direction of
	// T is simply straight up.  If plane is purely horizontal,
	// then T is arbitrary, so we choose NORTH.

	double tx, ty, tz;

	double xy_len = hypot(nx, ny);

	if (xy_len < 0.001)
	{
		tx =  0.0;
		ty = +1.0;
		tz =  0.0;
	}
	else
	{
		tx = -nz * (nx / xy_len);
		ty = -nz * (ny / xy_len);
		tz = xy_len;
	}

	// computing S is easy now, it is simply the cross-product
	// of T and the plane normal.

	double sx = ty * nz - tz * ny;
	double sy = tz * nx - tx * nz;
	double sz = tx * ny - ty * nx;

	// once here: N, T and S are three unit vectors which are
	// orthogonal to each other.

fprintf(stderr, "Face %p\n", F);
fprintf(stderr, "  n = (%+5.4f %+5.4f %+5.4f)\n", nx, ny, nz);
fprintf(stderr, "  t = (%+5.4f %+5.4f %+5.4f)\n", tx, ty, tz);
fprintf(stderr, "  s = (%+5.4f %+5.4f %+5.4f)\n", sx, sy, sz);

	// compute extents in the ST space...

	double min_s = +9e9;
	double max_s = -9e9;

	double min_t = +9e9;
	double max_t = -9e9;

	for (unsigned int k = 0 ; k < F->verts.size() ; k++)
	{
		const quake_vertex_c *V = &F->verts[k];

		double s = V->x * sx + V->y * sy + V->z * sz;

		min_s = MIN(min_s, s);
		max_s = MAX(max_s, s);

		double t = V->x * tx + V->y * ty + V->z * tz;

		min_t = MIN(min_t, t);
		max_t = MAX(max_t, t);
	}

fprintf(stderr, "  t range: %+8.2f .. %+8.2f\n", min_t, max_t);
fprintf(stderr, "  s range: %+8.2f .. %+8.2f\n", min_s, max_s);

#if 0  // DEBUG
	for (unsigned int k = 0 ; k < F->verts.size() ; k++)
	{
		const quake_vertex_c *V = &F->verts[k];

		double s = V->x * sx + V->y * sy + V->z * sz;
		double t = V->x * tx + V->y * ty + V->z * tz;

		// reverse mapping, ST --> vertex
		double xx = s * sx + t * tx + n_dist * nx;
		double yy = s * sy + t * ty + n_dist * ny;
		double zz = s * sz + t * tz + n_dist * nz;

		s = (s - min_s) / q3_LUXEL_SIZE;
		t = (s - min_t) / q3_LUXEL_SIZE;

		fprintf(stderr, "  st coord (%+5.3f %+5.3f)\n", s, t);
		fprintf(stderr, "   from: (%+7.2f %+7.2f %+7.2f)\n", V->x, V->y, V->z);
//		fprintf(stderr, "     to: (%+7.2f %+7.2f %+7.2f)\n", xx, yy, zz);
//		fprintf(stderr, "  Error: %7.3f\n", fabs(V->x - xx) + fabs(V->y - yy) + fabs(V->z - zz));
	}
#endif

	// compute size of lightmap
	lt_W = (int)ceil((max_s - min_s) / q3_LUXEL_SIZE - 0.1);
	lt_H = (int)ceil((max_t - min_t) / q3_LUXEL_SIZE - 0.1);

fprintf(stderr, "LM SIZE: %d x %d\n", lt_W, lt_H);

	lt_W = CLAMP(1, lt_W, MAX_LM_SIZE);
	lt_H = CLAMP(1, lt_H, MAX_LM_SIZE);

	F->lmap = QCOM_NewLightmap(lt_W, lt_H);

	F->lmap->offset = Q3_AllocLightBlock(lt_W, lt_H, &F->lmap->lx, &F->lmap->ly);

fprintf(stderr, "LM POSITION: (%3d %3d)\n", F->lmap->lx, F->lmap->ly);


	// create the points...

	const float away = 0.5;

	for (int py = 0 ; py < lt_H ; py++)
	for (int px = 0 ; px < lt_W ; px++)
	{
		float ax = (px * 2 + 1) / (float)(lt_W * 2 + 1);
		float ay = (py * 2 + 1) / (float)(lt_H * 2 + 1);

		double s = min_s + (max_s - min_s) * ax;
		double t = min_t + (max_t - min_t) * ay;

		quake_vertex_c & V = lt_points[py * lt_W + px];

		V.x = s * sx + t * tx + (n_dist + away) * nx;
		V.y = s * sy + t * ty + (n_dist + away) * ny;
		V.z = s * sz + t * tz + (n_dist + away) * nz;

///	fprintf(stderr, "point [%02d %02d] --> (%+7.2f %+7.2f %+7.2f)\n",
///			px, py, V.x, V.y, V.z);
	}


	// compute the UV matrix...

	uv_matrix_c *mat = F->lmap->lm_mat;

	double s1 = (F->lmap->lx + 0.5) / (double)LIGHTMAP_WIDTH;
	double t1 = (F->lmap->ly + 0.5) / (double)LIGHTMAP_HEIGHT;

	double s2 = (F->lmap->lx + lt_W - 0.5) / (double)LIGHTMAP_WIDTH;
	double t2 = (F->lmap->ly + lt_H - 0.5) / (double)LIGHTMAP_HEIGHT;

	fprintf(stderr, "want S range: %+1.7f .. %+1.7f\n", s1, s2);
	fprintf(stderr, "want T range: %+1.7f .. %+1.7f\n", t1, t2);

	double s_mul = (s2 - s1) / (max_s - min_s);
	double t_mul = (t2 - t1) / (max_t - min_t);

	mat->s[0] = s_mul * sx;
	mat->s[1] = s_mul * sy;
	mat->s[2] = s_mul * sz;
	mat->s[3] = s_mul * -min_s + s1;

	mat->t[0] = t_mul * tx;
	mat->t[1] = t_mul * ty;
	mat->t[2] = t_mul * tz;
	mat->t[3] = t_mul * -min_t + t1;


#if 0  // DEBUG
	for (unsigned int k = 0 ; k < F->verts.size() ; k++)
	{
		const quake_vertex_c *V = &F->verts[k];

		double s = mat->Calc_S(V->x, V->y, V->z);
		double t = mat->Calc_T(V->x, V->y, V->z);

		fprintf(stderr, "  LM coord (%+7.6f %+7.6f)\n", s, t);
	}
#endif
}


static void ClearLightBuffer(int level)
{
	int total = lt_W * lt_H;

	level <<= 8;

	for (int k = 0 ; k < total ; k++)
	{
		blocklights[k][0] = level;
		blocklights[k][1] = level;
		blocklights[k][2] = level;
	}
}


void qLightmap_c::Store_Normal()
{
	rgb_color_t *dest = current_pos;

	for (int k = 0 ; k < width * height ; k++)
	{
		float r = blocklights[k][0] / 2000.0;
		float g = blocklights[k][1] / 2000.0;
		float b = blocklights[k][2] / 2000.0;

		float ity = MAX(r, MAX(g, b));

		if (ity > 127)
		{
			ity = 127.0 / ity;

			r *= ity;
			g *= ity;
			b *= ity;
		}

		byte r2 = r;
		byte g2 = g;
		byte b2 = b;

		*dest++ = MAKE_RGBA(r2, g2, b2, 0);
	}
}


void qLightmap_c::Store_Fast()
{
// FIXME
#if 0
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
#endif
}


void qLightmap_c::Store_Best()
{
// FIXME
#if 0
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
#endif
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


static rgb_color_t ParseColorString(const char *name)
{
	if (! name || name[0] == 0)
		return WHITE;

	if (name[0] != '#')
	{
		LogPrintf("WARNING: bad color string for light: '%s'\n", name);
		return WHITE;
	}

	int raw_hex = strtol(name + 1, NULL, 16);
	int r=0, g=0, b=0;

	if (strlen(name) == 4)
	{
			r = ((raw_hex >> 8) & 0x0f) * 17;
			g = ((raw_hex >> 4) & 0x0f) * 17;
			b = ((raw_hex     ) & 0x0f) * 17;
	}
	else if (strlen(name) == 7)
	{
			r = (raw_hex >> 16) & 0xff;
			g = (raw_hex >>  8) & 0xff;
			b = (raw_hex      ) & 0xff;
	}
	else
	{
		LogPrintf("WARNING: bad color string for light: '%s'\n", name);
		return WHITE;
	}

	return MAKE_RGBA(r, g, b, 0);
}


static void QCOM_FreeLights()
{
	qk_all_lights.clear();
}


static void QCOM_FindLights()
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

		light.color = ParseColorString(E->props.getStr("color"));

		light.level = (int) level;
		light.style = E->props.getInt("style", 0);

		qk_all_lights.push_back(light);
	}
}


static inline void Bump(int s, int t, int W, int value, rgb_color_t color)
{
	const int offset = t * W + s;

	blocklights[offset][0] += value * RGB_RED(color);
	blocklights[offset][1] += value * RGB_GREEN(color);
	blocklights[offset][2] += value * RGB_BLUE(color);
}


static void QCOM_ProcessLight(qLightmap_c *lmap, quake_light_t& light, int pass)
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
		if (qk_game < 3)
		{
			SYS_ASSERT(lt_face->leaf);

			if (lt_face->leaf->cluster &&
				lt_face->leaf->cluster->ambient_dists[AMBIENT_SKY] > 4)
				return;
		}
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
			Bump(s, t, lt_W, light.level, light.color);
		}
		else
		{
			float dist = ComputeDist(V.x, V.y, V.z, light.x, light.y, light.z);

			if (dist < light.radius)
			{
				int value = light.level * (1.0 - dist / light.radius);

				Bump(s, t, lt_W, value, light.color);
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


void QLIT_TestingStuff(qLightmap_c *lmap)
{
	int W = lmap->width;
	int H = lmap->height;

	for (int t = 0 ; t < H ; t++)
	for (int s = 0 ; s < W ; s++)
	{
		const quake_vertex_c & V = lt_points[t*W + s];

		int r = 40 + 10 * sin(V.x / 40.0);
		int g = 80 + 40 * sin(V.y / 40.0);
		int b = 40 + 10 * sin(V.z / 40.0);

		g = (int)(V.x / 4.0) & 63;
		r = (int)(V.y / 4.0) & 63;
		b = (int)(V.z / 2.0) & 63;

		lmap->samples[t*W + s] = MAKE_RGBA(r, g, b, 0);

	//  lmap->samples[t*W + s] = QCOM_TraceRay(V.x,V.y,V.z, 2e5,4e5,3e5) ? 80 : 40;
	}
}


void QCOM_LightFace(quake_face_c *F)
{
	lt_face = F;

	F->GetBounds(&lt_face_bbox);

	if (qk_game < 3)
		Q1_CalcFaceStuff(F);
	else
		Q3_CalcFaceStuff(F);

#if 0  // DEBUG
	QLIT_TestingStuff(F->lmap);
	return;
#endif

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


#if 0  // this needed for Q1 and Q2
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
#endif


#define MAX_GRID_CONTRIBUTIONS	100

static int grid_contributions[MAX_GRID_CONTRIBUTIONS][3];


static const int grid_z_deltas[6] =
{
	0, +12, +24, -12, -24, +36
};

static const int grid_xy_deltas[9 * 2] =
{
	 0,		 0,
	+9,		+9,
	+9,		-9,
	-9,		+9,
	-9,		-9,
	+18, 	+18,
	+18,	-18,
	-18,	+18,
	-18,	-18
};


static void Q3_CalcAngularDirection(const float *vec3, dlightgrid3_t *out)
{
	float x = vec3[0];
	float y = vec3[1];
	float z = vec3[2];

	float len = sqrt(x*x + y*y + z*z);

	if (len > 0)
	{
		x /= len;
		y /= len;
		z /= len;
	}

	if (x == 0 && y == 0)
	{
		out->lat = (z < 0) ? 128 : 0;
		out->lng = 0;
	}
	else
	{
		float lat = atan2(y, x) * (180.0 / M_PI) * (255.0 / 360.0);
		float lng = acos(z)     * (180.0 / M_PI) * (255.0 / 360.0);

		out->lat = (int)lat & 0xff;
		out->lng = (int)lng & 0xff;
	}
}


static void Q3_ColorToBytes(int r, int g, int b, float div, byte *out)
{
	float r2 = r / div;
	float g2 = g / div;
	float b2 = b / div;

/// fprintf(stderr, "Q3_ColorToBytes : (%5.3f %5.3f %5.3f)\n", r2, g2, b2);

	float ity = MAX(r2, MAX(g2, b2));

	if (ity > 127)
	{
		ity = 127.0 / ity;

		r2 *= ity;
		g2 *= ity;
		b2 *= ity;
	}

	out[0] = (byte)r2;
	out[1] = (byte)g2;
	out[2] = (byte)b2;
}


static void Q3_ProcessLightForGrid(quake_light_t& light,
								   float gx, float gy, float gz,
								   int *r, int *g, int *b)
{
	*r = *g = *b = 0;

	float dist = ComputeDist(gx, gy, gz, light.x, light.y, light.z);

	// fast check on distance
	if (light.kind != LTK_Sun && dist >= light.radius)
		return;

	// slow ray-trace check
	if (! QCOM_TraceRay(gx, gy, gz, light.x, light.y, light.z))
		return;


	int value = light.level;

	if (light.kind != LTK_Sun)
		value = value * (1.0 - dist / light.radius);

	*r = value * RGB_RED(light.color);
	*g = value * RGB_GREEN(light.color);
	*b = value * RGB_BLUE(light.color);
}


static void Q3_VisitGridPoint(float gx, float gy, float gz, dlightgrid3_t *out)
{
	memset(out, 0, sizeof(dlightgrid3_t));

	// the point may lie inside a solid area, so look for a nearby
	// spot that is open...

	for (int i = 0 ; i <= 6*9 ; i++)
	{
		// everything failed?
		if (i == 6*9)
			return;

		float dx = grid_xy_deltas[(i / 6) * 2 + 0];
		float dy = grid_xy_deltas[(i / 6) * 2 + 1];
		float dz = grid_z_deltas[i % 6];

		if (! QCOM_TracePoint(gx + dx, gy + dy, gz + dz))
			continue;

		// Ok!
		gx += dx;
		gy += dy;
		gz += dz;

		break;
	}

	// process each light, storing each contribution and
	// remembering the greatest contribution to use for the
	// directional component.

	int sum_r = 0;
	int sum_g = 0;
	int sum_b = 0;
	int sum_total = 0;

	int   best_dir_ity = -999;
	int   best_dir_color[3];
	float best_direction[3];

	for (unsigned int k = 0 ; k < qk_all_lights.size() ; k++)
	{
		int r, g, b, ity;

		Q3_ProcessLightForGrid(qk_all_lights[k], gx, gy, gz, &r, &g, &b);

		ity = MAX(r, MAX(g, b));

		if (ity <= 0)
			continue;

		sum_r += r;
		sum_g += g;
		sum_b += b;
		sum_total += 1;

		if (ity > best_dir_ity)
		{
			best_dir_ity = ity;

			best_dir_color[0] = r;
			best_dir_color[1] = g;
			best_dir_color[2] = b;

			best_direction[0] = qk_all_lights[k].x - gx;
			best_direction[1] = qk_all_lights[k].y - gy;
			best_direction[2] = qk_all_lights[k].z - gz;
		}
	}

	if (best_dir_ity > 0)
	{
		Q3_CalcAngularDirection(best_direction, out);
		Q3_ColorToBytes(best_dir_color[0], best_dir_color[1], best_dir_color[2], 3000.0, out->directedLight);
	}

	if (sum_total > 0)
	{
		Q3_ColorToBytes(sum_r, sum_g, sum_b, sum_total * 500.0, out->ambientLight);
	}
}


#define LUMP_Q3_LIGHTGRID	15

static void Q3_GridLighting()
{
	// world mins / maxs
	float w_mins[3];
	float w_maxs[3];

	float g_mins[3];
	float g_maxs[3];
	int   g_count[3];

	for (int b = 0 ; b < 3 ; b++)
	{
		float block_size = (b < 2) ? 64.0 : 128.0;

		w_mins[b] = qk_bsp_root->bbox.mins[b];
		w_maxs[b] = qk_bsp_root->bbox.maxs[b];

		g_mins[b] = block_size * ceil (w_mins[b] / block_size);
		g_maxs[b] = block_size * floor(w_maxs[b] / block_size);

		g_count[b] = (g_maxs[b] - g_mins[b]) / block_size + 1;
	}

	LogPrintf("grid counts: %d x %d x %d\n", g_count[0], g_count[1], g_count[2]);

	qLump_c * lump = BSP_NewLump(LUMP_Q3_LIGHTGRID);

	dlightgrid3_t raw_point;

	for (int znum = 0 ; znum < g_count[2] ; znum++)
	for (int ynum = 0 ; ynum < g_count[1] ; ynum++)
	for (int xnum = 0 ; xnum < g_count[0] ; xnum++)
	{
		float gx = g_mins[0] + xnum *  64.0;
		float gy = g_mins[1] + ynum *  64.0;
		float gz = g_mins[2] + znum * 128.0;

		Q3_VisitGridPoint(gx, gy, gz, &raw_point);

		lump->Append(&raw_point, sizeof(raw_point));
	}
}


void QCOM_LightAllFaces()
{
	LogPrintf("\nLighting World...\n");

	QCOM_FindLights();

	LogPrintf("found %u lights\n", qk_all_lights.size());

	QCOM_MakeTraceNodes();

	int lit_faces  = 0;
	int lit_luxels = 0;

	// visit all faces, including Q3 detail and map-model faces

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

	// for Q3, determine grid lighting
	if (qk_game >= 3)
		Q3_GridLighting();

// Todo: Q1/Q2 map models
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
