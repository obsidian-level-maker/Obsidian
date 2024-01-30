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
#include "images.h"
#include "csg_main.h"
#include "g_nukem.h"
#include "headers.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "lib_zip.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "physfs.h"
#include "sys_xoshiro.h"

/**
 * \brief Ticker time in milliseconds
 */
constexpr size_t TICKER_TIME = 50;

std::filesystem::path home_dir;
std::filesystem::path install_dir;
std::filesystem::path config_file;
std::filesystem::path options_file;
std::filesystem::path logging_file;

struct UpdateKv {
    char section;
    std::string key;
    std::string value;
};

UpdateKv update_kv;

std::string OBSIDIAN_TITLE = "OBSIDIAN Level Maker";
std::string OBSIDIAN_CODE_NAME = "UNSTABLE";

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

#endif
int filename_prefix = 0;
std::string custom_prefix = "CUSTOM_";
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
bool mature_word_lists = false;
bool did_specify_seed = false;

std::filesystem::path gif_filename = "gif_output.gif";
std::filesystem::path default_output_path;

std::string string_seed;

std::string selected_lang =
    "en";  // Have a default just in case the translation stuff borks

game_interface_c *game_object = NULL;

extern bool ExtractPresetData(FILE *fp, std::string &buf);

/* ----- user information ----------------------------- */

