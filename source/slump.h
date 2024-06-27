/*
 * Copyright 2000 David Chess; Copyright 2005-2007 Sam Trenholme; Copyright 2021-2022 The OBSIDIAN Team
 *
 * Slump is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later
 * version.
 *
 * Slump is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Slump; see the file GPL.  If not, write to the Free
 * Software Foundation, 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Additionally, while not required for redistribution of this program,
 * the following requests are made when making a derived version of
 * this program:
 *
 * - Slump's code is partly derived from the Doom map generator
 *   called SLIGE, by David Chess.  Please inform David Chess of
 *   any derived version that you make.  His email address is at
 *   the domain "theogeny.com" with the name "chess" placed before
 *   the at symbol.
 *
 * - Please do not call any derivative of this program SLIGE.
 */

#pragma once

#include <stdint.h>
#include <stdio.h>

#include <string>
#include <vector>

bool slump_main(const std::string &filename);

/* Slump 0.003.02 */
#define SOURCE_VERSION    (0)
#define SOURCE_SERIAL     (003)
#define SOURCE_PATCHLEVEL (02)

/* Header file for things all slump files use */

/* Some Microsoft-specific defines which we will probably get rid of in
 * a later release */
#ifdef _MSC_VER
#define strncasecmp _strnicmp
#define strcasecmp  _stricmp
#endif

typedef unsigned char boolean;
#define SLUMP_TRUE  (1 == 1)
#define SLUMP_FALSE (!SLUMP_TRUE)
#define HUGE_NUMBER (1000000)

#define LEVEL_MAX_BARS     (30)
#define LEVEL_MAX_CRUSHERS (2)

#define TLMPSIZE(rows, columns) ((rows + 9) * columns + 8)

typedef unsigned char byte;

#ifdef OK_TO_USE_REAL_MONSTER_WIDTH
#define MONSTER_WIDTH(m) (m->width)
#else
#define MONSTER_WIDTH(m) (64)
#endif

/* Minimum room size on a level with teleports */
#define TELEPORT_MINROOMSIZE 256
/* Percentage change that a given level will have teleports */
#define TELEPORTS_PERCENT 30
/* The absolute minimum allowed light in a room */
#define ABSOLUTE_MINLIGHT 126

typedef unsigned long themebits; /* Bitarray, really */
/* So at most 32 themes in a config file */

typedef unsigned int gamebits; /* Also bitarray    */
#define DOOM0_BIT (0x01)
#define DOOM1_BIT (0x02)
#define DOOM2_BIT (0x04)
/* This is "clean" doom, with no "GROSS" items */
#define DOOMC_BIT (0x08)
/* "Intrinsic"; i.e. no SLUMP-special textures */
#define DOOMI_BIT   (0x10)
#define HERETIC_BIT (0x20)
#define CHEX_BIT    (0x40)
#define HACX_BIT    (0x80)
#define HARMONY_BIT (0x100)
#define STRIFE_BIT  (0x200)
#define REKKR_BIT   (0x400)
/* and that's all */

typedef unsigned long propertybits; /* Another bitarray */
#define FLOOR         (0x01)
#define CEILING       (0x02)
#define DOOR          (0x04)
#define ERROR_TEXTURE (0x08)
#define WALL          (0x10)
#define SUPPORT       (0x20)
#define NUKAGE        (0x40)
#define JAMB          (0x80)
#define RED           (0x100)
#define BLUE          (0x200)
#define YELLOW        (0x400)
#define GRATING       (0x800)
#define PLAQUE        (0x1000)
#define HALF_PLAQUE   (0x2000)
#define LIGHT         (0x4000)
#define BIG           (0x8000)
#define SWITCH        (0x10000)
#define OUTDOOR       (0x20000)
#define GATE          (0x40000)
#define EXITSWITCH    (0x80000)
#define STEP          (0x100000)
#define LIFT_TEXTURE  (0x200000)
#define VTILES        (0x400000)
/* and so on and so on; 32 may well not be enough! */

/* Some thing-only bits; corresponding bits above are texture/flat-only */
#define MONSTER  (0x01)
#define AMMO     (0x02)
#define HEALTH   (0x04)
#define WEAPON   (0x08)
#define PICKABLE (0x10)
#define SHOOTS   (0x20)
#define EXPLODES (0x40)
#define FLIES    (0x80)
#define BOSS     (0x100)
#define SPECIAL  (0x800)

typedef struct s_theme
{
    char           *name;
    boolean         secret;
    struct s_theme *next;
} theme, *ptheme;

typedef struct s_texture
{
    char              name[9];  /* Room for the eos */
    char             *realname; /* the DOOM name, in case the name name is an alias */
    gamebits          gamemask;
    themebits         compatible;
    themebits         core;
    propertybits      props;
    short             width;
    short             height;
    short             y_hint;
    short             y_bias; /* Y offset that a switch needs */
    struct s_texture *subtle;
    struct s_texture *switch_texture;
    boolean           used;
    struct s_texture *next;
} texture, *ptexture;

typedef struct s_flat
{
    char           name[9]; /* Room for the eos */
    gamebits       gamemask;
    themebits      compatible;
    propertybits   props;
    boolean        used;
    struct s_flat *next;
} flat, *pflat;

typedef struct s_linedef linedef, *plinedef;
typedef struct s_gate    gate, *pgate;

typedef struct s_link
{
    int            type;
    propertybits   bits;
    int            height1;    /* Basic height, or zero for "floor-to-ceiling" */
    int            width1;     /* Basic width, or zero for "wall-to-wall" */
    int            width2;     /* Width of the interalcove-passage, if any */
    int            depth1;     /* Depth of doors / arches (overall depth for OPEN) */
    int            depth2;     /* Depth of recess sectors */
    int            depth3;     /* Length (depth) of the core (if any) */
    int            floordelta; /* Far sector floorheight - near sector floorheight */
    int            stepcount;  /* Number of steps to slice depth3 into (minus one) */
    linedef       *cld;        /* The inner side of a twinned core, sometimes */
    struct s_link *next;
} link, *plink;

