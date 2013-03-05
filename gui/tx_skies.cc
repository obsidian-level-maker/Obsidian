//------------------------------------------------------------------------
//  SKY GENERATION
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2008-2009 Andrew Apted
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

#include "lib_util.h"
#include "main.h"
#include "m_lua.h"

#include "twister.h"
#include "tx_forge.h"
#include "tx_skies.h"


byte * SKY_GenGradient(int W, int H, std::vector<byte> & colors)
{
	int numcol = (int)colors.size();

	SYS_ASSERT(numcol > 0);

	byte *pixels = new byte[W * H];

	for (int y = 0; y < H; y++)
	{
		// we assume that (in general) top is light, bottom is dark
		int idx = (H-1-y) * numcol / H;

		byte color = colors[idx];

		byte *dest  = & pixels[y * W];
		byte *d_end = dest + W;

		while (dest < d_end)
		{
			*dest++ = color;
		}
	}

	return pixels;
}


void SKY_AddClouds(int seed, byte *pixels, int W, int H,
                   color_mapping_t *map, double powscale, double thresh,
                   double fracdim, double squish)
{
	// SYS_ASSERT(is_power_of_two(W))

	SYS_ASSERT(W >= H);

	SYS_ASSERT(map->size > 0);
	SYS_ASSERT(squish > 0);
	SYS_ASSERT(powscale > 0);

	float * synth = new float[W * W];

	TX_SpectralSynth(seed, synth, W, fracdim, powscale);

	for (int y = 0; y < H; y++)
	{
		int sy = (int)(y * squish) & (W-1);  // yes 'W'

		const float *src = & synth[sy * W];

		byte *dest  = & pixels[y * W];
		byte *d_end = dest + W;

		while (dest < d_end)
		{
			float v = *src++;

			if (v < thresh)
			{
				dest++;
				continue;
			}

			v = (v - thresh) / (1.0 - thresh);

			int idx = (int)(v * map->size);
			idx = CLAMP(0, idx, map->size-1);

			*dest++ = map->colors[idx];
		}
	}

	delete[] synth;
}


void SKY_AddStars(int seed, byte *pixels, int W, int H,
				  color_mapping_t *map,
				  double powscale, double thresh)
{
	SYS_ASSERT(map->size >= 1);
	SYS_ASSERT(powscale > 0);
	SYS_ASSERT(thresh < 0.99);

	MT_rand_c twist(seed);

	for (int y = 0; y < H; y++)
	{
		byte *dest  = & pixels[y * W];
		byte *d_end = dest + W;

		while (dest < d_end)
		{
			double v  = twist.Rand_fp();
			v *= twist.Rand_fp();
			v *= twist.Rand_fp();

			v = pow(v, powscale);

			if (v < thresh)
			{
				dest++;
				continue;
			}

			v = (v - thresh) / (1.0 - thresh);

			int idx = (int)(v * map->size);
			idx = CLAMP(0, idx, map->size-1);

			*dest++ = map->colors[idx];
		}
	}
}


void SKY_AddHills(int seed, byte *pixels, int W, int H,
                  color_mapping_t *map, double min_h, double max_h,
                  double powscale, double fracdim)
{
	SYS_ASSERT(map->size >= 2);
	SYS_ASSERT(min_h <= max_h);
	SYS_ASSERT(powscale > 0);

	float * height_map = new float[W * W];

	TX_SpectralSynth(seed, height_map, W, fracdim, powscale);


	max_h = max_h - min_h;

	MT_rand_c twist(seed ^ 1);


	// draw a column of pixels for every point on the height map.
	// optimised to only draw the visible parts.

	for (int x = 0; x < W; x++)
	{
		// remember the highest span for this column
		int high_span = 0;

		for (int z = 0; z < W; z++)
		{
			float f = height_map[z*W + x];

			f = min_h + f * max_h;

			int span = int(f*H);

			// hidden by previous spans?
			if (span <= high_span)
				continue;

			if (span >= H)
				span = H-1;

			float ity = abs(z - W/2) / float(W/2);

			ity = 1.0 - ity * 0.7;

			for (int y = high_span; y < span; y++)
			{
				float i2 = ity - 0.3 * twist.Rand_fp();

				int idx = (int)(i2 * map->size);

				idx = CLAMP(0, idx, map->size-1);

				pixels[(H-1-y)*W + x] = map->colors[idx];
			}

			high_span = span;
		}
	}

	delete[] height_map;
}


void SKY_AddBuilding(int seed, byte *pixels, int W, int H,
                     std::vector<byte> & colors,
                     int pos_x, int width, int base_h, int top_h,
                     int win_prob, int win_w, int win_h, int antenna)
{
	int numcol = (int)colors.size();
	SYS_ASSERT(numcol >= 2);

	win_prob = win_prob * 65535 / 100;

	MT_rand_c bu_twist(seed);

	int x, y;

	int win_x;
	int win_y = 1 + win_h;

	byte bg = colors[0];

	for (y = 0; y < base_h + top_h; y++)
	{
		if (y >= H)
			break;

		int x1 = pos_x;
		int x2 = pos_x + width - 1;

		if (y >= base_h)
		{
			x1 = x1 + width / 8;
			x2 = x2 - width / 8;
		}

		for (x = x1; x <= x2; x++)
		{
			pixels[(H-1-y)*W + (x % W)] = bg;
		}

		// Windows
		if (y == win_y && y < base_h+top_h-2)
		{
			for (win_x = x1+2; win_x+win_w <= x2-2; win_x += win_w+1)
			{
				byte fg = colors[1];

				if (((int)bu_twist.Rand() & 0xFFFF) > win_prob)
					fg = (numcol >= 3) ? colors[2] : bg;

				for (int dx = 0; dx < win_w; dx++)
				for (int dy = 0; dy < win_h; dy++)
				{
					pixels[(H-1-win_y+dy)*W + ((win_x+dx) % W)] = fg;
				}
			}

			win_y += win_h + 1;

			if (base_h <= win_y && win_y <= base_h + win_h)
				win_y = base_h + win_h + 1;
		}
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
