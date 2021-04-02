
//**************************************************************************
//**
//** error.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "common.h"
#include "error.h"
#include "token.h"
#include "misc.h"

// MACROS ------------------------------------------------------------------

#define ERROR_FILE_NAME "acs.err"

// TYPES -------------------------------------------------------------------

typedef enum
{
	ERRINFO_GCC,
	ERRINFO_VCC
} errorInfo_e;

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static char *ErrorText(error_t error);
static char *ErrorFileName(void);
static void eprintf(const char *fmt, ...);
static void veprintf(const char *fmt, va_list args);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

extern char acs_SourceFileName[MAX_FILE_NAME_LENGTH];

// PUBLIC DATA DEFINITIONS -------------------------------------------------

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static struct
{
	error_t number;
	char *name;
} ErrorNames[] =
{
	{ ERR_MISSING_SEMICOLON, "Missing semicolon." },
	{ ERR_MISSING_LPAREN, "Missing '('." },
	{ ERR_MISSING_RPAREN, "Missing ')'." },
	{ ERR_MISSING_LBRACE, "Missing '{'." },
	{ ERR_MISSING_SCRIPT_NUMBER, "Missing script number." },
	{ ERR_IDENTIFIER_TOO_LONG, "Identifier too long." },
	{ ERR_STRING_TOO_LONG, "String too long." },
	{ ERR_FILE_NAME_TOO_LONG, "File name too long.\nFile: \"%s\"" },
	{ ERR_BAD_CHARACTER, "Bad character in script text." },
	{ ERR_BAD_CHARACTER_CONSTANT, "Bad character constant in script text." },
	{ ERR_ALLOC_PCODE_BUFFER, "Failed to allocate PCODE buffer." },
	{ ERR_PCODE_BUFFER_OVERFLOW, "PCODE buffer overflow." },
	{ ERR_TOO_MANY_SCRIPTS, "Too many scripts." },
	{ ERR_TOO_MANY_FUNCTIONS, "Too many functions." },
	{ ERR_SAVE_OBJECT_FAILED, "Couldn't save object file." },
	{ ERR_MISSING_LPAREN_SCR, "Missing '(' in script definition." },
	{ ERR_INVALID_IDENTIFIER, "Invalid identifier." },
	{ ERR_REDEFINED_IDENTIFIER, "%s : Redefined identifier." },
	{ ERR_MISSING_COMMA, "Missing comma." },
	{ ERR_BAD_VAR_TYPE, "Invalid variable type." },
	{ ERR_BAD_RETURN_TYPE, "Invalid return type." },
	{ ERR_TOO_MANY_SCRIPT_ARGS, "Too many script arguments." },
	{ ERR_MISSING_LBRACE_SCR, "Missing opening '{' in script definition." },
	{ ERR_MISSING_RBRACE_SCR, "Missing closing '}' in script definition." },
	{ ERR_TOO_MANY_MAP_VARS, "Too many map variables." },
	{ ERR_TOO_MANY_SCRIPT_VARS, "Too many script variables." },
	{ ERR_TOO_MANY_FUNCTION_VARS, "Too many function variables." },
	{ ERR_TOO_MANY_SCRIPT_ARRAYS, "Too many script arrays." },
	{ ERR_TOO_MANY_FUNCTION_ARRAYS, "Too many function arrays." },
	{ ERR_MISSING_WVAR_INDEX, "Missing index in world variable declaration." },
	{ ERR_MISSING_GVAR_INDEX, "Missing index in global variable declaration." },
	{ ERR_BAD_WVAR_INDEX, "World variable index out of range." },
	{ ERR_MISSING_WVAR_COLON, "Missing colon in world variable declaration." },
	{ ERR_MISSING_GVAR_COLON, "Missing colon in global variable declaration." },
	{ ERR_MISSING_SPEC_VAL, "Missing value in special declaration." },
	{ ERR_MISSING_SPEC_COLON, "Missing colon in special declaration." },
	{ ERR_MISSING_SPEC_ARGC, "Missing argument count in special declaration." },
	{ ERR_CANT_READ_FILE, "Couldn't read file.\nFile: \"%s\"" },
	{ ERR_CANT_OPEN_FILE, "Couldn't open file.\nFile: \"%s\"" },
	{ ERR_CANT_OPEN_DBGFILE, "Couldn't open debug file." },
	{ ERR_INVALID_DIRECTIVE, "Invalid directive." },
	{ ERR_BAD_DEFINE, "Non-numeric constant found in #define." },
	{ ERR_INCL_NESTING_TOO_DEEP, "Include nesting too deep.\nUnable to include file \"%s\"." },
	{ ERR_STRING_LIT_NOT_FOUND, "String literal not found." },
	{ ERR_INVALID_DECLARATOR, "Invalid declarator." },
	{ ERR_BAD_LSPEC_ARG_COUNT, "Incorrect number of special arguments." },
	{ ERR_BAD_ARG_COUNT, "Incorrect number of arguments." },
	{ ERR_UNKNOWN_IDENTIFIER, "%s : Identifier has not been declared." },
	{ ERR_MISSING_COLON, "Missing colon." },
	{ ERR_BAD_EXPR, "Syntax error in expression." },
	{ ERR_BAD_CONST_EXPR, "Syntax error in constant expression." },
	{ ERR_DIV_BY_ZERO_IN_CONST_EXPR, "Division by zero in constant expression." },
	{ ERR_NO_DIRECT_VER, "Internal function has no direct version." },
	{ ERR_ILLEGAL_EXPR_IDENT, "%s : Illegal identifier in expression." },
	{ ERR_EXPR_FUNC_NO_RET_VAL, "Function call in expression has no return value." },
	{ ERR_MISSING_ASSIGN_OP, "Missing assignment operator." },
	{ ERR_INCDEC_OP_ON_NON_VAR, "'++' or '--' used on a non-variable." },
	{ ERR_MISSING_RBRACE, "Missing '}' at end of compound statement." },
	{ ERR_INVALID_STATEMENT, "Invalid statement." },
	{ ERR_BAD_DO_STATEMENT, "Do statement not followed by 'while' or 'until'." },
	{ ERR_BAD_SCRIPT_DECL, "Bad script declaration." },
	{ ERR_CASE_OVERFLOW, "Internal Error: Case stack overflow." },
	{ ERR_BREAK_OVERFLOW, "Internal Error: Break stack overflow." },
	{ ERR_CONTINUE_OVERFLOW, "Internal Error: Continue stack overflow." },
	{ ERR_STATEMENT_OVERFLOW, "Internal Error: Statement overflow." },
	{ ERR_MISPLACED_BREAK, "Misplaced BREAK statement." },
	{ ERR_MISPLACED_CONTINUE, "Misplaced CONTINUE statement." },
	{ ERR_CASE_NOT_IN_SWITCH, "CASE must appear in switch statement." },
	{ ERR_DEFAULT_NOT_IN_SWITCH, "DEFAULT must appear in switch statement." },
	{ ERR_MULTIPLE_DEFAULT, "Only 1 DEFAULT per switch allowed." },
	{ ERR_EXPR_STACK_OVERFLOW, "Expression stack overflow." },
	{ ERR_EXPR_STACK_EMPTY, "Tried to POP empty expression stack." },
	{ ERR_UNKNOWN_CONST_EXPR_PCD, "Unknown PCD in constant expression." },
	{ ERR_BAD_RADIX_CONSTANT, "Radix out of range in integer constant." },
	{ ERR_BAD_ASSIGNMENT, "Syntax error in multiple assignment statement." },
	{ ERR_OUT_OF_MEMORY, "Out of memory." },
	{ ERR_TOO_MANY_STRINGS, "Too many strings. Current max is %d" },
	{ ERR_UNKNOWN_PRTYPE, "Unknown cast type in print statement." },
	{ ERR_SCRIPT_OUT_OF_RANGE, "Script number must be between 1 and 32767." },
	{ ERR_MISSING_PARAM, "Missing required argument." },
	{ ERR_SCRIPT_ALREADY_DEFINED, "Script already has a body." },
	{ ERR_FUNCTION_ALREADY_DEFINED, "Function already has a body." },
	{ ERR_PARM_MUST_BE_VAR, "Parameter must be a variable." },
	{ ERR_MISSING_FONT_NAME, "Missing font name." },
	{ ERR_MISSING_LBRACE_FONTS, "Missing opening '{' in font list." },
	{ ERR_MISSING_RBRACE_FONTS, "Missing closing '}' in font list." },
	{ ERR_NOCOMPACT_NOT_HERE, "#nocompact must appear before any scripts." },
	{ ERR_MISSING_ASSIGN, "Missing '='." },
	{ ERR_PREVIOUS_NOT_VOID, "Previous use of function expected a return value." },
	{ ERR_MUST_RETURN_A_VALUE, "Function must return a value." },
	{ ERR_MUST_NOT_RETURN_A_VALUE, "Void functions cannot return a value." },
	{ ERR_SUSPEND_IN_FUNCTION, "Suspend cannot be used inside a function." },
	{ ERR_TERMINATE_IN_FUNCTION, "Terminate cannot be used inside a function." },
	{ ERR_RESTART_IN_FUNCTION, "Restart cannot be used inside a function." },
	{ ERR_RETURN_OUTSIDE_FUNCTION, "Return can only be used inside a function." },
	{ ERR_FUNC_ARGUMENT_COUNT, "Function %s should have %d argument%s." },
	{ ERR_EOF, "Unexpected end of file." },
	{ ERR_UNDEFINED_FUNC, "Function %s is used but not defined." },
	{ ERR_TOO_MANY_ARRAY_DIMS, "Too many array dimensions." },
	{ ERR_TOO_MANY_ARRAY_INIT, "Too many initializers for array." },
	{ ERR_MISSING_LBRACKET, "Missing '['." },
	{ ERR_MISSING_RBRACKET, "Missing ']'." },
	{ ERR_ZERO_DIMENSION, "Arrays cannot have a dimension of zero." },
	{ ERR_TOO_MANY_DIM_USED, "%s only has %d dimensions." },
	{ ERR_TOO_FEW_DIM_USED, "%s access needs %d more dimensions." },
	{ ERR_ARRAY_MAPVAR_ONLY, "Only map variables can be arrays." },
	{ ERR_NOT_AN_ARRAY, "%s is not an array." },
	{ ERR_MISSING_LBRACE_ARR, "Missing opening '{' in array initializer." },
	{ ERR_MISSING_RBRACE_ARR, "Missing closing '}' in array initializer." },
	{ ERR_LATENT_IN_FUNC, "Latent functions cannot be used inside functions." },
	{ ERR_LOCAL_VAR_SHADOWED, "A global identifier already has this name." },
	{ ERR_MULTIPLE_IMPORTS, "You can only #import one file." },
	{ ERR_IMPORT_IN_EXPORT, "You cannot #import from inside an imported file." },
	{ ERR_EXPORTER_NOT_FLAGGED, "A file that you #import must have a #library line." },
	{ ERR_TOO_MANY_IMPORTS, "Too many files imported." },
	{ ERR_NO_NEED_ARRAY_SIZE, "Only map arrays need a size." },
	{ ERR_NO_MULTIDIMENSIONS, "Only map arrays can have more than one dimension." },
	{ ERR_NEED_ARRAY_SIZE, "Missing array size." },
	{ ERR_DISCONNECT_NEEDS_1_ARG, "Disconnect scripts must have 1 argument." },
	{ ERR_UNCLOSED_WITH_ARGS, "Most special scripts must not have arguments." },
	{ ERR_NOT_A_CHAR_ARRAY, "%s has %d dimensions. Use %d subscripts to get a char array." },
	{ ERR_CANT_FIND_INCLUDE, "Couldn't find include file \"%s\"." },
	{ ERR_SCRIPT_NAMED_NONE, "Scripts may not be named \"None\"." },
	{ ERR_HEXEN_COMPAT, "Attempt to use feature not supported by Hexen." },
	{ ERR_NOT_HEXEN, "Cannot save; new features are not compatible with Hexen." },
	{ ERR_SPECIAL_RANGE, "Line specials with values higher than 255 require #nocompact." },
	{ ERR_EVENT_NEEDS_3_ARG, "Event scripts must have 3 arguments." }, // [BB]
	{ ERR_LIBRARY_NOT_FIRST, "#library must come before anything else." },
	{ ERR_NONE, NULL }
};

