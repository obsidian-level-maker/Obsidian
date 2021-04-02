
//**************************************************************************
//**
//** common.h
//**
//**************************************************************************

#ifndef __COMMON_H__
#define __COMMON_H__

// HEADER FILES ------------------------------------------------------------

// MACROS ------------------------------------------------------------------

#define ARRAY_SIZE(a)	(sizeof(a)/sizeof(*(a)))
#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif
#ifndef YES
#define YES 1
#endif
#ifndef NO
#define NO 0
#endif
// Increased limits - Ty 03jan2000
// 32 is okay
#define MAX_IDENTIFIER_LENGTH 32
// 32k long quoted string should be okay
#define MAX_QUOTED_LENGTH 32768
// 512 max file name is okay in DOS/Win
#define MAX_FILE_NAME_LENGTH 512
// Was 64
#define MAX_SCRIPT_COUNT 1000
// Was 32
#define MAX_MAP_VARIABLES 128
// Left alone--there's something in the docs about this...
// [RH] Bumped up to 20 for fun.
#define MAX_SCRIPT_VARIABLES 20
// Was 64
#define MAX_WORLD_VARIABLES 256
// [RH] New
#define MAX_GLOBAL_VARIABLES 64
// Was 128
#define MAX_STRINGS 32768
// Don't know what this is
#define DEFAULT_OBJECT_SIZE 65536
// Added Ty 07Jan2000 for error details
#define MAX_STATEMENT_LENGTH 4096

#define MAX_FUNCTION_COUNT 8192

#define MAX_IMPORTS 256

#define MAX_SCRIPT_ARRAYS 255

// Max number of include paths the user can specify
// This includes the "working directory"!
#define MAX_INCLUDE_PATHS 16

// Maximum number of translations that can be used
#define MAX_TRANSLATIONS 32

enum
{
	STRLIST_PICS,
	STRLIST_FUNCTIONS,
	STRLIST_MAPVARS,
	STRLIST_NAMEDSCRIPTS,

	NUM_STRLISTS
};

// These are just defs and have not been messed with
#define ASCII_SPACE 32
#define ASCII_QUOTE 34
#define ASCII_UNDERSCORE 95
#define EOF_CHARACTER 127
#ifdef __NeXT__
#define DIRECTORY_DELIMITER "/"
#define DIRECTORY_DELIMITER_CHAR ('/')
#else
#define DIRECTORY_DELIMITER "\\"
#define DIRECTORY_DELIMITER_CHAR ('\\')
#endif



#define MAKE4CC(a,b,c,d)	((a)|((b)<<8)|((c)<<16)|((d)<<24))

// TYPES -------------------------------------------------------------------

typedef unsigned int	boolean;
typedef unsigned char	byte;
typedef signed char		S_BYTE;
typedef unsigned char	U_BYTE;
typedef signed short	S_WORD;
typedef unsigned short	U_WORD;
typedef int			S_INT;
typedef unsigned int	U_INT;
// typedef signed long		S_LONG;
// typedef unsigned long	U_LONG;

enum ImportModes
{
	IMPORT_None,
	IMPORT_Importing,
	IMPORT_Exporting
};

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PUBLIC DATA DECLARATIONS ------------------------------------------------

#endif
