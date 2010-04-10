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


#define CONSOLE_BG  FL_BLACK

#define CONSOLE_FONT  FL_COURIER
#define CON_FONT_H    (14 + KF * 2)

#define CON_LINES   512


#define LINE_H  (18 + KF * 2)


class UI_Console;

static UI_Console       *console_body;
static Fl_Double_Window *console_win;


void ConExecute(const char *cmd);  // fwd decl


#define MY_FL_COLOR(R,G,B) \
          (Fl_Color) (((R) << 24) | ((G) << 16) | ((B) << 8))

static Fl_Color digit_colors[10] =
{
  MY_FL_COLOR(96,  96, 96),  // 0 : dark grey
  MY_FL_COLOR(255, 64, 64),  // 1 : red
  MY_FL_COLOR(72, 255, 72),  // 2 : green
  MY_FL_COLOR(255,255,128),  // 3 : yellow

  MY_FL_COLOR(128,128,255),  // 4 : blue
  MY_FL_COLOR(0,  255,255),  // 5 : cyan
  MY_FL_COLOR(224,  0,224),  // 6 : purple
  MY_FL_COLOR(208,208,208),  // 7 : white

  MY_FL_COLOR(255,176, 64),  // 8 : orange
  MY_FL_COLOR(200,144,112),  // 9 : brown
};


class UI_ConLine : public Fl_Group
{
friend class UI_Console;

private:
  std::string unparsed;

private:
  void AddBox(int& px, const char *text, int col)
  {
    SYS_ASSERT(col >= 0 && col < 10);

    Fl_Box *K = new Fl_Box(FL_NO_BOX, px, y(), w(), h(), NULL);

    K->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    K->labelcolor(digit_colors[col]);
//!!    K->labelfont(CONSOLE_FONT);
    K->labelsize(CON_FONT_H);
    K->copy_label(text);

    add(K);

    fl_font(K->labelfont(), K->labelsize());

    int pw=0, ph=0;  fl_measure(text, pw, ph);

    px += pw;
  }

  void Parse()
  {
    // convert the text into one or more Fl_Boxs

    int px = x();
    int color = 7;

    char *text = StringDup(unparsed.c_str());
    char *pos  = text;
    char *next;

    while (pos && *pos)
    {
      next = strchr(pos, '@');

      // the '@' is not special when followed by whitespace
      if (next && isspace(next[1]))
      {
        next[1] = '@'; // escape it for FLTK
        next = strchr(next+2, '@');
      }

      if (next) *next++ = 0;

      AddBox(px, pos, color);

      if (next)
      {
        if (isdigit(*next))
        {
          color = *next++;
          color -= '0';
        }
        else if (isalpha(*next))
        {
          char special = *next++;

          // TODO
        }
      }

      pos = next;
    }

    StringFree(text);
  }

public:
  UI_ConLine(int x, int y, int w, int h, const char *line) :
      Fl_Group(x, y, w, h), unparsed(line)
  {
    end(); // cancel begin() in Fl_Group constructor
   
    resizable(NULL);

    Parse();
  }

  virtual ~UI_ConLine()
  {
    // TODO
  }

public:
  int CalcHeight() const
  {
    return LINE_H;
  }
};


//----------------------------------------------------------------

class UI_ConInput : public Fl_Group
{
friend class UI_Console;

private:
///  Fl_Box *box;

  Fl_Input *input;

private:
  void Update()
  {
    char new_lab[256];

//    sprintf(new_lab, "> %s_", buffer.c_str());

//    box->copy_label(new_lab);
  }

public:
  UI_ConInput(int x, int y, int w, int h) :
      Fl_Group(x, y, w, h)
  {
    end(); // cancel begin() in Fl_Group constructor
   
    resizable(NULL);

///---    box(FL_FLAT_BOX);
///---    color(BUILD_BG, BUILD_BG);

    int cx = x;
/*
    box = new Fl_Box(FL_NO_BOX, cx, y, 50, h, "DEBUG>");
    box->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT);
    box->labelcolor(digit_colors[6]);

    add(box);

    cx = cx + box->w();
*/    
    input = new Fl_Input(cx+4, y, w-cx-8, h); /// , "DEBUG>");

///---    input->align(FL_ALIGN_LEFT);
///---    input->labelcolor(digit_colors[6]);

    input->when(FL_WHEN_ENTER_KEY_ALWAYS);
    input->callback(callback_Enter, this);

    add(input);
  }

  virtual ~UI_ConInput()
  {
    // TODO
  }

private:
  static void callback_Enter(Fl_Widget *w, void *data)
  {
    UI_ConInput *that = (UI_ConInput *) data;

    ConExecute(that->input->value());

    that->input->value("");
  }
};


//----------------------------------------------------------------

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


class UI_Console : public Fl_Group
{
private:
  int count;

  Fl_Group *all_lines;

