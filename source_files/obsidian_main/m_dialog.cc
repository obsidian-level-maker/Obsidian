//----------------------------------------------------------------------
//  DIALOG when all fucked up
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

#include <FL/fl_utf8.h>

#include <iostream>
#include <limits>
#include <string>

#ifdef WIN32
#include <iso646.h>
#endif

#include "fmt/core.h"
#include "fmt/format.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "m_lua.h"
#include "miniz.h"

std::filesystem::path last_directory;

// from main.h
std::string default_output_path;

static int dialog_result;

static void dialog_close_CB(Fl_Widget *w, void *data) { dialog_result = 1; }

#define BTN_W kf_w(100)
#define BTN_H kf_h(30)

#define ICON_W kf_w(40)
#define ICON_H ICON_W

#define FONT_SIZE (18 + KF * 2)

static void DialogShowAndRun(const char *message, const char *title,
                             const char *link_title, const char *link_url) {
    dialog_result = 0;

    // determine required size
    int mesg_W = kf_w(480);  // NOTE: fl_measure will wrap to this!
    int mesg_H = 0;

    fl_font(FL_HELVETICA, FONT_SIZE);
    fl_measure(message, mesg_W, mesg_H);

    if (mesg_W < kf_w(200)) {
        mesg_W = kf_w(200);
    }

    if (mesg_H < ICON_H) {
        mesg_H = ICON_H;
    }

    // add a little wiggle room
    mesg_W += kf_w(16);
    mesg_H += kf_h(8);

    int total_W = ICON_W + mesg_W + kf_w(30);
    int total_H = mesg_H + BTN_H + kf_h(30);

    if (link_title) {
        total_H += FONT_SIZE + kf_h(10);
    }

    // create window...
    Fl_Window *dialog = new Fl_Window(0, 0, total_W, total_H, title);

    dialog->end();
    dialog->size_range(total_W, total_H, total_W, total_H);
    dialog->callback((Fl_Callback *)dialog_close_CB);

    // create the error icon...
    Fl_Box *icon = new Fl_Box(kf_w(10), kf_h(15), ICON_W, ICON_H, "!");

    icon->box(FL_OVAL_BOX);
    icon->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    icon->color(FL_RED, FL_RED);
    icon->labelfont(use_system_fonts ? font_style : font_style | FL_BOLD);
    icon->labelsize(24 + KF * 3);
    icon->labelcolor(FL_WHITE);

    dialog->add(icon);

    // create the message area...
    Fl_Box *box =
        new Fl_Box(ICON_W + kf_w(20), kf_h(10), mesg_W, mesg_H, message);

    box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
    box->labelfont(font_style);
    box->labelsize(FONT_SIZE);

    dialog->add(box);

    // create the hyperlink...
    if (link_title) {
        SYS_ASSERT(link_url);

        UI_HyperLink *link =
            new UI_HyperLink(ICON_W + kf_w(20), kf_h(10) + mesg_H, mesg_W, 24,
                             link_title, link_url);
        link->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT);
        link->labelfont(font_style);
        link->labelsize(FONT_SIZE);

        dialog->add(link);
    }

    // create button...
    Fl_Button *button =
        new Fl_Button(total_W - BTN_W - kf_w(20), total_H - BTN_H - kf_h(12),
                      BTN_W, BTN_H, fl_close);

    button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    button->callback((Fl_Callback *)dialog_close_CB);
    button->labelfont(font_style);
    //  button->labelsize(FONT_SIZE - 2);

    dialog->add(button);

    // show time!
    dialog->set_modal();
    dialog->show();

    fl_beep();

    // run the GUI and let user make their choice
    while (dialog_result == 0) {
        Fl::wait();
    }

    // delete window (automatically deletes child widgets)
    delete dialog;
}

static void ParseHyperLink(char *buffer, unsigned int buf_len,
                           const char **link_title, const char **link_url) {
    // the syntax for a hyperlink is similar to HTML :-
    //    <a http://blah.blah.org/foobie.html>Title</a>

    char *pos = strstr(buffer, "<a ");

    if (!pos) {
        return;
    }

    // terminate the rest of the message here
    pos[0] = '\n';
    pos[1] = 0;

    pos += 3;

    *link_url = pos;

    pos = strstr(pos, ">");

    if (!pos) {  // malformed : oh well
        return;
    }

    // terminate the URL here
    pos[0] = 0;

    pos++;

    *link_title = pos;

    pos = strstr(pos, "<");

    if (pos) {
        pos[0] = 0;
    }
}

