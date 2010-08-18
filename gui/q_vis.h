//------------------------------------------------------------------------
//  QUAKE LIGHT TRACING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C)      2010 Andrew Apted
//  Copyright (C) 2005-2006 Peter Brett
//  Copyright (C) 1994-2001 iD Software
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

#ifndef __QUAKE_TRACE_H__
#define __QUAKE_TRACE_H__

void QCOM_MakeTraceNodes();
void QCOM_FreeTraceNodes();

// returns true if OK, false if blocked
bool QCOM_TraceRay(float x1, float y1, float z1,
                   float x2, float y2, float z2);

#endif /* __QUAKE_TRACE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
