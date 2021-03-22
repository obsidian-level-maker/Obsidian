//----------------------------------------------------------------------------
//
// File:        ZenRMB.cpp
// Date:        30-Oct-2000
// Programmer:  Marc Rousseau
//
// Description: RMB configuration file support for ZenNode
//
// Copyright (c) 2000-2004 Marc Rousseau, All Rights Reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
//
// Revision History:
//
//----------------------------------------------------------------------------

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.hpp"
#include "logger.hpp"
#include "level.hpp"
#include "zennode.hpp"
#include "blockmap.hpp"


DBG_REGISTER ( __FILE__ );

bool ParseGeneric ( char *, const sOptionTableInfo &, sRejectOptionRMB * );
bool ParseMap ( char *, const sOptionTableInfo &, sRejectOptionRMB * );
bool ParseBAND ( char *, const sOptionTableInfo &, sRejectOptionRMB * );
bool ParseINVERT ( char *, const sOptionTableInfo &, sRejectOptionRMB * );
bool ParseNOPROCESS ( char *, const sOptionTableInfo &, sRejectOptionRMB * );

sOptionTableInfo ParseTable [] = {
    { "BAND",       "NNL", OPTION_BAND,       ParseBAND      },
    { "BLIND",      "NL",  OPTION_BLIND,      ParseGeneric   },
    { "BLOCK",      "NN",  OPTION_BLOCK,      ParseGeneric   },
    { "DISTANCE",   "N",   OPTION_DISTANCE,   ParseGeneric   },
    { "DOOR",       "N",   OPTION_DOOR,       ParseGeneric   },
    { "E*M*",       NULL,  OPTION_MAP_1,      ParseMap       },
    { "EXCLUDE",    "LL",  OPTION_EXCLUDE,    ParseGeneric   },
    { "GROUP",      "NL",  OPTION_GROUP,      ParseGeneric   },
    { "INCLUDE",    "LL",  OPTION_INCLUDE,    ParseGeneric   },
    { "INVERT",     NULL,  OPTION_UNKNOWN,    ParseINVERT    },
    { "LEFT",       "N",   OPTION_LEFT,       ParseGeneric   },
    { "LENGTH",     "N",   OPTION_LENGTH,     ParseGeneric   },
    { "LINE",       "N",   OPTION_LINE,       ParseGeneric   },
    { "MAP**",      NULL,  OPTION_MAP_2,      ParseMap       },
    { "NODOOR",     "L",   OPTION_NODOOR,     ParseGeneric   },
    { "NOMAP",      NULL,  OPTION_NOMAP,      ParseGeneric   },
    { "NOPROCESS",  NULL,  OPTION_NOPROCESS,  ParseNOPROCESS },
    { "ONE",        "NN",  OPTION_ONE,        ParseGeneric   },
    { "PERFECT",    NULL,  OPTION_PERFECT,    ParseGeneric   },
    { "PREPROCESS", "N",   OPTION_PREPROCESS, ParseGeneric   },
    { "PROCESS",    "L",   OPTION_PROCESS,    ParseGeneric   },
    { "REPORT",     "N",   OPTION_REPORT,     ParseGeneric   },
    { "RIGHT",      "N",   OPTION_RIGHT,      ParseGeneric   },
    { "SAFE",       "NL",  OPTION_SAFE,       ParseGeneric   },
    { "TRACE",      "L",   OPTION_TRACE,      ParseGeneric   }
};

static const char *parseText;
static int         parseLine;
static int         lastLine;

const sOptionTableInfo *FindByType ( REJECT_OPTION_E type )
{
    for ( unsigned i = 0; i < SIZE ( ParseTable ); i++ ) {
        if ( ParseTable [i].Type == type ) return &ParseTable [i];
    }
    return NULL;
}

void ParseError ( const char *fmt, ... )
{
    FUNCTION_ENTRY ( NULL, "ParseError", true );

    va_list args;
    va_start ( args, fmt );

    fprintf ( stderr, ( lastLine == parseLine ) ? "          " : "Line %3d: ", parseLine );
    vfprintf ( stderr, fmt, args );
    fprintf ( stderr, "\n" );

    lastLine = parseLine;
    // 2017 fix by Zokum
    va_end(args);
}