/* Values for link.type */
#define BASIC_LINK 1001
#define OPEN_LINK  1002
#define GATE_LINK  1003

/* Bits for link.bits */
#define LINK_NEAR_DOOR (0x01)
#define LINK_RECESS    (0x02)
#define LINK_ALCOVE    (0x04)
#define LINK_TWIN      (0x08)
#define LINK_CORE      (0x10)
#define LINK_LIFT      (0x20)
#define LINK_STEPS     (0x40)
/* LINK_WINDOW is used only if LINK_TWIN */
#define LINK_WINDOW      (0x80)
#define LINK_MAX_CEILING (0x100)
#define LINK_TRIGGERED   (0x200)
#define LINK_LAMPS       (0x400)
#define LINK_BARS        (0x800)
#define LINK_LEFT        (0x1000)
#define LINK_LOCK_CORE   (0x2000)
#define LINK_FAR_TWINS   (0x4000)
#define LINK_DECROOM     (0x8000)
#define LINK_FAR_DOOR    (0x10000)

#define LINK_ANY_DOOR (LINK_NEAR_DOOR | LINK_FAR_DOOR)

/* The kinds of things that there are */

typedef struct s_genus
{
    gamebits     gamemask;
    themebits    compatible;
    propertybits bits;
    short        thingid;
#define ID_PLAYER1 (0x0001)
#define ID_PLAYER2 (0x0002)
#define ID_PLAYER3 (0x0003)
#define ID_PLAYER4 (0x0004)
#define ID_DM      (0x000b)
#define ID_GATEOUT (0x000e)
/* The monsters */
#define ID_TROOPER    (0x0bbc)
#define ID_SERGEANT   (0x0009)
#define ID_IMP        (0x0bb9)
#define ID_PINK       (0x0bba)
#define ID_SPECTRE    (0x003a)
#define ID_COMMANDO   (0x041)
#define ID_NAZI       (0x054)
#define ID_SKULL      (0xbbe)
#define ID_HEAD       (0xbbd)
#define ID_SKEL       (0x042)
#define ID_ARACH      (0x044)
#define ID_MANCUB     (0x0043)
#define ID_HELL       (0x045)
#define ID_BARON      (0x0bbb)
#define ID_PAIN       (0x047)
#define ID_ARCHIE     (0x0040)
#define ID_CYBER      (0x10)
#define ID_SPIDERBOSS (0x07)
#define ID_BRAIN      (0x58)
/* The Heretic monsters (No ghosts - Dasho) */
#define ID_GARGOYLE      (0x42)
#define ID_FIREGARGOYLE  (0x05)
#define ID_GOLEM         (0x44)
#define ID_NITROGOLEM    (0x2D)
#define ID_OPHIDIAN      (0x5C)
#define ID_SABRECLAW     (0x5A)
#define ID_UNDEADWARRIOR (0x40)
#define ID_DISCIPLE      (0x0F)
#define ID_WEREDRAGON    (0x46)
#define ID_MAULOTAUR     (0x09)
#define ID_IRONLICH      (0x06)
#define ID_DSPARIL       (0x07)
/* The Hacx Monsters*/
#define ID_THUG          (0x0bbc)
#define ID_ANDROID       (0x0009)
#define ID_BUZZER        (0x0bba)
#define ID_STEALTHBUZZER (0x003a)
#define ID_HACXPHAGE     (0x0043)
#define ID_ICE           (0x0bb9)
#define ID_DMAN          (0xbbe)
#define ID_MAJONG7       (0x047)
#define ID_MONSTRUCT     (0x041)
#define ID_TERMINATRIX   (0x0bbb)
#define ID_THORNTHING    (0x044)
#define ID_MECHAMANIAC   (0x045)
#define ID_ROAMINGMINE   (0x054)
/* The Harmony Monsters */
#define ID_BEASTLING     (0x0bba)
#define ID_FOLLOWER      (0x9)
#define ID_MUTANTSOLDIER (0x41)
#define ID_PHAGE         (0x44)
#define ID_PREDATOR      (0x42)
#define ID_LANDMINE      (0xbbe)
#define ID_AEROSOL       (0xbbd)
#define ID_CENTAUR       (0x10)
#define ID_ECHIDNA       (0x7)
    short           width;
    short           height;
    int             min_level;     /* Minimum level to put monster in */
    float           ammo_to_kill[3];
    float           ammo_provides; /* For monsters / ammo / weapons */
    float           damage[3];     /* damage[0] will be health provided by HEALTHs */
    float           altdamage[3];
    boolean         marked;
    struct s_genus *next;
} genus, *pgenus;

// Doom weapons/ammo
#define ID_SHOTGUN  (0x7d1)
#define ID_SSGUN    (0x052)
#define ID_CHAINGUN (0x7d2)
#define ID_CHAINSAW (0x7d5)
#define ID_PLASMA   (0x7d4)
#define ID_BFG      (0x7d6)
#define ID_CLIP     (0x7d7)
#define ID_SHELLS   (0x7d8)
#define ID_BULBOX   (0x800)
#define ID_SHELLBOX (0x801)
#define ID_CELL     (0x7ff)
#define ID_CELLPACK (0x11)
#define ID_BACKPACK (0x08)
#define ID_LAUNCHER (0x7d3)
#define ID_ROCKET   (0x7da)
#define ID_ROCKBOX  (0x7fe)

