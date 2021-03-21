//----------------------------------------------------------------------------
//
// File:        ZenReject.cpp
// Date:        15-Dec-1995
// Programmer:  Marc Rousseau
//
// Description: This module contains the logic for the REJECT builder.
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
//   06-12-99	Reordered functions & removed all function prototypes
//   06-14-99	Modified DrawBlockMapLine to elminate floating point & inlined calls to UpdateRow
//   07-19-99	Added code to track child sectors and active lines (36% faster!)
//   04-01-01	Added code to use graphs to reduce LOS calculations (way faster!)
//   12-02-02   Updated graph code to do a more thorough job (subsumes older child code)
//   01-18-04   Added support for RMB options
//
//----------------------------------------------------------------------------

#include <limits.h>
#include <math.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "common.hpp"
#include "logger.hpp"
#include "level.hpp"
#include "zennode.hpp"
#include "blockmap.hpp"
#include "console.hpp"
#include "geometry.hpp"

DBG_REGISTER ( __FILE__ );

// ----- Local enum/structure definitions -----

const UINT8 VIS_UNKNOWN     = 0x00;
const UINT8 VIS_VISIBLE     = 0x01;     // No actual LOS exists
const UINT8 VIS_HIDDEN      = 0x02;     // At least 1 valid LOS found
const UINT8 VIS_RMB_VISIBLE = 0x04;     // Special - ignores VIS_RMB_HIDDEN
const UINT8 VIS_RMB_HIDDEN  = 0x08;     // Special - force sector to be hidden
const UINT8 VIS_RMB_MASK    = 0x0C;     // Special - RMB option present

inline bool IsHidden ( UINT8 vis )     { return ( ! ( vis & VIS_VISIBLE ) | (( vis & VIS_RMB_MASK ) == VIS_RMB_HIDDEN )) ? true : false; }

struct sMapLine {
    int            index;
    const sPoint  *start;
    const sPoint  *end;
};

struct sSolidLine : sMapLine {
    bool           ignore;
};

struct sTransLine : sMapLine {
    int            leftSector;
    int            rightSector;
    long           DY, DX, H;
    REAL           lo, hi;
    sPoint        *loPoint;
    sPoint        *hiPoint;
};

struct sPolyLine {
    int            noPoints;
    int            lastPoint;
    const sPoint **point;
};

struct sLineSet {
    sSolidLine   **lines;
    int            loIndex;
    int            hiIndex;
};

struct sWorldInfo {
    sTransLine    *src;
    sTransLine    *tgt;
    sLineSet       solidSet;
    sPolyLine      upperPoly;
    sPolyLine      lowerPoly;
};

struct sBlockMapBounds {
    int            lo;
    int            hi;
};

struct sBlockMapArrayEntry {
    bool          *available;
    sSolidLine    *line;
};

struct sGraph;

struct sSector {
    int            index;
    int            noLines;
    sTransLine   **line;
    int            noNeighbors;
    sSector      **neighbor;

    int            metric;
    sGraph        *baseGraph;

    sGraph        *graph;
    sSector       *graphParent;
    bool           isArticulation;
    int            indexDFS;
    int            loDFS;
    int            hiDFS;
};

struct sGraph {
    int            noSectors;
    sSector      **sector;
};

struct sGraphTable {
    int            noGraphs;
    sGraph        *graph;
    sSector      **sectorStart;
    sSector      **sectorPool;
};

struct sSectorRMB {
    int            Safe;
    int            SafeLo;
    int            SafeHi;
    int            Blind;
    int            BlindLo;
    int            BlindHi;
};

static sGraphTable    graphTable;

static int            loRow;
static int            hiRow;

static sBlockMap             *blockMap;
static sBlockMapBounds       *blockMapBounds;
static sBlockMapArrayEntry ***blockMapArray;

static UINT8        **rejectTable;

static UINT8         *lineVisTable;

static sPoint        *vertices;
static int            noSolidLines;
static sSolidLine    *solidLines;
// static int            noTransLines;
static uint64_t		noTransLines;
static sTransLine    *transLines;

static sTransLine   **sectorLines;
static sSector      **neighborList;

static int            checkLineSize;
static bool          *checkLine;
static bool          *lineProcessed;
static sSolidLine   **indexToSolid;
static sSolidLine   **testLines;
static const sPoint **polyPoints;

static int            maxMapDistance;

static long    X, Y, DX, DY;

bool FeaturesDetected ( DoomLevel *level )
{
    FUNCTION_ENTRY ( NULL, "FeaturesDetected", true );

    char *ptr = ( char * ) level->GetReject ();
    if ( ptr == NULL ) return false;

    int noSectors = level->SectorCount ();

    // Make sure it's a valid REJECT structure before analyzing it
    int rejectSize = (( noSectors * noSectors ) + 7 ) / 8;
    if ( level->RejectSize () != rejectSize ) return false;

    int bits = 9;
    int data = *ptr++;
    bool **table = new bool * [ noSectors ];
    for ( int i = 0; i < noSectors; i++ ) {
        table [i] = new bool [ noSectors ];
        for ( int j = 0; j < noSectors; j++ ) {
            if ( --bits == 0 ) {
                bits = 8;
                data = *ptr++;
            }
            table [i][j] = data & 1;
            data >>= 1;
        }
    }

    bool featureDetected = false;

    // Look for "special" features
    for ( int i = 0; i < noSectors; i++ ) {
        // Make sure each sector can see itself
        if ( table [i][i] != 0 ) {
            featureDetected = true;
            goto done;
        }
        for ( int j = i + 1; j < noSectors; j++ ) {
            // Make sure that if I can see J, then J can see I
            if ( table [i][j] != table [j][i] ) {
                featureDetected = true;
                goto done;
            }
        }
    }

done:

    for ( int i = 0; i < noSectors; i++ ) {
        delete [] table [i];
    }
    delete [] table;

    return featureDetected;
}

//
// Run through our rejectTable to create the actual REJECT resource
//
UINT8 *GetREJECT ( DoomLevel *level, bool empty )
{
    FUNCTION_ENTRY ( NULL, "GetREJECT", true );

    int noSectors  = level->SectorCount ();
    int rejectSize = (( noSectors * noSectors ) + 7 ) / 8;

    UINT8 *reject = new UINT8 [ rejectSize ];
    memset ( reject, 0, rejectSize );

    if ( empty == false ) {
        // The rejectTable's data is sequential, making it easy to unroll the loop
        UINT8 *ptr = rejectTable [0];
        for ( int i = 0, index = 0; i < rejectSize; i++ ) {
            int bits = 0;
            if ( IsHidden ( *ptr++ )) bits |= 0x01;
            if ( IsHidden ( *ptr++ )) bits |= 0x02;
            if ( IsHidden ( *ptr++ )) bits |= 0x04;
            if ( IsHidden ( *ptr++ )) bits |= 0x08;
            if ( IsHidden ( *ptr++ )) bits |= 0x10;
            if ( IsHidden ( *ptr++ )) bits |= 0x20;
            if ( IsHidden ( *ptr++ )) bits |= 0x40;
            if ( IsHidden ( *ptr++ )) bits |= 0x80;
            reject [ index++ ] = ( UINT8 ) bits;
        }
    }

    return reject;
}

void ProgressBar(char *, double, int, int);

void UpdateProgress ( int stage, double percent )
{
    FUNCTION_ENTRY ( NULL, "UpdateProgress", false );

    char buffer [32];
/*
    sprintf ( buffer, ( stage == 1 ) ? "REJECT - Pruning sectors %0.1f%%" :
                      ( stage == 2 ) ? "REJECT - Analyzing lines %0.1f%%" : "REJECT - ??? %0.1f%%", percent );
    Status ( buffer );
*/

	double progress = percent / 100.0;

	if (stage == 1) {
		ProgressBar((char *) "Reject - Pruning sectors ", progress, 35, 0);
	} else if (stage == 2) {
		ProgressBar((char *) "Reject - Analyzing lines ", progress, 35, 0);
	} else {
		ProgressBar((char *) "Reject - Other ", progress, 45, 0);
	}

}

void MarkVisibility ( int sector1, int sector2, UINT8 visibility )
{
    FUNCTION_ENTRY ( NULL, "MarkVisibility", false );

    if ( rejectTable [ sector1 ][ sector2 ] == VIS_UNKNOWN ) {
        rejectTable [ sector1 ][ sector2 ] = visibility;
    }
    if ( rejectTable [ sector2 ][ sector1 ] == VIS_UNKNOWN ) {
        rejectTable [ sector2 ][ sector1 ] = visibility;
    }
}

void CopyVertices ( DoomLevel *level )
{
    FUNCTION_ENTRY ( NULL, "CopyVertices", true );

    int noVertices = level->VertexCount ();
    vertices = new sPoint [ noVertices ];
    const wVertex *vertex = level->GetVertices ();

    for ( int i = 0; i < noVertices; i++ ) {
        vertices [i].x = vertex [i].x;
        vertices [i].y = vertex [i].y;
    }
}

//
// Create lists of all the solid and see-thru lines in the map
//
bool SetupLines ( DoomLevel *level )
{
    FUNCTION_ENTRY ( NULL, "SetupLines", true );

    int noLineDefs = level->LineDefCount ();

    const wLineDefInternal *lineDef = level->GetLineDefs ();
    const wSideDef *sideDef = level->GetSideDefs ();

    checkLineSize = sizeof ( bool ) * noLineDefs;
    checkLine     = new bool [ noLineDefs ];
    lineProcessed = new bool [ noLineDefs ];

    indexToSolid = new sSolidLine * [ noLineDefs ];
    memset ( indexToSolid, 0, sizeof ( sSolidLine * ) * noLineDefs );

    noSolidLines = 0;
    noTransLines = 0;
    solidLines   = new sSolidLine [ noLineDefs ];
    transLines   = new sTransLine [ noLineDefs ];

    for ( int i = 0; i < noLineDefs; i++ ) {

        sMapLine *line;
        const sPoint *vertS = &vertices [ lineDef [i].start ];
        const sPoint *vertE = &vertices [ lineDef [i].end ];

        // We can't handle 0 length lineDefs!
        if ( vertS == vertE ) continue;

        if ( lineDef [i].flags & LDF_TWO_SIDED ) {

            int rSide = lineDef [i].sideDef [ RIGHT_SIDEDEF ];
            int lSide = lineDef [i].sideDef [ LEFT_SIDEDEF ];
            if (( lSide == NO_SIDEDEF ) || ( rSide == NO_SIDEDEF )) continue;
            if ( sideDef [ lSide ].sector == sideDef [ rSide ].sector ) continue;
            sTransLine *stLine = &transLines [ noTransLines++ ];
            line = ( sMapLine * ) stLine;
            stLine->leftSector  = sideDef [ lSide ].sector;
            stLine->rightSector = sideDef [ rSide ].sector;
            stLine->DX = vertE->x - vertS->x;
            stLine->DY = vertE->y - vertS->y;
            stLine->H  = ( stLine->DX * stLine->DX ) + ( stLine->DY * stLine->DY );

        } else {

            indexToSolid [i] = &solidLines [ noSolidLines++ ];
            line = ( sMapLine * ) indexToSolid [i];

        }

        line->index = i;
        line->start = vertS;
        line->end   = vertE;
    }

    // int lineVisSize = ( noTransLines - 1 ) * noTransLines / 2;
    uint64_t lineVisSize = ( noTransLines - 1 ) * noTransLines / 2;
    lineVisTable = new UINT8 [ lineVisSize ];
    memset ( lineVisTable, 0, sizeof ( UINT8 ) * lineVisSize );

    return ( noTransLines > 0 ) ? true : false;
}

