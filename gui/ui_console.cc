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
#include "main.h"

#include "g_lua.h"


#define CONSOLE_BG  FL_BLACK

#define CONSOLE_FONT  FL_COURIER
#define CON_FONT_H    (14 + KF * 2)

#define CON_MAX_LINES    1024
#define CON_MAX_ARGS     32
#define CON_MAX_HISTORY  100

#define MIN_SLIDER_SIZE  0.08


#define LINE_H  (18 + KF * 2)


class UI_Console;
class UI_ConLine;

static UI_Console       *console_body;
static Fl_Double_Window *console_win;

bool debug_onto_console;

char *console_argv[CON_MAX_ARGS];
int   console_argc;

static std::list<std::string> con_saved_lines;
static int con_saved_count = 0;

static UI_ConLine *button_line;
static int button_indent;  // RENAME !!


// forward decls
void ConExecute(const char *cmd);

static bool Script_DoString(const char *str);


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

  std::string button_data;

private:
  void AddBox(int& px, const char *text, int font, int col)
  {
    SYS_ASSERT(col >= 0 && col < 10);

    Fl_Box *K = new Fl_Box(FL_NO_BOX, px, y(), w(), h(), NULL);

    K->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    K->labelcolor(digit_colors[col]);
    K->labelfont(font);
    K->labelsize(CON_FONT_H);
    K->copy_label(text);

    add(K);

    fl_font(K->labelfont(), K->labelsize());

    int pw=0, ph=0;  fl_measure(text, pw, ph);

    px += pw;
  }

  void AddButton(int& px, const char *lab, const char *data)
  {
    int col = 7;
    if (isdigit(lab[0]))
    {
      col = CLAMP(0, lab[0] - '0', 9);
      lab++;
    }

    // FIXME: measure properly
    int bw = 14 + strlen(lab) * 6;

    px += 4;

    Fl_Button *B = new Fl_Button(px, y()+1, bw, h()-2);
    B->align(FL_ALIGN_INSIDE);
    B->color(col, FL_LIGHT1);
    B->labelcolor(FL_BLACK);
    B->copy_label(lab);

    if (col != 7)
      B->color(digit_colors[col], FL_LIGHT1);
    else
      B->color(FL_DARK3, FL_LIGHT3);

    B->callback(callback_Button, this);

    add(B);

    px += bw + 4;

    button_data = data;
  }

  char *ParseButton(int& px, char *pos)
  {
    char *lab = pos;

    while (*pos && *pos != ':' && *pos != '\n')
      pos++;

    if (*pos != ':')
      return lab;

    *pos++ = 0;

    char *data = pos;

    while (*pos && *pos != '@' && *pos != '\n')
      pos++;

    if (*pos != '@')
      return data;

    *pos++ = 0;

    AddButton(px, lab, data);

    return pos;
  }

  void Parse(int px)
  {
    // convert the text into one or more Fl_Boxs

    int color = 7;
    int font  = FL_HELVETICA;

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

      AddBox(px, pos, font, color);

      if (next)
      {
        if (isdigit(*next))
        {
          color = *next++;
          color = CLAMP(0, color - '0', 9);
        }
        else if (isalpha(*next))
        {
          char special = *next++;

          switch (special)
          {
            case 'b':
              next = ParseButton(px, next);
              break;

            case 'c':
              font = FL_COURIER;
              break;

            case 'h':
              font = FL_HELVETICA;
              break;

            default: break;
          }
        }
      }

      pos = next;
    }

    StringFree(text);
  }

public:
  UI_ConLine(int x, int y, int w, int h, const char *line, int indent = 0) :
      Fl_Group(x, y, w, h), unparsed(line)
  {
    end(); // cancel begin() in Fl_Group constructor
   
    resizable(NULL);

    Parse(x + indent * 8);
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

private:
  static void callback_Button(Fl_Widget *w, void *data)
  {
    // TODO: support more than one button per line

    button_line = (UI_ConLine *) data;

    const char *datum = button_line->button_data.c_str();

    if (datum[0] == 'e' && datum[1] == ':')
    {
      datum += 2;

      button_indent = atoi(datum);

      while (isdigit(*datum)) datum++;
      if (*datum == ':') datum++;

      char *lua_code = StringPrintf("ob_console_dump(%s)\n", datum);
      Script_DoString(lua_code);
      StringFree(lua_code);

      button_line = false;

      w->hide();
    }
    else
      fl_beep();
  }
};


