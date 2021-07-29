//------------------------------------------------------------------------
//  Argument library
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#ifndef __LIB_ARGV_H__
#define __LIB_ARGV_H__

#include <cstddef>
#include <string>
#include <vector>

extern std::vector<std::string> arg_list;

void ArgvInit(int argc, const char **argv);

int ArgvFind(char short_name, const char *long_name, int *num_params = NULL);
bool ArgvIsOption(int index);

#endif /* __LIB_ARGV_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
