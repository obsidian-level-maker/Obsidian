//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2013 Andrew Apted
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "m_cookie.h"
#include "m_lua.h"

#include "csg_main.h"
#include "q_common.h"  // qLump_c

#include "dm_extra.h"
#include "g_doom.h"


extern void CSG_DOOM_Write();

// extern void CSG_TestRegions_Doom();

extern int ef_solid_type;
extern int ef_liquid_type;
extern int ef_thing_mode;

extern int sky_bright;
extern int sky_shade;


static char *level_name;


int dm_sub_format;

int dm_offset_map;

static qLump_c *header_lump;
static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;

static int errors_seen;


typedef enum
{
	SECTION_Patches = 0,
	SECTION_Sprites,
	SECTION_Colormaps,
	SECTION_ZDoomTex,
	SECTION_Flats,

	NUM_SECTIONS
}
wad_section_e;


typedef std::vector<qLump_c *> lump_bag_t;

static lump_bag_t * sections[NUM_SECTIONS];


static const char * section_markers[NUM_SECTIONS][2] =
{
	{ "PP_START", "PP_END" },
	{ "SS_START", "SS_END" },
	{ "C_START",  "C_END"  },
	{ "TX_START", "TX_END" },

	// flats must end with F_END (a single 'F') to be vanilla compatible
	{ "FF_START", "F_END" }
};


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

void DM_WriteLump(const char *name, const void *data, u32_t len)
{
	SYS_ASSERT(strlen(name) <= 8);

	WAD_NewLump(name);

	if (len > 0)
	{
		if (! WAD_AppendData(data, len))
		{
			errors_seen++;
		}
	}

	WAD_FinishLump();
}


void DM_WriteLump(const char *name, qLump_c *lump)
{
	DM_WriteLump(name, lump->GetBuffer(), lump->GetSize());
}


static void DM_WriteBehavior()
{
	raw_behavior_header_t behavior;

	strncpy(behavior.marker, "ACS", 4);

	behavior.offset   = LE_U32(8);
	behavior.func_num = 0;
	behavior.str_num  = 0;

	DM_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}


static void DM_ClearSections()
{
	for (int k = 0 ; k < NUM_SECTIONS ; k++)
	{
		if (! sections[k])
			sections[k] = new lump_bag_t;

		for (unsigned int n = 0 ; n < sections[k]->size() ; n++)
		{
			delete sections[k]->at(n);
			sections[k]->at(n) = NULL;
		}

		sections[k]->clear();
	}
}


static void DM_WriteSections()
{
	for (int k = 0 ; k < NUM_SECTIONS ; k++)
	{
		if (sections[k]->size() == 0)
			continue;

		DM_WriteLump(section_markers[k][0], NULL, 0);

		for (unsigned int n = 0 ; n < sections[k]->size() ; n++)
		{
			qLump_c *lump = sections[k]->at(n);

			DM_WriteLump(lump->GetName(), lump);
		}

		DM_WriteLump(section_markers[k][1], NULL, 0);
	}
}


void DM_AddSectionLump(char ch, const char *name, qLump_c *lump)
{
	int k;
	switch (ch)
	{
		case 'P': k = SECTION_Patches;   break;
		case 'S': k = SECTION_Sprites;   break;
		case 'C': k = SECTION_Colormaps; break;
		case 'T': k = SECTION_ZDoomTex;  break;
		case 'F': k = SECTION_Flats;     break;

		default: 
			Main_FatalError("DM_AddSectionLump: bad section '%c'\n", ch);
			return; /* NOT REACHED */
	}

	lump->SetName(name);

	sections[k]->push_back(lump);
}


bool DM_StartWAD(const char *filename)
{
	if (! WAD_OpenWrite(filename))
	{
		DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
		return false;
	}

	errors_seen = 0;

	DM_ClearSections();

	qLump_c *info = BSP_CreateInfoLump();
	DM_WriteLump("OBLIGDAT", info);
	delete info;

	return true; //OK
}


