
//**************************************************************************
//**
//** pcode.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#include "pcode.h"

#include <limits.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "common.h"
#include "error.h"
#include "misc.h"
#include "parse.h"
#include "strlist.h"
#include "symbol.h"
#include "token.h"

// MACROS ------------------------------------------------------------------

// TYPES -------------------------------------------------------------------

typedef struct scriptInfo_s {
    S_WORD number;
    U_BYTE type;
    U_BYTE argCount;
    U_BYTE arrayCount;
    U_WORD varCount;
    U_WORD flags;
    int address;
    int srcLine;
    boolean imported;
    int arraySizes[MAX_SCRIPT_ARRAYS];
} scriptInfo_t;

typedef struct functionInfo_s {
    U_BYTE hasReturnValue;
    U_BYTE argCount;
    U_BYTE localCount;
    U_BYTE arrayCount;
    int address;
    int name;
    int arraySizes[MAX_SCRIPT_ARRAYS];
} functionInfo_t;

typedef struct mapVarInfo_s {
    int initializer;
    boolean isString;
    char *name;
    boolean imported;
} mapVarInfo_t;

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static void GrowBuffer(void);
static void Append(void *buffer, size_t size);
static void Write(void *buffer, size_t size, int address);
static void Skip(size_t size);
static void CloseOld(void);
static void CloseNew(void);
static void CreateDummyScripts(void);
static void RecordDummyScripts(void);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

int pc_Address;
byte *pc_Buffer;
byte *pc_BufferPtr;
int pc_ScriptCount;
int pc_FunctionCount;
boolean pc_NoShrink;
boolean pc_HexenCase;
boolean pc_EnforceHexen;
boolean pc_WarnNotHexen;
boolean pc_WadAuthor = TRUE;
boolean pc_EncryptStrings;
int pc_LastAppendedCommand;
int pc_DummyAddress;

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static size_t BufferSize;
static boolean ObjectOpened = NO;
static scriptInfo_t ScriptInfo[MAX_SCRIPT_COUNT];
static functionInfo_t FunctionInfo[MAX_FUNCTION_COUNT];
static int ArraySizes[MAX_MAP_VARIABLES];
static int *ArrayInits[MAX_MAP_VARIABLES];
static boolean ArrayOfStrings[MAX_MAP_VARIABLES];
static int NumArrays;
static mapVarInfo_t MapVariables[MAX_MAP_VARIABLES];
static boolean MapVariablesInit = NO;
static char ObjectName[MAX_FILE_NAME_LENGTH];
static int ObjectFlags;
static int PushByteAddr;
static char Imports[MAX_IMPORTS][9];
static int NumImports;
static boolean HaveExtendedScripts;
static boolean HaveScriptArrays;

