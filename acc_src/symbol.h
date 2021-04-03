
//**************************************************************************
//**
//** symbol.h
//**
//**************************************************************************

#ifndef __SYMBOL_H__
#define __SYMBOL_H__

// HEADER FILES ------------------------------------------------------------

#include "common.h"
#include "pcode.h"

// MACROS ------------------------------------------------------------------

#define MAX_ARRAY_DIMS 8

// TYPES -------------------------------------------------------------------

typedef enum
{
	SY_DUMMY,
	SY_LABEL,
	SY_SCRIPTVAR,
	SY_SCRIPTALIAS,
	SY_MAPVAR,
	SY_WORLDVAR,
	SY_GLOBALVAR,
	SY_SCRIPTARRAY,
	SY_MAPARRAY,
	SY_WORLDARRAY,
	SY_GLOBALARRAY,
	SY_SPECIAL,
	SY_CONSTANT,
	SY_INTERNFUNC,
	SY_SCRIPTFUNC
} symbolType_t;

typedef struct
{
	U_BYTE index;
} symVar_t;

typedef struct
{
	U_BYTE index;
	int dimensions[MAX_ARRAY_DIMS];
	int ndim;
	int size;
} symArray_t;

typedef struct
{
	int address;
} symLabel_t;

typedef struct
{
	int value;
	int argCount;
} symSpecial_t;

typedef struct
{
	int value;
	char *strValue;
	int fileDepth;
} symConstant_t;

typedef struct
{
	pcd_t directCommand;
	pcd_t stackCommand;
	int argCount;
	int optMask;
	int outMask;
	boolean hasReturnValue;
	boolean latent;
} symInternFunc_t;

typedef struct
{
	int address;
	int argCount;
	int varCount;
	int funcNumber;
	boolean hasReturnValue;
	int sourceLine;
	char *sourceName;
	boolean predefined;
} symScriptFunc_t;

typedef struct symbolNode_s
{
	struct symbolNode_s *left;
	struct symbolNode_s *right;
	char *name;
	symbolType_t type;
	boolean unused;
	boolean imported;
	union
	{
		symVar_t var;
		symArray_t array;
		symLabel_t label;
		symSpecial_t special;
		symConstant_t constant;
		symInternFunc_t internFunc;
		symScriptFunc_t scriptFunc;
	} info;
} symbolNode_t;

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

void SY_Init(void);
symbolNode_t *SY_Find(char *name);
symbolNode_t *SY_FindLocal(char *name);
symbolNode_t *SY_FindGlobal(char *name);
symbolNode_t *SY_InsertLocal(char *name, symbolType_t type);
symbolNode_t *SY_InsertGlobal(char *name, symbolType_t type);
symbolNode_t *SY_InsertGlobalUnique(char *name, symbolType_t type);
void SY_FreeLocals(void);
void SY_FreeGlobals(void);
void SY_FreeConstants(int depth);
void SY_ClearShared(void);

// PUBLIC DATA DECLARATIONS ------------------------------------------------

#endif
