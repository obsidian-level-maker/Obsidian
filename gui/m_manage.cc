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


#define MANAGE_WIN_W  620
#define MANAGE_WIN_H  380

#define BG_COLOR  fl_gray_ramp(10)


// forward decls
class UI_Manage_Config;


//
// This does the job of scanning a file and extracting any config.
// The text is appended into the given text buffer.
// Returns false if no config can be found in the file.
// 
static bool ExtractConfigData(FILE *fp, Fl_Text_Buffer *buf)
{
	// FIXME

	return false;
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

	Fl_Menu_Across *load_menu;
	Fl_Menu_Across *extract_menu;

	Fl_Button *save_but;
	Fl_Button *use_but;
	Fl_Button *close_but;

	Fl_Button *cut_but;
	Fl_Button *copy_but;
	Fl_Button *paste_but;

	static recent_file_data_t recent_wads   [RECENT_NUM];
	static recent_file_data_t recent_configs[RECENT_NUM];

public:
	UI_Manage_Config(const char *label = NULL);

	virtual ~UI_Manage_Config();

	bool WantQuit() const
	{
		return want_quit;
	}

	void MarkSource(const char *where)
	{
		if (! where)
			where = "NONE";

		char *full = StringPrintf(" Configuration Text  [%s]", where);

		conf_disp->copy_label(full);

		StringFree(full);

		redraw();
	}

	void Clear()
	{
		MarkSource(NULL);

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
		Fl_Native_File_Chooser chooser;

		chooser.title("Pick file to save to");
		chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
		chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
		chooser.filter("Text files\t*.txt\nConfig files\t*.cfg");

		// FIXME: chooser.directory(LAST_USED_DIRECTORY)

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
		// (checking FLTK code, the file is opened in "w" mode,
		//  hence should end-of-line in an OS-appropriate way).
		int res = text_buf->savefile(filename);

		int err_no = errno;

		if (res)
		{
			const char *reason = (res == 1 && err_no) ? strerror(err_no) :
								 "Error writing to file.";

			DLG_ShowError("Unable to save the file:\n\n%s", reason);
		}
	}

	void PopulateRecentMenu(Fl_Menu_Across *menu, int group)
	{
		recent_file_data_t *ptr;

		if (group == RECG_Output)
			ptr = &recent_wads[0];
		else
			ptr = &recent_configs[0];

		for (int k = 0 ; k < RECENT_NUM ; k++)
		{
			ptr[k].group  = -1;
			ptr[k].widget = NULL;
		}

		for (int i = 0 ; i < RECENT_NUM ; i++, ptr++)
		{
			if (! Recent_GetName(group, i, ptr->short_name, true /* for_menu */))
				break;

			ptr->group = group;
			ptr->index = i;
			ptr->widget = this;

			menu->add(ptr->short_name, 0, callback_Recent, ptr);
		}
	}

	void SetupRecent()
	{
		load_menu->clear();
		load_menu->add("Browse for file...  ", FL_CTRL+'l', callback_Load, this);
		load_menu->add("", 0, 0, 0, FL_MENU_DIVIDER|FL_MENU_INACTIVE);

		PopulateRecentMenu(load_menu,    RECG_Config);

		extract_menu->clear();
		extract_menu->add("Browse for file...  ", FL_CTRL+'e', callback_Extract, this);
		extract_menu->add("", 0, 0, 0, FL_MENU_DIVIDER|FL_MENU_INACTIVE);

		PopulateRecentMenu(extract_menu, RECG_Output);
	}

	const char * AskLoadFilename(int group)
	{
		Fl_Native_File_Chooser chooser;

		chooser.title("Select file to load");
		chooser.type(Fl_Native_File_Chooser::BROWSE_FILE);

		if (group == RECG_Output)
			chooser.filter("WAD files\t*.wad\nPAK files\t*.pak\nGRP files\t*.grp\nLump files\t*.lmp");
		else
			chooser.filter("Text files\t*.txt\nConfig files\t*.cfg");

		// FIXME: chooser.directory(LAST_USED_DIRECTORY)

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

	void LoadFromFile(const char *filename)
	{
		FILE *fp = fl_fopen(filename, "rb");

		if (! fp)
		{
			// FIXME
			DLG_ShowError("CANNOT OPEN FILE");
			return;
		}

		Clear();

		if (! ExtractConfigData(fp, text_buf))
		{
			// FIXME
			DLG_ShowError("NO CONFIG FOUND IN FILE");
			return;
		}

		Enable();

		// FIXME
		MarkSource("From a bloody file");
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

		const char *filename = that->AskLoadFilename(RECG_Config);
		if (! filename)
			return;

		that->LoadFromFile(filename);
	}

	static void callback_Extract(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		const char *filename = that->AskLoadFilename(RECG_Output);
		if (! filename)
			return;

		that->LoadFromFile(filename);
	}

	static void callback_Recent(Fl_Widget *w, void *data)
	{
		recent_file_data_t *priv = (recent_file_data_t *)data;

		// FIXME
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

		const char *filename = that->AskSaveFilename();
		if (! filename)
			return;

		that->SaveToFile(filename);
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
UI_Manage_Config::UI_Manage_Config(const char *label) :
    Fl_Double_Window(MANAGE_WIN_W, MANAGE_WIN_H, label),
	want_quit(false)
{
	size_range(MANAGE_WIN_W, MANAGE_WIN_H);

	if (alternate_look)
		color(FL_DARK2, FL_DARK2);
	else
		color(BG_COLOR, BG_COLOR);

	callback(callback_Quit, this);


	text_buf = new Fl_Text_Buffer();


	conf_disp = new Fl_Text_Display_NoSelect(190, 30, 410, 288, " Reading Config....");
	conf_disp->align(Fl_Align(FL_ALIGN_TOP_LEFT));
	conf_disp->labelsize(16);
	conf_disp->buffer(text_buf);
	conf_disp->textfont(FL_COURIER);
	conf_disp->textsize(12);


	/* Main Buttons */

	Fl_Box * o;

	{
		Fl_Group *g = new Fl_Group(0, 0, conf_disp->x(), conf_disp->h());
		g->resizable(NULL);

		load_menu = new Fl_Menu_Across(30, 25, 100, 35, "  Load @-3>");
		load_menu->labelsize(FL_NORMAL_SIZE);

		extract_menu = new Fl_Menu_Across(30, 85, 100, 35, "  Extract @-3>");
		extract_menu->labelsize(FL_NORMAL_SIZE);

		o = new Fl_Box(15, 116, 171, 40, "from a WAD or PAK file");
		o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
		o->labelsize(14);

		save_but = new Fl_Button(30, 165, 100, 35, "Save");
		save_but->labelsize(FL_NORMAL_SIZE);
		save_but->callback(callback_Save, this);
		save_but->shortcut(FL_CTRL + 's');

		use_but = new Fl_Button(30, 225, 100, 35, "Use");
		use_but->labelsize(FL_NORMAL_SIZE);
		use_but->callback(callback_Use, this);

		o = new Fl_Box(15, 256, 173, 50, "Note: this will replace\nall current settings!");
		o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
		o->labelsize(14);

		g->end();
	}

	close_but = new Fl_Button(30, 325, 100, 40, "Close");
	close_but->labelfont(FL_HELVETICA_BOLD);
	close_but->labelsize(FL_NORMAL_SIZE);
	close_but->callback(callback_Quit, this);
	close_but->shortcut(FL_CTRL + 'w');


	/* Clipboard buttons */

	{
		Fl_Group *g = new Fl_Group(conf_disp->x(), 318, conf_disp->w(), MANAGE_WIN_H - 318);
		g->resizable(NULL);

		o = new Fl_Box(215, 318, 355, 30, " Clipboard Operations");
		o->align(Fl_Align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE));
		o->labelsize(14);

		cut_but = new Fl_Button(245, 345, 80, 25, "Cut");
		cut_but->labelsize(FL_NORMAL_SIZE - 2);
		cut_but->shortcut(FL_CTRL + 'x');
		cut_but->callback(callback_Cut, this);

		copy_but = new Fl_Button(360, 345, 80, 25, "Copy");
		copy_but->labelsize(FL_NORMAL_SIZE - 2);
		copy_but->shortcut(FL_CTRL + 'c');
		copy_but->callback(callback_Copy, this);

		paste_but = new Fl_Button(475, 345, 80, 25, "Paste");
		paste_but->labelsize(FL_NORMAL_SIZE - 2);
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
		config_window = new UI_Manage_Config("OBLIGE Config Manager");

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
