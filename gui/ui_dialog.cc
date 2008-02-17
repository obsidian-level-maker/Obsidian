//------------------------------------------------------------------------
//  DIALOG when all fucked up
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

static int dialog_result;

static void dialog_close_CB(Fl_Widget *w, void *data)
{
  dialog_result = 1;
}

#define BTN_W  100
#define BTN_H  30

#define ICON_W  40
#define ICON_H  40

#define FONT_SIZE  18

static void
DialogShowAndRun(const char *message, const char *title)
{
  dialog_result = 0;

  // determine required size
  int mesg_W = 480;  // NOTE: fl_measure will wrap to this!
  int mesg_H = 0;

  fl_font(FL_HELVETICA, FONT_SIZE);
  fl_measure(message, mesg_W, mesg_H);

  if (mesg_W < 200)
    mesg_W = 200;

  if (mesg_H < ICON_H)
    mesg_H = ICON_H;

  // add a little wiggle room
  mesg_W += 16;
  mesg_H += 8;

  int total_W = 10 + ICON_W + 10 + mesg_W + 10;
  int total_H = 10 + mesg_H + 10 + BTN_H  + 10;

  // create window...
  Fl_Window *dialog = new Fl_Window(0, 0, total_W, total_H, title);

  dialog->end();
  dialog->size_range(total_W, total_H, total_W, total_H);
  dialog->callback((Fl_Callback *) dialog_close_CB);

  // create the error icon...
  Fl_Box *icon = new Fl_Box(10, 10, ICON_W, ICON_H, "!");
  
  icon->box(FL_OVAL_BOX);
  icon->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  icon->color(FL_RED, FL_RED);
  icon->labelfont(FL_HELVETICA_BOLD);
  icon->labelsize(24);
  icon->labelcolor(FL_WHITE);

  dialog->add(icon);

  // create the message area...
  Fl_Box *box = new Fl_Box(ICON_W + 20, 10, mesg_W, mesg_H, message);

  box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
  box->labelfont(FL_HELVETICA);
  box->labelsize(FONT_SIZE);

  dialog->add(box);

  // create button...
  Fl_Button *button =
    new Fl_Button(total_W - BTN_W - 20, total_H - BTN_H - 12,
               BTN_W, BTN_H, "Close");

  button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  button->callback((Fl_Callback *) dialog_close_CB);
//  button->labelsize(FONT_SIZE - 2);

  dialog->add(button);

  // show time!
  dialog->set_modal();
  dialog->show();

  // run the GUI and let user make their choice
  while (dialog_result == 0)
  {
    Fl::wait();
  }

  // delete window (automatically deletes child widgets)
  delete dialog;
}

void DLG_ShowError(const char *msg, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list arg_pt;

  va_start (arg_pt, msg);
  vsnprintf (buffer, MSG_BUF_LEN-1, msg, arg_pt);
  va_end (arg_pt);

  buffer[MSG_BUF_LEN-2] = 0;

  LogPrintf("\n%s\n", buffer);

  DialogShowAndRun(buffer, "Oblige - Error Message");
}


//------------------------------------------------------------------------

#define EXT_FONT_SIZE  16

static void dialog_useit_CB(Fl_Widget *w, void *data)
{
  dialog_result = EXDLG_UseDetected;
}

static void dialog_findman_CB(Fl_Widget *w, void *data)
{
  dialog_result = EXDLG_FindManually;
}