// Heretic weapons/ammo
#define ID_GAUNTLETS      (0x7D5)
#define ID_CROSSBOW       (0x7D1)
#define ID_DRAGONCLAW     (0x035)
#define ID_PHOENIXROD     (0x7D3)
#define ID_HELLSTAFF      (0x7D4)
#define ID_FIREMACE       (0x7D2)
#define ID_WANDCRYSTAL    (0xA)
#define ID_CRYSTALGEODE   (0xC)
#define ID_ETHEREALARROWS (0x12)
#define ID_ETHEREALQUIVER (0x13)
#define ID_CLAWORB        (0x36)
#define ID_ENERGYORB      (0x37)
#define ID_LESSERRUNES    (0x14)
#define ID_GREATERRUNES   (0x15)
#define ID_FLAMEORB       (0x16)
#define ID_INFERNOORB     (0x17)
#define ID_MACESPHERES    (0xD)
#define ID_MACESPHEREPILE (0x10)

// Doom health/powerups
#define ID_STIMPACK (0x7DB)
#define ID_MEDIKIT  (0x7dc)
#define ID_POTION   (0x7de)
#define ID_SOUL     (0x7dd)
#define ID_BERSERK  (0x7e7)
#define ID_INVIS    (0x7e8)
#define ID_SUIT     (0x7e9)
#define ID_MAP      (0x7ea)

// Heretic health/powerups
#define ID_CRYSTALVIAL         (0x51)
#define ID_QUARTZFLASK         (0x52)
#define ID_MYSTICURN           (0x20)
#define ID_MAPSCROLL           (0x23)
#define ID_CHAOSDEVICE         (0x24)
#define ID_MORPHOVUM           (0x1E)
#define ID_RINGOFINVINCIBILITY (0x54)
#define ID_SHADOWSPHERE        (0x4B)
#define ID_TIMEBOMB            (0x22)
#define ID_TOMEOFPOWER         (0x56)
#define ID_TORCH               (0x21)

// Doom armor
#define ID_HELMET    (0x7df)
#define ID_BLUESUIT  (0x7e3)
#define ID_GREENSUIT (0x7e2)

// Heretic armor
#define ID_SILVERSHIELD    (0x55)
#define ID_ENCHANTEDSHIELD (0x1F)

// Doom keys
#define ID_BLUEKEY    (0x028)
#define ID_REDKEY     (0x026)
#define ID_YELLOWKEY  (0x027)
#define ID_BLUECARD   (0x0005)
#define ID_REDCARD    (0x00d)
#define ID_YELLOWCARD (0x006)

// Heretic keys
#define ID_HERETICBLUEKEY   (0x4F)
#define ID_HERETICYELLOWKEY (0x50)
#define ID_HERETICGREENKEY  (0x49)

// Doom decor
#define ID_LAMP       (0x07ec)
#define ID_ELEC       (0x030)
#define ID_TLAMP2     (0x055)
#define ID_LAMP2      (0x056)
#define ID_TALLBLUE   (0x002c)
#define ID_SHORTBLUE  (0x037)
#define ID_TALLGREEN  (0x02d)
#define ID_SHORTGREEN (0x038)
#define ID_TALLRED    (0x02e)
#define ID_SHORTRED   (0x039)
#define ID_CANDLE     (0x022)
#define ID_CBRA       (0x023)
#define ID_BARREL     (0x07f3)
#define ID_FBARREL    (0x0046)
#define ID_SMIT       (0x002f)
#define ID_TREE1      (0x002b)
#define ID_TREE2      (0x0036)

// Heretic decor
#define ID_POD          (0x7F3)
#define ID_SERPENTTORCH (0x1B)
#define ID_FIREBRAZIER  (0x4C)
#define ID_SMSTALAGMITE (0x25)
#define ID_LGSTALAGMITE (0x26)

// Hacx decor
#define ID_CEILINGLAMP     (0x02c)
#define ID_TALLCEILINGLAMP (0x02e)
#define ID_FLOORLAMP       (0x039)

/* The style is the dynamic architectural knowledge and stuff. */
/* It changes throughout the run.                              */
typedef struct s_style
{
    int      theme_number;
    flat    *floor0;
    flat    *ceiling0;
    flat    *ceilinglight;
    flat    *doorfloor;
    flat    *doorceiling;
    flat    *stepfloor;
    flat    *nukage1;
    texture *wall0;
    texture *switch0;
    texture *support0;
    texture *doorjamb;
    texture *widedoorface;
    texture *narrowdoorface;
    texture *twdoorface;   /* tall-wide */
    texture *tndoorface;   /* tall-narrow */
    texture *lockdoorface; /* can be NULL */
    texture *walllight;    /* Can be NULL */
    texture *liftface;     /* can be NULL */
    texture *kickplate;    /* At least 64 tall */
    texture *stepfront;    /* May be quite short */
    texture *grating;
    texture *plaque;
    texture *redface;
    texture *blueface;
    texture *yellowface;
    genus   *lamp0;
    genus   *shortlamp0;
    short    doorlight0;
    short    roomlight0;
    short    wallheight0;
    short    linkheight0;
    short    closet_width;
    short    closet_depth;
    short    closet_light_delta;
    /* Shouldn't all these booleans just be in a properties bitarray? */
    boolean moving_jambs;
    boolean secret_doors;   /* a silly thing */
    boolean soundproof_doors;
    boolean center_pillars;
    boolean paint_recesses; /* Put keycolors on recesses, not doors? */
    boolean lightboxes;     /* Ephemeral */
    boolean gaudy_locks;
    int     auxheight;      /* Height off the ground of lightboxes (etc) */
    short   auxspecial;     /* Special light thing for lightboxes (etc) */
    short   doortype;       /* Should be part of link? */
    short   slifttype;      /* part of link? */
    int     sillheight;     /* should be part of link? */
    int     windowheight;   /* part of link? */
    int     windowborder;   /* part of link? */
    boolean slitwindows;    /* part of link? */
    boolean window_grate;   /* part of link? */
    int     window_decor;   /* part of link? */
#define WINDOW_NORMAL  (5001)
#define WINDOW_JAMBS   (5002)
#define WINDOW_SUPPORT (5003)
#define WINDOW_LIGHT   (5004)
    int lightbox_lighting;
#define LIGHTBOX_NORMAL  (6001)
#define LIGHTBOX_LIGHTED (6002)
#define LIGHTBOX_DARK    (6003)
    boolean         light_recesses;
    boolean         light_steps;
    boolean         light_edges;
    boolean         peg_lightstrips;
    int             construct_family;
    boolean         do_constructs;
    link           *link0;
    struct s_style *next;
} style, *pstyle;

