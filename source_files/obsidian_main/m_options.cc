//----------------------------------------------------------------------
//  Options Editor
//----------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
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

static void Parse_Option(std::string name, std::string value) {
    if (StringCaseCmpPartial(name, "recent") == 0) {
        Recent_Parse(name, value);
        return;
    }

    if (StringCaseCmp(name, "addon") == 0) {
        VFS_OptParse(value);
    } else if (StringCaseCmp(name, "language") == 0) {
        t_language = value;
    } else if (StringCaseCmp(name, "create_backups") == 0) {
        create_backups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "overwrite_warning") == 0) {
        overwrite_warning = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "debug_messages") == 0) {
        debug_messages = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "limit_break") == 0) {
        limit_break = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "preserve_failures") == 0) {
        preserve_failures = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "preserve_old_config") == 0) {
        preserve_old_config = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_architecture") == 0) {
        randomize_architecture = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_monsters") == 0) {
        randomize_monsters = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_pickups") == 0) {
        randomize_pickups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_misc") == 0) {
        randomize_misc = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "random_string_seeds") == 0) {
        random_string_seeds = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "password_mode") == 0) {
        password_mode = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "last_directory") == 0) {
        last_directory = value;
    } else if (StringCaseCmp(name, "filename_prefix") == 0) {
        filename_prefix = StringToInt(value);
    } else if (StringCaseCmp(name, "custom_prefix") == 0) {
        custom_prefix = value;
    } else if (StringCaseCmp(name, "zip_output") == 0) {
        zip_output = StringToInt(value);
    } else if (StringCaseCmp(name, "zip_logs") == 0) {
        zip_logs = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "timestamp_logs") == 0) {
        timestamp_logs = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "log_limit") == 0) {
        log_limit = StringToInt(value);
    } else if (StringCaseCmp(name, "restart_after_builds") == 0) {
        restart_after_builds = StringToInt(value) ? true : false;
    } else {
        LogPrintf("Unknown option: '{}'\n", name);
    }
}

static bool Options_ParseLine(std::string buf) {
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos) {
        // Skip blank lines, comments, etc
        return true;
    }

    // For options file, don't strip whitespace as it can cause issue with addon
    // paths that have whitespace - Dasho

    /*while (std::find(buf.begin(), buf.end(), ' ') != buf.end()) {
        buf.erase(std::find(buf.begin(), buf.end(), ' '));
    }*/

    if (!isalpha(buf.front())) {
        LogPrintf("Weird option line: [{}]\n", buf);
        return false;
    }

    // pos = buf.find('=', 0);  // Fix pos after whitespace deletion
    std::string name = buf.substr(0, pos - 1);
    std::string value = buf.substr(pos + 2);

    if (name.empty() || value.empty()) {
        LogPrintf("Name or value missing!\n");
        return false;
    }

    Parse_Option(name, value);
    return true;
}

bool Options_Load(std::filesystem::path filename) {
    std::ifstream option_fp(filename, std::ios::in);

    if (!option_fp.is_open()) {
        LogPrintf("Missing Options file -- using defaults.\n\n");
        return false;
    }

    LogPrintf("Loading options file: {}\n", filename.string());

    int error_count = 0;

    for (std::string line; std::getline(option_fp, line);) {
        if (!Options_ParseLine(line)) {
            error_count += 1;
        }
    }

    if (error_count > 0) {
        LogPrintf("DONE (found {} parse errors)\n\n", error_count);
    } else {
        LogPrintf("DONE.\n\n");
    }

    option_fp.close();

    return true;
}

