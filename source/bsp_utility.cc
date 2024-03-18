//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2023 Andrew Apted
//  Copyright (C) 1997-2003 Andr� Majorel et al
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "bsp_utility.h"

#include "AlmostEquals.h"
#include "bsp_local.h"
#include "sys_debug.h"
#include "sys_macro.h"
namespace ajbsp
{

//------------------------------------------------------------------------
// MEMORY ALLOCATION
//------------------------------------------------------------------------

//
// Allocate memory with error checking.  Zeros the memory.
//
void *UtilCalloc(int size)
{
    void *ret = calloc(1, size);

    if (!ret)
        ErrorPrintf("AJBSP: Out of memory (cannot allocate %d bytes)\n", size);

    return ret;
}

//
// Reallocate memory with error checking.
//
void *UtilRealloc(void *old, int size)
{
    void *ret = realloc(old, size);

    if (!ret)
        ErrorPrintf("AJBSP: Out of memory (cannot reallocate %d bytes)\n", size);

    return ret;
}

//
// Free the memory with error checking.
//
void UtilFree(void *data)
{
    if (data == nullptr)
        ErrorPrintf("AJBSP: Trying to free a nullptr pointer\n");

    free(data);
}

//------------------------------------------------------------------------
//  Adler-32 CHECKSUM Code
//------------------------------------------------------------------------

void Adler32Begin(uint32_t *crc)
{
    *crc = 1;
}

void Adler32AddBlock(uint32_t *crc, const uint8_t *data, int length)
{
    uint32_t s1 = (*crc) & 0xFFFF;
    uint32_t s2 = ((*crc) >> 16) & 0xFFFF;

    for (; length > 0; data++, length--)
    {
        s1 = (s1 + *data) % 65521;
        s2 = (s2 + s1) % 65521;
    }

    *crc = (s2 << 16) | s1;
}

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
