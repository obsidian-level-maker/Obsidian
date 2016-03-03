//------------------------------------------------------------------------
//  CONTROL Panel
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

// this includes everything we need
#include "defs.h"


class W_Posit : public Fl_Group
{
public:
	char block_str[100];
	char map_str[100];

public:
	W_Posit(int X, int Y, int W, int H, const char *label = NULL) : 
		Fl_Group(X, Y, W, H, label)
	{
		// cancel automatic 'begin' in Fl_Group's constructor
		end();

		box(FL_THIN_UP_BOX);
		resizable(0);

		align(FL_ALIGN_TOP | FL_ALIGN_INSIDE);
	    labeltype(FL_NORMAL_LABEL);
		labelfont(FL_HELVETICA_BOLD);
		labelsize(16);

		strcpy(block_str, "Block:");
		strcpy(map_str, "Map coord:");

		Y += 24;

		Fl_Box *block_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, block_str);
		block_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    block_bx->labeltype(FL_NORMAL_LABEL);
		block_bx->labelfont(FL_HELVETICA);
		block_bx->labelsize(16);

		add(block_bx);

		Y += 24;

		Fl_Box *map_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, map_str);
		map_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    map_bx->labeltype(FL_NORMAL_LABEL);
		map_bx->labelfont(FL_HELVETICA);
		map_bx->labelsize(16);

		add(map_bx);

		Y += 24;
	}

	virtual ~W_Posit()
	{ }

	void Update(int bx, int by, int mx, int my)
	{
		if (bx >= 0)
			sprintf(block_str, "Block: (%d,%d)", bx, by);
		else
			sprintf(block_str, "Block: INVALID");

		sprintf(map_str, "Map coord: (%d,%d)", mx, my);

		redraw();
	}
};

//------------------------------------------------------------------------

class W_Environ : public Fl_Group
{
public:
	char env_str[100];
	char mat_str[100];
	char height_str[100];

public:
	W_Environ(int X, int Y, int W, int H, const char *label = NULL) : 
		Fl_Group(X, Y, W, H, label)
	{
		// cancel automatic 'begin' in Fl_Group's constructor
		end();

		box(FL_THIN_UP_BOX);
		resizable(0);

		align(FL_ALIGN_TOP | FL_ALIGN_INSIDE);
	    labeltype(FL_NORMAL_LABEL);
		labelfont(FL_HELVETICA_BOLD);
		labelsize(16);

		strcpy(env_str, "Type:");
		strcpy(mat_str, "Material:");
		strcpy(height_str, "Floor:   Ceil:");

		Y += 24;

		Fl_Box *env_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, env_str);
		env_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    env_bx->labeltype(FL_NORMAL_LABEL);
		env_bx->labelfont(FL_HELVETICA);
		env_bx->labelsize(16);

		add(env_bx);

		Y += 24;

		Fl_Box *mat_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, mat_str);
		mat_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    mat_bx->labeltype(FL_NORMAL_LABEL);
		mat_bx->labelfont(FL_HELVETICA);
		mat_bx->labelsize(16);

		add(mat_bx);

		Y += 24;

		Fl_Box *height_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, height_str);
		height_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    height_bx->labeltype(FL_NORMAL_LABEL);
		height_bx->labelfont(FL_HELVETICA);
		height_bx->labelsize(16);

		add(height_bx);

		Y += 24;
	}

	virtual ~W_Environ()
	{ }

	void Update(const location_c& loc)
	{
		sprintf(env_str, "Type: %s", area_build::NameForEnv(loc.env));

		sprintf(mat_str, "Material: %d", loc.mat); //!!!!

		sprintf(height_str, "Floor: %d   Ceil: %d\n",
				(int)loc.floor_h * 64, (int)loc.ceil_h * 64);

		redraw();
	}
};

//------------------------------------------------------------------------

class W_Area : public Fl_Group
{
public:
	char index_str[100];
	char stage_str[100];
	char teleport_str[100];

public:
	W_Area(int X, int Y, int W, int H, const char *label = NULL) : 
		Fl_Group(X, Y, W, H, label)
	{
		index_str[0] = stage_str[0] = teleport_str[0] = 0;

		// cancel automatic 'begin' in Fl_Group's constructor
		end();

		box(FL_THIN_UP_BOX);
		resizable(0);

		align(FL_ALIGN_TOP | FL_ALIGN_INSIDE);
	    labeltype(FL_NORMAL_LABEL);
		labelfont(FL_HELVETICA_BOLD);
		labelsize(16);

		Y += 24;

		Fl_Box *index_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, index_str);
		index_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    index_bx->labeltype(FL_NORMAL_LABEL);
		index_bx->labelfont(FL_HELVETICA);
		index_bx->labelsize(16);

		add(index_bx);

		Y += 24;

		Fl_Box *stage_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, stage_str);
		stage_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    stage_bx->labeltype(FL_NORMAL_LABEL);
		stage_bx->labelfont(FL_HELVETICA);
		stage_bx->labelsize(16);

		add(stage_bx);

		Y += 24;

		Fl_Box *teleport_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, teleport_str);
		teleport_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    teleport_bx->labeltype(FL_NORMAL_LABEL);
		teleport_bx->labelfont(FL_HELVETICA);
		teleport_bx->labelsize(16);

		add(teleport_bx);

		Y += 24;

#if 0
		Fl_Box *stage_bx = new Fl_Box(FL_FLAT_BOX, X+4, Y, W-4, 24, stage_str);
		stage_bx->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	    stage_bx->labeltype(FL_NORMAL_LABEL);
		stage_bx->labelfont(FL_HELVETICA);
		stage_bx->labelsize(16);

		add(stage_bx);

		Y += 24;
#endif
		Update(NULL);  // set initial strings
	}

	virtual ~W_Area()
	{ }

	void Update(const area_c *A)
	{
		if (! A)
		{
			strcpy(index_str, "Index:   Size:");
			strcpy(stage_str, "Stage:   Island:");
			strcpy(teleport_str, "Teleport:");
		}
		else
		{
			sprintf(index_str, "Index: %d   Size: %d",  A->index, A->total);
			sprintf(stage_str, "Stage: %d   Island %d", A->stage, A->island);

			if (A->teleport)
				sprintf(teleport_str, "Teleport: %d", A->teleport->index);
			else
				sprintf(teleport_str, "Teleport: NONE");
		}

		redraw();
	}
};


//------------------------------------------------------------------------

//
// W_Control Constructor
//
W_Control::W_Control(int X, int Y, int W, int H, const char *label) : 
        Fl_Group(X, Y, W, H, label)
		//...
{
	// cancel automatic 'begin' in Fl_Group's constructor
	end();

	resizable(0);

	posit = new W_Posit(X, Y, W, 76, "Position");
	add(posit);

	Y += posit->h() + 4;

	environ = new W_Environ(X, Y, W, 98, "Environment");
	add(environ);

	Y += environ->h() + 4;

	area = new W_Area(X, Y, W, 122, "Area");
	add(area);

	Y += environ->h() + 4;
}

//
// W_Control Destructor
//
W_Control::~W_Control()
{ }

void W_Control::UpdatePos(int bx, int by, int mx, int my)
{
	posit->Update(bx, by, mx, my);
}

void W_Control::UpdateEnv(const location_c& loc)
{
	environ->Update(loc);

	area->Update(loc.Void() ? NULL : the_world->Area(loc.area));
}
