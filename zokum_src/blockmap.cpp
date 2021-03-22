//----------------------------------------------------------------------------
//
// File:        blockmap.cpp
// Date:        27.11.2016
// Programmer:  Kim Roar Foldøy Hauge, Marc Rousseau
//
// Description: This module contains the logic for the BLOCKMAP builder.
//
// Copyright (c) 2016 Kim Roar Foldøy Hauge. All Rights Reserved.
// Based on Marc Rousseau's ZenNode 1.2.0 blockmap.cpp
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

#include <math.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include "common.hpp"
#include "level.hpp"
#include "zennode.hpp"
#include "blockmap.hpp"
#include "console.hpp"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "endoom.hpp"

#include <algorithm>
#include "quicksort.hpp"


void AddLineDef ( sBlockList *block, int line ) {
	if (( block->count % 64 ) == 0 ) {
		int size = ( block->count + 64 ) * sizeof ( int );
		block->line = ( int * ) realloc ( block->line, size );
	}
	block->line [ block->count++ ] = line;

}

#define LDBX 1
#define LDBY 2

void UpdateLineDefBlocks(sBlockList *block, int blocks, int flags) {
	if (block->lineDefBlocks > blocks) {
		block->lineDefBlocks = blocks;
	}
	if (flags & LDBX) {
		if (block->lineDefBlocksX > blocks) {
			block->lineDefBlocksX = blocks;
		}
		block->lineDefBlocksY = 0;
	} else if (flags & LDBY) {
		if (block->lineDefBlocksY > blocks) {
			block->lineDefBlocksY = blocks;
		}
		block->lineDefBlocksX = 0;
	}
}

