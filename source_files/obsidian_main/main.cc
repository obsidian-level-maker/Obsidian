//------------------------------------------------------------------------
//  Main program
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#include <array>
#include "main.h"
#include "fmt/core.h"
#include "images.h"

#include "csg_main.h"
#include "g_nukem.h"
#ifndef CONSOLE_ONLY
#include "hdr_fltk.h"
#include "hdr_ui.h"
#endif
#include "headers.h"
#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "physfs.h"
#include "sys_xoshiro.h"
#ifndef CONSOLE_ONLY
#include "ui_window.h"
#endif

#ifdef WIN32
#include "winuser.h"
#endif

/**
 * \brief Ticker time in milliseconds
 */
constexpr size_t TICKER_TIME = 50;

std::filesystem::path home_dir;
std::filesystem::path install_dir;
#ifdef WIN32
std::filesystem::path physfs_dir;
#endif

std::filesystem::path config_file;
std::filesystem::path options_file;
std::filesystem::path theme_file;
std::filesystem::path logging_file;
std::filesystem::path reference_file;

struct UpdateKv {
    char section;
    std::string key;
    std::string value;
};

UpdateKv update_kv;

std::string OBSIDIAN_TITLE = "OBSIDIAN Level Maker";
std::string OBSIDIAN_CODE_NAME = "Unstable";

int screen_w;
int screen_h;

int main_action;

unsigned long long next_rand_seed;

bool batch_mode = false;
std::filesystem::path batch_output_file;
std::string numeric_locale;
std::vector<std::string> batch_randomize_groups;

// options
#ifndef CONSOLE_ONLY
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
Fl_Font font_style = 0;
Fl_Boxtype box_style = FL_FLAT_BOX;
Fl_Boxtype button_style = FL_DOWN_BOX;
#endif
int color_scheme = 0;
int font_theme = 0;
int box_theme = 0;
int button_theme = 0;
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
bool preserve_failures = false;
bool preserve_old_config = false;
bool did_randomize = false;
bool randomize_architecture = false;
bool randomize_monsters = false;
bool randomize_pickups = false;
bool randomize_misc = false;
bool random_string_seeds = false;
bool password_mode = false;
bool did_specify_seed = false;
int zip_output = 0;
int log_size = 1;  // Without debugging info on, this should handle a full size
                   // 75 megawad with some room to spare
int log_limit = 5;
bool mid_batch = false;
int builds_per_run = 1;

int old_x = 0;
int old_y = 0;
int old_w = 0;
int old_h = 0;
std::string old_seed;
std::string old_name;
u8_t *old_pixels;

bool first_run = false;

std::filesystem::path gif_filename = "gif_output.gif";
std::string default_output_path;

std::string string_seed;

std::string selected_lang =
    "en";  // Have a default just in case the translation stuff borks

game_interface_c *game_object = NULL;

#ifndef CONSOLE_ONLY
// Tutorial stuff
Fl_BMP_Image *tutorial1;
Fl_BMP_Image *tutorial2;
Fl_BMP_Image *tutorial3;
Fl_BMP_Image *tutorial4;
Fl_BMP_Image *tutorial5;
Fl_BMP_Image *tutorial6;
Fl_BMP_Image *tutorial7;
Fl_BMP_Image *tutorial8;
Fl_BMP_Image *tutorial9;
Fl_BMP_Image *tutorial10;

#ifdef WIN32
FLASHWINFO *blinker;
#endif

static void main_win_surprise_config_CB(Fl_Widget *w, void *data) {
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    const Fl_Menu_Item *checkbox = menu->find_item(main_win_surprise_config_CB);
    preserve_old_config = (checkbox->value() != 0) ? true : false;
}

static void main_win_architecture_config_CB(Fl_Widget *w, void *data) {
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    const Fl_Menu_Item *checkbox =
        menu->find_item(main_win_architecture_config_CB);
    randomize_architecture = (checkbox->value() != 0) ? true : false;
}

static void main_win_monsters_config_CB(Fl_Widget *w, void *data) {
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    const Fl_Menu_Item *checkbox = menu->find_item(main_win_monsters_config_CB);
    randomize_monsters = (checkbox->value() != 0) ? true : false;
}

static void main_win_pickups_config_CB(Fl_Widget *w, void *data) {
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    const Fl_Menu_Item *checkbox = menu->find_item(main_win_pickups_config_CB);
    randomize_pickups = (checkbox->value() != 0) ? true : false;
}

static void main_win_misc_config_CB(Fl_Widget *w, void *data) {
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    const Fl_Menu_Item *checkbox = menu->find_item(main_win_misc_config_CB);
    randomize_misc = (checkbox->value() != 0) ? true : false;
}

static void main_win_addon_CB(Fl_Widget *w, void *data) {
    std::string menu_item = _("Addons/");
    Fl_Menu_Bar *menu = (Fl_Menu_Bar *)w;
    addon_info_t *addon = (addon_info_t *)data;
    menu_item.append(addon->name.filename().string());
    const Fl_Menu_Item *checkbox = menu->find_item(menu_item.c_str());
    addon->enabled = (checkbox->value() != 0) ? true : false;
}

static void main_win_apply_addon_CB(Fl_Widget *w, void *data) {
    Options_Save(options_file);

    fl_alert("%s", _("OBSIDIAN will now restart and apply changes to addons."));

    initial_enabled_addons.clear();

    for (int j = 0; j < all_addons.size(); j++) {
        if (all_addons[j].enabled) {
            initial_enabled_addons[all_addons[j].name] = 1;
        }
    }

    main_action = MAIN_HARD_RESTART;
}
#endif
/* ----- user information ----------------------------- */