//----------------------------------------------------------------

class UI_ConInput : public Fl_Group
{
friend class UI_Console;

private:
  Fl_Input *input;

  char *cmd_history[CON_MAX_HISTORY];

  int hist_used;

  // when browsing the history, this shows the current index.
  // Usually it is -1.
  int browse_pos;

  std::string saved_input;

public:
  UI_ConInput(int x, int y, int w, int h) :
      Fl_Group(x, y, w, h),
      hist_used(0), browse_pos(-1), saved_input()
  {
    end(); // cancel begin() in Fl_Group constructor
   
    for (int i = 0; i < CON_MAX_HISTORY; i++)
      cmd_history[i] = NULL;

    input = new Fl_Input(x, y, w, h);

    input->when(FL_WHEN_ENTER_KEY_ALWAYS);
    input->callback(callback_Enter, this);

    add(input);

    /// resizable(NULL);
  }

  virtual ~UI_ConInput()
  {
    for (int i = 0; i < hist_used; i++)
      StringFree(cmd_history[i]);
  }

private:
  void AddHistory(const char *s)
  {
    // ignore empty lines
    const char *t = s;
    while (isspace(*t)) t++;
    if (*t == 0)
      return;

    // don't add if same as previous command
    if (hist_used > 0)
        if (strcmp(s, cmd_history[0]) == 0)
            return;

    // scroll everything up 
    StringFree(cmd_history[CON_MAX_HISTORY-1]);

    for (int i = CON_MAX_HISTORY-1; i > 0; i--)
      cmd_history[i] = cmd_history[i-1];

    cmd_history[0] = StringDup(s);

    if (hist_used < CON_MAX_HISTORY)
      hist_used++;
  }

  bool HasInput() const
  {
    return strlen(input->value()) > 0;
  }

  void HistoryUp()
  {
    if (browse_pos >= hist_used-1)
      return;

    if (browse_pos == -1)
      saved_input = input->value();

    browse_pos++;

    input->value(cmd_history[browse_pos]);
  }

  void HistoryDown()
  {
    if (browse_pos <= -1)
      return;

    browse_pos--;

    if (browse_pos >= 0)
      input->value(cmd_history[browse_pos]);
    else
      input->value(saved_input.c_str());
  }

