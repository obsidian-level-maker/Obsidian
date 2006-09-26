//------------------------------------------------------------------------
//  File screen
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"

#include "ui_chooser.h"
#include "lib_util.h"

static char *last_file;

void Default_Location()
{
  last_file = StringNew(FL_PATH_MAX + 4);

#if 0 // ifdef WIN32
  // don't include a path.  Hence GetSaveFileName() will go to
  // the default place.
  last_file[0] = 0;
#else
  fl_filename_absolute(last_file, ".");

  // add a directory separator on the end (if needed)
  int len = strlen(last_file);

  if (len > 0 && last_file[len-1] != DIR_SEP_CH)
  {
    last_file[len] = DIR_SEP_CH;
    last_file[len+1] = 0;
  }
#endif

  strcat(last_file, "TEST.wad");
}

char *Select_Output_File()
{
#ifdef WIN32
  char *name = StringNew(FL_PATH_MAX);
  strcpy(name, last_file);

  OPENFILENAME ofn;
  memset(ofn, 0, sizeof(ofn));

  ofn.lStructSize = sizeof(OPENFILENAME); 
  ofn.hwndOwner = fl_xid(main_win);
  ofn.lpstrFilter = "Wad Files\0*.wad\0\0";
  ofn.lpstrFile= name;
  ofn.nMaxFile = FL_PATH_MAX;
  ofn.lpstrFileTitle = (LPSTR)NULL;
  ofn.lpstrInitialDir = (LPSTR)NULL; 
  ofn.Flags = OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT; 
  ofn.lpstrTitle = "Select output file"; 
 
  if (0 == GetSaveFileName(&ofn))
  {
    // user cancelled, or error occurred
    return NULL;
  }

  name = ofn.lpstrFile;

#else  // Linux and MacOSX

  char *name = fl_file_chooser("Select output file", "*.wad", last_file);
  if (! name)
    return NULL;

  name = StringDup(name);
#endif

  if (! HasExtension(name))
  {
    char *new_name = ReplaceExtension(name, "wad");
    StringFree(name);
    name = new_name;
  }
  
  if (FileExists(name))
  {
    // FIXME
    // DIALOG : confirm overwrite
    // OR!!!  : make a backup
  }

  StringFree(last_file);
  last_file = StringDup(name);

  return name;
}

