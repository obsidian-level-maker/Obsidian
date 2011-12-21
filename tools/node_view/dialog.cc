//------------------------------------------------------------------------
//  DIALOG : Pop-up dialog boxes
//------------------------------------------------------------------------
//
//  GL-Node Viewer (C) 2004-2007 Andrew Apted
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
#include "defs.h"


static Fl_Window *cur_diag;
static int cur_diag_result;
static bool cur_diag_done;
static const char *cur_diag_guess_name;

static int pref_dialog_x = -1;
static int pref_dialog_y = -1;


static void dialog_closed_CB(Fl_Widget *w, void *data)
{
  cur_diag_result = -1;
  cur_diag_done = true;
}

static void dialog_left_button_CB(Fl_Widget *w, void *data)
{
  cur_diag_result = 0;
  cur_diag_done = true;
}

static void dialog_middle_button_CB(Fl_Widget *w, void *data)
{
  cur_diag_result = 1;
  cur_diag_done = true;
}

static void dialog_right_button_CB(Fl_Widget *w, void *data)
{
  cur_diag_result = 2;
  cur_diag_done = true;
}

static void dialog_file_browse_CB(Fl_Widget *w, void *data)
{
  Fl_Input *inp_box = (Fl_Input *) data;
  const char *new_name; 

  new_name = fl_file_chooser("Select the log file", "*.log",
      inp_box->value());

  // cancelled ?
  if (! new_name)
    return;

  inp_box->value(new_name);
}

static void dialog_file_guess_CB(Fl_Widget *w, void *data)
{
  Fl_Input *inp_box = (Fl_Input *) data;

  if (cur_diag_guess_name)
  {
    inp_box->value(cur_diag_guess_name);
  }
}


//------------------------------------------------------------------------

static void DialogRun()
{
  cur_diag->set_modal();
  cur_diag->show();

  // read initial pos (same logic as in Guix_MainWin)
  WindowSmallDelay();
  int init_x = cur_diag->x(); 
  int init_y = cur_diag->y();

  // run the GUI and let user make their choice
  while (! cur_diag_done)
  {
    Fl::wait();
  }

  // check if the user moved/resized the window
  if (cur_diag->x() != init_x || cur_diag->y() != init_y)
  {
    pref_dialog_x = cur_diag->x();
    pref_dialog_y = cur_diag->y();
  }
}


//
// DialogShowAndGetChoice
//
// The `pic' parameter is the picture to show on the left, or NULL for
// none.  The message can contain newlines.  The right/middle/left
// parameters allow up to three buttons.
//
// Returns the button number pressed (0 for right, 1 for middle, 2 for
// left) or -1 if escape was pressed or window manually closed.
// 
int DialogShowAndGetChoice(const char *title, Fl_Pixmap *pic, 
    const char *message, const char *left, // = "OK", 
    const char *middle, // = NULL,
    const char *right)  // = NULL)
{
  cur_diag_result = -1;
  cur_diag_done = false;

  int but_width = right ? (120*3) : middle ? (120*2) : (120*1);

  // determine required size
  int width = 120 * 3;
  int height;

  // set current font for fl_measure()
  fl_font(FL_HELVETICA, FL_NORMAL_SIZE);

  fl_measure(message, width, height);

  if (width < but_width)
    width = but_width;

  if (height < 16)
    height = 16;

  width  += 60 + 20 + 16;  // 16 extra, just in case
  height += 10 + 40 + 16;  // 

  // create window
  cur_diag = new Fl_Window(0, 0, width, height, title);
  cur_diag->end();
  cur_diag->size_range(width, height, width, height);
  cur_diag->callback((Fl_Callback *) dialog_closed_CB);

  if (pref_dialog_x >= 0)
    cur_diag->position(pref_dialog_x, pref_dialog_y);

  // set the resizable
  Fl_Box *box = new Fl_Box(60, 0, width - 3*120, height);
  cur_diag->add(box);
  cur_diag->resizable(box); 

  // create the image, if any
  if (pic)
  {
    box = new Fl_Box(5, 10, 50, 50);
    pic->label(box);
    cur_diag->add(box);
  }

  // create the message area
  box = new Fl_Box(60, 10, width-60 - 20, height-10 - 40, message);
  box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
  cur_diag->add(box);

  // create buttons
  Fl_Button *button;

  int CX = width - 120;
  int CY = height - 40;

  if (right)
  {
    button = new Fl_Return_Button(CX, CY, 104, 30, right);
    button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    button->callback((Fl_Callback *) dialog_right_button_CB);
    cur_diag->add(button);

    CX -= 120;
  }

  if (middle)
  {
    button = new Fl_Button(CX, CY, 104, 30, middle);
    button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    button->callback((Fl_Callback *) dialog_middle_button_CB);
    cur_diag->add(button);

    CX -= 120;
  }

  if (left)
  {
    button = new Fl_Button(CX, CY, 104, 30, left);
    button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    button->callback((Fl_Callback *) dialog_left_button_CB);
    cur_diag->add(button);

    CX -= 120;
  }

  // show time !
  DialogRun();

  // delete window (automatically deletes child widgets)
  delete cur_diag;
  cur_diag = NULL;

  return cur_diag_result;
}