static int
ExtractDialog_ShowAndRun(const char *message, const char *title, bool detected)
{
  dialog_result = 0;

  // determine required size
  int mesg_W = 480;  // NOTE: fl_measure will wrap to this!
  int mesg_H = 0;

  fl_font(FL_HELVETICA, EXT_FONT_SIZE);
  fl_measure(message, mesg_W, mesg_H);

  if (mesg_W < 200)
    mesg_W = 200;

  if (mesg_H < ICON_H)
    mesg_H = ICON_H;

  // add a little wiggle room
  mesg_W += 16;
  mesg_H += 8;

  int total_W = 10 + ICON_W + 10 + mesg_W + 10;
  int total_H = 10 + mesg_H + 20 + BTN_H  + 10;

  // create window...
  Fl_Window *dialog = new Fl_Window(0, 0, total_W, total_H, title);

  dialog->end();
  dialog->size_range(total_W, total_H, total_W, total_H);
  dialog->callback((Fl_Callback *) dialog_close_CB);

  // create the error icon...
  Fl_Box *icon = new Fl_Box(10, 10, ICON_W, ICON_H, "?");  ///  "!"
  
  icon->box(FL_UP_BOX);
  icon->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  icon->color(FL_YELLOW, FL_YELLOW);
  icon->labelfont(FL_HELVETICA_BOLD);
  icon->labelsize(24);
  icon->labelcolor(FL_BLUE);

  dialog->add(icon);

  // create the message area...
  Fl_Box *box = new Fl_Box(ICON_W + 20, 10, mesg_W, mesg_H, message);

  box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
  box->labelfont(FL_HELVETICA);
  box->labelsize(EXT_FONT_SIZE);

  dialog->add(box);

  // create buttons...
  int cx = total_W - BTN_W - 20;

  Fl_Button *button;

  button = new Fl_Button(cx, total_H - BTN_H - 12, BTN_W, BTN_H, "Find Manually");

  button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  button->callback((Fl_Callback *) dialog_findman_CB);

  dialog->add(button);

  cx -= 120;

  if (detected)
  {
    button = new Fl_Button(cx, total_H - BTN_H - 12, BTN_W, BTN_H, "Use Detected");

    button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    button->labelfont(FL_HELVETICA_BOLD);
    button->callback((Fl_Callback *) dialog_useit_CB);

    dialog->add(button);

    cx -= 120;
  }

  button = new Fl_Button(cx, total_H - BTN_H - 12, BTN_W, BTN_H, "Cancel");

  button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  button->callback((Fl_Callback *) dialog_close_CB);
//button->labelcolor(FL_RED);

  dialog->add(button);

  // show time!
  dialog->set_modal();
  dialog->show();

  // run the GUI and let user make their choice
  while (dialog_result == 0)
  {
    Fl::wait();
  }

  // delete window (automatically deletes child widgets)
  delete dialog;

  return dialog_result;
}


#if 0
static const char * extract_Text =
  Oblige needs to extract $(DATATYPE) from the game's
  data files in order to make $(GAME) levels.

  The game data is usually stored in a file called
  $(FILE)
  "pak0.pak" in a folder called "id1"
  where $(GAME) is installed.

  Oblige has detected an existing $(GAME) installation
  on your computer in the following location:
  [C:\QUAKE\ID1\PAK0.PAK]

  Do you want to use this location?
OR
  Oblige has looked for an existing $(GAME) installation
  but did not find it.  Please find it yourself by clicking
  on the Find Manually button.

  
  (ABORT)  (USE DETECTED)  (FIND MANUALLY)
;
#endif


int DLG_ExtractStuff(extract_info_t *info)
{
  static char top[2000];
  static char bottom[1000];
  static char loc_str[200];
  static char title[200];

  if (info->dir)
    sprintf(loc_str, " in a folder called \"%s\"", info->dir);
  else
    loc_str[0] = 0;

  sprintf(top,
      "Oblige needs to extract %s from the game's "
      "data files in order to make %s levels.\n"
      "\n"
      "The game data is normally stored in a file called \"%s\"%s "
      "where %s is installed\n"
      "\n",
      info->type, info->game, info->file, loc_str, info->game);

  if (info->detected)
  {
    sprintf(bottom,

        "Oblige has detected an existing %s installation "
        "on your computer in the following location:\n"
        "\n"
        "%s\n"
        "\n"
        "Do you want to use this location?",
        info->game, info->detected);
  }
  else
  {
    sprintf(bottom,
        "Oblige did not find any existing %s installation. "
        "Please locate the \"%s\" file by clicking "
        "on the Find Manually button.",
        info->game, info->file);
  }

  strcat(top, bottom);

  sprintf(title, "Oblige - %s Setup", info->game);

  return ExtractDialog_ShowAndRun(top, title, info->detected ? true : false);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
