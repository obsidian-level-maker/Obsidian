//----------------------------------------------------------------
//  Debugging CONSOLE
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010,2014 Andrew Apted
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
#include "m_lua.h"


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

static UI_Console *console_win;

bool debug_onto_console;

char *console_argv[CON_MAX_ARGS];
int   console_argc;

static std::list<std::string> con_saved_lines;
static int con_saved_count = 0;

static UI_ConLine *button_line;

static bool console_active;


// forward decls
void ConExecute(const char *cmd);

void UI_OpenConsole();
void UI_CloseConsole();


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
		int bw = 14 + strlen(lab) * (6 + KF * 4);

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
		int font  = FL_COURIER;

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

						default:
							break;
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
			w->hide();

			datum += 2;

			int indent = atoi(datum);

			while (isdigit(*datum)) datum++;
			if (*datum == ':') datum++;

			Script_RunString("ob_console_dump { tab_ref=%s, indent=%d }", datum, indent);

			// NOTE: it's possible the widget (w) has been deleted by now

			button_line = false;
		}
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

				default:
					break;
			}
		}

		return Fl_Group::handle(event);
	}

private:
	void DoEnter()
	{
		AddHistory(input->value());

		ConExecute(input->value());

		input->value("");
		browse_pos = -1;
	}

	static void callback_Enter(Fl_Widget *w, void *data)
	{
		UI_ConInput *_this = (UI_ConInput *) data;

		_this->DoEnter();
	}
};


//----------------------------------------------------------------


class UI_Console : public Fl_Double_Window
{
private:
	int count;

	Fl_Group *all_lines;

	Fl_Scrollbar *sbar;

	UI_ConInput *input;

	// total height of all lines in our buffer
	int total_h;

	// number of pixels that don't fit in the console area
	int spare_h;

	// this value has been added to the widget y() values to move them
	// from their default position (which is to anchor the bottom-most
	// line just above the input bar).
	//
	// in other words, it is the number of pixels "hidden" below the
	// bottom of the console area.
	//
	// range is 0 to spare_h.
	// value should be same as: spare_h - sbar->value()
	int offset_y;

private:
	void MoveAll(int new_offset, int old_offset);

	void RepositionAll(bool jump_bottom = false, UI_ConLine *focus = NULL);

	void ChangeScrollbar(int new_offset, bool move_em = false);

public:
	UI_Console(int x, int y, int w, int h, const char *label = NULL) :
		Fl_Double_Window(x, y, w, h, label),
		count(0), total_h(0), spare_h(0), offset_y(0)
	{
		end(); // cancel begin() in Fl_Group constructor

		size_range(kf_w(240), kf_h(160));
		color(CONSOLE_BG, CONSOLE_BG);


		int sb_w = Fl::scrollbar_size();
		int in_h = kf_h(28);


		sbar = new Fl_Scrollbar(x + w - sb_w, y, sb_w, h);
		sbar->callback(callback_Scroll, this);

		if (! alternate_look)
			sbar->color(FL_DARK3+1, FL_DARK3+1);

		add(sbar);


		input = new UI_ConInput(x+4, y+h-in_h, w-sb_w-8, in_h-4);

		add(input);


		all_lines = new Fl_Group(x+4, y+4, w-sb_w-8, h-in_h-4);
		all_lines->end();
		all_lines->clip_children(1);

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
		console_win = NULL;
		console_active = false;
	}

public:
	void Clear()
	{
		all_lines->clear();

		// this will recompute total_h, spare_h and offset_y
		AddLine("READY");
	}

	void AddLine(const char *line)
	{
		bool at_bottom = (offset_y < 8);

		if (count >= CON_MAX_LINES)
		{
			all_lines->remove(all_lines->child(0));
			count--;
		}

		int mx = all_lines->x();
		int my = all_lines->y();
		int mw = all_lines->w();

		UI_ConLine *M = new UI_ConLine(mx, my, mw, LINE_H, line);

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

		RepositionAll(at_bottom);
	}

private:
	// FLTK virtual method for handling input events
	int handle(int event);

	// FLTK virtual method for size changes
	void resize(int nx, int ny, int nw, int nh);

	void PageUp()
	{
		int dy = MAX(LINE_H, all_lines->h() - LINE_H);

		int new_offset = MIN(spare_h, offset_y + dy);

		ChangeScrollbar(new_offset, true);
	}

	void PageDown()
	{
		int dy = MAX(LINE_H, all_lines->h() - LINE_H);

		int new_offset = MAX(0, offset_y - dy);

		ChangeScrollbar(new_offset, true);
	}

	UI_ConLine *LowestVisibleLine()
	{
		int my = all_lines->y();
		int mh = all_lines->h();

		UI_ConLine *best = NULL;
		int best_dist = 9999;

		for (int j = 0; j < all_lines->children(); j++)
		{
			UI_ConLine *M = (UI_ConLine *) all_lines->child(j);
			SYS_ASSERT(M);

			if (!M->visible() || M->y() < my || M->y() >= my+mh)
				continue;

			int dist = my+mh - M->y();

			if (dist < best_dist)
			{
				best = M;
				best_dist = dist;
			}
		}

		return best;
	}

