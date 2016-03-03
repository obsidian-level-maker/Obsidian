//------------------------------------------------------------------------
//  MENU : Menu handling
//------------------------------------------------------------------------
//
//  Tailor Lua Editor  Copyright (C) 2008  Andrew Apted
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

// this includes everything we need
#include "headers.h"


static int last_line_num = -1;


#if 0
static void menu_quit_CB(Fl_Widget *w, void *data)
{
    menu_want_to_quit = true;
}
#endif


#ifndef MACOSX
void M_File_Quit(Fl_Widget *w, void * data)
{
    main_win->want_quit = true;
}
#endif


void M_File_New(Fl_Widget *w, void * data)
{
    // FIXME
}


void M_File_Open(Fl_Widget *w, void * data)
{
    // FIXME
}


void M_File_SaveAs(Fl_Widget *w, void * data)
{
    // FIXME
    // 
    // Select_Output_File()
    // main_win->ed->SetFilename(filename)
    // main_win->ed->Save();
}


void M_File_Save(Fl_Widget *w, void * data)
{
    if (main_win->ed->HasFilename())
        main_win->ed->Save();
    else
        M_File_SaveAs(w, data);
}


//------------------------------------------------------------------------

void M_Edit_Undo(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_undo('z' & 0x1f, main_win->ed);
}


void M_Edit_Cut(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_cut('x' & 0x1f, main_win->ed);
}


void M_Edit_Copy(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_copy('c' & 0x1f, main_win->ed);
}


void M_Edit_Paste(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_paste('v' & 0x1f, main_win->ed);
}


void M_Edit_Delete(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_delete(FL_Delete, main_win->ed);
}


void M_Edit_Find(Fl_Widget *w, void * data)
{
    // FIXME
}


void M_Edit_FindNext(Fl_Widget *w, void * data)
{
    // FIXME
}


void M_Edit_GotoLine(Fl_Widget *w, void * data)
{
    static char num_buffer[64];

    sprintf(num_buffer, "%d", last_line_num);

    const char *val = fl_input("Goto Line Number:", (last_line_num <= 0) ? num_buffer : NULL);
    if (! val)
        return;

    int num = atoi(val);
    if (num <= 0)
        return;

    last_line_num = num;

    if (! main_win->ed->GotoLine(num))
    {
        main_win->status->ShowError("No such line!");
    }
}


void M_Edit_SelectAll(Fl_Widget *w, void * data)
{
    Fl_Text_Editor::kf_select_all('a' & 0x1f, main_win->ed);
}


//------------------------------------------------------------------------

void M_Font_LightTheme(Fl_Widget *w, void * data)
{
    main_win->ed->SetDark(false);
}

void M_Font_DarkTheme(Fl_Widget *w, void * data)
{
    main_win->ed->SetDark(true);
}


void M_Font_Size10(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(10);
}

void M_Font_Size12(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(12);
}

void M_Font_Size14(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(14);
}

void M_Font_Size16(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(16);
}

void M_Font_Size18(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(18);
}

void M_Font_Size20(Fl_Widget *w, void * data)
{
    main_win->ed->SetFont(20);
}


//------------------------------------------------------------------------

void M_Help_About(Fl_Widget *w, void * data)
{
#if 0
    menu_want_to_quit = false;

    Fl_Window *ab_win = new Fl_Window(600, 340, "About " PROG_NAME);
    ab_win->end();

    // non-resizable
    ab_win->size_range(ab_win->w(), ab_win->h(), ab_win->w(), ab_win->h());
    ab_win->position(guix_prefs.manual_x, guix_prefs.manual_y);
    ab_win->callback((Fl_Callback *) menu_quit_CB);

    // add the about image
    Fl_Group *group = new Fl_Group(0, 0, 230, ab_win->h());
    group->box(FL_FLAT_BOX);
    group->color(FL_BLACK, FL_BLACK);
    ab_win->add(group);

    Fl_Box *box = new Fl_Box(20, 90, ABOUT_IMG_W+2, ABOUT_IMG_H+2);
    box->image(about_image);
    group->add(box); 


    // about text
    box = new Fl_Box(240, 60, 350, 270, about_Info);
    box->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);
    ab_win->add(box);


    // finally add an "OK" button
    Fl_Button *button = new Fl_Button(ab_win->w()-10-60, ab_win->h()-10-30, 
            60, 30, "OK");
    button->callback((Fl_Callback *) menu_quit_CB);
    ab_win->add(button);

    ab_win->set_modal();
    ab_win->show();

    // capture initial size

    int init_x = ab_win->x();
    int init_y = ab_win->y();

    // run the GUI until the user closes
    while (! menu_want_to_quit)
        Fl::wait();

    // check if the user moved/resized the window
    if (ab_win->x() != init_x || ab_win->y() != init_y)
    {
        guix_prefs.manual_x = ab_win->x();
        guix_prefs.manual_y = ab_win->y();
    }

    // this deletes all the child widgets too...
    delete ab_win;
