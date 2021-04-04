
//**************************************************************************
//**
//** acc.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "error.h"
#include "misc.h"
#include "parse.h"
#include "pcode.h"
#include "strlist.h"
#include "symbol.h"
#include "token.h"

// MACROS ------------------------------------------------------------------

#define VERSION_TEXT "1.58"
#define COPYRIGHT_YEARS_TEXT "1995"

// TYPES -------------------------------------------------------------------

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static void Init(void);
static void DisplayBanner(void);
static void DisplayUsage(void);
static void OpenDebugFile(char *name);
static void ProcessArgs(void);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

boolean acs_BigEndianHost;
boolean acs_VerboseMode;
boolean acs_DebugMode;
FILE *acs_DebugFile;
char acs_SourceFileName[MAX_FILE_NAME_LENGTH];

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static int ArgCount;
static char **ArgVector;
static char ObjectFileName[MAX_FILE_NAME_LENGTH];

// CODE --------------------------------------------------------------------

//==========================================================================
//
// main
//
//==========================================================================

int acc_main(int argc, char **argv) {
    int i;

    ArgCount = argc;
    ArgVector = argv;
    DisplayBanner();
    Init();
    TK_OpenSource(acs_SourceFileName);
    PC_OpenObject(ObjectFileName, DEFAULT_OBJECT_SIZE, 0);
    PA_Parse();
    PC_CloseObject();
    TK_CloseSource();

    MS_Message(MSG_NORMAL, "\n\"%s\":\n  %d line%s (%d included)\n",
               acs_SourceFileName, tk_Line, tk_Line == 1 ? "" : "s",
               tk_IncludedLines);
    MS_Message(MSG_NORMAL, "  %d function%s\n  %d script%s\n", pc_FunctionCount,
               pc_FunctionCount == 1 ? "" : "s", pa_ScriptCount,
               pa_ScriptCount == 1 ? "" : "s");
    for (i = 0; pa_TypedScriptCounts[i].TypeName; i++) {
        if (pa_TypedScriptCounts[i].TypeCount > 0) {
            MS_Message(MSG_NORMAL, "%5d %s\n",
                       pa_TypedScriptCounts[i].TypeCount,
                       pa_TypedScriptCounts[i].TypeName);
        }
    }
    MS_Message(MSG_NORMAL,
               "  %d global variable%s\n"
               "  %d world variable%s\n"
               "  %d map variable%s\n"
               "  %d global array%s\n"
               "  %d world array%s\n",
               pa_GlobalVarCount, pa_GlobalVarCount == 1 ? "" : "s",
               pa_WorldVarCount, pa_WorldVarCount == 1 ? "" : "s",
               pa_MapVarCount, pa_MapVarCount == 1 ? "" : "s",
               pa_GlobalArrayCount, pa_GlobalArrayCount == 1 ? "" : "s",
               pa_WorldArrayCount, pa_WorldArrayCount == 1 ? "" : "s");
    MS_Message(MSG_NORMAL, "  object \"%s\": %d bytes\n", ObjectFileName,
               pc_Address);
    ERR_RemoveErrorFile();
    return 0;
}

//==========================================================================
//
// DisplayBanner
//
//==========================================================================

static void DisplayBanner(void) {
    fprintf(stderr, "\nOriginal ACC Version 1.10 by Ben Gokey\n");
    fprintf(stderr,
            "Copyright (c) " COPYRIGHT_YEARS_TEXT " Raven Software, Corp.\n\n");
    fprintf(stderr, "This is version " VERSION_TEXT " (" __DATE__ ")\n");
    fprintf(stderr,
            "This software is not supported by Raven Software or Activision\n");
    fprintf(stderr, "ZDoom changes and language extensions by Randy Heit\n");
    fprintf(stderr, "Further changes by Brad Carney\n");
    fprintf(stderr, "Even more changes by James Bentler\n");
    fprintf(stderr, "Some additions by Michael \"Necromage\" Weber\n");
    fprintf(
        stderr,
        "Error reporting improvements and limit expansion by Ty Halderman\n");
    fprintf(stderr, "Include paths added by Pascal vd Heiden\n");
}

