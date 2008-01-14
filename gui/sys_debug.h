//------------------------------------------------------------------------
//  Debugging support
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

#ifndef __SYS_DEBUG_H__
#define __SYS_DEBUG_H__

void LogInit(const char *filename);  // NULL for none
void LogClose(void);

void LogEnableDebug(void);
void LogEnableTerminal(void);

void LogPrintf(const char *str, ...);

void DebugPrintf(const char *str, ...);

#endif /* __SYS_DEBUG_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
