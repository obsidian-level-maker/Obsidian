//------------------------------------------------------------------------
//  Status Bar
//------------------------------------------------------------------------
//
//  RTS Layout Tool (C) 2007 Andrew Apted
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

#ifndef __E_STATUS_H__
#define __E_STATUS_H__


class W_Status : public Fl_Group
{
public:
  W_Status(int X, int Y, int W, int H, const char *label = NULL);
  virtual ~W_Status();

public:
  int cur_line;
  int cur_col;

  Fl_Box *line_box;
  Fl_Box *column_box;
  Fl_Box *error_box;

public:
  void SetPos(int line, int col);

  void ShowError(const char *msg);
  void ClearError();

private:
};

#endif /* __E_STATUS_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
