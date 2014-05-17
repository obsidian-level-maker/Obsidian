//------------------------------------------------------------------------
//  Play Settings
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

#ifndef __UI_PLAY_H__
#define __UI_PLAY_H__

class UI_Play : public Fl_Group
{
public: // private:

	UI_RChoice *mons;
	UI_RChoice *strength;

	UI_RChoice *weaps;
	UI_RChoice *powers;

	UI_RChoice *health;
	UI_RChoice *ammo;

public:
	UI_Play(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Play();

public:

	void Locked(bool value);

	void Defaults();

	// this is only for reading the CONFIG file.
	// parse the name and store the value in the appropriate
	// widget, also sending it to the Lua code.
	// Returns false if the key was unknown.
	bool ParseValue(const char *key, const char *value);

private:

	void setup_Monsters();
	void setup_Strength();
	void setup_Weapons ();
	void setup_Powers  ();
	void setup_Health  ();
	void setup_Ammo    ();

	static void notify_Mode(const char *name, void *priv_dat);

	static void callback_Monsters(Fl_Widget *, void*);
	static void callback_Strength(Fl_Widget *, void*);
	static void callback_Weapons (Fl_Widget *, void*);
	static void callback_Powers  (Fl_Widget *, void*);
	static void callback_Health  (Fl_Widget *, void*);
	static void callback_Ammo    (Fl_Widget *, void*);

	static const char * monster_syms[];
	static const char * strength_syms[];
	static const char * power_syms[];
	static const char * health_syms[];
};

#endif /* __UI_PLAY_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
