//------------------------------------------------------------------------
//  Remember Choice widget
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

	bool enabled;	// shown to the user

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

	// FLTK method override
	int handle(int event);

public:
	// add a new choice to the list.  If a choice with the same 'id'
	// already exists, it is just replaced instead.
	// The choice will begin disabled (shown == false).
	void AddChoice(const char *id, const char *label);

	// finds the option with the given ID, and update its 'enabled'
	// value.  Returns true if successful, or false if no such
	// option exists.  Any change will call Recreate().
	bool EnableChoice(const char *id, bool enable_it);

	// get the id string for the currently shown value.
	// Returns the string "none" if there are no choices.
	const char *GetID() const;

	// change the currently shown value via the new 'id'.
	// If does not exist, returns false and nothing was changed.
	bool ChangeTo(const char *id);

private:
	choice_data_c * FindID(const char *id) const;
	choice_data_c * FindMapped() const;

	// call this to update the available choices to reflect their
	// 'shown' values.  If the previous selected item is still
	// valid, it remains set, otherwise we try and find a shown
	// value with the same label, and failing that: select the
	// first entry.
	void Recreate();

	const char *GetLabel() const;  // ????

	void GotoPrevious();
	void GotoNext();
};


#endif /* __UI_RCHOICE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
