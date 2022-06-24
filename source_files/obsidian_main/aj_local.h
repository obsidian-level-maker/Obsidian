//------------------------------------------------------------------------
//
//  AJ-Polygonator 
//  (C) 2021-2022 The OBSIDIAN Team
//  (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#ifndef __AJPOLY_LOCAL_H__
#define __AJPOLY_LOCAL_H__

#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <vector>

#include "aj_poly.h"
#include "sys_endian.h"
#include "sys_macro.h"
#include "sys_type.h"

#define HAVE_PHYSFS 1
#include "physfs.h"

namespace ajpoly {

#include "aj_map.h"
#include "aj_structs.h"
#include "aj_util.h"
#include "aj_wad.h"

}  // namespace ajpoly

#endif /* __AJPOLY_LOCAL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
