
//**************************************************************************
//**
//** strlist.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#include "strlist.h"

#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "error.h"
#include "misc.h"
#include "pcode.h"

// MACROS ------------------------------------------------------------------

// TYPES -------------------------------------------------------------------

typedef struct {
    char *name;
    int address;
} stringInfo_t;

typedef struct {
    int stringCount;
    stringInfo_t strings[MAX_STRINGS];
} stringList_t;

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static int STR_PutStringInSomeList(stringList_t *list, int index, char *name);
static int STR_FindInSomeList(stringList_t *list, char *name);
static int STR_FindInSomeListInsensitive(stringList_t *list, char *name);
static void DumpStrings(stringList_t *list, int lenadr, boolean quad,
                        boolean crypt);
static void Encrypt(void *data, int key, int len);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

int NumLanguages, NumStringLists;

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static stringList_t MainStringList;
static stringList_t *StringLists[NUM_STRLISTS];

// CODE --------------------------------------------------------------------

//==========================================================================
//
// STR_Init
//
//==========================================================================

void STR_Init(void) {
    NumStringLists = 0;
    MainStringList.stringCount = 0;
}

//==========================================================================
//
// STR_Get
//
//==========================================================================

char *STR_Get(int num) { return MainStringList.strings[num].name; }

//==========================================================================
//
// STR_Find
//
//==========================================================================

int STR_Find(char *name) { return STR_FindInSomeList(&MainStringList, name); }

//==========================================================================
//
// STR_FindInList
//
//==========================================================================

int STR_FindInList(int list, char *name) {
    if (StringLists[list] == NULL) {
        StringLists[list] =
            (stringList_t *)MS_Alloc(sizeof(stringList_t), ERR_OUT_OF_MEMORY);
        StringLists[list]->stringCount = 0;
        NumStringLists++;
        if (pc_EnforceHexen) {
            ERR_Error(ERR_HEXEN_COMPAT, YES);
        }
    }
    return STR_FindInSomeList(StringLists[list], name);
}

//==========================================================================
//
// STR_FindInSomeList
//
//==========================================================================

static int STR_FindInSomeList(stringList_t *list, char *name) {
    int i;

    for (i = 0; i < list->stringCount; i++) {
        if (strcmp(list->strings[i].name, name) == 0) {
            return i;
        }
    }
    // Add to list
    return STR_PutStringInSomeList(list, i, name);
}

//==========================================================================
//
// STR_FindInListInsensitive
//
//==========================================================================

int STR_FindInListInsensitive(int list, char *name) {
    if (StringLists[list] == NULL) {
        StringLists[list] =
            (stringList_t *)MS_Alloc(sizeof(stringList_t), ERR_OUT_OF_MEMORY);
        StringLists[list]->stringCount = 0;
        NumStringLists++;
        if (pc_EnforceHexen) {
            ERR_Error(ERR_HEXEN_COMPAT, YES);
        }
    }
    return STR_FindInSomeListInsensitive(StringLists[list], name);
}

//==========================================================================
//
// STR_FindInSomeListInsensitive
//
//==========================================================================

static int STR_FindInSomeListInsensitive(stringList_t *list, char *name) {
    int i;

    for (i = 0; i < list->stringCount; i++) {
        if (strcasecmp(list->strings[i].name, name) == 0) {
            return i;
        }
    }
    // Add to list
    return STR_PutStringInSomeList(list, i, name);
}

//==========================================================================
//
// STR_GetString
//
//==========================================================================

const char *STR_GetString(int list, int index) {
    if (StringLists[list] == NULL) {
        return NULL;
    }
    if (index < 0 || index >= StringLists[list]->stringCount) {
        return NULL;
    }
    return StringLists[list]->strings[index].name;
}

//==========================================================================
//
// STR_AppendToList
//
//==========================================================================

int STR_AppendToList(int list, char *name) {
    if (StringLists[list] == NULL) {
        StringLists[list] =
            (stringList_t *)MS_Alloc(sizeof(stringList_t), ERR_OUT_OF_MEMORY);
        StringLists[list]->stringCount = 0;
        NumStringLists++;
    }
    return STR_PutStringInSomeList(StringLists[list],
                                   StringLists[list]->stringCount, name);
}

//==========================================================================
//
// STR_PutStringInSomeList
//
//==========================================================================

static int STR_PutStringInSomeList(stringList_t *list, int index, char *name) {
    int i;

    if (index >= MAX_STRINGS) {
        ERR_Error(ERR_TOO_MANY_STRINGS, YES, MAX_STRINGS);
        return 0;
    }
    MS_Message(MSG_DEBUG, "Adding string %d:\n  \"%s\"\n", list->stringCount,
               name);
    if (index >= list->stringCount) {
        for (i = list->stringCount; i <= index; i++) {
            list->strings[i].name = NULL;
        }
        list->stringCount = index + 1;
    }
    if (list->strings[index].name != NULL) {
        free(list->strings[index].name);
    }
    if (name != NULL) {
        list->strings[index].name =
            (char *)MS_Alloc(strlen(name) + 1, ERR_OUT_OF_MEMORY);
        strcpy(list->strings[index].name, name);
    } else {
        list->strings[index].name = NULL;
    }
    return index;
}

