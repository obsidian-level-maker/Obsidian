//----------------------------------------------------------------------------
//  Assertions
//----------------------------------------------------------------------------
//
//  Copyright (C) 2006-2009 Andrew J Apted
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

#ifndef __SYS_ASSERT__
#define __SYS_ASSERT__

#ifdef NDEBUG
#define SYS_ASSERT(cond)  ((void) 0)

#elif defined(__GNUC__)
#define SYS_ASSERT(cond)  ((cond) ? (void)0 :  \
        FatalError("Assertion (%s) failed\nIn function %s (%s:%d)\n", #cond , __func__, __FILE__, __LINE__))

#else
#define SYS_ASSERT(cond)  ((cond) ? (void)0 :  \
        FatalError("Assertion (%s) failed\nIn file %s:%d\n", #cond , __FILE__, __LINE__))

#endif  // NDEBUG

#endif  /* __SYS_ASSERT__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