//
// Mark sectors sec1 & sec2 as neighbors of each other
//
void MakeNeighbors ( sSector *sec1, sSector *sec2 )
{
    FUNCTION_ENTRY ( NULL, "MakeNeighbors", false );

    for ( int i = 0; i < sec1->noNeighbors; i++ ) {
        if ( sec1->neighbor [i] == sec2 ) return;
    }

    sec1->neighbor [ sec1->noNeighbors++ ] = sec2;
    sec2->neighbor [ sec2->noNeighbors++ ] = sec1;
}

//
// Create the sector table that records all the see-thru lines related to a
//   sector and all of it's neighboring and child sectors.
//
sSector *CreateSectorInfo ( DoomLevel *level )
{
    FUNCTION_ENTRY ( NULL, "CreateSectorInfo", true );

    Status ( (char *) "Gathering sector information..." );

    int noSectors = level->SectorCount ();

    sSector *sector = new sSector [ noSectors ];
    memset ( sector, 0, sizeof ( sSector ) * noSectors );

    // Count the number of lines for each sector first
    for ( int i = 0; i < noTransLines; i++ ) {
        sTransLine *line = &transLines [ i ];
        sector [ line->leftSector ].noLines++;
        sector [ line->rightSector ].noLines++;
    }

    // Set up the line & neighbor array for each sector
    sTransLine **lines = sectorLines = new sTransLine * [ noTransLines * 2 ];
    sSector **neighbors = neighborList = new sSector * [ noTransLines * 2 ];
    for ( int i = 0; i < noSectors; i++ ) {
        sector [i].index     = i;
        sector [i].line      = lines;
        sector [i].neighbor  = neighbors;
        lines     += sector [i].noLines;
        neighbors += sector [i].noLines;
        sector [i].noLines   = 0;
    }

    // Fill in line information & mark off neighbors
    for ( int i = 0; i < noTransLines; i++ ) {
        sTransLine *line = &transLines [ i ];
        sSector *sec1 = &sector [ line->leftSector ];
        sSector *sec2 = &sector [ line->rightSector ];
        sec1->line [ sec1->noLines++ ] = line;
        sec2->line [ sec2->noLines++ ] = line;
        MakeNeighbors ( sec1, sec2 );
    }

    return sector;
}

int **CreateDistanceTable ( sSector *sector, int noSectors )
{
    FUNCTION_ENTRY ( NULL, "CreateDistanceTable", true );

    Status ( (char *) "Calculating sector distances..." );

    char *distBuffer    = new char [ sizeof ( int ) * noSectors * noSectors + sizeof ( int * ) * noSectors ];
    int **distanceTable = ( int ** ) distBuffer;

    distBuffer += sizeof ( int * ) * noSectors;

    int listRowSize = noSectors + 2;

    UINT16 *listBuffer = new UINT16 [ listRowSize * noSectors * 2 ];
    memset ( listBuffer, 0, sizeof ( UINT16 ) * listRowSize * noSectors * 2 );

    UINT16 *list [2] = { listBuffer, listBuffer + listRowSize * noSectors };

    for ( int i = 0; i < noSectors; i++ ) {
        distanceTable [i] = ( int * ) distBuffer;
        distBuffer += sizeof ( int ) * noSectors;
        // Set up the initial distances
        for ( int j = 0; j < noSectors; j++ ) {
            distanceTable [i][j] = INT_MAX;
        }
        // Prime the first list
        list [0][i*listRowSize+0]   = ( UINT16 ) i;
        list [0][i*listRowSize+1]   = ( UINT16 ) i;
        list [0][i*listRowSize+2+i] = true;
    }

    int currIndex = 0, length = 0;
    int loRow = 0, hiRow = noSectors - 1;

    int count;

    // Find the # of sectors between each pair of sectors
    do {
        count = 0;

        int nextIndex = ( currIndex + 1 ) % 2;
        UINT16 *currList = list [currIndex] + 2 + loRow * listRowSize;
        UINT16 *nextList = list [nextIndex] + 2 + loRow * listRowSize;
        currIndex = nextIndex;

        int i = loRow, max = hiRow;
        loRow = noSectors;
        hiRow = 0;

        for ( ; i <= max; i++ ) {
            int loIndex = currList [-2];
            int hiIndex = currList [-1];
            int minIndex = noSectors, maxIndex = 0;
            // See if this row needs to be processed
            if ( loIndex <= hiIndex ) {
                int startCount = count;
                for ( int j = loIndex; j <= hiIndex; j++ ) {
                    if ( currList [j] == false ) continue;
                    if ( length < distanceTable [i][j] ) {
                        distanceTable [i][j] = length;
                        for ( int x = 0; x < sector [j].noNeighbors; x++ ) {
                            int index = sector [j].neighbor [x] - sector;
                            nextList [index] = true;
                            if ( index < minIndex ) minIndex = index;
                            if ( index > maxIndex ) maxIndex = index;
                        }
                        count++;
                    }
                    currList [j] = false;
                }
                // Should we process this row next time around?
                if ( startCount != count ) {
                    if ( i < loRow ) loRow = i;
                    if ( i > hiRow ) hiRow = i;
                }
            }
            nextList [-2] = ( UINT16 ) minIndex;
            nextList [-1] = ( UINT16 ) maxIndex;
            currList += listRowSize;
            nextList += listRowSize;
        }
        length++;
    } while ( count );

    // Now mark all sectors with no path to each other as hidden
    for ( int i = 0; i < noSectors; i++ ) {
        for ( int j = i + 1; j < noSectors; j++ ) {
            if ( distanceTable [i][j] > length ) {
                MarkVisibility ( i, j, VIS_HIDDEN );
            }
        }
    }

    delete [] listBuffer;

    return distanceTable;
}

int DFS ( sGraph *graph, sSector *sector )
{
    FUNCTION_ENTRY ( NULL, "DFS", false );

    // Initialize the sector
    sector->graph          = graph;
    sector->indexDFS       = graph->noSectors;
    sector->loDFS          = graph->noSectors;
    sector->isArticulation = false;

    // Add this sector to the graph
    graph->sector [graph->noSectors++] = sector;

    int noChildren = 0;

    for ( int i = 0; i < sector->noNeighbors; i++ ) {
        sSector *child = sector->neighbor [i];
        if ( child->graph != graph ) {
            noChildren++;
            child->graphParent = sector;
            DFS ( graph, child );
            if ( child->loDFS < sector->loDFS ) {
                sector->loDFS = child->loDFS;
            }
            if ( child->loDFS >= sector->indexDFS ) {
                sector->isArticulation = true;
            }
        } else if ( child != sector->graphParent ) {
            if ( child->indexDFS < sector->loDFS ) {
                sector->loDFS = child->indexDFS;
            }
        }
    }

    sector->hiDFS = graph->noSectors - 1;

    return noChildren;
}

sGraph *CreateGraph ( sSector *root )
{
    FUNCTION_ENTRY ( NULL, "CreateGraph", true );

    sGraph *graph = &graphTable.graph [ graphTable.noGraphs++ ];

    graph->sector    = graphTable.sectorStart;
    graph->noSectors = 0;

    root->graphParent    = NULL;
    root->isArticulation = ( DFS ( graph, root ) > 1 ) ? true : false;

    graphTable.sectorStart += graph->noSectors;

    return graph;
}

void HideComponents ( sGraph *oldGraph, sGraph *newGraph )
{
    FUNCTION_ENTRY ( NULL, "HideComponents", true );

    for ( int i = 0; i < oldGraph->noSectors; i++ ) {
        sSector *sec1 = oldGraph->sector [i];
        if ( sec1->graph == oldGraph ) {
            for ( int j = 0; j < newGraph->noSectors; j++ ) {
                sSector *sec2 = newGraph->sector [j];
                MarkVisibility ( sec1->index, sec2->index, VIS_HIDDEN );
            }
        }
    }
}

void SplitGraph ( sGraph *oldGraph )
{
    FUNCTION_ENTRY ( NULL, "SplitGraph", true );

    int remainingSectors = oldGraph->noSectors - 1;

    for ( int i = 0; i < oldGraph->noSectors; i++ ) {
        sSector *sec = oldGraph->sector [i];
        if ( sec->graph == oldGraph ) {
            sGraph *newGraph = CreateGraph ( sec );
            if ( newGraph->noSectors < remainingSectors ) {
                HideComponents ( oldGraph, newGraph );
            }
            remainingSectors -= newGraph->noSectors - 1;
        }
    }
}

void InitializeGraphs ( sSector *sector, int noSectors )
{
    FUNCTION_ENTRY ( NULL, "InitializeGraphs", true );

    Status ( (char *) "Creating sector graphs..." );

    graphTable.noGraphs    = 0;
    graphTable.graph       = new sGraph [ noSectors * 2 ];
    graphTable.sectorPool  = new sSector * [ noSectors * 4 ];
    graphTable.sectorStart = graphTable.sectorPool;

    memset ( graphTable.graph, 0, sizeof ( sGraph ) * noSectors * 2 );
    memset ( graphTable.sectorPool, 0, sizeof ( sSector * ) * noSectors * 4 );

    // Create the initial graph
    sGraph *graph    = &graphTable.graph [0];
    graph->noSectors = noSectors;
    graph->sector    = graphTable.sectorStart;
    graphTable.sectorStart += noSectors;
    graphTable.noGraphs++;

    // Put all sectors in the initial graph
    for ( int i = 0; i < noSectors; i++ ) {
        sector [i].graph  = graph;
        graph->sector [i] = &sector [i];
    }

    // Separate the individual graphs
    SplitGraph ( graph );

    // Keep a permanent copy of the initial graph
    for ( int i = 0; i < noSectors; i++ ) {
        sector [i].baseGraph = sector [i].graph;
    }

    // Calculate the sector metrics
    for ( int i = 1; i < graphTable.noGraphs; i++ ) {
        sGraph *graph = &graphTable.graph [i];
        for ( int j = 0; j < graph->noSectors; j++ ) {
            sSector *sec = graph->sector [j];
            int sum = 0, left = graph->noSectors - 1;
            for ( int x = 0; x < sec->noNeighbors; x++ ) {
                sSector *child = sec->neighbor [x];
                if ( child->graphParent != sec ) continue;
                if ( child->loDFS >= sec->indexDFS ) {
                    int num = child->hiDFS - child->indexDFS + 1;
                    left -= num;
                    sum  += num * left;
                }
            }
            sec->metric = sum;
        }
    }
}

