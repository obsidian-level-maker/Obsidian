//----------------------------------------------------------------------------
//  GLBSP interface
//----------------------------------------------------------------------------
// 
//  Oblige Level Maker (C) 2006 Andrew Apted
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
//----------------------------------------------------------------------------

#include "headers.h"
#include "lib_util.h"

// GLBSP interface header
#include "glbsp.h"

#include "g_glbsp.h"
#include "main.h"

#include "hdr_fltk.h"
#include "ui_build.h"
#include "ui_window.h"


static nodebuildinfo_t nb_info;
static volatile nodebuildcomms_t nb_comms;

static int display_mode = DIS_INVALID;

static char message_buf[MSG_BUF_LEN+4];


void GB_PrintMsg(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(message_buf, MSG_BUF_LEN, str, args);
	va_end(args);

	message_buf[MSG_BUF_LEN] = 0;

	// FIXME: logging / debug
	fprintf(stderr, "GLBSP: %s", message_buf);
}

//
// GB_FatalError
//
// Terminates the program reporting an error.
//
void GB_FatalError(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(message_buf, MSG_BUF_LEN, str, args);
	va_end(args);

	message_buf[MSG_BUF_LEN] = 0;

	Main_FatalError("%s", message_buf);
	/* NOT REACHED */
}

void GB_Ticker(void)
{
	Main_Ticker();

	if (main_win->action >= UI_MainWin::ABORT)
	{
		nb_comms.cancelled = TRUE;
	}
}

boolean_g GB_DisplayOpen(displaytype_e type)
{
	display_mode = type;
	return TRUE;
}

void GB_DisplaySetTitle(const char *str)
{
	/* does nothing */
}

void GB_DisplaySetText(const char *str)
{
	/* does nothing */
}

void GB_DisplaySetBarText(int barnum, const char *str)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 1)
	{
		/* IDEA: extract map name from 'str' */
	}
}

void GB_DisplaySetBarLimit(int barnum, int limit)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 2)
	{
		main_win->build_box->P_Begin(limit, true);
	}
}

void GB_DisplaySetBar(int barnum, int count)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 2)
	{
		main_win->build_box->P_Update(count);
	}
}

void GB_DisplayClose(void)
{
	main_win->build_box->P_Finish();
}

const nodebuildfuncs_t edge_build_funcs =
{
	GB_FatalError,
	GB_PrintMsg,
	GB_Ticker,

	GB_DisplayOpen,
	GB_DisplaySetTitle,
	GB_DisplaySetBar,
	GB_DisplaySetBarLimit,
	GB_DisplaySetBarText,
	GB_DisplayClose
};


bool GB_BuildNodes(const char *filename, const char *out_name)
{
	display_mode = DIS_INVALID;

	memcpy(&nb_info,  &default_buildinfo,  sizeof(default_buildinfo));
	memcpy((void*)&nb_comms, &default_buildcomms, sizeof(nodebuildcomms_t));

	nb_info.input_file  = GlbspStrDup(filename);
	nb_info.output_file = GlbspStrDup(out_name);

	nb_info.quiet = true;
	nb_info.pack_sides = true;

	glbsp_ret_e ret = GlbspCheckInfo(&nb_info, &nb_comms);

	if (ret != GLBSP_E_OK)
	{
		// FIXME: check info failed - do what??
		GB_PrintMsg("Param Check FAILED: %d\n", ret);
		GB_PrintMsg("- %s\n", nb_comms.message);

		return false;
	}

	ret = GlbspBuildNodes(&nb_info, &edge_build_funcs, &nb_comms);

	if (ret != GLBSP_E_OK)
	{
		// FIXME: build nodes failed - do what??
		GB_PrintMsg("Building FAILED: %d\n", ret);
		GB_PrintMsg("- %s\n\n", nb_comms.message);

		return false;
	}

	return true;
}

