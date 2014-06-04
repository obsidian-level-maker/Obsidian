//------------------------------------------------------------------------
//  Manage Config Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2014 Andrew Apted
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
#include "hdr_ui.h"

#include "lib_util.h"

#include "main.h"
#include "m_cookie.h"
#include "m_lua.h"


#define BG_COLOR  fl_gray_ramp(10)


// forward decls
class UI_Manage_Config;


//
// This does the job of scanning a file and extracting any config.
// The text is appended into the given text buffer.
// Returns false if no config can be found in the file.
// 
#define LOOKAHEAD_SIZE  1024

class Lookahead_Stream_c
{
private:
	FILE *fp;

	char buffer[LOOKAHEAD_SIZE];

	// number of characters in buffer, usually the buffer is full
	int buf_len;

	// read position in buffer, < LOOKAHEAD_SIZE/2 except at EOF
	int pos;

private:
	void shift_data()
	{
		SYS_ASSERT(pos > 0);
		SYS_ASSERT(pos <= buf_len);

		// compute the new length of buffer
		// (we are eating 'pos' characters at the head)
		buf_len -= pos;

		if (buf_len > 0)
			memmove(buffer, buffer + pos, buf_len);

		pos = 0;
	}

	void read_data()
	{
		int want_len = LOOKAHEAD_SIZE - buf_len;
		SYS_ASSERT(want_len > 0);

		int got_len = fread(buffer + buf_len, 1, want_len, fp);

		if (got_len < 0)
			got_len = 0;

		buf_len = buf_len + got_len;
	}

public:
	Lookahead_Stream_c(FILE *_fp) : fp(_fp), buf_len(0), pos(0)
	{
		// need an initial packet of data
		read_data();
	}

	virtual ~Lookahead_Stream_c()
	{ }

public:
	bool hit_eof()
	{
		return (pos >= buf_len);
	}

	char peek_char(int offset = 0)
	{
		int new_pos = pos + offset;

		if (new_pos >= buf_len)
			return 0;

		return buffer[new_pos];
	}

	char get_char()
	{
		if (hit_eof())
			return 0;

		int ch = buffer[pos++];

		// time to read more from the file?
		if (pos >= LOOKAHEAD_SIZE / 2)
		{
			shift_data();
			read_data();
		}

		return ch;
	}

	bool match(const char *str)
	{
		for (int offset = 0 ; *str ; str++, offset++)
			if (peek_char(offset) != *str)
				return false;

		return true;
	}
};


static bool ExtractConfigData(FILE *fp, Fl_Text_Buffer *buf)
{
	Lookahead_Stream_c stream(fp);

	/* look for a starting string */

	while (1)
	{
		if (stream.hit_eof())
			return false;  // not found

		if (stream.match("-- CONFIG FILE : OBLIGE ") ||
			stream.match("-- Levels created by OBLIGE "))
		{
			break;  // found it
		}

		stream.get_char();
	}

	/* copy lines until we hit the end */

	char mini_buf[4];

	while (! stream.hit_eof())
	{
		if (stream.match("-- END"))
		{
			buf->append("-- END --\n\n");
			break;
		}

		int ch = stream.get_char();

		if (ch == 0 || ch == 26)
			break;

		// remove CR (Carriage Return) characters
		if (ch == '\r')
			continue;

		mini_buf[0] = ch;
		mini_buf[1] = 0;

		buf->append(mini_buf);
	}

	return true;  // Success!
}


//------------------------------------------------------------------------

//
// this prevents the text display widget from selecting areas,
// as well as eating the CTRL-A and CTRL-C keyboard events.
//
class Fl_Text_Display_NoSelect : public Fl_Text_Display
{
public:
	Fl_Text_Display_NoSelect(int X, int Y, int W, int H, const char *label = 0) : 
		Fl_Text_Display(X, Y, W, H, label)
	{ }