/* General linked list of textures, for constructs */
typedef struct s_texture_cell
{
    texture               *ptexture;
    boolean                marked;
    boolean                primary;
    short                  y_offset1;
    short                  y_offset2;
    short                  width;
    struct s_texture_cell *next;
} texture_cell, *ptexture_cell;

/* General linked list of flats */
typedef struct s_flat_cell
{
    flat               *pflat;
    struct s_flat_cell *next;
} flat_cell, *pflat_cell;

/* Things that are basically boxes with sides */
typedef struct s_construct
{
    gamebits            gamemask;
    themebits           compatible;
    int                 family; /* What general kind of thing is it? */
    short               height;
    texture_cell       *texture_cell_anchor;
    flat_cell          *flat_cell_anchor;
    boolean             marked;
    struct s_construct *next;
} construct, *pconstruct;

typedef struct s_thing
{
    short           x;
    short           y;
    short           angle;
    genus          *pgenus;
    short           options;
    short           number;
    struct s_thing *next;
} thing, *pthing;

/* These are sort of two-natured; they represent both sectors in the */
/* DooM-engine sense, and rooms.  Split the meanings someday. */
typedef struct s_sector
{
    short            floor_height;
    short            ceiling_height;
    flat            *floor_flat;
    flat            *ceiling_flat;
    short            light_level;
    short            special;
    short            tag;
    short            number;          /* Used only during dumping */
    style           *pstyle;          /* Style used to create it */
    boolean          marked;
    boolean          has_key;         /* Has a key been placed in here? */
    boolean          has_dm;          /* A DM start in here? */
    boolean          has_dm_weapon;   /* Any weapons in here yet in DM? */
    boolean          middle_enhanced; /* Already specially enhanced */
    gate            *pgate;
    short            entry_x, entry_y;
    boolean          findrec_data_valid;
    short            minx, miny, maxx, maxy;
    struct s_sector *next;
} sector, *psector;

typedef struct s_vertex
{
    short            x;
    short            y;
    short            number;
    boolean          marked;
    struct s_vertex *next;
} vertex, *pvertex;

typedef struct s_sidedef
{
    short             x_offset;
    short             x_misalign;
    short             y_offset;
    short             y_misalign;
    texture          *upper_texture;
    texture          *lower_texture;
    texture          *middle_texture;
    sector           *psector;
    short             number;
    boolean           isBoundary;
    struct s_sidedef *next;
} sidedef, *psidedef;

struct s_linedef
{
    vertex           *from;
    vertex           *to;
    short             flags;
    short             type; /* Ooh, could even have linedef-type-kind records! */
    short             tag;
    sidedef          *right;
    sidedef          *left;
    short             number;
    boolean           marked;
    boolean           f_misaligned;
    boolean           b_misaligned;
    struct s_linedef *group_next;     /* Used during texture-alignment */
    struct s_linedef *group_previous; /* A group gets aligned together */
    struct s_linedef *next;
}; /* linedef and plinedef defined above; gcc chokes if we do it again! */

/* Linedef flags */
#define IMPASSIBLE     (0x01)
#define BLOCK_MONSTERS (0x02)
#define TWO_SIDED      (0x04)
#define UPPER_UNPEGGED (0x08)
#define LOWER_UNPEGGED (0x10)
#define SECRET_LINEDEF (0x20)
#define BLOCK_SOUND    (0x40)
#define NOT_ON_MAP     (0x80)
#define ALREADY_ON_MAP (0x100)

/* Linedef types */
#define LINEDEF_NORMAL                   (0)
#define LINEDEF_NORMAL_DOOR              (1)
#define LINEDEF_NORMAL_S1_DOOR           (31)
#define LINEDEF_BLUE_S1_DOOR             (32)
#define LINEDEF_RED_S1_DOOR              (33)
#define LINEDEF_YELLOW_S1_DOOR           (34)
#define LINEDEF_S1_OPEN_DOOR             (103)
#define LINEDEF_S1_RAISE_STAIRS          (7)
#define LINEDEF_S1_LOWER_FLOOR           (23)
#define LINEDEF_SCROLL                   (48)
#define LINEDEF_TELEPORT                 (97)
#define LINEDEF_WR_OPEN_DOOR             (86)
#define LINEDEF_W1_OPEN_DOOR             (2)
#define LINEDEF_GR_OPEN_DOOR             (46)
#define LINEDEF_SR_OC_DOOR               (63)
#define LINEDEF_WR_OC_DOOR               (90)
#define LINEDEF_S1_END_LEVEL             (11)
#define LINEDEF_W1_END_LEVEL             (52)
#define LINEDEF_S1_SEC_LEVEL             (51)
#define LINEDEF_WR_FAST_CRUSH            (77)
#define LINEDEF_WR_LOWER_LIFT            (88)
#define LINEDEF_SR_LOWER_LIFT            (62)
#define LINEDEF_S1_RAISE_AND_CLEAN_FLOOR (20)
#define LINEDEF_S1_RAISE_FLOOR           (18)

// These aren't in Heretic
#define LINEDEF_WR_TURBO_LIFT       (120)
#define LINEDEF_SR_TURBO_LIFT       (123)
#define LINEDEF_S1_OPEN_DOOR_BLUE   (133)
#define LINEDEF_S1_OPEN_DOOR_RED    (135)
#define LINEDEF_S1_OPEN_DOOR_YELLOW (137)
#define LINEDEF_BLAZE_DOOR          (117)
#define LINEDEF_BLAZE_S1_DOOR       (118)
#define LINEDEF_S1_BLAZE_O_DOOR     (112)
#define LINEDEF_SR_BLAZE_OC_DOOR    (114)
#define LINEDEF_W1_SEC_LEVEL        (124)
#define LINEDEF_W1_RAISE_FLOOR      (119)

