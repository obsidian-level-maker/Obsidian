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
#include "icon.h"

#include "csg_main.h"
#include "g_nukem.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_argv.h"
#include "lib_file.h"
#include "lib_signal.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "twister.h"
#include "tx_forge.h"

#define TICKER_TIME 50 /* ms */

const char *home_dir = NULL;
const char *install_dir = NULL;

const char *config_file = NULL;
const char *options_file = NULL;
const char *theme_file = NULL;
const char *logging_file = NULL;

int screen_w;
int screen_h;

int main_action;

unsigned long long next_rand_seed;

bool batch_mode = false;
const char *batch_output_file = NULL;

// options
uchar text_red = 0;
uchar text_green = 0;
uchar text_blue = 0;
uchar bg_red = 221;
uchar bg_green = 221;
uchar bg_blue = 221;
uchar bg2_red = 62;
uchar bg2_green = 61;
uchar bg2_blue = 57;
uchar button_red = 0;
uchar button_green = 0;
uchar button_blue = 0;
uchar gradient_red = 221;
uchar gradient_green = 221;
uchar gradient_blue = 221;
uchar border_red = 62;
uchar border_green = 61;
uchar border_blue = 57;
uchar gap_red = 62;
uchar gap_green = 61;
uchar gap_blue = 57;
Fl_Color FONT_COLOR;
Fl_Color SELECTION;
Fl_Color WINDOW_BG;
Fl_Color GAP_COLOR;
Fl_Color GRADIENT_COLOR;
Fl_Color BUTTON_COLOR;
Fl_Color BORDER_COLOR;
int color_scheme = 0;
int font_theme = 0;
Fl_Font font_style = FL_HELVETICA;
int box_theme = 0;
Fl_Boxtype box_style = FL_THIN_UP_BOX;
int button_theme = 0;
Fl_Boxtype button_style = FL_THIN_UP_BOX;
int widget_theme = 0;
bool single_pane = false;
int window_scaling = 0;
int font_scaling = 0;
int filename_prefix = 0;
int num_fonts = 16; // FLTK built-in amount
std::vector<std::map<std::string, int>> font_menu_items;

bool create_backups = true;
bool overwrite_warning = true;
bool debug_messages = false;

game_interface_c *game_object = NULL;

/* ----- user information ----------------------------- */

