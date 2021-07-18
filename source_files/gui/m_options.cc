//----------------------------------------------------------------------
//  Options Editor
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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

#include "fmt/core.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_trans.h"
#include "main.h"

static void Parse_Option(const char *name, const char *value) {
    if (StringCaseCmpPartial(name, "recent") == 0) {
        Recent_Parse(name, value);
        return;
    }

    if (StringCaseCmp(name, "addon") == 0) {
        VFS_OptParse(value);
    } else if (StringCaseCmp(name, "language") == 0) {
        t_language = value;
    } else if (StringCaseCmp(name, "create_backups") == 0) {
        create_backups = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "overwrite_warning") == 0) {
        overwrite_warning = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "debug_messages") == 0) {
        debug_messages = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "last_directory") == 0) {
        last_directory = value;
    } else if (StringCaseCmp(name, "filename_prefix") == 0) {
        filename_prefix = atoi(value);
    } else if (StringCaseCmp(name, "custom_prefix") == 0) {
        custom_prefix = value;
    } else {
        LogPrintf("Unknown option: '%s'\n", name);
    }
}

static bool Options_ParseLine(char *buf) {
    // remove whitespace
    while (isspace(*buf)) {
        buf++;
    }

    int len = strlen(buf);

    while (len > 0 && isspace(buf[len - 1])) {
        buf[--len] = 0;
    }

    // ignore blank lines and comments
    if (*buf == 0) {
        return true;
    }

    if (buf[0] == '-' && buf[1] == '-') {
        return true;
    }

    if (!isalpha(*buf)) {
        LogPrintf("Weird option line: [%s]\n", buf);
        return false;
    }

    // Righteo, line starts with an identifier.  It should be of the
    // form "name = value".  We terminate the identifier and pass
    // the name/value strings to the matcher function.

    const char *name = buf;

    for (buf++; isalnum(*buf) || *buf == '_' || *buf == '.';
         buf++) { /* nothing here */
    }

    while (isspace(*buf)) {
        *buf++ = 0;
    }

    if (*buf != '=') {
        LogPrintf("Option line missing '=': [%s]\n", buf);
        return false;
    }

    *buf++ = 0;

    if (isspace(*buf)) {
        *buf++ = 0;
    }

    // everything after the " = " (note: single space) is the value,
    // and it does not need escaping since our values never contain
    // newlines or embedded spaces (nor control characters, but may
    // contain UTF-8 encoded filenames).

    if (*buf == 0) {
        LogPrintf("Option line missing value!\n");
        return false;
    }

    Parse_Option(name, buf);
    return true;
}

bool Options_Load(const char *filename) {
    FILE *option_fp = fopen(filename, "r");

    if (!option_fp) {
        LogPrintf("Missing Options file -- using defaults.\n\n");
        return false;
    }

    LogPrintf("Loading options file: %s\n", filename);

    // simple line-by-line parser
    char buffer[MSG_BUF_LEN];

    int error_count = 0;

    while (fgets(buffer, MSG_BUF_LEN - 2, option_fp)) {
        if (!Options_ParseLine(buffer)) {
            error_count += 1;
        }
    }

    if (error_count > 0) {
        LogPrintf("DONE (found %d parse errors)\n\n", error_count);
    } else {
        LogPrintf("DONE.\n\n");
    }

    fclose(option_fp);

    return true;
}