void HideSectorFromComponents ( sSector *key, sSector *root, sSector *sec )
{
    FUNCTION_ENTRY ( NULL, "HideSectorFromComponents", false );

    sGraph *graph = sec->graph;

    // Hide sec from all other sectors in its graph that are in different bi-connected components
    for ( int i = 0; i < root->indexDFS; i++ ) {
        MarkVisibility ( sec->index, graph->sector [i]->index, VIS_HIDDEN );
    }
    for ( int i = root->hiDFS + 1; i < graph->noSectors; i++ ) {
        MarkVisibility ( sec->index, graph->sector [i]->index, VIS_HIDDEN );
    }
}

void AddGraph ( sGraph *graph, sSector *sector )
{
    FUNCTION_ENTRY ( NULL, "AddGraph", false );

    // Initialize the sector
    sector->graph    = graph;
    sector->indexDFS = graph->noSectors;
    sector->loDFS    = graph->noSectors;

    // Add this sector to the graph
    graph->sector [graph->noSectors++] = sector;

    // Add all this nodes children that aren't already in the graph
    for ( int i = 0; i < sector->noNeighbors; i++ ) {
        sSector *child = sector->neighbor [i];
        if ( child->graph == sector->baseGraph ) {
            child->graphParent = sector;
            AddGraph ( graph, child );
            if ( child->loDFS < sector->loDFS ) {
                sector->loDFS = child->loDFS;
            }
        } else if ( child != sector->graphParent ) {
            if ( child->indexDFS < sector->loDFS ) {
                sector->loDFS = child->indexDFS;
            }
        }
    }

    sector->hiDFS = graph->noSectors - 1;
}

sGraph *QuickGraph ( sSector *root )
{
    FUNCTION_ENTRY ( NULL, "QuickGraph", true );

    sGraph *oldGraph = root->baseGraph;
    for ( int i = 0; i < oldGraph->noSectors; i++ ) {
        oldGraph->sector [i]->graph = oldGraph;
    }

    sGraph *graph = &graphTable.graph [ graphTable.noGraphs ];

    graph->sector     = graphTable.sectorStart;
    graph->noSectors  = 0;

    root->graphParent = NULL;

    AddGraph ( graph, root );

    return graph;
}

void EliminateTrivialCases ( sSector *sector, int noSectors )
{
    FUNCTION_ENTRY ( NULL, "EliminateTrivialCases", true );

    // Each sector can see itself
    for ( int i = 0; i < noSectors; i++ ) {
        rejectTable [i][i] = VIS_VISIBLE;
    }

    // Mark all sectors with no see-thru lines as hidden
    for ( int i = 0; i < noSectors; i++ ) {
        if ( sector [i].noLines == 0 ) {
            for ( int j = 0; j < noSectors; j++ ) {
                MarkVisibility ( i, j, VIS_HIDDEN );
            }
        }
    }

    // Each sector can see it's immediate neighbor(s)
    for ( int i = 0; i < noSectors; i++ ) {
        sSector *sec = &sector [i];
        for ( int j = 0; j < sec->noNeighbors; j++ ) {
            sSector *neighbor = sec->neighbor [j];
            if ( neighbor->index > sec->index ) {
                MarkVisibility ( sec->index, neighbor->index, VIS_VISIBLE );
            }
        }
    }
}

void PrepareREJECT ( int noSectors )
{
    FUNCTION_ENTRY ( NULL, "PrepareREJECT", true );

    // Allocate the whole table in 1 whole chunk (with 7 extra bytes to simplify GetREJECT)
    int tableSize = noSectors * ( sizeof ( char * ) + noSectors ) + 7;
    rejectTable = ( UINT8 ** ) malloc ( tableSize );
    memset ( rejectTable, 0, tableSize );

    UINT8 *ptr = ( UINT8 * ) ( rejectTable + noSectors );
    for ( int i = 0; i < noSectors; i++ ) {
        rejectTable [i] = ptr;
        ptr += noSectors;
    }

    // This is purely cosmetic - keep the unused bits in the last byte clear
    ptr [0] = VIS_VISIBLE;
    ptr [1] = VIS_VISIBLE;
    ptr [2] = VIS_VISIBLE;
    ptr [3] = VIS_VISIBLE;
    ptr [4] = VIS_VISIBLE;
    ptr [5] = VIS_VISIBLE;
    ptr [6] = VIS_VISIBLE;
}

void CleanUpREJECT ( int noSectors )
{
    FUNCTION_ENTRY ( NULL, "CleanUpREJECT", true );

    free ( rejectTable );
}

//
// Create a local BLOCKMAP that only contains entries for solid lines
//
void PrepareBLOCKMAP ( DoomLevel *level, const sBlockMapOptions &options )
{
    FUNCTION_ENTRY ( NULL, "PrepareBLOCKMAP", true );


	// Stuff that works for all blockmaps, no matter what offset.
	// populate it with data

    	blockMap = GenerateBLOCKMAP ( level, 8, 8, options);

	// delete [] extraData->lineDefsUsed;
	// delete extraData;

    blockMapArray  = new sBlockMapArrayEntry ** [ blockMap->noRows ];
    blockMapBounds = new sBlockMapBounds [ blockMap->noRows ];
    for ( int index = 0, row = 0; row < blockMap->noRows; row++ ) {
        blockMapArray [ row ]     = new sBlockMapArrayEntry * [ blockMap->noColumns ];
        blockMapBounds [ row ].lo = blockMap->noColumns;
        blockMapBounds [ row ].hi = -1;
        for ( int col = 0; col < blockMap->noColumns; col++ ) {
            sBlockMapArrayEntry *newPtr = NULL;
            sBlockList *blockList = &blockMap->data [index++];
            if ( blockList->count > 0 ) {
                int j = 0;
                newPtr = new sBlockMapArrayEntry [blockList->count+1];
                for ( int i = 0; i < blockList->count; i++ ) {
                    int line = blockList->line [i];
                    if ( indexToSolid [ line ] != NULL ) {
                        newPtr [j].available = &checkLine [ line ];
                        newPtr [j].line      = indexToSolid [ line ];
                        j++;
                    }
                }
                if ( j == 0 ) {
                    delete [] newPtr;
                    newPtr = NULL;
                } else {
                    newPtr [j].available = NULL;
                }
            }
            blockMapArray [ row ][ col ] = newPtr;
        }
    }

    int totalSize = blockMap->noColumns * blockMap->noRows;

    for ( int i = 0; i < totalSize; i++ ) {
        if ( blockMap->data [i].line ) free ( blockMap->data [i].line );
    }

    delete [] blockMap->data;
}

void CleanUpBLOCKMAP ()
{
    FUNCTION_ENTRY ( NULL, "CleanUpBLOCKMAP", true );

    delete [] blockMapBounds;
    for ( int row = 0; row < blockMap->noRows; row++ ) {
        for ( int col = 0; col < blockMap->noColumns; col++ ) {
            if ( blockMapArray [ row ][ col ] ) delete [] blockMapArray [ row ][ col ];
        }
        delete [] blockMapArray [ row ];
    }
    delete [] blockMapArray;
    delete blockMap;
}

//
// Adjust the two line so that:
//   1) If one line bisects the other:
//      a) The bisecting line is tgt
//      b) The point farthest from src is made both start & end
//   2) tgt is on the left side of src
//   3) src and tgt go in 'opposite' directions
//
bool AdjustLinePair ( sTransLine *src, sTransLine *tgt, bool *bisects )
{
    FUNCTION_ENTRY ( NULL, "AdjustLinePair", true );

    // Rotate & Translate so that src lies along the +X asix
    long y1 = src->DX * ( tgt->start->y - src->start->y ) - src->DY * ( tgt->start->x - src->start->x );
    long y2 = src->DX * (  tgt->end->y  - src->start->y ) - src->DY * (  tgt->end->x  - src->start->x );

    // The two lines are co-linear and should be ignored
    if (( y1 == 0 ) && ( y2 == 0 )) return false;

    // Make sure that src doesn't bi-sect tgt
    if ((( y1 > 0 ) && ( y2 < 0 )) || (( y1 < 0 ) && ( y2 > 0 ))) {
        // Swap src & tgt then recalculate the endpoints
        swap ( *src, *tgt );
        y1 = src->DX * ( tgt->start->y - src->start->y ) - src->DY * ( tgt->start->x - src->start->x );
        y2 = src->DX * (  tgt->end->y  - src->start->y ) - src->DY * (  tgt->end->x  - src->start->x );
        // See if these two lines actually intersect
        if ((( y1 > 0 ) && ( y2 < 0 )) || (( y1 < 0 ) && ( y2 > 0 ))) {
            fprintf ( stderr, "ERROR: Two lines (%d & %d) intersect\n", src->index, tgt->index );
            return false;
        }
    }

    // Make sure that tgt will end up on the correct (left) side
    if (( y1 <= 0 ) && ( y2 <= 0 )) {
        // Flip src
        swap ( src->start, src->end );
        // Adjust values y1 and y2 end reflect new src
        src->DX = -src->DX;
        src->DY = -src->DY;
        y1 = -y1;
        y2 = -y2;
    }

    // See if the lines are parallel
    if ( y2 == y1 ) {
        long x1 = src->DX * ( tgt->start->x - src->start->x ) + src->DY * ( tgt->start->y - src->start->y );
        long x2 = src->DX * (  tgt->end->x  - src->start->x ) + src->DY * (  tgt->end->y  - src->start->y );
        if ( x1 < x2 ) { swap ( tgt->start, tgt->end ); tgt->DX = -tgt->DX; tgt->DY = -tgt->DY; }
        return true;
    }

    // Now look at src from tgt's point of view
    long x1 = tgt->DX * ( src->start->y - tgt->start->y ) - tgt->DY * ( src->start->x - tgt->start->x );
    long x2 = tgt->DX * (  src->end->y  - tgt->start->y ) - tgt->DY * (  src->end->x  - tgt->start->x );

    // See if a line along tgt intersects src
    if ((( x1 < 0 ) && ( x2 > 0 )) || (( x1 > 0 ) && ( x2 < 0 ))) {
        *bisects = true;
        // Make sure tgt points away from src
        if ( y1 > y2 ) {
            swap ( tgt->start, tgt->end ); tgt->DX = -tgt->DX; tgt->DY = -tgt->DY;
        }
    } else if (( x1 <= 0 ) && ( x2 <= 0 )) {
        swap ( tgt->start, tgt->end ); tgt->DX = -tgt->DX; tgt->DY = -tgt->DY;
    }

    return true;
}

