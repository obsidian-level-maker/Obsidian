/*
    Reads wad files, builds nodes, and saves new wad files.
	Copyright (C) 1996 Raven Software 
    Copyright (C) 2002-2006 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/

// HEADER FILES ------------------------------------------------------------

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <limits.h>
#include "sc_man.h"

#ifdef _MSC_VER
#pragma warning(disable:4996)
#endif

// MACROS ------------------------------------------------------------------

#define MAX_STRING_SIZE 40960
#define ASCII_COMMENT (';')
#define CPP_COMMENT ('/')
#define C_COMMENT ('*')
#define ASCII_QUOTE (34)
#define LUMP_SCRIPT 1
#define FILE_ZONE_SCRIPT 2

// TYPES -------------------------------------------------------------------

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static void SC_PrepareScript (void);
static void CheckOpen (void);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

char *sc_String;
int sc_StringLen;
int sc_Number;
double sc_Float;
int sc_Line;
bool sc_End;
bool sc_Crossed;
bool sc_StringQuoted;
bool sc_FileScripts = false;
//FILE *sc_Out;

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static char *ScriptBuffer;
static char *ScriptPtr;
static char *ScriptEndPtr;
static char StringBuffer[MAX_STRING_SIZE];
static bool ScriptOpen = false;
static int ScriptSize;
static bool AlreadyGot = false;
static char *SavedScriptPtr;
static int SavedScriptLine;
static bool CMode;

// CODE --------------------------------------------------------------------

//==========================================================================
//
// SC_OpenFile
//
// Loads a script 
//
//==========================================================================

void SC_OpenMem (const char *name, char *buffer, int len)
{
	SC_Close ();
	ScriptSize = len;
	ScriptBuffer = buffer;
	SC_PrepareScript ();
}

//==========================================================================
//
// SC_PrepareScript
//
// Prepares a script for parsing.
//
//==========================================================================

static void SC_PrepareScript (void)
{
	ScriptPtr = ScriptBuffer;
	ScriptEndPtr = ScriptPtr + ScriptSize;
	sc_Line = 1;
	sc_End = false;
	ScriptOpen = true;
	sc_String = StringBuffer;
	AlreadyGot = false;
	SavedScriptPtr = NULL;
	CMode = false;
}

//==========================================================================
//
// SC_Close
//
//==========================================================================

void SC_Close (void)
{
	if (ScriptOpen)
	{
		ScriptBuffer = NULL;
		ScriptOpen = false;
	}
}

//==========================================================================
//
// SC_SavePos
//
// Saves the current script location for restoration later
//
//==========================================================================

void SC_SavePos (void)
{
	CheckOpen ();
	if (sc_End)
	{
		SavedScriptPtr = NULL;
	}
	else
	{
		SavedScriptPtr = ScriptPtr;
		SavedScriptLine = sc_Line;
	}
}

//==========================================================================
//
// SC_RestorePos
//
// Restores the previously saved script location
//
//==========================================================================

void SC_RestorePos (void)
{
	if (SavedScriptPtr)
	{
		ScriptPtr = SavedScriptPtr;
		sc_Line = SavedScriptLine;
		sc_End = false;
		AlreadyGot = false;
	}
}

//==========================================================================
//
// SC_SetCMode
//
// Enables/disables C mode. In C mode, more characters are considered to
// be whole words than in non-C mode.
//
//==========================================================================

void SC_SetCMode (bool cmode)
{
	CMode = cmode;
}

//==========================================================================
//
// SC_GetString
//
//==========================================================================

bool SC_GetString ()
{
	char *text;
	bool foundToken;

	CheckOpen();
	if (AlreadyGot)
	{
		AlreadyGot = false;
		return true;
	}
	foundToken = false;
	sc_Crossed = false;
	sc_StringQuoted = false;
	if (ScriptPtr >= ScriptEndPtr)
	{
		sc_End = true;
		return false;
	}
	while (foundToken == false)
	{
		while (ScriptPtr < ScriptEndPtr && *ScriptPtr <= ' ')
		{
			if (*ScriptPtr++ == '\n')
			{
				sc_Line++;
				sc_Crossed = true;
			}
		}
		if (ScriptPtr >= ScriptEndPtr)
		{
			sc_End = true;
			return false;
		}
		if ((CMode || *ScriptPtr != ASCII_COMMENT) &&
			!(ScriptPtr[0] == CPP_COMMENT && ScriptPtr < ScriptEndPtr - 1 &&
			  (ScriptPtr[1] == CPP_COMMENT || ScriptPtr[1] == C_COMMENT)))
		{ // Found a token
			foundToken = true;
		}
		else
		{ // Skip comment
			if (ScriptPtr[0] == CPP_COMMENT && ScriptPtr[1] == C_COMMENT)
			{	// C comment
				while (ScriptPtr[0] != C_COMMENT || ScriptPtr[1] != CPP_COMMENT)
				{
					if (ScriptPtr[0] == '\n')
					{
						sc_Line++;
						sc_Crossed = true;
					}
//					fputc(ScriptPtr[0], sc_Out);
					ScriptPtr++;
					if (ScriptPtr >= ScriptEndPtr - 1)
					{
						sc_End = true;
						return false;
					}
//					fputs("*/", sc_Out);
				}
				ScriptPtr += 2;
			}
			else
			{	// C++ comment
				while (*ScriptPtr++ != '\n')
				{
//					fputc(ScriptPtr[-1], sc_Out);
					if (ScriptPtr >= ScriptEndPtr)
					{
						sc_End = true;
						return false;
					}
				}
				sc_Line++;
				sc_Crossed = true;
//				fputc('\n', sc_Out);
			}
		}
	}
	text = sc_String;
	if (*ScriptPtr == ASCII_QUOTE)
	{ // Quoted string - return string including the quotes
		*text++ = *ScriptPtr++;
		sc_StringQuoted = true;
		while (*ScriptPtr != ASCII_QUOTE)
		{
			if (*ScriptPtr >= 0 && *ScriptPtr < ' ')
			{
				ScriptPtr++;
			}
			else if (*ScriptPtr == '\\')
			{
				// Add the backslash character and the following chararcter to the text.
				// We do not translate the escape sequence in any way, since the only
				// thing that will happen to this string is that it will be written back
				// out to disk. Basically, we just need this special case here so that
				// string reading won't terminate prematurely when a \" sequence is
				// used to embed a quote mark in the string.
				*text++ = *ScriptPtr++;
				*text++ = *ScriptPtr++;
			}
			else
			{
				*text++ = *ScriptPtr++;
			}
			if (ScriptPtr == ScriptEndPtr
				|| text == &sc_String[MAX_STRING_SIZE-1])
			{
				break;
			}
		}
		*text++ = '"';
		ScriptPtr++;
	}
	else
	{ // Normal string
		static const char *stopchars;

		if (CMode)
		{
			stopchars = "`~!@#$%^&*(){}[]/=\?+|;:<>,";

			// '-' can be its own token, or it can be part of a negative number
			if (*ScriptPtr == '-')
			{
				*text++ = '-';
				ScriptPtr++;
				if (ScriptPtr < ScriptEndPtr || (*ScriptPtr >= '0' && *ScriptPtr <= '9'))
				{
					goto grabtoken;
				}
				goto gottoken;
			}
		}
		else
		{
			stopchars = "{}|=";
		}
		if (strchr (stopchars, *ScriptPtr))
		{
			*text++ = *ScriptPtr++;
		}
		else
		{
grabtoken:
			while ((*ScriptPtr > ' ') && (strchr (stopchars, *ScriptPtr) == NULL)
				&& (CMode || *ScriptPtr != ASCII_COMMENT)
				&& !(ScriptPtr[0] == CPP_COMMENT && (ScriptPtr < ScriptEndPtr - 1) &&
					 (ScriptPtr[1] == CPP_COMMENT || ScriptPtr[1] == C_COMMENT)))
			{
				*text++ = *ScriptPtr++;
				if (ScriptPtr == ScriptEndPtr
					|| text == &sc_String[MAX_STRING_SIZE-1])
				{
					break;
				}
			}
		}
	}
