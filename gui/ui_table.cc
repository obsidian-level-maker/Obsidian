//----------------------------------------------------------------
//  DEBUGGING & VISUALIZATION
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"

#include "g_lua.h"


#define MY_PURPLE  fl_rgb_color(208,0,208)

#define LINE_H  (22 + KF * 2)


class My_ClipGroup : public Fl_Group
{
public:
  My_ClipGroup(int X, int Y, int W, int H, const char *L = NULL) :
      Fl_Group(X, Y, W, H, L)
  {
    clip_children(1);
  }

  virtual ~My_ClipGroup()
  { }
};


static void ColorFromType(Fl_Widget *w, const char *type)
{
  if (strcmp(type, "table") == 0)
  {
    w->labelcolor(FL_GREEN);
    return;
  }

  if (strcmp(type, "number") == 0)
  {
    w->labelcolor(FL_YELLOW);
    return;
  }

  w->labelcolor(FL_RED);
}


//-----------------------------------------------------------------


UI_TableDatum::UI_TableDatum(int x, int y, int w, int h,
                             const char *_key, const char *_type,
                             const char *_value) :
    Fl_Group(x, y, w, h),
    key(_key), type(_type), value(_value)
{
  end(); // cancel begin() in Fl_Group constructor
 
  resizable(NULL);

//  box(FL_THIN_UP_BOX);
//  color(BUILD_BG, BUILD_BG);

///  mod_button = new Fl_Check_Button(x+5, y+4, w-20, 24+KF*2, label);
///  add(mod_button);
 
  ///  char *datum = StringPrintf("%s = %s", _key, _value);

  Fl_Box *KK = new Fl_Box(FL_NO_BOX, x, y, w/4, h, _key);
  KK->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  KK->labelcolor(FL_BLUE);

  add(KK);

  Fl_Box * VV = new Fl_Box(FL_NO_BOX, x+w/4, y, w-w/4, h, _value);
  VV->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);

  ColorFromType(VV, _type);

  add(VV);


//  hide();
}


UI_TableDatum::~UI_TableDatum()
{
}


int UI_TableDatum::CalcHeight() const
{
  return LINE_H;

/*
  int h = 4 + 24 + KF*2 + 6;  // check button

  if (mod_button->value() && children() > 1)
    h += (children() - 1) * (28 + KF*2) + 4;

  return h;
*/
}


//----------------------------------------------------------------


UI_TableViewer::UI_TableViewer(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
//  box(FL_FLAT_BOX);
//  color(WINDOW_BG, WINDOW_BG);
// color(BUILD_BG, BUILD_BG);


  int cy = y;


  // area for module list
  mx = x+0;
  my = cy;
  mw = w-0 - Fl::scrollbar_size();
  mh = y+h-cy;

  offset_y = 0;
  total_h  = 0;


  sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
  sbar->callback(callback_Scroll, this);

  add(sbar);


  datum_pack = new My_ClipGroup(mx, my, mw, mh);
  datum_pack->end();

///---  datum_pack->align(FL_ALIGN_INSIDE);
///---  datum_pack->labeltype(FL_NORMAL_LABEL);
///---  datum_pack->labelsize(FL_NORMAL_SIZE+6);

  datum_pack->box(FL_FLAT_BOX);
  datum_pack->color(FL_BLACK);
  datum_pack->resizable(NULL);

  add(datum_pack);
}


UI_TableViewer::~UI_TableViewer()
{
}


void UI_TableViewer::AddDatum(const char *_key, const char *_type, const char *_value)
{
  UI_TableDatum *M = new UI_TableDatum(mx, my, mw-4, LINE_H, _key, _type, _value);

///  M->mod_button->callback(callback_ModEnable, M);

  datum_pack->add(M);


  PositionAll();

///???  M->redraw();
}


void UI_TableViewer::PositionAll(UI_TableDatum *focus)
{
  // determine focus [closest to top without going past it]
  if (! focus)
  {
    int best_dist = 9999;

    for (int j = 0; j < datum_pack->children(); j++)
    {
      UI_TableDatum *M = (UI_TableDatum *) datum_pack->child(j);
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
  int spacing = 0;

  for (int k = 0; k < datum_pack->children(); k++)
  {
    UI_TableDatum *M = (UI_TableDatum *) datum_pack->child(k);
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
    for (int k = 0; k < datum_pack->children(); k++)
    {
      UI_TableDatum *M = (UI_TableDatum *) datum_pack->child(k);
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

  for (int j = 0; j < datum_pack->children(); j++)
  {
    UI_TableDatum *M = (UI_TableDatum *) datum_pack->child(j);
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

  datum_pack->redraw();
}


void UI_TableViewer::callback_Scroll(Fl_Widget *w, void *data)
{
  Fl_Scrollbar *sbar = (Fl_Scrollbar *)w;
  UI_TableViewer *that = (UI_TableViewer *)data;

  int previous_y = that->offset_y;

  that->offset_y = sbar->value();

  int dy = that->offset_y - previous_y;

  // simply reposition all the UI_TableDatum widgets
  for (int j = 0; j < that->datum_pack->children(); j++)
  {
    Fl_Widget *F = that->datum_pack->child(j);
    SYS_ASSERT(F);

    F->resize(F->x(), F->y() - dy, F->w(), F->h());
  }

  that->datum_pack->redraw();
}


void UI_TableViewer::callback_Bar(Fl_Widget *w, void *data)
{
  UI_TableDatum *M = (UI_TableDatum *)data;
}


UI_TableViewer *table_view;


void UI_CreateTableViewer()
{
  Fl_Double_Window *win = new Fl_Double_Window(0, 0, 500, 400, "Lua Table Viewer");
  win->end();

  win->color(WINDOW_BG, WINDOW_BG);

  table_view = new UI_TableViewer(0, 0, win->w(), win->h());

  win->add(table_view);

/// FIXME  win->resizable(table_view);

  win->show();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
