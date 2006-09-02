//------------------------------------------------------------------------
//  Setup screen
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006 Andrew Apted
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

#ifndef __UI_SETUP_H__
#define __UI_SETUP_H__

class UI_Setup : public Fl_Group
{
private:
	Fl_Int_Input *seed;
	Fl_Button *bump;

	Fl_Choice *game;
	Fl_Choice *addon;
	Fl_Choice *length;
	Fl_Choice *mode;

public:
	UI_Setup(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Setup();

public:

	void SetSeed(u32_t new_val);

	void FreshSeed();
	void BumpSeed();

	void Locked(bool value);

	const char *cur_Seed();
	const char *cur_Game();
	const char *cur_Addon();
	const char *cur_Mode();
	const char *cur_Size();
	
private:
	static void bump_callback(Fl_Widget *, void*);

	static const char *game_syms[];
	static const char *addon_syms[];
	static const char *mode_syms[];
	static const char *size_syms[];
};

#endif /* __UI_SETUP_H__ */