int ParseNumber ( char *&text )
{
    FUNCTION_ENTRY ( NULL, "ParseNumber", true );

    if ( ! isdigit ( *text )) throw "expected a number";

    int number = 0;

    while ( isdigit ( *text )) {
        number *= 10;
        number += *text++ - '0';
    }

    return number;
}

int *ParseList ( char *&text, bool strict )
{
    FUNCTION_ENTRY ( NULL, "ParseList", true );

    if (( strict == true ) && ( *text != '(' )) {
        int *list = new int [ 2 ];
        list [0] = ParseNumber ( text );
        list [1] = -1;
        return list;
    }

    bool close = false;

    if ( *text == '(' ) {
        close = true;
        text++;
    }

    while ( isspace ( *text )) text++;
    
    if ( *text == '\0' ) throw "Invalid list";

    int count = 0;

    char *ptr = text;
    if ( isdigit ( *ptr )) {
        while (( *ptr != '\0' ) && ( *ptr != ')' )) {
            if ( ! isdigit ( *ptr )) throw "Invalid list";
            while ( isdigit ( *ptr )) ptr++;
            if ( *ptr == ',' ) ptr++;
            while ( isspace ( *ptr )) ptr++;
            count++;
        }
/* Is this valid???
    } else {
        if ( strncmp ( ptr, "ALL", 3 ) != 0 ) throw "Invalid list";
        ptr += 3;
        while ( isspace ( *ptr )) ptr++;
*/
    }

    if (( close == true ) && ( *ptr != ')' )) throw "List must end with a ')'";

    int *list = new int [ count + 1 ];
    for ( int i = 0; i < count; i++ ) {
        list [i] = atoi ( text );
        while ( isdigit ( *text )) text++;
        if ( *text == ',' ) text++;
        while ( isspace ( *text )) text++;
    }

    if ( close == true ) text++;

    list [count] = -1;

    return list;
}

bool ParseGeneric ( char *text, const sOptionTableInfo &info, sRejectOptionRMB *option )
{
    FUNCTION_ENTRY ( NULL, "ParseGeneric", true );

    int dataIndex = 0;
    int listIndex = 0;

    const char *syntax = info.Syntax;

    try {

        if ( syntax != NULL ) while ( *syntax ) {
            while ( isspace ( *text )) text++;
            switch ( *syntax++ ) {
                case 'N' :
                    option->Data [dataIndex++] = ParseNumber ( text );
                    break;
                case 'L' :
                    option->List [listIndex++] = ParseList ( text, ( *syntax != '\0' ) ? true : false );
                    break;
            }
        }

        while ( isspace ( *text )) text++;
        if (( *text != '\0' ) && ( *text != '#' )) throw "unexpected characters after command";

        option->Info = &info;
    }

    catch ( const char *message ) {
        ParseError ( "Syntax error - %s.", message );
        return false;
    }

    return true;
}

bool ParseMap ( char *text, const sOptionTableInfo &info, sRejectOptionRMB *option )
{
    option->Info = &info;

    while ( ! isdigit ( *text )) text--;

    switch ( info.Type ) {
        case OPTION_MAP_1 :
            option->Data [0] = text [-2] - '0';
            option->Data [1] = text [0] - '0';
            break;
        case OPTION_MAP_2 :
            option->Data [0] = ( text [-1] - '0' ) * 10 + ( text [0] - '0' );
            break;
        default :
            ParseError ( "Unable to parse map name" );
            break;
    }

    return true;
}

bool ParseBAND ( char *text, const sOptionTableInfo &info, sRejectOptionRMB *option )
{
    FUNCTION_ENTRY ( NULL, "ParseBAND", true );

    REJECT_OPTION_E type = OPTION_UNKNOWN;

    while ( isspace ( *text )) text++;

    if ( strncmp ( text, "BLIND", 5 ) == 0 ) {
        type = OPTION_BLIND;
        text += 5;
    } else if ( strncmp ( text, "SAFE", 5 ) == 0 ) {
        type = OPTION_SAFE;
        text += 4;
    } else {
        goto bad_option;
    }

    if ( isspace ( *text )) {
        bool retVal = ParseGeneric ( text, info, option );
        option->Banded = true;
        option->Info   = FindByType ( type );
        return retVal;
    }

bad_option:

    ParseError ( "Invalid BAND option." );
    return false;
}

