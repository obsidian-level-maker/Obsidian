//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "g_doom.h"

#include <bitset>
#include <iostream>
#include <string>

#include "csg_main.h"
#include "dm_extra.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "main.h"
#include "q_common.h"  // qLump_c

// SLUMP for Vanilla Doom
#include "slump_main.h"

extern void CSG_DOOM_Write();

// extern void CSG_TestRegions_Doom();

extern int ef_solid_type;
extern int ef_liquid_type;
extern int ef_thing_mode;

static char *level_name;

int dm_sub_format;

int dm_offset_map;

static qLump_c *header_lump;
static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;
static qLump_c *textmap_lump;
static qLump_c *endmap_lump;

static int errors_seen;

std::string current_engine;
std::string map_format;
int build_nodes;
int build_reject;
std::string levelcount;
std::string monvariety;

static bool UDMF_mode;

int udmf_vertexes;
int udmf_sectors;
int udmf_linedefs;
int udmf_things;
int udmf_sidedefs;

typedef enum {
    SECTION_Patches = 0,
    SECTION_Sprites,
    SECTION_Colormaps,
    SECTION_ZDoomTex,
    SECTION_Flats,

    NUM_SECTIONS
} wad_section_e;

typedef std::vector<qLump_c *> lump_bag_t;

static lump_bag_t *sections[NUM_SECTIONS];

static const char *section_markers[NUM_SECTIONS][2] = {
    {"PP_START", "PP_END"},
    {"SS_START", "SS_END"},
    {"C_START", "C_END"},
    {"TX_START", "TX_END"},

    // flats must end with F_END (a single 'F') to be vanilla compatible
    {"FF_START", "F_END"}};

//------------------------------------------------------------------------
//  SLUMP WAD Creation for Vanilla Doom
//------------------------------------------------------------------------
int Slump_MakeWAD(const char* filename) {
	s_config slump_config;
	slump_config.outfile = (char *)filename;
	levelcount = main_win->game_box->length->GetID();
	if (levelcount == "single") {
		slump_config.levelcount = 1;	
	} else if (levelcount == "few") {
		slump_config.levelcount = 4;
	} else if (levelcount == "episode") {
		slump_config.levelcount = 11;
	} else {
		slump_config.levelcount = 32; // "Full Game"
	}
	slump_config.minrooms = (int)main_win->left_mods->FindID("ui_slump_arch")
							->FindSliderOpt("float_minrooms")->value();
	slump_config.p_bigify = (int)main_win->left_mods->FindID("ui_slump_arch")
							->FindSliderOpt("float_bigify")->value();
	slump_config.forkiness = (int)main_win->left_mods->FindID("ui_slump_arch")
							->FindSliderOpt("float_forkiness")->value();
	if (main_win->left_mods->FindID("ui_slump_arch")
							->FindButtonOpt("bool_dm_starts")->value()) {
		slump_config.do_dm = 1;
	} else {
		slump_config.do_dm = 0;
	}
	if (main_win->left_mods->FindID("ui_slump_arch")
							->FindButtonOpt("bool_major_nukage")->value()) {
		slump_config.major_nukage = SLUMP_TRUE;
	} else {
		slump_config.major_nukage = SLUMP_FALSE;
	}
	if (main_win->left_mods->FindID("ui_slump_arch")
							->FindButtonOpt("bool_immediate_monsters")->value()) {
		slump_config.immediate_monsters = SLUMP_FALSE;
	} else {
		slump_config.immediate_monsters = rollpercent(20);
	}
	monvariety = main_win->right_mods->FindID("ui_slump_mons")
							->FindOpt("slump_mons")->GetID();
	if (monvariety == "normal") {
		slump_config.required_monster_bits = 0;
		slump_config.forbidden_monster_bits = SPECIAL;
	} else if (monvariety == "shooters") {
		slump_config.required_monster_bits = SHOOTS;
		slump_config.forbidden_monster_bits = SPECIAL;
	} else if (monvariety == "noflyzone") {
		slump_config.required_monster_bits = 0;
		slump_config.forbidden_monster_bits = FLIES + SPECIAL;
	} else {
		slump_config.required_monster_bits = SPECIAL; // All Nazis
		slump_config.forbidden_monster_bits = 0;
	}					
	return slump_main(slump_config);    
}	


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