gottoken:
	*text = 0;
	sc_StringLen = int(text - sc_String);
	return true;
}

//==========================================================================
//
// SC_MustGetString
//
//==========================================================================

void SC_MustGetString (void)
{
	if (SC_GetString () == false)
	{
		SC_ScriptError ("Missing string (unexpected end of file).");
	}
}

//==========================================================================
//
// SC_MustGetStringName
//
//==========================================================================

void SC_MustGetStringName (const char *name)
{
	SC_MustGetString ();
	if (SC_Compare (name) == false)
	{
		SC_ScriptError ("Expected '%s', got '%s'.", name, sc_String);
	}
}

//==========================================================================
//
// SC_CheckString
//
// Checks if the next token matches the specified string. Returns true if
// it does. If it doesn't, it ungets it and returns false.
//==========================================================================

bool SC_CheckString (const char *name)
{
	if (SC_GetString ())
	{
		if (SC_Compare (name))
		{
			return true;
		}
		SC_UnGet ();
	}
	return false;
}

//==========================================================================
//
// SC_GetNumber
//
//==========================================================================

bool SC_GetNumber (void)
{
	char *stopper;

	CheckOpen ();
	if (SC_GetString())
	{
		if (strcmp (sc_String, "MAXINT") == 0)
		{
			sc_Number = INT_MAX;
		}
		else
		{
			sc_Number = strtol (sc_String, &stopper, 0);
			if (*stopper != 0)
			{
				SC_ScriptError ("SC_GetNumber: Bad numeric constant \"%s\".", sc_String);
			}
		}
		sc_Float = sc_Number;
		return true;
	}
	else
	{
		return false;
	}
}