//==========================================================================
//
// STR_ListSize
//
//==========================================================================

int STR_ListSize() { return MainStringList.stringCount; }

//==========================================================================
//
// STR_WriteStrings
//
// Writes all the strings to the p-code buffer.
//
//==========================================================================

void STR_WriteStrings(void) {
    int i;
    U_INT pad;

    MS_Message(MSG_DEBUG, "---- STR_WriteStrings ----\n");
    for (i = 0; i < MainStringList.stringCount; i++) {
        MainStringList.strings[i].address = pc_Address;
        PC_AppendString(MainStringList.strings[i].name);
    }
    if (pc_Address % 4 != 0) {  // Need to align
        pad = 0;
        PC_Append((void *)&pad, 4 - (pc_Address % 4));
    }
}

//==========================================================================
//
// STR_WriteList
//
//==========================================================================

void STR_WriteList(void) {
    int i;

    MS_Message(MSG_DEBUG, "---- STR_WriteList ----\n");
    PC_AppendInt((U_INT)MainStringList.stringCount);
    for (i = 0; i < MainStringList.stringCount; i++) {
        PC_AppendInt((U_INT)MainStringList.strings[i].address);
    }
}

//==========================================================================
//
// STR_WriteChunk
//
//==========================================================================

void STR_WriteChunk(boolean encrypt) {
    int lenadr;

    MS_Message(MSG_DEBUG, "---- STR_WriteChunk ----\n");
    PC_Append((void *)(encrypt ? "STRE" : "STRL"), 4);
    lenadr = pc_Address;
    PC_SkipInt();
    PC_AppendInt(0);
    PC_AppendInt(MainStringList.stringCount);
    PC_AppendInt(0);  // Used in-game for stringing lists together (NOT!)

    DumpStrings(&MainStringList, lenadr, NO, encrypt);
}

//==========================================================================
//
// STR_WriteListChunk
//
//==========================================================================

void STR_WriteListChunk(int list, int id, boolean quad) {
    int lenadr;

    if (StringLists[list] != NULL && StringLists[list]->stringCount > 0) {
        MS_Message(MSG_DEBUG, "---- STR_WriteListChunk %d %c%c%c%c----\n", list,
                   id & 255, (id >> 8) & 255, (id >> 16) & 255,
                   (id >> 24) & 255);
        PC_AppendInt((U_INT)id);
        lenadr = pc_Address;
        PC_SkipInt();
        PC_AppendInt(StringLists[list]->stringCount);
        if (quad &&
            pc_Address % 8 != 0) {  // If writing quadword indices, align the
                                    // indices to an 8-byte boundary.
            U_INT pad = 0;
            PC_Append(&pad, 4);
        }
        DumpStrings(StringLists[list], lenadr, quad, NO);
    }
}

//==========================================================================
//
// DumpStrings
//
//==========================================================================

static void DumpStrings(stringList_t *list, int lenadr, boolean quad,
                        boolean crypt) {
    int i, ofs, startofs;

    startofs = ofs =
        pc_Address - lenadr - 4 + list->stringCount * (quad ? 8 : 4);

    for (i = 0; i < list->stringCount; i++) {
        if (list->strings[i].name != NULL) {
            PC_AppendInt((U_INT)ofs);
            ofs += strlen(list->strings[i].name) + 1;
        } else {
            PC_AppendInt(0);
        }
        if (quad) {
            PC_AppendInt(0);
        }
    }

    ofs = startofs;

    for (i = 0; i < list->stringCount; i++) {
        if (list->strings[i].name != NULL) {
            int stringlen = strlen(list->strings[i].name) + 1;
            if (crypt) {
                int cryptkey = ofs * 157135;

                Encrypt(list->strings[i].name, cryptkey, stringlen);
                PC_Append(list->strings[i].name, stringlen);
                ofs += stringlen;
                Encrypt(list->strings[i].name, cryptkey, stringlen);
            } else {
                PC_AppendString(list->strings[i].name);
            }
        }
    }
    if (pc_Address % 4 != 0) {  // Need to align
        U_INT pad = 0;
        PC_Append((void *)&pad, 4 - (pc_Address % 4));
    }

    PC_WriteInt(pc_Address - lenadr - 4, lenadr);
}

static void Encrypt(void *data, int key, int len) {
    int p = (byte)key, i;

    for (i = 0; i < len; ++i) {
        ((byte *)data)[i] ^= (byte)(p + (i >> 1));
    }
}
