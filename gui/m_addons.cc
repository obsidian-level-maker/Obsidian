//----------------------------------------------------------------------
//  Addons Loading and Selection GUI
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2015 Andrew Apted
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
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "physfs.h"

#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"

#include "main.h"
#include "m_addons.h"
#include "m_cookie.h"


// need this because the OPTIONS file is loaded *before* the addons
// folder is scanned for PK3 packages, so remember enabled ones here.
static std::map<std::string, int> initial_enabled_addons;

typedef struct 
{
	const char *name;	// base filename, includes ".pk3" extension
	
	bool enabled;

} addon_info_t;

static std::vector<addon_info_t> all_addons;


void VFS_AddFolder(const char *name)
{
	char *path  = StringPrintf("%s/%s", install_dir, name);
	char *mount = StringPrintf("/%s", name);

	if (! PHYSFS_mount(path, mount, 1))
	{
		Main_FatalError("Failed to mount '%s' folder in PhysFS:\n%s\n",
						name, PHYSFS_getLastError());
		return;  /* NOT REACHED */
	}

	DebugPrintf("mounted '%s'\n", name);
}


bool VFS_AddArchive(const char *filename, bool options_file)
{
	if (! HasExtension(filename))
		filename = ReplaceExtension(filename, "pk3");
	else
		filename = StringDup(filename);

	// when handling "bare" filenames from the command line (i.e. ones
	// containing no paths or drive spec) and the file does not exist in
	// the current dir, look for it in the standard addons/ folder.
	if (options_file ||
		(! FileExists(filename) &&
		 filename == fl_filename_name(filename)))
	{
		char *new_name = StringPrintf("%s/addons/%s", install_dir, filename);
		StringFree(filename);
		filename = new_name;
	}

	if (! PHYSFS_mount(filename, "/", 1))
	{
		if (options_file)
			LogPrintf("Failed to mount '%s' archive in PhysFS:\n%s\n",
					  filename, PHYSFS_getLastError());
		else
			Main_FatalError("Failed to mount '%s' archive in PhysFS:\n%s\n",
							filename, PHYSFS_getLastError());

		return false;
	}

	return true;  // Ok
}


void VFS_InitAddons(const char *argv0)
{
	LogPrintf("Initializing VFS...\n");

	if (! PHYSFS_init(argv0))
	{
		Main_FatalError("Failed to init PhysFS:\n%s\n", PHYSFS_getLastError());
		return;  /* NOT REACHED */
	}

	VFS_AddFolder("scripts");
	VFS_AddFolder("games");
	VFS_AddFolder("engines");
	VFS_AddFolder("modules");
	VFS_AddFolder("prefabs");
	VFS_AddFolder("data");

	LogPrintf("DONE.\n\n");
}


void VFS_ParseCommandLine()
{
	int arg = ArgvFind('a', "addon");
	int count = 0;

	if (arg < 0)
		return;

	arg++;

	for (; arg < arg_count && ! ArgvIsOption(arg) ; arg++, count++)
	{
		VFS_AddArchive(arg_list[arg], false /* options_file */);
	}

	if (! count)
		Main_FatalError("Missing filename for --addon option\n");
}


void VFS_OptParse(const char *name)
{
	// just remember it now
	if (initial_enabled_addons.find(name) == initial_enabled_addons.end())
	{
		initial_enabled_addons[name] = 1;
	}
}


void VFS_OptWrite(FILE *fp)
{
	fprintf(fp, "---- Enabled Addons ----\n\n");

	// TODO
}


void VFS_ScanForAddons()
{
	LogPrintf("Scanning for addons....\n");

	all_addons.clear();

	char *dir_name = StringPrintf("%s/addons", install_dir);

	std::vector<std::string> list;
	int result = ScanDir_MatchingFiles(dir_name, "pk3", list);

	StringFree(dir_name);

	if (result < 0)
	{
		LogPrintf("FAILED -- missing folder??\n\n");
		return;
	}

	for (unsigned int i = 0 ; i < list.size() ; i++)
	{
		addon_info_t info;

		info.name = StringDup(list[i].c_str());

		info.enabled = false;

		if (initial_enabled_addons.find(list[i]) != initial_enabled_addons.end())
			info.enabled = true;

//DEBUG
//info.enabled = true;

		LogPrintf("  found: %s%s\n", info.name, info.enabled ? " (Enabled)" : "");

		all_addons.push_back(info);

		// if enabled, install into the VFS
		if (info.enabled)
			VFS_AddArchive(info.name, true /* options_file */);
	}

	if (list.size() == 0)
		LogPrintf("DONE (none found)\n");
	else
		LogPrintf("DONE\n");

	LogPrintf("\n");
}