/* and so on and so on */

/* sector specials */
#define RANDOM_BLINK    (1)
#define SYNC_FAST_BLINK (0x0c)
#define SYNC_SLOW_BLINK (0x0d)
#define GLOW_BLINK      (0x08)
#define SECRET_SECTOR   (0x09)
#define NUKAGE1_SPECIAL (5)
#define DEATH_SECTOR    (0x0b) // This is a no-op for Heretic
#define HERETIC_LAVA    (0x10) // Use this instead

/* Stuff related to an open PWAD we're generating */

typedef struct s_index_entry
{
    char                  name[9];
    unsigned int          offset;
    unsigned int          length;
    struct s_index_entry *next;
} index_entry, *pindex_entry;

typedef struct s_dump_record
{
    FILE        *f;
    unsigned int offset_to_index;
    unsigned int lmpcount;
    index_entry *index_entry_anchor;
} dump_record, *pdump_record, *dumphandle;

typedef struct s_musheader
{
    char  tag[4]; /* MUS[0x1a] */
    short muslength;
    short headerlength;
    short primchannels;
    short secchannels;
    short patches;
    short dummy;
} musheader, *pmusheader;

typedef struct s_patch
{
    short           number;
    short           x;
    short           y;
    struct s_patch *next;
} patch, *ppatch;

typedef struct s_custom_texture
{
    char                    *name;
    short                    xsize;
    short                    ysize;
    patch                   *patch_anchor;
    struct s_custom_texture *next;
} custom_texture, *pcustom_texture;

typedef struct s_texture_lmp
{
    char           *name;
    custom_texture *custom_texture_anchor;
} texture_lmp, *ptexture_lmp;

/* Health, Armor, and Ammo estimates */

typedef struct s_one_haa
{
    float   health;
    float   armor;
    float   ammo;
    boolean can_use_shells;
    boolean can_use_rockets;
    boolean can_use_cells;
    boolean has_chaingun;
    boolean has_chainsaw;
    boolean has_backpack;
    boolean has_berserk;
    boolean has_ssgun;
    boolean shells_pending;
    boolean chaingun_pending;
} one_haa, *pone_haa;

typedef struct s_haa
{
    one_haa haas[3];
#define ITYTD (0)
#define HMP   (1)
#define UV    (2)
} haa, *phaa;

typedef struct s_quest
{
    short goal;               /* What kind of quest? */
    short tag;                /* If a linedef/switch, what's the tag? */
    short tag2;               /* Another tag, if needed for GATEs etc. */
    short type;               /* What should we do to the tag? */
                              /* Or what's the ID of the key */
    sector         *room;     /* What room will the quest let us into? */
    short           count;    /* How many rooms in the quest so far? */
    short           minrooms; /* How many rooms at least should it have? */
    short           auxtag;   /* Tag of door to open when taking goal */
    linedef        *surprise; /* Linedef to populate after goal room */
    thing          *pthing;   /* Thing that closed a closed thing-quest */
    struct s_quest *next;     /* For the quest stack */
} quest, *pquest;

/* Values for quest.goal */
#define LEVEL_END_GOAL 101
#define KEY_GOAL       102
#define SWITCH_GOAL    103
#define NULL_GOAL      104
#define ARENA_GOAL     105
#define GATE_GOAL      106

/* Teleport gates */
struct s_gate
{
    short   in_tag;
    short   out_tag;
    short   gate_lock; /* The linedef-type, if any, to open the gate */
    boolean is_entry;  /* Does one enter the room by it the first time? */
    gate   *next;
};

/* The Arena */

typedef struct s_arena
{
    propertybits props;
#define ARENA_ROOF         (0x01)
#define ARENA_PORCH        (0x02)
#define ARENA_LAMPS        (0x04)
#define ARENA_ARRIVAL_HOLE (0x08)
#define ARENA_NUKAGE       (0x10)
    genus          *boss;
    int             boss_count;
    genus          *weapon;
    genus          *ammo;
    flat           *floor;
    texture        *walls;
    boolean         placed_health;
    boolean         placed_armor;
    boolean         placed_ammo;
    boolean         placed_weapon;
    short           minx, miny, maxx, maxy;
    sector         *innersec;
    sector         *outersec;
    short           fromtag;
    struct s_arena *next;
} arena, *parena;

