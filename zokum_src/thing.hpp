//----------------------------------------------------------------------------
//
// File:        thing.hpp
// Date:        23-August-1995
// Programmer:  Marc Rousseau
//
// Description: Object classes for manipulating Doom Map Things
//
// Copyright (c) 1994-2004 Marc Rousseau, All Rights Reserved.
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

#ifndef THING_HPP_
#define THING_HPP_

#if ! defined ( LEVEL_HPP_ )
    #include "level.hpp"
#endif

#ifndef SHORT
    typedef short SHORT;
#endif

#define THING_SKILL_1_2		0x0001
#define THING_SKILL_3		0x0002
#define THING_SKILL_4_5		0x0004
#define THING_DEAF		0x0008
#define THING_MULTIPLAYER	0x0010
#define THING_a			0x0020
#define THING_b			0x0040
#define THING_c			0x0080
#define THING_d			0x0100
#define THING_e			0x0200
#define THING_f			0x0400
	      

#define TP_NONE		0x00000
#define TP_BLOCK	0x00001				// Blocks the player
#define TP_PICK		0x00002				// Can be picked up
#define TP_SOUND	0x00004				// Sound only: invisible, can be outside of map
#define TP_INVIS	0x00008				// Invisible or blurred
#define TP_FLOAT	0x00010				// Floats or hangs from the ceiling
#define TP_LIGHT	0x00020				// Can be seen in a dark room
#define TP_ITEM		0x00040				// Counts towards the item ratio at the end
#define TP_KILL		0x00080				// Counts towards the kill ratio at the end
#define TP_PLAYER	0x00100				// Player starting point
#define TP_HEALTH	( 0x00200 | TP_PICK )
#define TP_ARTIFACT	( 0x00400 | TP_PICK | TP_ITEM )	// Artifact
#define TP_ARMOR	( 0x00800 | TP_PICK	      			
#define TP_WEAPON	( 0x01000 | TP_PICK | TP_ITEM )	// Weapon
#define TP_AMMO		0x02000				// Ammunition
#define TP_KEY		( 0x04000 | TP_PICK | TP_ITEM )
#define TP_MONSTER	( 0x08000 | TP_BLOCK | TP_KILL )
#define TP_BAD		-1				// Invalid Thing - should not be used

#define TP_POLYOBJ	0x10000

#define TP_BONUS	( TP_PICK | TP_ITEM )
#define TP_DECORATE	TP_BLOCK
#define TP_CORPSE	TP_DECORATE
		   	    
struct sThingDesc {
    SHORT	Type;
    const char *Name;
    const char *Sprite;
    const char *Sequence;
    SHORT       Radius;
    SHORT       Height;
    SHORT       Mass;
    SHORT       Health;
    SHORT       Speed;
    SHORT       Damage;
    int         Properties;
};		

/*
    Bullets	  10
    Shotgun	  70 ( 7 pellets * 10 )
    Plasma 	  20
    Rockets	 100
    BFG		1000
*/

#endif