#endif
}


//------------------------------------------------------------------------

#undef FCAL
#define FCAL  (Fl_Callback *)

static Fl_Menu_Item menu_items[] = 
{
  { "&File", 0, 0, 0, FL_SUBMENU },
    { "&New...",   FL_COMMAND + 'n', FCAL M_File_New },
    { "&Open...",  FL_COMMAND + 'o', FCAL M_File_Open },
    { "&Save",     FL_COMMAND + 's', FCAL M_File_Save },
    { "Save &As...", 0,              FCAL M_File_SaveAs, 0, FL_MENU_DIVIDER },
#ifndef MACOSX
    { "&Quit",     FL_COMMAND + 'q', FCAL M_File_Quit },
#endif
    { 0 },

  { "&Edit", 0, 0, 0, FL_SUBMENU },
    { "&Undo",   0,  FCAL M_Edit_Undo, 0, FL_MENU_DIVIDER },

    { "Cu&t",    0, FCAL M_Edit_Cut },
    { "&Copy",   0, FCAL M_Edit_Copy },
    { "&Paste",  0, FCAL M_Edit_Paste },
    { "&Delete", 0, FCAL M_Edit_Delete, 0, FL_MENU_DIVIDER },

    { "&Find...",      FL_COMMAND + 'f', FCAL M_Edit_Find },
    { "Find &Next",    FL_COMMAND + 'g', FCAL M_Edit_FindNext },
    { "&Goto Line...", FL_COMMAND + 'l', FCAL M_Edit_GotoLine },
    { "Select &All",   FL_COMMAND + 'a', FCAL M_Edit_SelectAll },
    { 0 },

  { "&Font", 0, 0, 0, FL_SUBMENU },
    { "&Light Theme", 0, FCAL M_Font_LightTheme },
    { "&Dark Theme",  0, FCAL M_Font_DarkTheme, 0, FL_MENU_DIVIDER },

    { "Size 10", 0, FCAL M_Font_Size10 },
    { "Size 12", 0, FCAL M_Font_Size12 },
    { "Size 14", 0, FCAL M_Font_Size14 },
    { "Size 16", 0, FCAL M_Font_Size16 },
    { "Size 18", 0, FCAL M_Font_Size18 },
    { "Size 20", 0, FCAL M_Font_Size20 },
    { 0 },

  { "&Help", 0, 0, 0, FL_SUBMENU },
    { "&About...",         0,  FCAL M_Help_About },
    { 0 },

  { 0 } // END OF MENU
};


//
// MenuCreate
//
#ifdef MACOSX
Fl_Sys_Menu_Bar * MenuCreate(int x, int y, int w, int h)
{
    Fl_Sys_Menu_Bar *bar = new Fl_Sys_Menu_Bar(x, y, w, h);
    bar->menu(menu_items);
    return bar;
}
#else
Fl_Menu_Bar * MenuCreate(int x, int y, int w, int h)
{
    Fl_Menu_Bar *bar = new Fl_Menu_Bar(x, y, w, h);
    bar->menu(menu_items);
    return bar;
}
#endif

//------------------------------------------------------------------------

#if 0  // from EDITOR.CXX

int check_save(void)
{
    if (!changed) return 1;

    int r = fl_choice("The current file has not been saved.\n"
            "Would you like to save it now?",
            "Cancel", "Save", "Don't Save");

    if (r == 1)
    {
        save_cb(); // Save the file...
        return !changed;
    }

    return (r == 2) ? 1 : 0;
}