typedef struct s_level
{
    thing   *thing_anchor;
    sector  *sector_anchor;
    vertex  *vertex_anchor;
    sidedef *sidedef_anchor;
    linedef *linedef_anchor;
    boolean  used_red;
    boolean  used_blue;
    boolean  used_yellow;
    int      last_tag_used;
    short    sl_tag;         /* Tag for thing to activate to open secret level exit */
    short    sl_type;        /* Type for ... */
    sector  *sl_open_start;  /* The first room the opener can go in */
    boolean  sl_open_ok;     /* Is it time to do the opener yet? */
    sector  *sl_exit_sector; /* The room the exit switch is in */
    boolean  sl_done;        /* Did we done it yet? */
    sector  *first_room;
    sector  *goal_room;
    int      secret_count;
    int      dm_count;
    int      dm_rho;
    boolean  support_misaligns;
    boolean  seen_suit;
    boolean  seen_map;
    boolean  scrolling_keylights;
    int      skyclosets; /* Percent chance of closets being open to the sky */
    int      p_new_pillars;
    int      p_stair_lamps;
    int      p_force_nukage;
    int      p_force_sky;
    int      p_deep_baths;
    int      p_falling_core;
    int      p_barrels;
    int      p_extwindow;
    int      p_extroom;
    int      p_rising_room;
    int      p_surprise;
    int      p_swcloset;
    int      p_rational_facing;
    int      p_biggest_monsters;
    int      p_open_link;
    int      p_s1_door;
    int      p_special_room; /* Should be in Style, maybe? */
    int      lift_rho;       /* How common are lifts? */
    int      amcl_rho;       /* How common are ambush-closets? */
    int      maxkeys;        /* How many key or switch quests, at most, to use */
    int      barcount;       /* How many door-bars so far? */
    int      crushercount;   /* How many left-on crushers so far? */
    int      hugeness;       /* A one or a two or whatever */
    boolean  skullkeys;      /* Use skull (not card) keys? */
    boolean  use_gates;      /* Allowed to use non-exit teleporters? */
    boolean  raise_gates;    /* Teleport flats raised a bit? */
    boolean  all_wide_links;
    boolean  no_doors;
    boolean  heretic_level;
    short    outside_light_level; /* I don't know if it's cloudy or bright */
    short    bright_light_level;  /* How bright a bright room is */
    short    lit_light_level;     /* How bright a working lamp/light is */
    /* These lists are just for memory-freeing purposes */
    style *style_anchor;
    link  *link_anchor;
    gate  *gate_anchor;
    arena *arena_anchor;
} level, *plevel;

/* The config is the static architectural knowledge and stuff. */
/* It's read from a config file (parts of it, anyway!).        */
typedef struct s_config
{
    std::vector<char> *configdata;  /* Contents of the configuration */
    char              *outfile;     /* Name of the output file */
    boolean            cwadonly;    /* Do we want just the customization lumps? */
    unsigned char      themecount;  /* How many (non-secret) themes there are */
    unsigned char      sthemecount; /* How many secret themes there are */
    boolean            secret_themes;
    boolean            lock_themes;
    boolean            major_nukage;
    propertybits       required_monster_bits;
    propertybits       forbidden_monster_bits;
    short              minrooms;
    theme             *theme_anchor;
    genus             *genus_anchor;
    flat              *flat_anchor;
    texture           *texture_anchor;
    construct         *construct_anchor;
    flat              *sky_flat;
    flat              *water_flat;
    texture           *null_texture;
    texture           *error_texture;
    texture           *gate_exitsign_texture;
    gamebits           gamemask;   /* Which games must we be compatible with? */
    int                levelcount; /* How many levels to produce */
    boolean            produce_null_lmps;
    boolean            do_music;
    boolean            do_slinfo;
    boolean            do_seclevels;
    boolean            do_dm;
    boolean            secret_monsters;
    boolean            force_secret;
    boolean            force_arena;
    boolean            force_biggest;
    boolean            weapons_are_special; /* Can weapons (not) be given out as ammo? */
    boolean            recess_switches;
    boolean            big_weapons;
    boolean            big_monsters;
    boolean            gunk_channels;
    boolean            clights;
    boolean            allow_boring_rooms;
    boolean            both_doors;
    boolean            doorless_jambs;
    float              machoh;             /* Macho-factor for Hurt Me Plenty */
    float              machou;             /* Macho-factor for Ultraviolins */
    int                p_bigify;           /* Percent chance of maybe expanding rooms */
    int                usualammo[3];       /* Usual ammo/armor/health for the three hardnesses */
    int                usualarmor[3];
    int                usualhealth[3];
    int                minhealth[3];       /* Minimal OK healths for the three hardnesses */
    boolean            immediate_monsters; /* OK to have monsters in first room? */
    int                p_hole_ends_level;
    int                p_gate_ends_level;
    int                p_use_steps;
    int                p_sync_doors;
    int                p_grid_gaps;
    int                p_pushquest;
    int                rad_newtheme;        /* How likely to use a random theme beyond a lock */
    int                norm_newtheme;       /* How likely beyond a non-lock link */
    int                rad_vary;            /* How much to vary the style beyond a lock */
    int                norm_vary;           /* How much beyon a non-lock link */
    boolean            monsters_can_teleport;
    boolean            window_airshafts;
    int                homogenize_monsters; /* How likely to have all room monsters == */
    int                minlight;            /* How dark is dark? */
    /* These are *not* actually static */
    int     episode, mission, map; /* What map/mission we're on now. */
    boolean last_mission;          /* This the last one we're doing? */
    int     forkiness;             // Controls percentage rolls for room forking
} config, *pconfig;

/* Lots and lots and lots of functions */
/* And this isn't even all of 'em! */

config    *get_config(const std::string &filename);
void       NewLevel(level *l, haa *init_haa, config *c);
void       DumpLevel(dumphandle dh, config *c, level *l, int episode, int mission, int map);
void       FreeLevel(level *l);
dumphandle OpenDump(config *c);
void       CloseDump(dumphandle dh);
quest     *starting_quest(level *l, config *c);
haa       *starting_haa(void);
style     *random_style(level *l, config *c);
boolean    enough_quest(level *l, sector *s, quest *ThisQuest, config *c);
boolean    rollpercent(int n);
int        roll(int n);
linedef   *starting_linedef(level *l, style *ThisStyle, config *c);
int        mark_adequate_linedefs(level *l, sector *s, style *ThisStyle, config *c);
int        mark_decent_boundary_linedefs(level *l, sector *s, int minlen);
boolean    isAdequate(level *l, linedef *ld, style *ThisStyle, config *c);
linedef   *random_marked_linedef(level *l, int i);
void       unmark_linedefs(level *l);
void embellish_room(level *l, sector *oldsector, haa *haa, style *ThisStyle, quest *ThisQuest, boolean should_watermark,
                    boolean edges_only, config *c);
boolean  grid_room(level *l, sector *oldsector, haa *haa, style *ThisStyle, quest *ThisQuest, boolean first_room,
                   config *c);