void DM_WriteLump(const char *name, const void *data, u32_t len) {
    SYS_ASSERT(strlen(name) <= 8);

    WAD_NewLump(name);

    if (len > 0) {
        if (!WAD_AppendData(data, len)) {
            errors_seen++;
        }
    }

    WAD_FinishLump();
}

void DM_WriteLump(const char *name, qLump_c *lump) {
    DM_WriteLump(name, lump->GetBuffer(), lump->GetSize());
}

static void DM_WriteBehavior() {
    raw_behavior_header_t behavior;

    strncpy(behavior.marker, "ACS", 4);

    behavior.offset = LE_U32(8);
    behavior.func_num = 0;
    behavior.str_num = 0;

    DM_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}

static void DM_ClearSections() {
    for (int k = 0; k < NUM_SECTIONS; k++) {
        if (!sections[k]) {
            sections[k] = new lump_bag_t;
        }

        for (unsigned int n = 0; n < sections[k]->size(); n++) {
            delete sections[k]->at(n);
            sections[k]->at(n) = NULL;
        }

        sections[k]->clear();
    }
}

static void DM_WriteSections() {
    for (int k = 0; k < NUM_SECTIONS; k++) {
        if (sections[k]->size() == 0) {
            continue;
        }

        DM_WriteLump(section_markers[k][0], NULL, 0);

        for (unsigned int n = 0; n < sections[k]->size(); n++) {
            qLump_c *lump = sections[k]->at(n);

            DM_WriteLump(lump->GetName(), lump);
        }

        DM_WriteLump(section_markers[k][1], NULL, 0);
    }
}

void DM_AddSectionLump(char ch, const char *name, qLump_c *lump) {
    int k;
    switch (ch) {
        case 'P':
            k = SECTION_Patches;
            break;
        case 'S':
            k = SECTION_Sprites;
            break;
        case 'C':
            k = SECTION_Colormaps;
            break;
        case 'T':
            k = SECTION_ZDoomTex;
            break;
        case 'F':
            k = SECTION_Flats;
            break;

        default:
            Main_FatalError("DM_AddSectionLump: bad section '%c'\n", ch);
            return; /* NOT REACHED */
    }

    lump->SetName(name);

    sections[k]->push_back(lump);
}

bool DM_StartWAD(const char *filename) {
    if (!WAD_OpenWrite(filename)) {
        DLG_ShowError(_("Unable to create wad file:\n\n%s"), strerror(errno));
        return false;
    }

    errors_seen = 0;

    DM_ClearSections();

    qLump_c *info = BSP_CreateInfoLump();
    DM_WriteLump("OBLIGDAT", info);
    delete info;

    return true;  // OK
}

bool DM_EndWAD() {
    DM_WriteSections();
    DM_ClearSections();

    WAD_CloseWrite();

    return (errors_seen == 0);
}

static void DM_FreeLumps() {
    delete header_lump;
    header_lump = NULL;
    if (not UDMF_mode) {
        delete thing_lump;
        thing_lump = NULL;
        delete sector_lump;
        sector_lump = NULL;
        delete vertex_lump;
        vertex_lump = NULL;
        delete sidedef_lump;
        sidedef_lump = NULL;
        delete linedef_lump;
        linedef_lump = NULL;
    } else {
        delete textmap_lump;
        textmap_lump = NULL;
        delete endmap_lump;
        endmap_lump = NULL;
    }
}

void DM_BeginLevel() {
    DM_FreeLumps();

    header_lump = new qLump_c();
    if (not UDMF_mode) {
        thing_lump = new qLump_c();
        vertex_lump = new qLump_c();
        sector_lump = new qLump_c();
        linedef_lump = new qLump_c();
        sidedef_lump = new qLump_c();
    } else {
        textmap_lump = new qLump_c();
        if (dm_sub_format == SUBFMT_Hexen) {
            textmap_lump->Printf("namespace = \"Hexen\";\n\n");
        } else {
            textmap_lump->Printf("namespace = \"ZDoomTranslated\";\n\n");
        }
        endmap_lump = new qLump_c();
    }
}

