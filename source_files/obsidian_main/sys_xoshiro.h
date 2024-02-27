//------------------------------------------------------------------------
//  Xoshiro Random Number Generation
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2020-2024 The OBSIDIAN Team
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

#pragma once

#include <stdint.h>

void XoshiroReseed(uint64_t new_seed);

uint64_t XoshiroInt();

double XoshiroDouble();

int XoshiroBetween(int low, int high);