	virtual ~Fl_Text_Display_NoSelect()
	{ }

	virtual int handle(int e)
	{
		switch (e)
		{
			case FL_KEYBOARD: case FL_KEYUP:
			case FL_PUSH: case FL_RELEASE:
			case FL_DRAG:
				return Fl_Group::handle(e);
		}

		return Fl_Text_Display::handle(e);
	}
};


#define RECENT_NUM  10

typedef struct
{
	int group;
	int index;

	char short_name[100];

	UI_Manage_Config *widget;

} recent_file_data_t;



class UI_Manage_Config : public Fl_Double_Window
{
public:
	bool want_quit;

	Fl_Text_Buffer *text_buf;

	Fl_Text_Display_NoSelect *conf_disp;

	Fl_Button *load_but;
	Fl_Menu_Across *recent_menu;

	Fl_Button *save_but;
	Fl_Button *use_but;
	Fl_Button *close_but;

	Fl_Button *cut_but;
	Fl_Button *copy_but;
	Fl_Button *paste_but;

	static recent_file_data_t recent_wads   [RECENT_NUM];
	static recent_file_data_t recent_configs[RECENT_NUM];

public:
	UI_Manage_Config(int W, int H, const char *label = NULL);

	virtual ~UI_Manage_Config();

	bool WantQuit() const
	{
		return want_quit;
	}

	void MarkSource(const char *where)
	{
		char *full = StringPrintf(" Text :  [%s]", where);

		conf_disp->copy_label(full);

		StringFree(full);
		redraw();
	}

	void MarkSource_FILE(const char *filename)
	{
		char *full;

		// abbreviate the filename if too long
		int len = strlen(filename);

		if (len < 42)
			full = StringPrintf(" Text :  [%s]", filename);
		else
			full = StringPrintf(" Text :  [%.10s....%s]", filename, filename + (len - 30));

		conf_disp->copy_label(full);

		StringFree(full);
		redraw();
	}

	void Clear()
	{
		MarkSource("");

		text_buf->select(0, text_buf->length());
		text_buf->remove_selection();

		save_but->deactivate();
		 use_but->deactivate();

		 cut_but->deactivate();
		copy_but->deactivate();

		redraw();
	}

	void Enable()
	{
		save_but->activate();
		 use_but->activate();

		 cut_but->activate();
		copy_but->activate();

		redraw();
	}

	void ReadCurrentSettings()
	{
		Clear();

		text_buf->append("-- CONFIG FILE : OBLIGE " OBLIGE_VERSION "\n"); 
		text_buf->append("-- " OBLIGE_TITLE " (C) 2006-2014 Andrew Apted\n");
		text_buf->append("-- http://oblige.sourceforge.net/\n\n");

		std::vector<std::string> lines;

		ob_read_all_config(&lines);

		for (unsigned int i = 0 ; i < lines.size() ; i++)
		{
			text_buf->append(lines[i].c_str());
			text_buf->append("\n");
		}

		Enable();

		MarkSource("CURRENT SETTINGS");
	}

	void ReplaceWithString(const char *new_text)
	{
		Clear();

		text_buf->append(new_text);

		Enable();
	}

	const char * AskSaveFilename()
	{
		Fl_Native_File_Chooser  chooser;

		chooser.title("Pick file to save to");
		chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
		chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
		chooser.filter("Text files\t*.txt");

		// TODO: chooser.directory(LAST_USED_DIRECTORY)

		switch (chooser.show())
		{
			case -1:
				LogPrintf("Error choosing save file:\n");
				LogPrintf("   %s\n", chooser.errmsg());

				DLG_ShowError("Unable to save the file:\n\n%s", chooser.errmsg());
				return NULL;

			case 1:  // cancelled
				return NULL;

			default:
				break;  // OK
		}

		static char filename[FL_PATH_MAX + 10];

		strcpy(filename, chooser.filename());

		// if extension is missing then add ".txt"
		char *pos = (char *)fl_filename_ext(filename);
		if (! *pos)
			strcat(filename, ".txt");

		return filename;
	}

