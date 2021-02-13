//------------------------------------------------------------------------
//  Custom Module list
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "m_lua.h"
#include "main.h"


UI_Module::UI_Module(int X, int Y, int W, int H,
					 const char *id, const char *label,
					 const char *tip) :
	Fl_Group(X, Y, W, H),
	id_name(id),
	choice_map(),
	cur_opt_y(0)
{
	box(FL_THIN_UP_BOX);

	mod_button = new Fl_Check_Button(X + kf_w(6), Y + kf_h(4), W - kf_w(12), kf_h(24));

	if (Is_UI())
	{
		mod_button->value(1);
		mod_button->hide();
	}

	int tx = Is_UI() ? 8 : 28;

	Fl_Box *heading = new Fl_Box(FL_NO_BOX, X + kf_w(tx), Y + kf_h(4), W - kf_w(tx+4), kf_h(24), label);
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labelfont(FL_HELVETICA_BOLD);

	if (Is_UI())
		heading->labelsize(header_font_size);

	if (tip)
	{
		mod_button->tooltip(tip);
		heading->tooltip(tip);
	}

	cur_opt_y += kf_h(32);

	end();

	resizable(NULL);

	hide();
}


UI_Module::~UI_Module()
{ }


bool UI_Module::Is_UI() const
{
	return (id_name[0] == 'u' &&
			id_name[1] == 'i' &&
			id_name[2] == '_');
}


typedef struct
{
	UI_Module  *mod;
	const char *opt_name;
}
opt_change_callback_data_t;


void UI_Module::AddOption(const char *opt, const char *label, const char *tip,
						  int gap, Fl_Color select_col)
{
	int nw = kf_w(112);
//	int nh = kf_h(30);

	int nx = x() + w() - nw - kf_w(10);
	int ny = y() + cur_opt_y;

	// make label with ': ' suffixed
	int len = strlen(label);
	char *new_label = StringNew(len + 4);
	strcpy(new_label, label);
	strcat(new_label, ": ");

	UI_RChoice *rch = new UI_RChoice(nx, ny, nw, kf_h(24), new_label);
	rch->align(FL_ALIGN_LEFT);
	rch->selection_color(select_col);

	if (! tip)
		tip = "";
	rch->tooltip(tip);

	opt_change_callback_data_t *cb_data = new opt_change_callback_data_t;
	cb_data->mod = this;
	cb_data->opt_name = StringDup(opt);

	rch->callback(callback_OptChange, cb_data);

	if (! mod_button->value())
		rch->hide();

	add(rch);

	cur_opt_y += gap ? kf_h(44) : kf_h(30);

	resize(x(), y(), w(), CalcHeight());
	redraw();

	choice_map[opt] = rch;
}


int UI_Module::CalcHeight() const
{
	if (mod_button->value())
		return cur_opt_y + kf_h(6);
	else
		return kf_h(34);
}


void UI_Module::update_Enable()
{
	std::map<std::string, UI_RChoice *>::const_iterator IT;

	for (IT = choice_map.begin() ; IT != choice_map.end() ; IT++)
	{
		UI_RChoice *M = IT->second;

		if (mod_button->value())
			M->show();
		else
			M->hide();
	}
}


void UI_Module::AddOptionChoice(const char *option, const char *id, const char *label)
{
	UI_RChoice *rch = FindOpt(option);

	if (! rch)
	{
		LogPrintf("Warning: module '%s' lacks option '%s' (for choice '%s')\n",
				id_name.c_str(), option, id);
		return;
	}

	rch->AddChoice(id, label);
	rch->EnableChoice(id, 1);
}


bool UI_Module::SetOption(const char *option, const char *value)
{
	UI_RChoice *rch = FindOpt(option);

	if (! rch)
		return false;

	rch->ChangeTo(value);

	return true;
}


UI_RChoice * UI_Module::FindOpt(const char *option)
{
	if (choice_map.find(option) == choice_map.end())
		return NULL;

	return choice_map[option];
}


