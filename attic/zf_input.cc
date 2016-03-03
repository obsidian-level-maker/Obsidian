//
// Input widget for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2005 by Bill Spitzak and others.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA.
//
// Please report all bugs and problems on the following page:
//
//     http://www.fltk.org/str.php
//

//----------------------------------------------------------------
//
// Modified 25/Sep/2005 by Andrew Apted, from FLTK 1.1.7
//
// Provides an Fl_Name_Input which prevents characters that
// are illegal for the basename of a file from being entered.
//
//----------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include <FL/Fl.H>
#include <FL/Fl_Input.H>
#include <FL/fl_draw.H>
#include <FL/fl_ask.H>

#include "zf_input.h"


Fl_NameInput::Fl_NameInput(int X, int Y, int W, int H,
      const char *l) : Fl_Input_(X, Y, W, H, l)
{ }

void Fl_NameInput::draw()
{
  Fl_Boxtype b = box();
  if (damage() & FL_DAMAGE_ALL) draw_box(b, color());
  Fl_Input_::drawtext(x()+Fl::box_dx(b), y()+Fl::box_dy(b),
		      w()-Fl::box_dw(b), h()-Fl::box_dh(b));
}

// kludge so shift causes selection to extend:
int Fl_NameInput::shift_position(int p)
{
  return position(p, Fl::event_state(FL_SHIFT) ? mark() : p);
}
int Fl_NameInput::shift_up_down_position(int p)
{
  return up_down_position(p, Fl::event_state(FL_SHIFT));
}

#define ctrl(x) ((x)^0x40)

int Fl_NameInput::handle_key()
{
  char ascii = Fl::event_text()[0];
  int repeat_num=1;
  int del;

  if (Fl::compose(del))
  {
    filter_text();

    if (del || Fl::event_length())
    {
      replace(position(), del ? position()-del : mark(),
          Fl::event_text(), Fl::event_length());
    }
    return 1;
  }

  switch (Fl::event_key())
  {
    case FL_Insert:
      if (Fl::event_state() & FL_CTRL) ascii = ctrl('C');
      else if (Fl::event_state() & FL_SHIFT) ascii = ctrl('V');
      break;

    case FL_Delete:
      if (Fl::event_state() & FL_SHIFT) ascii = ctrl('X');
      else ascii = ctrl('D');
      break;

    case FL_Left:
      ascii = ctrl('B');
      break;

    case FL_Right:
      ascii = ctrl('F');
      break;

    case FL_Up:
    case FL_Page_Up:
      ascii = ctrl('P');
      break;

    case FL_Down:
    case FL_Page_Down:
      ascii = ctrl('N');
      break;

    case FL_Home:
      if (Fl::event_state() & FL_CTRL)
      {
        shift_position(0);
        return 1;
      }
      ascii = ctrl('A');
      break;

    case FL_End:
      if (Fl::event_state() & FL_CTRL)
      {
        shift_position(size());
        return 1;
      }
      ascii = ctrl('E');
      break;

    case FL_BackSpace:
      ascii = ctrl('H');
      break;

    case FL_Enter:
    case FL_KP_Enter:
      if (when() & FL_WHEN_ENTER_KEY)
      {
        position(size(), 0);
        maybe_do_callback();
        return 1;
      }
      else
        return 0;	// reserved for shortcuts

    case FL_Tab:
        return 0;

#ifdef __APPLE__
    case 'c' :
    case 'v' :
    case 'x' :
    case 'z' :
      if (Fl::event_state(FL_META)) ascii -= 0x60;
      break;
#endif // __APPLE__
  }

  int i;
  switch (ascii)
  {
    case ctrl('A'):
      return shift_position(line_start(position())) + 1;

    case ctrl('B'):
      return shift_position(position()-1) + 1;

    case ctrl('C'): // copy
      return copy(1);

    case ctrl('D'):
    case ctrl('?'):
      if (mark() != position())
        return cut();
      else
        return cut(1);

    case ctrl('E'):
      return shift_position(line_end(position())) + 1;

    case ctrl('F'):
      return shift_position(position()+1) + 1;

    case ctrl('H'):
      if (mark() != position())
        cut();
      else
        cut(-1);
      return 1;

    case ctrl('K'):
      if (position()>=size()) return 0;
      i = line_end(position());
      if (i == position() && i < size()) i++;
      cut(position(), i);
      return copy_cuts();

    case ctrl('N'):
      i = position();
      if (line_end(i) >= size()) return 1;
      while (repeat_num--)
      {
        i = line_end(i);
        if (i >= size()) break;
        i++;
      }
      shift_up_down_position(i);
      return 1;

    case ctrl('P'):
      i = position();
      if (!line_start(i)) return 1;
      while(repeat_num--)
      {
        i = line_start(i);
        if (!i) break;
        i--;
      }
      shift_up_down_position(line_start(i));
      return 1;

    case ctrl('U'):
      return cut(0, size());

    case ctrl('V'):
    case ctrl('Y'):
      Fl::paste(*this, 1);
      return 1;

    case ctrl('X'):
    case ctrl('W'):
      copy(1);
      return cut();

    case ctrl('Z'):
    case ctrl('_'):
      return undo();
  }

  return 0;
}

