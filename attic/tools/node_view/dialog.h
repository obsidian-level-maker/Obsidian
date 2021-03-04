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

#ifndef __NODEVIEW_DIALOG_H__
#define __NODEVIEW_DIALOG_H__

void DialogLoadImages(void);
void DialogFreeImages(void);

int DialogShowAndGetChoice(const char *title, Fl_Pixmap *pic, 
    const char *message, const char *left = "OK", 
    const char *middle = NULL, const char *right = NULL);

int DialogQueryFilename(const char *message,
    const char ** name_ptr, const char *guess_name);

void GUI_FatalError(const char *str, ...);

#define ALERT_TXT  (PROG_NAME "Alert")
#define MISSING_COMMS  "(Not Specified)"

#endif /* __NODEVIEW_DIALOG_H__ */
