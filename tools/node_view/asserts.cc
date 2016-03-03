//------------------------------------------------------------------------
//  ASSERTIONS
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

#include "defs.h"

assert_fail_c::assert_fail_c(const char *_msg)
{
  strncpy(message, _msg, sizeof(message));

  message[sizeof(message) - 1] = 0;
}

assert_fail_c::~assert_fail_c()
{
  /* nothing needed */
}

assert_fail_c::assert_fail_c(const assert_fail_c &other)
{
  strcpy(message, other.message);
}

assert_fail_c& assert_fail_c::operator=(const assert_fail_c &other)
{
  if (this != &other)
    strcpy(message, other.message);
  
  return *this;
}

//------------------------------------------------------------------------

void AssertFail(const char *msg, ...)
{
  char buffer[1024];

  va_list argptr;

  va_start(argptr, msg);
  vsprintf(buffer, msg, argptr);
  va_end(argptr);

  // assertion messages shouldn't overflow... (famous last words)
  buffer[sizeof(buffer) - 1] = 0;

  PrintDebug("%s\n", buffer);
  
  throw assert_fail_c(buffer);
}