	void SaveToFile(const char *filename)
	{
		// looking at FLTK code, the file is opened in "w" mode, so
		// it should handle end-of-line in an OS-appropriate way.
		int res = text_buf->savefile(filename);

		int err_no = errno;

		if (res)
		{
			const char *reason = (res == 1 && err_no) ? strerror(err_no) :
								 "Error writing to file.";

			DLG_ShowError("Unable to save the file:\n\n%s", reason);
		}
		else
		{
			Recent_AddFile(RECG_Config, filename);
		}
	}

	int PopulateRecentMenu(Fl_Menu_Across *menu, int group, int max_num)
	{
		SYS_ASSERT(max_num <= RECENT_NUM);

		recent_file_data_t *ptr;

		if (group == RECG_Output)
			ptr = &recent_wads[0];
		else
			ptr = &recent_configs[0];

		for (int k = 0 ; k < RECENT_NUM ; k++)
		{
			ptr[k].group  = -1;
			ptr[k].index  = -1;
			ptr[k].widget = NULL;
		}

		int i;

		for (i = 0 ; i < max_num ; i++, ptr++)
		{
			if (! Recent_GetName(group, i, ptr->short_name, true /* for_menu */))
				break;

			ptr->group = group;
			ptr->index = i;
			ptr->widget = this;

			menu->add(ptr->short_name, 0, callback_Recent, ptr);
		}

		return i;  // total number
	}

	void SetupRecent()
	{
		recent_menu->clear();

		int count1 = PopulateRecentMenu(recent_menu, RECG_Config, 6);

		recent_menu->add("", 0, 0, 0, FL_MENU_DIVIDER|FL_MENU_INACTIVE);

		int count2 = PopulateRecentMenu(recent_menu, RECG_Output, 8);

		if (count1 + count2 > 0)
			recent_menu->activate();
		else
			recent_menu->deactivate();
	}

	const char * AskLoadFilename()
	{
		Fl_Native_File_Chooser chooser;

		chooser.title("Select file to load");
		chooser.type(Fl_Native_File_Chooser::BROWSE_FILE);

		// These filters (in FLTK's own browser at least) are a choice
		// and only one is active at a time.  That sucks, since only
		// files matching the active filter are shown.
#if 0
		chooser.filter("Text files\t*.txt\n"
		               "Config files\t*.cfg\n"
		               "WAD files\t*.wad\n"
					   "GRP files\t*.grp\n"
					   "PAK files\t*.pak\n");
#endif

		// TODO: chooser.directory(LAST_USED_DIRECTORY)

		switch (chooser.show())
		{
			case -1:
				LogPrintf("Error choosing load file:\n");
				LogPrintf("   %s\n", chooser.errmsg());

				DLG_ShowError("Unable to load the file:\n\n%s", chooser.errmsg());
				return NULL;

			case 1:  // cancelled
				return NULL;

			default:
				break;  // OK
		}

		static char filename[FL_PATH_MAX + 10];

		strcpy(filename, chooser.filename());

		return filename;
	}

	bool LoadFromFile(const char *filename)
	{
		FILE *fp = fl_fopen(filename, "rb");

		if (! fp)
		{
			DLG_ShowError("Cannot open: %s\n\n%s", filename, strerror(errno));
			return false;
		}

		Clear();

		if (! ExtractConfigData(fp, text_buf))
		{
			DLG_ShowError("No config found in file.");
			fclose(fp);
			return false;
		}

		fclose(fp);

		Enable();

		MarkSource_FILE(filename);

		return true;
	}

private:
	// FLTK virtual method for handling input events
	int handle(int event)
	{
		if (event == FL_PASTE)
		{
			const char *text = Fl::event_text();
			SYS_ASSERT(text);

			if (strlen(text) == 0)
			{
				fl_beep();
			}
			else
			{
				ReplaceWithString(text);
				MarkSource("PASTED TEXT");
			}
			return 1;
		}

		return Fl_Double_Window::handle(event);
	}

private:
	/* Loading stuff */