static void ShowInfo() {
    StdOutPrintf(
        "\n"
        "** %s %s \"%s\"\n"
        "** Build %s **\n"
        "** Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted **\n"
        "\n",
        OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str(),
        OBSIDIAN_VERSION);

    StdOutPrintf(
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

    StdOutPrintf(
        "Please visit the web site for complete information:\n"
        "  %s \n"
        "\n",
        OBSIDIAN_WEBSITE);

    StdOutPrintf(
        "This program is free software, under the terms of the GNU General "
        "Public\n"
        "License, and comes with ABSOLUTELY NO WARRANTY.  See the "
        "documentation\n"
        "for more details, or visit http://www.gnu.org/licenses/gpl-2.0.txt\n"
        "\n");

    fflush(stdout);
}

static void ShowVersion() {
    StdOutPrintf("%s %s \"%s\" Build %s\n", OBSIDIAN_TITLE.c_str(),
               OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str(), OBSIDIAN_VERSION);

    fflush(stdout);
}

void Determine_WorkingPath(std::filesystem::path &path_check) {
    // firstly find the "Working directory" : that's the place where
    // the CONFIG.txt and LOGS.txt files are, as well the temp files.

    if (const int home_arg = argv::Find(0, "home"); home_arg >= 0) {
        if (home_arg + 1 >= argv::list.size() || argv::IsOption(home_arg + 1)) {
            StdErrPrintf("OBSIDIAN ERROR: missing path for --home\n");
            exit(EXIT_FAILURE);
        }

        home_dir = std::filesystem::u8path(argv::list[home_arg + 1]);
        return;
    }

#ifdef _WIN32
    home_dir = path_check;
    home_dir.remove_filename();
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
// FLTK is going to want a ~/.config directory as well I think - Dasho
#ifdef __OpenBSD__
    std::filesystem::path config_checker = std::getenv("HOME");
    config_checker /= ".config";
    if (!std::filesystem::exists(config_checker)) {
        std::filesystem::create_directory(config_checker);
    }
#endif
    // try to create it (doesn't matter if it already exists)
    if (!std::filesystem::exists(home_dir)) {
        std::filesystem::create_directory(home_dir);
    }
#endif
    if (home_dir.empty()) {
        home_dir = std::filesystem::canonical(".");
    }
}

std::filesystem::path Resolve_DefaultOutputPath() {
    if (default_output_path.empty()) {
        default_output_path = install_dir;
    }
    if (default_output_path.generic_u8string()[0] == '$') {
        const char *var = getenv(default_output_path.generic_u8string().c_str() + 1);
        if (var != nullptr) {
            return var;
        }
    }
    return default_output_path;
}

static bool Verify_InstallDir(const std::filesystem::path &path) {
    const std::filesystem::path filename = path / "scripts" / "obsidian.lua";

    return exists(filename);
}

void Determine_InstallDir(std::filesystem::path &path_check) {
    // secondly find the "Install directory", and store the
    // result in the global variable 'install_dir'.  This is
    // where all the LUA scripts and other data files are.

    if (const int inst_arg = argv::Find(0, "install"); inst_arg >= 0) {
        if (inst_arg + 1 >= argv::list.size() || argv::IsOption(inst_arg + 1)) {
            StdErrPrintf("OBSIDIAN ERROR: missing path for --install\n");
            exit(EXIT_FAILURE);
        }

        install_dir = std::filesystem::u8path(argv::list[inst_arg + 1]);

        if (Verify_InstallDir(install_dir)) {
            return;
        }

        Main::FatalError("Bad install directory specified!\n");
    }

    // if run from current directory, look there
    if (path_check == "." && Verify_InstallDir(".")) {
        install_dir = std::filesystem::canonical(".");
        return;
    }

#ifdef WIN32
    install_dir = home_dir;
#else
    if (Verify_InstallDir(OBSIDIAN_INSTALL_PREFIX "/share/obsidian")) {
        return;
    }

    // Last resort
    if (Verify_InstallDir(std::filesystem::canonical("."))) {
        install_dir = std::filesystem::canonical(".");
    }
#endif

    if (install_dir.empty()) {
        Main::FatalError("Unable to find Obsidian's install directory!\n");
    }
}

void Determine_ConfigFile() {
    if (const int conf_arg = argv::Find(0, "config"); conf_arg >= 0) {
        if (conf_arg + 1 >= argv::list.size() || argv::IsOption(conf_arg + 1)) {
            StdErrPrintf("OBSIDIAN ERROR: missing path for --config\n");
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
            StdErrPrintf("OBSIDIAN ERROR: missing path for --options\n");
            exit(EXIT_FAILURE);
        }

        options_file = argv::list[optf_arg + 1];
    } else {
        options_file /= home_dir;
        options_file /= OPTIONS_FILENAME;
    }
}

void Determine_LoggingFile() {
    if (const int logf_arg = argv::Find(0, "log"); logf_arg >= 0) {
        if (logf_arg + 1 >= argv::list.size() || argv::IsOption(logf_arg + 1)) {
            StdErrPrintf("OBSIDIAN ERROR: missing path for --log\n");
            exit(EXIT_FAILURE);
        }

        logging_file = std::filesystem::u8path(argv::list[logf_arg + 1]);

        // test that it can be created
        std::ofstream fp{logging_file};

        if (!fp.is_open()) {
            Main::FatalError("Cannot create log file: %s\n",
                             logging_file.u8string().c_str());
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

bool Main::BackupFile(const std::filesystem::path &filename) {
    if (std::filesystem::exists(filename)) {
        std::filesystem::path backup_name = filename;

        backup_name.replace_extension(StringFormat(
            "%s.%s", backup_name.filename().extension().string().c_str(), "bak"));

        LogPrintf("Backing up existing file to: %s\n", backup_name.u8string().c_str());

        std::filesystem::remove(backup_name);
        std::filesystem::rename(filename, backup_name);
    }

    return true;
}

void Main::Detail::Shutdown(const bool error) {
#ifndef CONSOLE_ONLY
    if (!std::filesystem::exists(options_file)) {
        Options_Save(options_file);
    }
#else
    if (!std::filesystem::exists(options_file)) {
        Options_Save(options_file);
    }
#endif
    Script_Close();
    LogClose();
}

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
            next_rand_seed = StringHash64(string_seed);
        }
    }
    xoshiro_Reseed(next_rand_seed);
    std::string seed = NumToString(next_rand_seed);
    ob_set_config("seed", seed.c_str());
#ifndef CONSOLE_ONLY

#endif
}

//------------------------------------------------------------------------

bool Build_Cool_Shit() {

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
        } else {
            Main::FatalError("ERROR: unknown format: '%s'\n", format.c_str());
        }
    }

    const std::string def_filename = ob_default_filename();

    const uint32_t start_time = TimeGetMillies();
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

    if (was_ok) {
        // run the scripts Scotty!
        was_ok = ob_build_cool_shit();

        was_ok = game_object->Finish(was_ok);
    }
    if (was_ok) {
        Main::ProgStatus(_("Success"));

        const uint32_t end_time = TimeGetMillies();
        const uint32_t total_time = end_time - start_time;

        LogPrintf("\nTOTAL TIME: %g seconds\n\n", total_time / 1000.0);

        string_seed.clear();
    } else {
        string_seed.clear();
    }

    // Insurance in case the build process errored/cancelled
    ZIPF_CloseWrite();
    if (!was_ok)
    {
        if (std::filesystem::exists(game_object->Filename())) {
            std::filesystem::remove(game_object->Filename());
        }
        if (std::filesystem::exists(game_object->ZIP_Filename())) {
            std::filesystem::remove(game_object->ZIP_Filename());
        }
    }

    // don't need game object anymore
    delete game_object;
    game_object = NULL;

    return was_ok;
}