//==========================================================================
//
// SC_MustGetNumber
//
//==========================================================================

void SC_MustGetNumber (void)
{
	if (SC_GetNumber() == false)
	{
		SC_ScriptError ("Missing integer (unexpected end of file).");
	}
}

//==========================================================================
//
// SC_CheckNumber
// similar to SC_GetNumber but ungets the token if it isn't a number 
// and does not print an error
//
//==========================================================================

bool SC_CheckNumber (void)
{
	char *stopper;

	//CheckOpen ();
	if (SC_GetString())
	{
		if (strcmp (sc_String, "MAXINT") == 0)
		{
			sc_Number = INT_MAX;
		}
		else
		{
			sc_Number = strtol (sc_String, &stopper, 0);
			if (*stopper != 0)
			{
				SC_UnGet();
				return false;
			}
		}
		sc_Float = sc_Number;
		return true;
	}
	else
	{
		return false;
	}
}

//==========================================================================
//
// SC_CheckFloat
// [GRB] Same as SC_CheckNumber, only for floats
//
//==========================================================================

bool SC_CheckFloat (void)
{
	char *stopper;

	//CheckOpen ();
	if (SC_GetString())
	{
		sc_Float = strtod (sc_String, &stopper);
		sc_Number = (int)sc_Float;
		if (*stopper != 0)
		{
			SC_UnGet();
			return false;
		}
		return true;
	}
	else
	{
		return false;
	}
}


//==========================================================================
//
// SC_GetFloat
//
//==========================================================================

bool SC_GetFloat (void)
{
	char *stopper;

	CheckOpen ();
	if (SC_GetString())
	{
		sc_Float = strtod (sc_String, &stopper);
		if (*stopper != 0)
		{
			SC_ScriptError("SC_GetFloat: Bad numeric constant \"%s\".\n",sc_String);
		}
		sc_Number = (int)sc_Float;
		return true;
	}
	else
	{
		return false;
	}
}

//==========================================================================
//
// SC_MustGetFloat
//
//==========================================================================

void SC_MustGetFloat (void)
{
	if (SC_GetFloat() == false)
	{
		SC_ScriptError ("Missing floating-point number (unexpected end of file).");
	}
}

//==========================================================================
//
// SC_UnGet
//
// Assumes there is a valid string in sc_String.
//
//==========================================================================

void SC_UnGet (void)
{
	AlreadyGot = true;
}

//==========================================================================
//
// SC_Check
//
// Returns true if another token is on the current line.
//
//==========================================================================

/*
bool SC_Check(void)
{
	char *text;

	CheckOpen();
	text = ScriptPtr;
	if(text >= ScriptEndPtr)
	{
		return false;
	}
	while(*text <= 32)
	{
		if(*text == '\n')
		{
			return false;
		}
		text++;
		if(text == ScriptEndPtr)
		{
			return false;
		}
	}
	if(*text == ASCII_COMMENT)
	{
		return false;
	}
	return true;
}
*/

//==========================================================================
//
// SC_MatchString
//
// Returns the index of the first match to sc_String from the passed
// array of strings, or -1 if not found.
//
//==========================================================================

int SC_MatchString (const char **strings)
{
	int i;

	for (i = 0; *strings != NULL; i++)
	{
		if (SC_Compare (*strings++))
		{
			return i;
		}
	}
	return -1;
}

//==========================================================================
//
// SC_MustMatchString
//
//==========================================================================

int SC_MustMatchString (const char **strings)
{
	int i;

	i = SC_MatchString (strings);
	if (i == -1)
	{
		SC_ScriptError (NULL);
	}
	return i;
}

//==========================================================================
//
// SC_Compare
//
//==========================================================================

bool SC_Compare (const char *text)
{
#ifdef _MSC_VER
	return (_stricmp (text, sc_String) == 0);
#else
	return (strcasecmp (text, sc_String) == 0);
#endif
}

//==========================================================================
//
// SC_ScriptError
//
//==========================================================================

void SC_ScriptError (const char *message, ...)
{
	char composed[2048];
	if (message == NULL)
	{
		message = "Bad syntax.";
	}

	va_list arglist;
	va_start (arglist, message);
	vsprintf (composed, message, arglist);
	va_end (arglist);

	printf ("Script error, line %d:\n%s\n", sc_Line, composed);
	exit(1);
}

//==========================================================================
//
// CheckOpen
//
//==========================================================================

static void CheckOpen(void)
{
	if (ScriptOpen == false)
	{
		printf ("SC_ call before SC_Open().\n");
		exit(1);
	}
}