void DLG_ShowError(const char *msg, ...) {
    static char buffer[MSG_BUF_LEN];

    va_list arg_pt;

    va_start(arg_pt, msg);
    vsnprintf(buffer, MSG_BUF_LEN - 1, msg, arg_pt);
    va_end(arg_pt);

    buffer[MSG_BUF_LEN - 2] = 0;

    LogPrintf("\n{}\n\n", buffer);

    const char *link_title = NULL;
    const char *link_url = NULL;

    // handle error messages with a hyperlink at the end
    ParseHyperLink(buffer, sizeof(buffer), &link_title, &link_url);

    if (!batch_mode) {
        DialogShowAndRun(buffer, _("OBSIDIAN - Error Message"), link_title,
                         link_url);
    }
}

//----------------------------------------------------------------------

static std::filesystem::path BestDirectory() {
    if (!last_directory.empty()) {
        return last_directory;
    } else {
        return Resolve_DefaultOutputPath();
    }
}

std::filesystem::path DLG_OutputFilename(const char *ext, const char *preset) {
    std::string kind_buf = fmt::format("{} {}\t*.{}", ext, _("files"), ext);

    // uppercase the first word
    for (char *p = &kind_buf[0]; *p && *p != ' '; p++) {
        *p = toupper(*p);
    }

    // save and restore the font height
    // (because FLTK's own browser get totally borked)
    int old_font_h = FL_NORMAL_SIZE;
    FL_NORMAL_SIZE = 14 + KF;

    Fl_Native_File_Chooser chooser;

    chooser.title(_("Select output file"));
    chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);

    if (overwrite_warning) {
        chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
    }

    chooser.filter(kind_buf.c_str());

    auto best_dir = BestDirectory();

    if (preset) {
        chooser.preset_file((best_dir / preset).generic_string().c_str());
    } else {
        chooser.directory(best_dir.generic_string().c_str());
    }

    int result = chooser.show();

    FL_NORMAL_SIZE = old_font_h;

    switch (result) {
        case -1:
            LogPrintf(_("Error choosing output file:\n"));
            LogPrintf("   {}\n", chooser.errmsg());

            DLG_ShowError(_("Unable to create the file:\n\n%s"),
                          chooser.errmsg());
            return "";

        case 1:  // cancelled
            return "";

        default:
            break;  // OK
    }

    std::filesystem::path src_name = chooser.filename();

    std::filesystem::path dir_name = src_name.parent_path();

    if (!dir_name.empty()) {
        last_directory = dir_name;
    }

#ifdef WIN32
    // add extension if missing
    if (src_name.extension().empty()) {
        src_name.replace_extension(ext);

        // check if exists, ask for confirmation
        if (std::filesystem::exists(src_name)) {
            if (!fl_choice("%s", fl_cancel, fl_ok, NULL,
                           Fl_Native_File_Chooser::file_exists_message)) {
                return "";  // cancelled
            }
        }
    }
    src_name = ucs4_path(src_name.generic_string().c_str());
    src_name.replace_extension(
        ext);  // Ucs4 conversion sometimes goofs the extension
#endif
    return src_name;
}

//----------------------------------------------------------------------cout

void DLG_EditSeed(void) {
    ;

    const char *user_buf =
        fl_input(_("Enter New Seed Number or Phrase:"),
                 string_seed.empty() ? std::to_string(next_rand_seed).c_str()
                                     : string_seed.c_str());

    // cancelled?
    if (!user_buf) {
        return;
    }

    std::string word = user_buf;
    try {
        for (long unsigned int i = 0; i < word.size(); i++) {
            char character = word.at(i);
            if (not std::isdigit(character)) {
                throw std::runtime_error(
                    // clang-format off
                    _("String contains non-digits. Will process as string\n"));
                // clang-format on
            }
        }
        did_specify_seed = true;
        next_rand_seed = std::stoull(word);
        return;
    } catch (std::invalid_argument &e) {
        std::cout << _("Invalid argument. Will process as string.\n");
    } catch (std::out_of_range &e) {
        // clang-format off
        std::cout << _("Resulting number would be out of range. Will process as string.\n");
        // clang-format on
    } catch (std::exception &e) {
        std::cout << e.what();
    }
    string_seed = word;
    ob_set_config("string_seed", word.c_str());
    unsigned long long split_limit =
        (std::numeric_limits<long long>::max() /
         127);  // It is intentional that I am using the max for signed - Dasho
    next_rand_seed = split_limit;
    for (size_t i = 0; i < word.size(); i++) {
        char character = word.at(i);
        if (not std::iscntrl(character)) {
            if (next_rand_seed < split_limit) {
                next_rand_seed *= abs(int(character));
            } else {
                next_rand_seed /= abs(int(character));
            }
        }
    }
    did_specify_seed = true;
    return;
}