inline void UpdateRow ( int column, int row )
{
    FUNCTION_ENTRY ( NULL, "UpdateRow", false );

    sBlockMapBounds *bound = &blockMapBounds [ row ];
    if ( column < bound->lo ) bound->lo = column;
    if ( column > bound->hi ) bound->hi = column;
}

void DrawBlockMapLine ( const sPoint *p1, const sPoint *p2 )
{
    FUNCTION_ENTRY ( NULL, "DrawBlockMapLine", false );

    long x0 = p1->x - blockMap->xOrigin;
    long y0 = p1->y - blockMap->yOrigin;
    long x1 = p2->x - blockMap->xOrigin;
    long y1 = p2->y - blockMap->yOrigin;

    int startX = x0 / 128, startY = y0 / 128;
    int endX   = x1 / 128, endY   = y1 / 128;

    if ( startY < loRow ) loRow = startY;
    if ( startY > hiRow ) hiRow = startY;

    if ( endY < loRow ) loRow = endY;
    if ( endY > hiRow ) hiRow = endY;

    UpdateRow ( startX, startY );

    if ( startX == endX ) {

        if ( startY != endY ) { // vertical line
            int dy = (( endY - startY ) > 0 ) ? 1 : -1;
            do {
                startY += dy;
                UpdateRow ( startX, startY );
            } while ( startY != endY );
        }

    } else {

        if ( startY != endY ) { // diagonal line

            int dy = (( endY - startY ) > 0 ) ? 1 : -1;

            // Calculate the pre-scaled values to be used in the for loop
            int deltaX = ( x1 - x0 ) * 128 * dy;
            int deltaY = ( y1 - y0 ) * 128;
            int nextX = x0 * ( y1 - y0 );

            // Figure out where the 1st row ends
            switch ( dy ) {
                case -1 : nextX += ( startY * 128 - y0 ) * ( x1 - x0 );          break;
                case  1 : nextX += ( startY * 128 + 128 - y0 ) * ( x1 - x0 );    break;
            }

            int lastX = nextX / deltaY;
            UpdateRow ( lastX, startY );

            // Now do the rest using integer math - each row is a delta Y of 128
            sBlockMapBounds *bound    = &blockMapBounds [ startY ];
            sBlockMapBounds *endBound = &blockMapBounds [ endY ];
            if ( x0 < x1 ) {
                for ( EVER ) {
                    // Do the next row
                    bound += dy;
                    if ( lastX < bound->lo ) bound->lo = lastX;
                    // Stop before we overshoot endX
                    if ( bound == endBound ) break;
                    nextX += deltaX;
                    lastX = nextX / deltaY;
                    if ( lastX > bound->hi ) bound->hi = lastX;
                }
            } else {
                for ( EVER ) {
                    // Do the next row
                    bound += dy;
                    if ( lastX > bound->hi ) bound->hi = lastX;
                    // Stop before we overshoot endX
                    if ( bound == endBound ) break;
                    nextX += deltaX;
                    lastX = nextX / deltaY;
                    if ( lastX < bound->lo ) bound->lo = lastX;
                }
            }
        }

        UpdateRow ( endX, endY );
    }
}

void MarkBlockMap ( sWorldInfo *world )
{
    FUNCTION_ENTRY ( NULL, "MarkBlockMap", true );

    loRow = blockMap->noRows;
    hiRow = -1;

    // Determine boundaries for the BLOCKMAP search
    DrawBlockMapLine ( world->src->start, world->src->end );
    DrawBlockMapLine ( world->tgt->start, world->tgt->end );
    DrawBlockMapLine ( world->src->start, world->tgt->end );
    DrawBlockMapLine ( world->tgt->start, world->src->end );
}

bool FindInterveningLines ( sLineSet *set )
{
    FUNCTION_ENTRY ( NULL, "FindInterveningLines", true );

    // Reset the checked flag for GetLines
    memset ( checkLine, true, checkLineSize );

    // Mark all lines that have been bounded
    int lineCount = 0;

    for ( int row = loRow; row <= hiRow; row++ ) {
        sBlockMapBounds *bound = &blockMapBounds [ row ];
        for ( int col = bound->lo; col <= bound->hi; col++ ) {
            sBlockMapArrayEntry *ptr = blockMapArray [ row ][ col ];
            if ( ptr != NULL ) do {
                set->lines [ lineCount ] = ptr->line;
                lineCount += ( *ptr->available == true ) ? 1 : 0;
                *ptr->available = false;
            } while ( (++ptr)->available );
        }
        bound->lo = blockMap->noColumns;
        bound->hi = -1;
    }

    set->loIndex = 0;
    set->hiIndex = lineCount - 1;
    set->lines [ lineCount ] = NULL;

    return ( lineCount > 0 ) ? true : false;
}

void GetBounds ( const sPoint *ss, const sPoint *se, const sPoint *ts, const sPoint *te,
                 long *loY, long *hiY, long *loX, long *hiX )
{
    FUNCTION_ENTRY ( NULL, "GetBounds", true );

    if ( ss->y < se->y ) {
        if ( ts->y < te->y ) {
            *loY = ( ss->y < ts->y ) ? ss->y : ts->y;
            *hiY = ( se->y > te->y ) ? se->y : te->y;
        } else {
            *loY = ( ss->y < te->y ) ? ss->y : te->y;
            *hiY = ( se->y > ts->y ) ? se->y : ts->y;
        }
    } else {
        if ( ts->y < te->y ) {
            *loY = ( se->y < ts->y ) ? se->y : ts->y;
            *hiY = ( ss->y > te->y ) ? ss->y : te->y;
        } else {
            *loY = ( se->y < te->y ) ? se->y : te->y;
            *hiY = ( ss->y > ts->y ) ? ss->y : ts->y;
        }
    }
    if ( ss->x < se->x ) {
        if ( ts->x < te->x ) {
            *loX = ( ss->x < ts->x ) ? ss->x : ts->x;
            *hiX = ( se->x > te->x ) ? se->x : te->x;
        } else {
            *loX = ( ss->x < te->x ) ? ss->x : te->x;
            *hiX = ( se->x > ts->x ) ? se->x : ts->x;
        }
    } else {
        if ( ts->x < te->x ) {
            *loX = ( se->x < ts->x ) ? se->x : ts->x;
            *hiX = ( ss->x > te->x ) ? ss->x : te->x;
        } else {
            *loX = ( se->x < te->x ) ? se->x : te->x;
            *hiX = ( ss->x > ts->x ) ? ss->x : ts->x;
        }
    }
}

bool TrimSetBounds ( sLineSet *set )
{
    FUNCTION_ENTRY ( NULL, "TrimSetBounds", true );

    if ( set->loIndex >= set->hiIndex ) return false;

    while ( set->lines [ set->loIndex ]->ignore == true ) {
        set->loIndex++;
        if ( set->loIndex >= set->hiIndex ) return false;
    }

    while ( set->lines [ set->hiIndex ]->ignore == true ) {
        set->hiIndex--;
    }

    return true;
}

inline void RotatePoint ( sPoint *p, int x, int y )
{
    FUNCTION_ENTRY ( NULL, "RotatePoint", false );

    p->x = DX * ( x - X ) + DY * ( y - Y );
    p->y = DX * ( y - Y ) - DY * ( x - X );
}

int TrimLines ( const sTransLine *src, const sTransLine *tgt, sLineSet *set )
{
    FUNCTION_ENTRY ( NULL, "TrimLines", true );

    long loY, hiY, loX, hiX;
    GetBounds ( src->start, src->end, tgt->start, tgt->end, &loY, &hiY, &loX, &hiX );

    // Set up globals used by RotatePoint
    X  = src->start->x;
    Y  = src->start->y;
    DX = tgt->end->x - src->start->x;
    DY = tgt->end->y - src->start->y;

    // Variables for a rotated bounding box
    sPoint p1, p2, p3;
    RotatePoint ( &p1, src->end->x, src->end->y );
    RotatePoint ( &p2, tgt->start->x, tgt->start->y );
    RotatePoint ( &p3, tgt->end->x, tgt->end->y );

    long minX = ( p1.x < 0 ) ? 0 : p1.x;
    long maxX = ( p2.x < p3.x ) ? p2.x : p3.x;
    long minY = ( p1.y < p2.y ) ? p1.y : p2.y;

    int linesLeft = 0;

    bool checkBlock = (( minX <= maxX ) && (( DX != 0 ) || ( DY != 0 ))) ? true : false;

    for ( int i = set->loIndex; i <= set->hiIndex; i++ ) {

        sSolidLine *line = set->lines [i];

        line->ignore = true;

        // Eliminate any lines completely outside the axis aligned bounding box
        if ( line->start->y <= loY ) {
            if ( line->end->y <= loY ) continue;
        } else if ( line->start->y >= hiY ) {
            if ( line->end->y >= hiY ) continue;
        }
        if ( line->start->x >= hiX ) {
            if ( line->end->x >= hiX ) continue;
        } else if ( line->start->x <= loX ) {
            if ( line->end->x <= loX ) continue;
        }

        // Stop if we find a single line that obstructs the view completely
        if ( checkBlock == true ) {
            sPoint start, end;
            start.y = DX * ( line->start->y - Y ) - DY * ( line->start->x - X );
            if (( start.y >= 0 ) || ( start.y <= minY )) {
                end.y = DX * ( line->end->y - Y ) - DY * ( line->end->x - X );
                if ((( end.y <= minY ) && ( start.y >= 0 )) || (( end.y >= 0 ) && ( start.y <= minY ))) {
                    start.x = DX * ( line->start->x - X ) + DY * ( line->start->y - Y );
                    if (( start.x  >= minX ) && ( start.x <= maxX )) {
                        end.x = DX * ( line->end->x - X ) + DY * ( line->end->y - Y );
                        if (( end.x >= minX ) && ( end.x <= maxX )) {
                            return -1;
                        }
                    }
                // Use the new information and see if line is outside the bounding box
                } else if ((( end.y >= 0 ) && ( start.y >= 0 )) || (( end.y <= minY ) && ( start.y <= minY ))) {
                    continue;
                }
            }
        }

        line->ignore = false;
        linesLeft++;

    }

    if ( linesLeft == 0 ) return 0;

    if ((( src->DX != 0 ) && ( src->DY != 0 )) || (( tgt->DX != 0 ) && ( tgt->DY != 0 ))) {

        // Eliminate lines that touch the src/tgt lines but are not in view
        for ( int i = set->loIndex; i <= set->hiIndex; i++ ) {
            sSolidLine *line = set->lines [i];
            if ( line->ignore == true ) continue;
            int y = 1;
            if (( line->start == src->start ) || ( line->start == src->end )) {
                y = src->DX * ( line->end->y - src->start->y ) - src->DY * ( line->end->x - src->start->x );
            } else if (( line->end == src->start ) || ( line->end == src->end )) {
                y = src->DX * ( line->start->y - src->start->y ) - src->DY * ( line->start->x - src->start->x );
            } else if (( line->start == tgt->start ) || ( line->start == tgt->end )) {
                y = tgt->DX * ( line->end->y - tgt->start->y ) - tgt->DY * ( line->end->x - tgt->start->x );
            } else if (( line->end == tgt->start ) || ( line->end == tgt->end )) {
                y = tgt->DX * ( line->start->y - tgt->start->y ) - tgt->DY * ( line->start->x - tgt->start->x );
            }
            if ( y <= 0 ) {
                line->ignore = true;
                linesLeft--;
            }
        }
    }

    TrimSetBounds ( set );

    return linesLeft;
}