static FILE *ErrorFile;
static int ErrorCount;
static errorInfo_e ErrorFormat;
static char *ErrorSourceName;
static int ErrorSourceLine;

// CODE --------------------------------------------------------------------

//==========================================================================
//
// ERR_ErrorAt
//
//==========================================================================

void ERR_ErrorAt(char *source, int line)
{
	ErrorSourceName = source;
	ErrorSourceLine = line;
}

//==========================================================================
//
// ERR_Error
//
//==========================================================================

void ERR_Error(error_t error, boolean info, ...)
{
	va_list args;
	va_start(args, info);
	ERR_ErrorV(error, info, args);
	va_end(args);
}

//==========================================================================
//
// ERR_Exit
//
//==========================================================================

void ERR_Exit(error_t error, boolean info, ...)
{
	va_list args;
	va_start(args, info);
	ERR_ErrorV(error, info, args);
	va_end(args);
	ERR_Finish();
}

//==========================================================================
//
// ERR_Finish
//
//==========================================================================

void ERR_Finish(void)
{
	if(ErrorFile)
	{
		fclose(ErrorFile);
		ErrorFile = NULL;
	}
	if(ErrorCount)
	{
		exit(1);
	}
}

//==========================================================================
//
// ShowError
//
//==========================================================================

void ERR_ErrorV(error_t error, boolean info, va_list args)
{
	char *text;
	boolean showLine = NO;
	static boolean showedInfo = NO;

	if(!ErrorFile)
	{
		ErrorFile = fopen(ErrorFileName(), "w");
	}
	if(ErrorCount == 0)
	{
		fprintf(stderr, "\n**** ERROR ****\n");
	}
	else if(ErrorCount == 100)
	{
		eprintf("More than 100 errors. Can't continue.\n");
		ERR_Finish();
	}
	ErrorCount++;
	if(info == YES)
	{
		char *source;
		int line;

		if(ErrorSourceName)
		{
			source = ErrorSourceName;
			line = ErrorSourceLine;
			ErrorSourceName = NULL;
		}
		else
		{
			source = tk_SourceName;
			line = tk_Line;
			showLine = YES;
		}
		if(showedInfo == NO)
                { // Output info compatible with older ACCs
                  // for editors that expect it.
			showedInfo = YES;
                        eprintf("Line %d in file \"%s\" ...\n", line, source);
		}
		if(ErrorFormat == ERRINFO_GCC)
		{
			eprintf("%s:%d: ", source, line);
		}
		else
		{
			eprintf("%s(%d) : ", source, line);
			if(error != ERR_NONE)
			{
				eprintf("error %04d: ", error);
			}
		}
	}
	if(error != ERR_NONE)
	{
		text = ErrorText(error);
		if(text != NULL)
		{
			veprintf(text, args);
		}
		eprintf("\n");
		if(showLine)
		{
			// deal with master source line and position indicator - Ty 07jan2000
			MasterSourceLine[MasterSourcePos] = '\0';  // pre-incremented already
			eprintf("> %s\n", MasterSourceLine);  // the string 
			eprintf(">%*s\n", MasterSourcePos, "^");  // pointer to error
		}
	}
#if 0
	else
	{
		va_list args2;
		va_start(va_arg(args,char*), args2);
		veprintf(va_arg(args,char*), args2);
		va_end(args2);
	}
#endif
}

