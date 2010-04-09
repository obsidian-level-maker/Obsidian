//------------------------------------------------------------------------
//  DEBUGGING & VISUALIZATION
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#ifndef __UI_DEBUG_H__
#define __UI_DEBUG_H__


class UI_TableDatum : public Fl_Group
{
friend class UI_TableViewer;

private:
  std::string key;
  std::string type;
  std::string value;

public:
  UI_TableDatum(int x, int y, int w, int h,
                const char *_key, const char *_type, const char *_value);
  virtual ~UI_TableDatum();

public:
  int CalcHeight() const;

private:
//  static void callback_Foo(Fl_Widget *w, void *data);
};


class UI_TableViewer : public Fl_Group
{
private:
  Fl_Group *datum_pack;

  Fl_Scrollbar *sbar;

  // area occupied by datum list
  int mx, my, mw, mh;

  // number of pixels "lost" above the top of the module area
  int offset_y;

  // total height of all shown data
  int total_h;

public:
  UI_TableViewer(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_TableViewer();

public:
  void AddDatum(const char *_key, const char *_type, const char *_value);

private:
  void PositionAll(UI_TableDatum *focus = NULL);

  static void callback_Scroll(Fl_Widget *w, void *data);
  static void callback_Bar(Fl_Widget *w, void *data);
};


extern UI_TableViewer * table_view;  // FIXME: TEMP STUFF

void UI_CreateTableViewer();


#endif /* __UI_DEBUG_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