//
// Find out which side of the poly-line the line is on
//
//  Return Values:
//      1 - above (not completely below) the poly-line
//      0 - intersects the poly-line
//     -1 - below the poly-line (one or both end-points may touch the poly-line)
//     -2 - can't tell start this segment
//

int Intersects ( const sPoint *p1, const sPoint *p2, const sPoint *t1, const sPoint *t2 )
{
    FUNCTION_ENTRY ( NULL, "Intersects", false );

    long DX, DY, y1, y2;

    // Rotate & translate using p1->p2 as the +X-axis
    DX = p2->x - p1->x;
    DY = p2->y - p1->y;

    y1 = DX * ( t1->y - p1->y ) - DY * ( t1->x - p1->x );
    y2 = DX * ( t2->y - p1->y ) - DY * ( t2->x - p1->x );

    // Eliminate the 2 easy cases (t1 & t2 both above or below the x-axis)
    if (( y1 > 0 ) && ( y2 > 0 )) return 1;
    if (( y1 <= 0 ) && ( y2 <= 0 )) return -1;
    // t1->t2 crosses poly-Line segment (or one point touches it and the other is above it)

    // Rotate & translate using t1->t2 as the +X-axis
    DX = t2->x - t1->x;
    DY = t2->y - t1->y;

    y1 = DX * ( p1->y - t1->y ) - DY * ( p1->x - t1->x );
    y2 = DX * ( p2->y - t1->y ) - DY * ( p2->x - t1->x );

    // Eliminate the 2 easy cases (p1 & p2 both above or below the x-axis)
    if (( y1 > 0 ) && ( y2 > 0 )) return -2;
    if (( y1 < 0 ) && ( y2 < 0 )) return -2;

    return 0;
}

int FindSide ( sMapLine *line, sPolyLine *poly )
{
    FUNCTION_ENTRY ( NULL, "FindSide", false );

    bool completelyBelow = true;
    for ( int i = 0; i < poly->noPoints - 1; i++ ) {
        const sPoint *p1 = poly->point [i];
        const sPoint *p2 = poly->point [i+1];
        switch ( Intersects ( p1, p2, line->start, line->end )) {
            case -1 : break;
            case  0 : return 0;
            case -2 :
            case  1 : completelyBelow = false;
        }
    }
    return completelyBelow ? -1 : 1;
}

void AddToPolyLine ( sPolyLine *poly, sSolidLine *line )
{
    FUNCTION_ENTRY ( NULL, "AddToPolyLine", true );

    long DX, DY, y1, y2;

    y1 = 0;

    // Find new index start from the 'left'
    int i;
    for ( i = 0; i < poly->noPoints - 1; i++ ) {
        const sPoint *p1 = poly->point [i];
        const sPoint *p2 = poly->point [i+1];
        DX = p2->x - p1->x;
        DY = p2->y - p1->y;

        y1 = DX * ( line->start->y - p1->y ) - DY * ( line->start->x - p1->x );
        y2 = DX * ( line->end->y - p1->y ) - DY * ( line->end->x - p1->x );
        if (( y1 > 0 ) != ( y2 > 0 )) break;
    }
    i += 1;

    // Find new index start from the 'right'
    int j;
    for ( j = poly->noPoints - 1; j > i; j-- ) {
        const sPoint *p1 = poly->point [j-1];
        const sPoint *p2 = poly->point [j];
        DX = p2->x - p1->x;
        DY = p2->y - p1->y;

        long y1 = DX * ( line->start->y - p1->y ) - DY * ( line->start->x - p1->x );
        long y2 = DX * ( line->end->y - p1->y ) - DY * ( line->end->x - p1->x );
        if (( y1 > 0 ) != ( y2 > 0 )) break;
    }

    int ptsRemoved = j - i;
    int toCopy     = poly->noPoints - j;
    if ( toCopy > 0 ) memmove ( &poly->point [i+1], &poly->point [j], sizeof ( sPoint * ) * toCopy );
    poly->noPoints += 1 - ptsRemoved;

    poly->point [i] = ( y1 > 0 ) ? line->start : line->end;
    poly->lastPoint = i;
}

bool PolyLinesCross ( sPolyLine *upper, sPolyLine *lower )
{
    bool foundAbove = false, ambiguous = false;
    int last = 0, max = upper->noPoints - 1;
    if ( upper->lastPoint != -1 ) {
        max  = 2;
        last = upper->lastPoint - 1;
    }
    for ( int i = 0; i < max; i++ ) {
        const sPoint *p1 = upper->point [ last + i ];
        const sPoint *p2 = upper->point [ last + i + 1 ];
        for ( int j = 0; j < lower->noPoints - 1; j++ ) {
            const sPoint *p3 = lower->point [j];
            const sPoint *p4 = lower->point [j+1];
            switch ( Intersects ( p1, p2, p3, p4 )) {
                case  1 : foundAbove = true;
                          break;
                case  0 : return true;
                case -2 : ambiguous = true;
                          break;
            }
        }
    }

    if ( foundAbove == true ) return false;

    if ( ambiguous == true ) {
        const sPoint *p1 = upper->point [0];
        const sPoint *p2 = upper->point [ upper->noPoints - 1 ];
        long DX = p2->x - p1->x;
        long DY = p2->y - p1->y;
        for ( int i = 1; i < lower->noPoints - 1; i++ ) {
            const sPoint *testPoint = lower->point [i];
            if ( DX * ( testPoint->y - p1->y ) - DY * ( testPoint->x - p1->x ) < 0 ) return true;
        }
    }

    return false;
}

bool CorrectForNewStart ( sPolyLine *poly )
{
    FUNCTION_ENTRY ( NULL, "CorrectForNewStart", true );

    const sPoint *p0 = poly->point [0];
    for ( int i = poly->noPoints - 1; i > 1; i-- ) {
        const sPoint *p1 = poly->point [i];
        const sPoint *p2 = poly->point [i-1];
        long dx = p1->x - p0->x;
        long dy = p1->y - p0->y;
        long y = dx * ( p2->y - p0->y ) - dy * ( p2->x - p0->x );
        if ( y < 0 ) {
            poly->point [i-1] = p0;
            poly->point      += i - 1;
            poly->noPoints   -= i - 1;
            poly->lastPoint  -= i - 1;
            return true;
        }
    }
    return false;
}

bool CorrectForNewEnd ( sPolyLine *poly )
{
    FUNCTION_ENTRY ( NULL, "CorrectForNewEnd", true );

    const sPoint *p0 = poly->point [ poly->noPoints - 1 ];
    for ( int i = 0; i < poly->noPoints - 2; i++ ) {
        const sPoint *p1 = poly->point [i];
        const sPoint *p2 = poly->point [i+1];
        long dx = p0->x - p1->x;
        long dy = p0->y - p1->y;
        long y = dx * ( p2->y - p1->y ) - dy * ( p2->x - p1->x );
        if ( y < 0 ) {
            poly->point [i+1] = p0;
            poly->noPoints   -= poly->noPoints - i - 2;
            return true;
        }
    }
    return false;
}

bool AdjustEndPoints ( sTransLine *left, sTransLine *right, sPolyLine *upper, sPolyLine *lower )
{
    FUNCTION_ENTRY ( NULL, "AdjustEndPoints", true );

    if ( upper->lastPoint == -1 ) return true;
    const sPoint *test = upper->point [ upper->lastPoint ];

    long dx, dy, y;
    bool changed = false;

    dx = test->x - left->hiPoint->x;
    dy = test->y - left->hiPoint->y;
    y = dx * ( right->hiPoint->y - left->hiPoint->y ) -
        dy * ( right->hiPoint->x - left->hiPoint->x );
    if ( y > 0 ) {
        long num = ( right->start->y - left->hiPoint->y ) * dx -
                   ( right->start->x - left->hiPoint->x ) * dy;
        long det = right->DX * dy - right->DY * dx;
        REAL t = ( REAL ) num / ( REAL ) det;
        if ( t <= right->lo ) return false;
        if ( t < right->hi ) {
            right->hi = t;
            right->hiPoint->x = right->start->x + ( long ) ( t * right->DX );
            right->hiPoint->y = right->start->y + ( long ) ( t * right->DY );
            changed |= CorrectForNewStart ( upper );
        }
    }

    dx = test->x - right->loPoint->x;
    dy = test->y - right->loPoint->y;
    y = dx * ( left->loPoint->y - right->loPoint->y ) -
        dy * ( left->loPoint->x - right->loPoint->x );
    if ( y < 0 ) {
        long num = ( left->start->y - right->loPoint->y ) * dx -
                   ( left->start->x - right->loPoint->x ) * dy;
        long det = left->DX * dy - left->DY * dx;
        REAL t = ( REAL ) num / ( REAL ) det;
        if ( t >= left->hi ) return false;
        if ( t > left->lo ) {
            left->lo = t;
            left->loPoint->x = left->start->x + ( long ) ( t * left->DX );
            left->loPoint->y = left->start->y + ( long ) ( t * left->DY );
            changed |= CorrectForNewEnd ( upper );
        }
    }

    return (( changed == true ) && ( PolyLinesCross ( upper, lower ) == true )) ? false : true;
}

bool FindPolyLines ( sWorldInfo *world )
{
    FUNCTION_ENTRY ( NULL, "FindPolyLines", true );

    sPolyLine *upperPoly = &world->upperPoly;
    sPolyLine *lowerPoly = &world->lowerPoly;

    sLineSet *set = &world->solidSet;

    for ( EVER ) {

        bool done  = true;
        bool stray = false;

        for ( int i = set->loIndex; i <= set->hiIndex; i++ ) {

            sSolidLine *line = set->lines [ i ];
            if ( line->ignore == true ) continue;

            switch ( FindSide ( line, lowerPoly )) {

                case  1 : // Completely above the lower/right poly-Line
                    switch ( FindSide ( line, upperPoly )) {

                        case  1 : // Line is between the two poly-lines
                            stray = true;
                            break;

                        case  0 : // Intersects the upper/left poly-Line
                            if ( stray ) done = false;
                            AddToPolyLine ( upperPoly, line );
                            if (( lowerPoly->noPoints > 2 ) && ( PolyLinesCross ( upperPoly, lowerPoly ) == true )) {
                                return false;
                            }
                            if ( AdjustEndPoints ( world->src, world->tgt, upperPoly, lowerPoly ) == false ) {
                                return false;
                            }
                        case -1 : // Completely above the upper/left poly-line
                            line->ignore = true;
                            break;

                    }
                    break;

                case  0 : // Intersects the lower/right poly-Line
                    if ( stray == true ) done = false;
                    AddToPolyLine ( lowerPoly, line );
                    if ( PolyLinesCross ( lowerPoly, upperPoly ) == true ) {
                        return false;
                    }
                    if ( AdjustEndPoints ( world->tgt, world->src, lowerPoly, upperPoly ) == false ) {
                        return false;
                    }
                case -1 : // Completely below the lower/right poly-Line
                    line->ignore = true;
                    break;

            }
        }

        if ( done == true ) break;

        TrimSetBounds ( set );
    }

    return true;
}