bool Options_Save(std::filesystem::path filename) {
    std::ofstream option_fp(filename, std::ios::out);

    if (!option_fp.is_open()) {
        LogPrintf("Error: unable to create file: {}\n({})\n\n",
                  filename.string(), strerror(errno));
        return false;
    }

    LogPrintf("Saving options file...\n");

    option_fp << "-- OPTIONS FILE : OBSIDIAN " << OBSIDIAN_SHORT_VERSION
              << " \"" << OBSIDIAN_CODE_NAME << "\"\n";
    option_fp << "-- Build " << OBSIDIAN_VERSION << "\n";
    option_fp << "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n";
    option_fp << "-- " << OBSIDIAN_WEBSITE << "\n\n";

    option_fp << "language = " << t_language << "\n";
    option_fp << "\n";

    option_fp << "create_backups = " << (create_backups ? 1 : 0) << "\n";
    option_fp << "overwrite_warning = " << (overwrite_warning ? 1 : 0) << "\n";
    option_fp << "debug_messages = " << (debug_messages ? 1 : 0) << "\n";
    option_fp << "limit_break = " << (limit_break ? 1 : 0) << "\n";
    option_fp << "preserve_failures = " << (preserve_failures ? 1 : 0) << "\n";
    option_fp << "preserve_old_config = " << (preserve_old_config ? 1 : 0)
              << "\n";
    option_fp << "randomize_architecture = " << (randomize_architecture ? 1 : 0)
              << "\n";
    option_fp << "randomize_monsters = " << (randomize_monsters ? 1 : 0)
              << "\n";
    option_fp << "randomize_pickups = " << (randomize_pickups ? 1 : 0) << "\n";
    option_fp << "randomize_misc = " << (randomize_misc ? 1 : 0) << "\n";
    option_fp << "random_string_seeds = " << (random_string_seeds ? 1 : 0)
              << "\n";
    option_fp << "password_mode = " << (password_mode ? 1 : 0) << "\n";
    option_fp << "filename_prefix = " << filename_prefix << "\n";
    option_fp << "custom_prefix = " << custom_prefix << "\n";
    option_fp << "zip_output = " << zip_output << "\n";
    option_fp << "zip_logs = " << zip_logs << "\n";
    option_fp << "timestamp_logs = " << timestamp_logs << "\n";
    option_fp << "log_limit = " << log_limit << "\n";
    option_fp << "restart_after_builds = " << restart_after_builds << "\n";

    if (!last_directory.empty()) {
        option_fp << "\n";
        option_fp << "last_directory = " << last_directory.string() << "\n";
    }

    option_fp << "\n";

    VFS_OptWrite(option_fp);

    Recent_Write(option_fp);

    option_fp.close();

    LogPrintf("DONE.\n\n");

    return true;
}

//----------------------------------------------------------------------

class UI_OptionsWin : public Fl_Window {
   public:
    bool want_quit;

   private:
    UI_CustomMenu *opt_language;
    UI_CustomMenu *opt_zip_output;
    UI_CustomMenu *opt_filename_prefix;

    Fl_Button *opt_custom_prefix;
    UI_HelpLink *custom_prefix_help;

    UI_CustomCheckBox *opt_random_string_seeds;
    UI_HelpLink *random_string_seeds_help;
    UI_CustomCheckBox *opt_password_mode;
    UI_HelpLink *password_mode_help;
    UI_CustomCheckBox *opt_backups;
    UI_CustomCheckBox *opt_overwrite;
    UI_CustomCheckBox *opt_debug;
    UI_CustomCheckBox *opt_limit_break;
    UI_CustomCheckBox *opt_preserve_failures;
    UI_CustomCheckBox *opt_zip_logs;
    UI_CustomCheckBox *opt_timestamp_logs;
    Fl_Simple_Counter *opt_log_limit;
    UI_CustomCheckBox *opt_restart_after_builds;
    UI_HelpLink *restart_after_builds_help;

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
        fl_alert("%s", _("Obsidian will now close to apply language "
                         "changes.\nObsidian will be in your selected language"
                         " when you restart the program."));

        main_action = MAIN_QUIT;

