//----------------------------------------------------------------
//  Remember Choice widget
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_util.h"


choice_data_c::choice_data_c(const char *_id, const char *_label) :
	id(NULL), label(NULL), shown(false),
	mapped(-1), widget(NULL)
{
	if (_id)    id    = StringDup(_id);
	if (_label) label = StringDup(_label);
}
 

choice_data_c::~choice_data_c()
{
	if (id)    StringFree(id);
	if (label) StringFree(label);

	// ignore 'widget' field when shown, we assume it exists in
	// an Fl_Group and hence FLTK will take care to delete it.
	if (! shown)
		delete widget;
}


//----------------------------------------------------------------


UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label) :
	Fl_Choice(x, y, w, h, label),
	opt_list()
{ }


UI_RChoice::~UI_RChoice()
{
	for (unsigned int i = 0; i < opt_list.size(); i++)
	{
		delete opt_list[i];
	}
}


void UI_RChoice::AddPair(const char *id, const char *label)
{
	choice_data_c *opt = FindID(id);

	if (opt)
	{
		StringFree(opt->label);
		opt->label = StringDup(label);

		if (opt->shown)
			Recreate();
	}
	else
	{
		opt = new choice_data_c(id, label);

		opt_list.push_back(opt);

		// no need to call Recreate() here since new pairs are always
		// hidden (shown == false).
	}
}


bool UI_RChoice::ShowOrHide(const char *id, bool new_shown)
{
	SYS_ASSERT(id);

	choice_data_c *P = FindID(id);

	if (! P)
		return false;

	if (P->shown != new_shown)
	{
		P->shown = new_shown;
		Recreate();
	}

	return true;
}


const char *UI_RChoice::GetID() const
{
	choice_data_c *P = FindMapped();

	return P ? P->id : "";
}


const char *UI_RChoice::GetLabel() const
{
	choice_data_c *P = FindMapped();

	return P ? P->label : "";
}


bool UI_RChoice::SetID(const char *id)
{
	SYS_ASSERT(id);

	choice_data_c *P = FindID(id);

	if (! P || P->mapped < 0)
		return false;

	value(P->mapped);

	return true;
}


//----------------------------------------------------------------


void UI_RChoice::Recreate()
{
	// recreate the choice list

	choice_data_c *LAST = FindMapped();

	clear();

	for (unsigned int j = 0 ; j < opt_list.size() ; j++)
	{
		choice_data_c *P = opt_list[j];

		// is it just a separator?
		if (strcmp(P->label, "_") == 0)
		{
			P->mapped = -1;
			add("", 0, 0, 0, FL_MENU_DIVIDER|FL_MENU_INACTIVE);
			continue;
		}

		if (! P->shown)
		{
			P->mapped = -1;
			continue;
		}

		P->mapped = add(P->label, 0, 0, 0, 0);
	}

	// update the currently selected choice

	if (LAST && LAST->mapped >= 0)
	{
		value(LAST->mapped);
		return;
	}

	value(0);
}


choice_data_c * UI_RChoice::FindID(const char *id) const
{
	for (unsigned int j = 0; j < opt_list.size(); j++)
	{
		choice_data_c *P = opt_list[j];

		if (strcmp(P->id, id) == 0)
			return P;
	}

	return NULL;
}


choice_data_c * UI_RChoice::FindMapped() const
{
	for (unsigned int j = 0 ; j < opt_list.size() ; j++)
	{
		choice_data_c *P = opt_list[j];

		if (P->mapped >= 0 && P->mapped == value())
			return P;
	}

	return NULL;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
