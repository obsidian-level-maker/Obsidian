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
        t_language = StringDup(value);
    } else if (StringCaseCmp(name, "font_theme") == 0) {
        font_theme = atoi(value);
    } else if (StringCaseCmp(name, "widget_theme") == 0) {
        widget_theme = atoi(value);
    } else if (StringCaseCmp(name, "box_theme") == 0) {
        box_theme = atoi(value);
    } else if (StringCaseCmp(name, "button_theme") == 0) {
        button_theme = atoi(value);
    } else if (StringCaseCmp(name, "single_pane") == 0) {
        single_pane = atoi(value) ? true : false;
	} else if (StringCaseCmp(name, "color_scheme") == 0) {
        color_scheme = atoi(value);
	} else if (StringCaseCmp(name, "text_red") == 0) {
        text_red = atoi(value);
	} else if (StringCaseCmp(name, "text_green") == 0) {
        text_green = atoi(value);  
	} else if (StringCaseCmp(name, "text_blue") == 0) {
        text_blue = atoi(value);
	} else if (StringCaseCmp(name, "bg_red") == 0) {
        bg_red = atoi(value);
	} else if (StringCaseCmp(name, "bg_green") == 0) {
        bg_green = atoi(value);  
	} else if (StringCaseCmp(name, "bg_blue") == 0) {
        bg_blue = atoi(value);
	} else if (StringCaseCmp(name, "bg2_red") == 0) {
        bg2_red = atoi(value);
	} else if (StringCaseCmp(name, "bg2_green") == 0) {
        bg2_green = atoi(value);  
	} else if (StringCaseCmp(name, "bg2_blue") == 0) {
        bg2_blue = atoi(value);         
    } else if (StringCaseCmp(name, "create_backups") == 0) {
        create_backups = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "overwrite_warning") == 0) {
        overwrite_warning = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "debug_messages") == 0) {
        debug_messages = atoi(value) ? true : false;
    } else if (StringCaseCmp(name, "last_directory") == 0) {
        last_directory = StringDup(value);
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

    fprintf(option_fp, "-- OPTIONS FILE : OBSIDIAN %s\n", OBSIDIAN_VERSION);
    fprintf(option_fp,
            "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fprintf(option_fp, "-- " OBSIDIAN_WEBSITE "\n\n");

    fprintf(option_fp, "language = %s\n", t_language);
    fprintf(option_fp, "\n");

    fprintf(option_fp, "font_theme      = %d\n", font_theme);
    fprintf(option_fp, "widget_theme      = %d\n", widget_theme);
    fprintf(option_fp, "box_theme      = %d\n", box_theme);
    fprintf(option_fp, "button_theme      = %d\n", button_theme);
    fprintf(option_fp, "single_pane = %d\n", single_pane ? 1 : 0);
    fprintf(option_fp, "color_scheme      = %d\n", color_scheme);
    fprintf(option_fp, "text_red      = %d\n", text_red);
    fprintf(option_fp, "text_green      = %d\n", text_green);
    fprintf(option_fp, "text_blue      = %d\n", text_blue);
    fprintf(option_fp, "bg_red      = %d\n", bg_red);
    fprintf(option_fp, "bg_green      = %d\n", bg_green);
    fprintf(option_fp, "bg_blue      = %d\n", bg_blue);
    fprintf(option_fp, "bg2_red      = %d\n", bg2_red);
    fprintf(option_fp, "bg2_green      = %d\n", bg2_green);
    fprintf(option_fp, "bg2_blue      = %d\n", bg2_blue);
    fprintf(option_fp, "\n");

    fprintf(option_fp, "create_backups = %d\n", create_backups ? 1 : 0);
    fprintf(option_fp, "overwrite_warning = %d\n", overwrite_warning ? 1 : 0);
    fprintf(option_fp, "debug_messages = %d\n", debug_messages ? 1 : 0);

    if (last_directory) {
        fprintf(option_fp, "\n");
        fprintf(option_fp, "last_directory = %s\n", last_directory);
    }

    fprintf(option_fp, "\n");

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
    UI_CustomMenu *opt_font_theme;
    UI_CustomMenu *opt_widget_theme;
    UI_CustomMenu *opt_box_theme;
    UI_CustomMenu *opt_button_theme;

    UI_CustomCheckBox *opt_single_pane;
    UI_CustomMenu *opt_color_scheme;
    Fl_Button *opt_text_color;
    Fl_Button *opt_bg_color;
    Fl_Button *opt_bg2_color;

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
            const char *fullname = Trans_GetAvailLanguage(i);

            if (!fullname) {
                break;
            }

            opt_language->add(fullname);

            // check for match against current language
            const char *lc = Trans_GetAvailCode(i);

            if (strcmp(lc, t_language) == 0) {
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
            if (!t_language) {
                t_language = "AUTO";
            }
        }
    }

    static void callback_FontTheme(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        font_theme = that->opt_font_theme->value();
    }
    
    static void callback_WidgetTheme(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        widget_theme = that->opt_widget_theme->value();
    }
    
    static void callback_BoxTheme(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        box_theme = that->opt_box_theme->value();
    }
    
    static void callback_ButtonTheme(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        button_theme = that->opt_button_theme->value();
    }
   
    static void callback_SinglePane(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        single_pane = that->opt_single_pane->value() ? true : false;
    }

    static void callback_ColorScheme(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;

        color_scheme = that->opt_color_scheme->value();
    }
    
    static void callback_TextColor(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;     
        if (fl_color_chooser((const char *)"Select Text Color", text_red, text_green, text_blue, 1)) {
    		that->opt_text_color->color(fl_rgb_color(text_red, text_green, text_blue));
    		that->opt_text_color->redraw();
    	}
    }
    
    static void callback_BgColor(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;     
        if (fl_color_chooser((const char *)"Select BG Color", bg_red, bg_green, bg_blue, 1)) {
    		that->opt_bg_color->color(fl_rgb_color(bg_red, bg_green, bg_blue));
    		that->opt_bg_color->redraw();
    	}
    }
    
    static void callback_Bg2Color(Fl_Widget *w, void *data) {
        UI_OptionsWin *that = (UI_OptionsWin *)data;       
        if (fl_color_chooser((const char *)"Select BG2 Color", bg2_red, bg2_green, bg2_blue, 1)) {
    		that->opt_bg2_color->color(fl_rgb_color(bg2_red, bg2_green, bg2_blue));
    		that->opt_bg2_color->redraw();
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
    int cy = y() + y_step;

    Fl_Box *heading;

    heading = new Fl_Box(FL_NO_BOX, x() + pad, cy, W - pad * 2, kf_h(24),
                         _("Appearance"));
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(font_style | FL_BOLD);
    heading->labelsize(header_font_size);

    cy += heading->h();

    opt_language =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Language: "));
    opt_language->align(FL_ALIGN_LEFT);
    opt_language->callback(callback_Language, this);
    opt_language->labelfont(font_style);
	opt_language->textfont(font_style);

    PopulateLanguages();

    cy += opt_language->h() + y_step;

    opt_font_theme =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Font: "));
    opt_font_theme->align(FL_ALIGN_LEFT);
    opt_font_theme->add(_("Default|Courier|Times"));
    opt_font_theme->callback(callback_FontTheme, this);
    opt_font_theme->value(font_theme);
    opt_font_theme->labelfont(font_style);
    opt_font_theme->textfont(font_style);

    cy += opt_font_theme->h() + y_step;
    
    opt_widget_theme =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Widget Theme: "));
    opt_widget_theme->align(FL_ALIGN_LEFT);
    opt_widget_theme->add(_("Default|Gleam|Win95|Plastic"));
    opt_widget_theme->callback(callback_WidgetTheme, this);
    opt_widget_theme->value(widget_theme);
    opt_widget_theme->labelfont(font_style);
    opt_widget_theme->textfont(font_style);

    cy += opt_widget_theme->h() + y_step;
    
    opt_box_theme =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Box Theme: "));
    opt_box_theme->align(FL_ALIGN_LEFT);
    opt_box_theme->add(_("Default|Shadow|Embossed|Engraved|Inverted|Flat"));
    opt_box_theme->callback(callback_BoxTheme, this);
    opt_box_theme->value(box_theme);
    opt_box_theme->labelfont(font_style);
    opt_box_theme->textfont(font_style);

    cy += opt_box_theme->h() + y_step;
    
    opt_button_theme =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Button Theme: "));
    opt_button_theme->align(FL_ALIGN_LEFT);
    opt_button_theme->add(_("Default|Embossed|Engraved|Inverted|Flat"));
    opt_button_theme->callback(callback_ButtonTheme, this);
    opt_button_theme->value(button_theme);
    opt_button_theme->labelfont(font_style);
    opt_button_theme->textfont(font_style);

    cy += opt_button_theme->h() + y_step;

    opt_color_scheme =
        new UI_CustomMenu(136 + KF * 40, cy, kf_w(130), kf_h(24), _("Color Scheme: "));
    opt_color_scheme->align(FL_ALIGN_LEFT);
    opt_color_scheme->add(_("Default|System Colors|Custom"));
    opt_color_scheme->callback(callback_ColorScheme, this);
    opt_color_scheme->value(color_scheme);
    opt_color_scheme->labelfont(font_style);
    opt_color_scheme->textfont(font_style);

    cy += opt_color_scheme->h() + y_step;
    
    opt_text_color = new Fl_Button(cx, cy, W * .25, kf_h(24),
                                       _("Font"));
    opt_text_color->visible_focus(0);
    opt_text_color->box(FL_DOWN_BOX);
    opt_text_color->color(fl_rgb_color(text_red, text_green, text_blue));
    opt_text_color->align(FL_ALIGN_BOTTOM);
    opt_text_color->callback(callback_TextColor, this);
    opt_text_color->labelfont(font_style);

    opt_bg_color = new Fl_Button(cx + opt_text_color->w() +  (3 * pad), cy, W * .25, kf_h(24),
                                       _("Panels"));
    opt_bg_color->visible_focus(0);
    opt_bg_color->box(FL_DOWN_BOX);
    opt_bg_color->color(fl_rgb_color(bg_red, bg_green, bg_blue));
    opt_bg_color->align(FL_ALIGN_BOTTOM);
    opt_bg_color->callback(callback_BgColor, this);
    opt_bg_color->labelfont(font_style);
    
    opt_bg2_color = new Fl_Button(cx + (opt_text_color->w() + (3 * pad)) * 2, cy, W * .25, kf_h(24),
                                       _("Highlights"));
    opt_bg2_color->visible_focus(0);
    opt_bg2_color->box(FL_DOWN_BOX);
    opt_bg2_color->color(fl_rgb_color(bg2_red, bg2_green, bg2_blue));
    opt_bg2_color->align(FL_ALIGN_BOTTOM);
    opt_bg2_color->callback(callback_Bg2Color, this);
    opt_bg2_color->labelfont(font_style);

    cy += opt_text_color->h() + y_step * 3;

    opt_single_pane = new UI_CustomCheckBox(cx, cy, W - cx - pad, kf_h(24),
                                       _(" Single Pane Mode"));
    opt_single_pane->value(single_pane ? 1 : 0);
    opt_single_pane->callback(callback_SinglePane, this);
    opt_single_pane->labelfont(font_style);
    opt_single_pane->selection_color(SELECTION);
    opt_single_pane->down_box(button_style);

    //----------------

    cy += y_step * 4;

    heading = new Fl_Box(FL_NO_BOX, x() + pad, cy, W - pad * 2, kf_h(24),
                         _("File Options"));
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(font_style | FL_BOLD);
    heading->labelsize(header_font_size);

    cy += heading->h() + y_step;

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
    //darkish->color(fl_darker(WINDOW_BG), fl_darker(WINDOW_BG));
    {
        // finally add an "Close" button

        Fl_Button *button = new Fl_Button(bx, by, bw, bh, fl_close);
        button->box(button_style);
        button->callback(callback_Quit, this);
        button->labelfont(font_style);
    }
    darkish->end();

    // restart needed warning
    heading = new Fl_Box(FL_NO_BOX, x() + pad, H - dh - kf_h(10), W - pad * 2,
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
    static UI_OptionsWin *option_window = NULL;

    if (!option_window) {
        int opt_w = kf_w(350);
        int opt_h = kf_h(500);

        option_window =
            new UI_OptionsWin(opt_w, opt_h, _("OBSIDIAN Misc Options"));
    }

    option_window->want_quit = false;
    option_window->set_modal();
    option_window->show();

    // run the GUI until the user closes
    while (!option_window->WantQuit()) {
        Fl::wait();
    }

    option_window->set_non_modal();
    option_window->hide();

    // save the options now
    Options_Save(options_file);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