static char *PCDNames[PCODE_COMMAND_COUNT] = {
    "PCD_NOP",
    "PCD_TERMINATE",
    "PCD_SUSPEND",
    "PCD_PUSHNUMBER",
    "PCD_LSPEC1",
    "PCD_LSPEC2",
    "PCD_LSPEC3",
    "PCD_LSPEC4",
    "PCD_LSPEC5",
    "PCD_LSPEC1DIRECT",
    "PCD_LSPEC2DIRECT",
    "PCD_LSPEC3DIRECT",
    "PCD_LSPEC4DIRECT",
    "PCD_LSPEC5DIRECT",
    "PCD_ADD",
    "PCD_SUBTRACT",
    "PCD_MULTIPLY",
    "PCD_DIVIDE",
    "PCD_MODULUS",
    "PCD_EQ",
    "PCD_NE",
    "PCD_LT",
    "PCD_GT",
    "PCD_LE",
    "PCD_GE",
    "PCD_ASSIGNSCRIPTVAR",
    "PCD_ASSIGNMAPVAR",
    "PCD_ASSIGNWORLDVAR",
    "PCD_PUSHSCRIPTVAR",
    "PCD_PUSHMAPVAR",
    "PCD_PUSHWORLDVAR",
    "PCD_ADDSCRIPTVAR",
    "PCD_ADDMAPVAR",
    "PCD_ADDWORLDVAR",
    "PCD_SUBSCRIPTVAR",
    "PCD_SUBMAPVAR",
    "PCD_SUBWORLDVAR",
    "PCD_MULSCRIPTVAR",
    "PCD_MULMAPVAR",
    "PCD_MULWORLDVAR",
    "PCD_DIVSCRIPTVAR",
    "PCD_DIVMAPVAR",
    "PCD_DIVWORLDVAR",
    "PCD_MODSCRIPTVAR",
    "PCD_MODMAPVAR",
    "PCD_MODWORLDVAR",
    "PCD_INCSCRIPTVAR",
    "PCD_INCMAPVAR",
    "PCD_INCWORLDVAR",
    "PCD_DECSCRIPTVAR",
    "PCD_DECMAPVAR",
    "PCD_DECWORLDVAR",
    "PCD_GOTO",
    "PCD_IFGOTO",
    "PCD_DROP",
    "PCD_DELAY",
    "PCD_DELAYDIRECT",
    "PCD_RANDOM",
    "PCD_RANDOMDIRECT",
    "PCD_THINGCOUNT",
    "PCD_THINGCOUNTDIRECT",
    "PCD_TAGWAIT",
    "PCD_TAGWAITDIRECT",
    "PCD_POLYWAIT",
    "PCD_POLYWAITDIRECT",
    "PCD_CHANGEFLOOR",
    "PCD_CHANGEFLOORDIRECT",
    "PCD_CHANGECEILING",
    "PCD_CHANGECEILINGDIRECT",
    "PCD_RESTART",
    "PCD_ANDLOGICAL",
    "PCD_ORLOGICAL",
    "PCD_ANDBITWISE",
    "PCD_ORBITWISE",
    "PCD_EORBITWISE",
    "PCD_NEGATELOGICAL",
    "PCD_LSHIFT",
    "PCD_RSHIFT",
    "PCD_UNARYMINUS",
    "PCD_IFNOTGOTO",
    "PCD_LINESIDE",
    "PCD_SCRIPTWAIT",
    "PCD_SCRIPTWAITDIRECT",
    "PCD_CLEARLINESPECIAL",
    "PCD_CASEGOTO",
    "PCD_BEGINPRINT",
    "PCD_ENDPRINT",
    "PCD_PRINTSTRING",
    "PCD_PRINTNUMBER",
    "PCD_PRINTCHARACTER",
    "PCD_PLAYERCOUNT",
    "PCD_GAMETYPE",
    "PCD_GAMESKILL",
    "PCD_TIMER",
    "PCD_SECTORSOUND",
    "PCD_AMBIENTSOUND",
    "PCD_SOUNDSEQUENCE",
    "PCD_SETLINETEXTURE",
    "PCD_SETLINEBLOCKING",
    "PCD_SETLINESPECIAL",
    "PCD_THINGSOUND",
    "PCD_ENDPRINTBOLD",
    // [RH] End of Hexen p-codes
    "PCD_ACTIVATORSOUND",
    "PCD_LOCALAMBIENTSOUND",
    "PCD_SETLINEMONSTERBLOCKING",
    // [BC] Start of new pcodes
    "PCD_PLAYERBLUESKULL",
    "PCD_PLAYERREDSKULL",
    "PCD_PLAYERYELLOWSKULL",
    "PCD_PLAYERMASTERSKULL",
    "PCD_PLAYERBLUECARD",
    "PCD_PLAYERREDCARD",
    "PCD_PLAYERYELLOWCARD",
    "PCD_PLAYERMASTERCARD",
    "PCD_PLAYERBLACKSKULL",
    "PCD_PLAYERSILVERSKULL",
    "PCD_PLAYERGOLDSKULL",
    "PCD_PLAYERBLACKCARD",
    "PCD_PLAYERSILVERCARD",
    "PCD_ISNETWORKGAME",
    "PCD_PLAYERTEAM",
    "PCD_PLAYERHEALTH",
    "PCD_PLAYERARMORPOINTS",
    "PCD_PLAYERFRAGS",
    "PCD_PLAYEREXPERT",
    "PCD_BLUETEAMCOUNT",
    "PCD_REDTEAMCOUNT",
    "PCD_BLUETEAMSCORE",
    "PCD_REDTEAMSCORE",
    "PCD_ISONEFLAGCTF",
    "PCD_LSPEC6",
    "PCD_LSPEC6DIRECT",
    "PCD_PRINTNAME",
    "PCD_MUSICCHANGE",
    "PCD_CONSOLECOMMANDDIRECT",
    "PCD_CONSOLECOMMAND",
    "PCD_SINGLEPLAYER",
    // [RH] End of Skull Tag p-codes
    "PCD_FIXEDMUL",
    "PCD_FIXEDDIV",
    "PCD_SETGRAVITY",
    "PCD_SETGRAVITYDIRECT",
    "PCD_SETAIRCONTROL",
    "PCD_SETAIRCONTROLDIRECT",
    "PCD_CLEARINVENTORY",
    "PCD_GIVEINVENTORY",
    "PCD_GIVEINVENTORYDIRECT",
    "PCD_TAKEINVENTORY",
    "PCD_TAKEINVENTORYDIRECT",
    "PCD_CHECKINVENTORY",
    "PCD_CHECKINVENTORYDIRECT",
    "PCD_SPAWN",
    "PCD_SPAWNDIRECT",
    "PCD_SPAWNSPOT",
    "PCD_SPAWNSPOTDIRECT",
    "PCD_SETMUSIC",
    "PCD_SETMUSICDIRECT",
    "PCD_LOCALSETMUSIC",
    "PCD_LOCALSETMUSICDIRECT",
    "PCD_PRINTFIXED",
    "PCD_PRINTLOCALIZED",
    "PCD_MOREHUDMESSAGE",
    "PCD_OPTHUDMESSAGE",
    "PCD_ENDHUDMESSAGE",
    "PCD_ENDHUDMESSAGEBOLD",
    "PCD_SETSTYLE",
    "PCD_SETSTYLEDIRECT",
    "PCD_SETFONT",
    "PCD_SETFONTDIRECT",
    "PCD_PUSHBYTE",
    "PCD_LSPEC1DIRECTB",
    "PCD_LSPEC2DIRECTB",
    "PCD_LSPEC3DIRECTB",
    "PCD_LSPEC4DIRECTB",
    "PCD_LSPEC5DIRECTB",
    "PCD_DELAYDIRECTB",
    "PCD_RANDOMDIRECTB",
    "PCD_PUSHBYTES",
    "PCD_PUSH2BYTES",
    "PCD_PUSH3BYTES",
    "PCD_PUSH4BYTES",
    "PCD_PUSH5BYTES",
    "PCD_SETTHINGSPECIAL",
    "PCD_ASSIGNGLOBALVAR",
    "PCD_PUSHGLOBALVAR",
    "PCD_ADDGLOBALVAR",
    "PCD_SUBGLOBALVAR",
    "PCD_MULGLOBALVAR",
    "PCD_DIVGLOBALVAR",
    "PCD_MODGLOBALVAR",
    "PCD_INCGLOBALVAR",
    "PCD_DECGLOBALVAR",
    "PCD_FADETO",
    "PCD_FADERANGE",
    "PCD_CANCELFADE",
    "PCD_PLAYMOVIE",
    "PCD_SETFLOORTRIGGER",
    "PCD_SETCEILINGTRIGGER",
    "PCD_GETACTORX",
    "PCD_GETACTORY",
    "PCD_GETACTORZ",
    "PCD_STARTTRANSLATION",
    "PCD_TRANSLATIONRANGE1",
    "PCD_TRANSLATIONRANGE2",
    "PCD_ENDTRANSLATION",
    "PCD_CALL",
    "PCD_CALLDISCARD",
    "PCD_RETURNVOID",
    "PCD_RETURNVAL",
    "PCD_PUSHMAPARRAY",
    "PCD_ASSIGNMAPARRAY",
    "PCD_ADDMAPARRAY",
    "PCD_SUBMAPARRAY",
    "PCD_MULMAPARRAY",
    "PCD_DIVMAPARRAY",
    "PCD_MODMAPARRAY",
    "PCD_INCMAPARRAY",
    "PCD_DECMAPARRAY",
    "PCD_DUP",
    "PCD_SWAP",
    "PCD_WRITETOINI",
    "PCD_GETFROMINI",
    "PCD_SIN",
    "PCD_COS",
    "PCD_VECTORANGLE",
    "PCD_CHECKWEAPON",
    "PCD_SETWEAPON",
    "PCD_TAGSTRING",
    "PCD_PUSHWORLDARRAY",
    "PCD_ASSIGNWORLDARRAY",
    "PCD_ADDWORLDARRAY",
    "PCD_SUBWORLDARRAY",
    "PCD_MULWORLDARRAY",
    "PCD_DIVWORLDARRAY",
    "PCD_MODWORLDARRAY",
    "PCD_INCWORLDARRAY",
    "PCD_DECWORLDARRAY",
    "PCD_PUSHGLOBALARRAY",
    "PCD_ASSIGNGLOBALARRAY",
    "PCD_ADDGLOBALARRAY",
    "PCD_SUBGLOBALARRAY",
    "PCD_MULGLOBALARRAY",
    "PCD_DIVGLOBALARRAY",
    "PCD_MODGLOBALARRAY",
    "PCD_INCGLOBALARRAY",
    "PCD_DECGLOBALARRAY",
    "PCD_SETMARINEWEAPON",
    "PCD_SETACTORPROPERTY",
    "PCD_GETACTORPROPERTY",
    "PCD_PLAYERNUMBER",
    "PCD_ACTIVATORTID",
    "PCD_SETMARINESPRITE",
    "PCD_GETSCREENWIDTH",
    "PCD_GETSCREENHEIGHT",
    "PCD_THING_PROJECTILE2",
    "PCD_STRLEN",
    "PCD_SETHUDSIZE",
    "PCD_GETCVAR",
    "PCD_CASEGOTOSORTED",
    "PCD_SETRESULTVALUE",
    "PCD_GETLINEROWOFFSET",
    "PCD_GETACTORFLOORZ",
    "PCD_GETACTORANGLE",
    "PCD_GETSECTORFLOORZ",
    "PCD_GETSECTORCEILINGZ",
    "PCD_LSPEC5RESULT",
    "PCD_GETSIGILPIECES",
    "PCD_GELEVELINFO",
    "PCD_CHANGESKY",
    "PCD_PLAYERINGAME",
    "PCD_PLAYERISBOT",
    "PCD_SETCAMERATOTEXTURE",
    "PCD_ENDLOG",
    "PCD_GETAMMOCAPACITY",
    "PCD_SETAMMOCAPACITY",
    // [JB] start of new pcodes
    "PCD_PRINTMAPCHARARRAY",
    "PCD_PRINTWORLDCHARARRAY",
    "PCD_PRINTGLOBALCHARARRAY",
    // [JB] end of new pcodes
    "PCD_SETACTORANGLE",
    "PCD_GRABINPUT",
    "PCD_SETMOUSEPOINTER",
    "PCD_MOVEMOUSEPOINTER",
    "PCD_SPAWNPROJECTILE",
    "PCD_GETSECTORLIGHTLEVEL",
    "PCD_GETACTORCEILINGZ",
    "PCD_SETACTORPOSITION",
    "PCD_CLEARACTORINVENTORY",
    "PCD_GIVEACTORINVENTORY",
    "PCD_TAKEACTORINVENTORY",
    "PCD_CHECKACTORINVENTORY",
    "PCD_THINGCOUNTNAME",
    "PCD_SPAWNSPOTFACING",
    "PCD_PLAYERCLASS",
    //[MW] start my p-codes
    "PCD_ANDSCRIPTVAR",
    "PCD_ANDMAPVAR",
    "PCD_ANDWORLDVAR",
    "PCD_ANDGLOBALVAR",
    "PCD_ANDMAPARRAY",
    "PCD_ANDWORLDARRAY",
    "PCD_ANDGLOBALARRAY",
    "PCD_EORSCRIPTVAR",
    "PCD_EORMAPVAR",
    "PCD_EORWORLDVAR",
    "PCD_EORGLOBALVAR",
    "PCD_EORMAPARRAY",
    "PCD_EORWORLDARRAY",
    "PCD_EORGLOBALARRAY",
    "PCD_ORSCRIPTVAR",
    "PCD_ORMAPVAR",
    "PCD_ORWORLDVAR",
    "PCD_ORGLOBALVAR",
    "PCD_ORMAPARRAY",
    "PCD_ORWORLDARRAY",
    "PCD_ORGLOBALARRAY",
    "PCD_LSSCRIPTVAR",
    "PCD_LSMAPVAR",
    "PCD_LSWORLDVAR",
    "PCD_LSGLOBALVAR",
    "PCD_LSMAPARRAY",
    "PCD_LSWORLDARRAY",
    "PCD_LSGLOBALARRAY",
    "PCD_RSSCRIPTVAR",
    "PCD_RSMAPVAR",
    "PCD_RSWORLDVAR",
    "PCD_RSGLOBALVAR",
    "PCD_RSMAPARRAY",
    "PCD_RSWORLDARRAY",
    "PCD_RSGLOBALARRAY",
    //[MW] end my p-codes
    "PCD_GETPLAYERINFO",
    "PCD_CHANGELEVEL",
    "PCD_SECTORDAMAGE",
    "PCD_REPLACETEXTURES",
    "PCD_NEGATEBINARY",
    "PCD_GETACTORPITCH",
    "PCD_SETACTORPITCH",
    "PCD_PRINTBIND",
    "PCD_SETACTORSTATE",
    "PCD_THINGDAMAGE2",
    "PCD_USEINVENTORY",
    "PCD_USEACTORINVENTORY",
    "PCD_CHECKACTORCEILINGTEXTURE",
    "PCD_CHECKACTORFLOORTEXTURE",
    "PCD_GETACTORLIGHTLEVEL",
    "PCD_SETMUGSHOTSTATE",
    "PCD_THINGCOUNTSECTOR",
    "PCD_THINGCOUNTNAMESECTOR",
    "PCD_CHECKPLAYERCAMERA",
    "PCD_MORPHACTOR",
    "PCD_UNMORPHACTOR",
    "PCD_GETPLAYERINPUT",
    "PCD_CLASSIFYACTOR",
    "PCD_PRINTBINARY",
    "PCD_PRINTHEX",
    "PCD_CALLFUNC",
    "PCD_SAVESTRING",       // [FDARI]
    "PCD_PRINTMAPCHRANGE",  // [FDARI] output range
    "PCD_PRINTWORLDCHRANGE",
    "PCD_PRINTGLOBALCHRANGE",
    "PCD_STRCPYTOMAPCHRANGE",  // [FDARI] input range
    "PCD_STRCPYTOWORLDCHRANGE",
    "PCD_STRCPYTOGLOBALCHRANGE",
    "PCD_PUSHFUNCTION",  // from Eternity
    "PCD_CALLSTACK",     // from Eternity
    "PCD_SCRIPTWAITNAMED",
    "PCD_TRANSLATIONRANGE3",
    "PCD_GOTOSTACK",
    "PCD_ASSIGNSCRIPTARRAY",
    "PCD_PUSHSCRIPTARRAY",
    "PCD_ADDSCRIPTARRAY",
    "PCD_SUBSCRIPTARRAY",
    "PCD_MULSCRIPTARRAY",
    "PCD_DIVSCRIPTARRAY",
    "PCD_MODSCRIPTARRAY",
    "PCD_INCSCRIPTARRAY",
    "PCD_DECSCRIPTARRAY",
    "PCD_ANDSCRIPTARRAY",
    "PCD_EORSCRIPTARRAY",
    "PCD_ORSCRIPTARRAY",
    "PCD_LSSCRIPTARRAY",
    "PCD_RSSCRIPTARRAY",
    "PCD_PRINTSCRIPTCHARARRAY",
    "PCD_PRINTSCRIPTCHRANGE",
    "PCD_STRCPYTOSCRIPTCHRANGE",
    "PCD_LSPEC5EX",
    "PCD_LSPEC5EXRESULT",
};

