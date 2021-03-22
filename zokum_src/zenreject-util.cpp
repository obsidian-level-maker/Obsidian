void DotGraph ( sGraph *graph )
{
    int maxMetric = 0;

    for ( int x = 0; x < graph->noSectors; x++ ) {
        if ( graph->sector [x]->metric > maxMetric ) maxMetric = graph->sector [x]->metric;
    }

    fprintf ( stderr, "digraph g {\n" );
    fprintf ( stderr, "\tsize = \"12,12\";\n" );
    fprintf ( stderr, "\tnode [shape=record];\n" );

    for ( int x = 0; x < graph->noSectors; x++ ) {
        sSector *sec1 = graph->sector [x];
        if ( sec1->graphParent != NULL ) fprintf ( stderr, "\t%d -> %d%s;\n", sec1->graphParent->index, sec1->index, ( sec1->loDFS < sec1->indexDFS ) ? " [color=green]" : "" );
        for ( int i = 0; i < sec1->noNeighbors; i++ ) {
            sSector *sec2 = sec1->neighbor [i];
            if ( sec1->graphParent == sec2 ) continue;
            if (( sec2->graphParent != sec1 ) && ( sec1->index > sec2->index )) fprintf ( stderr, "\t%d -> %d [color=red];\n", sec1->index, sec2->index );
        }
    }

    for ( int x = 0; x < graph->noSectors; x++ ) {
        sSector *sec = graph->sector [x];
        fprintf ( stderr, "\t%d [label=\"%d | { %d | %d | %d } | %d\"];\n", sec->index, sec->loDFS, sec->index, sec->indexDFS, sec->metric, sec->hiDFS );
    }

    fprintf ( stderr, "}\n" );

}

void NeatoGraph ( sGraph *graph )
{
    int maxMetric = 0;

    for ( int x = 0; x < graph->noSectors; x++ ) {
        if ( graph->sector [x]->metric > maxMetric ) maxMetric = graph->sector [x]->metric;
    }

    fprintf ( stderr, "graph g {\n" );
    fprintf ( stderr, "\tsize = \"12,12\";\n" );
    fprintf ( stderr, "\tnode [style=filled,fontcolor=white];\n" );

    for ( int x = 0; x < graph->noSectors; x++ ) {
        sSector *sec1 = graph->sector [x];
        for ( int i = 0; i < sec1->noNeighbors; i++ ) {
            sSector *sec2 = sec1->neighbor [i];
            if ( sec1->index < sec2->index ) fprintf ( stderr, "\t%d -- %d;\n", sec1->index, sec2->index );
        }
    }

    for ( int x = 0; x < graph->noSectors; x++ ) {
        sSector *sec = graph->sector [x];
        int color = ( maxMetric != 0 ) ? ( int ) ( 0xFF * sqrt (( double ) sec->metric / ( double ) maxMetric )) : 0;
        fprintf ( stderr, "\t%d [color=\"#%02X%02X%02X\"%s];\n", sec->index, color, 0, 0, ( color > 0x80 ) ? ",fontcolor=black" : "" );
    }

    fprintf ( stderr, "}\n" );

}

void DumpGraph ( sGraph *graph )
{
    fprintf ( stderr, "%08X:", graph );
    for ( int x = 0; x < graph->noSectors; x++ ) fprintf ( stderr, " %d", graph->sector [x]->index );
    fprintf ( stderr, "\n" );
}

void PrintGraph ( sGraph *graph )
{
    fprintf ( stderr, "%08X:\n", graph );

    int artCount = 0, childCount = 0;

    for ( int i = 0; i < graph->noSectors; i++ ) {
        sSector *sec = graph->sector [i];
        if ( sec->isArticulation == true ) artCount++;
        if ( sec->noChildren > 0 ) childCount++;
        fprintf ( stderr, " %4d(%4d-%4d,%4d,%7d)%s  %4d  %3d/%3d", sec->index, sec->loDFS, sec->indexDFS, sec->hiDFS, sec->metric, sec->isArticulation ? "*" : " ", sec->noChildren, sec->noActiveNeighbors, sec->noNeighbors );
        if ( sec->noActiveNeighbors == 2 ) {
            sSector *sec1 = sec->neighbor [0];
            sSector *sec2 = sec->neighbor [1];
            if (( sec1->isArticulation == true ) && ( sec2->isArticulation == true )) {
                fprintf ( stderr, " -step-" );
            }
        }
        while ( sec->parent != NULL ) {
            sec = sec->parent;
            fprintf ( stderr, "  %4d%s", sec->index, sec->isArticulation ? "*" : "" );
        }
        fprintf ( stderr, "\n" );
    }
    fprintf ( stderr, "                                     %4d   %3d\n", artCount, childCount );

    fprintf ( stderr, "\n" );
}

