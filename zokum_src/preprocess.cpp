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
#include <cstring>

#include "endoom.hpp"

#include <algorithm>

// int CrossProduct(


void GeometryStatusLine(int orglines, int pairs) {

	char lines[128];
	char zokoutput[256];

	sprintf(lines, "%5d/%-5d", orglines - pairs, orglines);

	if (pairs) {
		sprintf(zokoutput, "       Geometry: %11s lines, reduced to: %3.2f%%",
		lines,
		100.0 * (float) ((orglines - pairs) / (float) orglines));
	} else {
		sprintf(zokoutput, "       Geometry: %11s lines, no reduction", lines);
	}
	Status( (char *) zokoutput);
}

void LineDefSpecialSpeedUpScroller (DoomLevel *level, int line, int speed)  {
	
	wLineDefInternal *lineDef = level->GetLineDefs();
	sMapExtraData *extraData = level->extraData;

	if (speed < 1) {
		speed = 1;
	}

	for (int j = 1; j < speed; j++) {
		level->AddLineDef();
		lineDef = level->GetLineDefs();

		int latestLine = level->LineDefCount() - 1;

		lineDef[latestLine].start = lineDef[line].start;
		lineDef[latestLine].end = lineDef[line].end;

		extraData->lineDefsCollidable 	[latestLine] = false;
		extraData->lineDefsRendered	[latestLine] = false;
		extraData->lineDefsSpecialEffect[latestLine] = true;

		lineDef [latestLine].tag = 0;
		lineDef [latestLine].type = 48;
		lineDef [latestLine].sideDef[LEFT_SIDEDEF] = lineDef [line].sideDef[LEFT_SIDEDEF];
		lineDef [latestLine].sideDef[RIGHT_SIDEDEF] = lineDef [line].sideDef[RIGHT_SIDEDEF];
		// printf("\n+vegg %d\n", line);
	}
}
float DistanceTwoPoints(int sx, int sy, int ex, int ey) {
	return sqrtf( pow(sx - ex, 2) + pow(sy - ey, 2));
}



