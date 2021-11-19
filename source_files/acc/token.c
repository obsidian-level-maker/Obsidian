
//**************************************************************************
//**
//** token.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#if defined(_WIN32) && !defined(_MSC_VER)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

#ifdef __NeXT__
#include <libc.h>
#else
#if !defined(unix) && !defined(__APPLE__)
#include <io.h>
#endif
#include <fcntl.h>
#include <limits.h>
#include <stdlib.h>
#endif
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "common.h"
#include "error.h"
#include "misc.h"
#include "parse.h"
#include "symbol.h"
#include "token.h"

// MACROS ------------------------------------------------------------------

#define NON_HEX_DIGIT 255
#define MAX_NESTED_SOURCES 16

// TYPES -------------------------------------------------------------------

typedef enum { CHR_EOF, CHR_LETTER, CHR_NUMBER, CHR_QUOTE, CHR_SPECIAL } chr_t;

typedef struct {
    char *name;
    char *start;
    char *end;
    char *position;
    int line;
    boolean incLineNumber;
    boolean imported;
    enum ImportModes prevMode;
    char lastChar;
} nestInfo_t;

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static int SortKeywords(const void *a, const void *b);
static void SetLocalIncludePath(char *sourceName);
static int PopNestedSource(enum ImportModes *prevMode);
static void ProcessLetterToken(void);
static void ProcessNumberToken(void);
static void EvalFixedConstant(int whole);
static void EvalHexConstant(void);
static void EvalRadixConstant(void);
static int DigitValue(char digit, int radix);
static void ProcessQuoteToken(void);
static void ProcessSpecialToken(void);
static boolean CheckForKeyword(void);
static boolean CheckForLineSpecial(void);
static boolean CheckForConstant(void);
static void NextChr(void);
static void SkipComment(void);
static void SkipCPPComment(void);
static void BumpMasterSourceLine(char Chr,
                                 boolean clear);  // master line - Ty 07jan2000
static char *AddFileName(const char *name);
static int OctalChar();

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

tokenType_t tk_Token;
int tk_Line;
int tk_Number;
char *tk_String;
int tk_SpecialValue;
int tk_SpecialArgCount;
char *tk_SourceName;
int tk_IncludedLines;
boolean forSemicolonHack;
char MasterSourceLine[MAX_STATEMENT_LENGTH + 1];  // master line - Ty 07jan2000
int MasterSourcePos;            // master position - Ty 07jan2000
int PrevMasterSourcePos;        // previous master position - RH 09feb2000
boolean ClearMasterSourceLine;  // master clear flag - Ty 07jan2000

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static char Chr;
static char *FileStart;
static char *FilePtr;
static char *FileEnd;
static boolean SourceOpen;
static char ASCIIToChrCode[256];
static byte ASCIIToHexDigit[256];
static char TokenStringBuffer[MAX_QUOTED_LENGTH];
static nestInfo_t OpenFiles[MAX_NESTED_SOURCES];
static boolean AlreadyGot;
static int NestDepth;
static boolean IncLineNumber;
static char *FileNames;
static size_t FileNamesLen, FileNamesMax;

// Pascal 12/11/08
// Include paths. Lowest is searched first.
// Include path 0 is always set to the directory of the file being parsed.
static char IncludePaths[MAX_INCLUDE_PATHS][MAX_FILE_NAME_LENGTH];
static int NumIncludePaths;