//----------------------------------------------------------------------

//
// this is useful to "extract" something out of virtual FS to the real
// file system so we can use normal stdio file operations on it
// [ especially a _library_ that uses stdio.h ]
//
bool VFS_CopyFile(const char *src_name, const char *dest_name)
{
	char buffer[1024];

	PHYSFS_file *src = PHYSFS_openRead(src_name);
	if (! src)
		return false;

	FILE *dest = fopen(dest_name, "wb");
	if (! dest)
	{
		PHYSFS_close(src);
		return false;
	}

	bool was_OK = true;

	while (was_OK)
	{
		int rlen = (int)PHYSFS_read(src, buffer, 1, sizeof(buffer));
		if (rlen < 0)
			was_OK = false;

		if (rlen <= 0)
			break;

		int wlen = fwrite(buffer, 1, rlen, dest);
		if (wlen < rlen || ferror(dest))
			was_OK = false;
	}

	fclose(dest);
	PHYSFS_close(src);

	return was_OK;
}


byte * VFS_LoadFile(const char *filename, int *length)
{
	*length = 0;

	PHYSFS_File *fp = PHYSFS_openRead(filename);

	if (! fp)
		return NULL;

	*length = (int)PHYSFS_fileLength(fp);

	if (*length < 0)
	{
		PHYSFS_close(fp);
		return NULL;
	}

	byte *data = new byte[*length + 1];

	// ensure buffer is NUL-terminated
	data[*length] = 0;

	if (PHYSFS_read(fp, data, *length, 1) != 1)
	{
		VFS_FreeFile(data);
		PHYSFS_close(fp);
		return NULL;
	}

	PHYSFS_close(fp);

	return data;
}


void VFS_FreeFile(const byte *mem)
{
	if (mem)
	{
		delete[] mem;
	}
}


//----------------------------------------------------------------------

class UI_Addon : public Fl_Group
{
public:
	std::string id_name;

	Fl_Check_Button *button;

public:
	UI_Addon(int x, int y, int w, int h, const char *id, const char *label, const char *tip) :
		Fl_Group(x, y, w, h),
		id_name(id)
	{
		box(FL_THIN_UP_BOX);

		if (! alternate_look)
			color(BUILD_BG, BUILD_BG);

		button = new Fl_Check_Button(x + kf_w(6), y + kf_h(4), w - kf_w(12), kf_h(24), label);
		if (tip)
			button->tooltip(tip);

		end();

		resizable(NULL);
	}

	virtual ~UI_Addon()
	{ }

	int CalcHeight() const
	{
		return kf_h(34);
	}
};


//----------------------------------------------------------------------


class UI_AddonsWin : public Fl_Window
{
public:
	bool want_quit;

	Fl_Group *pack;

	Fl_Scrollbar *sbar;

	// area occupied by addon list
	int mx, my, mw, mh;

	// number of pixels "lost" above the top
	int offset_y;

	// total height of all shown addons
	int total_h;

public:
	UI_AddonsWin(int W, int H, const char *label = NULL);

	virtual ~UI_AddonsWin()
	{
		// nothing needed
	}

	void Populate();
	void InsertAddon(const addon_info_t *info);

	bool WantQuit() const
	{
		return want_quit;
	}

public:
	// FLTK virtual method for handling input events.
	int handle(int event);

private:
	void PositionAll();

	static void callback_Scroll(Fl_Widget *w, void *data)
	{
		// FIXME
	}

	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_AddonsWin *that = (UI_AddonsWin *)data;

		that->want_quit = true;
	}
};