bool Options_Save(const char *filename) {
    FILE *option_fp = fopen(filename, "w");

    if (!option_fp) {
        LogPrintf("Error: unable to create file: %s\n(%s)\n\n", filename,
                  strerror(errno));
        return false;
    }

    LogPrintf("Saving options file...\n");

    fmt::print(option_fp, "-- OPTIONS FILE : OBSIDIAN {}\n", OBSIDIAN_VERSION);
    fmt::print(option_fp,
               "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fmt::print(option_fp, "-- " OBSIDIAN_WEBSITE "\n\n");

    fmt::print(option_fp, "language = {}\n", t_language);
    fmt::print(option_fp, "\n");

    fmt::print(option_fp, "create_backups = {}\n", create_backups ? 1 : 0);
    fmt::print(option_fp, "overwrite_warning = {}\n",
               overwrite_warning ? 1 : 0);
    fmt::print(option_fp, "debug_messages = {}\n", debug_messages ? 1 : 0);
    fmt::print(option_fp, "filename_prefix = {}\n", filename_prefix);
    fmt::print(option_fp, "custom_prefix = {}\n", custom_prefix);

    if (!last_directory.empty()) {
        fmt::print(option_fp, "\n");
        fmt::print(option_fp, "last_directory = {}\n", last_directory);
    }

    fmt::print(option_fp, "\n");

    VFS_OptWrite(option_fp);

    Recent_Write(option_fp);

    fclose(option_fp);

    LogPrintf("DONE.\n\n");

    return true;
}

//----------------------------------------------------------------------

class UI_OptionsWin : public Fl_Window {
   public:
    bool want_quit;

   private:
    UI_CustomMenu *opt_language;
    UI_CustomMenu *opt_filename_prefix;

    Fl_Button *opt_custom_prefix;
    UI_HelpLink *custom_prefix_help;

    UI_CustomCheckBox *opt_backups;
    UI_CustomCheckBox *opt_overwrite;
    UI_CustomCheckBox *opt_debug;

   public:
    UI_OptionsWin(int W, int H, const char *label = NULL);

    virtual ~UI_OptionsWin() {
        // nothing needed
    }

    bool WantQuit() const { return want_quit; }

   public:
    // FLTK virtual method for handling input events.
    int handle(int event);

    void PopulateLanguages() {
        opt_language->add(_("AUTO"));
        opt_language->value(0);

        for (int i = 0;; i++) {
            std::string fullname = Trans_GetAvailLanguage(i);

            if (fullname.empty()) {
                break;
            }

            opt_language->add(fullname.c_str());

            // check for match against current language
            std::string lc = Trans_GetAvailCode(i);

            if (lc == t_language) {
                opt_language->value(i + 1);
            }
        }
    }

   private:
    static void callback_Quit(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        that->want_quit = true;
    }

    static void callback_Language(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        int val = that->opt_language->value();

        if (val == 0) {
            t_language = "AUTO";
        } else {
            t_language = Trans_GetAvailCode(val - 1);

            // this should not happen
            if (t_language.empty()) {
                t_language = "AUTO";
            }
        }
    }

    static void callback_Backups(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        create_backups = that->opt_backups->value() ? true : false;
    }

    static void callback_Overwrite(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        overwrite_warning = that->opt_overwrite->value() ? true : false;
    }

    static void callback_Debug(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        debug_messages = that->opt_debug->value() ? true : false;
        LogEnableDebug(debug_messages);
    }

    static void callback_FilenamePrefix(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        filename_prefix = that->opt_filename_prefix->value();

        fl_alert("%s",
                 _("File prefix changes require a restart.\nOBSIDIAN will "
                   "now restart."));

        main_action = MAIN_RESTART;

        that->want_quit = true;
    }

    static void callback_PrefixHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, "Custom Prefix");
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp =
            new Fl_Text_Display(20, 20, 640 - 40, 480 - 40, NULL);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        buff->text(
            "Custom prefixes can use any of the special format strings listed below. Anything else is used as-is.\n\n\
%year or %Y: The current year.\n\n\
%month or %M: The current month.\n\n\
%day or %D: The current day.\n\n\
%hour or %h: The current hour.\n\n\
%minute or %m: The current minute.\n\n\
%second or %s: The current second.\n\n\
%version or %v: The current Obsidian version.\n\n\
%game or %g: Which game the WAD is for.\n\n\
%theme or %t: Which theme was selected from the game's choices.\n\n\
%count or %c: The number of levels in the generated WAD.");
    }

    static void callback_SetCustomPrefix(Fl_Widget *w, void *data) {
        const char *user_buf = fl_input("%s", _("Enter Custom Prefix Format:"),
                                        custom_prefix.c_str());

        if (user_buf) {
            custom_prefix = user_buf;
        }
    }
};

