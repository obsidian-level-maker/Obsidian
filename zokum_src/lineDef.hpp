//----------------------------------------------------------------------------
//
// File:        lineDef.hpp
// Date:        23-August-1995
// Programmer:  Marc Rousseau
//
// Description: Object classes for manipulating Doom Map LineDefs
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

#ifndef LINEDEF_HPP_
#define LINEDEF_HPP_

#if ! defined ( LEVEL_HPP_ )
    #include "level.hpp"
#endif

// WAD LINEDEF Flags
#define LDF_IMPASSABLE		0x0001
#define LDF_BLOCK_MONSTERS	0x0002
#define LDF_TWO_SIDED		0x0004
#define LDF_UPPER_UNPEGGED	0x0008
#define LDF_LOWER_UNPEGGED	0x0010
#define LDF_SECRET		0x0020
#define LDF_BLOCK_SOUND		0x0040
#define LDF_NOT_ON_MAP		0x0080
#define LDF_ALREADY_ON_MAP	0x0100

enum LD_LINE_CLASS {
    LDC_NONE,			// "--"
    LDC_SPECIAL,		// "Special"
    LDC_DOOR,			// "Door"
    LDC_REMOTE,			// "Remote Door"
    LDC_CEILING,		// "Ceiling"
    LDC_LIFT,			// "Lift"
    LDC_FLOOR,			// "Floor"
    LDC_STAIRS,			// "Stairs"
    LDC_MOVE,			// "Moving Floor"
    LDC_CRUSH,			// "Crushing Ceiling"
    LDC_EXIT,			// "Exit"
    LDC_TELEPORT,		// "Teleporter"
    LDC_LIGHT,			// "Light"
    LDC_UNKNOWN,		// "???"
};

enum LD_LINE_SPEED {
    LDS_NONE,
    LDS_SLOW,
    LDS_MED,
    LDS_FAST,
    LDS_TURBO
};

enum LD_LINE_ACTION {
    LDA_NONE,
    LDA_SCROLL,
    LDA_OPEN,
    LDA_CLOSE,
    LDA_RAISE,
    LDA_LOWER,
    LDA_START,
    LDA_STOP,
    LDA_CHANGE,
    LDA_TELEPORT,
    LDA_END,
    LDA_END_SECRET
};

enum LD_LINE_EFFECTS {
    LDE_NONE		= 0x00000000,

    LDE_NEEDTAG		= 0x80000000,

    LDE_LOCK		= 0x40000000,

    LDE_MONSTER		= 0x20000000,
    LDE_MONSTER_ONLY	= 0x10000000,

    LDE_TRIGGER_MODEL	= 0x08000000,
    LDE_NUMERIC_MODEL	= 0x04000000,
    LDE_MODEL_MASK	= 0x0C000000,

    LDE_TX_TEXTURE	= 0x02000000,
    LDE_TX_SPECIAL	= 0x01000000,
    LDE_TX_MASK		= 0x03000000,

    LDE_MAX		= 0x00800000,
    LDE_MIN		= 0x00400000,

    LDE_MV_HIGHEST	= 0x00C00000,
    LDE_MV_NEXT_HIGHEST	= 0x00800000,
    LDE_MV_LOWEST	= 0x00400000,

    LDE_MV_SHORTEST	= 0x00300000,
    LDE_MV_FLOOR	= 0x00200000,
    LDE_MV_CEILING	= 0x00100000,

    LDE_MV_EXCLUSIVE	= 0x00080000,
    LDE_MV_INCLUSIVE	= 0x00040000,
			
    LDE_SLOW_HURT	= 0x00020000,
    LDE_FAST_HURT	= 0x00010000,
    LDE_CRUSH		= 0x00008000,
    LDE_SILENT		= 0x00004000,
    LDE_BLINKING	= 0x00002000,
			
    LDE_KEY_BLUE	= 0x00000C00,
    LDE_KEY_YELLOW	= 0x00000800,
    LDE_KEY_RED		= 0x00000400,
    LDE_KEY_MASK	= 0x00000C00,
				  
    LDE_MODIFIER_MASK	= 0x000003FF
};

#define LDE_TX		( LDE_TRIGGER_MODEL | LDE_TX_TEXTURE )
#define LDE_TXP		( LDE_TRIGGER_MODEL | LDE_TX_TEXTURE | LDE_TX_SPECIAL )
#define LDE_NXP		( LDE_NUMERIC_MODEL | LDE_TX_TEXTURE | LDE_TX_SPECIAL )
#define LDE_HE		( LDE_MV_HIGHEST | LDE_MV_EXCLUSIVE )
#define LDE_HEF		( LDE_MV_HIGHEST | LDE_MV_EXCLUSIVE | LDE_MV_FLOOR )
#define LDE_HEC		( LDE_MV_HIGHEST | LDE_MV_EXCLUSIVE | LDE_MV_CEILING )
#define LDE_LE		( LDE_MV_LOWEST | LDE_MV_EXCLUSIVE )
#define LDE_LEF		( LDE_MV_LOWEST | LDE_MV_EXCLUSIVE | LDE_MV_FLOOR )
#define LDE_LIC		( LDE_MV_LOWEST | LDE_MV_INCLUSIVE | LDE_MV_CEILING )
#define LDE_nhEF	( LDE_MV_NEXT_HIGHEST | LDE_MV_EXCLUSIVE | LDE_MV_FLOOR )
#define LDE_F		( LDE_MV_FLOOR )
#define LDE_NUM(x)	((x) & LDE_MODIFIER_MASK )
			
struct sLineDefDesc {
    INT16       Type;
    UINT8       Class;
    const char *Trigger;
    UINT8       Speed;
    UINT8       Duration;
    UINT8       Action;
    UINT32      Effects;

    const char *GetClass ();
    const char *GetDescription ();
};

#endif
