//----------------------------------------------------------------------------
//
// File:        bspdiff.cpp
// Date:        27-Oct-2000
// Programmer:  Marc Rousseau
//
// Description: Compares two BSP structures and report any differences
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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef _WIN32
	#include <strings.h>
#endif

#if defined ( __OS2__ )
    #define INCL_DOS
    #define INCL_SUB
    #include <conio.h>
    #include <dos.h>
    #include <os2.h>
#elif defined ( __WIN32__ )
    #include <conio.h>
    #include <dos.h>
    #include <windows.h>
    #include <wincon.h>
#elif defined ( __GNUC__ )
#else
    #error This program must be compiled as a 32-bit app.
#endif

#include "common.hpp"
#include "wad.hpp"
#include "level.hpp"
#include "console.hpp"

#define VERSION		"1.0"
#define MAX_LEVELS	50

#define UNSUPPORTED_FEATURE	-1
#define UNRECOGNIZED_PARAMETER	-2

#if defined ( __GNUC__ )

#define stricmp strcasecmp
#define cprintf printf

extern char *strupr ( char *ptr );
extern int getch ();
// extern bool kbhit ();

#endif

int GCD ( int A, int B )
{
    if ( A < 0 ) A = -A; else if ( A == 0 ) return 1;
    if ( B < 0 ) B = -B; else if ( B == 0 ) return 1;

    unsigned twos = 0;
    while ((( A | B ) & 1 ) == 0 ) {
        twos++;
        A >>= 1;
        B >>= 1;
    }

    while (( A & 1 ) == 0 ) A >>= 1; // remove other powers of 2
    while (( B & 1 ) == 0 ) B >>= 1; // remove other powers of 2

    // A and B both odd at this point!
    while ( A != B ) {
        while ( A > B ) {
            A -= B; // subtractracting smaller odd number
            // from larger odd number. ( A now even )
            while (( A & 1 ) == 0 ) A >>= 1;  // remove powers of 2
        }
        while ( B > A ) {
            B -= A; // subtractracting smaller odd number
            // from larger odd number. ( B now even )
            while (( B & 1 ) == 0 ) B >>= 1;  // remove powers of 2
        }
    }

    return ( A << twos ); // reapply original powers of two
}

void printHelp ()
{
    fprintf ( stderr, "Usage: nodediff {-options} filename1[.wad] filename2[.wad] [level{+level}]\n" );
    fprintf ( stderr, "\n" );
    fprintf ( stderr, "     -x+ turn on option   -x- turn off option  %c = default\n", DEFAULT_CHAR );
    fprintf ( stderr, "\n" );
    fprintf ( stderr, "     level - ExMy for DOOM / Heretic\n" );
    fprintf ( stderr, "             MAPxx for DOOM II / HEXEN\n" );
}

int parseArgs ( int index, const char *argv[] )
{
    bool errors = false;
    while ( argv [ index ] ) {

        if ( argv [index][0] != '/' ) break;

        index++;
    }
    if ( errors ) fprintf ( stderr, "\n" );
    return index;
}