//----------------------------------------------------------------------

class UI_LogViewer : public Fl_Double_Window {
   private:
    bool want_quit;

    Fl_Multi_Browser *browser;

    Fl_Button *copy_but;

   public:
    UI_LogViewer(int W, int H, const char *l);
    virtual ~UI_LogViewer();

    bool WantQuit() const { return want_quit; }

    void Add(std::string_view line);

    // ensure the very last line is visible
    void JumpEnd();

    void ReadLogs();

    void WriteLogs(std::ofstream &fp);

   private:
    int CountSelectedLines() const;

    std::string GetSelectedText() const;

    static void quit_callback(Fl_Widget *, void *);
    static void save_callback(Fl_Widget *, void *);
    static void select_callback(Fl_Widget *, void *);
    static void copy_callback(Fl_Widget *, void *);
};

UI_LogViewer::UI_LogViewer(int W, int H, const char *l)
    : Fl_Double_Window(W, H, l), want_quit(false) {
    box(FL_NO_BOX);

    size_range(W * 3 / 4, H * 3 / 4);

    callback(quit_callback, this);

    int ey = h() - kf_h(65);

    browser = new Fl_Multi_Browser(0, 0, w(), ey);
    browser->color(WINDOW_BG);
    browser->scrollbar.slider(button_style);
    browser->scrollbar.color(GAP_COLOR, BUTTON_COLOR);
    browser->box(button_style);
    browser->textcolor(FONT_COLOR);
    browser->textfont(font_style);
    browser->textsize(small_font_size);
    browser->callback(select_callback, this);

    // disable the special '@' formatting
    // [ should be zero here, but in FLTK 1.3.4 it causes garbage to be
    //   displayed.  LogReadLines() ensures 0x7f chars are removed. ]
    browser->format_char(0x7f);

    resizable(browser);

    int button_w = kf_w(80);
    int button_h = kf_h(35);

    int button_y = ey + (kf_h(65) - button_h) / 2;

    {
        Fl_Group *o = new Fl_Group(0, ey, w(), h() - ey);
        o->box(FL_FLAT_BOX);

        int bx = w() - button_w - kf_w(25);
        int bx2 = bx;
        {
            Fl_Button *but =
                new Fl_Button(bx, button_y, button_w, button_h, fl_close);
            but->box(button_style);
            but->visible_focus(0);
            but->color(BUTTON_COLOR);
            but->labelfont(use_system_fonts ? font_style
                                            : font_style | FL_BOLD);
            but->labelcolor(FONT2_COLOR);
            but->callback(quit_callback, this);
        }

        bx = kf_w(25);
        {
            Fl_Button *but =
                new Fl_Button(bx, button_y, button_w, button_h, _("Save"));
            but->box(button_style);
            but->visible_focus(0);
            but->color(BUTTON_COLOR);
            but->labelcolor(FONT2_COLOR);
            but->callback(save_callback, this);
            but->labelfont(font_style);
        }

        bx += kf_w(140);
        {
            copy_but =
                new Fl_Button(bx, button_y, button_w, button_h, _("Copy"));
            copy_but->box(button_style);
            copy_but->visible_focus(0);
            copy_but->color(BUTTON_COLOR);
            copy_but->labelcolor(FONT2_COLOR);
            copy_but->callback(copy_callback, this);
            copy_but->shortcut(FL_CTRL + 'c');
            copy_but->deactivate();
            copy_but->labelfont(font_style);
        }

        bx += button_w + 10;

        Fl_Group *resize_box =
            new Fl_Group(bx + 10, ey + 2, bx2 - bx - 20, h() - ey - 4);
        resize_box->box(FL_NO_BOX);

        o->resizable(resize_box);

        o->end();
    }

    end();
}

UI_LogViewer::~UI_LogViewer() {}

void UI_LogViewer::JumpEnd() {
    if (browser->size() > 0) {
        browser->bottomline(browser->size());
    }
}

int UI_LogViewer::CountSelectedLines() const {
    int count = 0;

    for (int i = 1; i <= browser->size(); i++) {
        if (browser->selected(i)) {
            count++;
        }
    }

    return count;
}