static struct keyword_s {
    char *name;
    tokenType_t token;
} Keywords[] = {
    {"break", TK_BREAK},
    {"case", TK_CASE},
    {"const", TK_CONST},
    {"continue", TK_CONTINUE},
    {"default", TK_DEFAULT},
    {"define", TK_DEFINE},
    {"do", TK_DO},
    {"else", TK_ELSE},
    {"for", TK_FOR},
    {"goto", TK_GOTO},
    {"if", TK_IF},
    {"include", TK_INCLUDE},
    {"int", TK_INT},
    {"open", TK_OPEN},
    {"print", TK_PRINT},
    {"printbold", TK_PRINTBOLD},
    {"log", TK_LOG},
    {"hudmessage", TK_HUDMESSAGE},
    {"hudmessagebold", TK_HUDMESSAGEBOLD},
    {"restart", TK_RESTART},
    {"script", TK_SCRIPT},
    {"special", TK_SPECIAL},
    {"str", TK_STR},
    {"suspend", TK_SUSPEND},
    {"switch", TK_SWITCH},
    {"terminate", TK_TERMINATE},
    {"until", TK_UNTIL},
    {"void", TK_VOID},
    {"while", TK_WHILE},
    {"world", TK_WORLD},
    {"global", TK_GLOBAL},
    // [BC] Start Skulltag tokens.
    {"respawn", TK_RESPAWN},
    {"death", TK_DEATH},
    {"enter", TK_ENTER},
    {"pickup", TK_PICKUP},
    {"bluereturn", TK_BLUERETURN},
    {"redreturn", TK_REDRETURN},
    {"whitereturn", TK_WHITERETURN},
    // [BC] End Skulltag tokens.
    {"nocompact", TK_NOCOMPACT},
    {"lightning", TK_LIGHTNING},
    {"createtranslation", TK_CREATETRANSLATION},
    {"function", TK_FUNCTION},
    {"return", TK_RETURN},
    {"wadauthor", TK_WADAUTHOR},
    {"nowadauthor", TK_NOWADAUTHOR},
    {"acs_executewait", TK_ACSEXECUTEWAIT},
    {"acs_namedexecutewait", TK_ACSNAMEDEXECUTEWAIT},
    {"encryptstrings", TK_ENCRYPTSTRINGS},
    {"import", TK_IMPORT},
    {"library", TK_LIBRARY},
    {"libdefine", TK_LIBDEFINE},
    {"bool", TK_BOOL},
    {"net", TK_NET},
    {"clientside", TK_CLIENTSIDE},  // [BB]
    {"disconnect", TK_DISCONNECT},
    {"event", TK_EVENT},  //[BB]
    {"unloading", TK_UNLOADING},
    {"static", TK_STATIC},
    {"strparam", TK_STRPARAM_EVAL},  // [FDARI]
    {"strcpy", TK_STRCPY},           // [FDARI]
    {"region", TK_REGION},           // [mxd]
    {"endregion", TK_ENDREGION},     // [mxd]
    {"kill", TK_KILL},               // [JM]
    {"reopen", TK_REOPEN},           // [Nash]
    {"morphactor", TK_MORPHACTOR},   // [Dasperal]
};

#define NUM_KEYWORDS (sizeof(Keywords) / sizeof(Keywords[0]))

// CODE --------------------------------------------------------------------

//==========================================================================
//
// TK_Init
//
//==========================================================================

void TK_Init(void) {
    int i;

    for (i = 0; i < 256; i++) {
        ASCIIToChrCode[i] = CHR_SPECIAL;
        ASCIIToHexDigit[i] = NON_HEX_DIGIT;
    }
    for (i = '0'; i <= '9'; i++) {
        ASCIIToChrCode[i] = CHR_NUMBER;
        ASCIIToHexDigit[i] = i - '0';
    }
    for (i = 'A'; i <= 'F'; i++) {
        ASCIIToHexDigit[i] = 10 + (i - 'A');
    }
    for (i = 'a'; i <= 'f'; i++) {
        ASCIIToHexDigit[i] = 10 + (i - 'a');
    }
    for (i = 'A'; i <= 'Z'; i++) {
        ASCIIToChrCode[i] = CHR_LETTER;
    }
    for (i = 'a'; i <= 'z'; i++) {
        ASCIIToChrCode[i] = CHR_LETTER;
    }
    ASCIIToChrCode[ASCII_QUOTE] = CHR_QUOTE;
    ASCIIToChrCode[ASCII_UNDERSCORE] = CHR_LETTER;
    ASCIIToChrCode[EOF_CHARACTER] = CHR_EOF;
    tk_String = TokenStringBuffer;
    IncLineNumber = FALSE;
    tk_IncludedLines = 0;
    NumIncludePaths =
        1;  // the first path is always the parsed file path - Pascal 12/11/08
    SourceOpen = FALSE;
    *MasterSourceLine = '\0';      // master line - Ty 07jan2000
    MasterSourcePos = 0;           // master position - Ty 07jan2000
    ClearMasterSourceLine = TRUE;  // clear the line to start
    qsort(Keywords, NUM_KEYWORDS, sizeof(Keywords[0]), SortKeywords);
    FileNames = (char *)MS_Alloc(4096, ERR_OUT_OF_MEMORY);
    FileNamesLen = 0;
    FileNamesMax = 4096;
}

//==========================================================================
//
// SortKeywords
//
//==========================================================================

static int SortKeywords(const void *a, const void *b) {
    return strcmp(((struct keyword_s *)a)->name, ((struct keyword_s *)b)->name);
}

//==========================================================================
//
// TK_OpenSource
//
//==========================================================================

void TK_OpenSource(char *fileName) {
    int size;

    TK_CloseSource();
    size = MS_LoadFile(fileName, &FileStart);
    tk_SourceName = AddFileName(fileName);
    SetLocalIncludePath(fileName);
    SourceOpen = TRUE;
    FileEnd = FileStart + size;
    FilePtr = FileStart;
    tk_Line = 1;
    tk_Token = TK_NONE;
    AlreadyGot = FALSE;
    NestDepth = 0;
    NextChr();
}

