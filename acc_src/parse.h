
//**************************************************************************
//**
//** parse.h
//**
//**************************************************************************

#ifndef __PARSE_H__
#define __PARSE_H__

// HEADER FILES ------------------------------------------------------------

// MACROS ------------------------------------------------------------------

// TYPES -------------------------------------------------------------------

struct ScriptTypes
{
	const char *TypeName;
	int TypeBase;
	int TypeCount;
};

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

void PA_Parse(void);

// PUBLIC DATA DECLARATIONS ------------------------------------------------

extern int pa_ScriptCount;
extern struct ScriptTypes *pa_TypedScriptCounts;
extern int pa_MapVarCount;
extern int pa_WorldVarCount;
extern int pa_GlobalVarCount;
extern int pa_WorldArrayCount;
extern int pa_GlobalArrayCount;
extern enum ImportModes ImportMode;
extern boolean ExporterFlagged;
extern boolean pa_ConstExprIsString;

#endif