std::string UI_LogViewer::GetSelectedText() const {
    std::string buf;

    for (int i = 1; i <= browser->size(); i++) {
        if (!browser->selected(i)) {
            continue;
        }

        std::string line_text = browser->text(i);
        if (line_text.empty()) {
            continue;
        }

        buf.append(line_text).append("\n");
    }

    return buf;
}

void UI_LogViewer::Add(std::string_view line) { browser->add(line.data()); }

static void logviewer_display_func(std::string_view line, void *priv_data) {
    UI_LogViewer *log_viewer = (UI_LogViewer *)priv_data;

    log_viewer->Add(line);
}

void UI_LogViewer::ReadLogs() {
    LogReadLines(logviewer_display_func, (void *)this);
}

void UI_LogViewer::WriteLogs(std::ofstream &fp) {
    for (int n = 1; n <= browser->size(); n++) {
        const char *str = browser->text(n);

        if (str) {
            fmt::print(fp, "{}\n", str);
        }
    }
}

void UI_LogViewer::quit_callback(Fl_Widget *w, void *data) {
    UI_LogViewer *that = (UI_LogViewer *)data;

    that->want_quit = true;
}

void UI_LogViewer::select_callback(Fl_Widget *w, void *data) {
    UI_LogViewer *that = (UI_LogViewer *)data;

    // require 2 or more lines to activate Copy button
    if (that->CountSelectedLines() >= 2) {
        that->copy_but->activate();
    } else {
        that->copy_but->deactivate();
    }
}

void UI_LogViewer::copy_callback(Fl_Widget *w, void *data) {
    UI_LogViewer *that = (UI_LogViewer *)data;

    std::string text = that->GetSelectedText();

    if (text[0]) {
        Fl::copy(text.c_str(), text.size(), 1);
    }
}

void UI_LogViewer::save_callback(Fl_Widget *w, void *data) {
    UI_LogViewer *that = (UI_LogViewer *)data;

    Fl_Native_File_Chooser chooser;

    chooser.title(_("Pick file to save to"));
    chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);

    if (overwrite_warning) {
        chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
    }

    chooser.filter("Text files\t*.txt");

tryagain:;

    if (!last_directory.empty()) {
        chooser.directory(last_directory.generic_string().c_str());
    }

    switch (chooser.show()) {
        case -1:
            DLG_ShowError(_("Unable to save the file:\n\n%s"),
                          chooser.errmsg());
            return;

        case 1:
            // cancelled
            return;

        default:
            break;  // OK
    }

    std::filesystem::path filename = chooser.filename();

    // add an extension if missing
    if (!filename.has_extension()) {
        filename.replace_extension(".txt");
    }

    if (std::filesystem::exists(filename)) {
        // clang-format off
        switch (fl_choice(_("%s already exists.\nChoose Yes to overwrite or No to choose a new filename."),
                          _("Yes"), 
                          _("No"), 0,
                          // clang-format on
                          filename.generic_string().c_str())) {
            case 0:
                std::filesystem::remove(filename);
                break;
            case 1:
                goto tryagain;
                break;
        }
    }

    if (filename.extension() != ".txt") {
        DLG_ShowError(_("Please choose a filename ending in .txt"));
        goto tryagain;
    }

    std::ofstream fp{filename};

    if (!fp) {
        filename = strerror(errno);

        DLG_ShowError(_("Unable to save the file:\n\n%s"), filename.c_str());
        return;
    }

    that->WriteLogs(fp);

    fp.close();
}

void DLG_ViewLogs(void) {
    int log_w = kf_w(560);
    int log_h = kf_h(380);

    UI_LogViewer *log_viewer =
        new UI_LogViewer(log_w, log_h, _("OBSIDIAN Log Viewer"));

    log_viewer->ReadLogs();

    log_viewer->set_modal();
    log_viewer->show();

    // run the dialog until the user closes it
    while (!log_viewer->WantQuit()) {
        Fl::wait();
    }

    delete log_viewer;
}

void DLG_ViewGlossary(void) {
    Fl_Window *win = new Fl_Window(640, 480, _("OBSIDIAN Glossary"));
    Fl_Text_Buffer *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp =
        new Fl_Text_Display(20, 20, 640 - 40, 480 - 40, NULL);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("This glossary's main purpose is for translators to have a space to provide longer definitions for terms that may not have a direct equivalent to their English counterparts.\n\nIf there is a need for an English version, this will be populated in the future."));
    // clang-format on
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
