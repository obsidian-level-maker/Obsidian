//------------------------------------------------------------------------
//  SYSTEM : System specific code
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

// this includes everything we need
#include "main.h"

static char message_buf[1024];


void FatalError(const char *str, ...)
{
/// strcpy(message_buf, "\nFATAL ERROR: ");
/// char *msg_end = message_buf + strlen(message_buf);

  va_list args;

  va_start(args, str);
  vsprintf(message_buf, str, args);
  va_end(args);

  PrintDebug(">> FATAL ERROR: %s", message_buf);

  fprintf(stderr, "FATAL ERROR: %s\n", message_buf);

  exit(9);
}


void InternalError(const char *str, ...)
{
  strcpy(message_buf, "\nINTERNAL ERROR: ");
  char *msg_end = message_buf + strlen(message_buf);

  va_list args;

  va_start(args, str);
  vsprintf(msg_end, str, args);
  va_end(args);

  PrintDebug(">> %s", message_buf);

  fprintf(stderr, "%s\n", message_buf);

  exit(9);
}


void PrintMsg(const char *str, ...)
{
  va_list args;

  va_start(args, str);
  vsprintf(message_buf, str, args);
  va_end(args);

  printf("%s", message_buf);

  PrintDebug(">> %s", message_buf);
}


void PrintWarn(const char *str, ...)
{
  va_list args;

  va_start(args, str);
  vsprintf(message_buf, str, args);
  va_end(args);

  printf("Warning: %s", message_buf);

  PrintDebug("Warning: %s", message_buf);
}


//------------------------------------------------------------------------
//  ARGUMENT HANDLING
//------------------------------------------------------------------------

const char **arg_list = NULL;
int arg_count = 0;

//
// Initialise argument list.  Do NOT include the program name
// (usually in argv[0]).  The strings (and array) are copied.
//
// NOTE: doesn't merge multiple uses of an option, hence
//       using ArgvFind() will only return the first usage.
//
void ArgvInit(int argc, const char **argv)
{
  arg_count = argc;
  SYS_ASSERT(arg_count >= 0);

  if (arg_count == 0)
  {
    arg_list = NULL;
    return;
  }

  arg_list = new const char *[arg_count];

  int dest = 0;

  for (int i = 0; i < arg_count; i++)
  {
    const char *cur = argv[i];
    SYS_ASSERT(cur);

#ifdef MACOSX
    // ignore MacOS X rubbish
    if (strncmp(cur, "-psn", 4) == 0)
      continue;
#endif

    // support GNU-style long options
    if (cur[0] == '-' && cur[1] == '-' && isalnum(cur[2]))
      cur++;

    arg_list[dest] = strdup(cur);

    // support DOS-style short options
    if (cur[0] == '/' && (isalnum(cur[1]) || cur[1] == '?') && cur[2] == 0)
      *(char *)(arg_list[dest]) = '-';

    dest++;
  }

  arg_count = dest;
}


void ArgvTerm(void)
{
  while (arg_count-- > 0)
    free((void *) arg_list[arg_count]);
  
  if (arg_list)
    delete[] arg_list;
}


//
// Returns index number, or -1 if not found.
// 
int ArgvFind(char short_name, const char *long_name, int *num_params)
{
  SYS_ASSERT(short_name || long_name);

  if (num_params)
    *num_params = 0;
  
  int p = 0;

  for (; p < arg_count; p++)
  {
    if (! ArgvIsOption(p))
      continue;

    const char *str = arg_list[p];

    if (short_name && (short_name == tolower(str[1])) && str[2] == 0)
      break;

    if (long_name && (UtilStrCaseCmp(long_name, str + 1) == 0))
      break;
  }

  if (p >= arg_count)  // NOT FOUND
    return -1;

  if (num_params)
  {
    int q = p + 1;

    while ((q < arg_count) && ! ArgvIsOption(q))
      q++;

    *num_params = q - p - 1;
  }

  return p;
}

bool ArgvIsOption(int index)
{
  SYS_ASSERT(index >= 0);
  SYS_ASSERT(index < arg_count);

  const char *str = arg_list[index];
  SYS_ASSERT(str);

  return (str[0] == '-');
}


//------------------------------------------------------------------------
//  DEBUGGING CODE
//------------------------------------------------------------------------

#define DEBUGGING_FILE  "d2b_debug.txt"

static FILE *debug_fp = NULL;

void InitDebug(bool enable)
{
  if (! enable)
  {
    debug_fp = NULL;
    return;
  }

  debug_fp = fopen(DEBUGGING_FILE, "w");

  if (! debug_fp)
    PrintWarn("Unable to open DEBUG FILE: %s\n", DEBUGGING_FILE);

  PrintDebug("====== START OF DEBUG FILE ======\n\n");
}


void TermDebug(void)
{
  if (debug_fp)
  {
    PrintDebug("\n====== END OF DEBUG FILE ======\n");

    fclose(debug_fp);
    debug_fp = NULL;
  }
}


void PrintDebug(const char *str, ...)
{
  if (debug_fp)
  {
    va_list args;

    va_start(args, str);
    vfprintf(debug_fp, str, args);
    va_end(args);

    fflush(debug_fp);
  }
}


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
  
  fprintf(stderr, "%s\n", buffer);

  exit(9);
}


//------------------------------------------------------------------------
//  ENDIAN CODE
//------------------------------------------------------------------------

static bool cpu_big_endian = false;

//
// Parts inspired by the Yadex endian.cc code.
//
void InitEndian(void)
{
  volatile union
  {
    uint8_g mem[32];
    uint32_g val;
  }
  u;

  /* sanity-check type sizes */

  if (sizeof(uint8_g) != 1)
    FatalError("Sanity check failed: sizeof(uint8_g) = %d", 
        sizeof(uint8_g));

  if (sizeof(uint16_g) != 2)
    FatalError("Sanity check failed: sizeof(uint16_g) = %d", 
        sizeof(uint16_g));

  if (sizeof(uint32_g) != 4)
    FatalError("Sanity check failed: sizeof(uint32_g) = %d", 
        sizeof(uint32_g));

  /* check endianness */

  memset((uint32_g *) u.mem, 0, sizeof(u.mem));

  u.mem[0] = 0x70;  u.mem[1] = 0x71;
  u.mem[2] = 0x72;  u.mem[3] = 0x73;

  PrintDebug("Endianness magic value: 0x%08x\n", u.val);

  if (u.val == 0x70717273)
    cpu_big_endian = true;
  else if (u.val == 0x73727170)
    cpu_big_endian = false;
  else
    FatalError("Sanity check failed: weird endianness (0x%08x)", u.val);

  PrintDebug("Endianness = %s\n", cpu_big_endian ? "BIG" : "LITTLE");

  PrintDebug("Endianness check: 0x1234 --> 0x%04x\n", 
      (int) Endian_U16(0x1234));

  PrintDebug("Endianness check: 0x11223344 --> 0x%08x\n\n", 
      Endian_U32(0x11223344));
}


uint16_g Endian_U16(uint16_g x)
{
  if (cpu_big_endian)
    return (x >> 8) | (x << 8);
  else
    return x;
}


uint32_g Endian_U32(uint32_g x)
{
  if (cpu_big_endian)
    return (x >> 24) | ((x >> 8) & 0xff00) |
             ((x << 8) & 0xff0000) | (x << 24);
  else
    return x;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