bool DM_EndWAD()
{
	DM_WriteSections();
	DM_ClearSections();

	WAD_CloseWrite();

	return (errors_seen == 0);
}


static void DM_FreeLumps()
{
	delete header_lump;  header_lump  = NULL;
	delete thing_lump;   thing_lump   = NULL;
	delete sector_lump;  sector_lump  = NULL;
	delete vertex_lump;  vertex_lump  = NULL;
	delete sidedef_lump; sidedef_lump = NULL;
	delete linedef_lump; linedef_lump = NULL;
}


void DM_BeginLevel()
{
	DM_FreeLumps();

	header_lump  = new qLump_c();
	thing_lump   = new qLump_c();
	vertex_lump  = new qLump_c();
	sector_lump  = new qLump_c();
	linedef_lump = new qLump_c();
	sidedef_lump = new qLump_c();
}


void DM_EndLevel(const char *level_name)
{
	// terminate header lump with trailing NUL
	if (header_lump->GetSize() > 0)
	{
		const byte nuls[4] = { 0,0,0,0 };
		header_lump->Append(nuls, 1);
	}

	DM_WriteLump(level_name, header_lump);

	DM_WriteLump("THINGS",   thing_lump);
	DM_WriteLump("LINEDEFS", linedef_lump);
	DM_WriteLump("SIDEDEFS", sidedef_lump);
	DM_WriteLump("VERTEXES", vertex_lump);

	DM_WriteLump("SEGS",     NULL, 0);
	DM_WriteLump("SSECTORS", NULL, 0);
	DM_WriteLump("NODES",    NULL, 0);
	DM_WriteLump("SECTORS",  sector_lump);

	if (dm_sub_format == SUBFMT_Hexen)
		DM_WriteBehavior();

	DM_FreeLumps();
}


//------------------------------------------------------------------------


void DM_HeaderPrintf(const char *str, ...)
{
	static char message_buf[MSG_BUF_LEN];

	va_list args;

	va_start(args, str);
	vsnprintf(message_buf, MSG_BUF_LEN, str, args);
	va_end(args);

	message_buf[MSG_BUF_LEN-1] = 0;

	header_lump->Append(message_buf, strlen(message_buf));
}


void DM_AddVertex(int x, int y)
{
	if (dm_offset_map)
	{
		x += 32;
		y += 32;
	}

	raw_vertex_t vert;

	vert.x = LE_S16(x);
	vert.y = LE_S16(y);

	vertex_lump->Append(&vert, sizeof(vert));
}


void DM_AddSector(int f_h, const char * f_tex, 
		int c_h, const char * c_tex,
		int light, int special, int tag)
{
	raw_sector_t sec;

	sec.floor_h = LE_S16(f_h);
	sec.ceil_h  = LE_S16(c_h);

	strncpy(sec.floor_tex, f_tex, 8);
	strncpy(sec.ceil_tex,  c_tex, 8);

	sec.light   = LE_U16(light);
	sec.special = LE_U16(special);
	sec.tag     = LE_S16(tag);

	sector_lump->Append(&sec, sizeof(sec));
}


void DM_AddSidedef(int sector, const char *l_tex,
		const char *m_tex, const char *u_tex,
		int x_offset, int y_offset)
{
	raw_sidedef_t side;

	side.sector = LE_S16(sector);

	strncpy(side.lower_tex, l_tex, 8);
	strncpy(side.mid_tex,   m_tex, 8);
	strncpy(side.upper_tex, u_tex, 8);

	side.x_offset = LE_S16(x_offset);
	side.y_offset = LE_S16(y_offset);

	sidedef_lump->Append(&side, sizeof(side));
}