void     enhance_room(level *l, sector *oldsector, haa *haa, style *ThisStyle, quest *ThisQuest, boolean first_room,
                      config *c);
void     align_textures(level *l, sector *oldsector, config *c);
void     gloabl_align_textures(level *l, config *c);
void     populate(level *l, sector *oldsector, config *c, haa *ThisHaa, boolean first);
void     gate_populate(level *l, sector *s, haa *haa, boolean first, config *c);
link    *random_link(level *l, linedef *ld, style *ThisStyle, quest *ThisQuest, config *c);
link    *random_open_link(level *l, linedef *ld, style *ThisStyle, quest *ThisQuest, config *c);
link    *random_basic_link(level *l, linedef *ld, style *ThisStyle, quest *ThisQuest, config *c);
link    *gate_link(level *l, config *c);
sector  *generate_room_outline(level *l, linedef *ld, style *ThisStyle, boolean try_reduction, config *c);
int      lengthsquared(linedef *ld);
int      distancesquared(int x1, int y1, int x2, int y2);
int      infinity_norm(int x1, int y1, int x2, int y2);
boolean  empty_rectangle(level *l, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4);
boolean  empty_left_side(level *l, linedef *ld, int sdepth);
void     close_quest(level *l, sector *s, quest *ThisQuest, haa *haa, config *c);
void     maybe_push_quest(level *l, sector *s, quest *ThisQuest, config *c);
linedef *make_parallel(level *l, linedef *ld, int depth, linedef *old);
linedef *lefthand_box_ext(level *l, linedef *ldf1, int depth, style *ThisStyle, config *c, linedef **nld1,
                          linedef **nld2);
#define lefthand_box(l, ldf1, depth, ThisStyle, c) (lefthand_box_ext(l, ldf1, depth, ThisStyle, c, NULL, NULL))
int      facing_along(int x1, int y1, int x2, int y2);
int      facing_right_from(int x1, int y1, int x2, int y2);
int      facing_right_from_ld(linedef *ld);
linedef *make_linkto(level *l, linedef *ldf, link *ThisLink, style *ThisStyle, config *c, linedef *old);
void     e_bl_inner(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink, quest *ThisQuest, style *ThisStyle,
                    style *NewStyle, short flipstate, haa *haa, config *c);
void     e_ol_inner(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink, quest *ThisQuest, style *ThisStyle,
                    style *NewStyle, haa *haa, config *c);
void establish_basic_link(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink, quest *ThisQuest, style *ThisStyle,
                          style *NewStyle, haa *haa, config *c);
void establish_open_link(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink, quest *ThisQuest, style *ThisStyle,
                         style *NewStyle, haa *haa, config *c);
void establish_link(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink, quest *ThisQuest, style *ThisStyle,
                    style *NewStyle, haa *haa, config *c);
void stairify(level *l, linedef *ldf1, linedef *ldf2, linedef *lde1, linedef *lde2, short nearheight, short farheight,
              quest *ThisQuest, style *ThisStyle, config *c);
void paint_room(level *l, sector *s, style *ThisStyle, config *c);
linedef *split_linedef(level *l, linedef *ld, int len, config *c);
boolean  link_fitsq(link *ThisLink, quest *ThisQuest);
boolean  link_fitsh(linedef *ldf, link *ThisLink, config *c);
boolean  link_fitsv(level *l, linedef *ldf1, linedef *ldf2, link *ThisLink);
boolean  nonswitch_config(config *c);
void     load_obsidian_config(config *c);
void     unload_config(config *c);
texture *new_texture(config *c, const char *name);
texture *find_texture(config *c, const char *name);
genus   *find_genus(config *c, int thingid);
genus   *new_genus(config *c, int thingid);
flat    *new_flat(config *c, const char *name);
flat    *find_flat(config *c, const char *name);
theme   *new_theme(config *c, const char *name, boolean secret);
gate    *new_gate(level *l, short in, short out, short lock, boolean entry, config *c);
void     patch_upper(linedef *ld, texture *t, config *c);
void     patch_lower(linedef *ld, texture *t, config *c);
linedef *flip_linedef(linedef *ld);
sector  *make_box_ext(level *l, linedef *ldf1, linedef *ldf2, style *ThisStyle, config *c, linedef **nld1,
                      linedef **nld2);
#define make_box(l, ld1, ld2, st, c) (make_box_ext(l, ld1, ld2, st, c, NULL, NULL))
thing   *place_object(level *l, sector *s, config *c, short thingid, int width, int angle, int ax, int ay, int bits);
thing   *place_object_in_region(level *l, int minx, int miny, int maxx, int maxy, config *c, short thingid, int width,
                                int angle, int ax, int ay, int bits);
thing   *place_required_pickable(level *l, sector *s, config *c, short id);
genus   *timely_monster(haa *haa, config *c, int *levels, boolean biggest, int mno);
genus   *timely_monster_ex(haa *haa, config *c, int *levels, boolean biggest, int mno, propertybits req);
void     update_haa_for_monster(haa *haa, genus *m, int levels, int mno, config *c);
void     ammo_value(short ammotype, haa *haa, int *a0, int *a1, int *a2);
void     haa_unpend(haa *haa);
void     trigger_box(level *l, thing *t, sector *s, short tag, short type, config *c);
void     populate_linedef(level *l, linedef *ldnew2, haa *haa, config *c, boolean s);
void     find_rec(level *l, sector *s, int *minx, int *miny, int *maxx, int *maxy);
void     mid_tile(level *l, sector *s, short *tlx, short *tly, short *thx, short *thy);
linedef *centerpart(level *l, linedef *ld, linedef **ld2, int width, style *ThisStyle, config *c);
texture *texture_for_key(short key, style *s, config *c);
texture *texture_for_bits(propertybits pb, style *s, config *c);
short    type_for_key(short key);
void     make_lighted(level *l, sector *s, config *c);
short    locked_linedef_for(short type, short key, config *c);
void     install_gate(level *l, sector *s, style *ThisStyle, haa *ThisHaa, boolean force_exit_style, config *c);
void     frame_innersec_ex(level *l, sector *oldsector, sector *innersec, texture *tm, texture *tu, texture *tl, int x1,
                           int y1, int x2, int y2, int x3, int y3, int x4, int y4, config *c, linedef **l1, linedef **l2,
                           linedef **l3, linedef **l4);
