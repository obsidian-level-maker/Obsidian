//------------------------------------------------------------------------
//  Remember Choice widget
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#ifndef __UI_RCHOICE_H__
#define __UI_RCHOICE_H__

//
// DESCRIPTION:
//   A sub-classed Fl_Choice widget which remembers an 'id'
//   string associated with each selectable value, and allows
//   these ids and labels to be updated at any time.
//

class choice_data_c
{
friend class UI_RChoice;

public:
	const char *id;     // terse identifier
	const char *label;  // description (for the UI)

	bool shown;

	// the index in the current list, or -1 if not present
	int mapped;

	Fl_Check_Button *widget;

public:
	choice_data_c(const char *_id = NULL, const char *_label = NULL);
	~choice_data_c();
};


class UI_RChoice : public Fl_Choice
{
private:
	std::vector<choice_data_c *> opt_list;

public:
	UI_RChoice(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_RChoice();

public:
	void AddPair(const char *id, const char *label);
	// add a new option to the list.  If an option with the same 'id'
	// already exists, that option is replaced instead.
	// The option will begin with shown == false.

	bool ShowOrHide(const char *id, bool new_shown);
	// finds the option with the given ID, and update the shown
	// value.  Returns true if successful, or false if no such
	// option exists.  Any change will call Recreate().

	const char *GetID() const;
	// get the id string for the currently shown value.
	// Returns the string "none" if there are no choices.

	bool SetID(const char *id);
	// set the currently shown value via the new 'id'.  If no
	// such exists, returns false and nothing was changed.

private:
	choice_data_c * FindID(const char *id) const;
	choice_data_c * FindMapped() const;

	void Recreate();
	// The available choices will be updated to reflect the
	// 'shown' values.  If the previous selected item is still
	// valid, it remains set, otherwise we try and find a shown
	// value with the same label, and failing that: select the
	// first entry.

	const char *GetLabel() const;  // ????
};


#endif /* __UI_RCHOICE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