sBlockMap *GenerateBLOCKMAP ( DoomLevel *level, int xOffset, int yOffset, const sBlockMapOptions &options) {

	sBlockMap *blockMap = new sBlockMap;

	const wVertex *vertex   = level->GetVertices();
	const wLineDefInternal *lineDef = level->GetLineDefs();

	static int xLeft, xRight, yTop, yBottom;

	sMapExtraData *extraData = level->extraData;

	xLeft =  extraData->leftMostVertex - xOffset;
	xRight = extraData->rightMostVertex;
	yBottom = extraData->bottomVertex - yOffset;
	yTop = extraData->topVertex;

	int noCols = ( xRight - xLeft ) / 128 + 1;
	int noRows = ( yTop - yBottom ) / 128 + 1;
	int totalSize = noCols * noRows;

	sBlockList *blockList = new sBlockList [ totalSize ];
	for ( int i = 0; i < totalSize; i++ ) {
		blockList [i].firstIndex = i;
		blockList [i].offset     = 0;
		blockList [i].count      = 0;
		blockList [i].line       = NULL;
		blockList [i].uniqueLinedefs = 0;
		blockList [i].sharedLinedefs = 0;
		blockList [i].lineDefBlocks = 9999; // dummy value, will usually go down...
		blockList [i].lineDefBlocksX = 9999;
		blockList [i].lineDefBlocksY = 9999;
	}

	int startLinedef = 0;
/*
	if (options.ZeroHeaderStart || options.IdCompatible || options.ZeroHeaderEnd) {
		startLinedef = 1; // we don't need to add 0 twice :D
	} else {
		startLinedef = 0;
	}
*/
	if ((options.ZeroHeader == 1) || options.IdCompatible ) {
		// Add all the dummy linedef 0 "headers" to all blocks...
		// This matters for demo compability
		for (int dc = 0; dc != (noCols * noRows);  dc++) {
			AddLineDef ( &blockList [ dc ], 0 );
		}
	} 

	for ( int i = startLinedef; i < level->LineDefCount (); i++ ) {

		if (extraData->lineDefsCollidable[i] == false) {
			continue;
		}

		const wVertex *vertS = &vertex [ lineDef [i].start ];
		const wVertex *vertE = &vertex [ lineDef [i].end ];

		long x0 = vertS->x - xLeft;
		long y0 = vertS->y - yBottom;
		long x1 = vertE->x - xLeft;
		long y1 = vertE->y - yBottom;

		int startX = x0 / 128, startY = y0 / 128;
		int endX = x1 / 128, endY = y1 / 128;

		int index = startX + startY * noCols;

		int uniqueCounter = 1;

		if ( startX == endX ) {
			AddLineDef ( &blockList [ index ], i );

			int lineDefLength = abs(startY - endY) +1 ;
			UpdateLineDefBlocks( &blockList [ index ], lineDefLength, LDBY);

			if ( startY != endY ) {	// vertical line
				int dy = (( endY - startY ) > 0 ) ? 1 : -1;
				do {
					startY += dy;
					index  += dy * noCols;
					AddLineDef ( &blockList [ index ], i );
					UpdateLineDefBlocks( &blockList [ index ], lineDefLength, LDBY);
					uniqueCounter++;
				} while ( startY != endY );
			}
			if (uniqueCounter == 1) {
				blockList [ index ].uniqueLinedefs++;
			} 
		} else {
			if ( startY == endY ) {	// horizontal line
				AddLineDef ( &blockList [ index ], i );
				// bool unique = true;
				int dx = (( endX - startX ) > 0 ) ? 1 : -1;

				int lineDefLength = abs(startX - endX) +1 ;

				UpdateLineDefBlocks( &blockList [ index ], lineDefLength, LDBX);

				do {
					startX += dx;
					index  += dx;
					AddLineDef ( &blockList [ index ], i );
					UpdateLineDefBlocks( &blockList [ index ], lineDefLength, LDBX);
					uniqueCounter++; //  = false;

				} while ( startX != endX );
				if (uniqueCounter == 1) {
					blockList [ index ].uniqueLinedefs++;
				} 
			} else {			// diagonal line

				int dx = ( x1 - x0 );
				int dy = ( y1 - y0 );

				int sx = ( dx < 0 ) ? -1 : 1;
				int sy = ( dy < 0 ) ? -1 : 1;

				x1 *= dy;
				int nextX = x0 * dy;
				int deltaX = ( startY * 128 + 64 * ( 1 + sy ) - y0 ) * dx;

				bool done = false;
				int indexSave = index;

				int lineDefLength = abs(startY - endY) + abs(startX - endX) +1;

				do {
					int thisX = nextX;
					nextX += deltaX;
					if (( sx * sy * nextX ) >= ( sx * sy * x1 )) nextX = x1, done = true;

					int lastIndex = index + nextX / dy / 128 - thisX / dy / 128;

					AddLineDef ( &blockList [ index ], i );
					UpdateLineDefBlocks( &blockList [ index ], lineDefLength, 0);

					while ( index != lastIndex ) {
						index += sx;
						AddLineDef ( &blockList [ index ], i );
						UpdateLineDefBlocks( &blockList [ index ], lineDefLength, 0);
					}

					index += sy * noCols;
					deltaX = ( 128 * dx ) * sy;

				} while ( ! done );

				int lastIndex = endX + endY * noCols;
				if ( index != lastIndex + sy * noCols ) {
					AddLineDef ( &blockList [ lastIndex ], i );
					UpdateLineDefBlocks( &blockList [ index ], lineDefLength, 0);
				}

				if (lineDefLength == 1) {
					blockList [ indexSave ].uniqueLinedefs++;
				}

			}
		}
	}

	if (options.SubBlockOptimization) {
		for ( int i = 0; i < totalSize; i++ ) {
			blockList [i].sharedLinedefs = blockList [i].count - blockList [i].uniqueLinedefs;
		}
	}

	if (options.ZeroHeader == 2) {
		// Add all the dummy linedef 0 "headers" to all blocks...
		// This matters for demo compability
		for (int dc = 0; dc != (noCols * noRows);  dc++) {
			AddLineDef ( &blockList [ dc ], 0 );
		}
	}

	blockMap->xOrigin   = xLeft;
	blockMap->yOrigin   = yBottom;
	blockMap->noColumns = noCols;
	blockMap->noRows    = noRows;
	blockMap->data      = blockList;

	return blockMap;
}

bool DeleteBLOCKMAP (sBlockMap *blockMap, int blockListSize) {

	int totalSize = blockMap->noColumns * blockMap->noRows;
	sBlockList *blockList = blockMap->data;

	for ( int i = 0; i < totalSize; i++ ) {
		if ( blockList [i].line ) free ( blockList [i].line );
	}
	delete [] blockList;
	delete blockMap;
	return true;
}


void SubBlockFinder(sBlockList *block) {


	/*	for (int i = 0; i != blockList[i].count; i++) {

		}
		*/
}