bool ParseINVERT ( char *text, const sOptionTableInfo &info, sRejectOptionRMB *option )
{
    FUNCTION_ENTRY ( NULL, "ParseINVERT", true );

    if ( ParseOptionRMB ( -1, text, option ) == true ) {
        switch ( option->Info->Type ) {
            case OPTION_BAND :
            case OPTION_BLIND :
            case OPTION_SAFE :
                option->Inverted = true;
                break;
            default :
                ParseError ( "Invalid %s option '%s'.", info.Name, text );
                return false;
        }
        return true;
    } else {
        ParseError ( "Unable to process %s effect.", info.Name );
    }

    return false;
}

bool ParseNOPROCESS ( char *text, const sOptionTableInfo &info, sRejectOptionRMB *option )
{
    FUNCTION_ENTRY ( NULL, "ParseNOPROCESS", true );

    return false;
}

bool ParseOptionRMB ( int lineNumber, const char *lineText, sRejectOptionRMB *option )
{
    FUNCTION_ENTRY ( NULL, "ParseOptionRMB", true );

    ASSERT ( lineText != NULL );
    ASSERT ( option != NULL );

    if ( lineNumber > 0 ) {
        parseLine = lineNumber;
        parseText = lineText;
    }

    memset ( option, 0, sizeof ( sRejectOptionRMB ));

    const char *srcText = lineText;
    while (( *srcText != '\0' ) && ( isspace ( *srcText ))) srcText++;

    if (( *srcText == '#' ) || ( *srcText == '\0' )) return false;

    size_t length = strlen ( srcText );
    char *buffer = new char [ length + 1 ];
    for ( size_t i = 0; i < length; i++ ) {
        buffer [i] = toupper ( srcText [i] );
        if (( buffer [i] == '\r' ) || ( buffer [i] == '\n' )) length = i;
    }
    buffer [length] = '\0';

    char *start = buffer;
    char *end   = buffer;
    while (( *end != '\0' ) && ( ! isspace ( *end ))) end++;

    bool retVal = false;

    if ( start != end ) {

        for ( unsigned i = 0; i < SIZE ( ParseTable ); i++ ) {
            char *src = start;
            const char *tgt = ParseTable [i].Name;
            while (( src != end ) && ( *tgt != '\0' )) {
                if ( *src != *tgt ) {
                    if ( *tgt != '*' ) goto next;
                    if ( ! isdigit ( *src )) goto next;
                }
                src++;
                tgt++;
            }
            if (( i + 1 < SIZE ( ParseTable )) && ( strncmp ( buffer, ParseTable [i+1].Name, src - buffer ) == 0 )) {
                ParseError ( "'%*.*s' is not a unique identifier.", end - buffer, end - buffer, buffer );
                goto done;
            }
            while ( isspace ( *end )) end++;
            retVal = ParseTable [i].ParseFunction ( end, ParseTable [i], option );
            goto done;
        next:
            ;
        }

        ParseError ( "Unrecognized effect '%*.*s'.", end - buffer, end - buffer, buffer );
    }

done:

    delete [] buffer;

    return retVal;
}

void PrintOption ( FILE *file, sRejectOptionRMB *option )
{
    const sOptionTableInfo *info = option->Info;
    const char *syntax           = info->Syntax;

    if ( option->Inverted ) fprintf ( file, "INVERT " );
    if ( option->Banded ) {
        syntax = "NNL";
        fprintf ( file, "BAND " );
    }

    switch ( info->Type ) {
        case OPTION_MAP_1 :
            fprintf ( file, "E%dM%d", option->Data [0], option->Data [1] );
            break;
        case OPTION_MAP_2 :
            fprintf ( file, "MAP%02d", option->Data [0] );
            break;
        default :
            fprintf ( file, "%s", info->Name );
            break;
    }

    int dataIndex = 0;
    int listIndex = 0;

    if ( syntax != NULL ) while ( *syntax ) {
        switch ( *syntax++ ) {
            case 'N' :
                fprintf ( file, " %d", option->Data [dataIndex++] );
                break;
            case 'L' :
                int *list;
                fprintf ( file, " (" );
                list = option->List [listIndex++];
                while ( *list != -1 ) fprintf ( file, " %d", *list++ );
                fprintf ( file, " )" );
                break;
            default :
                fprintf ( stderr, "Internal error: Invalid syntax\n" );
                break;
        }
    }

    fprintf ( file, "\n" );
}
