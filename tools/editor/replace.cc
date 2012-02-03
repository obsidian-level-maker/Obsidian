//------------------------------------------------------------------------
//  REPLACE : Find and Replace
//------------------------------------------------------------------------
//
//  Lua_Modify  Copyright (C) 2008  Andrew Apted
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
//
//  Based on the "editor.cxx" sample program from FLTK 1.1.6,
//  as described in Chapter 4 of the FLTK Programmer's Guide.
//  
//  Copyright 1998-2004 by Bill Spitzak, Mike Sweet and others.
//
//------------------------------------------------------------------------

#include "headers.h"

#if 0  // TEMPORARILY DISABLED

void find_cb(Fl_Widget* w, void* v)
{
    W_Replace* e = (W_Replace*)v;
    const char *val;

    val = fl_input("Search String:", e->search);
    if (val != NULL)
    {
        // User entered a string - go find it!
        strcpy(e->search, val);
        find2_cb(w, v);
    }
}

void find2_cb(Fl_Widget* w, void* v)
{
    W_Replace* e = (W_Replace*)v;

    if (e->search[0] == '\0')
    {
        // Search string is blank; get a new one...
        find_cb(w, v);
        return;
    }

    int pos = e->editor->insert_position();
    int found = textbuf->search_forward(pos, e->search, &pos);

    if (found)
    {
        // Found a match; select and update the position...
        textbuf->select(pos, pos+strlen(e->search));
        e->editor->insert_position(pos+strlen(e->search));
        e->editor->show_insert_position();
    }
    else fl_alert("No occurrences of \'%s\' found!", e->search);
}


//------------------------------------------------------------------------

static void replace2_cb(Fl_Widget*, void* v)
{
    W_Replace* e = (W_Replace*)v;
    const char *find = e->replace_find->value();
    const char *replace = e->replace_with->value();

    if (find[0] == '\0')
    {
        // Search string is blank; get a new one...
        e->replace_dlg->show();
        return;
    }

    e->replace_dlg->hide();

    int pos = e->editor->insert_position();
    int found = textbuf->search_forward(pos, find, &pos);

    if (found)
    {
        // Found a match; update the position and replace text...
        textbuf->select(pos, pos+strlen(find));
        textbuf->remove_selection();
        textbuf->insert(pos, replace);
        textbuf->select(pos, pos+strlen(replace));
        e->editor->insert_position(pos+strlen(replace));
        e->editor->show_insert_position();
    }
    else
        fl_alert("No occurrences of \'%s\' found!", find);
}

static void replall_cb(Fl_Widget*, void* v)
{
    W_Replace* e = (W_Replace*)v;
    const char *find = e->replace_find->value();
    const char *replace = e->replace_with->value();

    find = e->replace_find->value();
    if (find[0] == '\0')
    {
        // Search string is blank; get a new one...
        e->replace_dlg->show();
        return;
    }

    e->replace_dlg->hide();

    e->editor->insert_position(0);
    int times = 0;

    // Loop through the whole string
    for (int found = 1; found;)
    {
        int pos = e->editor->insert_position();
        found = textbuf->search_forward(pos, find, &pos);

        if (found)
        {
            // Found a match; update the position and replace text...
            textbuf->select(pos, pos+strlen(find));
            textbuf->remove_selection();
            textbuf->insert(pos, replace);
            e->editor->insert_position(pos+strlen(replace));
            e->editor->show_insert_position();
            times++;
        }
    }

    if (times > 0)
        fl_message("Replaced %d occurrences.", times);
    else
        fl_alert("No occurrences of \'%s\' found!", find);
}

static void replcan_cb(Fl_Widget*, void* v)
{
    W_Replace* e = (W_Replace*)v;

    e->replace_dlg->hide();
}


class W_Replace : public Fl_Double_Window
{
public:
    W_Replace(int w, int h, const char *t);
    ~W_Replace();

    Fl_Input           *replace_find;
    Fl_Input           *replace_with;
    Fl_Button          *replace_all;
    Fl_Return_Button   *replace_next;
    Fl_Button          *replace_cancel;

    char search[256];
};

W_Replace::W_Replace(int w, int h, const char *t) : Fl_Double_Window(w, h, t)
{
    replace_find = new Fl_Input(80, 10, 210, 25, "Find:");
    replace_find->align(FL_ALIGN_LEFT);

    replace_with = new Fl_Input(80, 40, 210, 25, "Replace:");
    replace_with->align(FL_ALIGN_LEFT);

    replace_all = new Fl_Button(10, 70, 90, 25, "Replace All");
    replace_all->callback((Fl_Callback *)replall_cb, this);

    replace_next = new Fl_Return_Button(105, 70, 120, 25, "Replace Next");
    replace_next->callback((Fl_Callback *)replace2_cb, this);

    replace_cancel = new Fl_Button(230, 70, 60, 25, "Cancel");
    replace_cancel->callback((Fl_Callback *)replcan_cb, this);

    end();
    set_non_modal();

    search[0] = (char)0;
}

W_Replace::~W_Replace()
{
}

#endif  // TEMPORARILY DISABLED

//--- editor settings ---
// vi:ts=4:sw=4:expandtab
