//----------------------------------------------------------------------------
//
// File:        bspinfo.cpp
// Date:        11-Oct-1995
// Programmer:  Marc Rousseau
//
// Description: An application to analyze the contents of a BSP tree
//
// Copyright (c) 1995-2004 Marc Rousseau, All Rights Reserved.
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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef _WIN32
	#include <strings.h>
#endif
#include "common.hpp"
#include "logger.hpp"
#include "wad.hpp"
#include "level.hpp"
#include "console.hpp"

#if defined ( __OS2__ )
    #include <conio.h>
    #include <io.h>
#elif defined ( __WIN32__ )
    #include <conio.h>
    #include <io.h>
#elif defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )
    #include <unistd.h>
#else
    #error This program must be compiled as a 32-bit app.
#endif

DBG_REGISTER ( __FILE__ );

#define VERSION		"1.3"
#define BANNER          "BSPInfo Version " VERSION " (c) 1995-2004 Marc Rousseau"
#define MAX_LEVELS	99

#if defined ( __GNUC__ ) || defined ( __INTEL_COMPILER )

#define stricmp strcasecmp

extern char *strupr ( char *ptr );

#endif

struct flags {
    bool  Tree;
} flags;

void printHelp ()
{
    fprintf ( stderr, "Usage: bspInfo [-options] filename[.wad] [level[+level]]\n" );
    fprintf ( stderr, "\n" );
    fprintf ( stderr, "     -x+ turn on option   -x- turn off option  %c = default\n", DEFAULT_CHAR );
    fprintf ( stderr, "\n" );
    fprintf ( stderr, "        -t    - Display NODE tree\n" );
    fprintf ( stderr, "\n" );
    fprintf ( stderr, "        level - ExMy for DOOM / Heretic\n" );
    fprintf ( stderr, "                MAPxx for DOOM II / HEXEN\n" );
}

int parseArgs ( int index, const char *argv [] )
{
    FUNCTION_ENTRY ( NULL, "parseArgs", true );

    bool errors = false;
    while ( argv [ index ] ) {

        if ( argv [index][0] != '-' ) break;

        char *localCopy = strdup ( argv [ index ]);
        char *ptr = localCopy + 1;
        strupr ( localCopy );

        bool localError = false;
        while ( *ptr && ( localError == false )) {
            int option = *ptr++;
            bool setting = true;
            if (( *ptr == '+' ) || ( *ptr == '-' )) {
                setting = ( *ptr == '-' ) ? false : true;
                ptr++;
            }
            switch ( option ) {
                case 'T' : flags.Tree = setting;	break;
                default  : localError = true;
            }
        }
        if ( localError ) {
            errors = true;
            int offset = ptr - localCopy - 1;
            size_t width = strlen ( ptr ) + 1;
            fprintf ( stderr, "Unrecognized parameter '%*.*s'\n", (int) width, (int) width, argv [index] + offset );
        }
        free ( localCopy );
        index++;
    }

    if ( errors ) fprintf ( stderr, "\n" );

    return index;
}

int getLevels ( int argIndex, const char *argv [], char names [][MAX_LUMP_NAME], wadList *list )
{
    FUNCTION_ENTRY ( NULL, "getLevels", true );

    int index = 0, errors = 0;

    char buffer [128];
    buffer [0] = '\0';
    if ( argv [argIndex] ) {
        strcpy ( buffer, argv [argIndex] );
        strupr ( buffer );
    }
    char *ptr = strtok ( buffer, "+" );

    // See if the user requested specific levels
    if ( WAD::IsMap ( ptr )) {
        argIndex++;
        while ( ptr ) {
            if ( WAD::IsMap ( ptr )) {
                if ( list->FindWAD ( ptr )) {
                    strcpy ( names [index++], ptr );
                } else {
                    fprintf ( stderr, "  Could not find %s\n", ptr, errors++ );
                }
            } else {
                fprintf ( stderr, "  %s is not a valid name for a level\n", ptr, errors++ );
            }
            ptr = strtok ( NULL, "+" );
        }
    } else {
        int size = list->DirSize ();
        const wadListDirEntry *dir = list->GetDir ( 0 );
        for ( int i = 0; i < size; i++ ) {
            if ( dir->wad->IsMap ( dir->entry->name )) {
                // Make sure it's really a level
                if ( strcmp ( dir[1].entry->name, "THINGS" ) == 0 ) {
                    if ( index == MAX_LEVELS ) {
                        fprintf ( stderr, "ERROR: Too many levels in WAD - ignoring %s!\n", dir->entry->name, errors++ );
                    } else {
                        memcpy ( names [index++], dir->entry->name, MAX_LUMP_NAME );
                    }
                }
            }
            dir++;
        }
    }
    memset ( names [index], 0, MAX_LUMP_NAME );

    if ( errors ) fprintf ( stderr, "\n" );

    return argIndex;
}