void DM_EndLevel(const char *level_name) {
    // terminate header lump with trailing NUL
    if (header_lump->GetSize() > 0) {
        const byte nuls[4] = {0, 0, 0, 0};
        header_lump->Append(nuls, 1);
    }

    DM_WriteLump(level_name, header_lump);

    if (UDMF_mode) {
        DM_WriteLump("TEXTMAP", textmap_lump);
    }

    if (not UDMF_mode) {
        DM_WriteLump("THINGS", thing_lump);
        DM_WriteLump("LINEDEFS", linedef_lump);
        DM_WriteLump("SIDEDEFS", sidedef_lump);
        DM_WriteLump("VERTEXES", vertex_lump);

        DM_WriteLump("SEGS", NULL, 0);
        DM_WriteLump("SSECTORS", NULL, 0);
        DM_WriteLump("NODES", NULL, 0);
        DM_WriteLump("SECTORS", sector_lump);
        if (dm_sub_format == SUBFMT_Hexen) {
            DM_WriteBehavior();
        }
    } else {
        if (dm_sub_format == SUBFMT_Hexen) {
            DM_WriteBehavior();
        }
        DM_WriteLump("ENDMAP", NULL, 0);
    }

    DM_FreeLumps();
}

//------------------------------------------------------------------------

void DM_HeaderPrintf(const char *str, ...) {
    static char message_buf[MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(message_buf, MSG_BUF_LEN, str, args);
    va_end(args);

    message_buf[MSG_BUF_LEN - 1] = 0;

    header_lump->Append(message_buf, strlen(message_buf));
}

void DM_AddVertex(int x, int y) {
    if (dm_offset_map) {
        x += 32;
        y += 32;
    }

    if (not UDMF_mode) {
        raw_vertex_t vert;

        vert.x = LE_S16(x);
        vert.y = LE_S16(y);
        vertex_lump->Append(&vert, sizeof(vert));
    } else {
        textmap_lump->Printf("\nvertex\n{\n");
        textmap_lump->Printf("\tx = %f;\n", (double)x);
        textmap_lump->Printf("\ty = %f;\n", (double)y);
        textmap_lump->Printf("}\n");
        udmf_vertexes += 1;
    }
}

void DM_AddSector(int f_h, const char *f_tex, int c_h, const char *c_tex,
                  int light, int special, int tag) {
    if (not UDMF_mode) {
        raw_sector_t sec;

        sec.floor_h = LE_S16(f_h);
        sec.ceil_h = LE_S16(c_h);

        strncpy(sec.floor_tex, f_tex, 8);
        strncpy(sec.ceil_tex, c_tex, 8);

        sec.light = LE_U16(light);
        sec.special = LE_U16(special);
        sec.tag = LE_S16(tag);
        sector_lump->Append(&sec, sizeof(sec));
    } else {
        textmap_lump->Printf("\nsector\n{\n");
        textmap_lump->Printf("\theightfloor = %d;\n", f_h);
        textmap_lump->Printf("\theightceiling = %d;\n", c_h);
        textmap_lump->Printf("\ttexturefloor = \"%s\";\n", f_tex);
        textmap_lump->Printf("\ttextureceiling = \"%s\";\n", c_tex);
        textmap_lump->Printf("\tlightlevel = %d;\n", light);
        textmap_lump->Printf("\tspecial = %d;\n", special);
        textmap_lump->Printf("\tid = %d;\n", tag);
        textmap_lump->Printf("}\n");
        udmf_sectors += 1;
    }
}

void DM_AddSidedef(int sector, const char *l_tex, const char *m_tex,
                   const char *u_tex, int x_offset, int y_offset) {
    if (not UDMF_mode) {
        raw_sidedef_t side;

        side.sector = LE_S16(sector);

        strncpy(side.lower_tex, l_tex, 8);
        strncpy(side.mid_tex, m_tex, 8);
        strncpy(side.upper_tex, u_tex, 8);

        side.x_offset = LE_S16(x_offset);
        side.y_offset = LE_S16(y_offset);
        sidedef_lump->Append(&side, sizeof(side));
    } else {
        textmap_lump->Printf("\nsidedef\n{\n");
        textmap_lump->Printf("\toffsetx = %d;\n", x_offset);
        textmap_lump->Printf("\toffsety = %d;\n", y_offset);
        textmap_lump->Printf("\ttexturetop = \"%s\";\n", u_tex);
        textmap_lump->Printf("\ttexturemiddle = \"%s\";\n", m_tex);
        textmap_lump->Printf("\ttexturebottom = \"%s\";\n", l_tex);
        textmap_lump->Printf("\tsector = %d;\n", sector);
        textmap_lump->Printf("}\n");
        udmf_sidedefs += 1;
    }
}

void DM_AddLinedef(int vert1, int vert2, int side1, int side2, int type,
                   int flags, int tag, const byte *args) {
    if (dm_sub_format != SUBFMT_Hexen) {
        if (not UDMF_mode) {
            raw_linedef_t line;

            line.start = LE_U16(vert1);
            line.end = LE_U16(vert2);

            line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
            line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

            line.type = LE_U16(type);
            line.flags = LE_U16(flags);
            line.tag = LE_U16(tag);
            linedef_lump->Append(&line, sizeof(line));
        } else {
            textmap_lump->Printf("\nlinedef\n{\n");
            textmap_lump->Printf("\tid = %d;\n", tag);
            textmap_lump->Printf("\tv1 = %d;\n", vert1);
            textmap_lump->Printf("\tv2 = %d;\n", vert2);
            textmap_lump->Printf("\tsidefront = %d;\n", side1 < 0 ? -1 : side1);
            textmap_lump->Printf("\tsideback = %d;\n", side2 < 0 ? -1 : side2);
            textmap_lump->Printf("\targ0 = %d;\n", tag);
            textmap_lump->Printf("\tspecial = %d;\n", type);
            std::bitset<16> udmf_flags(flags);
            if (udmf_flags.test(0)) {
                textmap_lump->Printf("\tblocking = true;\n");
            }
            if (udmf_flags.test(1)) {
                textmap_lump->Printf("\tblockmonsters = true;\n");
            }
            if (udmf_flags.test(2)) {
                textmap_lump->Printf("\ttwosided = true;\n");
            }
            if (udmf_flags.test(3)) {
                textmap_lump->Printf("\tdontpegtop = true;\n");
            }
            if (udmf_flags.test(4)) {
                textmap_lump->Printf("\tdontpegbottom = true;\n");
            }
            if (udmf_flags.test(5)) {
                textmap_lump->Printf("\tsecret = true;\n");
            }
            if (udmf_flags.test(6)) {
                textmap_lump->Printf("\tblocksound = true;\n");
            }
            if (udmf_flags.test(7)) {
                textmap_lump->Printf("\tdontdraw = true;\n");
            }
            if (udmf_flags.test(8)) {
                textmap_lump->Printf("\tmapped = true;\n");
            }
            if (udmf_flags.test(9)) {
                textmap_lump->Printf("\tpassuse = true;\n");
            }
            textmap_lump->Printf("}\n");
            udmf_linedefs += 1;
        }
    } else  // Hexen format
    {
        if (not UDMF_mode) {
            raw_hexen_linedef_t line;

            // clear unused fields (esp. arguments)
            memset(&line, 0, sizeof(line));

            line.start = LE_U16(vert1);
            line.end = LE_U16(vert2);

            line.sidedef1 = side1 < 0 ? 0xffff : LE_U16(side1);
            line.sidedef2 = side2 < 0 ? 0xffff : LE_U16(side2);

            line.special = type;  // 8 bits
            line.flags = LE_U16(flags);

            // tag value is UNUSED

            if (args) {
                memcpy(line.args, args, 5);
            }

            linedef_lump->Append(&line, sizeof(line));
        } else {
            textmap_lump->Printf("\nlinedef\n{\n");
            if (type == 121) {
                textmap_lump->Printf("\tid = %d;\n", args[0]);
            }
            textmap_lump->Printf("\tv1 = %d;\n", vert1);
            textmap_lump->Printf("\tv2 = %d;\n", vert2);
            textmap_lump->Printf("\tsidefront = %d;\n", side1 < 0 ? -1 : side1);
            textmap_lump->Printf("\tsideback = %d;\n", side2 < 0 ? -1 : side2);
            if (type == 121) {
                textmap_lump->Printf("\tspecial = 0;\n");
                textmap_lump->Printf("\targ0 = 0;\n");
            } else {
                textmap_lump->Printf("\tspecial = %d;\n", type);
                textmap_lump->Printf("\targ0 = %d;\n", args[0]);
            }
            textmap_lump->Printf("\targ1 = %d;\n", args[1]);
            textmap_lump->Printf("\targ2 = %d;\n", args[2]);
            textmap_lump->Printf("\targ3 = %d;\n", args[3]);
            textmap_lump->Printf("\targ4 = %d;\n", args[4]);
            std::bitset<16> udmf_flags(flags);
            if (udmf_flags.test(0)) {
                textmap_lump->Printf("\tblocking = true;\n");
            }
            if (udmf_flags.test(1)) {
                textmap_lump->Printf("\tblockmonsters = true;\n");
            }
            if (udmf_flags.test(2)) {
                textmap_lump->Printf("\ttwosided = true;\n");
            }
            if (udmf_flags.test(3)) {
                textmap_lump->Printf("\tdontpegtop = true;\n");
            }
            if (udmf_flags.test(4)) {
                textmap_lump->Printf("\tdontpegbottom = true;\n");
            }
            if (udmf_flags.test(5)) {
                textmap_lump->Printf("\tsecret = true;\n");
            }
            if (udmf_flags.test(6)) {
                textmap_lump->Printf("\tblocksound = true;\n");
            }
            if (udmf_flags.test(7)) {
                textmap_lump->Printf("\tdontdraw = true;\n");
            }
            if (udmf_flags.test(8)) {
                textmap_lump->Printf("\tmapped = true;\n");
            }
            if (udmf_flags.test(9)) {
                textmap_lump->Printf("\trepeatspecial = true;\n");
            }
            int spac = (flags & 0x1C00) >> 10;
            if (type > 0) {
                if (spac == 0) {
                    textmap_lump->Printf("\tplayercross = true;\n");
                }
                if (spac == 1) {
                    textmap_lump->Printf("\tplayeruse = true;\n");
                }
                if (spac == 2) {
                    textmap_lump->Printf("\tmonstercross = true;\n");
                }
                if (spac == 3) {
                    textmap_lump->Printf("\timpact = true;\n");
                }
                if (spac == 4) {
                    textmap_lump->Printf("\tplayerpush = true;\n");
                }
                if (spac == 5) {
                    textmap_lump->Printf("\tmissilecross = true;\n");
                }
            }
            textmap_lump->Printf("}\n");
            udmf_linedefs += 1;
        }
    }
}

void DM_AddThing(int x, int y, int h, int type, int angle, int options, int tid,
                 byte special, const byte *args) {
    if (dm_offset_map) {
        x += 32;
        y += 32;
    }

    if (dm_sub_format != SUBFMT_Hexen) {
        if (not UDMF_mode) {
            raw_thing_t thing;

            thing.x = LE_S16(x);
            thing.y = LE_S16(y);

            thing.type = LE_U16(type);
            thing.angle = LE_S16(angle);
            thing.options = LE_U16(options);
            thing_lump->Append(&thing, sizeof(thing));
        } else {
            textmap_lump->Printf("\nthing\n{\n");
            textmap_lump->Printf("\tx = %f;\n", (double)x);
            textmap_lump->Printf("\ty = %f;\n", (double)y);
            textmap_lump->Printf("\ttype = %d;\n", type);
            textmap_lump->Printf("\tangle = %d;\n", angle);
            std::bitset<16> udmf_flags(options);
            if (udmf_flags.test(0)) {
                textmap_lump->Printf("\tskill1 = true;\n");
                textmap_lump->Printf("\tskill2 = true;\n");
            }
            if (udmf_flags.test(1)) {
                textmap_lump->Printf("\tskill3 = true;\n");
            }
            if (udmf_flags.test(2)) {
                textmap_lump->Printf("\tskill4 = true;\n");
                textmap_lump->Printf("\tskill5 = true;\n");
            }
            if (udmf_flags.test(3)) {
                textmap_lump->Printf("\tambush = true;\n");
            }
            if (udmf_flags.test(4)) {
                textmap_lump->Printf("\tsingle = false;\n");
            } else {
                textmap_lump->Printf("\tsingle = true;\n");
            }
            if (udmf_flags.test(5)) {
                textmap_lump->Printf("\tdm = false;\n");
            } else {
                textmap_lump->Printf("\tdm = true;\n");
            }
            if (udmf_flags.test(6)) {
                textmap_lump->Printf("\tcoop = false;\n");
            } else {
                textmap_lump->Printf("\tcoop = true;\n");
            }
            if (udmf_flags.test(7)) {
                textmap_lump->Printf("\tfriend = true;\n");
            }
            // Testing fix for compatibility with ZDoom mods that add classes in
            // games other than Hexen
            textmap_lump->Printf("\tclass1 = true;\n");
            textmap_lump->Printf("\tclass2 = true;\n");
            textmap_lump->Printf("\tclass3 = true;\n");
            textmap_lump->Printf("}\n");
            udmf_things += 1;
        }
    } else  // Hexen format
    {
        if (not UDMF_mode) {
            raw_hexen_thing_t thing;

            // clear unused fields (esp. arguments)
            memset(&thing, 0, sizeof(thing));

            thing.x = LE_S16(x);
            thing.y = LE_S16(y);

            thing.height = LE_S16(h);
            thing.type = LE_U16(type);
            thing.angle = LE_S16(angle);
            thing.options = LE_U16(options);

            thing.tid = LE_S16(tid);
            thing.special = special;

            if (args) {
                memcpy(thing.args, args, 5);
            }

            thing_lump->Append(&thing, sizeof(thing));
        } else {
            textmap_lump->Printf("\nthing\n{\n");
            textmap_lump->Printf("\tid = %d;\n", tid);
            textmap_lump->Printf("\tx = %f;\n", (double)x);
            textmap_lump->Printf("\ty = %f;\n", (double)y);
            textmap_lump->Printf("\theight = %f;\n", (double)h);
            textmap_lump->Printf("\ttype = %d;\n", type);
            textmap_lump->Printf("\tangle = %d;\n", angle);
            std::bitset<16> udmf_flags(options);
            if (udmf_flags.test(0)) {
                textmap_lump->Printf("\tskill1 = true;\n");
                textmap_lump->Printf("\tskill2 = true;\n");
            }
            if (udmf_flags.test(1)) {
                textmap_lump->Printf("\tskill3 = true;\n");
            }
            if (udmf_flags.test(2)) {
                textmap_lump->Printf("\tskill4 = true;\n");
                textmap_lump->Printf("\tskill5 = true;\n");
            }
            if (udmf_flags.test(3)) {
                textmap_lump->Printf("\tambush = true;\n");
            }
            if (udmf_flags.test(4)) {
                textmap_lump->Printf("\tdormant = true;\n");
            }
            if (udmf_flags.test(5)) {
                textmap_lump->Printf("\tclass1 = true;\n");
            }
            if (udmf_flags.test(6)) {
                textmap_lump->Printf("\tclass2 = true;\n");
            }
            if (udmf_flags.test(7)) {
                textmap_lump->Printf("\tclass3 = true;\n");
            }
            if (udmf_flags.test(8)) {
                textmap_lump->Printf("\tsingle = true;\n");
            }
            if (udmf_flags.test(9)) {
                textmap_lump->Printf("\tcoop = true;\n");
            }
            if (udmf_flags.test(10)) {
                textmap_lump->Printf("\tdm = true;\n");
            }
            textmap_lump->Printf("\tspecial = %d;\n", special);
            if (args) {
                textmap_lump->Printf("\targ0 = %d;\n", args[0]);
                textmap_lump->Printf("\targ1 = %d;\n", args[1]);
                textmap_lump->Printf("\targ2 = %d;\n", args[2]);
                textmap_lump->Printf("\targ3 = %d;\n", args[3]);
                textmap_lump->Printf("\targ4 = %d;\n", args[4]);
            }
            textmap_lump->Printf("}\n");
            udmf_things += 1;
        }
    }
}

int DM_NumVertexes() {
    if (not UDMF_mode) {
        return vertex_lump->GetSize() / sizeof(raw_vertex_t);
    } else {
        return udmf_vertexes;
    }
}

int DM_NumSectors() {
    if (not UDMF_mode) {
        return sector_lump->GetSize() / sizeof(raw_sector_t);
    } else {
        return udmf_sectors;
    }
}

int DM_NumSidedefs() {
    if (not UDMF_mode) {
        return sidedef_lump->GetSize() / sizeof(raw_sidedef_t);
    } else {
        return udmf_sidedefs;
    }
}

int DM_NumLinedefs() {
    if (not UDMF_mode) {
        if (dm_sub_format == SUBFMT_Hexen) {
            return linedef_lump->GetSize() / sizeof(raw_hexen_linedef_t);
        }

        return linedef_lump->GetSize() / sizeof(raw_linedef_t);
    } else {
        return udmf_linedefs;
    }
}

int DM_NumThings() {
    if (not UDMF_mode) {
        if (dm_sub_format == SUBFMT_Hexen) {
            return thing_lump->GetSize() / sizeof(raw_hexen_thing_t);
        }

        return thing_lump->GetSize() / sizeof(raw_thing_t);
    } else {
        return udmf_things;
    }
}

//----------------------------------------------------------------------------
//  ZDBSP NODE BUILDING
//----------------------------------------------------------------------------

#include "zdmain.h"

static bool DM_BuildNodes(const char *filename, const char *out_name) {
    LogPrintf("\n");

    zdbsp_options options;
    if (current_engine == "vanilla") {
        options.build_nodes = true;
        options.build_gl_nodes = false;
        options.build_gl_only = false;
        if (build_reject) {
            options.reject_mode = ERM_Rebuild_NoGL;
        } else {
            options.reject_mode = ERM_CreateZeroes;
        }
        options.check_polyobjs = false;
        options.compress_nodes = false;
        options.compress_gl_nodes = false;
        options.force_compression = false;
    } else if (current_engine == "nolimit" || current_engine == "boom") {
        options.build_nodes = true;
        options.build_gl_nodes = false;
        options.build_gl_only = false;
        if (build_reject) {
            options.reject_mode = ERM_Rebuild_NoGL;
        } else {
            options.reject_mode = ERM_CreateZeroes;
        }
        options.check_polyobjs = false;
        options.compress_nodes = false;
        options.compress_gl_nodes = false;
        options.force_compression = false;
    } else if (current_engine == "prboom") {
        options.build_nodes = true;
        options.build_gl_nodes = true;
        options.build_gl_only = true;
        if (build_reject) {
            options.reject_mode = ERM_Rebuild;
        } else {
            options.reject_mode = ERM_CreateZeroes;
        }
        options.check_polyobjs = false;
        options.compress_nodes = true;
        options.compress_gl_nodes = false;
        options.force_compression = false;
    } else if (current_engine == "woof") {
        options.build_nodes = true;
        options.build_gl_nodes = false;
        options.build_gl_only = false;
        if (build_reject) {
            options.reject_mode = ERM_Rebuild_NoGL;
        } else {
            options.reject_mode = ERM_CreateZeroes;
        }
        options.check_polyobjs = false;
        options.compress_nodes = true;
        options.compress_gl_nodes = false;
        options.force_compression = true;
    } else if (current_engine == "zdoom") {
        if (!build_nodes) {
            LogPrintf("Skipping nodes per user selection...\n");
            FileRename(filename, out_name);
            return true;
        }
        options.build_nodes = true;
        options.build_gl_nodes = true;
        options.build_gl_only = true;
        if (build_reject) {
            options.reject_mode = ERM_Rebuild;
        } else {
            options.reject_mode = ERM_DontTouch;
        }
        options.check_polyobjs = true;
        options.compress_nodes = true;
        options.compress_gl_nodes = true;
        options.force_compression = true;
    }

    if (zdmain(filename, options) != 0) {
        Main_ProgStatus(_("ZDBSP Error!"));
        return false;
    }

    FileRename(filename, out_name);

    return true;
}

//------------------------------------------------------------------------

class doom_game_interface_c : public game_interface_c {
   private:
    const char *filename;

   public:
    doom_game_interface_c() : filename(NULL) {}

    ~doom_game_interface_c() { StringFree(filename); }

    bool Start(const char *preset);
    bool Finish(bool build_ok);

    void BeginLevel();
    void EndLevel();
    void Property(const char *key, const char *value);

   private:
    bool BuildNodes();
};

bool doom_game_interface_c::Start(const char *preset) {
    dm_sub_format = 0;

    ef_solid_type = 0;
    ef_liquid_type = 0;
    ef_thing_mode = 0;

    if (batch_mode) {
        filename = StringDup(batch_output_file);
    } else {
        filename = DLG_OutputFilename("wad", preset);
    }

    if (!filename) {
        Main_ProgStatus(_("Cancelled"));
        return false;
    }

    if (create_backups) {
        Main_BackupFile(filename, "old");
    }

    // Need to preempt the rest of this process if we are using Vanilla Doom
    if (main_win) {
        current_engine = main_win->game_box->engine->GetID();
        if (current_engine == "vanilla") {
            build_reject = main_win->left_mods->FindID("ui_reject_options")
                           ->FindButtonOpt("bool_build_reject")
                           ->value();
            if (Slump_MakeWAD(filename) == 0) {
                return true;
            } else {
                return false;
            }
        }
    }

    if (!DM_StartWAD(filename)) {
        Main_ProgStatus(_("Error (create file)"));
        return false;
    }

    if (main_win) {
        main_win->build_box->name_disp->copy_label(FindBaseName(filename));
        main_win->build_box->name_disp->redraw();
        main_win->build_box->Prog_Init(20, N_("CSG"));
        if (current_engine == "zdoom") {
            build_reject = main_win->left_mods->FindID("ui_zdoom_map_options")
                               ->FindButtonOpt("bool_build_reject_zdoom")
                               ->value();
        } else {
            build_reject = main_win->left_mods->FindID("ui_reject_options")
                               ->FindButtonOpt("bool_build_reject")
                               ->value();
        }
        map_format = main_win->left_mods->FindID("ui_zdoom_map_options")
                         ->FindOpt("map_format")
                         ->GetID();
        build_nodes = main_win->left_mods->FindID("ui_zdoom_map_options")
                          ->FindButtonOpt("bool_build_nodes")
                          ->value();
        if (current_engine == "zdoom" && map_format == "udmf") {
            UDMF_mode = true;
        } else {
            UDMF_mode = false;
        }
    }
    return true;
}

bool doom_game_interface_c::BuildNodes() {
    char *temp_name = ReplaceExtension(filename, "tmp");

    FileDelete(temp_name);

    if (!FileRename(filename, temp_name)) {
        LogPrintf("WARNING: could not rename file to .TMP!\n");
        StringFree(temp_name);
        return false;
    }

    bool result = DM_BuildNodes(temp_name, filename);

    FileDelete(temp_name);

    StringFree(temp_name);

    return result;
}

bool doom_game_interface_c::Finish(bool build_ok) {
    // Skip DM_EndWAD if using Vanilla Doom
    if (current_engine != "vanilla") {
        // TODO: handle write errors
        DM_EndWAD();
    }

    if (build_ok) {
        build_ok = BuildNodes();
    }

    if (!build_ok) {
        // remove the WAD if an error occurred
        FileDelete(filename);
    } else {
        Recent_AddFile(RECG_Output, filename);
    }

    return build_ok;
}

void doom_game_interface_c::BeginLevel() {
    if (UDMF_mode) {
        udmf_vertexes = 0;
        udmf_sectors = 0;
        udmf_linedefs = 0;
        udmf_things = 0;
        udmf_sidedefs = 0;
    }
    DM_BeginLevel();
}

void doom_game_interface_c::Property(const char *key, const char *value) {
    if (StringCaseCmp(key, "level_name") == 0) {
        level_name = StringDup(value);
    } else if (StringCaseCmp(key, "description") == 0) {
        // ignored (for now)
        // [another mechanism sets the description via BEX/DDF]
    } else if (StringCaseCmp(key, "sub_format") == 0) {
        if (StringCaseCmp(value, "doom") == 0) {
            dm_sub_format = 0;
        } else if (StringCaseCmp(value, "hexen") == 0) {
            dm_sub_format = SUBFMT_Hexen;
        } else if (StringCaseCmp(value, "strife") == 0) {
            dm_sub_format = SUBFMT_Strife;
        } else {
            LogPrintf("WARNING: unknown DOOM sub_format '%s'\n", value);
        }
    } else if (StringCaseCmp(key, "offset_map") == 0) {
        dm_offset_map = atoi(value);
    } else if (StringCaseCmp(key, "ef_solid_type") == 0) {
        ef_solid_type = atoi(value);
    } else if (StringCaseCmp(key, "ef_liquid_type") == 0) {
        ef_liquid_type = atoi(value);
    } else if (StringCaseCmp(key, "ef_thing_mode") == 0) {
        ef_thing_mode = atoi(value);
    } else {
        LogPrintf("WARNING: unknown DOOM property: %s=%s\n", key, value);
    }
}

void doom_game_interface_c::EndLevel() {
    if (!level_name) {
        Main_FatalError("Script problem: did not set level name!\n");
    }

    if (main_win) {
        main_win->build_box->Prog_Step("CSG");
    }

    CSG_DOOM_Write();
#if 0
	CSG_TestRegions_Doom();
#endif

    DM_EndLevel(level_name);

    StringFree(level_name);
    level_name = NULL;
}

game_interface_c *Doom_GameObject() { return new doom_game_interface_c(); }

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
