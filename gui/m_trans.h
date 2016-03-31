//------------------------------------------------------------------------
//  TRANSLATION / INTERNATIONALIZATION
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2016 Andrew Apted
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

#ifndef __OBLIGE_I18N_H__
#define __OBLIGE_I18N_H__

// current selected language, default is "AUTO"
extern const char *t_language;

void Trans_Init();

void Trans_SetLanguage();

// these are for the UI:
const char * Trans_GetAvailCode(int idx);
const char * Trans_GetAvailLanguage(int idx);

#endif /* __OBLIGE_I18N_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