//
// DialogQueryFilename
// 
// Shows the current filename (name_ptr) in an input box, and provides
// a browse button to choose a new filename, and an optional button to
// guess the new filename (if `guess_name' is NULL, then the button is
// disabled).
//
// This routine does NOT ensure that the filename is valid (or any
// other requirement, e.g. has a certain extension).
// 
// Returns 0 if "OK" was pressed, 1 if "Cancel" was pressed, or -1 if
// escape was pressed or the window was manually closed.
// 
int DialogQueryFilename(const char *message,
        const char ** name_ptr, const char *guess_name)
{
  cur_diag_result = -1;
  cur_diag_done = false;
  cur_diag_guess_name = guess_name;

  // determine required size
  int width = 400;
  int height;

  // set current font for fl_measure()
  fl_font(FL_HELVETICA, FL_NORMAL_SIZE);

  fl_measure(message, width, height);

  if (width < 400)
    width = 400;

  if (height < 16)
    height = 16;

  width  += 60 + 20 + 16;  // 16 extra, just in case
  height += 60 + 50 + 16;  // 

  // create window
  cur_diag = new Fl_Window(0, 0, width, height, PROG_NAME " Query");
  cur_diag->end();
  cur_diag->size_range(width, height, width, height);
  cur_diag->callback((Fl_Callback *) dialog_closed_CB);

  if (pref_dialog_x >= 0)
    cur_diag->position(pref_dialog_x, pref_dialog_y);

  // set the resizable
  Fl_Box *box = new Fl_Box(0, height-1, width, 1);
  cur_diag->add(box);
  cur_diag->resizable(box); 

  // create the message area
  box = new Fl_Box(14, 10, width-20 - 20, height-10 - 100, message);
  box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
  cur_diag->add(box);

  // create buttons

  int CX = width - 120;
  int CY = height - 50;

  Fl_Button *b_ok;
  Fl_Button *b_cancel;

  b_cancel = new Fl_Button(CX, CY, 104, 30, "Cancel");
  b_cancel->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  b_cancel->callback((Fl_Callback *) dialog_middle_button_CB);
  cur_diag->add(b_cancel);

  CX -= 120;

  b_ok = new Fl_Return_Button(CX, CY, 104, 30, "OK");
  b_ok->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
  b_ok->callback((Fl_Callback *) dialog_left_button_CB);
  cur_diag->add(b_ok);

  // create input box
  Fl_Input *inp_box;

  CX = width - 120;
  CY = height - 100;

  inp_box = new Fl_Input(20, CY, CX - 20 - 90, 26);
  inp_box->value(*name_ptr);
  cur_diag->add(inp_box);

  // create the browse and guess button
  Fl_Button *b_browse;
  Fl_Button *b_guess;

  b_guess = new Fl_Button(CX, CY, 70, 26, "Guess");
  b_guess->align(FL_ALIGN_INSIDE);
  b_guess->callback((Fl_Callback *) dialog_file_guess_CB, inp_box);
  cur_diag->add(b_guess);

  CX -= 85;

  b_browse = new Fl_Button(CX, CY, 80, b_guess->h(), "Browse");
  b_browse->align(FL_ALIGN_INSIDE);
  b_browse->callback((Fl_Callback *) dialog_file_browse_CB, inp_box);
  cur_diag->add(b_browse);

  // show time !
  DialogRun();

  if (cur_diag_result == 0)
  {
    UtilFree((void *) *name_ptr);

    *name_ptr = UtilStrDup(inp_box->value());
  }

  // delete window (automatically deletes child widgets)
  delete cur_diag;
  cur_diag = NULL;

  return cur_diag_result;
}


//
// GUI_FatalError
//
// Terminates the program reporting an error.
//
void GUI_FatalError(const char *str, ...)
{
  char buffer[2048];
  char main_err[2048];
  char *m_ptr;

  // create message
  va_list args;

  va_start(args, str);
  vsprintf(main_err, str, args);
  va_end(args);

  // remove leading and trailing whitespace
  int len = strlen(main_err);

  for (; len > 0 && isspace(main_err[len-1]); len--)
  {
    main_err[len-1] = 0;
  }

  for (m_ptr = main_err; isspace(*m_ptr); m_ptr++)
  { /* nothing else needed */ }

  sprintf(buffer,
      "The following unexpected error occurred:\n"
      "\n"
      "      %s\n"
      "\n"
      PROG_NAME " will now shut down.",
      m_ptr);

  DialogShowAndGetChoice(PROG_NAME " Fatal Error", 0, buffer);

  // Q/ save cookies ?  
  // A/ no, we save them before each build begins.

  exit(5);
}