void FindUnusedSpace(sBlockMap *blockmap, sBlockList *blockList) {

}

int CompareBlocks(sBlockList *blockList, int i, int existingIndex) {

	int count = blockList[i].count;
	int existingCount = blockList[existingIndex].count;
	// Older block comparison method, for regression testing.
#ifdef FALSE
	const void *mem1 = blockList[i].line;
	const void *mem2 = blockList[existingIndex].line;
	for (int offset = 0; (blockList[existingIndex].count >= (count + offset)) && squeeze ; offset = offset + sizeof(int)) {
		if (( blockList[existingIndex].count >= count + offset) &&
				( memcmp ( mem1, mem2 + offset, 1 * sizeof(int)	) == 0 ) &&
				( memcmp ( mem1, mem2 + offset, count * sizeof(int) ) == 0 ) 
		   ) {
			return offset;
		}
	}
#endif	

	// Due to this being a a very hot code path I have provided 5 codepaths. One for the generic 
	// case and 4 others for the 4 most common and smallest blockmap list sizes.
	if (count == existingCount) {
		if (count > 4) {
			const void *mem1 = blockList[i].line;
			const void *mem2 = blockList[existingIndex].line;
			if ( memcmp ( mem1, mem2, count * sizeof(int) ) == 0 ) {
				return 0;
			}
			return -1;
		} else if (count == 4) {
			if ((blockList[i].line[0] == blockList[existingIndex].line[0]) 
					&& (blockList[i].line[1] == blockList[existingIndex].line[1])
					&& (blockList[i].line[2] == blockList[existingIndex].line[2])
					&& (blockList[i].line[3] == blockList[existingIndex].line[3])) {
				return 0;
			}
		} else if (count == 3) {
			if ((blockList[i].line[0] == blockList[existingIndex].line[0]) 
					&& (blockList[i].line[1] == blockList[existingIndex].line[1])
					&& (blockList[i].line[2] == blockList[existingIndex].line[2])) {
				return 0;
			}
		} else if (count == 2) {
			if ((blockList[i].line[0] == blockList[existingIndex].line[0])
					&& (blockList[i].line[1] == blockList[existingIndex].line[1])) {
				return 0;
			}
		} else if (count == 1) {
			if (blockList[i].line[0] == blockList[existingIndex].line[0]) {
				return 0;
			}
		}
	}

	// This is an older version of the algorith, for regression and compability testing.
	// It is also used when blocks are of unequal size
	// int matches = 0;
	int offset = -1;

	for (int newBlockEntry = 0; newBlockEntry != count; newBlockEntry ++) {
		bool found = false;
		// for (int oldBlockEntry = 0; oldBlockEntry != existingCount; oldBlockEntry ++) {
		for (int oldBlockEntry = 0 /* newBlockEntry*/; oldBlockEntry != existingCount; oldBlockEntry ++) {
			if (blockList[i].line[newBlockEntry] == blockList[existingIndex].line[oldBlockEntry]) {
				found = true;
				break;
			} 
		}
		// }
		if (!found) {
			return -1;
		}
	}
	return 0;
}

// is the block inside the boundary box
inline bool BoundaryBoxCheck(sBlockMap *blockMap, int i, int index, int xCheck, int yCheck) {
	/*
	int xCheck; //  = blockList[i].lineDefBlocks;
	int yCheck; // = blockList[i].lineDefBlocks;

	// Des the block have horisontal linedefs
	if ((blockList[i].lineDefBlocksX != 9999) && blockList[i].lineDefBlocksX){
		// Does it also have vertical lines, if so no other blocks can match it.
		if ((blockList[i].lineDefBlocksY != 9999) && blockList[i].lineDefBlocksY)  {
			return false;

			// Horisontal lines, but no vertical lines. No need to check in Y-direction
		} else {
			yCheck = 0;
		}
		xCheck = blockList[i].lineDefBlocksX;
		// Does the block have vertical linedefs. We know it doesn't have horisontal ones
	} else if ((blockList[i].lineDefBlocksY != 9999) && blockList[i].lineDefBlocksY) {
		xCheck = 0;
		yCheck = blockList[i].lineDefBlocksY;

		// Only diagonal lines, fall back to check area compared from longest linedef.
	} else {
		xCheck = blockList[i].lineDefBlocks;
		yCheck = blockList[i].lineDefBlocks;
	}
	*/

	if ((abs((i % blockMap->noColumns ) - (index % blockMap->noColumns)) > xCheck)) {
		return false;
	}

	if (abs((i / blockMap->noColumns) - (index / blockMap->noColumns)) > yCheck) {
		return false;
	}
	return true;
}