void DM_AddLinedef(int vert1, int vert2, int side1, int side2,
		int type,  int flags, int tag,
		const byte *args)
{
	if (dm_sub_format != SUBFMT_Hexen)
	{
		raw_linedef_t line;

		line.start = LE_U16(vert1);
		line.end   = LE_U16(vert2);

		line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
		line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

		line.type  = LE_U16(type);
		line.flags = LE_U16(flags);
		line.tag   = LE_S16(tag);

		linedef_lump->Append(&line, sizeof(line));
	}
	else  // Hexen format
	{
		raw_hexen_linedef_t line;

		// clear unused fields (esp. arguments)
		memset(&line, 0, sizeof(line));

		line.start = LE_U16(vert1);
		line.end   = LE_U16(vert2);

		line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
		line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

		line.special = type; // 8 bits
		line.flags = LE_U16(flags);

		// tag value is UNUSED

		if (args)
			memcpy(line.args, args, 5);

		linedef_lump->Append(&line, sizeof(line));
	}
}


void DM_AddThing(int x, int y, int h, int type, int angle, int options,
				 int tid, byte special, const byte *args)
{
	if (dm_offset_map)
	{
		x += 32;
		y += 32;
	}

	if (dm_sub_format != SUBFMT_Hexen)
	{
		raw_thing_t thing;

		thing.x = LE_S16(x);
		thing.y = LE_S16(y);

		thing.type    = LE_U16(type);
		thing.angle   = LE_S16(angle);
		thing.options = LE_U16(options);

		thing_lump->Append(&thing, sizeof(thing));
	}
	else  // Hexen format
	{
		raw_hexen_thing_t thing;

		// clear unused fields (esp. arguments)
		memset(&thing, 0, sizeof(thing));

		thing.x = LE_S16(x);
		thing.y = LE_S16(y);

		thing.height  = LE_S16(h);
		thing.type    = LE_U16(type);
		thing.angle   = LE_S16(angle);
		thing.options = LE_U16(options);

		thing.tid     = LE_S16(tid);
		thing.special = special;

		if (args)
			memcpy(thing.args, args, 5);

		thing_lump->Append(&thing, sizeof(thing));
	}
}


int DM_NumVertexes()
{
	return vertex_lump->GetSize() / sizeof(raw_vertex_t);
}

int DM_NumSectors()
{
	return sector_lump->GetSize() / sizeof(raw_sector_t);
}

int DM_NumSidedefs()
{
	return sidedef_lump->GetSize() / sizeof(raw_sidedef_t);
}

int DM_NumLinedefs()
{
	if (dm_sub_format == SUBFMT_Hexen)
		return linedef_lump->GetSize() / sizeof(raw_hexen_linedef_t);

	return linedef_lump->GetSize() / sizeof(raw_linedef_t);
}

int DM_NumThings()
{
	if (dm_sub_format == SUBFMT_Hexen)
		return thing_lump->GetSize() / sizeof(raw_hexen_thing_t);

	return thing_lump->GetSize() / sizeof(raw_thing_t);
}


//----------------------------------------------------------------------------
//  GLBSP NODE BUILDING
//----------------------------------------------------------------------------

#include "glbsp.h"


static nodebuildinfo_t nb_info;
static volatile nodebuildcomms_t nb_comms;

static int display_mode = DIS_INVALID;
static int progress_limit;

static char message_buf[MSG_BUF_LEN];


static const char *GetErrorString(glbsp_ret_e ret)
{
	switch (ret)
	{
		case GLBSP_E_OK:
			return "OK";

		// the arguments were bad/inconsistent.
		case GLBSP_E_BadArgs:
			return "Bad Arguments";

		// the info was bad/inconsistent, but has been fixed
		case GLBSP_E_BadInfoFixed:
			return "Bad Args (fixed)";

		// file errors
		case GLBSP_E_ReadError:  return "Read Error";
		case GLBSP_E_WriteError: return "Write Error";

		// building was cancelled
		case GLBSP_E_Cancelled:
			return "Cancelled by User";

		// an unknown error occurred (this is the catch-all value)
		case GLBSP_E_Unknown:
		default:
			return "Unknown Error";
	}
}

