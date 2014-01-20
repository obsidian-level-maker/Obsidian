//----------------------------------------------------------------------------
//  A* Search Algorithm
//----------------------------------------------------------------------------
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

#ifndef __OBLIGE_ASTAR_H__
#define __OBLIGE_ASTAR_H__

class astar_info_c
{
public:
	astar_info_c() : state(SUB_Unknown) { }
	~astar_info_c() { }

public:
	enum
	{
		SUB_Unknown = 0,
		SUB_Open,
		SUB_Closed
	};

	int state;

	enum
	{
		PAR_NONE = -1,
		PAR_Teleport = -2
	};

	int parent;  // area number

	int G_score;
	int H_score;
	int F_score() const { return G_score + H_score; }

public:
	inline bool IsOpen()   const { return state == SUB_Open; }
	inline bool IsClosed() const { return state == SUB_Closed; }

	void Reset()
	{
		state = SUB_Unknown;
	}

	void Open(int _parent, int _G, int _H)
	{
		SYS_ASSERT(state == SUB_Unknown);

		state   = SUB_Open;
		parent  = _parent;
		G_score = _G;
		H_score = _H;
	}

	void Close()
	{
		SYS_ASSERT(state == SUB_Open);

		state = SUB_Closed;
	}

	void Improve(int new_parent, int new_G)
	{
		SYS_ASSERT(state == SUB_Open);

		parent  = new_parent;
		G_score = new_G;
	}
};

//------------------------------------------------------------------------

class area_c;

enum
{
	AST_NONE = 0,
	AST_Remember = (1 << 0)
};

namespace astar_search
{
	int FindStagePath(area_c *S, area_c *E, int flags = AST_NONE);
}

#endif  /* __OBLIGE_ASTAR_H__ */