void UI_Module::callback_OptChange(Fl_Widget *w, void *data)
{
	UI_RChoice *rch = (UI_RChoice*) w;

	opt_change_callback_data_t *cb_data = (opt_change_callback_data_t*) data;

	SYS_ASSERT(rch);
	SYS_ASSERT(cb_data);

	UI_Module *M = cb_data->mod;

	ob_set_mod_option(M->id_name.c_str(), cb_data->opt_name, rch->GetID());
}


//----------------------------------------------------------------


UI_CustomMods::UI_CustomMods(int X, int Y, int W, int H, Fl_Color _button_col) :
	Fl_Group(X, Y, W, H),
	button_col(_button_col)
{
	box(FL_FLAT_BOX);

	color(WINDOW_BG, WINDOW_BG);


	int cy = Y;


	// area for module list
	mx = X;
	my = cy;
	mw = W - Fl::scrollbar_size();
	mh = Y + H - cy;

	offset_y = 0;
	total_h  = 0;


	sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
	sbar->callback(callback_Scroll, this);

	sbar->color(FL_DARK3+1, FL_DARK1);


	mod_pack = new Fl_Group(mx, my, mw, mh);
	mod_pack->clip_children(1);
	mod_pack->end();

	mod_pack->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM);
	mod_pack->labeltype(FL_NORMAL_LABEL);
	mod_pack->labelsize(FL_NORMAL_SIZE * 3 / 2);

	mod_pack->labelcolor(FL_DARK1);

	mod_pack->box(FL_FLAT_BOX);
	mod_pack->color(WINDOW_BG);  
	mod_pack->resizable(NULL);


	end();
}


UI_CustomMods::~UI_CustomMods()
{ }


typedef struct
{
	UI_Module     *mod;
	UI_CustomMods *parent;
}
mod_enable_callback_data_t;


void UI_CustomMods::AddModule(const char *id, const char *label, const char *tip)
{
	UI_Module *M = new UI_Module(mx, my, mw-4, kf_h(34), id, label, tip);

	mod_enable_callback_data_t *cb_data = new mod_enable_callback_data_t;
	cb_data->mod = M;
	cb_data->parent = this;

	if (! M->Is_UI())
		M->mod_button->callback(callback_ModEnable, cb_data);

	mod_pack->add(M);

	PositionAll();
}


bool UI_CustomMods::AddOption(const char *module, const char *option,
							  const char *label, const char *tip,
							  int gap)
{
	UI_Module *M = FindID(module);

	if (! M)
		return false;

	M->AddOption(option, label, tip, gap, button_col);

	PositionAll();

	return true;
}


void UI_CustomMods::AddOptionChoice(const char *module, const char *option,
                                    const char *id, const char *label)
{
	UI_Module *M = FindID(module);

	if (! M)
		return;

	M->AddOptionChoice(option, id, label);
}


bool UI_CustomMods::ShowModule(const char *id, bool new_shown)
{
	SYS_ASSERT(id);

	UI_Module *M = FindID(id);

	if (! M)
		return false;

	if ((M->visible() ? 1:0) == (new_shown ? 1:0))
		return true;

	// visibility definitely changed

	if (new_shown)
		M->show();
	else
		M->hide();

	PositionAll();

	return true;
}


bool UI_CustomMods::SetOption(const char *module, const char *option,
							  const char *value)
{
	UI_Module *M = FindID(module);

	if (! M)
		return false;

	return M->SetOption(option, value);
}


bool UI_CustomMods::EnableMod(const char *id, bool enable)
{
	SYS_ASSERT(id);

	UI_Module *M = FindID(id);

	if (! M)
		return false;

	if ((M->mod_button->value() ? 1:0) == (enable ? 1:0))
		return true; // no change

	M->mod_button->value(enable ? 1 : 0);
	M->update_Enable();

	// no options => no height change => no need to reposition
	if (M->choice_map.size() > 0)
	{
		PositionAll();
	}

	return true;
}