static void ShowInfo() {
    printf(
        "\n"
        "** " OBSIDIAN_TITLE " " OBSIDIAN_VERSION
        " **\n"
        "** Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted **\n"
        "\n");

    printf(
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

    printf(
        "Please visit the web site for complete information:\n"
        "  " OBSIDIAN_WEBSITE
        " \n"
        "\n");

    printf(
        "This program is free software, under the terms of the GNU General "
        "Public\n"
        "License, and comes with ABSOLUTELY NO WARRANTY.  See the "
        "documentation\n"
        "for more details, or visit http://www.gnu.org/licenses/gpl-2.0.txt\n"
        "\n");

    fflush(stdout);
}

static void ShowVersion() {
    printf("Obsidian version " OBSIDIAN_VERSION " (" __DATE__ ")\n");

    fflush(stdout);
}

void Determine_WorkingPath(const char *argv0) {
    // firstly find the "Working directory" : that's the place where
    // the CONFIG.txt and LOGS.txt files are, as well the temp files.

    int home_arg = ArgvFind(0, "home");

    if (home_arg >= 0) {
        if (home_arg + 1 >= arg_count || ArgvIsOption(home_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --home\n");
            exit(9);
        }

        home_dir = StringDup(arg_list[home_arg + 1]);
        return;
    }

#ifdef WIN32
    home_dir = GetExecutablePath(argv0);

#else
    char *path = StringNew(FL_PATH_MAX + 4);

    if (fl_filename_expand(path, "$HOME/.obsidian") == 0) {
        Main_FatalError("Unable to find $HOME directory!\n");
    }

    home_dir = path;

    // try to create it (doesn't matter if it already exists)
    if (home_dir) {
        FileMakeDir(home_dir);
    }
#endif

    if (!home_dir) {
        home_dir = StringDup(".");
    }
}

static bool Verify_InstallDir(const char *path) {
    const char *filename = StringPrintf("%s/scripts/oblige.lua", path);

#if 0  // DEBUG
	fprintf(stderr, "Trying install dir: [%s]\n", path);
	fprintf(stderr, "  using file: [%s]\n\n", filename);
#endif

    bool exists = FileExists(filename);

    StringFree(filename);

    return exists;
}

void Determine_InstallDir(const char *argv0) {
    // secondly find the "Install directory", and store the
    // result in the global variable 'install_dir'.  This is
    // where all the LUA scripts and other data files are.

    int inst_arg = ArgvFind(0, "install");

    if (inst_arg >= 0) {
        if (inst_arg + 1 >= arg_count || ArgvIsOption(inst_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --install\n");
            exit(9);
        }

        install_dir = StringDup(arg_list[inst_arg + 1]);

        if (Verify_InstallDir(install_dir)) {
            return;
        }

        Main_FatalError("Bad install directory specified!\n");
    }

    // if run from current directory, look there
    if (argv0[0] == '.' && Verify_InstallDir(".")) {
        install_dir = StringDup(".");
        return;
    }

#ifdef WIN32
    install_dir = StringDup(home_dir);

#else
    static const char *prefixes[] = {
        "/usr/local", "/usr", "/opt",

        NULL  // end of list
    };

    for (int i = 0; prefixes[i]; i++) {
        install_dir = StringPrintf("%s/share/obsidian", prefixes[i]);

        if (Verify_InstallDir(install_dir)) {
            return;
        }

        StringFree(install_dir);
        install_dir = NULL;
    }
#endif

    if (!install_dir) {
        Main_FatalError("Unable to find Obsidian's install directory!\n");
    }
}

void Determine_ConfigFile() {
    int conf_arg = ArgvFind(0, "config");

    if (conf_arg >= 0) {
        if (conf_arg + 1 >= arg_count || ArgvIsOption(conf_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --config\n");
            exit(9);
        }

        config_file = StringDup(arg_list[conf_arg + 1]);
    } else {
        config_file = StringPrintf("%s/%s", home_dir, CONFIG_FILENAME);
    }
}

void Determine_OptionsFile() {
    int optf_arg = ArgvFind(0, "options");

    if (optf_arg >= 0) {
        if (optf_arg + 1 >= arg_count || ArgvIsOption(optf_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --options\n");
            exit(9);
        }

        options_file = StringDup(arg_list[optf_arg + 1]);
    } else {
        options_file = StringPrintf("%s/%s", home_dir, OPTIONS_FILENAME);
    }
}

void Determine_ThemeFile() {
    int themef_arg = ArgvFind(0, "theme");

    if (themef_arg >= 0) {
        if (themef_arg + 1 >= arg_count || ArgvIsOption(themef_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --theme\n");
            exit(9);
        }

        theme_file = StringDup(arg_list[themef_arg + 1]);
    } else {
        theme_file = StringPrintf("%s/%s", home_dir, THEME_FILENAME);
    }
}

void Determine_LoggingFile() {
    int logf_arg = ArgvFind(0, "log");

    if (logf_arg >= 0) {
        if (logf_arg + 1 >= arg_count || ArgvIsOption(logf_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing path for --log\n");
            exit(9);
        }

        logging_file = StringDup(arg_list[logf_arg + 1]);

        // test that it can be created
        FILE *fp = fopen(logging_file, "w");

        if (!fp) {
            Main_FatalError("Cannot create log file: %s\n", logging_file);
        }

        fclose(fp);
    } else if (!batch_mode) {
        logging_file = StringPrintf("%s/%s", home_dir, LOG_FILENAME);
    } else {
        logging_file = NULL;
    }
}

bool Main_BackupFile(const char *filename, const char *ext) {
    if (FileExists(filename)) {
        char *backup_name = ReplaceExtension(filename, ext);

        LogPrintf("Backing up existing file to: %s\n", backup_name);

        FileDelete(backup_name);

        if (!FileRename(filename, backup_name)) {
            LogPrintf("WARNING: unable to rename file!\n");
            StringFree(backup_name);
            return false;
        }

        StringFree(backup_name);
    }

    return true;
}

int Main_DetermineScaling() {
    /* computation of the Kromulent factor */

    // command-line overrides
    if (ArgvFind(0, "tiny") >= 0) {
        return -1;
    }
    if (ArgvFind(0, "small") >= 0) {
        return 0;
    }
    if (ArgvFind(0, "medium") >= 0) {
        return 1;
    }
    if (ArgvFind(0, "large") >= 0) {
        return 2;
    }
    if (ArgvFind(0, "huge") >= 0) {
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

void Main_DetermineFontScaling() {

    switch(font_scaling) {
    	case 0 : FL_NORMAL_SIZE = 18;
    			 break;
    	case 1 : FL_NORMAL_SIZE = 14;
    			 break;
    	case 2 : FL_NORMAL_SIZE = 16;
    			 break;
    	case 3 : FL_NORMAL_SIZE = 20;
    			 break;
    	case 4 : FL_NORMAL_SIZE = 22;
    			 break;
    	default : FL_NORMAL_SIZE = 18;
    			  break;
   }

   small_font_size = FL_NORMAL_SIZE - 2;
   header_font_size = FL_NORMAL_SIZE + 2;

   fl_message_font(font_style, FL_NORMAL_SIZE + 2);
   
}

void Main_PopulateFontMap() {
	
	num_fonts = Fl::set_fonts(NULL) - 16; // Total fonts - FLTK enumerations
	
	for (int x = 16; x < num_fonts; x++) { // Starting at 16 skips the FLTK default enumerations
		std::string fontname = Fl::get_font_name(x);
		if (std::isalpha(fontname.at(0))) {
			std::map<std::string, int> temp_map { {fontname, x} };
			font_menu_items.push_back(temp_map);
		}
	}

	num_fonts = font_menu_items.size();	
		
}

void Main_SetupFLTK() {
	
	Main_PopulateFontMap();
	
    Fl::visual(FL_DOUBLE | FL_RGB);  
    switch(color_scheme) {
    	case 0 : Fl::background(221, 221, 221);
    			 Fl::background2(221, 221, 221);
    			 Fl::foreground(0, 0, 0);
				 FONT_COLOR = fl_rgb_color(0, 0, 0);
				 SELECTION = fl_rgb_color(62, 61, 57);
				 WINDOW_BG = fl_rgb_color(221, 221, 221);
				 GAP_COLOR = fl_rgb_color(0, 0, 0);
				 BORDER_COLOR = fl_rgb_color(62, 61, 57);
				 GRADIENT_COLOR = fl_rgb_color(221, 221, 221);
				 BUTTON_COLOR = fl_rgb_color(221, 221, 221);    
    			 break;
    	case 1 : Fl::get_system_colors();
    			 // Test with a Windows VM - Dasho
				 FONT_COLOR = FL_FOREGROUND_COLOR;
				 SELECTION = FL_BACKGROUND2_COLOR;
				 WINDOW_BG = FL_BACKGROUND_COLOR;
				 BUTTON_COLOR = FL_BACKGROUND_COLOR;
				 GAP_COLOR = FL_BACKGROUND2_COLOR;
				 BORDER_COLOR = FL_BACKGROUND2_COLOR;
				 GRADIENT_COLOR = FL_BACKGROUND2_COLOR;
    			 break;
    	case 2 : Fl::background(bg_red, bg_green, bg_blue);
    			 Fl::background2(bg_red, bg_green, bg_blue);
    			 Fl::foreground(text_red, text_green, text_blue);
				 FONT_COLOR = fl_rgb_color(text_red, text_green, text_blue);
				 SELECTION = fl_rgb_color(bg2_red, bg2_green, bg2_blue);
				 WINDOW_BG = fl_rgb_color(bg_red, bg_green, bg_blue);
    			 GAP_COLOR = fl_rgb_color(gap_red, gap_green, gap_blue); 
    			 BORDER_COLOR = fl_rgb_color(border_red, border_green, border_blue);     
    			 GRADIENT_COLOR = fl_rgb_color(gradient_red, gradient_green, gradient_blue);
    			 BUTTON_COLOR = fl_rgb_color(button_red, button_green, button_blue); 
    			 break;
    	// Shouldn't be reached, but still
    	default : Fl::background(221, 221, 221);
    			  Fl::background2(221, 221, 221);
    			  Fl::foreground(0, 0, 0);
				  FONT_COLOR = fl_rgb_color(0, 0, 0);
				  SELECTION = fl_rgb_color(62, 61, 57);
				  WINDOW_BG = fl_rgb_color(221, 221, 221);
				  GAP_COLOR = fl_rgb_color(0, 0, 0);
				  BORDER_COLOR = fl_rgb_color(62, 61, 57);
				  GRADIENT_COLOR = fl_rgb_color(221, 221, 221);
				  BUTTON_COLOR = fl_rgb_color(221, 221, 221);  
    			  break;    			     			 
    }
    if (color_scheme == 2) {
    Fl::get_color(FONT_COLOR, text_red, text_green, text_blue); 
    Fl::get_color(WINDOW_BG, bg_red, bg_green, bg_blue);     
    Fl::get_color(SELECTION, bg2_red, bg2_green, bg2_blue);
    Fl::get_color(GAP_COLOR, gap_red, gap_green, gap_blue); 
    Fl::get_color(BORDER_COLOR, border_red, border_green, border_blue);     
    Fl::get_color(GRADIENT_COLOR, gradient_red, gradient_green, gradient_blue);
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
    Fl::set_boxtype(FL_BORDER_BOX, crectbound, 1, 1, 2, 2);
    Fl::set_boxtype(FL_THIN_UP_BOX, cthin_up_box, 1, 1, 2, 2);
    Fl::set_boxtype(FL_EMBOSSED_BOX, cembossed_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_ENGRAVED_BOX, cengraved_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_DOWN_BOX, cdown_box, 2, 2, 4, 4);
    Fl::set_boxtype(FL_UP_BOX, cup_box, 2, 2, 4, 4);
    switch(widget_theme) {
    	case 0 : Fl::scheme("gtk+");
    			 break;
    	case 1 : Fl::scheme("gleam");
    			 break;
    	case 2 : Fl::scheme("base");
    			 break;
    	case 3 : Fl::scheme("plastic");
    			 break;
    	// Shouldn't be reached, but still
    	default : Fl::scheme("gtk+");
    			  break;    			     			 
    }   
    switch(box_theme) {
    	case 0 : box_style = FL_THIN_UP_BOX;
    			 break;
    	case 1 : box_style = FL_SHADOW_BOX;
    			 break;
    	case 2 : box_style = FL_EMBOSSED_BOX;
    			 break;
    	case 3 : box_style = FL_ENGRAVED_BOX;
    			 break;
    	case 4 : box_style = FL_DOWN_BOX;
    			 break;
    	case 5 : box_style = FL_FLAT_BOX;
    			 break;
    	// Shouldn't be reached, but still
    	default : box_style = FL_THIN_UP_BOX;
    			  break;    			     			 
    }    
    switch(button_theme) {
    	case 0 : button_style = FL_UP_BOX;
    			 break;
    	case 1 : button_style = FL_EMBOSSED_BOX;
    			 break;
    	case 2 : button_style = FL_ENGRAVED_BOX;
    			 break;
    	case 3 : button_style = FL_DOWN_BOX;
    			 break;
    	case 4 : button_style = FL_BORDER_BOX;
    			 break;
    	// Shouldn't be reached, but still
    	default : button_style = FL_UP_BOX;
    			  break;    			     			 
    } 			 
    if (font_theme < num_fonts) { // In case the number of installed fonts is reduced between launches
    	if (font_theme == 0) {
    		font_style = 0;
    	} else {
    		for (auto font = font_menu_items[font_theme - 1].begin(); font != font_menu_items[font_theme - 1].end(); ++font) {
    			font_style = font->second;
  			}
    	}
    } else {
    	// Fallback
    	font_style = 0;
    }
    
    screen_w = Fl::w();
    screen_h = Fl::h();

#if 0  // debug
	fprintf(stderr, "Screen dimensions = %dx%d\n", screen_w, screen_h);
#endif

    KF = Main_DetermineScaling();
    Main_DetermineFontScaling();
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

void Main_Ticker() {
    // This function is called very frequently.
    // To prevent a slow-down, we only call Fl::check()
    // after a certain time has elapsed.

    static u32_t last_millis = 0;

    u32_t cur_millis = TimeGetMillies();

    if ((cur_millis - last_millis) >= TICKER_TIME) {
        Fl::check();

        last_millis = cur_millis;
    }
}

void Main_Shutdown(bool error) {
    if (main_win) {
        // on fatal error we cannot risk calling into the Lua runtime
        // (it's state may be compromised by a script error).
        if (config_file && !error) {
            Cookie_Save(config_file);
        }

        delete main_win;
        main_win = NULL;
    }

    Script_Close();
    LogClose();
    ArgvClose();
}

void Main_FatalError(const char *msg, ...) {
    static char buffer[MSG_BUF_LEN];

    va_list arg_pt;

    va_start(arg_pt, msg);
    vsnprintf(buffer, MSG_BUF_LEN - 1, msg, arg_pt);
    va_end(arg_pt);

    buffer[MSG_BUF_LEN - 2] = 0;

    DLG_ShowError("%s", buffer);

    Main_Shutdown(true);

    if (batch_mode) {
        fprintf(stderr, "ERROR!\n");
    }

    exit(9);
}

void Main_ProgStatus(const char *msg, ...) {
    static char buffer[MSG_BUF_LEN];

    va_list arg_pt;

    va_start(arg_pt, msg);
    vsnprintf(buffer, MSG_BUF_LEN - 1, msg, arg_pt);
    va_end(arg_pt);

    buffer[MSG_BUF_LEN - 2] = 0;

    if (main_win) {
        main_win->build_box->SetStatus(buffer);
    } else if (batch_mode) {
        fprintf(stderr, "%s\n", buffer);
    }
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
    std::string label = "Seed: ";
    std::string seed = std::to_string(next_rand_seed);
    ob_set_config("seed", seed.c_str());
    if (!batch_mode) {
        main_win->build_box->seed_disp->copy_label(label.append(seed).c_str());
        main_win->build_box->seed_disp->redraw();
    }
}

static void Module_Defaults() {
    //ob_set_mod_option("small_spiderdemon", "self", "1");
    ob_set_mod_option("sky_generator", "self", "1");
    ob_set_mod_option("music_swapper", "self", "1");
}

//------------------------------------------------------------------------

bool Build_Cool_Shit() {
    // clear the map
    if (main_win) {
        main_win->build_box->mini_map->EmptyMap();
    }

    const char *format = ob_game_format();

    if (!format || strlen(format) == 0) {
        Main_FatalError("ERROR: missing 'format' for game?!?\n");
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
            Main_FatalError("ERROR: unknown format: '%s'\n", format);
        }
    }

    const char *def_filename = ob_default_filename();

    // lock most widgets of user interface
    if (main_win) {
        std::string label = "Seed: ";
        std::string seed = std::to_string(next_rand_seed);
        if (main_win->build_box->string_seed != "") {
		    main_win->build_box->seed_disp->copy_label(label.append(main_win->build_box->string_seed).c_str());
		    main_win->build_box->seed_disp->redraw();      
        } else {
		    main_win->build_box->seed_disp->copy_label(label.append(seed).c_str());
		    main_win->build_box->seed_disp->redraw();
        }
        main_win->game_box->SetAbortButton(true);
        main_win->build_box->SetStatus(_("Preparing..."));
        main_win->Locked(true);
    }

    u32_t start_time = TimeGetMillies();
    // this will ask for output filename (among other things)
    bool was_ok = game_object->Start(def_filename);

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
        Main_ProgStatus(_("Success"));

        u32_t end_time = TimeGetMillies();
        u32_t total_time = end_time - start_time;

        LogPrintf("\nTOTAL TIME: %1.2f seconds\n\n", total_time / 1000.0);
        
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

        Main_ProgStatus(_("Cancelled"));
    }

    // don't need game object anymore
    delete game_object;
    game_object = NULL;

    return was_ok;
}

// Apply theme changes without restarting hopefully

void Restyle() {
    main_win->color(GAP_COLOR, SELECTION);
	main_win->menu_bar->box(box_style);
    main_win->menu_bar->selection_color(SELECTION);
    main_win->game_box->box(box_style);
    main_win->game_box->game->selection_color(SELECTION);
    main_win->game_box->engine->selection_color(SELECTION);
    main_win->game_box->length->selection_color(SELECTION);
    main_win->game_box->theme->selection_color(SELECTION);
    main_win->game_box->build->box(button_style);
    main_win->game_box->build->color(BUTTON_COLOR);
    main_win->game_box->quit->box(button_style);
    main_win->game_box->quit->color(BUTTON_COLOR);
    main_win->build_box->box(box_style);
    main_win->build_box->redraw();
    main_win->left_mods->sbar->slider(button_style);
    main_win->left_mods->sbar->color(GAP_COLOR, BUTTON_COLOR);
    main_win->left_mods->sbar->labelcolor(SELECTION);
    if (main_win->right_mods) {
    	main_win->right_mods->color(GAP_COLOR, GAP_COLOR);
    	main_win->right_mods->sbar->slider(button_style);
    	main_win->right_mods->sbar->color(GAP_COLOR, BUTTON_COLOR);
    	main_win->right_mods->sbar->labelcolor(SELECTION);
    	main_win->right_mods->mod_pack->color(GAP_COLOR);
    	main_win->right_mods->redraw();
    }   
}

/* ----- main program ----------------------------- */

int main(int argc, char **argv) {
    // initialise argument parser (skipping program name)
    ArgvInit(argc - 1, (const char **)(argv + 1));

    if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0) {
        ShowInfo();
        exit(1);
    } else if (ArgvFind(0, "version") >= 0) {
        ShowVersion();
        exit(1);
    }

    int batch_arg = ArgvFind('b', "batch");
    if (batch_arg >= 0) {
        if (batch_arg + 1 >= arg_count || ArgvIsOption(batch_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing filename for --batch\n");
            exit(9);
        }

        batch_mode = true;
        batch_output_file = arg_list[batch_arg + 1];
    }

    Determine_WorkingPath(argv[0]);
    Determine_InstallDir(argv[0]);

    Determine_ConfigFile();
    Determine_OptionsFile();
    Determine_ThemeFile();
    Determine_LoggingFile();

    LogInit(logging_file);

    if (ArgvFind('d', "debug") >= 0) {
        debug_messages = true;
    }

    // accept -t and --terminal for backwards compatibility
    if (ArgvFind('v', "verbose") >= 0 || ArgvFind('t', "terminal") >= 0) {
        LogEnableTerminal(true);
    }

    LogPrintf("\n");
    LogPrintf("********************************************************\n");
    LogPrintf("** " OBSIDIAN_TITLE " " OBSIDIAN_VERSION " **\n");
    LogPrintf("********************************************************\n");
    LogPrintf("\n");

    LogPrintf("Library versions: FLTK %d.%d.%d\n\n", FL_MAJOR_VERSION,
              FL_MINOR_VERSION, FL_PATCH_VERSION);

    LogPrintf("   home_dir: %s\n", home_dir);
    LogPrintf("install_dir: %s\n", install_dir);
    LogPrintf("config_file: %s\n\n", config_file);

    Trans_Init();

    if (!batch_mode) {
        Options_Load(options_file);
        Theme_Options_Load(theme_file);
        Trans_SetLanguage();
        Main_SetupFLTK();
    }
    
    LogEnableDebug(debug_messages);

    twister_Init();

    Main_CalcNewSeed();
    
//	TX_TestSynth(next_rand_seed); - Fractal testing stuff

    VFS_InitAddons(argv[0]);

    const char *load_file = NULL;

    int load_arg = ArgvFind('l', "load");
    if (load_arg >= 0) {
        if (load_arg + 1 >= arg_count || ArgvIsOption(load_arg + 1)) {
            fprintf(stderr, "OBSIDIAN ERROR: missing filename for --load\n");
            exit(9);
        }

        load_file = arg_list[load_arg + 1];
    }

    if (batch_mode) {
        VFS_ParseCommandLine();

        Script_Open();

        // inform Lua code about batch mode (the value doesn't matter)
        ob_set_config("batch", "yes");

        Module_Defaults();

        // batch mode never reads/writes the normal config file.
        // but we can load settings from a explicitly specified file...
        if (load_file) {
            if (!Cookie_Load(load_file)) {
                Main_FatalError(_("No such config file: %s\n"), load_file);
            }
        }

        Cookie_ParseArguments();

        Main_SetSeed();
        if (!Build_Cool_Shit()) {
            fprintf(stderr, "FAILED!\n");
            LogPrintf("FAILED!\n");

            Main_Shutdown(false);
            return 3;
        }

        Main_Shutdown(false);
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

    const char *main_title =
        StringPrintf("%s %s", _(OBSIDIAN_TITLE), OBSIDIAN_VERSION);
    main_win = new UI_MainWin(main_w, main_h, main_title);
    
    // Set window icon
    fl_register_images();
    Fl_Pixmap program_icon(pixmap_icon);
    Fl_RGB_Image rgb_icon(&program_icon, FL_BLACK);
    main_win->default_icon(&rgb_icon);

    //???	Default_Location();

    Script_Open();

    // enable certain modules by default
    Module_Defaults();

    // load config after creating window (will set widget values)
    if (!Cookie_Load(config_file)) {
        LogPrintf("Missing config file -- using defaults.\n\n");
    }

    if (load_file) {
        if (!Cookie_Load(load_file)) {
            Main_FatalError(_("No such config file: %s\n"), load_file);
        }
    }

    Cookie_ParseArguments();

    // show window (pass some dummy arguments)
    {
        char *argv[2];
        argv[0] = strdup("Obsidian.exe");
        argv[1] = NULL;
        main_win->show(1 /* argc */, argv);
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

            if (main_action == MAIN_QUIT) {
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
    } catch (assert_fail_c err) {
        Main_FatalError(_("Sorry, an internal error occurred:\n%s"),
                        err.GetMessage());
    } catch (...) {
        Main_FatalError(_("An unknown problem occurred (UI code)"));
    }

    LogPrintf("\nQuit......\n\n");

	Theme_Options_Save(theme_file);
    Options_Save(options_file);

    Main_Shutdown(false);

    return 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