//==========================================================================
//
// AddFileName
//
//==========================================================================

static char *AddFileName(const char *name) {
    size_t len = strlen(name) + 1;
    char *namespot;

    if (FileNamesLen + len > FileNamesMax) {
        FileNames = (char *)MS_Alloc(FileNamesMax, ERR_OUT_OF_MEMORY);
        FileNamesLen = 0;
    }
    namespot = FileNames + FileNamesLen;
    memcpy(namespot, name, len);
    FileNamesLen += len;
    return namespot;
}

//==========================================================================
//
// TK_AddIncludePath
// This adds an include path with less priority than the ones already added
//
// Pascal 12/11/08
//
//==========================================================================

void TK_AddIncludePath(char *sourcePath) {
    if (NumIncludePaths < MAX_INCLUDE_PATHS) {
        // Add to list
        strcpy(IncludePaths[NumIncludePaths], sourcePath);

        // Not ending with directory delimiter?
        if (!MS_IsDirectoryDelimiter(*(IncludePaths[NumIncludePaths] +
                                       strlen(IncludePaths[NumIncludePaths]) -
                                       1))) {
            // Add a directory delimiter to the include path
            strcat(IncludePaths[NumIncludePaths], "/");
        }
        MS_Message(MSG_DEBUG, "Add include path %d: \"%s\"\n", NumIncludePaths,
                   IncludePaths[NumIncludePaths]);
        NumIncludePaths++;
    }
}

//==========================================================================
//
// TK_AddProgramIncludePath
// Adds an include path for the directory of the executable.
//
//==========================================================================

void TK_AddProgramIncludePath(char *progname) {
    if (NumIncludePaths < MAX_INCLUDE_PATHS) {
#ifdef _WIN32
#ifdef _MSC_VER
#if _MSC_VER >= 1300
        if (_get_pgmptr(&progname) != 0) {
            return;
        }
#else
        progname = _pgmptr;
#endif
#else
        char progbuff[1024];
        GetModuleFileName(0, progbuff, sizeof(progbuff));
        progbuff[sizeof(progbuff) - 1] = '\0';
        progname = progbuff;
#endif
#else
        char progbuff[PATH_MAX];
        if (realpath(progname, progbuff) != NULL) {
            progname = progbuff;
        }
#endif
        strcpy(IncludePaths[NumIncludePaths], progname);
        if (MS_StripFilename(IncludePaths[NumIncludePaths])) {
            MS_Message(MSG_DEBUG, "Program include path is %d: \"%s\"\n",
                       NumIncludePaths, IncludePaths[NumIncludePaths]);
            NumIncludePaths++;
        }
    }
}

//==========================================================================
//
// SetLocalIncludePath
// This sets the first include path
//
// Pascal 12/11/08
//
//==========================================================================

static void SetLocalIncludePath(char *sourceName) {
    strcpy(IncludePaths[0], sourceName);
    if (MS_StripFilename(IncludePaths[0]) == NO) {
        IncludePaths[0][0] = 0;
    }
}

//==========================================================================
//
// TK_Include
//
//==========================================================================

void TK_Include(char *fileName) {
    char sourceName[MAX_FILE_NAME_LENGTH];
    int size, i;
    nestInfo_t *info;
    boolean foundfile = FALSE;

    MS_Message(MSG_DEBUG, "*Including %s\n", fileName);
    if (NestDepth == MAX_NESTED_SOURCES) {
        ERR_Exit(ERR_INCL_NESTING_TOO_DEEP, YES, fileName);
    }
    info = &OpenFiles[NestDepth++];
    info->name = tk_SourceName;
    info->start = FileStart;
    info->end = FileEnd;
    info->position = FilePtr;
    info->line = tk_Line;
    info->incLineNumber = IncLineNumber;
    info->lastChar = Chr;
    info->imported = NO;

    // Pascal 30/11/08
    // Handle absolute paths
    if (MS_IsPathAbsolute(fileName)) {
#if defined(_WIN32) || defined(__MSDOS__)
        sourceName[0] = '\0';
        if (MS_IsDirectoryDelimiter(fileName[0])) {
            // The source file is absolute for the drive, but does not
            // specify a drive. Use the path for the current file to
            // get the drive letter, if it has one.
            if (IncludePaths[0][0] != '\0' && IncludePaths[0][1] == ':') {
                sourceName[0] = IncludePaths[0][0];
                sourceName[1] = ':';
                sourceName[2] = '\0';
            }
        }
        strcat(sourceName, fileName);
#else
        strcpy(sourceName, fileName);
#endif
        foundfile = MS_FileExists(sourceName);
    } else {
        // Pascal 12/11/08
        // Find the file in the include paths
        for (i = 0; i < NumIncludePaths; i++) {
            strcpy(sourceName, IncludePaths[i]);
            strcat(sourceName, fileName);
            if (MS_FileExists(sourceName)) {
                foundfile = TRUE;
                break;
            }
        }
    }

    if (!foundfile) {
        ERR_ErrorAt(tk_SourceName, tk_Line);
        ERR_Exit(ERR_CANT_FIND_INCLUDE, YES, fileName, tk_SourceName, tk_Line);
    }

    MS_Message(MSG_DEBUG, "*Include file found at %s\n", sourceName);

    // Now change the first include path to the file directory
    SetLocalIncludePath(sourceName);

    tk_SourceName = AddFileName(sourceName);
    size = MS_LoadFile(tk_SourceName, &FileStart);
    FileEnd = FileStart + size;
    FilePtr = FileStart;
    tk_Line = 1;
    IncLineNumber = FALSE;
    tk_Token = TK_NONE;
    AlreadyGot = FALSE;
    BumpMasterSourceLine('x', TRUE);  // dummy x
    NextChr();
}