// CODE --------------------------------------------------------------------

//==========================================================================
//
// PC_OpenObject
//
//==========================================================================

void PC_OpenObject(char *name, size_t size, int flags) {
    if (ObjectOpened == YES) {
        PC_CloseObject();
    }
    if (strlen(name) >= MAX_FILE_NAME_LENGTH) {
        ERR_Exit(ERR_FILE_NAME_TOO_LONG, NO, name);
    }
    strcpy(ObjectName, name);
    pc_Buffer = (byte *)MS_Alloc(size, ERR_ALLOC_PCODE_BUFFER);
    pc_BufferPtr = pc_Buffer;
    pc_Address = 0;
    ObjectFlags = flags;
    BufferSize = size;
    pc_ScriptCount = 0;
    ObjectOpened = YES;
    PC_AppendString("ACS");
    PC_SkipInt();  // Script table offset
}

//==========================================================================
//
// PC_CloseObject
//
//==========================================================================

void PC_CloseObject(void) {
    MS_Message(MSG_DEBUG, "---- PC_CloseObject ----\n");
    while (pc_Address & 3) {
        PC_AppendByte(0);
    }
    if (!pc_NoShrink || (NumStringLists > 0) || (pc_FunctionCount > 0) ||
        MapVariablesInit || NumArrays != 0 || pc_EncryptStrings ||
        NumImports != 0 || HaveExtendedScripts || HaveScriptArrays) {
        if (pc_EnforceHexen) {
            ERR_Exit(ERR_NOT_HEXEN, NO);
        }
        if (pc_WarnNotHexen) {
            fprintf(stderr,
                    "\nThese scripts have been upgraded because they use new "
                    "features.\n"
                    "They will not be compatible with Hexen.\n");
        }
        CloseNew();
    } else {
        CloseOld();
    }
    if (MS_SaveFile(ObjectName, pc_Buffer, pc_Address) == FALSE) {
        ERR_Exit(ERR_SAVE_OBJECT_FAILED, NO);
    }
}