int CompareREJECT ( UCHAR *srcPtr, UCHAR *tgtPtr, int noSectors )
{
    FUNCTION_ENTRY ( NULL, "CompareREJECT", true );

    bool match = true;

    int **vis2hid = new int * [ noSectors ];
    int **hid2vis = new int * [ noSectors ];

    int *v2hCount = new int [ noSectors ];
    int *h2vCount = new int [ noSectors ];

    int bits = 8;
    int srcVal = *srcPtr++;
    int tgtVal = *tgtPtr++;
    int dif = srcVal ^ tgtVal;
    for ( int i = 0; i < noSectors; i++ ) {
        vis2hid [i] = new int [ noSectors ];
        hid2vis [i] = new int [ noSectors ];
        memset ( vis2hid [i], 0, noSectors * sizeof ( int ));
        memset ( hid2vis [i], 0, noSectors * sizeof ( int ));
        v2hCount [i] = 0;
        h2vCount [i] = 0;
        for ( int j = 0; j < noSectors; j++ ) {
            if ( dif & 1 ) {
                if ( srcVal & 1 ) {
                    hid2vis [i][h2vCount [i]++] = j;
                } else {
                    vis2hid [i][v2hCount [i]++] = j;
                }
                match = false;
            }
            if ( --bits == 0 ) {
                bits = 8;
                srcVal = *srcPtr++;
                tgtVal = *tgtPtr++;
                dif = srcVal ^ tgtVal;
            } else {
                srcVal >>= 1;
                tgtVal >>= 1;
                dif >>= 1;
            }
        }
    }

    bool first = true;
    for ( int i = 0; i < noSectors; i++ ) {
        if (( v2hCount [i] == 0 ) && ( h2vCount [i] == 0 )) continue;
        bool v2h = false;
        for ( int j = 0; j < v2hCount [i]; j++ ) {
            int index = vis2hid [i][j];
	    if (( v2hCount [i] > v2hCount [index] ) ||
	        (( v2hCount [i] == v2hCount [index] ) && ( i > index ))) {
	        v2h = true;
	        break;
	    }
	}
        bool h2v = false;
        for ( int j = 0; j < h2vCount [i]; j++ ) {
            int index = hid2vis [i][j];
	    if (( h2vCount [i] > h2vCount [index] ) ||
	        (( h2vCount [i] == h2vCount [index] ) && ( i > index ))) {
	        h2v = true;
	        break;
	    }
	}
        if ( v2h == true ) {
            if ( first == false ) printf ( "            " );
            printf ( "vis->hid %5d:", i );
            for ( int j = 0; j < v2hCount [i]; j++ ) {
                printf ( " %d", vis2hid [i][j] );
            }
            printf ( "\n" );
            first = false;
        }
        if ( h2v == true ) {
            if ( first == false ) printf ( "            " );
            printf ( "hid->vis %5d:", i );
            for ( int j = 0; j < h2vCount [i]; j++ ) {
                printf ( " %d", hid2vis [i][j] );
            }
            printf ( "\n" );
            first = false;
        }
    }

    if ( match == true ) printf ( "Perfect Match\n" );

    for ( int i = 0; i < noSectors; i++ ) {
        delete [] vis2hid [i];
        delete [] hid2vis [i];
    }
    
    delete [] vis2hid;
    delete [] hid2vis;

    delete [] v2hCount;
    delete [] h2vCount;

    return match ? 0 : 1;
}
