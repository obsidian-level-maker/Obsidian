//----------------------------------------------------------------------------
//
//  Angular Occlusion Buffer
// 
//  Copyright (c) 2007,2013  Andrew Apted
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
//----------------------------------------------------------------------------

#include "headers.h"
#include "main.h"

#include "vis_occlude.h"


#define DEBUG_OCCLUDE  0


typedef u16_t angle_t;

#define ANG180   0x8000
#define ANG_MAX  0xffff

static inline angle_t ToAngle(float ang)
{
	if (ang < 0) ang += 720.0;

	ang = ang * (65536.0 / 360.0);

	return (angle_t) ((u32_t)ang & ANG_MAX);
}


typedef struct angle_range_s
{
	angle_t low, high;

	struct angle_range_s *next;
	struct angle_range_s *prev;

} angle_range_t;


static angle_range_t *occbuf_head = NULL;
static angle_range_t *occbuf_tail = NULL;

static angle_range_t *free_range_chickens = NULL;


#ifdef DEBUG_OCCLUDE
static void ValidateBuffer(void)
{
	if (! occbuf_head)
	{
		SYS_ASSERT(! occbuf_tail);
		return;
	}

	for (angle_range_t *AR = occbuf_head ; AR ; AR = AR->next)
	{
		SYS_ASSERT(AR->low <= AR->high);

		if (AR->next)
		{
			SYS_ASSERT(AR->next->prev == AR);
			SYS_ASSERT(AR->next->low > AR->high);
		}
		else
		{
			SYS_ASSERT(AR == occbuf_tail);
		}

		if (AR->prev)
		{
			SYS_ASSERT(AR->prev->next == AR);
		}
		else
		{
			SYS_ASSERT(AR == occbuf_head);
		}
	}
}
#endif // DEBUG_OCCLUDE


void Occlusion_Dump(void)
{
	fprintf(stderr, "Occludes {");  

	for (angle_range_t *AR = occbuf_head ; AR ; AR = AR->next)
	{
		float low  = AR->low  * (360.0 / 65536.0);
		float high = AR->high * (360.0 / 65536.0);

		fprintf(stderr, " %1.2f-%1.2f ", low, high);
	}

	fprintf(stderr, "}\n");
}


void Occlusion_Clear(void)
{
	// Clear all angles in the whole buffer
	// )i.e. mark them as open / non-blocking).

	if (occbuf_head)
	{
		occbuf_tail->next = free_range_chickens;

		free_range_chickens = occbuf_head;

		occbuf_head = NULL;
		occbuf_tail = NULL;
	}

#ifdef DEBUG_OCCLUDE
	ValidateBuffer();
#endif
}


static inline angle_range_t *GetNewRange(angle_t low, angle_t high)
{
	angle_range_t *R;

	if (free_range_chickens)
	{
		R = free_range_chickens;

		free_range_chickens = R->next;
	}
	else
	{
		R = new angle_range_t;
	}

	R->low  = low;
	R->high = high;

	return R;
}


static inline void LinkBefore(angle_range_t *X, angle_range_t *N)
{
	// X = eXisting range
	// N = New range

	N->next = X;
	N->prev = X->prev;

	X->prev = N;

	if (N->prev)
		N->prev->next = N;
	else
		occbuf_head = N;
}


static inline void LinkInTail(angle_range_t *N)
{
	N->next = NULL;
	N->prev = occbuf_tail;

	if (occbuf_tail)
		occbuf_tail->next = N;
	else
		occbuf_head = N;

	occbuf_tail = N;
}


static inline void RemoveRange(angle_range_t *R)
{
	if (R->next)
		R->next->prev = R->prev;
	else
		occbuf_tail = R->prev;

	if (R->prev)
		R->prev->next = R->next;
	else
		occbuf_head = R->next;

	// add it to the quick-alloc list
	R->next = free_range_chickens;
	R->prev = NULL;

	free_range_chickens = R;
}


static void DoSet(angle_t low, angle_t high)
{
	for (angle_range_t *AR = occbuf_head ; AR ; AR = AR->next)
	{
		if (high < AR->low)
		{
			LinkBefore(AR, GetNewRange(low, high));
			return;
		}

		if (low > AR->high)
			continue;

		// the new range overlaps the old range.
		//
		// The above test (i.e. low > AR->high) guarantees that if
		// we reduce AR->low, it cannot touch the previous range.
		//
		// However by increasing AR->high we may touch or overlap
		// some subsequent ranges in the list.  When that happens,
		// we must remove them (and adjust the current range).

		AR->low  = MIN(AR->low,  low);
		AR->high = MAX(AR->high, high);

#ifdef DEBUG_OCCLUDE
		if (AR->prev)
		{
			SYS_ASSERT(AR->low > AR->prev->high);
		}
#endif
		while (AR->next && AR->high >= AR->next->low)
		{
			AR->high = MAX(AR->high, AR->next->high);

			RemoveRange(AR->next);
		}

		return;
	}

	// the new range is greater than all existing ranges

	LinkInTail(GetNewRange(low, high));
}


void Occlusion_Set(float low, float high)
{
	// Set all angles in the given range, i.e. mark them as blocking.
	// The range is limited to 180 degrees.

	angle_t a1 = ToAngle(low);
	angle_t a2 = ToAngle(high);

	SYS_ASSERT((angle_t)(a2 - a1) < ANG180);

	if (a1 <= a2)
		DoSet(a1, a2);
	else
	{
		DoSet(a1, ANG_MAX);
		DoSet( 0, a2);
	}

#ifdef DEBUG_OCCLUDE
	ValidateBuffer();
#endif
}


static inline bool DoTest(angle_t low, angle_t high)
{
	for (angle_range_t *AR = occbuf_head ; AR ; AR = AR->next)
	{
		if (AR->low <= low && high <= AR->high)
			return true;

		if (AR->high > low)
			break;
	}

	return false;
}


bool Occlusion_Blocked(float low, float high)
{
	// Check whether all angles in the given range are set (i.e. blocked).
	// Returns true if the entire range is blocked, false otherwise.
	// The range is limited to 180 degrees.

	angle_t a1 = ToAngle(low);
	angle_t a2 = ToAngle(high);

	SYS_ASSERT((angle_t)(a2 - a1) < ANG180);

	if (a1 <= a2)
		return DoTest(a1, a2);
	else
		return DoTest(a1, ANG_MAX) && DoTest(0, a2);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