static void GB_PrintMsg(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(message_buf, MSG_BUF_LEN, str, args);
	va_end(args);

	message_buf[MSG_BUF_LEN-1] = 0;

	LogPrintf("GLBSP: %s", message_buf);
}

//
// GB_FatalError
//
// Terminates the program reporting an error.
//
static void GB_FatalError(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(message_buf, MSG_BUF_LEN, str, args);
	va_end(args);

	message_buf[MSG_BUF_LEN-1] = 0;

	Main_FatalError("glBSP Failure:\n%s", message_buf);
	/* NOT REACHED */
}

static void GB_Ticker(void)
{
	Main_Ticker();

	if (main_action >= MAIN_CANCEL)
	{
		nb_comms.cancelled = TRUE;
	}
}

static boolean_g GB_DisplayOpen(displaytype_e type)
{
	display_mode = type;
	return TRUE;
}

static void GB_DisplaySetTitle(const char *str)
{
	/* does nothing */
}

static void GB_DisplaySetBarText(int barnum, const char *str)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 1)
	{
		/* IDEA: extract map name from 'str' */

		if (batch_mode)
			fprintf(stderr, "%s\n", str);
	}
}

static void GB_DisplaySetBarLimit(int barnum, int limit)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 2 && main_win)
	{
		progress_limit = limit;

		main_win->build_box->SetStatus("Building nodes");
		main_win->build_box->Prog_Nodes(0, limit);
	}
}

static void GB_DisplaySetBar(int barnum, int count)
{
	if (display_mode == DIS_BUILDPROGRESS && barnum == 2 && main_win)
	{
		main_win->build_box->Prog_Nodes(count, progress_limit);
	}
}

static void GB_DisplayClose(void)
{
	/* does nothing */
}

static const nodebuildfuncs_t edge_build_funcs =
{
	GB_FatalError,
	GB_PrintMsg,
	GB_Ticker,

	GB_DisplayOpen,
	GB_DisplaySetTitle,
	GB_DisplaySetBar,
	GB_DisplaySetBarLimit,
	GB_DisplaySetBarText,
	GB_DisplayClose
};


static bool DM_BuildNodes(const char *filename, const char *out_name)
{
	LogPrintf("\n");

	display_mode = DIS_INVALID;

	memcpy(&nb_info,  &default_buildinfo,  sizeof(default_buildinfo));
	memcpy((void*)&nb_comms, &default_buildcomms, sizeof(nodebuildcomms_t));

	nb_info.input_file  = GlbspStrDup(filename);
	nb_info.output_file = GlbspStrDup(out_name);

	nb_info.quiet = TRUE;
	nb_info.pack_sides = FALSE;
	nb_info.force_normal = TRUE;
	nb_info.fast = TRUE;

	glbsp_ret_e ret = GlbspCheckInfo(&nb_info, &nb_comms);

	if (ret != GLBSP_E_OK)
	{
		// check info failure (unlikely to happen)
		GB_PrintMsg("Param Check FAILED: %s\n", GetErrorString(ret));
		GB_PrintMsg("Reason: %s\n\n", nb_comms.message);

		Main_ProgStatus("glBSP Error");
		return false;
	}

	ret = GlbspBuildNodes(&nb_info, &edge_build_funcs, &nb_comms);

	if (ret == GLBSP_E_Cancelled)
	{
		GB_PrintMsg("Building CANCELLED.\n\n");
		Main_ProgStatus("Cancelled");
		return false;
	}

	if (ret != GLBSP_E_OK)
	{
		// build nodes failed
		GB_PrintMsg("Building FAILED: %s\n", GetErrorString(ret));
		GB_PrintMsg("Reason: %s\n\n", nb_comms.message);

		Main_ProgStatus("glBSP Error");
		return false;
	}

	return true;
}


//------------------------------------------------------------------------

class doom_game_interface_c : public game_interface_c
{
private:
	const char *filename;

public:
	doom_game_interface_c() : filename(NULL)
	{ }

	~doom_game_interface_c()
	{
		StringFree(filename);
	}