void MapExtraData( DoomLevel *level, const sOptions *config) {
	const sBlockMapOptions options = config->BlockMap; //  sOptions

	char zokoutput[256];

	level->extraData = new sMapExtraData;
	sMapExtraData *extraData = level->extraData;

	const wSideDef *sideDef = level->GetSideDefs ();
	const wSector *sectors = level->GetSectors();

	// no longer const, since we change it
	wLineDefInternal *lineDef = level->GetLineDefs();
	const wVertex *vertex   = level->GetVertices();

	int numberOfLineDefs = level->LineDefCount();
	int numberOfSectors = level->SectorCount();

	extraData->multiSectorSpecial = false;


//	extraData->rightMostVertex = extraData->leftMostVertex = vertex [0].x;
//	extraData->bottomVertex = extraData->topVertex = vertex [0].y;



	extraData->rightMostVertex = extraData->topVertex = -32766;
	extraData->leftMostVertex = extraData->bottomVertex = 32767;

	


	// For simplicity we set them all to true, then to false if needed :)
	extraData->lineDefsCollidable = new bool [numberOfLineDefs];
	extraData->lineDefsRendered = new bool [numberOfLineDefs];
	extraData->lineDefsSegProperties = new int [numberOfLineDefs];
	extraData->lineDefsSpecialEffect = new bool [numberOfLineDefs];
	extraData->sectorsActive = new bool [numberOfSectors];

	int pairs = 0;
	int orglines = level->LineDefCount();

	sprintf(zokoutput, "GEOMETRY - Locating '998'-tag non-render lines.");
	Status( (char *) zokoutput);

	// Speed up animated walls by using the tag!


	for ( int i = 0; i < level->LineDefCount(); i++ ) {
		extraData->lineDefsCollidable[i] = true;


		if (lineDef [i].tag == 998) {
			extraData->lineDefsRendered[i] = false;
		} else {
			extraData->lineDefsRendered[i] = true;
		}

		if (lineDef [i].type == 1085) {
			extraData->lineDefsSegProperties[i] = 0x1;
		} else if (lineDef [i].type == 1084) {
			extraData->lineDefsSegProperties[i] = 0x2;
		} else if (lineDef [i].type == 1086) {
			extraData->lineDefsSegProperties[i] = 0x1 + 0x2;
		} else {
			extraData->lineDefsSegProperties[i] = 0x0;
		}

	}

	for (int i = 0; i < level->SectorCount(); i++) {
		if (sectors[i].special) {
			extraData->sectorsActive[i] = true;
		} else if (sectors[i].trigger) {
			extraData->sectorsActive[i] = true;	
		} else {
			extraData->sectorsActive[i] = false;
		}
	}	

	// now for the damn doors that are direct, tagless

	// printf("\n----\n");

	for ( int i = 0; i < level->LineDefCount(); i++ ) {
		bool active;

		switch (lineDef [i].type) {
			case 1:		// normal door
			case 26:	// blue door
			case 27:	// yellow door
			case 28: 	// red door
			case 31:	// d1
			case 32:	// d1 key
			case 33:	// d1 key
			case 34:	// d1 key
			case 117: 	// dr turbo
			case 118: {	// d1 turbo
					  active = true;
					  // printf("door at %d\n", i);
					  break;
				  }
			default: {
					 active = false;
					 break;
				 }
		}

		// aparently, this is the kind of trickery boom uses...
		if ((lineDef [i].type > 0x3C00) && (lineDef [i].type < 0x4000)) {
			active = true;
		}

		if (lineDef [i].sideDef[LEFT_SIDEDEF] == 0xffff) {
			continue;
		}

		int backSector = sideDef[lineDef [i].sideDef[LEFT_SIDEDEF]].sector ;

		if (active) {
			// printf("Sector %d active\n", backSector);
			extraData->sectorsActive[backSector] = true;
		}

	}







	/*
	   char lines[128];
	   sprintf(lines, "%5d/%-5d", orglines - pairs, orglines);

	   sprintf(zokoutput, "GEOMETRY - %11s lines      Reduced to: %3.2f%%",
	   lines,
	   100.0 * (float) ((orglines - pairs) / (float) orglines));
	   Status( (char *) zokoutput);
	   */
	GeometryStatusLine(orglines, pairs);


	// Check all linedefs and flag them as false if we don't
	// need to check for collisions.
	bool removenoncollidable = !options.IdCompatible && options.RemoveNonCollidable;


	// Custom new linedef types!
	for ( int i = 0; i < level->LineDefCount(); i++ ) {
		bool active;
		// some types, like 48 invalidate this one
		lineDef = level->GetLineDefs();

		bool flag = false;

		switch (lineDef [i].type) {
			case 48: // scrolling wall
				if (lineDef [i].tag > 1){
					LineDefSpecialSpeedUpScroller (level, i, lineDef[i].tag);
				}
				break;
			case 1048: // remote scrolling wall, use two last digits of a number
				if (lineDef [i].tag > 0) {
					// we find the closest wall, use start-vertex
					float distance = -1.0; // impossible value
					int nearest = -1;

					for ( int j = 0; j < level->LineDefCount(); j++ ) {
						if ((lineDef [j].tag == lineDef [i].tag) && (i != j)) {
							// Distance between start of one linedef to start of another
							float distanceNew = DistanceTwoPoints(
								vertex [ lineDef[i].start].x,
								vertex [ lineDef[i].start].y,
								vertex [ lineDef[j].start].x,
								vertex [ lineDef[j].start].y);
	
							// printf("\nDistance %f, %d\n", distanceNew, j);

							if ((distance < 0.0) || (distanceNew < distance)) {
								nearest = j;
								distance = distanceNew;
							}
						}
					}
					if (nearest != -1) {
						// We make the "nearest" same tagged line scroll at tag speed.
						LineDefSpecialSpeedUpScroller (level, nearest, lineDef [i].tag % 100);
						lineDef = level->GetLineDefs();
						lineDef [i].type = 48;
						lineDef [i].sideDef[RIGHT_SIDEDEF] = lineDef [nearest].sideDef[RIGHT_SIDEDEF];
						// printf("\nfound %d\n", nearest);
					}
				}
				break;
			case 1078: // Change start vertex of all with same tag to be same as this line. Make line non-render. Also copies sidedefs.
				flag = true;
			case 1079: // Change end vertex of all with same tag to be the same as this line. Make line non-render. Also copies sidedefs.
				for ( int j = 0; j < level->LineDefCount(); j++ ) {
					if (lineDef [j].tag == lineDef [i].tag) {
						if (flag) {
							lineDef [j].start = lineDef [i].start;
						} else {
							lineDef [j].end = lineDef [i].end;
						}
						lineDef [j].sideDef[0] = lineDef [i].sideDef[0];
						lineDef [j].sideDef[1] = lineDef [i].sideDef[1];
						
						extraData->lineDefsRendered     [j] = false;

					}

				}
				extraData->lineDefsCollidable	[i] = false;
				extraData->lineDefsRendered	[i] = false;
				
				break;


		}
	}


	if (options.GeometrySimplification) { // && (config->OutputWad || !config->WriteWAD )) {
		for ( int i = 0; i < level->LineDefCount(); i++ ) {
			sprintf(zokoutput, "GEOMETRY - Simplifying geometry %d of %d lines, found %d pairs.",
					i,
					level->LineDefCount(),
					pairs
			       );
			Status( (char *) zokoutput);

			if (extraData->lineDefsCollidable [i] == false) {
				continue;
			}

			for ( int inner = i + 1; inner < level->LineDefCount(); inner++ ) {

				if (!(
							(lineDef[i].end == lineDef[inner].start)
							|| (lineDef[i].end == lineDef[inner].end)
							|| (lineDef[i].start == lineDef[inner].start)
							|| (lineDef[i].start == lineDef[inner].end)
				     )) {
					continue;
				}

				if (extraData->lineDefsCollidable [inner] == false) {
					continue;
				}

				// Reduced form of cross product of two vectors in 3d.

				// A x B = (a2b3  -   a3b2,     a3b1   -   a1b3,     a1b2   -   a2b1) 

				int a1 = vertex [ lineDef[i].start].x - vertex [ lineDef[i].end].x;
				int a2 = vertex [ lineDef[i].start].y - vertex [ lineDef[i].end].y;

				int b1 = vertex [ lineDef[inner].start].x - vertex [ lineDef[inner].end].x;
				int b2 = vertex [ lineDef[inner].start].y - vertex [ lineDef[inner].end].y;

				if (((a1 * b2) - (a2 * b1)) != 0) {
					continue;
				}


				// Basic check to see if the lines have same amount of sides.

				if ((lineDef [i].sideDef[LEFT_SIDEDEF] != 65535) && (lineDef [inner].sideDef[LEFT_SIDEDEF] == 65535)) {
					continue;
				}
				if ((lineDef [i].sideDef[LEFT_SIDEDEF] == 65535) && (lineDef [inner].sideDef[LEFT_SIDEDEF] != 65535)) {
					continue;
				}
				if ((lineDef [i].sideDef[RIGHT_SIDEDEF] != 65535) && (lineDef [inner].sideDef[RIGHT_SIDEDEF] == 65535)) {
					continue;
				}
				if ((lineDef [i].sideDef[RIGHT_SIDEDEF] == 65535) && (lineDef [inner].sideDef[RIGHT_SIDEDEF] != 65535)) {
					continue;
				}

				// printf("\n %d %d\n", lineDef [i].sideDef[LEFT_SIDEDEF], lineDef [inner].sideDef[LEFT_SIDEDEF]);

				// if 2 sided, check if they belong to the same sectors
				//

				int geoLevel = options.GeometrySimplification;

				if (geoLevel == 1) {
					// In this level, must point to same sector

					if ((lineDef [i].sideDef[LEFT_SIDEDEF] != 65535) && (lineDef [inner].sideDef[LEFT_SIDEDEF] != 65535)) {

						int iSector = sideDef [lineDef [i].sideDef[LEFT_SIDEDEF]].sector;
						int innerSector = sideDef [lineDef [inner].sideDef[LEFT_SIDEDEF]].sector;

						if (iSector != innerSector) {
							continue;
						}

					}
					// same as prev, other side
					if ((lineDef [i].sideDef[RIGHT_SIDEDEF] != 65535) && (lineDef [inner].sideDef[RIGHT_SIDEDEF] != 65535)) {

						int iSector = sideDef [lineDef [i].sideDef[RIGHT_SIDEDEF]].sector;
						int innerSector = sideDef [lineDef [inner].sideDef[RIGHT_SIDEDEF]].sector;

						if (iSector != innerSector) {
							continue;
						}
					}
				} else if (geoLevel == 2) {
					// we know they have the same sidedness, 1 or 2, not a mix
					// if they are both 1-sided, let's merge!

					if (!((lineDef [i].sideDef[RIGHT_SIDEDEF] == 65535) || (lineDef [i].sideDef[LEFT_SIDEDEF] == 65535))) {
						continue;
					}

				}

				// we have two lindefs where one extends the other, add a new blockmap only linedef.			

				level->AddLineDef();
				pairs++;

				// This list has changed, we need the new one.
				lineDef = level->GetLineDefs();

				int latestLine = level->LineDefCount() - 1;

				// printf("new def: %d\n", latestLine);

				if (lineDef[i].start == lineDef[inner].end) {
					lineDef[latestLine].start = lineDef[inner].start;
					lineDef[latestLine].end = lineDef[i].end;
				} else {
					lineDef[latestLine].start = lineDef[i].start;
					lineDef[latestLine].end = lineDef[inner].end;
				}

				lineDef [latestLine].sideDef[RIGHT_SIDEDEF] = lineDef [i].sideDef[RIGHT_SIDEDEF];
				lineDef [latestLine].sideDef[LEFT_SIDEDEF] = lineDef [i].sideDef[LEFT_SIDEDEF];
				lineDef [latestLine].flags = lineDef [i].flags;
				lineDef [latestLine].type = lineDef [i].type;
				lineDef [latestLine].tag = lineDef [i].tag;

				extraData->lineDefsCollidable[latestLine] = true;
				extraData->lineDefsRendered[latestLine] = false;

				extraData->lineDefsCollidable[i] = false;
				extraData->lineDefsCollidable[inner] = false;
				/*
				   printf("Extending: LD %d and LD %d from %d(%d %d) to %d(%d %d) with new LD %d\n", 
				   i, 
				   inner, 

				   lineDef[latestLine].start, 
				   vertex [ lineDef[latestLine].start].x, 
				   vertex [ lineDef[latestLine].start].y, 

				   lineDef[latestLine].end, 
				   vertex [ lineDef[latestLine].end].x, 
				   vertex [ lineDef[latestLine].end].y,
				   latestLine 
				   );
				   */


				// add new virtual linedef 
				//
				// sleep(2);
				break;
			}
		}
		level->TrimLineDefs();

		/*
		   sprintf(lines, "%5d/%-5d", orglines - pairs, orglines);

		   sprintf(zokoutput, "GEOMETRY - %11s lines      Reduced to: %3.2f%%",
		   lines,
		   100.0 * (float) ((orglines - pairs) / (float) orglines));
		   Status( (char *) zokoutput);
		   */
		GeometryStatusLine(orglines, pairs);

	}

	// level->TrimLineDefs();

	// printf("Lines %d\n", level->LineDefCount());

	if (removenoncollidable) {
		// first we look for raising stairs and donuts
		for ( int i = 0; i < level->LineDefCount(); i++ ) {
			switch (lineDef [i].type) {
				case 9:
				case 8:
				case 127:
				case 100:
				case 7:
					// BOOM types
					// stairs
				case 258:
				case 256:
				case 259:
				case 257:
					// donuts
				case 146:
				case 155:
				case 191:

					extraData->multiSectorSpecial = true;
			}
			// Generalized check
			if ((lineDef [i].type >= 0x3000) && (lineDef [i].type <= 0x33FF)) {
				extraData->multiSectorSpecial = true;
			} 
		}

		if (options.autoDetectBacksideRemoval) {
			for ( int i = 0; i < level->LineDefCount(); i++ ) {

				// doom 2 map06 has crash doors :)
				if ((lineDef [i].flags & LDF_TWO_SIDED) == false) {
					continue;
				}

				if (lineDef [i].sideDef[LEFT_SIDEDEF] == 0xffff) {
					// printf("oops\n");
					continue;
				}

				if (lineDef [i].sideDef[RIGHT_SIDEDEF] == 0xffff) {
					continue;
				}

				if (lineDef [i].tag != 0) {
					continue;
				}
				if (lineDef [i].type != 0) {
					continue;
				}

				int backSector = sideDef [lineDef [i].sideDef[LEFT_SIDEDEF]].sector;
				//  sideDef [lineDef [i].sideDef[LEFT_SIDEDEF]].sector;
				// printf("sector: %d\n", backSector);

				if (extraData->sectorsActive[backSector]) {
					continue;
				}

				/*
				   if (sectors[backSector].trigger != 0) {
				   continue;
				   }

				   if (sectors[backSector].special != 0) {
				   continue;
				   }
				   */

				if (sectors[backSector].floorh == sectors[backSector].ceilh) {
					// printf("found one: %d\n", i);
					extraData->lineDefsSegProperties[i] = 0x01;	
				}


				// if (sectors[ ].floorh

				/*
				   for (int j = 0; j < level->SectorCount(); j++) {
				   if ((sideDef [lineDef [i].sideDef[LEFT_SIDEDEF]].sector) == j) {
				   if 

				   }
				   }
				   */

			}

		}


		for ( int i = 0; i < level->LineDefCount(); i++ ) {
			if ((lineDef [i].tag) == 999) {
				extraData->lineDefsCollidable[i] = false;
			} else if ((lineDef [i].flags & LDF_TWO_SIDED) 
					&& !(lineDef [i].flags & LDF_IMPASSABLE)  
					&& !(lineDef [i].flags & LDF_BLOCK_MONSTERS)
					&& (lineDef [i].type == 0)
					&& (lineDef [i].sideDef[LEFT_SIDEDEF] != 0xffff)
					&& (lineDef [i].sideDef[RIGHT_SIDEDEF] != 0xffff )

				  ) {



				int sectorL = sideDef [lineDef [i].sideDef[LEFT_SIDEDEF]].sector;
				int sectorR = sideDef [lineDef [i].sideDef[RIGHT_SIDEDEF]].sector;

				// map01 n doom2.wad has a linedef that partions a sector into two parts, but serves NO purpose
				if (sectorR == sectorL) {
					// printf("Linedef %d\n", i);
					extraData->lineDefsCollidable[i] = false;
				} else if (extraData->multiSectorSpecial == false) {

					// two sided linedef, without any action, same floor and ceiling
					if ((sectors[sectorL].floorh == sectors[sectorR].floorh) 
							&& (sectors[sectorL].ceilh == sectors[sectorR].ceilh)
							&& (sectors[sectorL].trigger == 0)
							&& (sectors[sectorR].trigger == 0)
							&& (sectors[sectorR].special != 10) // door like effects
							&& (sectors[sectorR].special != 14)
							&& (sectors[sectorL].special != 10)
							&& (sectors[sectorL].special != 14)
					   ) 

					{
						// printf("linedef optimization\n");
						extraData->lineDefsCollidable[i] = false;
					} 
				} 
			} 
		}

		// Remove boundary walls in sectors that have 0 height, not tagged, not a door.
		for (int i = 0; i < level->SectorCount(); i++) {

			// 0 height and no tag, only need to check for d? doors
			if ((sectors[i].floorh == sectors[i].ceilh) && (sectors[i].trigger == 0)) {
				bool direct = false;
				//printf("found 0-heigh sector %d\n", i);

				// Find all linedefs used by that sector
				for ( int j = 0; j < level->LineDefCount(); j++ ) {

					// RIGHT = FRONT
					// Find linedefs conncted to that sector
					if (lineDef [j].flags & LDF_TWO_SIDED) {

						if (lineDef [j].sideDef[LEFT_SIDEDEF] == 65535) {
							// printf("Error: 1-sided linedef %d flagged as 2-sided\n", j);
							continue;
						}

						if ((sideDef [lineDef [j].sideDef[LEFT_SIDEDEF]].sector) == i) {
							int s = lineDef[j].type;
							//printf(" checking for type %d on %d\n",s, j );
							if ((s == 1) || (s == 26) || (s == 27)  || (s == 28)
									|| (s == 31) || (s == 32) || (s == 33) || (s == 34) 
									|| (s == 117) || (s == 118)) {
								direct = true;
								// printf("found conv. door\n");
								break;
							}
						}

					}
				}
				if (!direct) {
					//printf("  found sky-sector %d\n", i);
					// remove all 1-sided linedefs belonging to that sector
					for ( int j = 0; j < level->LineDefCount(); j++ ) {
						if ((sideDef [lineDef [j].sideDef[RIGHT_SIDEDEF]].sector == i) 
								&& !(lineDef[j].flags & LDF_TWO_SIDED))  {
							extraData->lineDefsCollidable[j] = false;
							// printf("   found sky-sector linedef %d\n",j);
						}
					}
				}
			}
		}
	}
	// Loop through all linedefs, look at the starting vertex to find the left most and bottom
	for ( int i = 0; i < level->LineDefCount(); i++ ) {
		if ( (extraData->lineDefsCollidable[i] == false)) {
			// we use all blocking linedefs to make the block grid, not all vertexes.
			continue;
		}

		if ( vertex [ lineDef[i].start].x < extraData->leftMostVertex ) {
			extraData->leftMostVertex = vertex [ lineDef[i].start].x;
		}
		if ( vertex [ lineDef[i].start].x > extraData->rightMostVertex ) {
			extraData->rightMostVertex = vertex [lineDef[i].start].x;
		}
		if ( vertex [ lineDef[i].start].y < extraData->bottomVertex ) {
			extraData->bottomVertex = vertex [lineDef[i].start].y;
		}
		if ( vertex [ lineDef[i].start].y > extraData->topVertex ) {
			extraData->topVertex = vertex [ lineDef[i].start].y;
		}
	}
	}
	/*
	   INT16       xOff;                 
	   INT16       yOff;                 
	   char        text1[MAX_LUMP_NAME]; 
	   char        text2[MAX_LUMP_NAME]; 
	   char        text3[MAX_LUMP_NAME]; 
	   UINT16      sector;               
	 * */

	void CompressSideDefs(DoomLevel *level, const sOptions *config) {
		int sideDefs = level->SideDefCount();

		const wSideDef *sideDef = level->GetSideDefs ();

		int compressable = 0;

		bool alreadyCompressed[sideDefs];

		for ( int i = 0; i < (sideDefs); i++ ) {
			alreadyCompressed[i] = false;
		}

		for ( int i = 0; i < (sideDefs - 1); i++ ) {
			for (int j = i + 1; j < sideDefs; j++) {
				if (	
						(alreadyCompressed[i] == false) &&
						(sideDef [i].sector == sideDef [j].sector) && 
						(sideDef [i].xOff == sideDef [j].xOff) &&  
						(sideDef [i].yOff == sideDef [j].yOff) &&
						(strncmp( sideDef [i].text1, sideDef [j].text1, 8) == 0) &&
						(strncmp( sideDef [i].text2, sideDef [j].text2, 8) == 0) &&
						(strncmp( sideDef [i].text3, sideDef [j].text3, 8) == 0)
				   )
				{
					alreadyCompressed[j] = true;
					// printf("Compressable sidedef found %5d == %5d, sector %3d | %8.8s %8.8s | %8.8s %8.8s | %8.8s %8.8s\n", i, j, sideDef [i].sector, sideDef [i].text1, sideDef [j].text1, sideDef [i].text2, sideDef [j].text2, sideDef [i].text3, sideDef [j].text3);
					compressable++;
				}
			}

		}
		// printf("Sidedefs: %d of %d are compressable\n", compressable, sideDefs);

	}




