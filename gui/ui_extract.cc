//------------------------------------------------------------------------
//  EXTRACTION Wizard
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


static bool dialog_done;

static void DialogCallback(Fl_Widget *w, void *data)
{
  dialog_done = true;
}

#define BTN_W  100
#define BTN_H  30

#define ICON_W  40
#define ICON_H  40


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