	bool Start();
	bool Finish(bool build_ok);

	void BeginLevel();
	void EndLevel();
	void Property(const char *key, const char *value);

private:
	bool BuildNodes();
};


bool doom_game_interface_c::Start()
{
	dm_sub_format = 0;

	ef_solid_type = 0;
	ef_liquid_type = 0;
	ef_thing_mode = 0;

	if (batch_mode)
		filename = StringDup(batch_output_file);
	else
		filename = DLG_OutputFilename("wad");

	if (! filename)
	{
		Main_ProgStatus("Cancelled");
		return false;
	}

	if (create_backups)
		Main_BackupFile(filename, "old");

	if (! DM_StartWAD(filename))
	{
		Main_ProgStatus("Error (create file)");
		return false;
	}

	if (main_win)
		main_win->build_box->Prog_Init(20, "CSG");

	return true;
}


bool doom_game_interface_c::BuildNodes()
{
	char *temp_name = ReplaceExtension(filename, "tmp");

	FileDelete(temp_name);

	if (! FileRename(filename, temp_name))
	{
		LogPrintf("WARNING: could not rename file to .TMP!\n");
		StringFree(temp_name);
		return false;
	}

	bool result = DM_BuildNodes(temp_name, filename);

	FileDelete(temp_name);

	StringFree(temp_name);

	return result;
}


bool doom_game_interface_c::Finish(bool build_ok)
{
	// TODO: handle write errors
	DM_EndWAD();

	if (build_ok)
	{
		build_ok = BuildNodes();
	}

	if (! build_ok)
	{
		// remove the WAD if an error occurred
		FileDelete(filename);
	}
	else
	{
		Recent_AddFile(RECG_Output, filename);
	}

	return build_ok;
}


void doom_game_interface_c::BeginLevel()
{
	DM_BeginLevel();
}


void doom_game_interface_c::Property(const char *key, const char *value)
{
	if (StringCaseCmp(key, "level_name") == 0)
	{
		level_name = StringDup(value);
	}
	else if (StringCaseCmp(key, "description") == 0)
	{
		// ignored (for now)
		// [another mechanism sets the description via BEX/DDF]
	}
	else if (StringCaseCmp(key, "sub_format") == 0)
	{
		if (StringCaseCmp(value, "doom") == 0)
			dm_sub_format = 0;
		else if (StringCaseCmp(value, "hexen") == 0)
			dm_sub_format = SUBFMT_Hexen;
		else if (StringCaseCmp(value, "strife") == 0)
			dm_sub_format = SUBFMT_Strife;
		else
			LogPrintf("WARNING: unknown DOOM sub_format '%s'\n", value);
	}
	else if (StringCaseCmp(key, "offset_map") == 0)
	{
		dm_offset_map = atoi(value);
	}
	else if (StringCaseCmp(key, "ef_solid_type") == 0)
	{
		ef_solid_type = atoi(value);
	}
	else if (StringCaseCmp(key, "ef_liquid_type") == 0)
	{
		ef_liquid_type = atoi(value);
	}
	else if (StringCaseCmp(key, "ef_thing_mode") == 0)
	{
		ef_thing_mode = atoi(value);
	}
	else if (StringCaseCmp(key, "sky_bright") == 0)
	{
		sky_bright = atoi(value);
	}
	else if (StringCaseCmp(key, "sky_shade") == 0)
	{
		sky_shade = atoi(value);
	}
	else
	{
		LogPrintf("WARNING: unknown DOOM property: %s=%s\n", key, value);
	}
}


void doom_game_interface_c::EndLevel()
{
	if (! level_name)
		Main_FatalError("Script problem: did not set level name!\n");

	if (main_win)
		main_win->build_box->Prog_Step("CSG");

	CSG_DOOM_Write();
#if 0
	CSG_TestRegions_Doom();
#endif

	DM_EndLevel(level_name);

	StringFree(level_name);
	level_name = NULL;
}


game_interface_c * Doom_GameObject()
{
	return new doom_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