int getLevels ( int argIndex, const char *argv[], char names [][MAX_LUMP_NAME], wadList *list )
{
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
            if ( WAD::IsMap ( ptr ))
                if ( list->FindWAD ( ptr ))
                    strcpy ( names [index++], ptr );
                else
                    fprintf ( stderr, "  Could not find %s\n", ptr, errors++ );
            else
                fprintf ( stderr, "  %s is not a valid name for a level\n", ptr, errors++ );
            ptr = strtok ( NULL, "+" );
        }
    } else {
        int size = list->DirSize ();
        const wadListDirEntry *dir = list->GetDir ( 0 );
        for ( int i = 0; i < size; i++ ) {
            if ( dir->wad->IsMap ( dir->entry->name )) {
                if ( index == MAX_LEVELS )
                    fprintf ( stderr, "ERROR: Too many levels in WAD - ignoring %s!\n", dir->entry->name, errors++ );
                else
                    memcpy ( names [index++], dir->entry->name, MAX_LUMP_NAME );
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
    size_t length = strlen ( fileName );
    char *ptr     = strrchr ( fileName, '.' );
    if (( ptr && strchr ( ptr, '\\' )) ||
        ( ! ptr && stricmp ( &fileName[length-4], ext )))
        strcat ( fileName, ext );
}

const char *TypeName ( eWadType type )
{
    switch ( type ) {
        case wt_DOOM    : return "DOOM";
        case wt_DOOM2   : return "DOOM2";
        case wt_HERETIC : return "Heretic";
        case wt_HEXEN   : return "Hexen";
        default         : break;
    }
    return "<Unknown>";
}

wadList *getInputFiles ( const char *cmdLine, char *wadFileName )
{
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
                if ( myList->Type () != wt_UNKNOWN )
                    fprintf ( stderr, "ERROR: %s is not a %s PWAD.\n", wadName, TypeName ( myList->Type ()));
                else
                    fprintf ( stderr, "ERROR: %s is not the same type.\n", wadName );
                delete wad;
            } else {
                char *end = wadName + strlen ( wadName ) - 1;
                while (( end > wadName ) && ( *end != '\\' )) end--;
                if ( *end == '\\' ) end++;
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

template <class T> inline T sgn ( T val ) { return ( val > 0 ) ? 1 : ( val < 0 ) ? -1 : 0; }

void NormalizeNODES ( wNode *node, int noNodes )
{
    for ( int i = 0; i < noNodes; i++ ) {
        int gcd = GCD ( node [i].dx, node [i].dy );
        node [i].dx /= gcd;
        node [i].dy /= gcd;
	if ( node [i].dx == 0 ) node [i].dy = sgn ( node [i].dy );
	if ( node [i].dy == 0 ) node [i].dx = sgn ( node [i].dx );
        if (( node [i].dx < 0 ) || (( node [i].dx == 0 ) && ( node [i].dy < 0 ))) {
            node [i].dx = -node [i].dx;
            node [i].dy = -node [i].dy;
            swap ( node [i].side [0], node [i].side [1] );
            swap ( node [i].child [0], node [i].child [1] );
        }
    }
}

/*
static int SortSegs ( const void *ptr1, const void *ptr2 )
{
    int dif = (( wSegs * ) ptr1)->lineDef - (( wSegs * ) ptr2)->lineDef;
    if ( dif ) return dif;

    return (( wSegs * ) ptr1)->flip - (( wSegs * ) ptr2)->flip ?
           (( wSegs * ) ptr1)->flip - (( wSegs * ) ptr2)->flip :
           (( wSegs * ) ptr1)->offset - (( wSegs * ) ptr2)->offset;
}
*/

bool LinesMatch ( const wNode &node1, const wNode &node2 )
{
    if (( node1.dx != node2.dx ) || ( node1.dy != node2.dy )) return false;

    if ( node1.dx == 0 ) return ( node1.x == node2.x ) ? true : false;
    if ( node1.dy == 0 ) return ( node1.y == node2.y ) ? true : false;
    
    double tx = ( double ) ( node2.x - node1.x ) / ( double ) node1.dx;
    double ty = ( double ) ( node2.y - node1.y ) / ( double ) node1.dy;

    double delta = fabs ( tx - ty );
    
    if ( delta < 0.001 ) return true;
    
    if ( delta < 1.000 ) printf ( "tx = %g  ty = %g\n", tx, ty );

    return false;
}

char *locationString;

void printNode ( const wNode &node, int index )
{
    printf ( "\n%5d - (%5d,%5d) (%5d,%5d) L: %c %5d R: %c %5d",
             index, node.x, node.y, node.dx, node.dy,
             ( node.child [0] & 0x8000 ) ? 'S' : 'N', node.child [0] & 0x7FFF, ( node.child [1] & 0x8000 ) ? 'S' : 'N', node.child [1] & 0x7FFF );
}

static DoomLevel *srcLevel;
static DoomLevel *tgtLevel;

int CompareSSECTOR ( int srcIndex, int tgtIndex )
{
    srcIndex &= 0x7FFF;
    tgtIndex &= 0x7FFF;

//        qsort ( segs, noSegs, sizeof ( SEG ), SortSegs );

    return 0;
}

int CompareNODE ( int srcIndex, int tgtIndex, char *location )
{
    int length = location - locationString;

    if (( srcIndex & 0x8000 ) != ( tgtIndex & 0x8000 )) {
        printf ( "\n%*.*s: Leaf != Node", length, length, locationString );
        return 1;
    }

    if ( srcIndex & 0x8000 ) {
        return CompareSSECTOR ( srcIndex, tgtIndex );
    }
    
    const wNode &src = srcLevel->GetNodes () [srcIndex];
    const wNode &tgt = tgtLevel->GetNodes () [tgtIndex];

    if ( LinesMatch ( src, tgt ) == false ) {
        int length = location - locationString;
        printf ( "\n%*.*s:", length, length, locationString );
        printNode ( src, srcIndex );
        printNode ( tgt, tgtIndex );
        return 1;
    }
    
    int count = 0;

    *location = 'R';
    count += CompareNODE ( src.child [0], tgt.child [0], location + 1 );

    *location = 'L';
    count += CompareNODE ( src.child [1], tgt.child [1], location + 1 );

    return count;
}

int ProcessLevel ( char *name, wadList *myList1, wadList *myList2 )
{
    cprintf ( "\r  %-*.*s: ", MAX_LUMP_NAME, MAX_LUMP_NAME, name );
    GetXY ( &startX, &startY );

    int mismatches = 0;

    srcLevel = NULL;
    tgtLevel = NULL;

    const wadListDirEntry *dir = myList1->FindWAD ( name );
    srcLevel = new DoomLevel ( name, dir->wad );
    if ( srcLevel->IsValid ( true ) == false ) {
        Status ( (char*) "This level is not valid... " );
        mismatches = -1;
        goto done;
    }

    dir = myList2->FindWAD ( name );
    tgtLevel = new DoomLevel ( name, dir->wad );
    if ( tgtLevel->IsValid ( true ) == false ) {
        Status ( (char*) "This level is not valid... " );
        mismatches = -1;
        goto done;
    }

    {
        NormalizeNODES (( wNode * ) srcLevel->GetNodes (), srcLevel->NodeCount ());
        NormalizeNODES (( wNode * ) tgtLevel->GetNodes (), tgtLevel->NodeCount ());

        int noNodes = max ( srcLevel->NodeCount (), tgtLevel->NodeCount ());

        locationString = new char [ noNodes ];

        mismatches = CompareNODE ( srcLevel->NodeCount () - 1, tgtLevel->NodeCount () - 1, locationString );

        delete [] locationString;
    
        if ( mismatches == 0 ) Status ( (char*) "NODES Match" );
    }

done:

    cprintf ( "\r\n" );

    delete tgtLevel;
    delete srcLevel;

    return mismatches;
}

int main ( int argc, const char *argv[] )
{
    fprintf ( stderr, "Compare Version %s (c) 2003-2004 Marc Rousseau\n\n", VERSION );

    if ( argc == 1 ) {
        printHelp ();
        return -1;
    }

    SaveConsoleSettings ();

    int argIndex = 1, changes = 0;

    while ( KeyPressed ()) GetKey ();

    do {

        argIndex = parseArgs ( argIndex, argv );
        if ( argIndex < 0 ) break;

        char wadFileName1 [ 256 ];
        wadList *myList1 = getInputFiles ( argv [argIndex++], wadFileName1 );
        if ( myList1->IsEmpty ()) { changes = -1000;  break; }

        char wadFileName2 [ 256 ];
        wadList *myList2 = getInputFiles ( argv [argIndex++], wadFileName2 );
        if ( myList2->IsEmpty ()) { changes = -1000;  break; }

        cprintf ( "Comparing: %s and %s\r\n\n", wadFileName1, wadFileName2 );

        char levelNames [MAX_LEVELS+1][MAX_LUMP_NAME];
        argIndex = getLevels ( argIndex, argv, levelNames, myList1 );

        if ( levelNames [0][0] == '\0' ) {
            fprintf ( stderr, "Unable to find any valid levels in %s\n", wadFileName1 );
            break;
        }

        int noLevels = 0;

        do {

            changes += ProcessLevel ( levelNames [noLevels++], myList1, myList2 );
            if ( KeyPressed () && ( GetKey () == 0x1B )) break;

        } while ( levelNames [noLevels][0] );

        cprintf ( "\r\n" );

        delete myList1;
        delete myList2;

    } while ( argv [argIndex] );

    RestoreConsoleSettings ();

    return changes;
}