        that->want_quit = true;
    }

    static void callback_RestartAfterBuilds(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        restart_after_builds =
            that->opt_restart_after_builds->value() ? true : false;
    }

    static void callback_RestartAfterBuildsHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, "Restart Lua VM After Builds");
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        buff->text(
            "Obsidian has migrated from Lua to LuaJIT. One side effect of this is that even with a fixed seed, \
subsequent runs with the same configuration will not guarantee the same result.\n\nRestarting the Lua VM between \
builds will improve the odds of being able to repeat the results of a prior seed/setting combination, with the downside \
of visibly restarting the program every time a map is generated (even unsuccessfully).\n\nIf you have no particular need \
to recreate the results of prior runs, this option can be safely left off.");
    }

    static void callback_TimestampLogs(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        timestamp_logs = that->opt_timestamp_logs->value() ? true : false;
    }

    static void callback_LogLimit(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        log_limit = that->opt_log_limit->value();
    }

    static void callback_ZipLogs(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        zip_logs = that->opt_zip_logs->value() ? true : false;
    }

    static void callback_ZipOutput(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        zip_output = that->opt_zip_output->value();
    }

    static void callback_Random_String_Seeds(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        random_string_seeds =
            that->opt_random_string_seeds->value() ? true : false;

        if (!random_string_seeds) {
            that->opt_password_mode->deactivate();
        } else {
            that->opt_password_mode->activate();
        }
    }

    static void callback_RandomStringSeedsHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, "Random String Seeds");
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        buff->text(
            "Will randomly pull 1 to 3 words from Obsidian's random word list (found in \
/scripts/random_words.lua) and use those as input for the map generation seed. Purely for \
cosmetic/entertainment value.");
    }

    static void callback_Password_Mode(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        password_mode = that->opt_password_mode->value() ? true : false;
    }

    static void callback_PasswordModeHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, "Password Mode");
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
        disp->buffer(buff);
        disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
        win->resizable(*disp);
        win->hotspot(0, 0, 0);
        win->set_modal();
        win->show();
        buff->text(
            "Will produce a pseudo-random sequence of characters as input for the map \
generation seed. Random String Seeds must be enabled to use this option.");
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

    static void callback_LimitBreak(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;
        if (that->opt_limit_break->value()) {
            if (fl_choice(
                    "WARNING! This option will allow you to manually enter values in excess of the \n(usually) stable \
slider limits for Obsidian.\nAny bugs, crashes, or errors as a result of this will not be addressed by the developers.\
\nYou must select Yes for this option to be applied.",
                    "Cancel", "Yes, break Obsidian", 0)) {
                limit_break = true;
            } else {
                limit_break = false;
                that->opt_limit_break->value(0);
            }
        } else {
            limit_break = false;
            fl_alert(
                "%s",
                _("Restoring slider limits requires a restart.\nObsidian will "
                  "now restart."));

            main_action = MAIN_RESTART;

            that->want_quit = true;
        }
    }

    static void callback_PreserveFailures(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        preserve_failures = that->opt_preserve_failures->value() ? true : false;
    }

    static void callback_PrefixHelp(Fl_Widget *w, void *data) {
        fl_cursor(FL_CURSOR_DEFAULT);
        Fl_Window *win = new Fl_Window(640, 480, "Custom Prefix");
        Fl_Text_Buffer *buff = new Fl_Text_Buffer();
        Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
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
%engine or %e: Which engine the WAD is for.\n\n\
%theme or %t: Which theme was selected from the game's choices.\n\n\
%count or %c: The number of levels in the generated WAD.");
    }

    static void callback_SetCustomPrefix(Fl_Widget *w, void *data) {
    tryagain:
        const char *user_buf = fl_input("%s", custom_prefix.c_str(),
                                        _("Enter Custom Prefix Format:"));

        if (user_buf) {
            custom_prefix = user_buf;
            if (custom_prefix.empty()) {
                fl_alert("%s", _("Custom prefix cannot be blank!"));
                goto tryagain;
            }
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

    opt_language =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), "");
    opt_language->copy_label(_("Language: "));
    opt_language->align(FL_ALIGN_LEFT);
    opt_language->callback(callback_Language, this);
    opt_language->labelfont(font_style);
    opt_language->textcolor(FONT2_COLOR);
    opt_language->textfont(font_style);
    opt_language->selection_color(SELECTION);

    PopulateLanguages();

    cy += opt_language->h() + y_step;

    opt_zip_output =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), "");
    opt_zip_output->copy_label(_("Compress Output: "));
    opt_zip_output->align(FL_ALIGN_LEFT);
    opt_zip_output->callback(callback_ZipOutput, this);
    opt_zip_output->add(_("OFF|ZIP|PK3"));
    opt_zip_output->labelfont(font_style);
    opt_zip_output->textfont(font_style);
    opt_zip_output->textcolor(FONT2_COLOR);
    opt_zip_output->selection_color(SELECTION);
    opt_zip_output->value(zip_output);

    cy += opt_zip_output->h() + y_step;

    opt_filename_prefix =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), "");
    opt_filename_prefix->copy_label(_("Filename Prefix: "));
    opt_filename_prefix->align(FL_ALIGN_LEFT);
    opt_filename_prefix->callback(callback_FilenamePrefix, this);
    opt_filename_prefix->add(
        _("Date and Time|Number of Levels|Game|Engine|Theme|Version|Custom|Nothing"));
    opt_filename_prefix->labelfont(font_style);
    opt_filename_prefix->textfont(font_style);
    opt_filename_prefix->textcolor(FONT2_COLOR);
    opt_filename_prefix->selection_color(SELECTION);
    opt_filename_prefix->value(filename_prefix);

    cy += opt_filename_prefix->h() + y_step;

    opt_custom_prefix = new Fl_Button(136 + KF * 40, cy, kf_w(130), kf_h(24),
                                      _("Set Custom Prefix..."));
    opt_custom_prefix->box(button_style);
    opt_custom_prefix->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    opt_custom_prefix->visible_focus(0);
    opt_custom_prefix->color(BUTTON_COLOR);
    opt_custom_prefix->callback(callback_SetCustomPrefix, this);
    opt_custom_prefix->labelfont(font_style);
    opt_custom_prefix->labelcolor(FONT2_COLOR);

    custom_prefix_help = new UI_HelpLink(
        136 + KF * 40 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    custom_prefix_help->labelfont(font_style);
    custom_prefix_help->callback(callback_PrefixHelp, this);

    cy += opt_custom_prefix->h() + y_step * 2;

    opt_random_string_seeds =
        new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_random_string_seeds->copy_label(_(" Random String Seeds"));
    opt_random_string_seeds->value(random_string_seeds ? 1 : 0);
    opt_random_string_seeds->callback(callback_Random_String_Seeds, this);
    opt_random_string_seeds->labelfont(font_style);
    opt_random_string_seeds->selection_color(SELECTION);
    opt_random_string_seeds->down_box(button_style);

    random_string_seeds_help = new UI_HelpLink(
        136 + KF * 40 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    random_string_seeds_help->labelfont(font_style);
    random_string_seeds_help->callback(callback_RandomStringSeedsHelp, this);

    cy += opt_random_string_seeds->h() + y_step * .5;

    opt_password_mode =
        new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_password_mode->copy_label(_(" Password Mode"));
    opt_password_mode->value(password_mode ? 1 : 0);
    opt_password_mode->callback(callback_Password_Mode, this);
    opt_password_mode->labelfont(font_style);
    opt_password_mode->selection_color(SELECTION);
    opt_password_mode->down_box(button_style);
    if (!random_string_seeds) {
        opt_password_mode->deactivate();
    }

    password_mode_help = new UI_HelpLink(
        136 + KF * 40 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    password_mode_help->labelfont(font_style);
    password_mode_help->callback(callback_PasswordModeHelp, this);

    cy += opt_password_mode->h() + y_step * .5;

    opt_backups = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_backups->copy_label(_(" Create Backups"));
    opt_backups->value(create_backups ? 1 : 0);
    opt_backups->callback(callback_Backups, this);
    opt_backups->labelfont(font_style);
    opt_backups->selection_color(SELECTION);
    opt_backups->down_box(button_style);

    cy += opt_backups->h() + y_step * .5;

    opt_overwrite = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_overwrite->copy_label(_(" Overwrite File Warning"));
    opt_overwrite->value(overwrite_warning ? 1 : 0);
    opt_overwrite->callback(callback_Overwrite, this);
    opt_overwrite->labelfont(font_style);
    opt_overwrite->selection_color(SELECTION);
    opt_overwrite->down_box(button_style);

    cy += opt_overwrite->h() + y_step * .5;

    opt_debug = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_debug->copy_label(_(" Debugging Messages"));
    opt_debug->value(debug_messages ? 1 : 0);
    opt_debug->callback(callback_Debug, this);
    opt_debug->labelfont(font_style);
    opt_debug->selection_color(SELECTION);
    opt_debug->down_box(button_style);

    cy += opt_debug->h() + y_step * .5;

    opt_limit_break = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_limit_break->copy_label(_(" Ignore Slider Limits"));
    opt_limit_break->value(limit_break ? 1 : 0);
    opt_limit_break->callback(callback_LimitBreak, this);
    opt_limit_break->labelfont(font_style);
    opt_limit_break->selection_color(SELECTION);
    opt_limit_break->down_box(button_style);

    cy += opt_limit_break->h() + y_step * .5;

    opt_preserve_failures =
        new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_preserve_failures->copy_label(_(" Preserve Failed Builds"));
    opt_preserve_failures->value(preserve_failures ? 1 : 0);
    opt_preserve_failures->callback(callback_PreserveFailures, this);
    opt_preserve_failures->labelfont(font_style);
    opt_preserve_failures->selection_color(SELECTION);
    opt_preserve_failures->down_box(button_style);

    cy += opt_preserve_failures->h() + y_step * .5;

    opt_zip_logs = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_zip_logs->copy_label(_(" Zip Logs When Saving"));
    opt_zip_logs->value(zip_logs ? 1 : 0);
    opt_zip_logs->callback(callback_ZipLogs, this);
    opt_zip_logs->labelfont(font_style);
    opt_zip_logs->selection_color(SELECTION);
    opt_zip_logs->down_box(button_style);

    cy += opt_zip_logs->h() + y_step * .5;

    opt_timestamp_logs =
        new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_timestamp_logs->copy_label(_(" Preserve/Timestamp Previous Logs"));
    opt_timestamp_logs->value(timestamp_logs ? 1 : 0);
    opt_timestamp_logs->callback(callback_TimestampLogs, this);
    opt_timestamp_logs->labelfont(font_style);
    opt_timestamp_logs->selection_color(SELECTION);
    opt_timestamp_logs->down_box(button_style);

    cy += opt_timestamp_logs->h() + y_step * .5;

    opt_log_limit =
        new Fl_Simple_Counter(136 + KF * 40, cy, kf_w(130), kf_h(24), "");
    opt_log_limit->copy_label(_("# of Logs Preserved "));
    opt_log_limit->align(FL_ALIGN_LEFT);
    opt_log_limit->step(1);
    opt_log_limit->bounds(2, 25);
    opt_log_limit->callback(callback_LogLimit, this);
    opt_log_limit->value(log_limit);
    opt_log_limit->labelfont(font_style);
    opt_log_limit->textfont(font_style);
    opt_log_limit->textcolor(FONT2_COLOR);
    opt_log_limit->selection_color(SELECTION);
    opt_log_limit->visible_focus(0);
    opt_log_limit->color(BUTTON_COLOR);

    cy += opt_log_limit->h() + y_step * .5;

    opt_restart_after_builds =
        new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24), "");
    opt_restart_after_builds->copy_label(_(" Restart Lua VM Between Builds"));
    opt_restart_after_builds->value(restart_after_builds ? 1 : 0);
    opt_restart_after_builds->callback(callback_RestartAfterBuilds, this);
    opt_restart_after_builds->labelfont(font_style);
    opt_restart_after_builds->selection_color(SELECTION);
    opt_restart_after_builds->down_box(button_style);

    restart_after_builds_help = new UI_HelpLink(
        136 + KF * 40 + this->opt_custom_prefix->w(), cy, W * 0.10, kf_h(24));
    restart_after_builds_help->labelfont(font_style);
    restart_after_builds_help->callback(callback_RestartAfterBuildsHelp, this);

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
    int opt_h = kf_h(525);

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