	static void callback_Load(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		// save and restore the font height
		// (because FLTK's own browser gets totally borked)
		int old_font_h = FL_NORMAL_SIZE;
		FL_NORMAL_SIZE = 14 + KF;

		const char *filename = that->AskLoadFilename();

		FL_NORMAL_SIZE = old_font_h;

		if (! filename)
			return;

		that->LoadFromFile(filename);
	}

	static void callback_Recent(Fl_Widget *w, void *data)
	{
		recent_file_data_t *priv = (recent_file_data_t *)data;

		// invalid data? -- should not happen, but don't choke on it
		if (priv->index < 0)
		{
			LogPrintf("WARNING: callback_Recent with dud data\n");
			return;
		}

		static char filename[FL_PATH_MAX];

		// this also should not happen...
		if (! Recent_GetName(priv->group, priv->index, filename))
		{
			LogPrintf("WARNING: callback_Recent with bad index\n");
			return;
		}

		UI_Manage_Config *that = priv->widget;
		SYS_ASSERT(that);

		if (! that->LoadFromFile(filename))
		{
			// unable to load that file, it has probably been deleted
			// so remove it from the recent list
			Recent_RemoveFile(priv->group, filename);
			that->SetupRecent();
		}
	}

	/* Saving and Using */

	static void callback_Save(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		// save and restore the font height
		// (because FLTK's own browser gets totally borked)
		int old_font_h = FL_NORMAL_SIZE;
		FL_NORMAL_SIZE = 14 + KF;

		const char *filename = that->AskSaveFilename();

		FL_NORMAL_SIZE = old_font_h;

		if (! filename)
			return;

		that->SaveToFile(filename);

		that->SetupRecent();
	}

	static void callback_Use(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		const char *str = that->text_buf->text();

		Cookie_LoadString(str);

		free((void*)str);
	}

	/* Leaving */

	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		that->want_quit = true;
	}

	/* Clipboard stuff */

	static void callback_Copy(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		const char *str = that->text_buf->text();

		Fl::copy(str, strlen(str), 1);

		free((void*)str);
	}

	static void callback_Cut(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		callback_Copy(w, data);

		if (that->text_buf->length() > 0)
			that->Clear();
	}

	static void callback_Paste(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		Fl::paste(*that, 1);
	}
};


// define the recent arrays
recent_file_data_t UI_Manage_Config::recent_wads   [RECENT_NUM];
recent_file_data_t UI_Manage_Config::recent_configs[RECENT_NUM];