int compare( const void *aa, const void  *bb);

void ProgressBar(char *, double, int, int);

int CreateBLOCKMAP ( DoomLevel *level, sBlockMapOptions &options ) {
	// Generate the data
	sBlockMap *blockMap = NULL;
	sBlockMap *oldBlockMap = NULL;;
	sBlockMap *bestBlockMap = NULL;

	int offsetXMax, offsetXMin, offsetYMax, offsetYMin, offsetIncreaseX, offsetIncreaseY;

	int bestX = -1;
	int bestY = -1;

	int blockSize, totalSize;
	int bestBlockSize = 1234568;

	int bestTotalSize = 99999999;
	int bestBlockListSize = 0;

	int blockListSize = 0, savings = 0 /*, bestSavings = 0*/;

	int oldBlockListSize = 0;

	int *bestLinedefArray = NULL;;

	sBlockList *blockList;
	sBlockList *bestBlockList = NULL;

	char zokoutput[256];

	// Stuff that works for all blockmaps, no matter what offset.
	sMapExtraData *extraData = level->extraData;

	bool eight;

	if (options.IdCompatible) {
		options.OffsetEight = true;
		options.SubBlockOptimization = false;
		options.ZeroHeader = 1;
	} 

	eight = options.OffsetEight;

	int bailout = 0;

	bool blockBig = options.blockBig;


	if (eight) {
		offsetXMax= 8;
		offsetXMin = 8;

		offsetYMax = 8;
		offsetYMin = 8;

		offsetIncreaseX = 8; // must be bigger than 0 :D
		offsetIncreaseY = 8;
	} else if (options.OffsetHeuristic) {
		offsetXMin = 0;
		offsetYMin = 0;

		offsetXMax= 127;
		offsetYMax= 127;

		offsetIncreaseX = 1;
		offsetIncreaseY = 1;

		int xSpan = (extraData->rightMostVertex - extraData->leftMostVertex) / 128 + 1;
		int ySpan = (extraData->topVertex - extraData->bottomVertex) / 128 + 1;

		if ( ((float) xSpan / (float) ySpan < 1.15) && ((float) xSpan / (float) ySpan > 0.85)) {
			// when maps are close to quadratic, we try all offsets.
			bailout = 0;
		} else {
			bailout = (xSpan + 1) * (ySpan + 1);
		}
	} else if (options.OffsetUser) {
		offsetXMax = options.OffsetCommandLineX;
		offsetXMin = options.OffsetCommandLineX;

		offsetYMax = options.OffsetCommandLineY;
		offsetYMin = options.OffsetCommandLineY;

		offsetIncreaseX = 8;
		offsetIncreaseY = 8;

	} else if (options.OffsetThirtySix) {
		offsetXMax = 48;
		offsetXMin = 0;

		offsetYMax = 48;
		offsetYMin = 0;

		offsetIncreaseX = 8;
		offsetIncreaseY = 8;
	} else if (options.OffsetBruteForce){
		offsetXMax= 127;
		offsetXMin = 0;

		offsetYMax = 127;
		offsetYMin = 0; 

		offsetIncreaseX = 1;
		offsetIncreaseY = 1;
	} else {
		offsetXMax= 0;
		offsetXMin = 0;

		offsetYMax = 0;
		offsetYMin = 0;

		offsetIncreaseX = 8; // must be bigger than 0 :D
		offsetIncreaseY = 8;
	}

	bool squeeze = options.SubBlockOptimization;

	int earlyExitSize = 90000000; // 90meg, well over the 65k limit

	for (int offsetY = offsetYMin; offsetY <= offsetYMax; offsetY += offsetIncreaseY) {

		bool compress = options.Compress;

		for (int offsetX = offsetXMin; offsetX <= offsetXMax; offsetX += offsetIncreaseX) {

			double progress = (double) offsetY / (double) offsetYMax + ((((double) offsetX / (double) offsetXMax)) / (double) offsetXMax    );

			if (!(offsetX % 8)) {

				if (bestBlockSize < 1234567) {
					sprintf(zokoutput, "Blockmap      %5dbytes ", bestBlockSize);
				} else {
					sprintf(zokoutput, "Blockmap      N/A bytes  ");
				}
				ProgressBar(zokoutput, progress, 35, 0);
			}

			if (bailout) {
				int xLeft =  extraData->leftMostVertex - offsetX;
				int xRight = extraData->rightMostVertex;
				int yBottom = extraData->bottomVertex - offsetY;
				int yTop = extraData->topVertex;

				int noCols = ( xRight - xLeft ) / 128 + 1;
				int noRows = ( yTop - yBottom ) / 128 + 1;

				if (bailout == ( noCols * noRows)) {
					break;
				}
			}

			// oldBlockListSize = blockListSize;
			// oldBlockMap = blockMap;
			blockMap = GenerateBLOCKMAP ( level, offsetX, offsetY, options);

			blockList = blockMap->data;

			// Count unique blockList elements
			totalSize = blockMap->noColumns * blockMap->noRows;

			blockListSize = 0;

			int i = -1;
			int minEntrySize = 0;
#ifdef _WIN32
			// TEMPORARY HACK TO GET THIS WORKING ON MSVC, NEED TO FIX
			// bool blockHasList[65535];
			int orderArray2[65535][2];
#else
			// bool blockHasList[totalSize];
			int orderArray2 [totalSize][2];
			// int *orderArray2[2] = new int [totalSize][2];
#endif

			int hashDifferences = 0;

			bool hashCheck;

			if (oldBlockMap 
					&& (oldBlockMap->noColumns == blockMap->noColumns) 
					&& (oldBlockMap->noRows == blockMap->noRows)
			   ) {
				hashCheck = true;
			} else {
				hashCheck = false;
			}

			for (int n = 0; n != totalSize; n++) {
				// blockHasList[n] = false;
				blockList[n].subBlockOffset = 0;

				orderArray2[n][0] = blockList[n].count;
				orderArray2[n][1] = n;

				blockList [n].hash = 0;
				if (blockList [n].count > 0 /* && !(options.SubBlockOptimization)*/ ) {
					for (int cnt = 0; cnt != blockList [n].count; cnt++) {
						blockList [n].hash += blockList [n].line[cnt];
					}
				}
				// if all new hashes == old hashes, abort early, same map..
				if (hashCheck && (blockList [n].hash != oldBlockMap->data [n].hash )) {
					hashCheck = false;
					// hashDifferences++;
				} 

			}

			if (hashCheck /*&& !hashDifferences*/) {
				DeleteBLOCKMAP (blockMap, blockListSize);
				continue;
			}

			std::qsort(orderArray2,totalSize,sizeof(orderArray2[0]),compare);

			for (int entry = totalSize - 1; entry > -1; entry--) {
				i = orderArray2[entry][1];
				if ((blockList [i].uniqueLinedefs == 0) && compress) {
					if (blockList [i].count) {
						bool newBlock = true;

						int xCheck; //  = blockList[i].lineDefBlocks;
						int yCheck; // = blockList[i].lineDefBlocks;

						// Does the block have horisontal linedefs
						if ((blockList[i].lineDefBlocksX != 9999) && blockList[i].lineDefBlocksX) {
							// Does it also have vertical lines, if so no other blocks can match it.
							if ((blockList[i].lineDefBlocksY != 9999) && blockList[i].lineDefBlocksY) {
								return false;
								// Horisontal lines, but no vertical lines. No need to check in Y-direction
							} else {
								yCheck = 0;
							}
							xCheck = blockList[i].lineDefBlocksX;
							// Does the block have vertical linedefs. We know it doesn't have horisontal ones
						} else if ((blockList[i].lineDefBlocksY != 9999) && blockList[i].lineDefBlocksY) {
							xCheck = 0;
							yCheck = blockList[i].lineDefBlocksY;

							// Only diagonal lines, fall back to check area compared from longest linedef.
						} else {
							xCheck = blockList[i].lineDefBlocks;
							yCheck = blockList[i].lineDefBlocks;
						}

						for (int entry2 = totalSize - 1; entry2 > entry; entry2--) {
							int index = orderArray2[entry2][1];

							if (BoundaryBoxCheck(blockMap, i, index, xCheck, yCheck) == false) {
								continue;
							}

							if (squeeze) {
								if (blockList[i].count > (blockList[index].sharedLinedefs)) {
									continue;
								} 
								if (blockList[i].count == blockList[index].count) {
									if (blockList[i].hash != blockList[index].hash) {
										continue;
									}
								}
								// the hash is the sum of all linedef values
								if (blockList[i].hash > blockList[index].hash) {
									continue;
								}
							} else if (blockList[i].hash != blockList[index].hash) {
								continue;
							} else if (blockList[i].count != blockList[index].count) {
								continue;
							}
							if (CompareBlocks(blockList, i, index) == 0) {
								blockList[i].firstIndex = index;
								newBlock = false;
								break;
							}
						}
						if (!newBlock) {
							continue;
						}
					} else { // we switch to handling empty blocks only
						blockList [i].firstIndex = -1;

						for (int element = entry -1; element > -1; element--) {
							i = orderArray2[element][1];
							blockList [i].firstIndex = -1;
						}
						break;
					}
				}

				sBlockList *block = &blockList [i];
				blockList [i].firstIndex = i;
				blockListSize += 1 + blockList [i].count;
				// blockHasList[i] = true;
				if (earlyExitSize < (blockListSize + totalSize)) {
					break;
				}
			}
			// is the new blockmap smaller?

			if (blockBig) {
				blockSize = sizeof ( wBlockMap32 ) + totalSize * sizeof ( INT32 ) + blockListSize * sizeof ( INT32 );
			} else {
				blockSize = sizeof ( wBlockMap ) + totalSize * sizeof ( INT16 ) + blockListSize * sizeof ( INT16 );
			}

			// Is the new blockmap smaller than the old best one?
			if (bestBlockSize > blockSize) {
				earlyExitSize = blockListSize + totalSize;
				if (bestBlockMap) {
					DeleteBLOCKMAP (bestBlockMap, bestBlockListSize /*, bestBlockList, offset, bestTotalSize*/);
				}

				if (bestLinedefArray) {
					delete [] bestLinedefArray;
				}
				bestLinedefArray = new int[totalSize];

				for (int j = 0; j != totalSize; j++) {
					bestLinedefArray[j] = orderArray2[j][1];
				}

				// delete [] orderArray2;

				// bestSavings = savings;
				bestTotalSize = totalSize;
				bestX = offsetX;
				bestY = offsetY;
				bestBlockMap = blockMap;
				bestBlockList = blockList;
				bestBlockSize = blockSize;
				bestBlockListSize = blockListSize;
			} else { // new blockmap was bigger, discard it.
				if (oldBlockMap) {
					DeleteBLOCKMAP (oldBlockMap, oldBlockListSize);
				}
				oldBlockListSize = blockListSize;
				oldBlockMap = blockMap;
				blockMap = NULL;
			}
		}
	}
	if (oldBlockMap) {
		DeleteBLOCKMAP (oldBlockMap, oldBlockListSize);
	}

	blockMap = bestBlockMap;
	blockList  = bestBlockList;
	// blockListSize = bestBlockListSize;
	blockSize = bestBlockSize;
	totalSize = bestTotalSize;
	// savings = bestSavings;

	// delete [] extraData->lineDefsUsed;
	// delete extraData;

	Status ( (char *)"Blockmap   Now saving... " );

	char *start = new char [ blockSize];

	wBlockMap *map = ( wBlockMap * ) start;
	wBlockMap32 *map32 = ( wBlockMap32 * ) start;

	if (blockBig) {
		map32->xOrigin   = ( INT32 ) blockMap->xOrigin;
		map32->yOrigin   = ( INT32 ) blockMap->yOrigin;
		map32->noColumns = ( UINT32 ) blockMap->noColumns;
		map32->noRows    = ( UINT32 ) blockMap->noRows;
	} else {
		map->xOrigin   = ( INT16 ) blockMap->xOrigin;
		map->yOrigin   = ( INT16 ) blockMap->yOrigin;
		map->noColumns = ( UINT16 ) blockMap->noColumns;
		map->noRows    = ( UINT16 ) blockMap->noRows;
	}

	// Fill in data & offsets
	UINT16 *offset /* = ( UINT16 * ) ( map + 1 )*/;
	UINT16 *data   /*= offset + totalSize*/;

	UINT32 *offset32 /*= ( UINT32 * ) ( map32 + 1 )*/;
	UINT32 *data32   /*= offset32 + totalSize*/;

	int j = 0;
	int val = 0;

	if (blockBig) {
		offset32 = ( UINT32 * ) ( map32 + 1 );
		data32   = offset32 + totalSize;
	} else {
		offset = ( UINT16 * ) ( map + 1 );
		data   = offset + totalSize;
	}

	// write and compute savings :)

	savings = 0;

	bool errors = false;

	for ( int n = 0; n < totalSize; n++ ) {
		int i = bestLinedefArray[totalSize - n - 1];

		sBlockList *block = &blockList [i];

		if ( block->firstIndex == i ) {
			if (blockBig) {
				block->offset = data32 - ( UINT32 * ) start;
				blockList [i].offset = data32 - ( UINT32 * ) start;
			} else {
				block->offset = data - ( UINT16 * ) start;
				blockList [i].offset = data - ( UINT16 * ) start;
			}

			for ( int x = 0; x < block->count; x++ ) {
				if (blockBig) {
					*data32++ = ( UINT32 ) block->line [x];
				} else {
					*data++ = ( UINT16 ) block->line [x];
				}
			}
			if (blockBig) {
				*data32++ = ( UINT32 ) -1;
			} else {
				*data++ = ( UINT16 ) -1;
			}

			if (!blockBig && (blockList [i].offset > 0xFFFF )) {
				errors = true;
			}

		} else if (block->firstIndex == -1) {

			if (blockBig) {
				block->offset = blockList [ bestLinedefArray[totalSize- 1]].offset + blockList[bestLinedefArray[totalSize- 1] ].count;
			} else {
				block->offset = blockList [ bestLinedefArray[totalSize- 1]].offset + blockList[bestLinedefArray[totalSize- 1] ].count;
			}
			savings++;
		} else {
			if (blockBig) {
				block->offset = blockList [ block->firstIndex ].offset;
			} else {
				block->offset = blockList [ block->firstIndex ].offset;
			}
			savings = savings + blockList[i].count + 1;
		}
		/*if ( blockList [i].offset > 0xFFFF ) {
		  errors = true;
		  }*/
		if (blockBig) {
			offset [i] = ( UINT32 ) blockList [i].offset;
		} else {
			offset [i] = ( UINT16 ) blockList [i].offset;
		}

		if ( blockList [i].line ) {
			free ( blockList [i].line );
		}
	}
	/*
	   for(int k = 0 ; k != blockSize; k++) {
	   printf("%d, ", (signed) start[k]);
	   }
	   printf("\n");
	   */

	/*
	   if (squeeze) {
	   for ( int n = 0; n < totalSize; n++ ) {
	   sBlockList *block = &blockList [n];
	   block->offset += block->subBlockOffset;
	   }
	   }
	   */


	if (options.HTMLOutput) {
		HTMLOutput(map, blockMap, blockList, options, blockSize, savings, totalSize);
	}
	if (blockBig) {
		level->NewBlockMapBig ( blockSize, map32 );
	} else {
		level->NewBlockMap ( blockSize, map );
	}

	delete [] blockList;
	delete blockMap; 
	delete [] bestLinedefArray;

	if ( errors == true ) {
		delete [] start;
		return -1;
	}

	// testing, do not use in prod!
	// MakeENDOOMLump();

	if (blockBig) {
		return savings * sizeof ( INT32 );
	} else {
		return savings * sizeof ( INT16 );
	}
}

