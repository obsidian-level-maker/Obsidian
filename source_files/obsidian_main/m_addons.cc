//----------------------------------------------------------------------
//  Addons Loading and Selection GUI
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#include "m_addons.h"

#include "headers.h"

#include "fmt/core.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"
#include "m_cookie.h"
#include "main.h"
#include "physfs.h"

// need this because the OPTIONS file is loaded *before* the addons
// folder is scanned for PK3 packages, so remember enabled ones here.
std::map<std::filesystem::path, int> initial_enabled_addons;

std::vector<addon_info_t> all_addons;

void VFS_AddFolder(std::string name) {
    std::filesystem::path path = install_dir;
    path /= name;
    std::string mount = fmt::format("/{}", name);

    if (!PHYSFS_mount(path.string().c_str(), mount.c_str(), 0)) {
        Main::FatalError("Failed to mount '{}' folder in PhysFS:\n{}\n", name,
                         PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        return; /* NOT REACHED */
    }

    DebugPrintf("mounted folder '{}'\n", name);
}

bool VFS_AddArchive(std::filesystem::path filename, bool options_file) {
    LogPrintf("  using: {}\n", filename.string());

    if (!filename.has_extension()) {
        filename.replace_extension("pk3");
    }

    // when handling "bare" filenames from the command line (i.e. ones
    // containing no paths or drive spec) and the file does not exist in
    // the current dir, look for it in the standard addons/ folder.
    if ((!std::filesystem::exists(filename) && !filename.has_parent_path())) {
        std::filesystem::path new_name =
            fmt::format("{}/addons/{}", home_dir.string(), filename.string());
        if (!std::filesystem::exists(new_name)) {
            new_name = fmt::format("{}/addons/{}", install_dir.string(),
                                   filename.string());
        }
        filename = new_name;
    }

    if (!PHYSFS_mount(filename.string().c_str(), "/", 0)) {
        if (options_file) {
            LogPrintf(
                fmt::format("Failed to mount '{}' archive in PhysFS:\n{}\n",
                            filename.string(),
                            PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()))
                    .c_str());
        } else {
            Main::FatalError("Failed to mount '{}' archive in PhysFS:\n{}\n",
                             filename.string(),
                             PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
        }

        return false;
    }

    return true;  // Ok
}

void VFS_InitAddons(const char *argv0) {
    LogPrintf("Initializing VFS...\n");

    if (!PHYSFS_init(argv0)) {
        Main::FatalError("Failed to init PhysFS:\n{}\n",
                         PHYSFS_getErrorByCode(PHYSFS_getLastErrorCode()));
    }

    VFS_AddFolder("scripts");
    VFS_AddFolder("games");
    VFS_AddFolder("engines");
    VFS_AddFolder("modules");
    VFS_AddFolder("data");

    LogPrintf("DONE.\n\n");
}

void VFS_ParseCommandLine() {
    int arg = argv::Find('a', "addon");
    int count = 0;

    if (arg < 0) {
        return;
    }

    arg++;

    LogPrintf("Command-line addons....\n");

    for (; arg < argv::list.size() && !argv::IsOption(arg); arg++, count++) {
        VFS_AddArchive(argv::list[arg], false /* options_file */);
    }

    if (!count) {
        Main::FatalError("Missing filename for --addon option\n");
    }

    LogPrintf("DONE\n\n");
}

void VFS_OptParse(std::string name) {
    // just remember it now
    if (initial_enabled_addons.find(name) == initial_enabled_addons.end()) {
        initial_enabled_addons[name] = 1;
    }
}

void VFS_OptWrite(std::ofstream &fp) {
    fp << "---- Enabled Addons ----\n\n";

    for (unsigned int i = 0; i < all_addons.size(); i++) {
        const addon_info_t *info = &all_addons[i];

        if (info->enabled) {
            fp << "addon = " << info->name.string() << "\n";
        }
    }

    fp << "\n";
}

void VFS_ScanForAddons() {
    LogPrintf("Scanning for addons....\n");

    all_addons.clear();

    std::filesystem::path dir_name = install_dir;
    dir_name /= "addons";

    std::vector<std::filesystem::path> list;
    int result1 = 0;
    int result2 = 0;

    for (auto &file : std::filesystem::directory_iterator(dir_name)) {
        if (file.path().has_extension() &&
            StringCaseCmp(file.path().extension().generic_string(), ".pk3") ==
                0) {
            result1 += 1;
            list.push_back(file.path());
        }
    }

    if (StringCaseCmp(home_dir.generic_string(),
                      install_dir.generic_string()) != 0) {
        dir_name = home_dir;
        dir_name /= "addons";
        if (!std::filesystem::exists(dir_name)) {
            goto no_home_addon_dir;
        }

        std::vector<std::filesystem::path> list2;

        for (auto &file : std::filesystem::directory_iterator(dir_name)) {
            if (file.path().has_extension() &&
                StringCaseCmp(file.path().extension().generic_string(),
                              ".pk3") == 0) {
                result2 += 1;
                list2.push_back(file.path());
            }
        }
        // std::vector<std::filesystem::path>().swap(list2);
        for (auto x : list2) {
            list.push_back(x);
        }
    }

no_home_addon_dir:

    if ((result1 < 0) && (result2 < 0)) {
        LogPrintf("FAILED -- no addon directory found.\n\n");
        return;
    }

    for (unsigned int i = 0; i < list.size(); i++) {
        addon_info_t info;

        info.name = list[i];

        info.enabled = false;

        if (initial_enabled_addons.find(list[i]) !=
            initial_enabled_addons.end()) {
            info.enabled = true;
        }

        // DEBUG
        // info.enabled = true;

        LogPrintf("  found: {}{}\n", info.name.string(),
                  info.enabled ? " (Enabled)" : " (Disabled)");

        all_addons.push_back(info);

        // if enabled, install into the VFS
        if (info.enabled) {
            VFS_AddArchive(info.name, true /* options_file */);
        }
    }

    if (list.size() == 0) {
        LogPrintf("DONE (none found)\n");
    } else {
        LogPrintf("DONE\n");
    }

    LogPrintf("\n");
}

//----------------------------------------------------------------------

//
// this is useful to "extract" something out of virtual FS to the real
// file system so we can use normal stdio file operations on it
// [ especially a _library_ that uses stdio.h ]
//
bool VFS_CopyFile(const char *src_name, const char *dest_name) {
    char buffer[1024];

    PHYSFS_file *src = PHYSFS_openRead(src_name);
    if (!src) {
        return false;
    }

    FILE *dest = fopen(dest_name, "wb");
    if (!dest) {
        PHYSFS_close(src);
        return false;
    }

    bool was_OK = true;

    while (was_OK) {
        int rlen = (int)(PHYSFS_readBytes(src, buffer, sizeof(buffer)) /
                         sizeof(buffer));
        if (rlen < 0) {
            was_OK = false;
        }

        if (rlen <= 0) {
            break;
        }

        int wlen = fwrite(buffer, 1, rlen, dest);
        if (wlen < rlen || ferror(dest)) {
            was_OK = false;
        }
    }

    fclose(dest);
    PHYSFS_close(src);

    return was_OK;
}

byte *VFS_LoadFile(const char *filename, int *length) {
    *length = 0;

    PHYSFS_File *fp = PHYSFS_openRead(filename);

    if (!fp) {
        return NULL;
    }

    *length = (int)PHYSFS_fileLength(fp);

    if (*length < 0) {
        PHYSFS_close(fp);
        return NULL;
    }

    byte *data = new byte[*length + 1];

    // ensure buffer is NUL-terminated
    data[*length] = 0;

    if ((PHYSFS_readBytes(fp, data, *length) / *length) != 1) {
        VFS_FreeFile(data);
        PHYSFS_close(fp);
        return NULL;
    }

    PHYSFS_close(fp);

    return data;
}

void VFS_FreeFile(const byte *mem) {
    if (mem) {
        delete[] mem;
    }
}

//----------------------------------------------------------------------

class UI_Addon : public Fl_Group {
   public:
    addon_info_t *info;

    UI_CustomCheckBox *button;

   public:
    UI_Addon(int x, int y, int w, int h, addon_info_t *_info)
        : Fl_Group(x, y, w, h), info(_info) {
        box(box_style);

        button = new UI_CustomCheckBox(x + kf_w(6), y + kf_h(4), w - kf_w(12),
                                       kf_h(24), "");
        button->copy_label(
            fmt::format(" {}", info->name.filename().string()).c_str());
        button->labelfont(font_style);
        button->selection_color(SELECTION);
        // if (tip)
        //    button->tooltip(tip);
        end();

        resizable(NULL);
    }

    virtual ~UI_Addon() {}

    int CalcHeight() const { return kf_h(34); }
};

//----------------------------------------------------------------------

class UI_AddonsWin : public Fl_Window {
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

    virtual ~UI_AddonsWin() {
        // nothing needed
    }

    void Populate();

    bool ApplyChanges();

    bool WantQuit() const { return want_quit; }

   public:
    // FLTK virtual method for handling input events.
    int handle(int event);

   private:
    void InsertAddon(addon_info_t *info);

    void PositionAll();

    static void callback_Scroll(Fl_Widget *w, void *data) {
        UI_AddonsWin *that = (UI_AddonsWin *)data;

        Fl_Scrollbar *sbar = (Fl_Scrollbar *)w;

        int previous_y = that->offset_y;

        that->offset_y = sbar->value();

        int dy = that->offset_y - previous_y;

        // simply reposition all the UI_Module widgets
        for (int j = 0; j < that->pack->children(); j++) {
            Fl_Widget *F = that->pack->child(j);
            SYS_ASSERT(F);

            F->resize(F->x(), F->y() - dy, F->w(), F->h());
        }

        that->pack->redraw();
    }

    static void callback_Quit(Fl_Widget *w, void *data) {
        UI_AddonsWin *that = (UI_AddonsWin *)data;

        that->want_quit = true;
    }
};

//
// Constructor
//
UI_AddonsWin::UI_AddonsWin(int W, int H, const char *label)
    : Fl_Window(W, H, label), want_quit(false) {
    callback(callback_Quit, this);

    // non-resizable
    size_range(W, H, W, H);

    box(FL_FLAT_BOX);

    color(WINDOW_BG, WINDOW_BG);

    //    int pad = kf_w(6);

    int dh = kf_h(64);

    // area for addons list
    mx = 0;
    my = 0;
    mw = W - Fl::scrollbar_size();
    mh = H - dh;

    offset_y = 0;
    total_h = 0;

    sbar = new Fl_Scrollbar(mx + mw, my, Fl::scrollbar_size(), mh);
    sbar->callback(callback_Scroll, this);
    sbar->slider(button_style);
    sbar->color(GAP_COLOR, BUTTON_COLOR);
    sbar->labelcolor(SELECTION);

    if (all_addons.empty()) {
        pack = new Fl_Group(mx, my, mw, mh, "");
        pack->copy_label(
            fmt::format("\n\n\n\n{}", _("No Addons Found!")).c_str());
    } else {
        pack = new Fl_Group(mx, my, mw, mh, 0);
    }
    pack->clip_children(1);
    pack->end();

    pack->align(FL_ALIGN_INSIDE);
    pack->labeltype(FL_NORMAL_LABEL);
    pack->labelsize(FL_NORMAL_SIZE * 3 / 2);
    pack->labelfont(font_style);

    pack->box(button_style);
    pack->resizable(NULL);

    //----------------

    Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
    darkish->box(FL_FLAT_BOX);
    darkish->color(WINDOW_BG);
    {
        // finally add the close button
        int bw = kf_w(60);
        int bh = kf_h(30);
        int bx = bw;
        int by = H - dh / 2 - bh / 2 + 2;

        Fl_Button *apply_but = new Fl_Button(W - bx - bw, by, bw, bh, fl_close);
        apply_but->box(button_style);
        apply_but->visible_focus(0);
        apply_but->color(BUTTON_COLOR);
        apply_but->callback(callback_Quit, this);
        apply_but->labelfont(font_style);
        apply_but->labelcolor(FONT2_COLOR);

        // show warning about needing a restart
        Fl_Box *sep = new Fl_Box(FL_NO_BOX, x(), by, W * 3 / 5, bh,
                                 _("Changes require a restart"));
        sep->align(FL_ALIGN_INSIDE);
        sep->labelsize(small_font_size);
        sep->labelfont(font_style);
        sep->labelcolor(FONT_COLOR);
    }
    darkish->end();

    end();

    resizable(NULL);
}

int UI_AddonsWin::handle(int event) {
    if (event == FL_KEYDOWN || event == FL_SHORTCUT) {
        int key = Fl::event_key();

        switch (key) {
            case FL_Escape:
                want_quit = true;
                return 1;

            default:
                break;
        }

        // eat all other function keys
        if (FL_F + 1 <= key && key <= FL_F + 12) {
            return 1;
        }
    }

    return Fl_Window::handle(event);
}

void UI_AddonsWin::PositionAll() {
    // calculate new total height
    int new_height = 0;
    int spacing = 4;

    for (int k = 0; k < pack->children(); k++) {
        UI_Addon *M = (UI_Addon *)pack->child(k);
        SYS_ASSERT(M);

        if (M->visible()) {
            new_height += M->CalcHeight() + spacing;
        }
    }

    // determine new offset_y
    if (new_height <= mh) {
        offset_y = 0;
    } else {
        // when not shrinking, offset_y will remain valid
        if (new_height < total_h) {
            offset_y = 0;
        }
    }

    total_h = new_height;

    SYS_ASSERT(offset_y >= 0);
    SYS_ASSERT(offset_y <= total_h);

    // reposition all the modules
    int ny = my - offset_y;

    for (int j = 0; j < pack->children(); j++) {
        UI_Addon *M = (UI_Addon *)pack->child(j);
        SYS_ASSERT(M);

        int nh = M->visible() ? M->CalcHeight() : 1;

        if (ny != M->y() || nh != M->h()) {
            M->resize(M->x(), ny, M->w(), nh);
        }

        if (M->visible()) {
            ny += M->CalcHeight() + spacing;
        }
    }

    // p = position, first line displayed
    // w = window, number of lines displayed
    // t = top, number of first line
    // l = length, total number of lines
    sbar->value(offset_y, mh, 0, total_h);

    pack->redraw();
}

void UI_AddonsWin::InsertAddon(addon_info_t *info) {
    UI_Addon *addon = new UI_Addon(mx, my, mw - 4, kf_h(34), info);

    if (info->enabled) {
        addon->button->value(1);
    }

    pack->add(addon);

    PositionAll();
}

void UI_AddonsWin::Populate() {
    for (unsigned int i = 0; i < all_addons.size(); i++) {
        InsertAddon(&all_addons[i]);
    }
}

bool UI_AddonsWin::ApplyChanges() {
    bool has_changes = false;

    for (int j = 0; j < pack->children(); j++) {
        UI_Addon *M = (UI_Addon *)pack->child(j);
        SYS_ASSERT(M);

        bool new_val = M->button->value() ? true : false;

        if (M->info->enabled != new_val) {
            has_changes = true;
            M->info->enabled = new_val;
        }
    }

    return has_changes;
}

void DLG_SelectAddons(void) {
    int opt_w = kf_w(350);
    int opt_h = kf_h(380);

    UI_AddonsWin *addons_window =
        new UI_AddonsWin(opt_w, opt_h, _("OBSIDIAN Addons"));

    addons_window->Populate();

    addons_window->want_quit = false;
    addons_window->set_modal();
    addons_window->show();

    // run the GUI until the user closes
    while (!addons_window->WantQuit()) {
        Fl::wait();
    }

    if (addons_window->ApplyChanges()) {
        // persist the changed addon list into OPTIONS.txt
        Options_Save(options_file);

        fl_alert("%s", _("Changes to addons require a restart.\nOBSIDIAN will "
                         "now restart."));

        initial_enabled_addons.clear();

        for (int j = 0; j < addons_window->pack->children(); j++) {
            UI_Addon *M = (UI_Addon *)addons_window->pack->child(j);
            SYS_ASSERT(M);
            if (M->info->enabled) {
                initial_enabled_addons[M->info->name] = 1;
            }
        }

        main_action = MAIN_RESTART;
    }

    delete addons_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