//
// Constructor
//
UI_OptionsWin::UI_OptionsWin(int W, int H, const char *label)
    : Fl_Window(W, H, label), want_quit(false) {
    // non-resizable
    size_range(W, H, W, H);

    callback(callback_Quit, this);

    box(FL_FLAT_BOX);

    int y_step = kf_h(9);
    int pad = kf_w(6);

    int cx = x() + kf_w(24);
    int cy = y() + (y_step * 3);

    Fl_Box *heading;

    opt_language = new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24),
                                     _("Language: "));
    opt_language->align(FL_ALIGN_LEFT);
    opt_language->callback(callback_Language, this);
    opt_language->labelfont(font_style);
    opt_language->textcolor(FONT2_COLOR);
    opt_language->textfont(font_style);
    opt_language->selection_color(SELECTION);

    PopulateLanguages();

    cy += opt_language->h() + y_step;

    opt_filename_prefix = new UI_CustomMenu(136 + KF * 40, cy, kf_w(130),
                                            kf_h(24), _("Filename Prefix: "));
    opt_filename_prefix->align(FL_ALIGN_LEFT);
    opt_filename_prefix->callback(callback_FilenamePrefix, this);
    opt_filename_prefix->add(
        _("Date and Time|Number of Levels|Game|Theme|Version|Custom|Nothing"));
    opt_filename_prefix->labelfont(font_style);
    opt_filename_prefix->textfont(font_style);
    opt_filename_prefix->textcolor(FONT2_COLOR);
    opt_filename_prefix->selection_color(SELECTION);
    opt_filename_prefix->value(filename_prefix);

    cy += opt_filename_prefix->h() + y_step;

    opt_custom_prefix = new Fl_Button(136 + KF * 40, cy, kf_w(130), kf_h(24),
                                      _("Set Custom Prefix..."));
    opt_custom_prefix->box(button_style);
    opt_custom_prefix->visible_focus(0);
    opt_custom_prefix->color(BUTTON_COLOR);
    opt_custom_prefix->callback(callback_SetCustomPrefix, this);
    opt_custom_prefix->labelfont(font_style);
    opt_custom_prefix->labelcolor(FONT2_COLOR);

    custom_prefix_help =
        new UI_HelpLink(136 + KF * 40 + this->opt_custom_prefix->w(), cy,
                        W * 0.10, kf_h(24), "?");
    custom_prefix_help->labelfont(font_style);
    custom_prefix_help->callback(callback_PrefixHelp, this);

    cy += opt_custom_prefix->h() + y_step * 2;

    opt_backups = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24),
                                        _(" Create Backups"));
    opt_backups->value(create_backups ? 1 : 0);
    opt_backups->callback(callback_Backups, this);
    opt_backups->labelfont(font_style);
    opt_backups->selection_color(SELECTION);
    opt_backups->down_box(button_style);

    cy += opt_backups->h() + y_step * 2 / 3;

    opt_overwrite = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24),
                                          _(" Overwrite File Warning"));
    opt_overwrite->value(overwrite_warning ? 1 : 0);
    opt_overwrite->callback(callback_Overwrite, this);
    opt_overwrite->labelfont(font_style);
    opt_overwrite->selection_color(SELECTION);
    opt_overwrite->down_box(button_style);

    cy += opt_overwrite->h() + y_step * 2 / 3;

    opt_debug = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24),
                                      _(" Debugging Messages"));
    opt_debug->value(debug_messages ? 1 : 0);
    opt_debug->callback(callback_Debug, this);
    opt_debug->labelfont(font_style);
    opt_debug->selection_color(SELECTION);
    opt_debug->down_box(button_style);

    cy += opt_debug->h() + y_step;

    //----------------

    int dh = kf_h(60);

    int bw = kf_w(60);
    int bh = kf_h(30);
    int bx = W - kf_w(40) - bw;
    int by = H - dh / 2 - bh / 2;

    Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
    darkish->box(FL_FLAT_BOX);
    {
        // finally add an "Close" button

        Fl_Button *button = new Fl_Button(bx, by, bw, bh, fl_close);
        button->box(button_style);
        button->visible_focus(0);
        button->color(BUTTON_COLOR);
        button->callback(callback_Quit, this);
        button->labelfont(font_style);
        button->labelcolor(FONT2_COLOR);
    }
    darkish->end();

    // restart needed warning
    heading = new Fl_Box(FL_NO_BOX, x() + pad, H - dh - kf_h(3), W - pad * 2,
                         kf_h(14), _("Note: some options require a restart."));
    heading->align(FL_ALIGN_INSIDE);
    heading->labelsize(small_font_size);
    heading->labelfont(font_style);

    end();

    resizable(NULL);
}

int UI_OptionsWin::handle(int event) {
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

void DLG_OptionsEditor(void) {
    int opt_w = kf_w(350);
    int opt_h = kf_h(300);

    UI_OptionsWin *option_window =
        new UI_OptionsWin(opt_w, opt_h, _("OBSIDIAN Misc Options"));

    option_window->want_quit = false;
    option_window->set_modal();
    option_window->show();

    // run the GUI until the user closes
    while (!option_window->WantQuit()) {
        Fl::wait();
    }

    // save the options now
    Options_Save(options_file.c_str());

    delete option_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
