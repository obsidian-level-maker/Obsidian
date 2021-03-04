//------------------------------------------------------------------------
//  HEADERS and DEFS
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

#ifndef __LM_HEADERS_H__
#define __LM_HEADERS_H__

//
//  SYSTEM INCLUDES
//
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <string.h>
#include <ctype.h>
#include <errno.h>

#include <math.h>
#include <limits.h>

#ifdef WIN32
#include <FL/x.H>
#else
#include <sys/time.h>
#endif

//
//  FLTK INCLUDES
//
#ifdef __MWERKS__
# define FL_DLL
#endif

#include <FL/Fl.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Browser.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Check_Button.H>
#include <FL/Fl_Counter.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Hold_Browser.H>
#include <FL/Fl_Image.H>
#include <FL/Fl_Input.H>
#include <FL/Fl_Menu_Bar.H>
#include <FL/Fl_Menu_Item.H>
#include <FL/Fl_Multiline_Output.H>
#include <FL/Fl_Multi_Browser.H>
#include <FL/Fl_Pack.H>
#include <FL/Fl_Pixmap.H>
#include <FL/Fl_Return_Button.H>
#include <FL/Fl_Round_Button.H>
#include <FL/Fl_Scrollbar.H>
#include <FL/Fl_Slider.H>
#ifdef MACOSX
#include <FL/Fl_Sys_Menu_Bar.H>
#endif
#include <FL/Fl_Text_Buffer.H>
#include <FL/Fl_Text_Editor.H>
#include <FL/Fl_Value_Input.H>
#include <FL/Fl_Widget.H>
#include <FL/Fl_Window.H>

#include <FL/fl_ask.H>
#include <FL/fl_draw.H>
#include <FL/fl_file_chooser.H>

//
//  LOCAL INCLUDES
//
#include "sys_type.h"
#include "sys_macro.h"
#include "sys_assert.h"

#include "lib_argv.h"
#include "lib_file.h"
#include "lib_util.h"

#include "e_chooser.h"
#include "e_dialog.h"
#include "e_editor.h"
#include "e_menu.h"
#include "e_status.h"
#include "e_window.h"

// 
// GLOBAL DEFS
//
#define PROG_NAME      "Tailor"
#define PROG_NAME_FULL "Tailor Lua Editor"

#define VERSION_STR  "0.30"
#define VERSION_HEX  0x030

#endif /* __LM_HEADERS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:expandtab