static void ShowInfo() {
    fmt::print(
        "\n"
        "** {} {} \"{}\"\n"
        "** Build {} **\n"
        "** Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted **\n"
        "\n",
        OBSIDIAN_TITLE, OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME,
        OBSIDIAN_VERSION);

    fmt::print(
        "Usage: Obsidian [options...] [key=value...]\n"
        "\n"
        "Available options:\n"
        "     --version              Display build information\n"
        "     --home     <dir>       Home directory\n"
        "     --install  <dir>       Installation directory\n"
        "\n"
        "     --config   <file>      Config file for GUI\n"
        "     --options  <file>      Options file for GUI\n"
        "     --log      <file>      Log file to create\n"
        "\n"
        "  -b --batch    <output>    Batch mode (no GUI)\n"
        "  -a --addon    <file>...   Addon(s) to use\n"
        "  -l --load     <file>      Load settings from a file\n"
        "  -k --keep                 Keep SEED from loaded settings\n"
        "\n"
        "     --randomize-all        Randomize all options\n"
        "     --randomize-arch       Randomize architecture settings\n"
        "     --randomize-combat     Randomize combat-related settings\n"
        "     --randomize-pickups    Randomize item/weapon settings\n"
        "     --randomize-other      Randomize other settings\n"
        "\n"
        "  -3 --pk3                  Compress output file to PK3\n"
        "  -z --zip                  Compress output file to ZIP\n"
        "\n"
        "  -d --debug                Enable debugging\n"
        "  -v --verbose              Print log messages to stdout\n"
        "  -h --help                 Show this help message\n"
        "  -p --printref             Print reference of all keys and values to "
        "REFERENCE.txt\n"
        "     --printref-json        Print reference of all keys and values in "
        "JSON format\n"
        "  -u --update <section> <key> <value>\n"
        "                            Set a key in the config file\n"
        "                            (section should be 'c' or 'o')\n"
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
    fmt::print("{} {} \"{}\" Build {}\n", OBSIDIAN_TITLE,
               OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME, OBSIDIAN_VERSION);

    fflush(stdout);
}

#ifdef WIN32
char32_t *ucs4_path(const char *path) {
    PHYSFS_uint32 *long_path = new PHYSFS_uint32[strlen(path) * 4 + 1];
    PHYSFS_utf8ToUcs4(path, long_path, strlen(path) * 4);
    return (char32_t *)long_path;
}
#endif

void Determine_WorkingPath(const char *argv0) {
    // firstly find the "Working directory" : that's the place where
    // the CONFIG.txt and LOGS.txt files are, as well the temp files.

    if (const int home_arg = argv::Find(0, "home"); home_arg >= 0) {
        if (home_arg + 1 >= argv::list.size() || argv::IsOption(home_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --home\n");
            exit(EXIT_FAILURE);
        }

        home_dir = argv::list[home_arg + 1];
        return;
    }

#ifdef WIN32
    home_dir = ucs4_path(argv0);
    home_dir.remove_filename();
    physfs_dir = argv0;
    physfs_dir.remove_filename();
#else
    const char *xdg_config_home = std::getenv("XDG_CONFIG_HOME");
    if (xdg_config_home == nullptr) {
        xdg_config_home = std::getenv("HOME");
        if (xdg_config_home == nullptr) {
            home_dir = ".";
        } else {
            home_dir = xdg_config_home;
            home_dir /= ".config";
        }
    } else {
        home_dir = xdg_config_home;
    }
    home_dir /= "obsidian";
    if (!home_dir.is_absolute()) {
        home_dir = std::getenv("HOME");
        home_dir /= ".config/obsidian";

        if (!home_dir.is_absolute()) {
            Main::FatalError("Unable to find $HOME directory!\n");
        }
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

std::filesystem::path Resolve_DefaultOutputPath() {
    if (default_output_path.empty()) {
        default_output_path = install_dir.string();
    }
    if (default_output_path[0] == '$') {
        const char *var = getenv(default_output_path.c_str() + 1);
        if (var != nullptr) {
            return var;
        }
    }
    return default_output_path;
}

static bool Verify_InstallDir(const std::filesystem::path &path) {
    const std::filesystem::path filename = path / "scripts" / "obsidian.lua";

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
            exit(EXIT_FAILURE);
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
    constexpr std::array<const char *, 4> prefixes = {
        "/usr/local",
        "/usr",
        "/opt",
        "/app",
    };

    for (const char *prefix : prefixes) {
        install_dir = fmt::format("{}/share/obsidian", prefix);

        if (Verify_InstallDir(install_dir.c_str())) {
            return;
        }

        install_dir.clear();
    }

    // Last resort
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
            exit(EXIT_FAILURE);
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
            exit(EXIT_FAILURE);
        }

        options_file = argv::list[optf_arg + 1];
    } else {
        options_file /= home_dir;
        options_file /= OPTIONS_FILENAME;
    }
}

#ifndef CONSOLE_ONLY
void Determine_ThemeFile() {
    if (const int themef_arg = argv::Find(0, "theme"); themef_arg >= 0) {
        if (themef_arg + 1 >= argv::list.size() ||
            argv::IsOption(themef_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --theme\n");
            exit(EXIT_FAILURE);
        }

        theme_file = argv::list[themef_arg + 1];
    } else {
        theme_file /= home_dir;
        theme_file /= THEME_FILENAME;
    }
}
#endif

void Determine_LoggingFile() {
    if (const int logf_arg = argv::Find(0, "log"); logf_arg >= 0) {
        if (logf_arg + 1 >= argv::list.size() || argv::IsOption(logf_arg + 1)) {
            fmt::print(stderr, "OBSIDIAN ERROR: missing path for --log\n");
            exit(EXIT_FAILURE);
        }

        logging_file = argv::list[logf_arg + 1];

        // test that it can be created
        std::ofstream fp{logging_file};

        if (!fp.is_open()) {
            Main::FatalError("Cannot create log file: {}\n",
                             logging_file.string());
        }

        fp.close();
    } else if (!batch_mode) {
        logging_file /= home_dir;
        logging_file /= LOG_FILENAME;
    } else {
        logging_file = std::filesystem::current_path();
        logging_file /= LOG_FILENAME;
    }
}

void Determine_ReferenceFile() {
    if (argv::Find('p', "printref") >= 0) {
        if (!batch_mode) {
            reference_file /= home_dir;
            reference_file /= REF_FILENAME;
        } else {
            reference_file = std::filesystem::current_path();
            reference_file /= REF_FILENAME;
        }
    }
}

bool Main::BackupFile(const std::filesystem::path &filename) {
    if (std::filesystem::exists(filename)) {
        std::filesystem::path backup_name = filename;

        backup_name.replace_extension(fmt::format(
            "{}.{}", backup_name.filename().extension().generic_string(), "bak"));

        LogPrintf("Backing up existing file to: {}\n", backup_name.string());

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

#ifndef CONSOLE_ONLY
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
    if (font_menu_items.size() == 0) {
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
            // their TTF fontname. This is because these fonts have been
            // modified in some fashion, and the OFL 1.1 license dictates that
            // modified versions cannot display their Reserved Name to users

            int current_free_font = 16;

            if (LoadInternalFont(
                    "./theme/fonts/SourceSansPro/SourceSansPro-Regular.ttf",
                    current_free_font, "Source Sans Pro")) {
                if (LoadInternalFont(
                        "./theme/fonts/SourceSansPro/SourceSansPro-Bold.ttf",
                        current_free_font + 1, "Source Sans Pro Bold")) {
                    font_menu_items.push_back(std::map<std::string, int>{
                        {"Sauce <Default>", current_free_font}});
                    current_free_font += 2;
                }
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
                font_menu_items.push_back(std::map<std::string, int>{
                    {"Avenixel", current_free_font}});
                current_free_font += 2;
            }

            if (LoadInternalFont("./theme/fonts/TheNeueBlack/TheNeue-Black.ttf",
                                 current_free_font, "The Neue Black")) {
                Fl::set_font(current_free_font + 1, "The Neue Black");
                font_menu_items.push_back(std::map<std::string, int>{
                    {"New Black", current_free_font}});
                current_free_font += 2;
            }

            if (LoadInternalFont("./theme/fonts/Teko/Teko-Regular.ttf",
                                 current_free_font, "Teko")) {
                if (LoadInternalFont("./theme/fonts/Teko/Teko-Bold.ttf",
                                     current_free_font + 1, "Teko Bold")) {
                    font_menu_items.push_back(std::map<std::string, int>{
                        {"Teko", current_free_font}});
                    current_free_font += 2;
                }
            }

            if (LoadInternalFont("./theme/fonts/Kalam/Kalam-Regular.ttf",
                                 current_free_font, "Kalam")) {
                if (LoadInternalFont("./theme/fonts/Kalam/Kalam-Bold.ttf",
                                     current_free_font + 1, "Kalam Bold")) {
                    font_menu_items.push_back(std::map<std::string, int>{
                        {"Kalam", current_free_font}});
                    current_free_font += 2;
                }
            }

            if (LoadInternalFont("./theme/fonts/3270/3270.ttf",
                                 current_free_font, "3270 Condensed")) {
                Fl::set_font(current_free_font + 1, "3270 Condensed");
                font_menu_items.push_back(
                    std::map<std::string, int>{{"3270", current_free_font}});
                current_free_font += 2;
            }

            if (LoadInternalFont("./theme/fonts/Workbench/Workbench.ttf",
                                 current_free_font,
                                 "Workbench Light Regular")) {
                if (LoadInternalFont("./theme/fonts/Workbench/Workbench.ttf",
                                     current_free_font + 1,
                                     "Workbench Regular")) {
                    font_menu_items.push_back(std::map<std::string, int>{
                        {"Workbench", current_free_font}});
                    current_free_font += 2;
                }
            }

            if (LoadInternalFont(
                    "./theme/fonts/FPD-Pressure/FPDPressure-Light.otf",
                    current_free_font, "FPD Pressure Light")) {
                if (LoadInternalFont(
                        "./theme/fonts/FPD-Pressure/FPDPressure-Regular.otf",
                        current_free_font + 1, "FPD Pressure")) {
                    font_menu_items.push_back(std::map<std::string, int>{
                        {"FPD Pressure", current_free_font}});
                    current_free_font += 2;
                }
            }

            if (LoadInternalFont("./theme/fonts/DramaSans/DramaSans.ttf",
                                 current_free_font, "Drama Sans")) {
                Fl::set_font(current_free_font + 1, "Drama Sans");
                font_menu_items.push_back(std::map<std::string, int>{
                    {"Drama Sans", current_free_font}});
                current_free_font += 2;
            }

            if (LoadInternalFont("./theme/fonts/SamIAm/MiniSmallCaps.ttf",
                                 current_free_font, "MiniSmallCaps")) {
                Fl::set_font(current_free_font + 1, "MiniSmallCaps");
                font_menu_items.push_back(std::map<std::string, int>{
                    {"Sam I Am", current_free_font}});
                current_free_font += 2;
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

#ifdef WIN32
void Main::Blinker() { FlashWindowEx(blinker); }
#endif
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
#endif

void Main::Detail::Shutdown(const bool error) {
#ifndef CONSOLE_ONLY
    if (main_win) {
        // on fatal error we cannot risk calling into the Lua runtime
        // (it's state may be compromised by a script error).
        if (!config_file.empty() && !error) {
            if (did_randomize) {
                if (!preserve_old_config) {
                    Cookie_Save(config_file);
                }
            } else {
                Cookie_Save(config_file);
            }
        }

        delete main_win;
        main_win = nullptr;
    }
#else
    if (!std::filesystem::exists(options_file)) {
        Options_Save(options_file);
    }
#endif
    Script_Close();
    LogClose();
}

#ifndef CONSOLE_ONLY
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
#endif

void Main_CalcNewSeed() { next_rand_seed = xoshiro_UInt(); }

void Main_SetSeed() {
    if (random_string_seeds && !did_specify_seed) {
        if (string_seed.empty()) {
            if (password_mode) {
                if (next_rand_seed % 2 == 1) {
                    string_seed = ob_get_password();
                } else {
                    string_seed = ob_get_random_words();
                }
            } else {
                string_seed = ob_get_random_words();
            }
            ob_set_config("string_seed", string_seed.c_str());
            unsigned long long split_limit =
                (std::numeric_limits<long long>::max() /
                 127);  // It is intentional that I am using the max for signed
                        // - Dasho
            next_rand_seed = split_limit;
            for (size_t i = 0; i < string_seed.size(); i++) {
                char character = string_seed.at(i);
                if (!std::iscntrl(character)) {
                    if (next_rand_seed < split_limit) {
                        next_rand_seed *= abs(int(character));
                    } else {
                        next_rand_seed /= abs(int(character));
                    }
                }
            }
        }
    }
    xoshiro_Reseed(next_rand_seed);
    std::string seed = NumToString(next_rand_seed);
    ob_set_config("seed", seed.c_str());
#ifndef CONSOLE_ONLY
    if (!batch_mode) {
        main_win->build_box->seed_disp->copy_label(
            fmt::format("{} {}", _("Seed:"), seed).c_str());
        main_win->build_box->seed_disp->redraw();
    }
#endif
}

static void Module_Defaults() {
    ob_set_mod_option("sky_generator", "self", "1");
    ob_set_mod_option("sky_generator_heretic", "self", "1");
    ob_set_mod_option("armaetus_epic_textures", "self", "1");
    ob_set_mod_option("music_swapper", "self", "1");
}

//------------------------------------------------------------------------

bool Build_Cool_Shit() {
#ifndef CONSOLE_ONLY
    // clear the map
    if (main_win) {
        main_win->build_box->mini_map->EmptyMap();
    }
#endif

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
        } else if (StringCaseCmp(format, "wolf3d") == 0) {
            game_object = Wolf_GameObject();
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

#ifndef CONSOLE_ONLY
    // lock most widgets of user interface
    if (main_win) {
        std::string seed = NumToString(next_rand_seed);
        if (!string_seed.empty()) {
            main_win->build_box->seed_disp->copy_label(
                fmt::format("{} {}", _("Seed:"), string_seed).c_str());
            main_win->build_box->seed_disp->redraw();
        } else {
            main_win->build_box->seed_disp->copy_label(
                fmt::format("{} {}", _("Seed:"), seed).c_str());
            main_win->build_box->seed_disp->redraw();
        }
        main_win->game_box->SetAbortButton(true);
        main_win->build_box->SetStatus(_("Preparing..."));
        main_win->Locked(true);
    }
#endif

    const u32_t start_time = TimeGetMillies();
    bool was_ok = false;
    // this will ask for output filename (among other things)
    if (StringCaseCmp(format, "wolf3d") == 0) {
        std::string current_game = ob_get_param("game");
        if (StringCaseCmp(current_game, "wolf") == 0) {
            was_ok = game_object->Start("WL6");
        } else if (StringCaseCmp(current_game, "spear") == 0) {
            was_ok = game_object->Start("SOD");
        } else if (StringCaseCmp(current_game, "noah") == 0) {
            was_ok = game_object->Start("N3D");
        } else {
            was_ok = game_object->Start("BS6"); // Blake Stone: Aliens of Gold
        }
    } else {
        was_ok = game_object->Start(def_filename.c_str());
    }

#ifndef CONSOLE_ONLY
    // coerce FLTK to redraw the main window
    for (int r_loop = 0; r_loop < 6; r_loop++) {
        Fl::wait(0.06);
    }
#endif

    if (was_ok) {
        // run the scripts Scotty!
        was_ok = ob_build_cool_shit();

        was_ok = game_object->Finish(was_ok);
    }
    if (was_ok) {
        Main::ProgStatus(_("Success"));

        const u32_t end_time = TimeGetMillies();
        const u32_t total_time = end_time - start_time;

        LogPrintf("\nTOTAL TIME: {} seconds\n\n", total_time / 1000.0);

        string_seed.clear();

#ifdef WIN32
#ifndef CONSOLE_ONLY
        if (main_win) Main::Blinker();
#endif
#endif
    } else {
        string_seed.clear();
#ifndef CONSOLE_ONLY
        if (main_win) {
            main_win->build_box->seed_disp->copy_label(_("Seed: -"));
            main_win->build_box->seed_disp->redraw();
            main_win->build_box->name_disp->copy_label("");
            main_win->build_box->name_disp->redraw();
        }
#endif
    }

#ifndef CONSOLE_ONLY
    if (main_win) {
        main_win->build_box->Prog_Finish();
        main_win->game_box->SetAbortButton(false);
        main_win->Locked(false);
    }
#endif

    if (main_action == MAIN_CANCEL) {
        main_action = 0;
#ifndef CONSOLE_ONLY
        if (main_win) {
            main_win->label(fmt::format("{} {} \"{}\"", OBSIDIAN_TITLE,
                                        OBSIDIAN_SHORT_VERSION,
                                        OBSIDIAN_CODE_NAME)
                                .c_str());
        }
#endif
        Main::ProgStatus(_("Cancelled"));
    }

    // don't need game object anymore
    delete game_object;
    game_object = NULL;

    return was_ok;
}

void Options_ParseArguments() {
    if (argv::Find('z', "zip") >= 0) {
        zip_output = 1;
    }

    if (argv::Find('3', "pk3") >= 0) {
        zip_output = 2;
    }

    if (argv::Find(0, "randomize-all") >= 0) {
        if (batch_mode) {
            batch_randomize_groups.push_back("architecture");
            batch_randomize_groups.push_back("monsters");
            batch_randomize_groups.push_back("pickups");
            batch_randomize_groups.push_back("misc");
        }
        goto skiprest;
    }

    if (argv::Find(0, "randomize-arch") >= 0) {
        if (batch_mode) {
            batch_randomize_groups.push_back("architecture");
        }
    }

    if (argv::Find(0, "randomize-monsters") >= 0) {
        if (batch_mode) {
            batch_randomize_groups.push_back("monsters");
        }
    }

    if (argv::Find(0, "randomize-pickups") >= 0) {
        if (batch_mode) {
            batch_randomize_groups.push_back("pickups");
        }
    }

    if (argv::Find(0, "randomize-other") >= 0) {
        if (batch_mode) {
            batch_randomize_groups.push_back("misc");
        }
    }

skiprest:;
}

/* ----- main program ----------------------------- */

int main(int argc, char **argv) {
    // initialise argument parser (skipping program name)

    // these flags take at least one argument
    argv::short_flags.emplace('b');
    argv::short_flags.emplace('a');
    argv::short_flags.emplace('l');
    argv::short_flags.emplace('u');

    // parse the flags
    argv::Init(argc - 1, argv + 1);

hardrestart:;

    if (argv::Find('?', NULL) >= 0 || argv::Find('h', "help") >= 0) {
#if defined WIN32 && !defined CONSOLE_ONLY
        if (AllocConsole()) {
            freopen("CONOUT$", "r", stdin);
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#endif
        ShowInfo();
#if defined WIN32 && !defined CONSOLE_ONLY
        std::cout << '\n' << "Close window when finished...";
        do {
        } while (true);
#endif
        exit(EXIT_SUCCESS);
    } else if (argv::Find(0, "version") >= 0) {
#if defined WIN32 && !defined CONSOLE_ONLY
        if (AllocConsole()) {
            freopen("CONOUT$", "r", stdin);
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#endif
        ShowVersion();
#if defined WIN32 && !defined CONSOLE_ONLY
        std::cout << '\n' << "Close window when finished...";
        do {
        } while (true);

#endif
        exit(EXIT_SUCCESS);
    }

#ifdef CONSOLE_ONLY
    batch_mode = true;
#endif

    int batch_arg = argv::Find('b', "batch");
    if (batch_arg >= 0) {
        if (batch_arg + 1 >= argv::list.size() ||
            argv::IsOption(batch_arg + 1)) {
            fmt::print(stderr,
                       "OBSIDIAN ERROR: missing filename for --batch\n");
            exit(EXIT_FAILURE);
        }

        batch_mode = true;
        batch_output_file = argv::list[batch_arg + 1];
#if defined WIN32 && !defined CONSOLE_ONLY
        if (AllocConsole()) {
            freopen("CONOUT$", "r", stdin);
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#endif
    }

    if (argv::Find('p', "printref") >= 0) {
        batch_mode = true;
#if defined WIN32 && !defined CONSOLE_ONLY
        if (AllocConsole()) {
            freopen("CONOUT$", "r", stdin);
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#endif
    }

    if (int update_arg = argv::Find('u', "update"); update_arg >= 0) {
        batch_mode = true;
        if (update_arg + 3 >= argv::list.size() ||
            argv::IsOption(update_arg + 1) || argv::IsOption(update_arg + 2) ||
            argv::IsOption(update_arg + 3)) {
            fmt::print(stderr,
                       "OBSIDIAN ERROR: missing one or more args for --update "
                       "<section> <key> <value>\n");
            exit(EXIT_FAILURE);
        }
        if (argv::list[update_arg + 1].length() > 1) {
            fmt::print(stderr,
                       "OBSIDIAN ERROR: section name must be one character\n");
            exit(EXIT_FAILURE);
        }
        char section = argv::list[update_arg + 1][0];
        if (section != 'c' && section != 'o') {
            fmt::print(stderr,
                       "OBSIDIAN ERROR: section name must be 'c' or 'o'\n");
            exit(EXIT_FAILURE);
        }
        update_kv.section = section;
        update_kv.key = argv::list[update_arg + 2];
        update_kv.value = argv::list[update_arg + 3];
    }

    if (argv::Find(0, "printref-json") >= 0) {
        batch_mode = true;
#if defined WIN32 && !defined CONSOLE_ONLY
        if (AllocConsole()) {
            freopen("CONOUT$", "r", stdin);
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#endif
    }

    Determine_WorkingPath(argv[0]);
    Determine_InstallDir(argv[0]);

    Determine_ConfigFile();
    Determine_OptionsFile();
#ifndef CONSOLE_ONLY
    Determine_ThemeFile();
#endif
    Determine_LoggingFile();
    Determine_ReferenceFile();

    Options_Load(options_file);

    Options_ParseArguments();

    LogInit(logging_file);

    if (argv::Find('p', "printref") >= 0) {
        RefInit(reference_file);
    }

    // accept -t and --terminal for backwards compatibility
    if (argv::Find('v', "verbose") >= 0 || argv::Find('t', "terminal") >= 0) {
        LogEnableTerminal(true);
    }

    LogPrintf("\n");
    LogPrintf("********************************************************\n");
    LogPrintf("** {} {} \"{}\" **\n", OBSIDIAN_TITLE, OBSIDIAN_SHORT_VERSION,
              OBSIDIAN_CODE_NAME);
    LogPrintf("** Build {} **\n", OBSIDIAN_VERSION);
    LogPrintf("********************************************************\n");
    LogPrintf("\n");

#ifndef CONSOLE_ONLY
    LogPrintf("Library versions: FLTK {}.{}.{}\n\n", FL_MAJOR_VERSION,
              FL_MINOR_VERSION, FL_PATCH_VERSION);
#endif

    LogPrintf("home_dir: {}\n", home_dir.string());
    LogPrintf("install_dir: {}\n", install_dir.string());
    LogPrintf("config_file: {}\n\n", config_file.string());

    Trans_Init();

    if (!batch_mode) {
#ifndef CONSOLE_ONLY
        Theme_Options_Load(theme_file);
#endif
        Trans_SetLanguage();
        OBSIDIAN_TITLE = _("OBSIDIAN Level Maker");
        OBSIDIAN_CODE_NAME = _("Unstable");
#ifndef CONSOLE_ONLY
        Main::SetupFltk();
#endif
    }

    if (argv::Find('d', "debug") >= 0) {
        debug_messages = true;
    }
#ifdef __unix__
#ifndef __linux__
    numeric_locale =
        setlocale(LC_NUMERIC, NULL);  // Grab current numeric locale
#else
    numeric_locale =
        std::setlocale(LC_NUMERIC, NULL);  // Grab current numeric locale
#endif
#else
    numeric_locale =
        std::setlocale(LC_NUMERIC, NULL);  // Grab current numeric locale
#endif

    LogEnableDebug(debug_messages);

softrestart:;

    Main_CalcNewSeed();

    std::string load_file;

    //    TX_TestSynth(next_rand_seed); - Fractal testing stuff

    if (main_action != MAIN_SOFT_RESTART) {
        VFS_InitAddons(argv[0]);

        if (const int load_arg = argv::Find('l', "load"); load_arg >= 0) {
            if (load_arg + 1 >= argv::list.size() ||
                argv::IsOption(load_arg + 1)) {
                fmt::print(stderr,
                           "OBSIDIAN ERROR: missing filename for --load\n");
                exit(EXIT_FAILURE);
            }

            load_file = argv::list[load_arg + 1];
        }
    }

    // Dumb ad-hoc function for if I need to update the images.h arrays - Dasho

    /*std::filesystem::path logo_path = install_dir;
    logo_path.append("data").append("obsidian_pill.raw");
    std::string test_file = FileLoad(logo_path);
    byte *testy = new byte[64 * 64];
    memcpy(testy, (void *)test_file.data(), 64 * 64);
    int numba_counter = 0;
    for (int i = 0; i < 64 * 64; i++) {
        LogPrintf("{:d},", testy[i]);
        numba_counter++;
        if (numba_counter == 16) {
            LogPrintf("\n");
            numba_counter = 0;
        }
    }*/

    if (batch_mode) {
        VFS_ParseCommandLine();

        Script_Open();

        // inform Lua code about batch mode (the value doesn't matter)
        ob_set_config("batch", "yes");

        Module_Defaults();

        if (argv::Find('p', "printref") >= 0) {
            ob_print_reference();
            RefClose();
#if defined WIN32 && !defined CONSOLE_ONLY
            std::cout << '\n' << "Close window when finished...";

            do {
            } while (true);
#endif
            Main::Detail::Shutdown(false);
            return 0;
        }

        if (argv::Find(0, "printref-json") >= 0) {
            ob_print_reference_json();
#if defined WIN32 && !defined CONSOLE_ONLY
            std::cout << '\n' << "Close window when finished...";

            do {
            } while (true);
#endif
            Main::Detail::Shutdown(false);
            return 0;
        }

        if (!load_file.empty()) {
            if (!Cookie_Load(load_file)) {
                Main::FatalError(_("No such config file: {}\n"), load_file);
            }
        } else {
            if (!std::filesystem::exists(config_file)) {
                Cookie_Save(config_file);
            }
            if (!Cookie_Load(config_file)) {
                Main::FatalError(_("No such config file: {}\n"), config_file);
            }
        }

        Cookie_ParseArguments();

        if (argv::Find('u', "update") >= 0) {
            switch (update_kv.section) {
                case 'c':
                    ob_set_config(update_kv.key, update_kv.value);
                    break;
                case 'o':
                    Parse_Option(update_kv.key, update_kv.value);
                    break;
            }
            Options_Save(options_file);
            Cookie_Save(config_file);
            Main::Detail::Shutdown(false);
            return 0;
        }

        if (batch_output_file.empty()) {
            fmt::print(stderr,
                       "\nNo output filename given! Did you forget the --batch "
                       "parameter?\n");
            LogPrintf(
                "\nNo output filename given! Did you forget the --batch "
                "parameter?\n");

            Main::Detail::Shutdown(false);
#if defined WIN32 && !defined CONSOLE_ONLY
            std::cout << '\n' << "Close window when finished...";
            do {
            } while (true);
#endif
            return EXIT_FAILURE;
        }

        Main_SetSeed();
        if (!Build_Cool_Shit()) {
            fmt::print(stderr, "FAILED!\n");
            LogPrintf("FAILED!\n");

            Main::Detail::Shutdown(false);
#if defined WIN32 && !defined CONSOLE_ONLY
            std::cout << '\n' << "Close window when finished...";
            do {
            } while (true);
#endif
            return EXIT_FAILURE;
        }
        Main::Detail::Shutdown(false);
        return 0;
    }

    /* ---- normal GUI mode ---- */

    std::string main_title =
        fmt::format("{} {} \"{}\"", OBSIDIAN_TITLE, OBSIDIAN_SHORT_VERSION,
                    OBSIDIAN_CODE_NAME);

    if (main_action != MAIN_SOFT_RESTART) {
        // this not only finds PK3 files, but also activates the ones specified
        // in OPTIONS.txt
        VFS_ScanForAddons();

        VFS_ParseCommandLine();

// create the main window
#ifndef CONSOLE_ONLY
        int main_w, main_h;
        UI_MainWin::CalcWindowSize(&main_w, &main_h);

        main_win = new UI_MainWin(main_w, main_h, main_title.c_str());
#endif
    }

    //???    Default_Location();

    Script_Open();

    ob_set_config("locale", selected_lang.c_str());

    // enable certain modules by default
    Module_Defaults();

    // load config after creating window (will set widget values)
    if (!Cookie_Load(config_file)) {
        LogPrintf("Missing config file -- using defaults.\n\n");
        first_run = true;
    }

    if (!load_file.empty()) {
        if (!Cookie_Load(load_file)) {
            Main::FatalError(_("No such config file: {}\n"), load_file);
        }
    }

    Cookie_ParseArguments();

    if (main_action != MAIN_SOFT_RESTART) {
#ifndef CONSOLE_ONLY
        // Have to add these after reading existing settings - Dasho
        if (main_win) {
            main_win->menu_bar->add(
                _("Surprise Me/Preserve Old Config"), NULL,
                main_win_surprise_config_CB, 0,
                FL_MENU_TOGGLE | (preserve_old_config ? FL_MENU_VALUE : 0));
            main_win->menu_bar->add(
                _("Surprise Me/Randomize Architecture"), NULL,
                main_win_architecture_config_CB, 0,
                FL_MENU_TOGGLE | (randomize_architecture ? FL_MENU_VALUE : 0));
            main_win->menu_bar->add(
                _("Surprise Me/Randomize Combat"), NULL,
                main_win_monsters_config_CB, 0,
                FL_MENU_TOGGLE | (randomize_monsters ? FL_MENU_VALUE : 0));
            main_win->menu_bar->add(
                _("Surprise Me/Randomize Pickups"), NULL,
                main_win_pickups_config_CB, 0,
                FL_MENU_TOGGLE | (randomize_pickups ? FL_MENU_VALUE : 0));
            main_win->menu_bar->add(
                _("Surprise Me/Randomize Other"), NULL, main_win_misc_config_CB,
                0, FL_MENU_TOGGLE | (randomize_misc ? FL_MENU_VALUE : 0));
            if (all_addons.size() == 0) {
                main_win->menu_bar->add(_("Addons/No Addons Detected"), 0, 0, 0,
                                        FL_MENU_INACTIVE);
            } else {
                main_win->menu_bar->add(_("Addons/Restart and Apply Changes"),
                                        0, main_win_apply_addon_CB, 0, 0);
                for (int i = 0; i < all_addons.size(); i++) {
                    std::string addon_entry = _("Addons/");
                    addon_entry.append(all_addons[i].name.filename().string());
                    main_win->menu_bar->add(
                        addon_entry.c_str(), 0, main_win_addon_CB,
                        (void *)&all_addons[i],
                        FL_MENU_TOGGLE |
                            (all_addons[i].enabled ? FL_MENU_VALUE : 0));
                }
            }
        }

        fl_register_images();  // Needed for Unix window icon and tutorial
                               // windows

        // Load tutorial images
        std::filesystem::path image_loc = install_dir;
        image_loc.append("data").append("tutorial").append("tutorial1.bmp");
        if (!tutorial1) {
            tutorial1 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial2.bmp");
        if (!tutorial2) {
            tutorial2 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial3.bmp");
        if (!tutorial3) {
            tutorial3 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial4.bmp");
        if (!tutorial4) {
            tutorial4 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial5.bmp");
        if (!tutorial5) {
            tutorial5 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial6.bmp");
        if (!tutorial6) {
            tutorial6 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial7.bmp");
        if (!tutorial7) {
            tutorial7 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial8.bmp");
        if (!tutorial8) {
            tutorial8 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial9.bmp");
        if (!tutorial9) {
            tutorial9 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }
        image_loc.replace_filename("tutorial10.bmp");
        if (!tutorial10) {
            tutorial10 = new Fl_BMP_Image(image_loc.generic_string().c_str());
        }

#ifdef WIN32
        main_win->icon((const void *)LoadIcon(fl_display, MAKEINTRESOURCE(1)));
#else
#ifdef UNIX
        Fl_Pixmap program_icon(obsidian_icon);
        Fl_RGB_Image rgb_icon(&program_icon, FL_BLACK);
        UI_MainWin::default_icon(&rgb_icon);
#endif
#endif

        // show window (pass some dummy arguments)
        {
            char *fake_argv[2];
            fake_argv[0] = strdup("Obsidian.exe");
            fake_argv[1] = NULL;
            main_win->show(1 /* argc */, fake_argv);
            if (old_w > 0 && old_h > 0) {
                main_win->resize(old_x, old_y, old_w, old_h);
            }
            if (first_run) {
                DLG_Tutorial();
            }
        }

#ifdef WIN32  // Populate structure for taskbar/window flash. Must be done after
              // main_win->show() function - Dasho
        if (!blinker) {
            blinker = new FLASHWINFO;
            blinker->cbSize = sizeof(FLASHWINFO);
            blinker->hwnd = fl_xid(main_win);
            blinker->dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
            blinker->dwTimeout = 0;
            blinker->uCount = 0;
        } else {
            blinker->hwnd = fl_xid(main_win);
            if (!old_seed.empty() && !old_name.empty()) Main::Blinker();
        }
#endif

        // kill the stupid bright background of the "plastic" scheme
        if (widget_theme == 3) {
            delete Fl::scheme_bg_;
            Fl::scheme_bg_ = NULL;

            main_win->image(NULL);
        }

        Fl::add_handler(Main_key_handler);
#endif
    }

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
            ob_set_config("filename_prefix", "port");
            break;
        case 4:
            ob_set_config("filename_prefix", "theme");
            break;
        case 5:
            ob_set_config("filename_prefix", "version");
            break;
        case 6:
            ob_set_config("filename_prefix", "custom");
            break;
        case 7:
            ob_set_config("filename_prefix", "none");
            break;
        default:
            ob_set_config("filename_prefix", "datetime");
            break;
    }

    if (main_action != MAIN_SOFT_RESTART) {
#ifndef CONSOLE_ONLY
        // draw an empty map (must be done after main window is
        // shown() because that is when FLTK finalises the colors).
        main_win->build_box->mini_map->EmptyMap();

        if (!old_seed.empty()) {
            main_win->build_box->seed_disp->copy_label(
                fmt::format("{} {}", _("Seed:"), old_seed).c_str());
            old_seed.clear();
        }

        if (!old_name.empty()) {
            main_win->build_box->name_disp->copy_label(old_name.c_str());
            old_name.clear();
        }

        if (old_pixels) {
            if (main_win->build_box->mini_map->pixels) {
                delete[] main_win->build_box->mini_map->pixels;
            }
            int map_size = main_win->build_box->mini_map->map_W *
                           main_win->build_box->mini_map->map_H * 3;
            main_win->build_box->mini_map->pixels = new u8_t[map_size];
            memcpy(main_win->build_box->mini_map->pixels, old_pixels, map_size);
            delete[] old_pixels;
            old_pixels = NULL;
            main_win->build_box->mini_map->MapFinish();
        }
#endif
    }

    main_action = MAIN_NONE;

    int runs_left = builds_per_run;

    try {
        // run the GUI until the user quits
        for (;;) {
#ifndef CONSOLE_ONLY
            Fl::wait(0.2);
#endif

            if (main_action == MAIN_QUIT || main_action == MAIN_HARD_RESTART ||
                main_action == MAIN_SOFT_RESTART) {
                break;
            }

            if (main_action == MAIN_BUILD) {
                if (!mid_batch) {
                    runs_left = builds_per_run;
                }

                main_action = 0;

                Main_SetSeed();

                // save config in case everything blows up
                if (did_randomize) {
                    if (!preserve_old_config) {
                        Cookie_Save(config_file);
                    }
                } else {
                    Cookie_Save(config_file);
                }

                bool result = Build_Cool_Shit();

                did_specify_seed = false;

                if (result) {
                    old_seed = string_seed.empty() ? NumToString(next_rand_seed)
                                                   : string_seed;
#ifndef CONSOLE_ONLY
                    if (main_win->build_box->name_disp->label()) {
                        old_name = main_win->build_box->name_disp->label();
                    }
                    if (main_win->build_box->mini_map->pixels) {
                        int map_size = main_win->build_box->mini_map->map_W *
                                       main_win->build_box->mini_map->map_H * 3;
                        old_pixels = new u8_t[map_size];
                        memcpy(old_pixels,
                               main_win->build_box->mini_map->pixels, map_size);
                    }
#endif
                } else {
                    old_seed.clear();
                    old_name.clear();
                }

                // regardless of success or fail, compute a new seed
                Main_CalcNewSeed();

                if (!result) {
                    mid_batch = false;
                    main_action = MAIN_SOFT_RESTART;
                    break;
                }

                runs_left--;
                if (runs_left > 0) {
                    mid_batch = true;
                    main_action = MAIN_BUILD;
                } else {
                    mid_batch = false;
                    main_action = MAIN_SOFT_RESTART;
                }
            }
        }
    } catch (const assert_fail_c &err) {
        Main::FatalError(_("Sorry, an internal error occurred:\n{}"),
                         err.GetMessage());
    } catch (std::exception &e) {
        Main::FatalError(_("An exception occurred: \n{}"), e.what());
    }

    if (main_action != MAIN_SOFT_RESTART) {
        LogPrintf("\nQuit......\n\n");
    }
#ifndef CONSOLE_ONLY
    Theme_Options_Save(theme_file);
#endif
    Options_Save(options_file);

    if (main_action == MAIN_HARD_RESTART || main_action == MAIN_SOFT_RESTART) {
#ifndef CONSOLE_ONLY
        if (main_win) {
            // on fatal error we cannot risk calling into the Lua runtime
            // (it's state may be compromised by a script error).
            if (!config_file.empty() && !preserve_old_config) {
                if (did_randomize) {
                    if (!preserve_old_config) {
                        Cookie_Save(config_file);
                    }
                } else {
                    Cookie_Save(config_file);
                }
            }
            if (main_action == MAIN_HARD_RESTART) {
                old_x = main_win->x();
                old_y = main_win->y();
                old_w = main_win->w();
                old_h = main_win->h();
                delete main_win;
                main_win = nullptr;
            }
        }
#endif
        Script_Close();
        if (main_action == MAIN_SOFT_RESTART) {
            goto softrestart;
        }
        if (main_action == MAIN_HARD_RESTART) {
            LogClose();
            PHYSFS_deinit();
            goto hardrestart;
        }
    }

    Main::Detail::Shutdown(false);

    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