void Options_ParseArguments() {

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
    argv::Init(argc, argv);

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
            StdErrPrintf(
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
            StdErrPrintf(
                       "OBSIDIAN ERROR: missing one or more args for --update "
                       "<section> <key> <value>\n");
            exit(EXIT_FAILURE);
        }
        if (argv::list[update_arg + 1].length() > 1) {
            StdErrPrintf(
                       "OBSIDIAN ERROR: section name must be one character\n");
            exit(EXIT_FAILURE);
        }
        char section = argv::list[update_arg + 1][0];
        if (section != 'c' && section != 'o') {
            StdErrPrintf(
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

    std::filesystem::path path_check = std::filesystem::u8path(argv::list[0]);
    Determine_WorkingPath(path_check);
    Determine_InstallDir(path_check);

    Determine_ConfigFile();
    Determine_OptionsFile();
    Determine_LoggingFile();

    Options_Load(options_file);

    Options_ParseArguments();

    LogInit(logging_file);


    // accept -t and --terminal for backwards compatibility
    if (argv::Find('v', "verbose") >= 0 || argv::Find('t', "terminal") >= 0) {
        LogEnableTerminal(true);
    }

    LogPrintf("\n");
    LogPrintf("********************************************************\n");
    LogPrintf("** %s %s \"%s\" **\n", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION,
              OBSIDIAN_CODE_NAME.c_str());
    LogPrintf("** Build %s **\n", OBSIDIAN_VERSION);
    LogPrintf("********************************************************\n");
    LogPrintf("\n");

    LogPrintf("home_dir: %s\n", home_dir.u8string().c_str());
    LogPrintf("install_dir: %s\n", install_dir.u8string().c_str());
    LogPrintf("config_file: %s\n\n", config_file.u8string().c_str());

    Trans_Init();

    if (!batch_mode) {
        Trans_SetLanguage();
        OBSIDIAN_TITLE = _("OBSIDIAN Level Maker");
        OBSIDIAN_CODE_NAME = _("Unstable");
    }

    if (argv::Find('d', "debug") >= 0) {
        debug_messages = true;
    }
// Grab current numeric locale
#ifdef __APPLE__
    numeric_locale =
        setlocale(LC_NUMERIC, NULL);
#elif __unix__
#ifndef __linux__
    numeric_locale =
        setlocale(LC_NUMERIC, NULL);
#else
    numeric_locale =
        std::setlocale(LC_NUMERIC, NULL);
#endif
#else
    numeric_locale =
        std::setlocale(LC_NUMERIC, NULL);
#endif

    LogEnableDebug(debug_messages);


    Main_CalcNewSeed();

    std::string load_file;

    //TX_TestSynth(next_rand_seed); - Fractal testing stuff

    VFS_InitAddons(install_dir);

    if (const int load_arg = argv::Find('l', "load"); load_arg >= 0) {
        if (load_arg + 1 >= argv::list.size() ||
            argv::IsOption(load_arg + 1)) {
            StdErrPrintf(
                        "OBSIDIAN ERROR: missing filename for --load\n");
            exit(EXIT_FAILURE);
        }

        load_file = argv::list[load_arg + 1];
    }

    if (batch_mode) {
        VFS_ParseCommandLine();

        Script_Open();

        // inform Lua code about batch mode (the value doesn't matter)
        ob_set_config("batch", "yes");

        if (mature_word_lists) {
            ob_set_config("mature_words", "yes");
        } else {
            ob_set_config("mature_words", "no");
        }

        if (!load_file.empty()) {
            if (!Cookie_Load(load_file)) {
                Main::FatalError(_("No such config file: %s\n"), load_file.c_str());
            }
        } else {
            if (!std::filesystem::exists(config_file)) {
                Cookie_Save(config_file);
            }
            if (!Cookie_Load(config_file)) {
                Main::FatalError(_("No such config file: %s\n"), config_file.c_str());
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
            StdErrPrintf(
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
            StdErrPrintf("FAILED!\n");
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
        StringFormat("%s %s \"%s\"", OBSIDIAN_TITLE.c_str(), OBSIDIAN_SHORT_VERSION,
                    OBSIDIAN_CODE_NAME.c_str());

    // this not only finds PK3 files, but also activates the ones specified
    // in OPTIONS.txt
    VFS_ScanForAddons();
    VFS_ParseCommandLine();
    VFS_ScanForPresets();

    Script_Open();

    ob_set_config("locale", selected_lang.c_str());

    if (mature_word_lists) {
        ob_set_config("mature_words", "yes");
    } else {
        ob_set_config("mature_words", "no");
    }

    // load config after creating window (will set widget values)
    if (!Cookie_Load(config_file)) {
        LogPrintf("Missing config file -- using defaults.\n\n");
    }

    if (!load_file.empty()) {
        if (!Cookie_Load(load_file)) {
            Main::FatalError(_("No such config file: %s\n"), load_file.c_str());
        }
    }

    Cookie_ParseArguments();

    ob_set_config("filename_prefix", "datetime");

    // GUI goes here lol

    Main::Detail::Shutdown(false);

    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