bool FindObstacles ( sWorldInfo *world )
{
    FUNCTION_ENTRY ( NULL, "FindObstacles", true );

    if ( world->solidSet.hiIndex < world->solidSet.loIndex ) return false;

    // If we have an unbroken line between src & tgt there is a direct LOS
    if ( world->upperPoly.noPoints == 2 ) return false;
    if ( world->lowerPoly.noPoints == 2 ) return false;

    // To be absolutely correct, we should create a list of obstacles
    // (ie: connected lineDefs completely enclosed by upperPoly & lowerPoly)
    // and see if any of them completely block the LOS

    return false;
}

void InitializeWorld ( sWorldInfo *world, sTransLine *src, sTransLine *tgt )
{
    FUNCTION_ENTRY ( NULL, "InitializeWorld", true );

    world->src = src;
    world->tgt = tgt;

    world->solidSet.lines   = testLines;
    world->solidSet.loIndex = 0;
    world->solidSet.hiIndex = -1;

    static sPoint p1, p2, p3, p4;
    p1 = *src->start;
    p2 = *src->end;
    p3 = *tgt->start;
    p4 = *tgt->end;

    src->loPoint = &p1;    src->lo = 0.0;
    src->hiPoint = &p2;    src->hi = 1.0;
    tgt->loPoint = &p3;    tgt->lo = 0.0;
    tgt->hiPoint = &p4;    tgt->hi = 1.0;

    sPolyLine *lowerPoly = &world->lowerPoly;
    lowerPoly->point     = polyPoints;
    lowerPoly->noPoints  = 2;
    lowerPoly->lastPoint = -1;
    lowerPoly->point [0] = src->hiPoint;
    lowerPoly->point [1] = tgt->loPoint;

    sPolyLine *upperPoly = &world->upperPoly;
    upperPoly->point     = &polyPoints [ noSolidLines + 2 ];
    upperPoly->noPoints  = 2;
    upperPoly->lastPoint = -1;
    upperPoly->point [0] = tgt->hiPoint;
    upperPoly->point [1] = src->loPoint;
}

bool CheckLOS ( sTransLine *src, sTransLine *tgt )
{
    FUNCTION_ENTRY ( NULL, "CheckLOS", true );

    sWorldInfo myWorld;
    InitializeWorld ( &myWorld, src, tgt );

    MarkBlockMap ( &myWorld );

    // See if there are any solid lines in the blockmap region between src & tgt
    if ( FindInterveningLines ( &myWorld.solidSet ) == true ) {

        // If src & tgt touch, look for a quick way out - no lines passing through the common point
        const sPoint *common = NULL;
        if ((( common = src->end ) == tgt->start ) || (( common = src->start ) == tgt->end )) {
            for ( int i = myWorld.solidSet.loIndex; i <= myWorld.solidSet.hiIndex; i++ ) {
                sSolidLine *line = myWorld.solidSet.lines [i];
                if (( line->start == common ) || ( line->end == common )) goto more;
            }
            // The two lines touch and there are no lines blocking them
            return true;
        }

    more:

        // Do a more refined check to see if there are any lines
        switch ( TrimLines ( myWorld.src, myWorld.tgt, &myWorld.solidSet )) {

            case -1 :		// A single line completely blocks the view
                return false;

            case 0 :		// No intervening lines left - end check
                break;

            default :
                // Do an even more refined check
                if ( FindPolyLines ( &myWorld ) == false ) return false;
                // Now see if there are any obstacles that may block the LOS
                if ( FindObstacles ( &myWorld ) == true ) return false;
        }
    }

    return true;
}

bool DivideRegion ( sTransLine *src, sTransLine *tgt )
{
    FUNCTION_ENTRY ( NULL, "DivideRegion", true );

    // Find the point of intersection on src
    long num = tgt->DX * ( src->start->y - tgt->start->y ) - tgt->DY * ( src->start->x - tgt->start->x );
    long det = src->DX * tgt->DY - src->DY * tgt->DX;
    REAL t   = ( REAL ) num / ( REAL ) det;

    sPoint crossPoint ( src->start->x + ( long ) ( t * src->DX ), src->start->y + ( long ) ( t * src->DY ));

    // See if we ran into an integer truncation problem (shortcut if we did)
    if (( crossPoint == *src->start ) || ( crossPoint == *src->end )) {
        return CheckLOS ( src, tgt );
    }

    sTransLine newSrc = *src;

    newSrc.end = &crossPoint;

    bool isVisible = CheckLOS ( &newSrc, tgt );

    if ( isVisible == false ) {
        newSrc.start = &crossPoint;
        newSrc.end   = src->end;
        swap ( tgt->start, tgt->end );
        tgt->DX      = -tgt->DX;
        tgt->DY      = -tgt->DY;
        isVisible    = CheckLOS ( &newSrc, tgt );
    }

    return isVisible;
}

UINT8 GetLineVisibility ( const sTransLine *srcLine, const sTransLine *tgtLine )
{
    FUNCTION_ENTRY ( NULL, "GetLineVisibility", true );

    if ( srcLine == tgtLine ) return VIS_VISIBLE;

    int row = (( srcLine < tgtLine ) ? srcLine : tgtLine ) - transLines;
    int col = (( srcLine < tgtLine ) ? tgtLine : srcLine ) - transLines;

    int offset = row * ( 2 * noTransLines - 1 - row ) / 2 + ( col - row - 1 );

    UINT8 data = lineVisTable [ offset / 4 ];

    return ( UINT8 ) ( 0x03 & ( data >> ( 2 * ( offset % 4 ))));
}

void SetLineVisibility ( const sTransLine *srcLine, const sTransLine *tgtLine, UINT8 vis )
{
    FUNCTION_ENTRY ( NULL, "SetLineVisibility", false );

    if ( srcLine == tgtLine ) return;

    int row = (( srcLine < tgtLine ) ? srcLine : tgtLine ) - transLines;
    int col = (( srcLine < tgtLine ) ? tgtLine : srcLine ) - transLines;

    int offset = row * ( 2 * noTransLines - 1 - row ) / 2 + ( col - row - 1 );

    UINT8 data = lineVisTable [ offset / 4 ];

    data &= ~ ( 0x03 << ( 2 * ( offset % 4 )));
    data |= vis << ( 2 * ( offset % 4 ));

    lineVisTable [ offset / 4 ] = data;
}

bool DontBother ( const sTransLine *srcLine, const sTransLine *tgtLine )
{
    FUNCTION_ENTRY ( NULL, "DontBother", true );

    if (( rejectTable [ srcLine->leftSector ][ tgtLine->leftSector ] != VIS_UNKNOWN ) &&
        ( rejectTable [ srcLine->leftSector ][ tgtLine->rightSector ] != VIS_UNKNOWN ) &&
        ( rejectTable [ srcLine->rightSector ][ tgtLine->leftSector ] != VIS_UNKNOWN ) &&
        ( rejectTable [ srcLine->rightSector ][ tgtLine->rightSector ] != VIS_UNKNOWN )) {
        return true;
    }

    return false;
}

int MapDistance ( const sPoint *p1, const sPoint *p2 )
{
    FUNCTION_ENTRY ( NULL, "MapDistance", true );

    int dx = p1->x - p2->x;
    int dy = p1->y - p2->y;

    return dx * dx + dy * dy;
}

bool PointTooFar ( const sPoint *p, const sTransLine *line )
{
    FUNCTION_ENTRY ( NULL, "PointTooFar", true );

    const sPoint *p1 = line->start;
    const sPoint *p2 = line->end;

    int c1 = line->DX * ( p->x - p1->x ) + line->DY * ( p->y - p1->y );

    if ( c1 <= 0 ) {
        // 'p' is closest to the start of the line segment
        return ( MapDistance ( p, p1 ) < maxMapDistance ) ? false : true;
    }

    if ( c1 >= line->H ) {
        // 'p' is closest to the end of the line segment
        return ( MapDistance ( p, p2 ) < maxMapDistance ) ? false : true;
    }

    int d = ( line->DX * ( p->y - p1->y ) - line->DY * ( p->x - p1->x )) / line->H;

    return ( d < maxMapDistance ) ? false : true;
}

bool LinesTooFarApart ( const sTransLine *srcLine, const sTransLine *tgtLine )
{
    FUNCTION_ENTRY ( NULL, "TestLinePair", true );

    if (( maxMapDistance != INT_MAX ) &&
        ( PointTooFar ( srcLine->start, tgtLine ) == true ) &&
        ( PointTooFar ( srcLine->end,   tgtLine ) == true ) &&
        ( PointTooFar ( tgtLine->start, srcLine ) == true ) &&
        ( PointTooFar ( tgtLine->end,   srcLine ) == true )) {
        STATUS ( "Lines " << srcLine->index << " and " << tgtLine->index << " are too far apart" );
        return true;
    }

    return false;
}

bool TestLinePair ( const sTransLine *srcLine, const sTransLine *tgtLine )
{
    FUNCTION_ENTRY ( NULL, "TestLinePair", true );

    UINT8 vis = GetLineVisibility ( srcLine, tgtLine );

    if (( vis != VIS_UNKNOWN ) || ( DontBother ( srcLine, tgtLine ) == true )) {
        return false;
    }

    if ( LinesTooFarApart ( srcLine, tgtLine ) == true ) {
        SetLineVisibility ( srcLine, tgtLine, VIS_HIDDEN );
        return false;
    }

    sTransLine src = *srcLine;
    sTransLine tgt = *tgtLine;

    bool isVisible = false;

    bool bisect = false;
    if ( AdjustLinePair ( &src, &tgt, &bisect ) == true ) {
        isVisible = ( bisect == true ) ? DivideRegion ( &src, &tgt ) : CheckLOS ( &src, &tgt );
    }

    SetLineVisibility ( srcLine, tgtLine, isVisible ? VIS_VISIBLE : VIS_HIDDEN );

    return isVisible;
}