//==========================================================================
//
// TK_Import
//
//==========================================================================

void TK_Import(char *fileName, enum ImportModes prevMode) {
    TK_Include(fileName);
    OpenFiles[NestDepth - 1].imported = YES;
    OpenFiles[NestDepth - 1].prevMode = prevMode;
    ImportMode = IMPORT_Importing;
}

//==========================================================================
//
// PopNestedSource
//
//==========================================================================

static int PopNestedSource(enum ImportModes *prevMode) {
    nestInfo_t *info;

    MS_Message(MSG_DEBUG, "*Leaving %s\n", tk_SourceName);
    free(FileStart);
    SY_FreeConstants(NestDepth);
    tk_IncludedLines += tk_Line;
    info = &OpenFiles[--NestDepth];
    tk_SourceName = info->name;
    FileStart = info->start;
    FileEnd = info->end;
    FilePtr = info->position;
    tk_Line = info->line;
    IncLineNumber = info->incLineNumber;
    Chr = info->lastChar;
    tk_Token = TK_NONE;
    AlreadyGot = FALSE;

    // Pascal 12/11/08
    // Set the first include path back to this file directory
    SetLocalIncludePath(tk_SourceName);

    *prevMode = info->prevMode;
    return info->imported ? 2 : 0;
}

//==========================================================================
//
// TK_CloseSource
//
//==========================================================================

void TK_CloseSource(void) {
    int i;

    if (SourceOpen) {
        free(FileStart);
        for (i = 0; i < NestDepth; i++) {
            free(OpenFiles[i].start);
        }
        SourceOpen = FALSE;
    }
}

//==========================================================================
//
// TK_GetDepth
//
//==========================================================================

int TK_GetDepth(void) { return NestDepth; }

//==========================================================================
//
// TK_NextToken
//
//==========================================================================

tokenType_t TK_NextToken(void) {
    enum ImportModes prevMode;
    boolean validToken;

    if (AlreadyGot == TRUE) {
        int t = MasterSourcePos;
        MasterSourcePos = PrevMasterSourcePos;
        PrevMasterSourcePos = t;
        AlreadyGot = FALSE;
        return tk_Token;
    }
    tk_String = TokenStringBuffer;
    validToken = NO;
    PrevMasterSourcePos = MasterSourcePos;
    do {
        while (Chr == ASCII_SPACE) {
            NextChr();
        }
        switch (ASCIIToChrCode[(byte)Chr]) {
            case CHR_EOF:
                tk_Token = TK_EOF;
                break;
            case CHR_LETTER:
                ProcessLetterToken();
                break;
            case CHR_NUMBER:
                ProcessNumberToken();
                break;
            case CHR_QUOTE:
                ProcessQuoteToken();
                break;
            default:
                ProcessSpecialToken();
                break;
        }
        if (tk_Token == TK_STARTCOMMENT) {
            SkipComment();
        } else if (tk_Token == TK_CPPCOMMENT) {
            SkipCPPComment();
        } else if ((tk_Token == TK_EOF) && (NestDepth > 0)) {
            if (PopNestedSource(&prevMode)) {
                ImportMode = prevMode;
                if (!ExporterFlagged) {
                    ERR_Exit(ERR_EXPORTER_NOT_FLAGGED, YES, NULL);
                }
                SY_ClearShared();
            }
        } else {
            validToken = YES;
        }
    } while (validToken == NO);
    return tk_Token;
}

//==========================================================================
//
// TK_NextCharacter
//
//==========================================================================

