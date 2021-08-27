//------------------------------------------------------------------------
//  Main program
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#include "main.h"
#include "fmt/core.h"
#include "images.h"

#include "csg_main.h"
#include "g_nukem.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "physfs.h"
#include "sys_twister.h"
#include "ui_window.h"

/**
 * \brief Ticker time in milliseconds
 */
constexpr size_t TICKER_TIME = 50;

std::filesystem::path home_dir;
std::filesystem::path install_dir;

std::filesystem::path config_file;
std::filesystem::path options_file;
std::filesystem::path theme_file;
std::filesystem::path logging_file;

int screen_w;
int screen_h;

int main_action;

unsigned long long next_rand_seed;

bool batch_mode = false;
std::filesystem::path batch_output_file;
std::string numeric_locale;

// options
uchar text_red = 225;
uchar text_green = 225;
uchar text_blue = 225;
uchar text2_red = 225;
uchar text2_green = 225;
uchar text2_blue = 225;
uchar bg_red = 56;
uchar bg_green = 56;
uchar bg_blue = 56;
uchar bg2_red = 83;
uchar bg2_green = 121;
uchar bg2_blue = 180;
uchar button_red = 89;
uchar button_green = 89;
uchar button_blue = 89;
uchar gradient_red = 221;
uchar gradient_green = 221;
uchar gradient_blue = 221;
uchar border_red = 62;
uchar border_green = 61;
uchar border_blue = 57;
uchar gap_red = 35;
uchar gap_green = 35;
uchar gap_blue = 35;
Fl_Color FONT_COLOR;
Fl_Color FONT2_COLOR;
Fl_Color SELECTION;
Fl_Color WINDOW_BG;
Fl_Color GAP_COLOR;
Fl_Color GRADIENT_COLOR;
Fl_Color BUTTON_COLOR;
Fl_Color BORDER_COLOR;
int color_scheme = 0;
int font_theme = 0;
Fl_Font font_style = 0;
int box_theme = 0;
Fl_Boxtype box_style = FL_FLAT_BOX;
int button_theme = 0;
Fl_Boxtype button_style = FL_DOWN_BOX;
int widget_theme = 0;
bool single_pane = false;
bool use_system_fonts = false;
int window_scaling = 0;
int font_scaling = 18;
int filename_prefix = 0;
std::string custom_prefix = "CUSTOM_";
int num_fonts = 0;
std::vector<std::map<std::string, int>> font_menu_items;

bool create_backups = true;
bool overwrite_warning = true;
bool debug_messages = false;
bool limit_break = false;

game_interface_c *game_object = NULL;

/* ----- user information ----------------------------- */

static void ShowInfo() {
    fmt::print(
        "\n"
        "** {} {}"
        " **\n"
        "** Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted **\n"
        "\n",
        OBSIDIAN_TITLE, OBSIDIAN_VERSION);

    fmt::print(
        "Usage: Obsidian [options...] [key=value...]\n"
        "\n"
        "Available options:\n"
        "     --home     <dir>      Home directory\n"
        "     --install  <dir>      Installation directory\n"
        "\n"
        "     --config   <file>     Config file for GUI\n"
        "     --options  <file>     Options file for GUI\n"
        "     --log      <file>     Log file to create\n"
        "\n"
        "  -b --batch    <output>   Batch mode (no GUI)\n"
        "  -a --addon    <file>...  Addon(s) to use\n"
        "  -l --load     <file>     Load settings from a file\n"
        "  -k --keep                Keep SEED from loaded settings\n"
        "\n"
        "  -d --debug               Enable debugging\n"
        "  -v --verbose             Print log messages to stdout\n"
        "  -h --help                Show this help message\n"
        "\n");

    fmt::print(
        "Please visit the web site for complete information:\n"
        "  {} \n"
        "\n",
        OBSIDIAN_WEBSITE);

    fmt::print(
        "This program is free software, under the terms of the GNU General "
        "Public\n"
        "License, and comes with ABSOLUTELY NO WARRANTY.  See the "
        "documentation\n"
        "for more details, or visit http://www.gnu.org/licenses/gpl-2.0.txt\n"
        "\n");

    fflush(stdout);
}

static void ShowVersion() {
    fmt::print("Obsidian version {} (" __DATE__ ")\n", OBSIDIAN_VERSION);

    fflush(stdout);
}