void MarkPairVisible ( sTransLine *srcLine, sTransLine *tgtLine )
{
    FUNCTION_ENTRY ( NULL, "MarkPairVisible", true );

    // There is a direct LOS between the two lines - mark all affected sectors
    MarkVisibility ( srcLine->leftSector, tgtLine->leftSector, VIS_VISIBLE );
    MarkVisibility ( srcLine->leftSector, tgtLine->rightSector, VIS_VISIBLE );
    MarkVisibility ( srcLine->rightSector, tgtLine->leftSector, VIS_VISIBLE );
    MarkVisibility ( srcLine->rightSector, tgtLine->rightSector, VIS_VISIBLE );
}

//----------------------------------------------------------------------------
//  Sort sectors so the the most critical articulation points are placed first
//----------------------------------------------------------------------------
int SortSector ( const void *ptr1, const void *ptr2 )
{
    FUNCTION_ENTRY ( NULL, "SortSector", false );

    const sSector *sec1 = * ( const sSector ** ) ptr1;
    const sSector *sec2 = * ( const sSector ** ) ptr2;

    // Favor the sector with the best metric (higher is better)
    if ( sec1->metric != sec2->metric ) {
        return sec2->metric - sec1->metric;
    }

    // Favor the sector that is not part of a loop
    int sec1Loop = ( sec1->loDFS < sec1->indexDFS ) ? 1 : 0;
    int sec2Loop = ( sec2->loDFS < sec2->indexDFS ) ? 1 : 0;

    if ( sec1Loop != sec2Loop ) {
        return sec1Loop - sec2Loop;
    }

    // Favor the sector with the most neighbors
    if ( sec1->noNeighbors != sec2->noNeighbors ) {
        return sec2->noNeighbors - sec1->noNeighbors;
    }

    // Favor the sector with the most visible lines
    if ( sec1->noLines != sec2->noLines ) {
        return sec2->noLines - sec1->noLines;
    }

    // It's a tie - use the sector index - lower index favored
    return sec1->index - sec2->index;
}

//----------------------------------------------------------------------------
// Create a mapping for see-thru lines that tries to put lines that affect
//   the most sectors first.  As more sectors are marked visible/hidden, the
//   number of remaining line pairs that must be checked drops.  By ordering
//   the lines, we can speed things up quite a bit with just a little effort.
//----------------------------------------------------------------------------
int SetupLineMap ( sTransLine **lineMap, sSector **sectorList, int maxSectors )
{
    FUNCTION_ENTRY ( NULL, "SetupLineMap", true );

    static bool inMap [0x10000];

    memset ( inMap, 0, sizeof ( inMap ));

    int maxIndex = 0;
    for ( int i = 0; i < maxSectors; i++ ) {
        for ( int j = 0; j < sectorList [i]->noLines; j++ ) {
            sTransLine *line = sectorList [i]->line [j];
            if ( inMap [line->index] == false ) {
                inMap [line->index] = true;
                lineMap [ maxIndex++ ] = line;
            }
        }
    }

    return maxIndex;
}

bool ShouldTest ( sTransLine *src, int key, sTransLine *tgt, int sector )
{
    long y1 = src->DX * ( tgt->start->y - src->start->y ) - src->DY * ( tgt->start->x - src->start->x );
    long y2 = src->DX * (  tgt->end->y  - src->start->y ) - src->DY * (  tgt->end->x  - src->start->x );

    if ( src->rightSector == key ) {
        if (( y1 <= 0 ) && ( y2 <= 0 )) {
            return false;
        }
    } else if (( y1 >= 0 ) && ( y2 >= 0 )) {
        return false;
    }

    long x1 = tgt->DX * ( src->start->y - tgt->start->y ) - tgt->DY * ( src->start->x - tgt->start->x );
    long x2 = tgt->DX * (  src->end->y  - tgt->start->y ) - tgt->DY * (  src->end->x  - tgt->start->x );

    if ( tgt->rightSector == sector ) {
        if (( x1 <= 0 ) && ( x2 <= 0 )) {
            return false;
        }
    } else if (( x1 >= 0 ) && ( x2 >= 0 )) {
        return false;
    }

    return true;
}

