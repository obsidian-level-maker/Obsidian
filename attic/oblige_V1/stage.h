//------------------------------------------------------------------------
//  STAGES
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_STAGES_H__
#define __OBLIGE_STAGES_H__

class stage_c
{
public:
	stage_c(int _index, char _key);
	virtual ~stage_c();

public:
	int index;

	// the key required to enter this stage (actual key must occur in
	// a previous stage).  Zero for a switched door / bars.
	char key;

	int num_areas;
	int num_squares;

	int mid_x;
	int mid_y;

	class stage_conn_c
	{
	public:
		stage_conn_c() : A(NULL), N(NULL), teleport(false) { }
		~stage_conn_c() { }

	public:
		area_c *A;  // Area in THIS stage
		area_c *N;  // Neighbouring area in OTHER stage
		bool teleport;
	
	public:
		void Set(area_c *_A, area_c *_N, bool _teleport)
		{
			A = _A; N = _N; teleport = _teleport;
		}
	};

	stage_conn_c S1, S2;  // START areas
	stage_conn_c L1, L2;  // LEAVE areas

	area_c * K;           // KEY area

///---	int S, N; // START area in this stage, and its Neighbour.
///---	int K;    // KEY area, this stage.  Used for EXIT on last stage.
///---
///---	int aux_S, aux_N; // AUXILIARY link (keyed stages only)

public:
	void ComputeInfo();
};

//------------------------------------------------------------------------

namespace stage_build
{
	void CreateStages();
}

#endif /* __OBLIGE_STAGES_H__ */