//
// Constructor
//
UI_Manage_Config::UI_Manage_Config(int W, int H, const char *label) :
    Fl_Double_Window(W, H, label),
	want_quit(false)
{
	size_range(W, H);

	if (alternate_look)
		color(FL_DARK2, FL_DARK2);
	else
		color(BG_COLOR, BG_COLOR);

	callback(callback_Quit, this);


	text_buf = new Fl_Text_Buffer();


	int conf_w = kf_w(420);
	int conf_h = H * 0.75;
	int conf_x = W - conf_w - kf_w(10);
	int conf_y = kf_h(30);

	conf_disp = new Fl_Text_Display_NoSelect(conf_x, conf_y, conf_w, conf_h, " Reading Config....");
	conf_disp->align(Fl_Align(FL_ALIGN_TOP_LEFT));
	conf_disp->buffer(text_buf);
	conf_disp->textfont(FL_COURIER);
	conf_disp->textsize(12 + KF * 2);


	/* Main Buttons */

	int button_x = kf_w(20);
	int button_w = kf_w(100);
	int button_h = kf_h(35);

	Fl_Box * o;

	{
		Fl_Group *g = new Fl_Group(0, 0, conf_disp->x(), conf_disp->h());
		g->resizable(NULL);

		load_but = new Fl_Button(button_x, kf_h(25), button_w, button_h, "Load");
		load_but->callback(callback_Load, this);
		load_but->shortcut(FL_CTRL + 'l');

		o = new Fl_Box(0, kf_h(65), kf_w(160), kf_h(40), "(can be WAD or PAK)");
		o->align(Fl_Align(FL_ALIGN_TOP | FL_ALIGN_INSIDE));
		o->labelsize(small_font_size);

		recent_menu = new Fl_Menu_Across(button_x, kf_h(95), button_w, button_h, "   Recent @-3>");

		save_but = new Fl_Button(button_x, kf_h(165), button_w, button_h, "Save");
		save_but->callback(callback_Save, this);
		save_but->shortcut(FL_CTRL + 's');

		use_but = new Fl_Button(button_x, kf_h(225), button_w, button_h, "Use");
		use_but->callback(callback_Use, this);

		o = new Fl_Box(0, kf_h(265), kf_w(170), kf_h(50), "Note: this will replace\nall current settings!");
		o->align(Fl_Align(FL_ALIGN_TOP | FL_ALIGN_INSIDE));
		o->labelsize(small_font_size);

		g->end();
	}

	close_but = new Fl_Button(button_x, H - kf_h(50), button_w, button_h + 5, "Close");
	close_but->labelfont(FL_HELVETICA_BOLD);
	close_but->labelsize(FL_NORMAL_SIZE + 2);
	close_but->callback(callback_Quit, this);
	close_but->shortcut(FL_CTRL + 'w');


	/* Clipboard buttons */

	{
		int cx = conf_x + kf_w(40);

		int base_y = conf_y + conf_h + 1;

		Fl_Group *g = new Fl_Group(conf_x, base_y, conf_w, H - base_y);
		g->resizable(NULL);

		o = new Fl_Box(cx, base_y, W - cx - 10, kf_h(30), " Clipboard Operations");
		o->align(Fl_Align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE));
		o->labelsize(small_font_size);

		cx += kf_w(30);
		base_y += kf_h(30);

		button_w = kf_w(80);
		button_h = kf_h(25);

		cut_but = new Fl_Button(cx, base_y, button_w, button_h, "Cut");
		cut_but->labelsize(small_font_size);
		cut_but->shortcut(FL_CTRL + 'x');
		cut_but->callback(callback_Cut, this);

		cx += kf_w(115);

		copy_but = new Fl_Button(cx, base_y, button_w, button_h, "Copy");
		copy_but->labelsize(small_font_size);
		copy_but->shortcut(FL_CTRL + 'c');
		copy_but->callback(callback_Copy, this);

		cx += kf_w(115);

		paste_but = new Fl_Button(cx, base_y, button_w, button_h, "Paste");
		paste_but->labelsize(small_font_size);
		paste_but->shortcut(FL_CTRL + 'v');
		paste_but->callback(callback_Paste, this);

		g->end();
	}

	end();

	resizable(conf_disp);
}


//
// Destructor
//
UI_Manage_Config::~UI_Manage_Config()
{ }


void DLG_ManageConfig(void)
{
	static UI_Manage_Config * config_window = NULL;

	// if it already exists, simply re-show it
	if (! config_window)
	{
		int manage_w = kf_w(600);
		int manage_h = kf_h(380);

		config_window = new UI_Manage_Config(manage_w, manage_h, "OBLIGE Config Manager");
	}

	config_window->want_quit = false;
	config_window->set_modal();
	config_window->show();

	config_window->SetupRecent();
	config_window->ReadCurrentSettings();

	// run the GUI until the user closes
	while (! config_window->WantQuit())
		Fl::wait();

	config_window->set_non_modal();
	config_window->hide();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
