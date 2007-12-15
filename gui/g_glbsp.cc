//----------------------------------------------------------------------------
//  GLBSP interface
//----------------------------------------------------------------------------
// 
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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
#include "ui_window.h"


static nodebuildinfo_t nb_info;
static volatile nodebuildcomms_t nb_comms;

static int display_mode = DIS_INVALID;

static char message_buf[MSG_BUF_LEN];


static const char *GetErrorString(glbsp_ret_e ret)
{
  switch (ret)
  {
    case GLBSP_E_OK: return "OK";

    // the arguments were bad/inconsistent.
    case GLBSP_E_BadArgs: return "Bad Arguments";

    // the info was bad/inconsistent, but has been fixed
    case GLBSP_E_BadInfoFixed: return "Bad Args (fixed)";

    // file errors
    case GLBSP_E_ReadError:  return "Read Error";
    case GLBSP_E_WriteError: return "Write Error";

    // building was cancelled
    case GLBSP_E_Cancelled: return "Cancelled by User";

    // an unknown error occurred (this is the catch-all value)
    case GLBSP_E_Unknown:
    default:
      return "Unknown Error";
  }
}

void GB_PrintMsg(const char *str, ...)
{
  va_list args;

  va_start(args, str);
  vsnprintf(message_buf, MSG_BUF_LEN-1, str, args);
  va_end(args);

  message_buf[MSG_BUF_LEN-2] = 0;

  LogPrintf("GLBSP: %s", message_buf);
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
  vsnprintf(message_buf, MSG_BUF_LEN-1, str, args);
  va_end(args);

  message_buf[MSG_BUF_LEN-2] = 0;

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
    main_win->build_box->ProgBegin(2, limit);
  }
}

void GB_DisplaySetBar(int barnum, int count)
{
  if (display_mode == DIS_BUILDPROGRESS && barnum == 2)
  {
    main_win->build_box->ProgUpdate(count);
  }
}

void GB_DisplayClose(void)
{
  /* does nothing */
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
  LogPrintf("\n");
      
  display_mode = DIS_INVALID;

  memcpy(&nb_info,  &default_buildinfo,  sizeof(default_buildinfo));
  memcpy((void*)&nb_comms, &default_buildcomms, sizeof(nodebuildcomms_t));

  nb_info.input_file  = GlbspStrDup(filename);
  nb_info.output_file = GlbspStrDup(out_name);

  nb_info.quiet = true;

#if 0  // this is not supported by the Doomsday engine
  nb_info.pack_sides = true;
#endif

  glbsp_ret_e ret = GlbspCheckInfo(&nb_info, &nb_comms);

  if (ret != GLBSP_E_OK)
  {
    // check info failed (unlikely to happen)
    GB_PrintMsg("Param Check FAILED: %s\n", GetErrorString(ret));
    GB_PrintMsg("Reason: %s\n", nb_comms.message);

    return false;
  }

  ret = GlbspBuildNodes(&nb_info, &edge_build_funcs, &nb_comms);

  if (ret != GLBSP_E_OK)
  {
    // build nodes failed
    GB_PrintMsg("Building FAILED: %s\n", GetErrorString(ret));
    GB_PrintMsg("Reason: %s\n\n", nb_comms.message);

    return false;
  }

  return true;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