void EnsureExtension ( char *fileName, const char *ext )
{
    FUNCTION_ENTRY ( NULL, "EnsureExtension", true );

    // See if the file exists first
    FILE *file = fopen ( fileName, "rb" );
    if ( file != NULL ) {
        fclose ( file );
        return;
    }

    size_t length = strlen ( fileName );
    if ( stricmp ( &fileName [length-4], ext ) != 0 ) {
        strcat ( fileName, ext );
    }
}

const char *TypeName ( eWadType type )
{
    FUNCTION_ENTRY ( NULL, "TypeName", true );

    const char *name = NULL;
    switch ( type ) {
        case wt_DOOM    : name = "DOOM";	break;
        case wt_DOOM2   : name = "DOOM2";	break;
        case wt_HERETIC : name = "Heretic";	break;
        case wt_HEXEN   : name = "Hexen";	break;
        default         : name = "<Unknown>";	break;
    }
    return name;
}

wadList *getInputFiles ( const char *cmdLine, char *wadFileName )
{
    FUNCTION_ENTRY ( NULL, "getInputFiles", true );

    char *listNames = wadFileName;
    wadList *myList = new wadList;

    if ( cmdLine == NULL ) return myList;

    char temp [ 256 ];
    strcpy ( temp, cmdLine );
    char *ptr = strtok ( temp, "+" );

    int errors = 0;

    while ( ptr && *ptr ) {
        char wadName [ 256 ];
        strcpy ( wadName, ptr );
        EnsureExtension ( wadName, ".wad" );

        WAD *wad = new WAD ( wadName );
        if ( wad->Status () != ws_OK ) {
            const char *msg;
            switch ( wad->Status ()) {
                case ws_INVALID_FILE : msg = "The file %s does not exist\n";		break;
                case ws_CANT_READ    : msg = "Can't open the file %s for read access\n";	break;
                case ws_INVALID_WAD  : msg = "%s is not a valid WAD file\n";		break;
                default              : msg = "** Unexpected Error opening %s **\n";	break;
            }
            fprintf ( stderr, msg, wadName );
            delete wad;
        } else {
            if ( ! myList->IsEmpty ()) {
                cprintf ( "Merging: %s with %s\r\n", wadName, listNames );
                *wadFileName++ = '+';
            }
            if ( myList->Add ( wad ) == false ) {
                errors++;
                if ( myList->Type () != wt_UNKNOWN ) {
                    fprintf ( stderr, "ERROR: %s is not a %s PWAD.\n", wadName, TypeName ( myList->Type ()));
                } else {
                    fprintf ( stderr, "ERROR: %s is not the same type.\n", wadName );
                }
                delete wad;
            } else {
                char *end = wadName + strlen ( wadName ) - 1;
                while (( end > wadName ) && ( *end != SEPERATOR )) end--;
                if ( *end == SEPERATOR ) end++;
                wadFileName += sprintf ( wadFileName, "%s", end );
            }
        }
        ptr = strtok ( NULL, "+" );
    }

    if ( wadFileName [-1] == '+' ) wadFileName [-1] = '\0';
    if ( myList->wadCount () > 1 ) cprintf ( "\r\n" );
    if ( errors ) fprintf ( stderr, "\n" );

    return myList;
}

const wNode *nodes;
int totalDepth;

int Traverse ( int index, int depth, int &diagonals, int &balance, int &lChildren, int &rChildren )
{
    FUNCTION_ENTRY ( NULL, "Traverse", false );

    const wNode *node = &nodes [ index ];

    if ( flags.Tree ) printf ( "(%5d,%5d)  [%5d,%5d]\n", node->x, node->y, node->dx, node->dy );

    if (( node->dx != 0 ) && ( node->dy != 0 )) diagonals++;

    int lIndex = node->child [0];
    int rIndex = node->child [1];

    if (( lIndex & 0x8000 ) == ( rIndex & 0x8000 )) balance++;

    int lDepth = 0, rDepth = 0;

    depth++;

    if ( flags.Tree ) printf ( "%5d %*.*sLeft - ", depth, depth*2, depth*2, "" );

    if (( lIndex & 0x8000 ) == 0 ) {
        int left = 0, right = 0;
        lDepth    = Traverse ( lIndex, depth, diagonals, balance, left, right );
        lChildren = 1 + left + right;
    } else {
        if ( flags.Tree ) printf ( "** NONE **\n" );
        lDepth      = depth;
        totalDepth += depth + 1;
    }

    if ( flags.Tree ) printf ( "%5d %*.*sRight - ", depth, depth*2, depth*2, "" );

    if (( rIndex & 0x8000 ) == 0 ) {
        int left = 0, right = 0;
        rDepth    = Traverse ( rIndex, depth, diagonals, balance, left, right );
        rChildren = 1 + left + right;
    } else {
        if ( flags.Tree ) printf ( "** NONE **\n" );
        rDepth      = depth;
        totalDepth += depth + 1;
    }

    return (( lDepth > rDepth ) ? lDepth : rDepth );
}