//==========================================================================
//
// CloseOld
//
//==========================================================================

static void CloseOld(void) {
    int i;

    STR_WriteStrings();
    PC_WriteInt((U_INT)pc_Address, 4);
    PC_AppendInt((U_INT)pc_ScriptCount);
    for (i = 0; i < pc_ScriptCount; ++i) {
        scriptInfo_t *info = &ScriptInfo[i];
        MS_Message(MSG_DEBUG, "Script %d, address = %d, arg count = %d\n",
                   info->number, info->address, info->argCount);
        PC_AppendInt((U_INT)(info->number + info->type * 1000));
        PC_AppendInt((U_INT)info->address);
        PC_AppendInt((U_INT)info->argCount);
    }
    STR_WriteList();
}

//==========================================================================
//
// CloseNew
//
// Creates a new-format ACS file. For programs that don't know any better,
// this will look just like an old ACS file with no scripts or strings but
// with some extra junk in the middle. Both WadAuthor and DeePsea will not
// accept ACS files that do not have the ACS\0 header. Worse, WadAuthor
// will hang if the file begins with ACS\0 but does not look like something
// that might have been created with Raven's ACC. Thus, the chunks live in
// the string block, and there are two 0 dwords at the end of the file.
//
//==========================================================================

static void CloseNew(void) {
    int i, j, count;
    int chunkStart;

    if (pc_WadAuthor) {
        CreateDummyScripts();
    }

    chunkStart = pc_Address;

    // Only write out those scripts that this acs file actually provides.
    for (i = j = 0; i < pc_ScriptCount; ++i) {
        if (!ScriptInfo[i].imported) {
            ++j;
        }
    }
    if (j > 0) {
        PC_Append((void *)"SPTR", 4);
        PC_AppendInt(j * 8);
        for (i = 0; i < pc_ScriptCount; i++) {
            scriptInfo_t *info = &ScriptInfo[i];
            if (!info->imported) {
                MS_Message(MSG_DEBUG,
                           "Script %d, address = %d, arg count = %d\n",
                           info->number, info->address, info->argCount);
                PC_AppendWord(info->number);
                PC_AppendByte(info->type);
                PC_AppendByte(info->argCount);
                PC_AppendInt((U_INT)info->address);
            }
        }
    }

    // If any scripts have more than the maximum number of arguments, output
    // them.
    for (i = j = 0; i < pc_ScriptCount; ++i) {
        if (!ScriptInfo[i].imported &&
            ScriptInfo[i].varCount > MAX_SCRIPT_VARIABLES) {
            ++j;
        }
    }
    if (j > 0) {
        PC_Append((void *)"SVCT", 4);
        PC_AppendInt(j * 4);
        for (i = 0; i < pc_ScriptCount; ++i) {
            scriptInfo_t *info = &ScriptInfo[i];
            if (!info->imported && info->varCount > MAX_SCRIPT_VARIABLES) {
                MS_Message(MSG_DEBUG, "Script %d, var count = %d\n",
                           info->number, info->varCount);
                PC_AppendWord(info->number);
                PC_AppendWord(info->varCount);
            }
        }
    }

    // Write script flags in a separate chunk, so older ZDooms don't get
    // confused
    for (i = j = 0; i < pc_ScriptCount; ++i) {
        if (!ScriptInfo[i].imported && ScriptInfo[i].flags != 0) {
            ++j;
        }
    }
    if (j > 0) {
        PC_Append((void *)"SFLG", 4);
        PC_AppendInt(j * 4);
        for (i = 0; i < pc_ScriptCount; ++i) {
            scriptInfo_t *info = &ScriptInfo[i];
            if (!info->imported && info->flags != 0) {
                PC_AppendWord(info->number);
                PC_AppendWord(info->flags);
            }
        }
    }

    // Add chunks for scripts with arrays
    for (i = 0; i < pc_ScriptCount; ++i) {
        if (ScriptInfo[i].arrayCount) {
            PC_Append((void *)"SARY", 4);
            PC_AppendInt(2 + ScriptInfo[i].arrayCount * 4);
            PC_AppendWord(ScriptInfo[i].number);
            for (j = 0; j < ScriptInfo[i].arrayCount; ++j) {
                PC_AppendInt(ScriptInfo[i].arraySizes[j]);
            }
        }
    }

    // Write the string table for named scripts.
    STR_WriteListChunk(STRLIST_NAMEDSCRIPTS, MAKE4CC('S', 'N', 'A', 'M'), NO);

    // Write the functions provided by this file.
    if (pc_FunctionCount > 0) {
        PC_Append((void *)"FUNC", 4);
        PC_AppendInt(pc_FunctionCount * 8);
        for (i = 0; i < pc_FunctionCount; ++i) {
            functionInfo_t *info = &FunctionInfo[i];
            MS_Message(MSG_DEBUG,
                       "Function %d:%s, address = %d, arg count = %d, var "
                       "count = %d\n",
                       i, STR_GetString(STRLIST_FUNCTIONS, info->name),
                       info->address, info->argCount, info->localCount);
            PC_AppendByte(info->argCount);
            PC_AppendByte(info->localCount);
            PC_AppendByte((U_BYTE)(info->hasReturnValue ? 1 : 0));
            PC_AppendByte(0);
            PC_AppendInt((U_INT)info->address);
        }
        STR_WriteListChunk(STRLIST_FUNCTIONS, MAKE4CC('F', 'N', 'A', 'M'), NO);
    }

    // Add chunks for functions with arrays
    for (i = 0; i < pc_FunctionCount; ++i) {
        if (FunctionInfo[i].arrayCount) {
            PC_Append((void *)"FARY", 4);
            PC_AppendInt(2 + FunctionInfo[i].arrayCount * 4);
            PC_AppendWord((U_WORD)i);
            for (j = 0; j < FunctionInfo[i].arrayCount; ++j) {
                PC_AppendInt(FunctionInfo[i].arraySizes[j]);
            }
        }
    }

    if (STR_ListSize() > 0) {
        STR_WriteChunk(pc_EncryptStrings);
    }

    STR_WriteListChunk(STRLIST_PICS, MAKE4CC('P', 'I', 'C', 'S'), NO);
    if (MapVariablesInit) {
        int j;

        for (i = 0; i < pa_MapVarCount; ++i) {
            if (MapVariables[i].initializer != 0) break;
        }
        for (j = pa_MapVarCount - 1; j > i; --j) {
            if (MapVariables[j].initializer != 0) break;
        }
        ++j;

        if (i < j) {
            PC_Append((void *)"MINI", 4);
            PC_AppendInt((j - i) * 4 + 4);
            PC_AppendInt(i);  // First map var defined
            for (; i < j; ++i) {
                PC_AppendInt(MapVariables[i].initializer);
            }
        }
    }

    // If this is a library, record which map variables are
    // initialized with strings.
    if (ImportMode == IMPORT_Exporting) {
        count = 0;

        for (i = 0; i < pa_MapVarCount; ++i) {
            if (MapVariables[i].isString) {
                ++count;
            }
        }
        if (count > 0) {
            PC_Append((void *)"MSTR", 4);
            PC_AppendInt(count * 4);
            for (i = 0; i < pa_MapVarCount; ++i) {
                if (MapVariables[i].isString) {
                    PC_AppendInt(i);
                }
            }
        }

        // Now do the same thing for arrays.
        for (count = 0, i = 0; i < pa_MapVarCount; ++i) {
            if (ArrayOfStrings[i]) {
                ++count;
            }
        }
        if (count > 0) {
            PC_Append((void *)"ASTR", 4);
            PC_AppendInt(count * 4);
            for (i = 0; i < pa_MapVarCount; ++i) {
                if (ArrayOfStrings[i]) {
                    PC_AppendInt(i);
                }
            }
        }
    }

    // Publicize the names of map variables in a library.
    if (ImportMode == IMPORT_Exporting) {
        for (i = 0; i < pa_MapVarCount; ++i) {
            if (!MapVariables[i].imported) {
                STR_AppendToList(STRLIST_MAPVARS, MapVariables[i].name);
            } else {
                STR_AppendToList(STRLIST_MAPVARS, NULL);
            }
        }
        STR_WriteListChunk(STRLIST_MAPVARS, MAKE4CC('M', 'E', 'X', 'P'), NO);
    }

    // Record the names of imported map variables
    count = 0;
    for (i = 0; i < pa_MapVarCount; ++i) {
        if (MapVariables[i].imported && !ArraySizes[i]) {
            count += 5 + strlen(MapVariables[i].name);
        }
    }
    if (count > 0) {
        PC_Append((void *)"MIMP", 4);
        PC_AppendInt(count);
        for (i = 0; i < pa_MapVarCount; ++i) {
            if (MapVariables[i].imported && !ArraySizes[i]) {
                PC_AppendInt(i);
                PC_AppendString(MapVariables[i].name);
            }
        }
    }

    if (NumArrays) {
        int count;

        // Arrays defined here
        for (count = 0, i = 0; i < pa_MapVarCount; ++i) {
            if (ArraySizes[i] && !MapVariables[i].imported) {
                ++count;
            }
        }
        if (count) {
            PC_Append((void *)"ARAY", 4);
            PC_AppendInt(count * 8);
            for (i = 0; i < pa_MapVarCount; ++i) {
                if (ArraySizes[i] && !MapVariables[i].imported) {
                    PC_AppendInt(i);
                    PC_AppendInt(ArraySizes[i]);
                }
            }
            for (i = 0; i < pa_MapVarCount; ++i) {
                if (ArrayInits[i]) {
                    int j;

                    PC_Append((void *)"AINI", 4);
                    PC_AppendInt(ArraySizes[i] * 4 + 4);
                    PC_AppendInt((U_INT)i);
                    MS_Message(
                        MSG_DEBUG,
                        "Writing array initializers for array %d (size %d)\n",
                        i, ArraySizes[i]);
                    for (j = 0; j < ArraySizes[i]; ++j) {
                        PC_AppendInt((U_INT)ArrayInits[i][j]);
                    }
                }
            }
        }

        // Arrays imported from elsewhere
        for (count = 0, j = i = 0; i < pa_MapVarCount; ++i) {
            if (ArraySizes[i] && MapVariables[i].imported) {
                count += 9 + strlen(MapVariables[i].name);
                ++j;
            }
        }
        if (count) {
            PC_Append((void *)"AIMP", 4);
            PC_AppendInt(count + 4);
            PC_AppendInt(j);
            for (i = 0; i < pa_MapVarCount; ++i) {
                if (ArraySizes[i] && MapVariables[i].imported) {
                    PC_AppendInt(i);
                    PC_AppendInt(ArraySizes[i]);
                    PC_AppendString(MapVariables[i].name);
                }
            }
        }
    }

    // Add a dummy chunk to indicate if this object is a library.
    if (ImportMode == IMPORT_Exporting) {
        PC_Append((void *)"ALIB", 4);
        PC_AppendInt(0);
    }

    // Record libraries imported by this object.
    if (NumImports > 0) {
        count = 0;
        for (i = 0; i < NumImports; ++i) {
            count += strlen(Imports[i]) + 1;
        }
        if (count > 0) {
            PC_Append((void *)"LOAD", 4);
            PC_AppendInt(count);
            for (i = 0; i < NumImports; ++i) {
                PC_AppendString(Imports[i]);
            }
        }
    }

    PC_AppendInt((U_INT)chunkStart);
    if (pc_NoShrink) {
        PC_Append((void *)"ACSE", 4);
    } else {
        PC_Append((void *)"ACSe", 4);
    }
    PC_WriteInt((U_INT)pc_Address, 4);

    // WadAuthor compatibility when creating a library is pointless, because
    // that editor does not know anything about libraries and will never
    // find their scripts ever.
    if (pc_WadAuthor && ImportMode != IMPORT_Exporting) {
        RecordDummyScripts();
    } else {
        PC_AppendInt(0);
    }
    PC_AppendInt(0);
}

