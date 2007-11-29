//------------------------------------------------------------------------
//  DEFINITIONS
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_DEFS_H__
#define __OBLIGE_DEFS_H__

#define PROG_NAME  "Oblige Viewer"

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
#include <time.h>

#ifdef WIN32
#include <FL/x.H>
#else
#include <sys/time.h>
#endif

//
//  STL INCLUDES
//
#include <vector>

//
//  FLTK INCLUDES
//
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
#include <FL/Fl_Value_Input.H>
#include <FL/Fl_Widget.H>
#include <FL/Fl_Window.H>

#include <FL/fl_ask.H>
#include <FL/fl_draw.H>
#include <FL/fl_file_chooser.H>

//
//  LOCAL INCLUDES
//
#include "system.h"
#include "u_assert.h"
#include "u_list.h"
#include "util.h"
#include "u_heap.h"

#include "name_gen.h"
#include "w_enums.h"
#include "world.h"
#include "environ.h"
#include "a_star.h"
#include "area.h"
#include "island.h"
#include "stage.h"
#include "path.h"
#include "room.h"

#include "l_block.h"
#include "l_cube.h"
#include "l_dstruct.h"
#include "l_dwad.h"
#include "l_doom.h"
#include "l_quake.h"
#include "l_wolf.h"

#include "g_dialog.h"
#include "g_menu.h"
#include "g_control.h"
#include "g_grid.h"
#include "g_window.h"

#endif /* __OBLIGE_DEFS_H__ */