void AnalyzeBSP ( DoomLevel *curLevel )
{
    FUNCTION_ENTRY ( NULL, "AnalyzeBSP", true );

    if ( curLevel->IsValid ( true, true ) == false ) {
        printf ( "******** Invalid level ********" );
        return;
    }

    totalDepth = 0;

    nodes = curLevel->GetNodes ();
    int balance = 0, diagonals = 0;
    if ( flags.Tree ) printf ( "\n\nROOT: " );

    int left = 0;
    int right = 0;
    int depth = Traverse ( curLevel->NodeCount () - 1, 0, diagonals, balance, left, right );

    const wSegs *seg = curLevel->GetSegs ();
    const wLineDef *lineDef = curLevel->GetLineDefs ();

    bool *lineUsed = new bool [ curLevel->LineDefCount ()];
    memset ( lineUsed, false, sizeof ( bool ) * curLevel->LineDefCount ());
    for ( int i = 0; i < curLevel->SegCount (); i++, seg++ ) {
        lineUsed [ seg->lineDef ] = true;
    }

    int sideDefs = 0;
    for ( int i = 0; i < curLevel->LineDefCount (); i++ ) {
        if ( lineUsed [i] == false ) continue;
        if ( lineDef[i].sideDef[0] != NO_SIDEDEF ) sideDefs++;
        if ( lineDef[i].sideDef[1] != NO_SIDEDEF ) sideDefs++;
    }

    int splits = curLevel->SegCount () - sideDefs;

    int noLeafs  = curLevel->SubSectorCount ();
    int optDepth = ( int ) ceil ( log (( float ) noLeafs ) / log ( 2.0 ));
    int maxLeafs = ( int ) pow ( 2, optDepth );
    int minDepth = noLeafs * ( optDepth + 1 ) - maxLeafs;
    int maxDepth = noLeafs * (( noLeafs - 1 ) / 2 + 1 ) - 1;

    double minScore = ( double ) minDepth / ( double ) maxDepth;
    double score = ( double ) minDepth / ( double ) totalDepth;
    score = ( score - minScore ) / ( 1 - minScore );

    if ( ! flags.Tree ) {
        float avgDepth = noLeafs ? ( float ) totalDepth / ( float ) noLeafs : 0;
        printf ( "%2d  ", depth );
        printf ( "%4.1f   ", avgDepth );
        printf ( "%5.3f   ", score );
        printf ( "%5.3f ", ( left < right ) ? ( double ) left / ( double ) right : ( double ) right / ( double ) left );
        printf ( "%5d - %4.1f%% ", splits, 100.0 * splits / sideDefs );
        printf ( "%5d - %4.1f%% ", diagonals, 100.0 * diagonals / curLevel->NodeCount ());
        printf ( "%5d ", curLevel->NodeCount ());
        printf ( "%5d", curLevel->SegCount ());
    }
}

int main ( int argc, const char *argv[] )
{
    FUNCTION_ENTRY ( NULL, "main", true );

    SaveConsoleSettings ();

    cprintf ( "%s\r\n\r\n", BANNER );
    if ( ! isatty ( fileno ( stdout ))) fprintf ( stdout, "%s\n\n", BANNER );
    if ( ! isatty ( fileno ( stderr ))) fprintf ( stderr, "%s\n\n", BANNER );

    if ( argc == 1 ) {
        printHelp ();
        return -1;
    }

    flags.Tree = false;

    int argIndex = 1;
    do {

        argIndex = parseArgs ( argIndex, argv );
        if ( argIndex < 0 ) break;

        char wadFileName [ 256 ];
        wadList *myList = getInputFiles ( argv [argIndex++], wadFileName );
        if ( myList->IsEmpty ()) break;
        printf ( "Analyzing: %s\n\n", wadFileName );

        char levelNames [MAX_LEVELS+1][MAX_LUMP_NAME];
        argIndex = getLevels ( argIndex, argv, levelNames, myList );

        if ( levelNames [0][0] == '\0' ) {
            fprintf ( stderr, "Unable to find any valid levels in %s\n", wadFileName );
            break;
        }

        if ( ! flags.Tree ) {
            printf ( "          Max   Avg\n" );
            printf ( "         Depth Depth   FOM   Balance    Splits       Diagonals  Nodes  Segs\n" );
        }

        int noLevels = 0;

        do {

            const wadListDirEntry *dir = myList->FindWAD ( levelNames [ noLevels ]);
            DoomLevel *curLevel = new DoomLevel ( levelNames [ noLevels ], dir->wad );
            printf ( "%8.8s:  ", levelNames [ noLevels++ ]);
            AnalyzeBSP ( curLevel );
            printf ( "\n" );
            delete curLevel;

        } while ( levelNames [noLevels][0] );

        printf ( "\n" );

        delete myList;

    } while ( argv [argIndex] );

    return 0;
}