int TK_NextCharacter(void) {
    int c;

    while (Chr == ASCII_SPACE) {
        NextChr();
    }
    c = (int)Chr;
    if (c == EOF_CHARACTER) {
        c = -1;
    }
    NextChr();
    return c;
}

//==========================================================================
//
// TK_SkipPast
//
//==========================================================================

void TK_SkipPast(tokenType_t token) {
    while (tk_Token != token && tk_Token != TK_EOF) {
        TK_NextToken();
    }
    TK_NextToken();
}

//==========================================================================
//
// TK_SkipTo
//
//==========================================================================

void TK_SkipTo(tokenType_t token) {
    while (tk_Token != token && tk_Token != TK_EOF) {
        TK_NextToken();
    }
}

//==========================================================================
//
// TK_NextTokenMustBe
//
//==========================================================================

boolean TK_NextTokenMustBe(tokenType_t token, error_t error) {
    if (TK_NextToken() != token) {
        ERR_Error(error, YES);
        /*
        if(skipToken == TK_EOF)
        {
                ERR_Finish();
        }
        else if(skipToken != TK_NONE)
        {
                TK_SkipPast(skipToken);
        }
        return NO;
        */
        ERR_Finish();
    }
    return YES;
}

//==========================================================================
//
// TK_TokenMustBe
//
//==========================================================================

boolean TK_TokenMustBe(tokenType_t token, error_t error) {
    if (token == TK_SEMICOLON && forSemicolonHack) {
        token = TK_RPAREN;
    }
    if (tk_Token != token) {
        ERR_Error(error, YES);
        /*
        if(skipToken == TK_EOF)
        {
                ERR_Finish();
        }
        else if(skipToken != TK_NONE)
        {
                while(tk_Token != skipToken)
                {
                        TK_NextToken();
                }
        }
        return NO;
        */
        ERR_Finish();
    }
    return YES;
}

//==========================================================================
//
// TK_Member
//
//==========================================================================

boolean TK_Member(tokenType_t *list) {
    int i;

    for (i = 0; list[i] != TK_NONE; i++) {
        if (tk_Token == list[i]) {
            return YES;
        }
    }
    return NO;
}

//==========================================================================
//
// TK_Undo
//
//==========================================================================

void TK_Undo(void) {
    if (tk_Token != TK_NONE) {
        if (AlreadyGot == FALSE) {
            int t = MasterSourcePos;
            MasterSourcePos = PrevMasterSourcePos;
            PrevMasterSourcePos = t;
            AlreadyGot = TRUE;
        }
    }
}

//==========================================================================
//
// ProcessLetterToken
//
//==========================================================================

static void ProcessLetterToken(void) {
    int i;
    char *text;

    i = 0;
    text = TokenStringBuffer;
    while (ASCIIToChrCode[(byte)Chr] == CHR_LETTER ||
           ASCIIToChrCode[(byte)Chr] == CHR_NUMBER) {
        if (++i == MAX_IDENTIFIER_LENGTH) {
            ERR_Error(ERR_IDENTIFIER_TOO_LONG, YES);
        }
        if (i < MAX_IDENTIFIER_LENGTH) {
            *text++ = Chr;
        }
        NextChr();
    }
    *text = 0;
    MS_StrLwr(TokenStringBuffer);
    if (CheckForKeyword() == FALSE && CheckForLineSpecial() == FALSE &&
        CheckForConstant() == FALSE) {
        tk_Token = TK_IDENTIFIER;
    }
}

//==========================================================================
//
// CheckForKeyword
//
//==========================================================================

static boolean CheckForKeyword(void) {
    int min, max, probe, lexx;

    // [RH] Use a binary search
    min = 0;
    max = NUM_KEYWORDS - 1;
    probe = NUM_KEYWORDS / 2;

    while (max - min >= 0) {
        lexx = strcmp(tk_String, Keywords[probe].name);
        if (lexx == 0) {
            tk_Token = Keywords[probe].token;
            return TRUE;
        } else if (lexx < 0) {
            max = probe - 1;
        } else {
            min = probe + 1;
        }
        probe = (max - min) / 2 + min;
    }
    return FALSE;
}

//==========================================================================
//
// CheckForLineSpecial
//
//==========================================================================

static boolean CheckForLineSpecial(void) {
    symbolNode_t *sym;

    sym = SY_FindGlobal(tk_String);
    if (sym == NULL) {
        return FALSE;
    }
    if (sym->type != SY_SPECIAL) {
        return FALSE;
    }
    tk_Token = TK_LINESPECIAL;
    tk_SpecialValue = sym->info.special.value;
    tk_SpecialArgCount = sym->info.special.argCount;
    return TRUE;
}