  Fl_Scrollbar *sbar;

  UI_ConInput *input;

  // area occupied by datum list
  int mx, my, mw, mh;

  // number of pixels "lost" above the top of the module area
  int offset_y;

  // total height of all shown data
  int total_h;

private:
  void PositionAll(UI_ConLine *focus = NULL);

public:
  UI_Console(int x, int y, int w, int h, const char *label = NULL) :
      Fl_Group(x, y, w, h, label),
      count(0), offset_y(0), total_h(0)
  {
    end(); // cancel begin() in Fl_Group constructor
   
    int cy = y;

    // area for module list
    mx = x+0;
    my = cy;
    mw = w-0 - Fl::scrollbar_size();
    mh = y+h-cy;


    sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
    sbar->callback(callback_Scroll, this);

    add(sbar);


    all_lines = new My_ClipGroup(mx+4, my+4, mw-8, mh-48);
    all_lines->end();

    all_lines->box(FL_FLAT_BOX);
    all_lines->color(CONSOLE_BG);
    all_lines->resizable(NULL);

    add(all_lines);


    input = new UI_ConInput(mx+4, my+mh-36, mw-8, 28);

    add(input);

    mh = mh - 48;
  }

  virtual ~UI_Console()
  {
    // TODO
  }

public:
  void AddLine(const char *line)
  {
    if (count >= CON_LINES)
    {
      all_lines->remove(all_lines->child(0));
      count--;
    }

    UI_ConLine *M = new UI_ConLine(mx, my, mw-4, LINE_H, line);

  ///  M->mod_button->callback(callback_ModEnable, M);

    all_lines->add(M);
    count++;

    PositionAll();

  ///???  M->redraw();
  }

  static void callback_Scroll(Fl_Widget *w, void *data);
  static void callback_Bar(Fl_Widget *w, void *data);
};


void UI_Console::PositionAll(UI_ConLine *focus)
{
  // determine focus [closest to top without going past it]
  if (! focus)
  {
    int best_dist = 9999;

    for (int j = 0; j < all_lines->children(); j++)
    {
      UI_ConLine *M = (UI_ConLine *) all_lines->child(j);
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

  for (int k = 0; k < all_lines->children(); k++)
  {
    UI_ConLine *M = (UI_ConLine *) all_lines->child(k);
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
    for (int k = 0; k < all_lines->children(); k++)
    {
      UI_ConLine *M = (UI_ConLine *) all_lines->child(k);
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

  for (int j = 0; j < all_lines->children(); j++)
  {
    UI_ConLine *M = (UI_ConLine *) all_lines->child(j);
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

  all_lines->redraw();
}


void UI_Console::callback_Scroll(Fl_Widget *w, void *data)
{
  Fl_Scrollbar *sbar = (Fl_Scrollbar *)w;
  UI_Console *that = (UI_Console *)data;

  int previous_y = that->offset_y;

  that->offset_y = sbar->value();

  int dy = that->offset_y - previous_y;

  // simply reposition all the UI_ConLine widgets
  for (int j = 0; j < that->all_lines->children(); j++)
  {
    Fl_Widget *F = that->all_lines->child(j);
    SYS_ASSERT(F);

    F->resize(F->x(), F->y() - dy, F->w(), F->h());
  }

  that->all_lines->redraw();
}


void UI_Console::callback_Bar(Fl_Widget *w, void *data)
{
  UI_ConLine *M = (UI_ConLine *)data;
}


//----------------------------------------------------------------

void UI_OpenConsole()
{
  if (console_win)
    return;

  console_win = new Fl_Double_Window(0, 0, 600, 400, "OBLIGE CONSOLE");
  console_win->end();

  console_win->color(CONSOLE_BG, CONSOLE_BG);

  if (! console_body)
  {
    console_body = new UI_Console(0, 0, console_win->w(), console_win->h());
  }
  // else RESIZE body to WIN SIZE

  console_win->add(console_body);

/// FIXME  console_win->resizable(console_body);

  console_win->show();
}

void UI_CloseConsole()
{
  if (console_win)
  {
    // we keep the body around
    console_win->remove(console_body);

    delete console_win;
    console_win = NULL;
  }
}

void UI_ToggleConsole()
{
  if (console_win)
    UI_CloseConsole();
  else
    UI_OpenConsole();
}


void ConPrintf(const char *str, ...)
{
  if (console_body)
  {
    static char buffer[MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
    va_end(args);

    buffer[MSG_BUF_LEN-2] = 0;

    // prefix each debugging line with a special symbol

    char *pos = buffer;
    char *next;

    while (pos && *pos)
    {
      next = strchr(pos, '\n');

      if (next) *next++ = 0;

      console_body->AddLine(pos);

      pos = next;
    }
  }
}


void ConExecute(const char *cmd)
{
  ConPrintf("@6> %s\n", cmd);

  // FIXME: ConExecute
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
