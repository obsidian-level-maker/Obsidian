//------------------------------------------------------------------------
//  Main defines
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

#ifndef __OBLIGE_MAIN_H__
#define __OBLIGE_MAIN_H__

#define OBLIGE_TITLE  "Oblige Level Maker"

#define OBLIGE_VERSION  "0.79"
#define OBLIGE_HEX_VER  0x079

#define DATA_DIR  "./obl_data"

void Main_FatalError(const char *msg, ...);

void Main_Ticker();

#endif /* __OBLIGE_MAIN_H__ */
