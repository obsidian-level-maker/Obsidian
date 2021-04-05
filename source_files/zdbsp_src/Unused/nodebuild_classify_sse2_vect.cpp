/*
    Determine what side of a splitter a seg lies on. (SSE2 version)
    Copyright (C) 2002-2006 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/

#ifndef DISABLE_SSE

#include "zdbsp.h"
#include "nodebuild.h"
#include <emmintrin.h>

#define FAR_ENOUGH 17179869184.f		// 4<<32

// You may notice that this function is identical to ClassifyLine2.
// The reason it is SSE2 is because this file is explicitly compiled
// with SSE2 math enabled, but the other files are not.

extern "C" int ClassifyLineSSE2 (node_t &node, const FSimpleVert *v1, const FSimpleVert *v2, int sidev[2])
{
	__m128d xy, dxy, xyv1, xyv2;

	// Why does this intrinsic go through an MMX register, when it can just go through memory?
	// That would let it work with x64, too. (This only applies to VC++. GCC
	// is smarter and can load directly from memory without touching the MMX registers.)
	xy = _mm_cvtpi32_pd(*(__m64*)&node.x);		// d_y1  d_x1
	dxy = _mm_cvtpi32_pd(*(__m64*)&node.dx);	// d_dy  d_dx
	xyv1 = _mm_cvtpi32_pd(*(__m64*)&v1->x);		// d_yv1 d_xv1
	xyv2 = _mm_cvtpi32_pd(*(__m64*)&v2->x);		// d_yv2 d_xv2

	__m128d num1, num2, dyx;

	dyx = _mm_shuffle_pd(dxy, dxy, _MM_SHUFFLE2(0,1));
	num1 = _mm_mul_pd(_mm_sub_pd(xy, xyv1), dyx);
	num2 = _mm_mul_pd(_mm_sub_pd(xy, xyv2), dyx);

	__m128d pnuma, pnumb, num;

	pnuma = _mm_shuffle_pd(num1, num2, _MM_SHUFFLE2(1,1));
	pnumb = _mm_shuffle_pd(num1, num2, _MM_SHUFFLE2(0,0));
	num = _mm_sub_pd(pnuma, pnumb);
	// s_num1 is at num[0]; s_num2 is at num[1]

	__m128d neg_enough, pos_enough;
	__m128d neg_check, pos_check;

	neg_enough = _mm_set1_pd(-FAR_ENOUGH);
	pos_enough = _mm_set1_pd( FAR_ENOUGH);

	// Why do the comparison instructions return __m128d and not __m128i?
	neg_check = _mm_cmple_pd(num, neg_enough);
	pos_check = _mm_cmpge_pd(num, pos_enough);

	union
	{
		struct
		{
			double n[2], p[2];
		};
		struct
		{
			int ni[4], pi[4];
		};
	} _;

	_mm_storeu_pd(_.n, neg_check);
	_mm_storeu_pd(_.p, pos_check);

	int nears = 0;

	if (_.ni[0])
	{
		if (_.ni[2])
		{
			sidev[0] = sidev[1] = 1;
			return 1;
		}
		if (_.pi[2])
		{
			sidev[0] = 1;
			sidev[1] = -1;
			return -1;
		}
		nears = 1;
	}
	else if (_.pi[0])
	{
		if (_.pi[2])
		{
			sidev[0] = sidev[1] = -1;
			return 0;
		}
		if (_.ni[2])
		{
			sidev[0] = -1;
			sidev[1] = 1;
			return -1;
		}
		nears = 1;
	}
	else
	{
		nears = 2 | (((_.ni[2] | _.pi[2]) & 1) ^ 1);
	}

	__m128d zero = _mm_setzero_pd();
	__m128d posi = _mm_cmpgt_pd(num, zero);
	_mm_storeu_pd(_.p, posi);

	int sv1 = _.pi[0] ? _.pi[0] : 1;
	int sv2 = _.pi[2] ? _.pi[2] : 1;
	if (nears)
	{
		__m128d sqnum = _mm_mul_pd(num, num);
		__m128d sqdyx = _mm_mul_pd(dyx, dyx);
		__m128d sqdxy = _mm_mul_pd(dxy, dxy);
		__m128d l = _mm_add_pd(sqdyx, sqdxy);
		__m128d dist = _mm_div_pd(sqnum, l);
		__m128d epsilon = _mm_set1_pd(SIDE_EPSILON);
		__m128d close = _mm_cmplt_pd(dist, epsilon);
		_mm_storeu_pd(_.n, close);
		if (nears & _.ni[0] & 2)
		{
			sv1 = 0;
		}
		if (nears & _.ni[2] & 1)
		{
			sv2 = 0;
		}
	}
	sidev[0] = sv1;
	sidev[1] = sv2;

	if ((sv1 | sv2) == 0)
	{ // seg is coplanar with the splitter, so use its orientation to determine
	  // which child it ends up in. If it faces the same direction as the splitter,
	  // it goes in front. Otherwise, it goes in back.

		if (node.dx != 0)
		{
			if ((node.dx > 0 && v2->x > v1->x) || (node.dx < 0 && v2->x < v1->x))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		else
		{
			if ((node.dy > 0 && v2->y > v1->y) || (node.dy < 0 && v2->y < v1->y))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
	}
	else if (sv1 <= 0 && sv2 <= 0)
	{
		return 0;
	}
	else if (sv1 >= 0 && sv2 >= 0)
	{
		return 1;
	}
	return -1;
}

#endif
