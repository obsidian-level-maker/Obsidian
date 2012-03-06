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

#ifndef __BRUSHER_SYSTEM_H__
#define __BRUSHER_SYSTEM_H__


/* ----- basic types and macros ---------------------------- */

typedef char  sint8_g;
typedef short sint16_g;
typedef int   sint32_g;
   
typedef unsigned char  uint8_g;
typedef unsigned short uint16_g;
typedef unsigned int   uint32_g;


/* ----- function prototypes ---------------------------- */

// fatal error messages (these don't return)
void FatalError(const char *str, ...);
void InternalError(const char *str, ...);

// display normal messages & warnings to the screen
void PrintMsg(const char *str, ...);
void PrintWarn(const char *str, ...);

// argument handling
extern const char **arg_list;
extern int arg_count;

void ArgvInit(int argc, const char **argv);
void ArgvTerm(void);
int ArgvFind(char short_name, const char *long_name, int *num_params = NULL);
bool ArgvIsOption(int index);

// endian handling
void InitEndian(void);
uint16_g Endian_U16(uint16_g);
uint32_g Endian_U32(uint32_g);

// these are only used for debugging
void InitDebug(bool enable);
void TermDebug(void);
void PrintDebug(const char *str, ...);

#ifdef NDEBUG
#define SYS_ASSERT(cond)  ((void) 0)

#else
#define SYS_ASSERT(cond)  ((cond) ? (void)0 :  \
  AssertFail("Assertion (%s) failed\nIn function %s (%s:%d)\n", #cond , __func__, __FILE__, __LINE__))

#endif  // NDEBUG

// throw an assertion exception with the given message.
void AssertFail(const char *msg, ...);


/* ----- conversion macros ----------------------- */

#define UINT8(x)   ((uint8_g) (x))
#define SINT8(x)   ((sint8_g) (x))

#define UINT16(x)  Endian_U16(x)
#define UINT32(x)  Endian_U32(x)

#define SINT16(x)  ((sint16_g) Endian_U16((uint16_g) (x)))
#define SINT32(x)  ((sint32_g) Endian_U32((uint32_g) (x)))


#endif /* __BRUSHER_SYSTEM_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
