//------------------------------------------------------------------------
//  File Chooser dialog
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

#ifdef WIN32
#include <commdlg.h>
#endif

static char *last_file;

void Default_Location(void)
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

  strcat(last_file, "TEST");

//  DebugPrintf("Default_Location: [%s]\n", last_file);
}

bool UI_SetLastFile(const char *filename)
{
  if (filename[0] != '\"')
  {
//  LogPrintf("Weird filename in config: [%s]\n", filename);
    return false;
  }

  int len = strlen(filename);

  if (filename[len-1] != '\"')
  {
//  LogPrintf("Unterminated filename in config: [%s]\n", filename);
    return false;
  }

  filename++, len -= 2;

  SYS_ASSERT(len >= 0);

  last_file = StringDup(filename);
  last_file[len] = 0;

//  DebugPrintf("Parsed last_file as: [%s]\n", last_file);
 
  return true;
}

const char *UI_GetLastFile(void)
{
  if (! last_file)
    return "\"\"";

  return StringPrintf("\"%s\"", last_file);
}


//------------------------------------------------------------------------

char *Select_Output_File(const char *ext)
{
  SYS_ASSERT(last_file);

#ifdef WIN32
  // remember current directory and restore it after the call to
  // GetSaveFileName(), which might change it.
  char *cur_dir = StringNew(MAX_PATH);

  DWORD gcd_res = ::GetCurrentDirectory(MAX_PATH, cur_dir);

  if (0 == gcd_res || gcd_res > MAX_PATH)
    Main_FatalError("GetCurrentDirectory failed!");

//  DebugPrintf("Select_Output_File: cur_dir=[%s]\n", cur_dir);
  
  char pattern_buf[128];
  pattern_buf[0] = toupper(ext[0]);
  sprintf(pattern_buf+1, "%s Files%c*.%s%c%c", ext+1, 0, ext, 0, 0);

  // --- call the bitch ---

  char *name = StringNew(FL_PATH_MAX);
  name[0] = 0;
  // THIS FUCKS UP: strcpy(name, last_file);

  OPENFILENAME ofn;
  memset(&ofn, 0, sizeof(ofn));

  ofn.lStructSize = sizeof(OPENFILENAME); 
  ofn.hwndOwner = fl_xid(main_win);
  ofn.lpstrFilter = pattern_buf;
  ofn.lpstrFile = name;
  ofn.nMaxFile  = FL_PATH_MAX;
  ofn.lpstrInitialDir = (LPSTR)NULL; 
  ofn.Flags = OFN_EXPLORER | OFN_HIDEREADONLY |
              OFN_PATHMUSTEXIST | OFN_OVERWRITEPROMPT |
              OFN_NONETWORKBUTTON;
  ofn.lpstrTitle = "Select output file"; 
 
  BOOL result = ::GetSaveFileName(&ofn);

  if (result == 0)
  {
    DWORD err = ::CommDlgExtendedError();

//  DebugPrintf("Select_Output_File: failed, err=0x%08x\n", err);

    // user cancelled, or error occurred
    ::SetCurrentDirectory(cur_dir);
    return NULL;
  }

  if (ofn.lpstrFile != name)
  {
    SYS_ASSERT(ofn.lpstrFile);

    // NOTE: memory leak.  I cannot be sure what the GetSaveFileName()
    // call has placed into lpstrFile field, maybe a subset of our
    // existing buffer, maybe something entirely different.

    name = StringDup(ofn.lpstrFile);
  }

  if (name[0] != '\\' && ! (name[0] && name[1] == ':'))
  {
    // name was relative.  Since I'm assuming the GetSaveFileName()
    // call might modify the current directory, we need to make the
    // filename absolute _BEFORE_ we restore the original dir.

    char *copy = StringNew(FL_PATH_MAX);

    fl_filename_absolute(copy, FL_PATH_MAX, name);

    StringFree(name);
    name = copy;
  }

  ::SetCurrentDirectory(cur_dir);

#else  // Linux and MacOSX

  char pattern_buf[64];
  sprintf(pattern_buf, "*.%s", ext);

  char *name = fl_file_chooser("Select output file", pattern_buf, last_file);
  if (! name)
    return NULL;

  name = StringDup(name);
#endif

  if (! HasExtension(name))
  {
    char *new_name = ReplaceExtension(name, ext);
    StringFree(name);
    name = new_name;
  }
  
//  DebugPrintf("Select_Output_File: OK, name=[%s]\n", name);

  StringFree(last_file);
  last_file = StringDup(name);

  return name;
}


//------------------------------------------------------------------------

char *Select_Input_File(const char *ext)
{
#ifdef WIN32
  // remember current directory and restore it after the call to
  // GetSaveFileName(), which might change it.
  char *cur_dir = StringNew(MAX_PATH);

  DWORD gcd_res = ::GetCurrentDirectory(MAX_PATH, cur_dir);

  if (0 == gcd_res || gcd_res > MAX_PATH)
    Main_FatalError("GetCurrentDirectory failed!");

//  DebugPrintf("Select_Input_File: cur_dir=[%s]\n", cur_dir);

  char pattern_buf[128];
  pattern_buf[0] = toupper(ext[0]);
  sprintf(pattern_buf+1, "%s Files%c*.%s%c%c", ext+1, 0, ext, 0, 0);
  
  // --- call the bitch ---

  char *name = StringNew(FL_PATH_MAX);
  name[0] = 0;

  OPENFILENAME ofn;
  memset(&ofn, 0, sizeof(ofn));

  ofn.lStructSize = sizeof(OPENFILENAME); 
  ofn.hwndOwner = fl_xid(main_win);
  ofn.lpstrFilter = pattern_buf;
  ofn.lpstrFile = name;
  ofn.nMaxFile  = FL_PATH_MAX;
  ofn.lpstrInitialDir = (LPSTR)NULL; 
  ofn.Flags = OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_NONETWORKBUTTON;
  ofn.lpstrTitle = "Select input file"; 
 
  BOOL result = ::GetOpenFileName(&ofn);

  if (result == 0)
  {
    DWORD err = ::CommDlgExtendedError();

//  DebugPrintf("Select_Input_File: failed, err=0x%08x\n", err);

    // user cancelled, or error occurred
    ::SetCurrentDirectory(cur_dir);
    return NULL;
  }

  if (ofn.lpstrFile != name)
  {
    SYS_ASSERT(ofn.lpstrFile);

    // NOTE: memory leak.  I cannot be sure what the GetOpenFileName()
    // call has placed into lpstrFile field, maybe a subset of our
    // existing buffer, maybe something entirely different.

    name = StringDup(ofn.lpstrFile);
  }

  if (name[0] != '\\' && ! (name[0] && name[1] == ':'))
  {
    // name was relative.  Since I'm assuming the GetOpenFileName()
    // call might modify the current directory, we need to make the
    // filename absolute _BEFORE_ we restore the original dir.

    char *copy = StringNew(FL_PATH_MAX);

    fl_filename_absolute(copy, FL_PATH_MAX, name);

    StringFree(name);
    name = copy;
  }

  ::SetCurrentDirectory(cur_dir);

#else  // Linux and MacOSX

  char *name = fl_file_chooser("Select input file", "*.pak", NULL);
  if (! name)
    return NULL;

  name = StringDup(name);
#endif

  if (! HasExtension(name))
  {
    char *new_name = ReplaceExtension(name, "pak");
    StringFree(name);
    name = new_name;
  }
  
//  DebugPrintf("Select_Input_File: OK, name=[%s]\n", name);

  return name;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