void Determine_WorkingPath(const char *argv0) {
    // firstly find the "Working directory" : that's the place where
    // the CONFIG.txt and LOGS.txt files are, as well the temp files.

    if (const int home_arg = argv::Find(0, "home"); home_arg >= 0) {
        if (home_arg + 1 >= argv::list.size() || argv::IsOption(home_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --home\n");
            exit(9);
        }

        home_dir = argv::list[home_arg + 1];
        return;
    }

#ifdef WIN32
    home_dir = std::filesystem::current_path();

#else
    home_dir = std::getenv("HOME");
    home_dir /= ".config/obsidian";

    if (!home_dir.is_absolute()) {
        Main::FatalError("Unable to find $HOME directory!\n");
    }

    // try to create it (doesn't matter if it already exists)
    if (!std::filesystem::exists(home_dir)) {
        std::filesystem::create_directory(home_dir);
    }
#endif
    if (home_dir.empty()) {
        home_dir = ".";
    }
}

static bool Verify_InstallDir(const std::filesystem::path &path) {
    const std::filesystem::path filename = path / "scripts" / "oblige.lua";

#if 0  // DEBUG
	fprintf(stderr, "Trying install dir: [%s]\n", path);
	fprintf(stderr, "  using file: [%s]\n\n", filename);
#endif

    return exists(filename);
}

void Determine_InstallDir(const char *argv0) {
    // secondly find the "Install directory", and store the
    // result in the global variable 'install_dir'.  This is
    // where all the LUA scripts and other data files are.

    if (const int inst_arg = argv::Find(0, "install"); inst_arg >= 0) {
        if (inst_arg + 1 >= argv::list.size() || argv::IsOption(inst_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --install\n");
            exit(9);
        }

        install_dir = argv::list[inst_arg + 1];

        if (Verify_InstallDir(install_dir)) {
            return;
        }

        Main::FatalError("Bad install directory specified!\n");
    }

    // if run from current directory, look there
    if (argv0[0] == '.' && Verify_InstallDir(".")) {
        install_dir = ".";
        return;
    }

#ifdef WIN32
    install_dir = home_dir;

#else
    constexpr std::array prefixes = {
        "/usr/local",
        "/usr",
        "/opt",
    };

    for (const char *prefix : prefixes) {
        install_dir = fmt::format("{}/share/obsidian", prefix);

        if (Verify_InstallDir(install_dir.c_str())) {
            return;
        }

        install_dir.clear();
    }

    if (Verify_InstallDir(std::filesystem::current_path().c_str())) {
        install_dir = std::filesystem::current_path();
    }
#endif

    if (install_dir.empty()) {
        Main::FatalError("Unable to find Obsidian's install directory!\n");
    }
}

void Determine_ConfigFile() {
    if (const int conf_arg = argv::Find(0, "config"); conf_arg >= 0) {
        if (conf_arg + 1 >= argv::list.size() || argv::IsOption(conf_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --config\n");
            exit(9);
        }

        config_file = argv::list[conf_arg + 1];
    } else {
        config_file /= home_dir;
        config_file /= CONFIG_FILENAME;
    }
}

void Determine_OptionsFile() {
    if (const int optf_arg = argv::Find(0, "options"); optf_arg >= 0) {
        if (optf_arg + 1 >= argv::list.size() || argv::IsOption(optf_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --options\n");
            exit(9);
        }

        options_file = argv::list[optf_arg + 1];
    } else {
        options_file /= home_dir;
        options_file /= OPTIONS_FILENAME;
    }
}

void Determine_ThemeFile() {
    if (const int themef_arg = argv::Find(0, "theme"); themef_arg >= 0) {
        if (themef_arg + 1 >= argv::list.size() ||
            argv::IsOption(themef_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --theme\n");
            exit(9);
        }

        theme_file = argv::list[themef_arg + 1];
    } else {
        theme_file /= home_dir;
        theme_file /= THEME_FILENAME;
    }
}

void Determine_LoggingFile() {
    if (const int logf_arg = argv::Find(0, "log"); logf_arg >= 0) {
        if (logf_arg + 1 >= argv::list.size() || argv::IsOption(logf_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --log\n");
            exit(9);
        }

        logging_file = argv::list[logf_arg + 1];

        // test that it can be created
        std::ofstream fp{logging_file};

        if (!fp.is_open()) {
            Main::FatalError("Cannot create log file: {}\n", logging_file.string());
        }

        fp.close();
    } else if (!batch_mode) {
        logging_file /= home_dir;
        logging_file /= LOG_FILENAME;
    } else {
        logging_file.clear();
    }
}

bool Main::BackupFile(const std::filesystem::path &filename,
                      const std::filesystem::path &ext) {
    if (std::filesystem::exists(filename)) {
        std::filesystem::path backup_name = filename;
        backup_name.replace_extension(ext);

        LogPrintf("Backing up existing file to: {}\n", backup_name);

        std::filesystem::remove(backup_name);
        std::filesystem::rename(filename, backup_name);
    }

    return true;
}

namespace Main {
static int DetermineScaling() {
    /* computation of the Kromulent factor */

    // command-line overrides
    if (argv::Find(0, "tiny") >= 0) {
        return -1;
    }
    if (argv::Find(0, "small") >= 0) {
        return 0;
    }
    if (argv::Find(0, "medium") >= 0) {
        return 1;
    }
    if (argv::Find(0, "large") >= 0) {
        return 2;
    }
    if (argv::Find(0, "huge") >= 0) {
        return 3;
    }

    // user option setting
    if (window_scaling > 0) {
        return window_scaling - 2;
    }

    // automatic selection
    if (screen_w >= 1600 && screen_h >= 800) {
        return 2;
    }
    if (screen_w >= 1200 && screen_h >= 672) {
        return 1;
    }
    if (screen_w <= 640 && screen_h <= 480) {
        return -1;
    }

    return 0;
}
}  // namespace Main

bool Main::LoadInternalFont(const char *fontpath, const int fontnum,
                            const char *fontname) {

    /* set the extra font */
    if (i_load_private_font(fontpath)) {
        Fl::set_font(fontnum, fontname);
        return true;
    }

    return false;
}

void Main::PopulateFontMap() {
    if (use_system_fonts) {
        font_menu_items.push_back(
            std::map<std::string, int>{{"Sans <Default>", 0}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Courier <Internal>", 4}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Times <Internal>", 8}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Screen <Internal>", 13}});

        num_fonts = Fl::set_fonts(NULL);

        for (int x = 16; x < num_fonts;
             x++) {  // Starting at 16 skips the FLTK default enumerations
            if (std::string fontname = Fl::get_font_name(x);
                std::isalpha(fontname.at(0))) {
                std::map<std::string, int> temp_map{{fontname, x}};
                font_menu_items.push_back(temp_map);
            }
        }

    } else {
        // TODO - If feasible, find a better way to automate this/crawl for
        // *.ttf files

        // Load bundled fonts. Fonts without a bold variant are essentially
        // loaded twice in a row so that calls for a bold variant don't
        // accidentally change fonts

        // Some custom fonts will have a different display name than that of
        // their TTF fontname. This is because these fonts have been modified in
        // some fashion, and the OFL 1.1 license dictates that modified
        // versions cannot display their Reserved Name to users

        int current_free_font = 16;

        if (LoadInternalFont(
                "./theme/fonts/SourceSansPro/SourceSansPro-Regular.ttf",
                current_free_font, "Source Sans Pro")) {
            if (LoadInternalFont(
                    "./theme/fonts/SourceSansPro/SourceSansPro-Bold.ttf",
                    current_free_font + 1, "Source Sans Pro Bold")) {
                font_menu_items.push_back(std::map<std::string, int>{
                    {"Sauce <Default>", current_free_font}});
            }
            current_free_font += 2;
        }

        font_menu_items.push_back(
            std::map<std::string, int>{{"Sans <Internal>", 0}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Courier <Internal>", 4}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Times <Internal>", 8}});
        font_menu_items.push_back(
            std::map<std::string, int>{{"Screen <Internal>", 13}});

        if (LoadInternalFont("./theme/fonts/Avenixel/Avenixel-Regular.ttf",
                             current_free_font, "Avenixel")) {
            Fl::set_font(current_free_font + 1, "Avenixel");
            font_menu_items.push_back(
                std::map<std::string, int>{{"Avenixel", current_free_font}});
            current_free_font += 2;
        }

        if (LoadInternalFont("./theme/fonts/TheNeueBlack/TheNeue-Black.ttf",
                             current_free_font, "The Neue")) {
            Fl::set_font(current_free_font + 1, "The Neue");
            font_menu_items.push_back(
                std::map<std::string, int>{{"New Black", current_free_font}});
            current_free_font += 2;
        }

        if (LoadInternalFont("./theme/fonts/Teko/Teko-Regular.ttf",
                             current_free_font, "Teko")) {
            if (LoadInternalFont("./theme/fonts/Teko/Teko-Bold.ttf",
                                 current_free_font + 1, "Teko Bold")) {
                font_menu_items.push_back(
                    std::map<std::string, int>{{"Teko", current_free_font}});
            }
            current_free_font += 2;
        }

        if (LoadInternalFont("./theme/fonts/Kalam/Kalam-Regular.ttf",
                             current_free_font, "Kalam")) {
            if (LoadInternalFont("./theme/fonts/Kalam/Kalam-Bold.ttf",
                                 current_free_font + 1, "Kalam Bold")) {
                font_menu_items.push_back(
                    std::map<std::string, int>{{"Kalam", current_free_font}});
            }
        }
    }

    // lossy conversion, size_t?
    num_fonts = static_cast<int>(font_menu_items.size());
}

namespace Main {
void SetupFltk() {
    PopulateFontMap();

    Fl::visual(FL_DOUBLE | FL_RGB);
    if (color_scheme ==
        2) {  // "Custom" color selection used to be 2 in older configs
        color_scheme = 1;
    }
    switch (color_scheme) {
        case 0:
            Fl::background(56, 56, 56);
            Fl::background2(56, 56, 56);
            Fl::foreground(225, 225, 225);
            FONT_COLOR = fl_rgb_color(225, 225, 225);
            FONT2_COLOR = fl_rgb_color(225, 225, 225);
            SELECTION = fl_rgb_color(83, 121, 180);
            WINDOW_BG = fl_rgb_color(56, 56, 56);
            GAP_COLOR = fl_rgb_color(35, 35, 35);
            BORDER_COLOR = fl_rgb_color(62, 61, 57);
            GRADIENT_COLOR = fl_rgb_color(221, 221, 221);
            BUTTON_COLOR = fl_rgb_color(89, 89, 89);
            break;
        case 1:
            Fl::background(bg_red, bg_green, bg_blue);
            Fl::background2(bg_red, bg_green, bg_blue);
            Fl::foreground(text_red, text_green, text_blue);
            FONT_COLOR = fl_rgb_color(text_red, text_green, text_blue);
            FONT2_COLOR = fl_rgb_color(text2_red, text2_green, text2_blue);
            SELECTION = fl_rgb_color(bg2_red, bg2_green, bg2_blue);
            WINDOW_BG = fl_rgb_color(bg_red, bg_green, bg_blue);
            GAP_COLOR = fl_rgb_color(gap_red, gap_green, gap_blue);
            BORDER_COLOR = fl_rgb_color(border_red, border_green, border_blue);
            GRADIENT_COLOR =
                fl_rgb_color(gradient_red, gradient_green, gradient_blue);
            BUTTON_COLOR = fl_rgb_color(button_red, button_green, button_blue);
            break;
        // Shouldn't be reached, but still
        default:
            Fl::background(56, 56, 56);
            Fl::background2(56, 56, 56);
            Fl::foreground(225, 225, 225);
            FONT_COLOR = fl_rgb_color(225, 225, 225);
            FONT2_COLOR = fl_rgb_color(225, 225, 225);
            SELECTION = fl_rgb_color(83, 121, 180);
            WINDOW_BG = fl_rgb_color(56, 56, 56);
            GAP_COLOR = fl_rgb_color(35, 35, 35);
            BORDER_COLOR = fl_rgb_color(62, 61, 57);
            GRADIENT_COLOR = fl_rgb_color(221, 221, 221);
            BUTTON_COLOR = fl_rgb_color(89, 89, 89);
            break;
    }
    if (color_scheme == 1) {
        Fl::get_color(FONT_COLOR, text_red, text_green, text_blue);
        Fl::get_color(FONT2_COLOR, text2_red, text2_green, text2_blue);
        Fl::get_color(WINDOW_BG, bg_red, bg_green, bg_blue);
        Fl::get_color(SELECTION, bg2_red, bg2_green, bg2_blue);
        Fl::get_color(GAP_COLOR, gap_red, gap_green, gap_blue);
        Fl::get_color(BORDER_COLOR, border_red, border_green, border_blue);
        Fl::get_color(GRADIENT_COLOR, gradient_red, gradient_green,
                      gradient_blue);
        Fl::get_color(BUTTON_COLOR, button_red, button_green, button_blue);
    }
    Fl::set_boxtype(FL_GLEAM_UP_BOX, cgleam_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_GLEAM_THIN_UP_BOX, cgleam_thin_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_GLEAM_DOWN_BOX, cgleam_down_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_GTK_UP_BOX, cgtk_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_GTK_THIN_UP_BOX, cgtk_thin_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_GTK_DOWN_BOX, cgtk_down_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_PLASTIC_UP_BOX, cplastic_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_PLASTIC_THIN_UP_BOX, cplastic_thin_up_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_PLASTIC_DOWN_BOX, cplastic_down_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_SHADOW_BOX, cshadow_box, 1, 1, 5, 5);
    Fl::set_boxtype(FL_FREE_BOXTYPE, crectbound, 1, 1, 2, 2);
    Fl::set_boxtype(static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 1), crectbound, 1,
                    1, 2, 2);
    Fl::set_boxtype(FL_THIN_UP_BOX, cthin_up_box, 1, 1, 2, 2);
    Fl::set_boxtype(FL_EMBOSSED_BOX, cembossed_box, 2, 2, 4, 4);
    Fl::set_boxtype(static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 2), cengraved_box,
                    2, 2, 4, 4);
    Fl::set_boxtype(static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 3), cengraved_box,
                    2, 2, 4, 4);
    Fl::set_boxtype(FL_DOWN_BOX, cdown_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_UP_BOX, cup_box, 2, 2, 4, 4);
    switch (widget_theme) {
        case 0:
            Fl::scheme("gtk+");
            break;
        case 1:
            Fl::scheme("gleam");
            break;
        case 2:
            Fl::scheme("base");
            break;
        case 3:
            Fl::scheme("plastic");
            break;
        // Shouldn't be reached, but still
        default:
            Fl::scheme("gtk+");
            break;
    }
    switch (box_theme) {
        case 0:
            box_style = FL_FLAT_BOX;
            break;
        case 1:
            box_style = FL_SHADOW_BOX;
            break;
        case 2:
            box_style = FL_EMBOSSED_BOX;
            break;
        case 3:
            box_style = FL_ENGRAVED_BOX;
            break;
        case 4:
            box_style = FL_DOWN_BOX;
            break;
        case 5:
            box_style = FL_THIN_UP_BOX;
            break;
        // Shouldn't be reached, but still
        default:
            box_style = FL_FLAT_BOX;
            break;
    }
    switch (button_theme) {
        case 0:
            button_style = FL_DOWN_BOX;
            break;
        case 1:
            button_style = FL_UP_BOX;
            break;
        case 2:
            button_style = static_cast<Fl_Boxtype>(FL_FREE_BOXTYPE + 2);
            break;
        case 3:
            button_style = FL_EMBOSSED_BOX;
            break;
        case 4:
            button_style = FL_FREE_BOXTYPE;
            break;
        // Shouldn't be reached, but still
        default:
            button_style = FL_DOWN_BOX;
            break;
    }
    if (font_theme < num_fonts) {  // In case the number of installed fonts is
                                   // reduced between launches
        for (const auto &[_fst, snd] : font_menu_items[font_theme]) {
            font_style = snd;
        }
    } else {
        // Fallback
        font_style = 0;
    }
    if (font_scaling < 6) {  // Values from old configs
        font_scaling = 18;
    }
    FL_NORMAL_SIZE = font_scaling;
    small_font_size = FL_NORMAL_SIZE - 2;
    header_font_size = FL_NORMAL_SIZE + 2;
    fl_message_font(font_style, FL_NORMAL_SIZE + 2);

    screen_w = Fl::w();
    screen_h = Fl::h();

#if 0  // debug
	fmt::print(stderr, "Screen dimensions = {}x{}\n", screen_w, screen_h);
#endif

    KF = DetermineScaling();
    // load icons for file chooser
#ifndef WIN32
    Fl_File_Icon::load_system_icons();
#endif

    // translate some FLTK strings
    fl_no = _("No");
    fl_yes = _("Yes");
    fl_ok = _("OK");
    fl_cancel = _("Cancel");
    fl_close = _("Close");
}
}  // namespace Main

void Main::Ticker() {
    // This function is called very frequently.
    // To prevent a slow-down, we only call Fl::check()
    // after a certain time has elapsed.

    static u32_t last_millis = 0;

    if (const u32_t cur_millis = TimeGetMillies();
        (cur_millis - last_millis) >= TICKER_TIME) {
        Fl::check();

        last_millis = cur_millis;
    }
}

void Main::Detail::Shutdown(const bool error) {
    if (main_win) {
        // on fatal error we cannot risk calling into the Lua runtime
        // (it's state may be compromised by a script error).
        if (!config_file.empty() && !error) {
            Cookie_Save(config_file);
        }

        delete main_win;
        main_win = nullptr;
    }

    Script_Close();
    LogClose();
}

int Main_key_handler(int event) {
    if (event != FL_SHORTCUT) {
        return 0;
    }

    switch (Fl::event_key()) {
        case FL_Escape:
            // if building is in progress, cancel it, otherwise quit
            if (game_object && !Fl::modal()) {
                main_action = MAIN_CANCEL;
                return 1;
            } else {
                // let FLTK's default code kick in
                // [we cannot mimic it because we lack the 'window' ref]
                return 0;
            }

        default:
            break;
    }

    return 0;
}

void Main_CalcNewSeed() { next_rand_seed = twister_UInt(); }

void Main_SetSeed() {
    std::string seed = NumToString(next_rand_seed);
    ob_set_config("seed", seed.c_str());
    if (!batch_mode) {
        main_win->build_box->seed_disp->copy_label(
            fmt::format("Seed: {}", seed).c_str());
        main_win->build_box->seed_disp->redraw();
    }
}

static void Module_Defaults() {
    ob_set_mod_option("sky_generator", "self", "1");
    ob_set_mod_option("music_swapper", "self", "1");
}

//------------------------------------------------------------------------

bool Build_Cool_Shit() {
    // clear the map
    if (main_win) {
        main_win->build_box->mini_map->EmptyMap();
    }

    const std::string format = ob_game_format();

    if (format.empty()) {
        Main::FatalError("ERROR: missing 'format' for game?!?\n");
    }

    // create game object
    {
        if (StringCaseCmp(format, "doom") == 0) {
            game_object = Doom_GameObject();

        } else if (StringCaseCmp(format, "nukem") == 0) {
            game_object = Nukem_GameObject();

            /// else if (StringCaseCmp(format, "wolf3d") == 0)
            ///   game_object = Wolf_GameObject();

        } else if (StringCaseCmp(format, "quake") == 0) {
            game_object = Quake1_GameObject();

        } else if (StringCaseCmp(format, "quake2") == 0) {
            game_object = Quake2_GameObject();

        } else if (StringCaseCmp(format, "quake3") == 0) {
            game_object = Quake3_GameObject();

        } else {
            Main::FatalError("ERROR: unknown format: '{}'\n", format);
        }
    }

    const std::string def_filename = ob_default_filename();

    // lock most widgets of user interface
    if (main_win) {
        std::string seed = NumToString(next_rand_seed);
        if (!main_win->build_box->string_seed.empty()) {
            main_win->build_box->seed_disp->copy_label(
                fmt::format("Seed: {}", main_win->build_box->string_seed)
                    .c_str());
            main_win->build_box->seed_disp->redraw();
        } else {
            main_win->build_box->seed_disp->copy_label(
                fmt::format("Seed: {}", seed).c_str());
            main_win->build_box->seed_disp->redraw();
        }
        main_win->game_box->SetAbortButton(true);
        main_win->build_box->SetStatus(_("Preparing..."));
        main_win->Locked(true);
    }

    const u32_t start_time = TimeGetMillies();
    // this will ask for output filename (among other things)
    bool was_ok = game_object->Start(def_filename.c_str());

    // coerce FLTK to redraw the main window
    for (int r_loop = 0; r_loop < 6; r_loop++) {
        Fl::wait(0.06);
    }

    if (was_ok) {
        // run the scripts Scotty!
        was_ok = ob_build_cool_shit();

        was_ok = game_object->Finish(was_ok);
    }
    if (was_ok) {
        Main::ProgStatus(_("Success"));

        const u32_t end_time = TimeGetMillies();
        const u32_t total_time = end_time - start_time;

        LogPrintf("\nTOTAL TIME: {}.2f seconds\n\n", total_time / 1000.0);

        if (main_win) {
            main_win->build_box->string_seed = "";
        }
    } else {
        if (main_win) {
            main_win->build_box->seed_disp->copy_label("Seed: -");
            main_win->build_box->seed_disp->redraw();
            main_win->build_box->name_disp->copy_label("");
            main_win->build_box->name_disp->redraw();
            main_win->build_box->string_seed = "";
        }
    }

    if (main_win) {
        main_win->build_box->Prog_Finish();
        main_win->game_box->SetAbortButton(false);
        main_win->Locked(false);
    }

    if (main_action == MAIN_CANCEL) {
        main_action = 0;

        Main::ProgStatus(_("Cancelled"));
    }

    // don't need game object anymore
    delete game_object;
    game_object = NULL;

    return was_ok;
}

/* ----- main program ----------------------------- */

int main(int argc, char **argv) {
    // initialise argument parser (skipping program name)
    argv::Init(argc - 1, argv + 1);

restart:;

    if (argv::Find('?', NULL) >= 0 || argv::Find('h', "help") >= 0) {
        ShowInfo();
        exit(1);
    } else if (argv::Find(0, "version") >= 0) {
        ShowVersion();
        exit(1);
    }

    int batch_arg = argv::Find('b', "batch");
    if (batch_arg >= 0) {
        if (batch_arg + 1 >= argv::list.size() ||
            argv::IsOption(batch_arg + 1)) {
            fmt::print(stderr,
                       "OBSIDIAN ERROR: missing filename for --batch\n");
            exit(9);
        }

        batch_mode = true;
        batch_output_file = argv::list[batch_arg + 1];
    }

    Determine_WorkingPath(argv[0]);
    Determine_InstallDir(argv[0]);

    Determine_ConfigFile();
    Determine_OptionsFile();
    Determine_ThemeFile();
    Determine_LoggingFile();

    LogInit(logging_file);

    if (argv::Find('d', "debug") >= 0) {
        debug_messages = true;
    }

    // accept -t and --terminal for backwards compatibility
    if (argv::Find('v', "verbose") >= 0 || argv::Find('t', "terminal") >= 0) {
        LogEnableTerminal(true);
    }

    LogPrintf("\n");
    LogPrintf("********************************************************\n");
    LogPrintf("** {} {} **\n", OBSIDIAN_TITLE, OBSIDIAN_VERSION);
    LogPrintf("********************************************************\n");
    LogPrintf("\n");

    LogPrintf("Library versions: FLTK {}.{}.{}\n\n", FL_MAJOR_VERSION,
              FL_MINOR_VERSION, FL_PATCH_VERSION);

    LogPrintf("home_dir: {}\n", home_dir.string());
    LogPrintf("install_dir: {}\n", install_dir.string());
    LogPrintf("config_file: {}\n\n", config_file.string());

    Trans_Init();

    if (!batch_mode) {
        Options_Load(options_file);
        Theme_Options_Load(theme_file);
        Trans_SetLanguage();
        Main::SetupFltk();
    }

#ifndef WIN32
    numeric_locale =
        std::setlocale(LC_NUMERIC, NULL);  // Grab current numeric locale
#endif

    LogEnableDebug(debug_messages);

    twister_Init();

    Main_CalcNewSeed();

    //	TX_TestSynth(next_rand_seed); - Fractal testing stuff

    VFS_InitAddons(argv[0]);

    std::string load_file;

    if (const int load_arg = argv::Find('l', "load"); load_arg >= 0) {
        if (load_arg + 1 >= argv::list.size() || argv::IsOption(load_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing filename for --load\n");
            exit(9);
        }

        load_file = argv::list[load_arg + 1];
    }

    if (batch_mode) {
        VFS_ParseCommandLine();

        Script_Open();

        // inform Lua code about batch mode (the value doesn't matter)
        ob_set_config("batch", "yes");

        Module_Defaults();

        // batch mode never reads/writes the normal config file.
        // but we can load settings from a explicitly specified file...
        if (!load_file.empty()) {
            if (!Cookie_Load(load_file)) {
                Main::FatalError(_("No such config file: {}\n"), load_file);
            }
        }

        Cookie_ParseArguments();

        Main_SetSeed();
        if (!Build_Cool_Shit()) {
            fmt::print(stderr, "FAILED!\n");
            LogPrintf("FAILED!\n");

            Main::Detail::Shutdown(false);
            return 3;
        }

        Main::Detail::Shutdown(false);
        return 0;
    }

    /* ---- normal GUI mode ---- */

    // this not only finds PK3 files, but also activates the ones specified in
    // OPTIONS.txt
    VFS_ScanForAddons();

    VFS_ParseCommandLine();

    // create the main window
    int main_w, main_h;
    UI_MainWin::CalcWindowSize(&main_w, &main_h);

    std::string main_title =
        fmt::format("{} {}", _(OBSIDIAN_TITLE), OBSIDIAN_VERSION);
    main_win = new UI_MainWin(main_w, main_h, main_title.c_str());

    //???	Default_Location();

    Script_Open();

    // enable certain modules by default
    Module_Defaults();

    // load config after creating window (will set widget values)
    if (!Cookie_Load(config_file)) {
        LogPrintf("Missing config file -- using defaults.\n\n");
    }

    if (!load_file.empty()) {
        if (!Cookie_Load(load_file)) {
            Main::FatalError(_("No such config file: {}\n"), load_file);
        }
    }

    Cookie_ParseArguments();

    // show window (pass some dummy arguments)
    {
        char *fake_argv[2];
        fake_argv[0] = strdup("Obsidian.exe");
        fake_argv[1] = NULL;
        main_win->show(1 /* argc */, fake_argv);
    }

    // kill the stupid bright background of the "plastic" scheme
    if (widget_theme == 3) {
        delete Fl::scheme_bg_;
        Fl::scheme_bg_ = NULL;

        main_win->image(NULL);
    }

    Fl::add_handler(Main_key_handler);

    switch (filename_prefix) {
        case 0:
            ob_set_config("filename_prefix", "datetime");
            break;
        case 1:
            ob_set_config("filename_prefix", "numlevels");
            break;
        case 2:
            ob_set_config("filename_prefix", "game");
            break;
        case 3:
            ob_set_config("filename_prefix", "theme");
            break;
        case 4:
            ob_set_config("filename_prefix", "version");
            break;
        case 5:
            ob_set_config("filename_prefix", "custom");
            break;
        case 6:
            ob_set_config("filename_prefix", "none");
            break;
        default:
            ob_set_config("filename_prefix", "datetime");
            break;
    }

    // draw an empty map (must be done after main window is
    // shown() because that is when FLTK finalises the colors).
    main_win->build_box->mini_map->EmptyMap();

    try {
        // run the GUI until the user quits
        for (;;) {
            Fl::wait(0.2);

            if (main_action == MAIN_QUIT || main_action == MAIN_RESTART) {
                break;
            }

            if (main_action == MAIN_BUILD) {
                main_action = 0;

                Main_SetSeed();

                // save config in case everything blows up
                Cookie_Save(config_file);

                Build_Cool_Shit();

                // regardless of success or fail, compute a new seed
                Main_CalcNewSeed();
            }
        }
    } catch (const assert_fail_c &err) {
        Main::FatalError(_("Sorry, an internal error occurred:\n{}"),
                         err.GetMessage());
    } catch (...) {
        Main::FatalError(_("An unknown problem occurred (UI code)"));
    }

    LogPrintf("\nQuit......\n\n");

    Theme_Options_Save(theme_file);
    Options_Save(options_file);

    if (main_action == MAIN_RESTART) {
        if (main_win) {
            // on fatal error we cannot risk calling into the Lua runtime
            // (it's state may be compromised by a script error).
            if (!config_file.empty()) {
                Cookie_Save(config_file);
            }
            delete main_win;
            main_win = nullptr;
        }
        Script_Close();
        LogClose();
        PHYSFS_deinit();
        main_action = MAIN_NONE;
        goto restart;
    }

    Main::Detail::Shutdown(false);

    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
