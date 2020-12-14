//------------------------------------------------------------------------
//  Custom Mod list
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

#ifndef __UI_MODS_H__
#define __UI_MODS_H__


class UI_Module : public Fl_Group
{
friend class UI_CustomMods;

	// NOTES:
	// -  module is "enabled" when mod_button->value() == 1
	// -  module is "shown" when visible() == true

private:
	std::string id_name;

	Fl_Check_Button *mod_button;  

	std::map<std::string, UI_RChoice *> choice_map;

	// only used while positioning the options (as they are added)
	int cur_opt_y;

public:
	UI_Module(int X, int Y, int W, int H, const char *id, const char *label, const char *tip);
	virtual ~UI_Module();

	void AddOption(const char *option, const char *label, const char *tip,
	               int gap, Fl_Color select_col);

	void AddOptionChoice(const char *option, const char *id, const char *label);

	bool SetOption(const char *option, const char *value);

	bool Is_UI() const;

public:
	int CalcHeight() const;

	void update_Enable();

protected:
	UI_RChoice *FindOpt(const char *opt); // const;

private:
	static void callback_OptChange(Fl_Widget *w, void *data);
};


class UI_CustomMods : public Fl_Group
{
private:
	Fl_Group *mod_pack;

	Fl_Scrollbar *sbar;

	// area occupied by module list
	int mx, my, mw, mh;

	// number of pixels "lost" above the top of the module area
	int offset_y;

	// total height of all shown modules
	int total_h;

	// highlight color for option buttons
	Fl_Color button_col;

public:
	UI_CustomMods(int X, int Y, int W, int H, Fl_Color _button_col);
	virtual ~UI_CustomMods();

public:
	void AddModule(const char *id, const char *label, const char *tip);

	// these return false if module is unknown
	bool ShowModule(const char *id, bool new_shown);
	bool EnableMod(const char *id, bool enable);

	bool AddOption (const char *module, const char *option, const char *label,
	                const char *tip, int gap);

	void AddOptionChoice(const char *module, const char *option,
						 const char *id, const char *label);

	bool SetOption(const char *module, const char *option, const char *value);

	void Locked(bool value);

private:
	UI_Module *FindID(const char *id) const;

	void PositionAll(UI_Module *focus = NULL);

	static void callback_Scroll(Fl_Widget *w, void *data);
	static void callback_ModEnable(Fl_Widget *w, void *data);
};


#endif /* __UI_MODS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
