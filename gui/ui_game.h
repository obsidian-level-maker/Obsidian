//------------------------------------------------------------------------
//  Game Panel
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef __UI_GAME_H__
#define __UI_GAME_H__

class UI_Game : public Fl_Group
{
public:
	UI_RChoice *game;
	UI_RChoice *engine;
	UI_RChoice *theme;
	UI_RChoice *length;

public:
	UI_Game(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Game();

public:
	void Locked(bool value);

	// these return false if 'button' is not valid
	bool AddChoice(const char *button, const char *id, const char *label);
	bool EnableChoice(const char *button, const char *id, bool enable_it);
	bool SetButton(const char *button, const char *id);

private:
	static void callback_Game  (Fl_Widget *, void*);
	static void callback_Engine(Fl_Widget *, void*);
	static void callback_Length(Fl_Widget *, void*);
	static void callback_Theme (Fl_Widget *, void*);
};

#endif /* __UI_GAME_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