//==========================================================================
//
// CheckForConstant
//
//==========================================================================

static boolean CheckForConstant(void) {
    symbolNode_t *sym;

    sym = SY_FindGlobal(tk_String);
    if (sym == NULL) {
        return FALSE;
    }
    if (sym->type != SY_CONSTANT) {
        return FALSE;
    }
    if (sym->info.constant.strValue != NULL) {
        MS_Message(MSG_DEBUG, "Constant string: %s\n",
                   sym->info.constant.strValue);
        tk_Token = TK_STRING;
        tk_String = sym->info.constant.strValue;
    } else {
        tk_Token = TK_NUMBER;
        tk_Number = sym->info.constant.value;
    }
    return TRUE;
}

//==========================================================================
//
// ProcessNumberToken
//
//==========================================================================

static void ProcessNumberToken(void) {
    char c;

    c = Chr;
    NextChr();
    if (c == '0' && (Chr == 'x' || Chr == 'X')) {  // Hexadecimal constant
        NextChr();
        EvalHexConstant();
        return;
    }
    tk_Number = c - '0';
    while (ASCIIToChrCode[(byte)Chr] == CHR_NUMBER) {
        tk_Number = 10 * tk_Number + (Chr - '0');
        NextChr();
    }
    if (Chr == '.') {  // Fixed point
        NextChr();     // Skip period
        EvalFixedConstant(tk_Number);
        return;
    }
    if (Chr == ASCII_UNDERSCORE) {
        NextChr();  // Skip underscore
        EvalRadixConstant();
        return;
    }
    tk_Token = TK_NUMBER;
}

//==========================================================================
//
// EvalFixedConstant
//
//==========================================================================

static void EvalFixedConstant(int whole) {
    double frac;
    double divisor;

    frac = 0;
    divisor = 1;
    while (ASCIIToChrCode[(byte)Chr] == CHR_NUMBER) {
        frac = 10 * frac + (Chr - '0');
        divisor *= 10;
        NextChr();
    }
    tk_Number = (whole << 16) + (int)(65536.0 * frac / divisor);
    tk_Token = TK_NUMBER;
}

//==========================================================================
//
// EvalHexConstant
//
//==========================================================================

static void EvalHexConstant(void) {
    tk_Number = 0;
    while (ASCIIToHexDigit[(byte)Chr] != NON_HEX_DIGIT) {
        tk_Number = (tk_Number << 4) + ASCIIToHexDigit[(byte)Chr];
        NextChr();
    }
    tk_Token = TK_NUMBER;
}

//==========================================================================
//
// EvalRadixConstant
//
//==========================================================================

static void EvalRadixConstant(void) {
    int radix;
    int digitVal;

    radix = tk_Number;
    if (radix < 2 || radix > 36) {
        ERR_Error(ERR_BAD_RADIX_CONSTANT, YES, NULL);
        radix = 36;
    }
    tk_Number = 0;
    while ((digitVal = DigitValue(Chr, radix)) != -1) {
        tk_Number = radix * tk_Number + digitVal;
        NextChr();
    }
    tk_Token = TK_NUMBER;
}

//==========================================================================
//
// DigitValue
//
// Returns -1 if the digit is not allowed in the specified radix.
//
//==========================================================================

static int DigitValue(char digit, int radix) {
    digit = toupper(digit);
    if (digit < '0' || (digit > '9' && digit < 'A') || digit > 'Z') {
        return -1;
    }
    if (digit > '9') {
        digit = 10 + digit - 'A';
    } else {
        digit -= '0';
    }
    if (digit >= radix) {
        return -1;
    }
    return digit;
}

//==========================================================================
//
// ProcessQuoteToken
//
//==========================================================================

static void ProcessQuoteToken(void) {
    int i;
    char *text;
    boolean escaped;

    i = 0;
    escaped = FALSE;
    text = TokenStringBuffer;
    NextChr();
    while (Chr != EOF_CHARACTER) {
        if (Chr == ASCII_QUOTE && escaped == 0)  // [JB]
        {
            break;
        }
        if (++i == MAX_QUOTED_LENGTH) {
            ERR_Error(ERR_STRING_TOO_LONG, YES, NULL);
        }
        if (i < MAX_QUOTED_LENGTH) {
            *text++ = Chr;
        }
        // escape the character after a backslash [JB]
        if (Chr == '\\')
            escaped ^= (Chr == '\\');
        else
            escaped = FALSE;
        NextChr();
    }
    *text = 0;
    if (Chr == ASCII_QUOTE) {
        NextChr();
    }
    tk_Token = TK_STRING;
}

//==========================================================================
//
// ProcessSpecialToken
//
//==========================================================================