//
// Constructor
//
UI_AddonsWin::UI_AddonsWin(int W, int H, const char *label) :
	Fl_Window(W, H, label),
	want_quit(false)
{
	callback(callback_Quit, this);

	// non-resizable
	size_range(W, H, W, H);

	box(FL_FLAT_BOX);

	color(BUILD_BG, BUILD_BG);


//	int pad = kf_w(6);

	int dh = kf_h(64);


	// area for addons list
	mx = 0;
	my = 0;
	mw = W - Fl::scrollbar_size();
	mh = H - dh;

	offset_y = 0;
	total_h  = 0;


	sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
	sbar->callback(callback_Scroll, this);

	if (! alternate_look)
		sbar->color(FL_DARK3+1, FL_DARK3+1);


	pack = new Fl_Group(mx, my, mw, mh, "\n\n\n\nList of Addons");
	pack->clip_children(1);
	pack->end();

	pack->align(FL_ALIGN_INSIDE);
	pack->labeltype(FL_NORMAL_LABEL);
	pack->labelsize(FL_NORMAL_SIZE * 3 / 2);

	pack->box(FL_FLAT_BOX);
	pack->color(WINDOW_BG);
	pack->resizable(NULL);


	//----------------

	Fl_Box *sep = new Fl_Box(FL_FLAT_BOX, 0, H-dh, W, 3, "");
	sep->color(FL_BACKGROUND_COLOR);


	// finally add the close button
	int bw = kf_w(60);
	int bh = kf_h(30);
	int bx = bw;
	int by = H - dh/2 - bh/2 + 2;

	Fl_Button *apply_but = new Fl_Button(W-bx-bw, by, bw, bh, "Close");
	apply_but->callback(callback_Quit, this);


	// show warning about needing a restart
	sep = new Fl_Box(FL_NO_BOX, x(), by, W*3/5, bh, "Changes require a restart");
	sep->align(FL_ALIGN_INSIDE);
	sep->labelcolor(FL_DARK1);
	sep->labelsize(small_font_size);


	end();

	resizable(NULL);
}


int UI_AddonsWin::handle(int event)
{
	if (event == FL_KEYDOWN || event == FL_SHORTCUT)
	{
		int key = Fl::event_key();

		switch (key)
		{
			case FL_Escape:
				want_quit = true;
				return 1;

			default:
				break;
		}

		// eat all other function keys
		if (FL_F+1 <= key && key <= FL_F+12)
			return 1;
	}

	return Fl_Window::handle(event);
}


void UI_AddonsWin::PositionAll()
{
	int spacing = 4;

	int ny = my - offset_y;

	for (int j = 0 ; j < pack->children() ; j++)
	{
		UI_Addon *M = (UI_Addon *) pack->child(j);
		SYS_ASSERT(M);

		int nh = kf_h(34);

		if (ny != M->y() || nh != M->h())
		{
			M->resize(M->x(), ny, M->w(), nh);
		}

		ny += nh + spacing;
	}

	// p = position, first line displayed
	// w = window, number of lines displayed
	// t = top, number of first line
	// l = length, total number of lines
	sbar->value(offset_y, mh, 0, total_h);

	pack->redraw();
}


void UI_AddonsWin::InsertAddon(const addon_info_t *info)
{
	UI_Addon *addon = new UI_Addon(mx, my, mw, kf_h(34), info->name, info->name, NULL);

	pack->add(addon);

	PositionAll();
}


void UI_AddonsWin::Populate()
{
	for (unsigned int i = 0 ; i < all_addons.size() ; i++)
	{
		InsertAddon(&all_addons[i]);
	}
}


void DLG_SelectAddons(void)
{
	static UI_AddonsWin * addons_window = NULL;

	if (! addons_window)
	{
		int opt_w = kf_w(350);
		int opt_h = kf_h(380);

		addons_window = new UI_AddonsWin(opt_w, opt_h, "OBLIGE Addons");

		addons_window->Populate();
	}

	addons_window->want_quit = false;
	addons_window->set_modal();
	addons_window->show();

	// run the GUI until the user closes
	while (! addons_window->WantQuit())
		Fl::wait();

	addons_window->set_non_modal();
	addons_window->hide();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