  // FLTK virtual method for handling input events.
  int handle(int event)
  {
    if (event == FL_KEYDOWN || event == FL_SHORTCUT)
    {
      int key = Fl::event_key();

      switch (key)
      {
        case FL_Up:
          HistoryUp();
          return 1;

        case FL_Down:
          HistoryDown();
          return 1;

        default: break;
      }
    }

    return Fl_Group::handle(event);
  }

private:
  static void callback_Enter(Fl_Widget *w, void *data)
  {
    UI_ConInput *that = (UI_ConInput *) data;

    that->AddHistory(that->input->value());

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

  // number of pixels "lost" above the top of the module area
  int offset_y;

  // total height of all shown data
  int total_h;

private:
  void Repos(int new_offset, bool call_cb = false)
  {
    // p = position, first line displayed
    // w = window, number of lines displayed
    // t = top, number of first line
    // l = length, total number of lines
    sbar->value(new_offset, all_lines->h(), 0, total_h);

    // ensure knob never gets too small
    if (sbar->slider_size() < MIN_SLIDER_SIZE)
        sbar->slider_size(MIN_SLIDER_SIZE);

    if (call_cb)
      callback_Scroll(sbar, this);
    else
      all_lines->redraw();
  }

  void PositionAll(bool jump_bottom = false, UI_ConLine *focus = NULL);

public:
  UI_Console(int x, int y, int w, int h, const char *label = NULL) :
      Fl_Group(x, y, w, h, label),
      count(0), offset_y(0), total_h(0)
  {
    end(); // cancel begin() in Fl_Group constructor
   
    int sb_w = Fl::scrollbar_size();
    int in_h = 28 + KF * 2;


    sbar = new Fl_Scrollbar(x + w - sb_w, y, sb_w, h);
    sbar->callback(callback_Scroll, this);
    sbar->color(FL_DARK3+1, FL_DARK3+1);

    add(sbar);


    input = new UI_ConInput(x+4, y+h-in_h, w-sb_w-8, in_h-4);

    add(input);


    all_lines = new My_ClipGroup(x+4, y+4, w-sb_w-8, h-in_h-4);
    all_lines->end();

    all_lines->box(FL_FLAT_BOX);
    all_lines->color(CONSOLE_BG);
    all_lines->resizable(NULL);

    add(all_lines);

    resizable(all_lines);


    // ensure not empty
    AddLine("");
  }

  virtual ~UI_Console()
  {
    // TODO
  }

public:
  void Clear()
  {
    all_lines->clear();

    AddLine("");
  }

  void AddLine(const char *line)
  {
    bool at_bottom = (1 + sbar->value() > sbar->maximum());

    if (count >= CON_MAX_LINES)
    {
      all_lines->remove(all_lines->child(0));
      count--;
    }

    int mx = all_lines->x();
    int my = all_lines->y();
    int mw = all_lines->w();

    UI_ConLine *M = new UI_ConLine(mx, my, mw, LINE_H, line, button_indent);

  ///  M->mod_button->callback(callback_ModEnable, M);

    if (button_line)
    {
      all_lines->insert(*M, 1 + all_lines->find(button_line));
      button_line = M;  // FIXME
      at_bottom = false;
    }
    else
      all_lines->add(M);

    count++;

    PositionAll(at_bottom);
  }

private:
  void PageUp()
  {
    int dy = MAX(LINE_H, all_lines->h() - LINE_H);

    int new_offset = MAX(0, offset_y - dy);

    Repos(new_offset, true);
  }

  void PageDown()
  {
    int dy = MAX(LINE_H, all_lines->h() - LINE_H);

    int new_offset = MIN(total_h - all_lines->h(), offset_y + dy);

    Repos(new_offset, true);
  }

  // FLTK virtual method for handling input events.
  int handle(int event)
  {
    if (event == FL_KEYDOWN || event == FL_SHORTCUT)
    {
      int key = Fl::event_key();

      switch (key)
      {
        // do our own PAGE-UP and PAGE-DOWN handling, since FLTK jumps
        // too far after we sane-ified the slider_size.
        case FL_Page_Up:
          PageUp();
          return 1;

        case FL_Page_Down:
          PageDown();
          return 1;

        default: break;
      }
    }

    return Fl_Group::handle(event);
  }

private:
  static void callback_Scroll(Fl_Widget *w, void *data);
};


void UI_Console::PositionAll(bool jump_bottom, UI_ConLine *focus)
{
  // determine focus [closest to top without going past it]
  int my = all_lines->y();
  int mh = all_lines->h();

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
  else if (jump_bottom)
  {
    offset_y = new_height - mh;
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


  Repos(offset_y);
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


//----------------------------------------------------------------

void UI_OpenConsole()
{
  if (console_win)
    return;

  console_win = new Fl_Double_Window(0, 0, 600, 400, "OBLIGE CONSOLE");
  console_win->end();

  console_win->size_range(240, 160);
  console_win->color(CONSOLE_BG, CONSOLE_BG);

  if (! console_body)
  {
    console_body = new UI_Console(0, 0, console_win->w(), console_win->h());
  }
  // else RESIZE body to WIN SIZE

  console_win->add(console_body);
  console_win->resizable(console_body);

  console_win->show();

  // add the saved lines
  while (! con_saved_lines.empty())
  {
    console_body->AddLine(con_saved_lines.front().c_str());

    con_saved_lines.pop_front();
  }
}

void UI_CloseConsole()
{
  if (! console_win)
    return;

  // we keep the body around (FIXME: don't)
  console_win->remove(console_body);

  delete console_win;
  console_win = NULL;
}

void UI_ToggleConsole()
{
  if (console_win)
    UI_CloseConsole();
  else
    UI_OpenConsole();
}


static void DoAddLine(const char *line)
{
  if (console_win)
  {
    console_body->AddLine(line);
    return;
  }

  // save the line

  if (con_saved_count >= CON_MAX_LINES)
  {
    con_saved_lines.pop_front();
    con_saved_count--;
  }

  con_saved_lines.push_back(line);
  con_saved_count++;
}

void ConPrintf(const char *str, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list args;

  va_start(args, str);
  vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
  va_end(args);

  buffer[MSG_BUF_LEN-2] = 0;

  // split into lines
  char *pos = buffer;
  char *next;

  while (pos && *pos)
  {
    next = strchr(pos, '\n');

    if (next) *next++ = 0;

    DoAddLine(pos);

    pos = next;
  }
}


//----------------------------------------------------------------

extern lua_State *LUA_ST;  // Fixme ?


static bool Script_DoString(const char *str)  // FIXME VARARG-ify
{
  lua_getglobal(LUA_ST, "ob_traceback");
 
  if (lua_type(LUA_ST, -1) == LUA_TNIL)
    Main_FatalError("LUA script problem: missing function '%s'", "ob_traceback");

  int status = luaL_loadbuffer(LUA_ST, str, strlen(str), "=CONSOLE");

  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    ConPrintf("Error: @1Bad Syntax or Unknown Command\n");

    lua_remove(LUA_ST, -1);
    return false;
  }

  status = lua_pcall(LUA_ST, 0, 0, -2);
  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    // skip the filename
    const char *err_msg = strstr(msg, ": ");
    if (err_msg)
      err_msg += 2;
    else
      err_msg = msg;

    ConPrintf("\nError: @1%s", err_msg);
    ConPrintf("\n");
  }
 
  // remove the traceback function
  lua_remove(LUA_ST, -1);

  return (status == 0) ? true : false;
}

void CMD_PrintExpr(const char *expr)
{
  while (isspace(*expr))
    expr++;

  ConPrintf("%s = \n", expr);

  char *lua_code = StringPrintf("ob_console_dump(%s)", expr);

  Script_DoString(lua_code);

  StringFree(lua_code);
}

void CMD_Args(void)
{
  ConPrintf("Arguments:\n");

	for (int i = 0; i < console_argc; i++)
  {
    const char *arg = console_argv[i];

		ConPrintf("  %2d = \"%s\" (len %d)\n", i, arg, (int)strlen(arg));
  }
}

void CMD_Clear(void)
{
  console_body->Clear();
}

void CMD_Help(void)
{
  // FIXME: make this even more helpful
  ConPrintf("We all need help, buddy.\n");
}


typedef struct
{
	const char *name;

	void (* func)(void);
}
con_cmd_t;

//
// Current console commands
//
const con_cmd_t builtin_commands[] =
{
	{ "args",           CMD_Args },
	{ "clear",          CMD_Clear },
	{ "help",           CMD_Help },

	// end of list
	{ NULL, NULL }
};


static int FindCommand(const char *line)
{
	for (int i = 0; builtin_commands[i].name; i++)
	{
    const char *name = builtin_commands[i].name;

		if (StringCaseCmpPartial(line, name) == 0)
      return i;
	}

  return -1;  // not found
}

static void ParseArgs(const char *line)
{
	console_argc = 0;

	for (;;)
	{
		while (isspace(*line))
			line++;

		if (! *line)
			break;

		// silent truncation (bad?)
		if (console_argc >= CON_MAX_ARGS)
			break;

		const char *start = line;

		if (*line == '"')
		{
			start++; line++;

			while (*line && *line != '"')
				line++;
		}
		else
		{
			while (*line && !isspace(*line))
				line++;
		}

		// ignore empty strings at beginning of the line
		if (! (console_argc == 0 && start == line))
		{
			console_argv[console_argc++] = StringDup(start, line - start);
		}

		if (*line)
			line++;
	}
}

static void KillArgs()
{
	for (int i = 0; i < console_argc; i++)
  {
		StringFree(console_argv[i]);
  }
}


void ConExecute(const char *cmd)
{
  if (! console_win)
    return;

  if (cmd[0] == '?')
  {
    CMD_PrintExpr(cmd+1);
    return;
  }

  // display line, removing any @ symbols (TODO: escape them properly)
  char *display = StringDup(cmd);
  for (char *pos = display; *pos; pos++)
    if (*pos == '@')
      *pos = '*';

  ConPrintf("@6> %s\n", display);
  StringFree(display);

  // look for a built-in command
  int bi = FindCommand(cmd);
  if (bi >= 0)
  {
    ParseArgs(cmd);  // argv[0] will be the command itself

		(* builtin_commands[bi].func)();

		KillArgs();
		return;
  }

  // everything else goes to Lua
  Script_DoString(cmd);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