void UI_CustomMods::PositionAll(UI_Module *focus)
{
	// determine focus [closest to top without going past it]
	if (! focus)
	{
		int best_dist = 9999;

		for (int j = 0 ; j < mod_pack->children() ; j++)
		{
			UI_Module *M = (UI_Module *) mod_pack->child(j);
			SYS_ASSERT(M);

			if (!M->visible() || M->y() < my || M->y() >= my+mh)
				continue;

			int dist = M->y() - my;

			if (dist < best_dist)
			{
				focus = M;
				best_dist = dist;
			}
		}
	}


	// calculate new total height
	int new_height = 0;
	int spacing = 4;

	for (int k = 0 ; k < mod_pack->children() ; k++)
	{
		UI_Module *M = (UI_Module *) mod_pack->child(k);
		SYS_ASSERT(M);

		if (M->visible())
			new_height += M->CalcHeight() + spacing;
	}


	// determine new offset_y
	if (new_height <= mh)
	{
		offset_y = 0;
	}
	else if (focus)
	{
		int focus_oy = focus->y() - my;

		int above_h = 0;
		for (int k = 0 ; k < mod_pack->children() ; k++)
		{
			UI_Module *M = (UI_Module *) mod_pack->child(k);
			if (M->visible() && M->y() < focus->y())
			{
				above_h += M->CalcHeight() + spacing;
			}
		}

		offset_y = above_h - focus_oy;

		offset_y = MAX(offset_y, 0);
		offset_y = MIN(offset_y, new_height - mh);
	}
	else
	{
		// when not shrinking, offset_y will remain valid
		if (new_height < total_h)
			offset_y = 0;
	}

	total_h = new_height;

	SYS_ASSERT(offset_y >= 0);
	SYS_ASSERT(offset_y <= total_h);


	// reposition all the modules
	int ny = my - offset_y;

	for (int j = 0 ; j < mod_pack->children() ; j++)
	{
		UI_Module *M = (UI_Module *) mod_pack->child(j);
		SYS_ASSERT(M);

		int nh = M->visible() ? M->CalcHeight() : 1;

		if (ny != M->y() || nh != M->h())
		{
			M->resize(M->x(), ny, M->w(), nh);
		}

		if (M->visible())
			ny += M->CalcHeight() + spacing;
	}


	// p = position, first line displayed
	// w = window, number of lines displayed
	// t = top, number of first line
	// l = length, total number of lines
	sbar->value(offset_y, mh, 0, total_h);

	mod_pack->redraw();
}


void UI_CustomMods::callback_Scroll(Fl_Widget *w, void *data)
{
	UI_CustomMods *that = (UI_CustomMods *)data;

	Fl_Scrollbar *sbar = (Fl_Scrollbar *)w;

	int previous_y = that->offset_y;

	that->offset_y = sbar->value();

	int dy = that->offset_y - previous_y;

	// simply reposition all the UI_Module widgets
	for (int j = 0; j < that->mod_pack->children(); j++)
	{
		Fl_Widget *F = that->mod_pack->child(j);
		SYS_ASSERT(F);

		F->resize(F->x(), F->y() - dy, F->w(), F->h());
	}

	that->mod_pack->redraw();
}


void UI_CustomMods::callback_ModEnable(Fl_Widget *w, void *data)
{
	mod_enable_callback_data_t *cb_data = (mod_enable_callback_data_t*) data;
	SYS_ASSERT(cb_data);

	UI_Module *M = cb_data->mod;

	M->update_Enable();

	// no options => no height change => no need to reposition
	if (M->choice_map.size() > 0)
	{
		cb_data->parent->PositionAll(M);
	}

	ob_set_mod_option(M->id_name.c_str(), "self", M->mod_button->value() ? "true" : "false");
}


UI_Module * UI_CustomMods::FindID(const char *id) const
{
	for (int j = 0 ; j < mod_pack->children() ; j++)
	{
		UI_Module *M = (UI_Module *) mod_pack->child(j);
		SYS_ASSERT(M);

		if (strcmp(M->id_name.c_str(), id) == 0)
			return M;
	}

	return NULL;
}


void UI_CustomMods::Locked(bool value)
{
	if (value)
	{
		mod_pack->deactivate();
	}
	else
	{
		mod_pack->activate();
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