//==========================================================================
//
// ERR_RemoveErrorFile
//
//==========================================================================

void ERR_RemoveErrorFile(void)
{
	remove(ErrorFileName());
}

//==========================================================================
//
// ERR_ErrorFileName
//
//==========================================================================

static char *ErrorFileName(void)
{
	static char errFileName[MAX_FILE_NAME_LENGTH];

	strcpy(errFileName, acs_SourceFileName);
	if(MS_StripFilename(errFileName) == NO)
	{
		strcpy(errFileName, ERROR_FILE_NAME);
	}
	else
	{
		strcat(errFileName, ERROR_FILE_NAME);
	}
	return errFileName;
}

//==========================================================================
//
// ErrorText
//
//==========================================================================

static char *ErrorText(error_t error)
{
	int i;

	for(i = 0; ErrorNames[i].number != ERR_NONE; i++)
	{
		if(error == ErrorNames[i].number)
		{
			return ErrorNames[i].name;
		}
	}
	return NULL;
}

//==========================================================================
//
// eprintf
//
//==========================================================================

static void eprintf(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	veprintf(fmt, args);
	va_end(args);
}

//==========================================================================
//
// veprintf
//
//==========================================================================

static void veprintf(const char *fmt, va_list args)
{
#ifdef va_copy
	va_list copy;
	va_copy(copy, args);
#endif
	vfprintf(stderr, fmt, args);
	if(ErrorFile)
	{
#ifdef va_copy
		vfprintf(ErrorFile, fmt, copy);
#else
		vfprintf(ErrorFile, fmt, args);
#endif
	}
#ifdef va_copy
	va_end(copy);
#endif
}