static void ProcessSpecialToken(void) {
    char c;

    c = Chr;
    NextChr();
    switch (c) {
        case '+':
            switch (Chr) {
                case '=':
                    tk_Token = TK_ADDASSIGN;
                    NextChr();
                    break;
                case '+':
                    tk_Token = TK_INC;
                    NextChr();
                    break;
                default:
                    tk_Token = TK_PLUS;
                    break;
            }
            break;
        case '-':
            switch (Chr) {
                case '=':
                    tk_Token = TK_SUBASSIGN;
                    NextChr();
                    break;
                case '-':
                    tk_Token = TK_DEC;
                    NextChr();
                    break;
                default:
                    tk_Token = TK_MINUS;
                    break;
            }
            break;
        case '*':
            switch (Chr) {
                case '=':
                    tk_Token = TK_MULASSIGN;
                    NextChr();
                    break;
                case '/':
                    tk_Token = TK_ENDCOMMENT;
                    NextChr();
                    break;
                default:
                    tk_Token = TK_ASTERISK;
                    break;
            }
            break;
        case '/':
            switch (Chr) {
                case '=':
                    tk_Token = TK_DIVASSIGN;
                    NextChr();
                    break;
                case '/':
                    tk_Token = TK_CPPCOMMENT;
                    break;
                case '*':
                    tk_Token = TK_STARTCOMMENT;
                    NextChr();
                    break;
                default:
                    tk_Token = TK_SLASH;
                    break;
            }
            break;
        case '%':
            if (Chr == '=') {
                tk_Token = TK_MODASSIGN;
                NextChr();
            } else {
                tk_Token = TK_PERCENT;
            }
            break;
        case '=':
            if (Chr == '=') {
                tk_Token = TK_EQ;
                NextChr();
            } else {
                tk_Token = TK_ASSIGN;
            }
            break;
        case '<':
            if (Chr == '=') {
                tk_Token = TK_LE;
                NextChr();
            } else if (Chr == '<') {
                NextChr();
                if (Chr == '=') {
                    tk_Token = TK_LSASSIGN;
                    NextChr();
                } else {
                    tk_Token = TK_LSHIFT;
                }

            } else {
                tk_Token = TK_LT;
            }
            break;
        case '>':
            if (Chr == '=') {
                tk_Token = TK_GE;
                NextChr();
            } else if (Chr == '>') {
                NextChr();
                if (Chr == '=') {
                    tk_Token = TK_RSASSIGN;
                    NextChr();
                } else {
                    tk_Token = TK_RSHIFT;
                }
            } else {
                tk_Token = TK_GT;
            }
            break;
        case '!':
            if (Chr == '=') {
                tk_Token = TK_NE;
                NextChr();
            } else {
                tk_Token = TK_NOT;
            }
            break;
        case '&':
            if (Chr == '&') {
                tk_Token = TK_ANDLOGICAL;
                NextChr();
            } else if (Chr == '=') {
                tk_Token = TK_ANDASSIGN;
                NextChr();
            } else {
                tk_Token = TK_ANDBITWISE;
            }
            break;
        case '|':
            if (Chr == '|') {
                tk_Token = TK_ORLOGICAL;
                NextChr();
            } else if (Chr == '=') {
                tk_Token = TK_ORASSIGN;
                NextChr();
            } else {
                tk_Token = TK_ORBITWISE;
            }
            break;
        case '(':
            tk_Token = TK_LPAREN;
            break;
        case ')':
            tk_Token = TK_RPAREN;
            break;
        case '{':
            tk_Token = TK_LBRACE;
            break;
        case '}':
            tk_Token = TK_RBRACE;
            break;
        case '[':
            tk_Token = TK_LBRACKET;
            break;
        case ']':
            tk_Token = TK_RBRACKET;
            break;
        case '?':
            tk_Token = TK_TERNARY;
            break;
        case ':':
            tk_Token = TK_COLON;
            break;
        case ';':
            tk_Token = TK_SEMICOLON;
            break;
        case ',':
            tk_Token = TK_COMMA;
            break;
        case '.':
            tk_Token = TK_PERIOD;
            break;
        case '#':
            tk_Token = TK_NUMBERSIGN;
            break;
        case '@':
            tk_Token = TK_ATSIGN;
            break;
        case '^':
            if (Chr == '=') {
                tk_Token = TK_EORASSIGN;
                NextChr();
            } else {
                tk_Token = TK_EORBITWISE;
            }
            break;
        case '~':
            tk_Token = TK_TILDE;
            break;
        case '\'':
            if (Chr == '\\') {
                NextChr();
                switch (Chr) {
                    case '0':
                    case '1':
                    case '2':
                    case '3':
                    case '4':
                    case '5':
                    case '6':
                    case '7':
                        tk_Number = OctalChar();
                        break;
                    case 'x':
                    case 'X':
                        NextChr();
                        EvalHexConstant();
                        if (Chr != '\'') {
                            ERR_Exit(ERR_BAD_CHARACTER_CONSTANT, YES, NULL);
                        }
                        NextChr();
                        break;
                    case 'a':
                        tk_Number = '\a';
                        break;
                    case 'b':
                        tk_Number = '\b';
                        break;
                    case 't':
                        tk_Number = '\t';
                        break;
                    case 'v':
                        tk_Number = '\v';
                        break;
                    case 'n':
                        tk_Number = '\n';
                        break;
                    case 'f':
                        tk_Number = '\f';
                        break;
                    case 'r':
                        tk_Number = '\r';
                        break;
                    case '\'':
                    case '\\':
                        tk_Number = Chr;
                        break;
                    default:
                        ERR_Exit(ERR_BAD_CHARACTER_CONSTANT, YES, NULL);
                }
                tk_Token = TK_NUMBER;
            } else if (Chr == '\'') {
                ERR_Exit(ERR_BAD_CHARACTER_CONSTANT, YES, NULL);
            } else {
                tk_Number = Chr;
                tk_Token = TK_NUMBER;
            }
            NextChr();
            if (Chr != '\'') {
                ERR_Exit(ERR_BAD_CHARACTER_CONSTANT, YES, NULL);
            }
            NextChr();
            break;
        default:
            ERR_Exit(ERR_BAD_CHARACTER, YES, NULL);
            break;
    }
}