void HTMLOutput(wBlockMap *map, sBlockMap *blockMap, sBlockList *blockList, const sBlockMapOptions &options, int blockSize, int savings, int totalSize) {
	int grid = map->noColumns * map->noRows * sizeof(UINT16);
	int lists = blockSize - grid - 8;
	int idSize = grid + savings + grid * 2 + lists;
	//	int val = 0;

	char *start = new char [ blockSize];

	UINT16 *offset = ( UINT16 * ) ( map + 1 );
	UINT16 *data   = offset + totalSize;

	printf("\n<html><head>");
	printf("<style>");
	printf(".count99 {background-color: #000000; color: #fff;}");
	printf(".count1 {background-color: #000000; color: #060;}");
	printf(".count2 {background-color: #000000; color: #0a0;}");
	printf(".count3 {background-color: #000000; color: #0d0;}");
	printf(".count4 {background-color: #000000; color: #0f0;}");
	printf(".count5 {background-color: #000000; color: #4f0;}");
	printf(".count6 {background-color: #000000; color: #8f0;}");
	printf(".count7 {background-color: #000000; color: #bf0;}");
	printf(".count8 {background-color: #000000; color: #ff0;}");
	printf(".count9 {background-color: #000000; color: #fb0;}");
	printf(".count10 {background-color: #000000; color: #f80;}");
	printf(".count11 {background-color: #000000; color: #f40;}");
	printf(".count12 {background-color: #000000; color: #f00;}");
	printf(".count13 {background-color: #000000; color: #f04;}");
	printf(".count14 {background-color: #000000; color: #f08;}");
	printf(".count15 {background-color: #000000; color: #f0b;}");
	printf(".count16 {background-color: #000000; color: #f0f;}");
	printf(".count17 {background-color: #000000; color: #80f;}");
	printf(".count18 {background-color: #000000; color: #40f;}");




	printf("tr,table {border: 0px; border-collapse: collapse; padding: 0px; margin: 0px;} td {border-spacing: 0px; border: 1px solid black; padding: 0px; margin: 0px; width: 33px; height: 33px;}</style></head>");
	printf("<body><hr><pre><table width=900px;><tr><td colspan=2><h1>Map00</h1></td></tr><tr><td><h2>Size: %d</h2>Header: 8 bytes, grid: %d, lists: %d<br/>IdBSP size: ~%d bytes</td>", blockSize, grid, lists, idSize);
	printf("<td><h2>Geometry</h2>X-origin: %d. Y-origin: %d.<br/>\nColumns: %d, rows: %d, ratio %1.3f, cells: %d</td></tr></table>\n\n", map->xOrigin, map->yOrigin, map->noColumns, map->noRows, (float) map->noColumns / (float) map->noRows, map->noColumns * map->noRows);
	// printf("Block grid size: %ld bytes<br/>\n", map->noColumns * map->noRows * sizeof(UINT16));


	printf("<table>\n");

	/*	int size = 8;
		size = size + map->noColumns * map->noRows;
		*/
	for (int rows = blockMap->noRows - 1; rows != -1; rows--) {
		printf(" <tr>\n  ");
		for (int cols = 0; cols != blockMap->noColumns; cols++) {

			int j = rows * blockMap->noColumns + cols;

			sBlockList *block = &blockList [j];

			// val = (data - ( UINT16 * ) start) * 2;

			int styleCount = 0;

			if (block->count == 0) {
				styleCount = 0;
			}
			else if (block->count == 1) { styleCount = 1;}
			else if (block->count == 2) { styleCount = 2;}
			else if (block->count == 3) { styleCount = 3;}
			else if (block->count == 4) { styleCount = 4;}
			else if (block->count == 5) { styleCount = 5;}
			else if (block->count <= 7) { styleCount = 6;}
			else if (block->count <= 10) { styleCount = 7;}
			else if (block->count <= 13) { styleCount = 8;}
			else if (block->count <= 16) { styleCount = 9;}
			else if (block->count <= 20) { styleCount = 10;}
			else if (block->count <= 25) { styleCount = 11;}
			else if (block->count <= 30) { styleCount = 12;}
			else if (block->count <= 35) { styleCount = 13;}
			else if (block->count <= 45) { styleCount = 14;}
			else if (block->count <= 55) { styleCount = 15;}
			else if (block->count <= 68) { styleCount = 16;}
			else if (block->count <= 80) { styleCount = 17;}
			else if (block->count <= 100) { styleCount = 18;}
			else {
				styleCount = 99;
			}

			printf("<td class=\"count%d\">", styleCount);
			if (block->count != 0) {
				printf("%5x", block->offset * 2);
			} else {
				printf("&nbsp;    ");
			}
			printf("</td>");

			/*if ((j % map->noColumns) == (map->noColumns -1)) {
			  printf("\n </tr>\n <tr>\n");

			  }*/
		}
		printf("\n </tr>\n");
		// printf("</tr>\n");
	}
	printf("</table>\n");
	printf("</pre></body></html>\n");
}
