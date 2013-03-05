//------------------------------------------------------------------------
//  Custom Mod list
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

#ifndef __UI_MODS_H__
#define __UI_MODS_H__


class UI_Module : public Fl_Group
{
friend class UI_CustomMods;

private:
	std::string id_name;

	Fl_Check_Button *mod_button;  

	std::map<std::string, UI_RChoice *> choice_map;

public:
	UI_Module(int x, int y, int w, int h, const char *id, const char *label);
	virtual ~UI_Module();

	void AddOption(const char *option, const char *label);

	void OptionPair(const char *option, const char *id, const char *label);

	bool ParseValue(const char *option, const char *value);

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

public:
	UI_CustomMods(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_CustomMods();

public:
	void AddModule(const char *id, const char *label);

	bool ShowOrHide(const char *id, bool new_shown);

	void ChangeValue(const char *id, bool enable);

	void AddOption (const char *module, const char *option, const char *label);

	void OptionPair(const char *module, const char *option,
			const char *id, const char *label);

	bool ParseOptValue(const char *module, const char *option,
			const char *value);

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