int Fl_NameInput::handle(int event)
{
  static int drag_start = -1;
  switch (event)
  {
  case FL_FOCUS:
    switch (Fl::event_key())
    {
    case FL_Right:
      position(0);
      break;

    case FL_Left:
      position(size());
      break;

    case FL_Down:
      up_down_position(0);
      break;

    case FL_Up:
      up_down_position(line_start(size()));
      break;

    case FL_Tab:
    case 0xfe20: // XK_ISO_Left_Tab
      position(size(),0);
      break;

    default:
      position(position(),mark());// turns off the saved up/down arrow position
      break;
    }
    break;

  case FL_KEYBOARD:
    if (Fl::event_key() == FL_Tab && mark() != position())
    {
      // Set the current cursor position to the end of the selection...
      if (mark() > position())
        position(mark());
      else
        position(position());
      return (1);
    }
    else
      return handle_key();

  case FL_PUSH:
    if (Fl::focus() != this)
    {
      Fl::focus(this);
      handle(FL_FOCUS);
    }
    break;

  case FL_RELEASE:
    if (Fl::event_button() == 2)
    {
      Fl::event_is_click(0); // stop double click from picking a word
      Fl::paste(*this, 0);
    }
    else if (!Fl::event_is_click())
    {
      // copy drag-selected text to the clipboard.
      copy(0);
    }
    else if (Fl::event_is_click() && drag_start >= 0)
    {
      // user clicked in the field and wants to reset the cursor position...
      position(drag_start, drag_start);
      drag_start = -1;
    }
    else if (Fl::event_clicks())
    {
      // user double or triple clicked to select word or whole text
      copy(0);
    }

    return 1;
  }

  if (event == FL_PASTE)
    filter_text();

  Fl_Boxtype b = box();

  return Fl_Input_::handletext(event,
            x()+Fl::box_dx(b), y()+Fl::box_dy(b),
            w()-Fl::box_dw(b), h()-Fl::box_dh(b));
}

bool Fl_NameInput::valid_char(char ch)
{
  if (isalnum(ch)) return true;

  switch (ch)
  {
    case '_': case '-':
      return true;

    default:
      return false;
  }
}

void Fl_NameInput::filter_text()
{
  // NOTE: this is evil since we directly modify Fl::e_length
  //       and the Fl::e_text buffer.

  // It's probably messed up for international text too.

  char *s = Fl::e_text;
  char *e = s + Fl::e_length;
  char *d = s;

  for (; s < e; s++)
    if (valid_char(*s))
      *d++ = *s;

  *d = 0;

  Fl::e_length = d - Fl::e_text;
}