//==========================================================================
//
// CreateDummyScripts
//
//==========================================================================

static void CreateDummyScripts(void) {
    int i;

    MS_Message(MSG_DEBUG, "Creating dummy scripts to make WadAuthor happy.\n");
    if (pc_Address % 4 != 0) {  // Need to align
        U_INT pad = 0;
        PC_Append((void *)&pad, 4 - (pc_Address % 4));
    }
    pc_DummyAddress = pc_Address;
    for (i = 0; i < pc_ScriptCount; ++i) {
        // Only create dummies for scripts WadAuthor could care about.
        if (!ScriptInfo[i].imported && ScriptInfo[i].number >= 0 &&
            ScriptInfo[i].number <= 255) {
            PC_AppendCmd(PCD_TERMINATE);
            if (!pc_NoShrink) {
                PC_AppendCmd(PCD_NOP);
                PC_AppendCmd(PCD_NOP);
                PC_AppendCmd(PCD_NOP);
            }
        }
    }
}

//==========================================================================
//
// RecordDummyScripts
//
//==========================================================================

static void RecordDummyScripts(void) {
    int i, j, count;

    for (i = count = 0; i < pc_ScriptCount; ++i) {
        if (!ScriptInfo[i].imported && ScriptInfo[i].number >= 0 &&
            ScriptInfo[i].number <= 255) {
            ++count;
        }
    }
    PC_AppendInt((U_INT)count);
    for (i = j = 0; i < pc_ScriptCount; ++i) {
        scriptInfo_t *info = &ScriptInfo[i];
        if (!info->imported && info->number >= 0 &&
            ScriptInfo[i].number <= 255) {
            MS_Message(MSG_DEBUG,
                       "Dummy script %d, address = %d, arg count = %d\n",
                       info->number, info->address, info->argCount);
            PC_AppendInt((U_INT)info->number);
            PC_AppendInt((U_INT)pc_DummyAddress + j * 4);
            PC_AppendInt((U_INT)info->argCount);
            j++;
        }
    }
}