void ProcessSectorLines ( sSector *key, sSector *root, sSector *sector, sTransLine **lines )
{
    FUNCTION_ENTRY ( NULL, "ProcessSectorLines", true );

    bool isVisible = ( rejectTable [ key->index ][ sector->index ] == VIS_VISIBLE ) ? true : false;
    bool isUnknown = ( rejectTable [ key->index ][ sector->index ] == VIS_UNKNOWN ) ? true : false;

    if ( isUnknown == true ) {

        sTransLine **ptr = lines;

        while ( *ptr != NULL ) {

            sTransLine *srcLine = *ptr++;

            for ( int i = 0; i < sector->noNeighbors; i++ ) {
                sSector *child = sector->neighbor [i];
                // Test each line that may lead back to the key sector (can reach higher up in the graph)
                if ( child->loDFS <= sector->indexDFS ) {
                    for ( int j = 0; j < sector->noLines; j++ ) {
                        sTransLine *tgtLine = sector->line [j];
                        if (( tgtLine->leftSector == child->index ) || ( tgtLine->rightSector == child->index )) {
                            if ( ShouldTest ( srcLine, key->index, tgtLine, sector->index ) == true ) {
                                if ( TestLinePair ( srcLine, tgtLine )) {
                                    MarkPairVisible ( srcLine, tgtLine );
                                    goto done;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    if ( isVisible == false ) {
        
        sGraph *graph = sector->graph;

        // See if we're in a loop
        if ( sector->loDFS == sector->indexDFS ) {

            // Nope. Hide ourself and all our children from the other components
            for ( int i = sector->indexDFS; i <= sector->hiDFS; i++ ) {
                HideSectorFromComponents ( key, root, graph->sector [i] );
            }

        } else {

            // Yep. Hide ourself
            HideSectorFromComponents ( key, root, sector );

            for ( int i = 0; i < sector->noNeighbors; i++ ) {
                sSector *child = sector->neighbor [i];
                if ( child->graphParent == sector ) {
                    // Hide any child components that aren't in the loop
                    if ( child->loDFS >= sector->indexDFS ) {
                        for ( int i = child->indexDFS; i <= child->hiDFS; i++ ) {
                            HideSectorFromComponents ( key, root, graph->sector [i] );
                        }
                    } else {
                        ProcessSectorLines ( key, root, child, lines );
                    }
                }
            }
        }

    } else {

done:
        // Continue checking all of our children
        for ( int i = 0; i < sector->noNeighbors; i++ ) {
            sSector *child = sector->neighbor [i];
            if ( child->graphParent == sector ) {
                ProcessSectorLines ( key, root, child, lines );
            }
        }
    }
}

void ProcessSector ( sSector *sector )
{
    FUNCTION_ENTRY ( NULL, "ProcessSector", true );

    if ( sector->isArticulation == true ) {

        // For now, make sure this sector is at the top of the graph (keeps things simple)
        QuickGraph ( sector );

        sTransLine **lines = new sTransLine * [ sector->noLines + 1 ];

        for ( int i = 0; i < sector->noNeighbors; i++ ) {

            sSector *child = sector->neighbor [i];

            // Find each child that is the start of a component of this sector
            if ( child->graphParent == sector ) {

                // Make a list of lines that connect this component
                int index = 0;
                for ( int j = 0; j < sector->noLines; j++ ) {
                    sTransLine *line = sector->line [j];
                    if (( line->leftSector == child->index ) || ( line->rightSector == child->index )) {
                        lines [index++] = line;
                    }
                }

                // If this child is part of a loop, add lines from all the other children in the loop too
                if ( child->loDFS < child->indexDFS ) {
                    for ( int j = i + 1; j < sector->noNeighbors; j++ ) {
                        sSector *child2 = sector->neighbor [j];
                        if ( child2->indexDFS <= child->hiDFS ) {
                            for ( int k = 0; k < sector->noLines; k++ ) {
                                sTransLine *line = sector->line [k];
                                if (( line->leftSector == child2->index ) || ( line->rightSector == child2->index )) {
                                    lines [index++] = line;
                                }
                            }
                        }
                    }
                }

                lines [index] = NULL;

                ProcessSectorLines ( sector, child, child, lines );
            }

        }

        delete [] lines;

    } else {

        sGraph *graph = sector->baseGraph;

        UINT8 *rejectRow = rejectTable [ sector->index ];

        for ( int i = 0; i < graph->noSectors; i++ ) {

            sSector *tgtSector = graph->sector [i];

            if ( rejectRow [ tgtSector->index ] == VIS_UNKNOWN ) {

                for ( int j = 0; j < sector->noLines; j++ ) {
                    sTransLine *srcLine = sector->line [j];
                    for ( int k = 0; k < tgtSector->noLines; k++ ) {
                        sTransLine *tgtLine = tgtSector->line [k];
                        if ( TestLinePair ( srcLine, tgtLine ) == true ) {
                            MarkPairVisible ( srcLine, tgtLine );
                            goto next;
                        }
                    }
                }

                MarkVisibility ( sector->index, tgtSector->index, VIS_HIDDEN );

            next:

                ;
            }
        }
    }
}

bool NeedDistances ( const sRejectOptionRMB *rmb )
{
    FUNCTION_ENTRY ( NULL, "NeedDistances", true );

    if ( rmb == NULL ) return false;

    // Look for any RMB option that requires distances
    for ( int i = 0; rmb [i].Info != NULL; i++ ) {
        switch ( rmb [i].Info->Type ) {
            case OPTION_BLIND :
            case OPTION_LENGTH :
            case OPTION_SAFE :
            case OPTION_REPORT :
                return true;
            default : 
                break;
        }
    }

    return false;
}

void ApplyDistanceLimits ( const sRejectOptionRMB *rmb, int noSectors, int **distanceTable )
{
    FUNCTION_ENTRY ( NULL, "ApplyDistanceLimits", true );

    if ( rmb == NULL ) return;

    int maxLength = INT_MAX;

    for ( int i = 0; rmb [i].Info != NULL; i++ ) {
        if ( rmb [i].Info->Type == OPTION_LENGTH ) {
            // Remember the last LENGTH option seen
            maxLength = rmb [i].Data [0];
        }
    }

    // Did we find a LENGTH option?
    if ( maxLength != INT_MAX ) {
        for ( int x = 0; x < noSectors; x++ ) {
            for ( int y = x + 1; y < noSectors; y++ ) {
                if ( distanceTable [x][y] > maxLength ) {
                    rejectTable [x][y] = VIS_HIDDEN;
                    rejectTable [y][x] = VIS_HIDDEN;
                }
            }
        }
    }
}

int FindMaxMapDistance ( const sRejectOptionRMB *rmb )
{
    FUNCTION_ENTRY ( NULL, "FindMaxMapDistance", true );

    int maxDistance = INT_MAX;

    if ( rmb != NULL ) {
        for ( int i = 0; rmb [i].Info != NULL; i++ ) {
            if ( rmb [i].Info->Type == OPTION_DISTANCE ) {
                // Store the square of the distance (avoid floating point later on)
                maxDistance = rmb [i].Data [0] * rmb [i].Data [0];
            }
        }
    }

    return maxDistance;
}

void ProcessOptionsRMB ( const sRejectOptionRMB *rmb, int noSectors, int **distanceTable )
{
    FUNCTION_ENTRY ( NULL, "ProcessOptionsRMB", true );

    if ( rmb == NULL ) return;

    // Handle the options that rely on distance
    if ( distanceTable != NULL ) {

        sSectorRMB *sectorList = new sSectorRMB [noSectors];
        memset ( sectorList, -1, sizeof ( sSectorRMB ) * noSectors );

        // Populate sectorList with the BLIND/SAFE information
        for ( int i = 0; rmb [i].Info != NULL; i++ ) {
            if ( rmb [i].Info->Type == OPTION_BLIND ) {
                if ( rmb [i].Banded == true ) {
                    for ( int j = 0; rmb [i].List [0][j] != -1; j++ ) {
                        sSectorRMB *sector = &sectorList [rmb [i].List [0][j]];
                        sector->Blind   = rmb [i].Inverted ? 7 : 4;
                        sector->BlindLo = rmb [i].Data [0];
                        sector->BlindHi = rmb [i].Data [1];
                    }
                } else {
                    for ( int j = 0; rmb [i].List [0][j] != -1; j++ ) {
                        sSectorRMB *sector = &sectorList [rmb [i].List [0][j]];
                        if ( sector->Blind < 4 ) {
                            if ( sector->Blind == -1 ) sector->Blind = 0;
                            sector->Blind |= rmb [i].Inverted ? 2 : 1;
                            ( rmb [i].Inverted ? sector->BlindHi : sector->BlindLo ) = rmb [i].Data [0];
                        }
                    }
                }
            }
            if ( rmb [i].Info->Type == OPTION_SAFE ) {
                if ( rmb [i].Banded == true ) {
                    for ( int j = 0; rmb [i].List [0][j] != -1; j++ ) {
                        sSectorRMB *sector = &sectorList [rmb [i].List [0][j]];
                        sector->Safe   = rmb [i].Inverted ? 7 : 4;
                        sector->SafeLo = rmb [i].Data [0];
                        sector->SafeHi = rmb [i].Data [1];
                    }
                } else {
                    for ( int j = 0; rmb [i].List [0][j] != -1; j++ ) {
                        sSectorRMB *sector = &sectorList [rmb [i].List [0][j]];
                        if ( sector->Safe < 4 ) {
                            if ( sector->Safe == -1 ) sector->Safe = 0;
                            sector->Safe |= rmb [i].Inverted ? 2 : 1;
                            ( rmb [i].Inverted ? sector->SafeHi : sector->SafeLo ) = rmb [i].Data [0];
                        }
                    }
                }
            }
        }

        // Do the BLIND/SAFE thing
        for ( int i = 0; i < noSectors; i++ ) {
            sSectorRMB *sector = &sectorList [i];
            if ( sector->Blind > 0 ) {
                if ( sector->Blind == 3 ) {
                    if ( sector->BlindLo > sector->BlindHi ) {
                        swap ( sector->BlindLo, sector->BlindHi );
                        sector->Blind = 4;
                    }
                }
                for ( int j = 0; j < noSectors; j++ ) {
                    if ( sector->Blind & 1 ) {
                        // Handle normal BLIND
                        if ( distanceTable [i][j] >= sector->BlindLo ) {
                            rejectTable [i][j] |= VIS_RMB_HIDDEN;
                        }
                    }
                    if ( sector->Blind & 2 ) { 
                        // Handle inverse BLIND
                        if ( distanceTable [i][j] < sector->BlindHi ) {
                            rejectTable [i][j] |= VIS_RMB_HIDDEN;
                        }
                    }
                    if ( sector->Blind == 4 ) {
                        // Handle normal BAND BLIND
                        if (( distanceTable [i][j] >= sector->BlindLo ) &&
                            ( distanceTable [i][j] <  sector->BlindHi )) {
                            rejectTable [i][j] |= VIS_RMB_HIDDEN;
                        }
                    }
                }
            }
            if ( sector->Safe > 0 ) {
                if ( sector->Safe == 3 ) {
                    if ( sector->SafeLo > sector->SafeHi ) {
                        swap ( sector->SafeLo, sector->SafeHi );
                        sector->Safe = 4;
                    }
                }
                for ( int j = 0; j < noSectors; j++ ) {
                    if ( sector->Safe & 1 ) {
                        // Handle normal SAFE
                        if ( distanceTable [i][j] >= sector->SafeLo ) {
                            rejectTable [j][i] |= VIS_RMB_HIDDEN;
                        }
                    }
                    if ( sector->Safe & 2 ) { 
                        // Handle inverse SAFE
                        if ( distanceTable [i][j] < sector->SafeHi ) {
                            rejectTable [j][i] |= VIS_RMB_HIDDEN;
                        }
                    }
                    if ( sector->Safe == 4 ) {
                        // Handle normal BAND SAFE
                        if (( distanceTable [i][j] >= sector->SafeLo ) &&
                            ( distanceTable [i][j] <  sector->SafeHi )) {
                            rejectTable [j][i] |= VIS_RMB_HIDDEN;
                        }
                    }
                }
            }
        }

        delete [] sectorList;
    }

    // INCLUDE is the 2nd highest priority option
    for ( int i = 0; rmb [i].Info != NULL; i++ ) {
        if ( rmb [i].Info->Type == OPTION_INCLUDE ) {
            int *src = rmb [i].List [0];
            int *tgt = rmb [i].List [1];
            while ( *src != -1 ) {
                int *next = tgt;
                while ( *next != -1 ) {
                    rejectTable [ *src ][ *next++ ] |= VIS_RMB_VISIBLE;
                }
                src++;
            }
        }
    }

    // EXCLUDE is the highest priority option
    for ( int i = 0; rmb [i].Info != NULL; i++ ) {
        if ( rmb [i].Info->Type == OPTION_EXCLUDE ) {
            int *src = rmb [i].List [0];
            int *tgt = rmb [i].List [1];
            while ( *src != -1 ) {
                int *next = tgt;
                while ( *next != -1 ) {
                    rejectTable [ *src ][ *next++ ] = VIS_HIDDEN;
                }
                src++;
            }
        }
    }
}

bool CreateREJECT ( DoomLevel *level, const sRejectOptions &options, const sBlockMapOptions &blockMapOptions)
{
    FUNCTION_ENTRY ( NULL, "CreateREJECT", true );

    if (( options.Force == false ) && ( FeaturesDetected ( level ) == true )) {
        return true;
    }

    int noSectors = level->SectorCount ();
    if ( options.Empty ) {
        level->NewReject ((( noSectors * noSectors ) + 7 ) / 8, GetREJECT ( level, true ));
        return false;
    }

    PrepareREJECT ( noSectors );
    CopyVertices ( level );

    // Make sure we have something worth doing
    if ( SetupLines ( level )) {

        // Set up a scaled BLOCKMAP type structure
        PrepareBLOCKMAP ( level, blockMapOptions );

        // Make a list of which sectors contain others and their boundary lines
        sSector *sector = CreateSectorInfo ( level );

        // Mark the easy ones visible to speed things up later
        EliminateTrivialCases ( sector, noSectors );

        bool bUseGraphs = options.UseGraphs;

        int **distanceTable = NULL;

        if ( NeedDistances ( options.rmb ) == true ) {
            distanceTable = CreateDistanceTable ( sector, noSectors );
            ApplyDistanceLimits ( options.rmb, noSectors, distanceTable );
        }

        maxMapDistance = FindMaxMapDistance ( options.rmb );

        // Initialize globals used to test line pairs
        testLines  = new sSolidLine * [ noSolidLines ];
        polyPoints = new const sPoint * [ 2 * ( noSolidLines + 2 )];

        // Create a map that can be used to reorder lines more efficiently
        sSector **sectorList = new sSector * [ noSectors ];
        for ( int i = 0; i < noSectors; i++ ) sectorList [i] = &sector [i];

        Status ( (char *) "Working..." );

        if ( bUseGraphs == true ) {

            // Method 1: Use graphs to reduce things down
            InitializeGraphs ( sector, noSectors );

            // Try to order lines to maximize our chances of culling child sectors
            qsort ( sectorList, noSectors, sizeof ( sSector * ), SortSector );

            for ( int i = 0; i < noSectors; i++ ) {
                UpdateProgress ( 1, 100.0 * ( double ) i / ( double ) noSectors );
                ProcessSector ( sectorList [i] );
            }

            delete [] graphTable.graph;
            delete [] graphTable.sectorPool;

        } else {

            // Method 2: Down and dirty - check everything

            // Try to order lines to maximize our chances of culling child sectors
            qsort ( sectorList, noSectors, sizeof ( sSector * ), SortSector );

            sTransLine **lineMap = new sTransLine * [ noTransLines ];
            int lineMapSize = SetupLineMap ( lineMap, sectorList, noSectors );

            int done  = 0;
            int total = noTransLines * ( noTransLines - 1 ) / 2;
            double nextProgress = 0.0;

            // Now the tough part: check all lines against each other
            for ( int i = 0; i < lineMapSize; i++ ) {

                sTransLine *srcLine = lineMap [ i ];
                for ( int j = lineMapSize - 1; j > i; j-- ) {
                    sTransLine *tgtLine = lineMap [ j ];
                    if ( TestLinePair ( srcLine, tgtLine ) == true ) {
                        MarkPairVisible ( srcLine, tgtLine );
                    }
                }

                // Update the progress indicator to let the user know we're not hung
                done += lineMapSize - ( i + 1 );
                double progress = ( 100.0 * done ) / total;
                if ( progress >= nextProgress ) {
                    UpdateProgress ( 2, progress );
                    nextProgress = progress + 0.11;
                }
            }

            delete [] lineMap;
        }

        CleanUpBLOCKMAP ();

        // Clean up allocations we made
        delete [] sectorList;
        delete [] polyPoints;
        delete [] testLines;

        // Apply special RMB rules (now that all physical LOS calculations are done)
        ProcessOptionsRMB ( options.rmb, noSectors, distanceTable );

        // Clean up allocations made by CreateDistanceTable
        delete [] distanceTable;
        distanceTable = NULL;

        // Clean up allocations made by CreateSectorInfo
        delete [] neighborList;
        delete [] sectorLines;
        delete [] sector;
    }

    level->NewReject ((( noSectors * noSectors ) + 7 ) / 8, GetREJECT ( level, false ));

    // Clean up allocations made by SetupLines
    delete [] lineProcessed;
    delete [] checkLine;
    delete [] solidLines;
    delete [] transLines;
    delete [] indexToSolid;
    delete [] lineVisTable;

    // Delete our local copy of the vertices
    delete [] vertices;

    // Finally, release our reject table data
    CleanUpREJECT ( noSectors );

    return false;
}