	void DoScroll()
	{
		// int mh = all_lines->h();

		int old_offset = offset_y;

		offset_y = spare_h - sbar->value();

		MoveAll(offset_y, old_offset);

		all_lines->redraw();
	}

	static void callback_Scroll(Fl_Widget *w, void *data);
};


void UI_Console::MoveAll(int new_offset, int old_offset)
{
	int dy = new_offset - old_offset;

	for (int j = 0; j < all_lines->children(); j++)
	{
		Fl_Widget *F = all_lines->child(j);

		SYS_ASSERT(F);

		F->resize(F->x(), F->y() + dy, F->w(), F->h());
	}
}


void UI_Console::ChangeScrollbar(int new_offset, bool move_em)
{
	int mh = all_lines->h();

	int old_offset = offset_y;

	offset_y = new_offset;

	// p = position, first line displayed
	// w = window, number of lines displayed
	// t = top, number of first line
	// l = length, total number of lines
	sbar->value(spare_h - offset_y, mh, 0, total_h);

	// ensure knob never gets too small
	if (sbar->slider_size() < MIN_SLIDER_SIZE)
		sbar->slider_size(MIN_SLIDER_SIZE);

	if (move_em)
	{
		MoveAll(new_offset, old_offset);
	}

	all_lines->redraw();
}


void UI_Console::RepositionAll(bool jump_bottom, UI_ConLine *focus)
{
	// the 'focus' line, when not NULL, w

	int my = all_lines->y();
	int mh = all_lines->h();

	if (! focus)
		focus = LowestVisibleLine();

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

	if (new_height <= mh || jump_bottom)
	{
		offset_y = 0;
	}
	else if (! focus)
	{
		if (offset_y > new_height-mh)
			offset_y = new_height-mh;
	}
	else
	{
		int base_y = my+mh - LINE_H;

		int focus_diff = focus->y() - base_y;

		int below_h = LINE_H;

		for (int k = 0; k < all_lines->children(); k++)
		{
			UI_ConLine *M = (UI_ConLine *) all_lines->child(k);

			if (M->visible() && M->y() > focus->y())
			{
				below_h += M->CalcHeight() + spacing;
			}
		}

		offset_y = below_h + focus_diff;

		offset_y = MAX(offset_y, 0);
		offset_y = MIN(offset_y, new_height - mh);
	}

	total_h = new_height;
	spare_h = MAX(0, new_height - mh);

	SYS_ASSERT(offset_y >= 0);
	SYS_ASSERT(offset_y <= spare_h);

	// reposition all the line widgets
	// (iterate from bottom-most to top-most)

	int base_y = my+mh - LINE_H;

	int ny = base_y + offset_y;

	for (int k = all_lines->children()-1 ; k >= 0 ; k--)
	{
		UI_ConLine *M = (UI_ConLine *) all_lines->child(k);

		int nh = M->visible() ? M->CalcHeight() : 1;

		if (ny != M->y() || nh != M->h())
		{
			M->resize(M->x(), ny, M->w(), nh);
		}

		if (M->visible())
			ny -= nh + spacing;
	}


	ChangeScrollbar(offset_y);
}


int UI_Console::handle(int event)
{
	if (event == FL_SHOW)
		console_active = true;
	else if (event == FL_HIDE)
		console_active = false;

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

			case FL_F+7:
				UI_CloseConsole();
				return 1;

			default: break;
		}
	}

	return Fl_Group::handle(event);
}


void UI_Console::resize(int nx, int ny, int nw, int nh)
{
	Fl_Double_Window::resize(nx, ny, nw, nh);

	RepositionAll(false, NULL);
}


void UI_Console::callback_Scroll(Fl_Widget *w, void *data)
{
	UI_Console *_this = (UI_Console *)data;

	_this->DoScroll();
}


//----------------------------------------------------------------

void UI_OpenConsole()
{
	if (console_active)
		return;

	if (! console_win)
	{
		int con_w = kf_w(600);
		int con_h = kf_h(400);

		console_win = new UI_Console(0, 0, con_w, con_h, "OBLIGE DEBUG CONSOLE");
	}

	console_win->show();

	// add the saved lines
	while (! con_saved_lines.empty())
	{
		console_win->AddLine(con_saved_lines.front().c_str());

		con_saved_lines.pop_front();
	}
}


void UI_CloseConsole()
{
	if (console_active)
	{
		SYS_ASSERT(console_win);

		console_win->hide();
	}
}


void DLG_ToggleConsole(void)
{
	if (console_active)
		UI_CloseConsole();
	else
		UI_OpenConsole();
}


static void DoAddLine(const char *line)
{
	if (console_active)
	{
		console_win->AddLine(line);
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


void CMD_PrintExpr(const char *expr)
{
	while (isspace(*expr))
		expr++;

	ConPrintf("@6? %s\n", expr);

	Script_RunString("ob_console_dump(nil, %s)", expr);
}


void CMD_Args(void)
{
	ConPrintf("Arguments:\n");

	for (int i = 0 ; i < console_argc ; i++)
	{
		const char *arg = console_argv[i];

		ConPrintf("  %2d = \"%s\" (len %d)\n", i, arg, (int)strlen(arg));
	}
}


void CMD_Clear(void)
{
	console_win->Clear();

	Script_RunString("ob_ref_table(\"clear\")");
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
	if (! console_active)
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
	Script_RunString(cmd);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