int loading = 0;

char filename[256] = "";

void load_file(char *newfile, int ipos)
{
    loading = 1;
    int insert = (ipos != -1);
    changed = insert;
    if (!insert)
        strcpy(filename, "");

    int r;
    if (!insert)
        r = textbuf->loadfile(newfile);
    else
        r = textbuf->insertfile(newfile, ipos);

    if (r)
        fl_alert("Error reading from file \'%s\':\n%s.", newfile, strerror(errno));
    else
    {
        if (!insert)
            strcpy(filename, newfile);
    }

    loading = 0;
    textbuf->call_modify_callbacks();
}

void save_file(char *newfile)
{
    if (textbuf->savefile(newfile))
        fl_alert("Error writing to file \'%s\':\n%s.", newfile, strerror(errno));
    else
        strcpy(filename, newfile);
    changed = 0;
    textbuf->call_modify_callbacks();
}

void copy_cb(Fl_Widget*, void* v)
{
    EditorWindow* e = (EditorWindow*)v;
    Fl_Text_Editor::kf_copy(0, e->editor);
}

void cut_cb(Fl_Widget*, void* v)
{
    EditorWindow* e = (EditorWindow*)v;
    Fl_Text_Editor::kf_cut(0, e->editor);
}

void delete_cb(Fl_Widget*, void*)
{
    textbuf->remove_selection();
}

void set_title(Fl_Window* w)
{
    if (filename[0] == '\0')
        strcpy(title, "Untitled");
    else
    {
        char *slash = strrchr(filename, '/');
#ifdef WIN32
        if (slash == NULL)
            slash = strrchr(filename, '\\');
#endif
        if (slash != NULL)
            strcpy(title, slash + 1);
        else
            strcpy(title, filename);
    }

    if (changed)
        strcat(title, " (modified)");

    w->label(title);
}

void changed_cb(int, int nInserted, int nDeleted,int, const char*, void* v)
{
    if ((nInserted || nDeleted) && !loading)
        changed = 1;
    EditorWindow *w = (EditorWindow *)v;
    set_title(w);
    if (loading)
        w->editor->show_insert_position();
}

void new_cb(Fl_Widget*, void*)
{
    if (!check_save())
        return;

    filename[0] = '\0';
    textbuf->select(0, textbuf->length());
    textbuf->remove_selection();
    changed = 0;
    textbuf->call_modify_callbacks();
}

void open_cb(Fl_Widget*, void*)
{
    if (!check_save()) return;

    char *newfile = fl_file_chooser("Open File?", "*", filename);
    if (newfile != NULL)
        load_file(newfile, -1);
}

void insert_cb(Fl_Widget*, void *v)
{
    char *newfile = fl_file_chooser("Insert File?", "*", filename);
    EditorWindow *w = (EditorWindow *)v;
    if (newfile != NULL)
        load_file(newfile, w->editor->insert_position());
}

void paste_cb(Fl_Widget*, void* v)
{
    EditorWindow* e = (EditorWindow*)v;
    Fl_Text_Editor::kf_paste(0, e->editor);
}

void close_cb(Fl_Widget*, void* v)
{
    Fl_Window* w = (Fl_Window*)v;
    if (num_windows == 1 && !check_save())
    {
        return;
    }

    w->hide();
    textbuf->remove_modify_callback(changed_cb, w);
    delete w;
    num_windows--;
    if (!num_windows)
        exit(0);
}

void quit_cb(Fl_Widget*, void*)
{
    if (changed && !check_save())
        return;

    exit(0);
}

void replace_cb(Fl_Widget*, void* v)
{
    EditorWindow* e = (EditorWindow*)v;
    e->replace_dlg->show();
}

void save_cb()
{
    if (filename[0] == '\0')
    {
        // No filename - get one!
        saveas_cb();
        return;
    }
    else save_file(filename);
}

void saveas_cb()
{
    char *newfile;

    newfile = fl_file_chooser("Save File As?", "*", filename);
    if (newfile != NULL)
        save_file(newfile);
}

#endif

//--- editor settings ---
// vi:ts=4:sw=4:expandtab