//==========================================================================
//
// NextChr
//
//==========================================================================

static void NextChr(void) {
    if (FilePtr >= FileEnd) {
        Chr = EOF_CHARACTER;
        return;
    }
    if (IncLineNumber == TRUE) {
        tk_Line++;
        IncLineNumber = FALSE;
        BumpMasterSourceLine('x', TRUE);  // dummy x
    }
    Chr = *FilePtr++;
    if (Chr < ASCII_SPACE && Chr >= 0)  // Allow high ASCII characters
    {
        if (Chr == '\n') {
            IncLineNumber = TRUE;
        }
        Chr = ASCII_SPACE;
    }
    BumpMasterSourceLine(Chr, FALSE);
}

//==========================================================================
//
// PeekChr // [JB]
//
//==========================================================================

static int PeekChr(void) {
    char ch;
    if (FilePtr >= FileEnd) {
        return EOF_CHARACTER;
    }
    ch = *FilePtr - 1;
    if (ch < ASCII_SPACE && ch >= 0)  // Allow high ASCII characters
    {
        ch = ASCII_SPACE;
    }
    return ch;
}

//==========================================================================
//
// OctalChar // [JB]
//
//==========================================================================

static int OctalChar() {
    int digits = 1;
    int code = Chr - '0';
    while (digits < 4 && PeekChr() >= '0' && PeekChr() <= '7') {
        NextChr();
        code = (code << 3) + Chr - '0';
    }
    return code;
}

//==========================================================================
//
// SkipComment
//
//==========================================================================

void SkipComment(void) {
    boolean first;

    first = FALSE;
    while (Chr != EOF_CHARACTER) {
        if (first == TRUE && Chr == '/') {
            break;
        }
        first = (Chr == '*');
        NextChr();
    }
    NextChr();
}

//==========================================================================
//
// SkipCPPComment
//
//==========================================================================

void SkipCPPComment(void) {
    while (FilePtr < FileEnd) {
        if (*FilePtr++ == '\n') {
            tk_Line++;
            BumpMasterSourceLine('x', TRUE);  // dummy x
            break;
        }
    }
    NextChr();
}

//==========================================================================
//
// BumpMasterSourceLine
//
//==========================================================================

void BumpMasterSourceLine(char Chr,
                          boolean clear)  // master line - Ty 07jan2000
{
    if (ClearMasterSourceLine)  // set to clear last time, clear now for first
                                // character
    {
        *MasterSourceLine = '\0';
        MasterSourcePos = 0;
        ClearMasterSourceLine = FALSE;
    }
    if (clear) {
        ClearMasterSourceLine = TRUE;
    } else {
        if (MasterSourcePos < MAX_STATEMENT_LENGTH)
            MasterSourceLine[MasterSourcePos++] = Chr;
    }
}

//==========================================================================
//
// TK_SkipLine
//
//==========================================================================

void TK_SkipLine(void) {
    char *sourcenow = tk_SourceName;
    int linenow = tk_Line;
    do TK_NextToken();
    while (tk_Line == linenow && tk_SourceName == sourcenow &&
           tk_Token != TK_EOF);
}