//==========================================================================
//
// GrowBuffer
//
//==========================================================================

void GrowBuffer(void) {
    ptrdiff_t buffpos = pc_BufferPtr - pc_Buffer;

    BufferSize *= 2;
    pc_Buffer =
        (byte *)MS_Realloc(pc_Buffer, BufferSize, ERR_PCODE_BUFFER_OVERFLOW);
    pc_BufferPtr = pc_Buffer + buffpos;
}

//==========================================================================
//
// PC_Append functions
//
//==========================================================================

static void Append(void *buffer, size_t size) {
    if (ImportMode != IMPORT_Importing) {
        if (pc_Address + size > BufferSize) {
            GrowBuffer();
        }
        memcpy(pc_BufferPtr, buffer, size);
        pc_BufferPtr += size;
        pc_Address += size;
    }
}

void PC_Append(void *buffer, size_t size) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "AD> %06d = (%d bytes)\n", pc_Address, size);
        Append(buffer, size);
    }
}

void PC_AppendByte(U_BYTE val) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "AB> %06d = %d\n", pc_Address, val);
        Append(&val, sizeof(U_BYTE));
    }
}

void PC_AppendWord(U_WORD val) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "AW> %06d = %d\n", pc_Address, val);
        val = MS_LittleUWORD(val);
        Append(&val, sizeof(U_WORD));
    }
}

void PC_AppendInt(U_INT val) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "AL> %06d = %d\n", pc_Address, val);
        val = MS_LittleUINT(val);
        Append(&val, sizeof(U_INT));
    }
}

void PC_AppendString(char *string) {
    if (ImportMode != IMPORT_Importing) {
        int length;

        length = strlen(string) + 1;
        MS_Message(MSG_DEBUG, "AS> %06d = \"%s\" (%d bytes)\n", pc_Address,
                   string, length);
        Append(string, length);
    }
}