//==========================================================================
//
// Init
//
//==========================================================================

static void Init(void) {
    short endianTest = 1;

    if (*(char *)&endianTest)
        acs_BigEndianHost = NO;
    else
        acs_BigEndianHost = YES;
    acs_VerboseMode = YES;
    acs_DebugMode = NO;
    acs_DebugFile = NULL;
    TK_Init();
    SY_Init();
    STR_Init();
    ProcessArgs();
    MS_Message(MSG_NORMAL, "Host byte order: %s endian\n",
               acs_BigEndianHost ? "BIG" : "LITTLE");
}

//==========================================================================
//
// ProcessArgs
//
// Pascal 12/11/08
// Allowing space after options (option parameter as the next argument)
//
//==========================================================================

static void ProcessArgs(void) {
    int i = 1;
    int count = 0;
    char *text;
    char option;

    while (i < ArgCount) {
        text = ArgVector[i];

        if (*text == '-') {
            // Option
            text++;
            if (*text == 0) {
                DisplayUsage();
            }
            option = toupper(*text++);
            switch (option) {
                case 'I':
                    if ((i + 1) < ArgCount) {
                        TK_AddIncludePath(ArgVector[++i]);
                    }
                    break;

                case 'D':
                    acs_DebugMode = YES;
                    acs_VerboseMode = YES;
                    if (*text != 0) {
                        OpenDebugFile(text);
                    }
                    break;

                case 'H':
                    pc_NoShrink = TRUE;
                    pc_HexenCase = TRUE;
                    pc_EnforceHexen = toupper(*text) != 'H';
                    pc_WarnNotHexen = toupper(*text) == 'H';
                    break;

                default:
                    DisplayUsage();
                    break;
            }
        } else {
            // Input/output file
            count++;
            switch (count) {
                case 1:
                    strcpy(acs_SourceFileName, text);
                    MS_SuggestFileExt(acs_SourceFileName, ".acs");
                    break;

                case 2:
                    strcpy(ObjectFileName, text);
                    MS_SuggestFileExt(ObjectFileName, ".o");
                    break;

                default:
                    DisplayUsage();
                    break;
            }
        }

        // Next arg
        i++;
    }

    if (count == 0) {
        DisplayUsage();
    }

    TK_AddIncludePath(".");
#ifdef unix
    TK_AddIncludePath("/usr/local/share/acc/");
#endif
    TK_AddProgramIncludePath(ArgVector[0]);

    if (count == 1) {
        strcpy(ObjectFileName, acs_SourceFileName);
        MS_StripFileExt(ObjectFileName);
        MS_SuggestFileExt(ObjectFileName, ".o");
    }
}

//==========================================================================
//
// DisplayUsage
//
//==========================================================================

static void DisplayUsage(void) {
    puts("\nUsage: ACC [options] source[.acs] [object[.o]]\n");
    puts("-i [path]  Add include path to find include files");
    puts("-d[file]   Output debugging information");
    puts("-h         Create pcode compatible with Hexen and old ZDooms");
    puts("-hh        Like -h, but use of new features is only a warning");
    exit(1);
}

//==========================================================================
//
// OpenDebugFile
//
//==========================================================================

static void OpenDebugFile(char *name) {
    if ((acs_DebugFile = fopen(name, "w")) == NULL) {
        ERR_Exit(ERR_CANT_OPEN_DBGFILE, NO, "File: \"%s\".", name);
    }
}

//==========================================================================
//
// OptionExists
//
//==========================================================================

/*
static boolean OptionExists(char *name)
{
        int i;
        char *arg;

        for(i = 1; i < ArgCount; i++)
        {
                arg = ArgVector[i];
                if(*arg == '-')
                {
                        arg++;
                        if(MS_StrCmp(name, arg) == 0)
                        {
                                return YES;
                        }
                }
        }
        return NO;
}
*/