#define frame_innersec(l, s, i, tm, tu, tl, x1, y1, x2, y2, x3, y3, x4, y4, c)                                         \
    frame_innersec_ex(l, s, i, tm, tu, tl, x1, y1, x2, y2, x3, y3, x4, y4, c, NULL, NULL, NULL, NULL)
void parallel_innersec_ex(level *l, sector *oldsector, sector *innersec, texture *tm, texture *tu, texture *tl,
                          int minx, int miny, int maxx, int maxy, config *c, linedef **l1, linedef **l2, linedef **l3,
                          linedef **l4);
#define parallel_innersec(l, o, i, tm, tu, tl, ix, iy, ax, ay, c)                                                      \
    parallel_innersec_ex(l, o, i, tm, tu, tl, ix, iy, ax, ay, c, NULL, NULL, NULL, NULL)
boolean install_construct(level *l, sector *oldsector, int minx, int miny, int maxx, int maxy, style *ThisStyle,
                          config *c);

void make_music(dumphandle dh, config *c);
void make_slinfo(dumphandle dh, config *c);
void record_custom_textures(dumphandle dh, config *c);
void record_custom_flats(dumphandle dh, config *c, boolean even_unused);
void record_custom_patches(dumphandle dh, config *c, boolean even_unused);

boolean need_secret_level(config *c);
void    make_secret_level(dumphandle dh, haa *haa, config *c);
void    secretize_config(config *c);
boolean install_sl_exit(level *l, sector *oldsector, haa *ThisHaa, style *ThisStyle, quest *ThisQuest, boolean opens,
                        config *c);

#define NONE        -1
#define VERBOSE     0
#define LOG         1
#define NOTE        2
#define WARNING     3
#define SLUMP_ERROR 4
void announce(int announcetype, const char *s);

#define RIGHT_TURN (90)
#define LEFT_TURN  (270)
void           point_from(int x1, int y1, int x2, int y2, int angle, int len, int *x3, int *y3);
unsigned short psi_sqrt(int v);
#define linelen(x) (unsigned short)(psi_sqrt(lengthsquared(x)))
boolean no_monsters_stuck_on(level *l, linedef *ld1);

flat    *random_ceiling0(config *c, style *s);
flat    *random_ceilinglight(config *c, style *s);
flat    *random_floor0(config *c, style *s);
flat    *random_gate(config *c, style *s);
flat    *random_doorceiling(config *c, style *s);
flat    *random_doorfloor(config *c, style *s);
flat    *random_stepfloor(config *c, style *s);
flat    *random_nukage1(config *c, style *s);
flat    *random_flat0(propertybits pmask, config *c, style *s);
genus   *random_thing0(propertybits pmask, config *c, style *s, int minh, int maxh);
texture *random_texture0(propertybits pmask, config *c, style *s);
texture *random_wall0(config *c, style *s);
texture *random_kickplate(config *c, style *s);
texture *random_stepfront(config *c, style *s);
texture *switch0_for(config *c, style *s);
texture *random_support0(config *c, style *s);
texture *random_doorjamb(config *c, style *s);
texture *random_widedoorface(config *c, style *s);
texture *random_widedoorface_ex(config *c, style *s, boolean hi);
texture *random_narrowdoorface(config *c, style *s);
texture *random_narrowdoorface_ex(config *c, style *s, boolean hi);
texture *random_twdoorface(config *c, style *s);
texture *random_tndoorface(config *c, style *s);
texture *random_lockdoorface(config *c, style *s);
texture *random_grating(config *c, style *s);
texture *random_walllight(config *c, style *s);
texture *random_liftface(config *c, style *s);
texture *random_plaque(config *c, style *s);
genus   *random_lamp0(config *c, style *s);
genus   *random_shortlamp0(config *c, style *s);
genus   *random_barrel(config *c, style *s);
genus   *random_plant(config *c, style *s);
texture *random_redface(config *c, style *s);
texture *random_blueface(config *c, style *s);
texture *random_yellowface(config *c, style *s);

void place_monsters(level *l, sector *s, config *c, haa *haa);
void place_timely_something(level *l, haa *haa, config *c, int x, int y);
void place_armor(level *l, sector *s, config *c, haa *haa);
void place_ammo(level *l, sector *s, config *c, haa *haa);
void place_health(level *l, sector *s, config *c, haa *haa);
void place_barrels(level *l, sector *s, config *c, haa *haa);
void place_plants(level *l, int allow, sector *s, config *c);

boolean common_texture(sidedef *sd1, sidedef *sd2);
boolean coalignable(texture *t1, texture *t2);

void global_align_textures(level *l, config *c);
void global_align_linedef(level *l, linedef *ld);
void global_align_forward(level *l, linedef *ld);
void global_align_backward(level *l, linedef *ld);
void global_align_group_backbone_forward(level *l, linedef *ld);
void global_align_group_backbone_backward(level *l, linedef *ld);
void global_align_group_etc_forward(level *l, linedef *ld);
void global_align_group_etc_backward(level *l, linedef *ld);

void            basic_background2(uint8_t *fbuf, byte bottom, int range);
uint8_t        *one_piece(musheader *pmh);
texture_lmp    *new_texture_lmp(const char *name);
void            free_texture_lmp(texture_lmp *tl);
custom_texture *new_custom_texture(texture_lmp *tl, const char *name, short xsize, short ysize);
boolean         hardwired_nonswitch_nontheme_config(config *c);

/* End of slump.h */