void PC_AppendCmd(pcd_t command) {
    boolean dupbyte = NO;
    if (ImportMode != IMPORT_Importing) {
        pc_LastAppendedCommand = command;
        if (pc_NoShrink) {
            MS_Message(MSG_DEBUG, "AC> %06d = #%d:%s\n", pc_Address, command,
                       PCDNames[command]);
            command = (pcd_t)MS_LittleUINT(command);
            Append(&command, sizeof(U_INT));
        } else {
            U_BYTE cmd;
            if (command == PCD_DUP &&
                PushByteAddr) {  // If the last instruction was PCD_PUSHBYTE,
                                 // convert this PCD_DUP to a duplicate
                                 // PCD_PUSHBYTE, so it can be merged into a
                                 // single instruction below.
                command = PCD_PUSHBYTE;
                dupbyte = YES;
                MS_Message(MSG_DEBUG, "AC> PCD_DUP changed to PCD_PUSHBYTE\n");
            } else if (command != PCD_PUSHBYTE &&
                       PushByteAddr) {  // Maybe shrink a PCD_PUSHBYTE sequence
                                        // into PCD_PUSHBYTES
                int runlen = (pc_Address - PushByteAddr) / 2;
                int i;

                if (runlen > 5) {
                    pc_Buffer[PushByteAddr] = PCD_PUSHBYTES;
                    for (i = 0; i < runlen; i++) {
                        pc_Buffer[PushByteAddr + i + 2] =
                            pc_Buffer[PushByteAddr + i * 2 + 1];
                    }
                    pc_Buffer[PushByteAddr + 1] = runlen;
                    pc_Address = PushByteAddr + runlen + 2;
                    pc_BufferPtr = pc_Buffer + pc_Address;
                    MS_Message(MSG_DEBUG,
                               "AC> Last %d PCD_PUSHBYTEs changed to "
                               "#%d:PCD_PUSHBYTES\n",
                               runlen, PCD_PUSHBYTES);
                } else if (runlen > 1) {
                    pc_Buffer[PushByteAddr] = PCD_PUSH2BYTES + runlen - 2;
                    for (i = 1; i < runlen; i++) {
                        pc_Buffer[PushByteAddr + 1 + i] =
                            pc_Buffer[PushByteAddr + 1 + i * 2];
                    }
                    pc_Address = PushByteAddr + runlen + 1;
                    pc_BufferPtr = pc_Buffer + pc_Address;
                    MS_Message(MSG_DEBUG,
                               "AC> Last %d PCD_PUSHBYTEs changed to "
                               "#%d:PCD_PUSH%dBYTES\n",
                               runlen, PCD_PUSH2BYTES + runlen - 2, runlen);
                }
                PushByteAddr = 0;
            } else if (command == PCD_PUSHBYTE &&
                       PushByteAddr == 0) {  // Remember the first PCD_PUSHBYTE,
                                             // in case there are more
                PushByteAddr = pc_Address;
            }
            MS_Message(MSG_DEBUG, "AC> %06d = #%d:%s\n", pc_Address, command,
                       PCDNames[command]);

            if (command < 256 - 16) {
                cmd = command;
                Append(&cmd, sizeof(U_BYTE));
            } else {
                // Room for expansion: The top 16 pcodes in the [0,255]
                // range select a set of pcodes, and the next byte is
                // the pcode in that set.
                cmd = ((command - (256 - 16)) >> 8) + (256 - 16);
                Append(&cmd, sizeof(U_BYTE));
                cmd = (command - (256 - 16)) & 255;
                Append(&cmd, sizeof(U_BYTE));
            }
            if (dupbyte) {
                PC_AppendByte(pc_Buffer[pc_Address - 2]);
            }
        }
    }
}

//==========================================================================
//
// PC_AppendShrink
//
//==========================================================================

void PC_AppendShrink(U_BYTE val) {
    if (pc_NoShrink) {
        PC_AppendInt(val);
    } else {
        PC_AppendByte(val);
    }
}

//==========================================================================
//
// PC_AppendPushVal
//
//==========================================================================

void PC_AppendPushVal(U_INT val) {
    if (pc_NoShrink || val > 255) {
        PC_AppendCmd(PCD_PUSHNUMBER);
        PC_AppendInt(val);
    } else {
        PC_AppendCmd(PCD_PUSHBYTE);
        PC_AppendByte((U_BYTE)val);
    }
}

//==========================================================================
//
// PC_Write functions
//
//==========================================================================

static void Write(void *buffer, size_t size, int address) {
    if (ImportMode != IMPORT_Importing) {
        if (address + size > BufferSize) {
            GrowBuffer();
        }
        memcpy(pc_Buffer + address, buffer, size);
    }
}

void PC_Write(void *buffer, size_t size, int address) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "WD> %06d = (%d bytes)\n", address, size);
        Write(buffer, size, address);
    }
}

void PC_WriteByte(U_BYTE val, int address) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "WB> %06d = %d\n", address, val);
        Write(&val, sizeof(U_BYTE), address);
    }
}

/*
void PC_WriteWord(U_WORD val, int address)
{
        MS_Message(MSG_DEBUG, "WW> %06d = %d\n", address, val);
        val = MS_LittleUWORD(val);
        Write(&val, sizeof(U_WORD), address);
}
*/

void PC_WriteInt(U_INT val, int address) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "WL> %06d = %d\n", address, val);
        val = MS_LittleUINT(val);
        Write(&val, sizeof(U_INT), address);
    }
    pc_LastAppendedCommand = PCD_NOP;
}

void PC_WriteString(char *string, int address) {
    if (ImportMode != IMPORT_Importing) {
        int length;

        length = strlen(string) + 1;
        MS_Message(MSG_DEBUG, "WS> %06d = \"%s\" (%d bytes)\n", address, string,
                   length);
        Write(string, length, address);
    }
}

void PC_WriteCmd(pcd_t command, int address) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "WC> %06d = #%d:%s\n", address, command,
                   PCDNames[command]);
        command = (pcd_t)MS_LittleUINT(command);
        Write(&command, sizeof(U_INT), address);
    }
}

//==========================================================================
//
// PC_Skip functions
//
//==========================================================================

static void Skip(size_t size) {
    if (ImportMode != IMPORT_Importing) {
        if (pc_Address + size > BufferSize) {
            GrowBuffer();
        }
        pc_BufferPtr += size;
        pc_Address += size;
    }
}

void PC_Skip(size_t size) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "SD> %06d (skip %d bytes)\n", pc_Address, size);
        Skip(size);
    }
}

/*
void PC_SkipByte(void)
{
        MS_Message(MSG_DEBUG, "SB> %06d (skip byte)\n", pc_Address);
        Skip(sizeof(U_BYTE));
}
*/

/*
void PC_SkipWord(void)
{
        MS_Message(MSG_DEBUG, "SW> %06d (skip word)\n", pc_Address);
        Skip(sizeof(U_WORD));
}
*/

void PC_SkipInt(void) {
    if (ImportMode != IMPORT_Importing) {
        MS_Message(MSG_DEBUG, "SL> %06d (skip int)\n", pc_Address);
        Skip(sizeof(U_INT));
    }
}

//==========================================================================
//
// PC_PutMapVariable
//
//==========================================================================

void PC_PutMapVariable(int index, int value) {
    if (index < MAX_MAP_VARIABLES) {
        MapVariables[index].isString = pa_ConstExprIsString;
        MapVariables[index].initializer = value;
        MapVariablesInit = YES;
        if (pc_EnforceHexen) {
            ERR_Error(ERR_HEXEN_COMPAT, YES);
        }
    }
}

//==========================================================================
//
// PC_NameMapVariable
//
//==========================================================================

void PC_NameMapVariable(int index, symbolNode_t *sym) {
    if (index < MAX_MAP_VARIABLES) {
        MapVariables[index].name = sym->name;
        MapVariables[index].imported = sym->imported;
    }
}

//==========================================================================
//
// PC_AddScript
//
//==========================================================================

void PC_AddScript(int number, int type, int flags, int argCount) {
    scriptInfo_t *script;
    int i;

    if (flags != 0 || number < 0 || number >= 1000) {
        HaveExtendedScripts = YES;
        if (pc_EnforceHexen) {
            ERR_Error(ERR_HEXEN_COMPAT, YES);
        }
    }

    for (i = 0; i < pc_ScriptCount; i++) {
        if (ScriptInfo[i].number == number) {
            ERR_Error(ERR_SCRIPT_ALREADY_DEFINED, YES);
        }
    }
    if (pc_ScriptCount == MAX_SCRIPT_COUNT) {
        ERR_Error(ERR_TOO_MANY_SCRIPTS, YES);
    } else {
        script = &ScriptInfo[pc_ScriptCount];
        script->number = number;
        script->type = type;
        script->address = (ImportMode == IMPORT_Importing) ? 0 : pc_Address;
        script->argCount = argCount;
        script->flags = flags;
        script->srcLine = tk_Line;
        script->imported = (ImportMode == IMPORT_Importing) ? YES : NO;
        script->arrayCount = 0;
        pc_ScriptCount++;
    }
}

//==========================================================================
//
// PC_SetScriptVarCount
//
// Sets the number of local variables used by a script, including
// arguments.
//
//==========================================================================

void PC_SetScriptVarCount(int number, int type, int varCount, int arrayCount,
                          int *arraySizes) {
    int i;

    for (i = 0; i < pc_ScriptCount; i++) {
        if (ScriptInfo[i].number == number && ScriptInfo[i].type == type) {
            ScriptInfo[i].varCount = varCount;
            if (arrayCount > 0 && arrayCount < MAX_SCRIPT_ARRAYS) {
                ScriptInfo[i].arrayCount = (U_BYTE)arrayCount;
                memcpy(ScriptInfo[i].arraySizes, arraySizes,
                       arrayCount * sizeof(int));
                HaveScriptArrays = YES;
            }
            break;
        }
    }
}

//==========================================================================
//
// PC_AddFunction
//
//==========================================================================

void PC_AddFunction(symbolNode_t *sym, int arrayCount, int *arraySizes) {
    functionInfo_t *function;
    int maxFunctionCount =
        pc_NoShrink ? MAX_FUNCTION_COUNT : (1 << CHAR_BIT * sizeof(U_BYTE));

    if (pc_FunctionCount == maxFunctionCount) {
        ERR_Error(ERR_TOO_MANY_FUNCTIONS, YES, NULL);
    }
    function = &FunctionInfo[pc_FunctionCount];
    function->hasReturnValue = (U_BYTE)sym->info.scriptFunc.hasReturnValue;
    function->argCount = (U_BYTE)sym->info.scriptFunc.argCount;
    function->localCount = (U_BYTE)sym->info.scriptFunc.varCount;
    function->name = STR_AppendToList(STRLIST_FUNCTIONS, sym->name);
    function->address = sym->info.scriptFunc.address;
    sym->info.scriptFunc.funcNumber = pc_FunctionCount;
    if (arrayCount > 0 && arrayCount < MAX_SCRIPT_ARRAYS) {
        function->arrayCount = (U_BYTE)arrayCount;
        memcpy(function->arraySizes, arraySizes, arrayCount * sizeof(int));
        HaveScriptArrays = YES;
    } else {
        function->arrayCount = 0;
    }
    pc_FunctionCount++;
}

//==========================================================================
//
// PC_AddArray
//
//==========================================================================

void PC_AddArray(int index, int size) {
    NumArrays++;
    ArraySizes[index] = size;
    if (pc_EnforceHexen) {
        ERR_Error(ERR_HEXEN_COMPAT, YES);
    }
}

//==========================================================================
//
// PC_InitArray
//
//==========================================================================

void PC_InitArray(int index, int *entries, boolean hasStrings) {
    int i;

    // If the array is just initialized to zeros, then we don't need to
    // remember the initializer.
    for (i = 0; i < ArraySizes[index]; ++i) {
        if (entries[i] != 0) {
            break;
        }
    }
    if (i < ArraySizes[index]) {
        ArrayInits[index] =
            (int *)MS_Alloc(ArraySizes[index] * sizeof(int), ERR_OUT_OF_MEMORY);
        memcpy(ArrayInits[index], entries, ArraySizes[index] * sizeof(int));
    }
    ArrayOfStrings[index] = hasStrings;
}

//==========================================================================
//
// PC_AddImport
//
//==========================================================================

int PC_AddImport(char *name) {
    if (NumImports >= MAX_IMPORTS) {
        ERR_Exit(ERR_TOO_MANY_IMPORTS, YES);
    } else if (pc_EnforceHexen) {
        ERR_Error(ERR_HEXEN_COMPAT, YES);
    }
    strncpy(Imports[NumImports], name, 8);
    return NumImports++;
}
