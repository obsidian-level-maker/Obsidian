
//**************************************************************************
//**
//** symbol.c
//**
//**************************************************************************

// HEADER FILES ------------------------------------------------------------

#include <string.h>
#include <stdlib.h>
#include "common.h"
#include "symbol.h"
#include "misc.h"
#include "parse.h"

// MACROS ------------------------------------------------------------------

// TYPES -------------------------------------------------------------------

typedef struct
{
	char *name;
	pcd_t directCommand;
	pcd_t stackCommand;
	int argCount;
	int optMask;
	int outMask;
	boolean hasReturnValue;
	boolean latent;
} internFuncDef_t;

// EXTERNAL FUNCTION PROTOTYPES --------------------------------------------

// PUBLIC FUNCTION PROTOTYPES ----------------------------------------------

// PRIVATE FUNCTION PROTOTYPES ---------------------------------------------

static symbolNode_t *Find(char *name, symbolNode_t *root);
static symbolNode_t *Insert(char *name, symbolType_t type,
	symbolNode_t **root);
static void FreeNodes(symbolNode_t *root);
static void FreeNodesAtDepth(symbolNode_t **root, int depth);
static void DeleteNode(symbolNode_t *node, symbolNode_t **parent_p);
static void ClearShared(symbolNode_t *root);

// EXTERNAL DATA DECLARATIONS ----------------------------------------------

// PUBLIC DATA DEFINITIONS -------------------------------------------------

// PRIVATE DATA DEFINITIONS ------------------------------------------------

static symbolNode_t *LocalRoot;
static symbolNode_t *GlobalRoot;

static internFuncDef_t InternalFunctions[] =
{
	{ "tagwait", PCD_TAGWAITDIRECT, PCD_TAGWAIT, 1, 0, 0, NO, YES },
	{ "polywait", PCD_POLYWAITDIRECT, PCD_POLYWAIT, 1, 0, 0, NO, YES },
	{ "scriptwait", PCD_SCRIPTWAITDIRECT, PCD_SCRIPTWAIT, 1, 0, 0, NO, YES },
	{ "namedscriptwait", PCD_NOP, PCD_SCRIPTWAITNAMED, 1, 0, 0, NO, YES },
	{ "delay", PCD_DELAYDIRECT, PCD_DELAY, 1, 0, 0, NO, YES },
	{ "random", PCD_RANDOMDIRECT, PCD_RANDOM, 2, 0, 0, YES, NO },
	{ "thingcount", PCD_THINGCOUNTDIRECT, PCD_THINGCOUNT, 2, 0, 0, YES, NO },
	{ "thingcountname", PCD_NOP, PCD_THINGCOUNTNAME, 2, 0, 0, YES, NO },
	{ "changefloor", PCD_CHANGEFLOORDIRECT, PCD_CHANGEFLOOR, 2, 0, 0, NO, NO },
	{ "changeceiling", PCD_CHANGECEILINGDIRECT, PCD_CHANGECEILING, 2, 0, 0, NO, NO },
	{ "lineside", PCD_NOP, PCD_LINESIDE, 0, 0, 0, YES, NO },
	{ "clearlinespecial", PCD_NOP, PCD_CLEARLINESPECIAL, 0, 0, 0, NO, NO },
	{ "playercount", PCD_NOP, PCD_PLAYERCOUNT, 0, 0, 0, YES, NO },
	{ "gametype", PCD_NOP, PCD_GAMETYPE, 0, 0, 0, YES, NO },
	{ "gameskill", PCD_NOP, PCD_GAMESKILL, 0, 0, 0, YES, NO },
	{ "timer", PCD_NOP, PCD_TIMER, 0, 0, 0, YES, NO },
	{ "sectorsound", PCD_NOP, PCD_SECTORSOUND, 2, 0, 0, NO, NO },
	{ "ambientsound", PCD_NOP, PCD_AMBIENTSOUND, 2, 0, 0, NO, NO },
	{ "soundsequence", PCD_NOP, PCD_SOUNDSEQUENCE, 1, 0, 0, NO, NO },
	{ "setlinetexture", PCD_NOP, PCD_SETLINETEXTURE, 4, 0, 0, NO, NO },
	{ "setlineblocking", PCD_NOP, PCD_SETLINEBLOCKING, 2, 0, 0, NO, NO },
	{ "setlinespecial", PCD_NOP, PCD_SETLINESPECIAL, 7, 4|8|16|32|64, 0, NO, NO },
	{ "thingsound", PCD_NOP, PCD_THINGSOUND, 3, 0, 0, NO, NO },
	{ "activatorsound", PCD_NOP, PCD_ACTIVATORSOUND, 2, 0, 0, NO, NO },
	{ "localambientsound", PCD_NOP, PCD_LOCALAMBIENTSOUND, 2, 0, 0, NO, NO },
	{ "setlinemonsterblocking", PCD_NOP, PCD_SETLINEMONSTERBLOCKING, 2, 0, 0, NO, NO },
	{ "fixedmul", PCD_NOP, PCD_FIXEDMUL, 2, 0, 0, YES, NO },
	{ "fixeddiv", PCD_NOP, PCD_FIXEDDIV, 2, 0, 0, YES, NO },
// [BC] Start of new pcodes
	{ "playerblueskull", PCD_NOP, PCD_PLAYERBLUESKULL, 0, 0, 0, YES, NO },
	{ "playerredskull", PCD_NOP, PCD_PLAYERREDSKULL, 0, 0, 0, YES, NO },
	{ "playeryellowskull", PCD_NOP, PCD_PLAYERYELLOWSKULL, 0, 0, 0, YES, NO },
	{ "playerbluecard", PCD_NOP, PCD_PLAYERBLUECARD, 0, 0, 0, YES, NO },
	{ "playerredcard", PCD_NOP, PCD_PLAYERREDCARD, 0, 0, 0, YES, NO },
	{ "playeryellowcard", PCD_NOP, PCD_PLAYERYELLOWCARD, 0, 0, 0, YES, NO },
	{ "isnetworkgame", PCD_NOP, PCD_ISNETWORKGAME, 0, 0, 0, YES, NO },
	{ "playerteam", PCD_NOP, PCD_PLAYERTEAM, 0, 0, 0, YES, NO },
	{ "playerfrags", PCD_NOP, PCD_PLAYERFRAGS, 0, 0, 0, YES, NO },
	{ "playerhealth", PCD_NOP, PCD_PLAYERHEALTH, 0, 0, 0, YES, NO },
	{ "playerarmorpoints", PCD_NOP, PCD_PLAYERARMORPOINTS, 0, 0, 0, YES, NO },
	{ "playerexpert", PCD_NOP, PCD_PLAYEREXPERT, 0, 0, 0, YES, NO },
	{ "bluecount", PCD_NOP, PCD_BLUETEAMCOUNT, 0, 0, 0, YES, NO },
	{ "redcount", PCD_NOP, PCD_REDTEAMCOUNT, 0, 0, 0, YES, NO },
	{ "bluescore", PCD_NOP, PCD_BLUETEAMSCORE, 0, 0, 0, YES, NO },
	{ "redscore", PCD_NOP, PCD_REDTEAMSCORE, 0, 0, 0, YES, NO },
	{ "isoneflagctf", PCD_NOP, PCD_ISONEFLAGCTF, 0, 0, 0, YES, NO },
	{ "getinvasionwave", PCD_NOP, PCD_GETINVASIONWAVE, 0, 0, 0, YES, NO },
	{ "getinvasionstate", PCD_NOP, PCD_GETINVASIONSTATE, 0, 0, 0, YES, NO },
	{ "music_change", PCD_NOP, PCD_MUSICCHANGE, 2, 0, 0, NO, NO },
	{ "consolecommand", PCD_CONSOLECOMMANDDIRECT, PCD_CONSOLECOMMAND, 3, 2|4, 0, NO, NO },
	{ "singleplayer", PCD_NOP, PCD_SINGLEPLAYER, 0, 0, 0, YES, NO },
// [RH] end of Skull Tag functions
	{ "setgravity", PCD_SETGRAVITYDIRECT, PCD_SETGRAVITY, 1, 0, 0, NO, NO },
	{ "setaircontrol", PCD_SETAIRCONTROLDIRECT, PCD_SETAIRCONTROL, 1, 0, 0, NO, NO },
	{ "clearinventory", PCD_NOP, PCD_CLEARINVENTORY, 0, 0, 0, NO, NO },
	{ "giveinventory", PCD_GIVEINVENTORYDIRECT, PCD_GIVEINVENTORY, 2, 0, 0, NO, NO },
	{ "takeinventory", PCD_TAKEINVENTORYDIRECT, PCD_TAKEINVENTORY, 2, 0, 0, NO, NO },
	{ "checkinventory", PCD_CHECKINVENTORYDIRECT, PCD_CHECKINVENTORY, 1, 0, 0, YES, NO },
	{ "clearactorinventory", PCD_NOP, PCD_CLEARACTORINVENTORY, 1, 0, 0, NO, NO },
	{ "giveactorinventory", PCD_NOP, PCD_GIVEACTORINVENTORY, 3, 0, 0, NO, NO },
	{ "takeactorinventory", PCD_NOP, PCD_TAKEACTORINVENTORY, 3, 0, 0, NO, NO },
	{ "checkactorinventory", PCD_NOP, PCD_CHECKACTORINVENTORY, 2, 0, 0, YES, NO },
	{ "spawn", PCD_SPAWNDIRECT, PCD_SPAWN, 6, 16|32, 0, YES, NO },
	{ "spawnspot", PCD_SPAWNSPOTDIRECT, PCD_SPAWNSPOT, 4, 4|8, 0, YES, NO },
	{ "spawnspotfacing", PCD_NOP, PCD_SPAWNSPOTFACING, 3, 4, 0, YES, NO },
	{ "setmusic", PCD_SETMUSICDIRECT, PCD_SETMUSIC, 3, 2|4, 0, NO, NO },
	{ "localsetmusic", PCD_LOCALSETMUSICDIRECT, PCD_LOCALSETMUSIC, 3, 2|4, 0, NO, NO },
	{ "setstyle", PCD_SETSTYLEDIRECT, PCD_SETSTYLE, 1, 0, 0, NO, NO },
	{ "setfont", PCD_SETFONTDIRECT, PCD_SETFONT, 1, 0, 0, NO, NO },
	{ "setthingspecial", PCD_NOP, PCD_SETTHINGSPECIAL, 7, 4|8|16|32|64, 0, NO, NO },
	{ "fadeto", PCD_NOP, PCD_FADETO, 5, 0, 0, NO, NO },
	{ "faderange", PCD_NOP, PCD_FADERANGE, 9, 0, 0, NO, NO },
	{ "cancelfade", PCD_NOP, PCD_CANCELFADE, 0, 0, 0, NO, NO },
	{ "playmovie", PCD_NOP, PCD_PLAYMOVIE, 1, 0, 0, YES, NO },
	{ "setfloortrigger", PCD_NOP, PCD_SETFLOORTRIGGER, 8, 8|16|32|64|128, 0, NO, NO },
	{ "setceilingtrigger", PCD_NOP, PCD_SETCEILINGTRIGGER, 8, 8|16|32|64|128, 0, NO, NO },
	{ "setactorposition", PCD_NOP, PCD_SETACTORPOSITION, 5, 0, 0, YES, NO },
	{ "getactorx", PCD_NOP, PCD_GETACTORX, 1, 0, 0, YES, NO },
	{ "getactory", PCD_NOP, PCD_GETACTORY, 1, 0, 0, YES, NO },
	{ "getactorz", PCD_NOP, PCD_GETACTORZ, 1, 0, 0, YES, NO },
	{ "getactorfloorz", PCD_NOP, PCD_GETACTORFLOORZ, 1, 0, 0, YES, NO },
	{ "getactorceilingz", PCD_NOP, PCD_GETACTORCEILINGZ, 1, 0, 0, YES, NO },
	{ "getactorangle", PCD_NOP, PCD_GETACTORANGLE, 1, 0, 0, YES, NO },
	{ "writetoini", PCD_NOP, PCD_WRITETOINI, 3, 0, 0, NO, NO },
	{ "getfromini", PCD_NOP, PCD_GETFROMINI, 3, 0, 0, YES, NO },
	{ "sin", PCD_NOP, PCD_SIN, 1, 0, 0, YES, NO },
	{ "cos", PCD_NOP, PCD_COS, 1, 0, 0, YES, NO },
	{ "vectorangle", PCD_NOP, PCD_VECTORANGLE, 2, 0, 0, YES, NO },
	{ "checkweapon", PCD_NOP, PCD_CHECKWEAPON, 1, 0, 0, YES, NO },
	{ "setweapon", PCD_NOP, PCD_SETWEAPON, 1, 0, 0, YES, NO },
	{ "setmarineweapon", PCD_NOP, PCD_SETMARINEWEAPON, 2, 0, 0, NO, NO },
	{ "setactorproperty", PCD_NOP, PCD_SETACTORPROPERTY, 3, 0, 0, NO, NO },
	{ "getactorproperty", PCD_NOP, PCD_GETACTORPROPERTY, 2, 0, 0, YES, NO },
	{ "playernumber", PCD_NOP, PCD_PLAYERNUMBER, 0, 0, 0, YES, NO },
	{ "activatortid", PCD_NOP, PCD_ACTIVATORTID, 0, 0, 0, YES, NO },
	{ "setmarinesprite", PCD_NOP, PCD_SETMARINESPRITE, 2, 0, 0, NO, NO },
	{ "getscreenwidth", PCD_NOP, PCD_GETSCREENWIDTH, 0, 0, 0, YES, NO },
	{ "getscreenheight", PCD_NOP, PCD_GETSCREENHEIGHT, 0, 0, 0, YES, NO },
	{ "thing_projectile2", PCD_NOP, PCD_THING_PROJECTILE2, 7, 0, 0, NO, NO },
	{ "strlen", PCD_NOP, PCD_STRLEN, 1, 0, 0, YES, NO },
	{ "sethudsize", PCD_NOP, PCD_SETHUDSIZE, 3, 0, 0, NO, NO },
	{ "getcvar", PCD_NOP, PCD_GETCVAR, 1, 0, 0, YES, NO },
	{ "setresultvalue", PCD_NOP, PCD_SETRESULTVALUE, 1, 0, 0, NO, NO },
	{ "getlinerowoffset", PCD_NOP, PCD_GETLINEROWOFFSET, 0, 0, 0, YES, NO },
	{ "getsectorfloorz", PCD_NOP, PCD_GETSECTORFLOORZ, 3, 0, 0, YES, NO },
	{ "getsectorceilingz", PCD_NOP, PCD_GETSECTORCEILINGZ, 3, 0, 0, YES, NO },
	{ "getsigilpieces", PCD_NOP, PCD_GETSIGILPIECES, 0, 0, 0, YES, NO },
	{ "getlevelinfo", PCD_NOP, PCD_GETLEVELINFO, 1, 0, 0, YES, NO },
	{ "changesky", PCD_NOP, PCD_CHANGESKY, 2, 0, 0, NO, NO },
	{ "playeringame", PCD_NOP, PCD_PLAYERINGAME, 1, 0, 0, YES, NO },
	{ "playerisbot", PCD_NOP, PCD_PLAYERISBOT, 1, 0, 0, YES, NO },
	{ "setcameratotexture", PCD_NOP, PCD_SETCAMERATOTEXTURE, 3, 0, 0, NO, NO },
	{ "grabinput", PCD_NOP, PCD_GRABINPUT, 2, 0, 0, NO, NO },
	{ "setmousepointer", PCD_NOP, PCD_SETMOUSEPOINTER, 3, 0, 0, NO, NO },
	{ "movemousepointer", PCD_NOP, PCD_MOVEMOUSEPOINTER, 2, 0, 0, NO, NO },
	{ "getammocapacity", PCD_NOP, PCD_GETAMMOCAPACITY, 1, 0, 0, YES, NO },
	{ "setammocapacity", PCD_NOP, PCD_SETAMMOCAPACITY, 2, 0, 0, NO, NO },
	{ "setactorangle", PCD_NOP, PCD_SETACTORANGLE, 2, 0, 0, NO, NO },
	{ "spawnprojectile", PCD_NOP, PCD_SPAWNPROJECTILE, 7, 0, 0, NO, NO },
	{ "getsectorlightlevel", PCD_NOP, PCD_GETSECTORLIGHTLEVEL, 1, 0, 0, YES, NO },
	{ "playerclass", PCD_NOP, PCD_PLAYERCLASS, 1, 0, 0, YES, NO },
	{ "getplayerinfo", PCD_NOP, PCD_GETPLAYERINFO, 2, 0, 0, YES, NO },
	{ "changelevel", PCD_NOP, PCD_CHANGELEVEL, 4, 8, 0, NO, NO },
	{ "sectordamage", PCD_NOP, PCD_SECTORDAMAGE, 5, 0, 0, NO, NO },
	{ "replacetextures", PCD_NOP, PCD_REPLACETEXTURES, 3, 4, 0, NO, NO },
	{ "getactorpitch", PCD_NOP, PCD_GETACTORPITCH, 1, 0, 0, YES, NO },
	{ "setactorpitch", PCD_NOP, PCD_SETACTORPITCH, 2, 0, 0, NO, NO },
	{ "setactorstate", PCD_NOP, PCD_SETACTORSTATE, 3, 4, 0, YES, NO },
	{ "thing_damage2", PCD_NOP, PCD_THINGDAMAGE2, 3, 0, 0, YES, NO },
	{ "useinventory", PCD_NOP, PCD_USEINVENTORY, 1, 0, 0, YES, NO },
	{ "useactorinventory", PCD_NOP, PCD_USEACTORINVENTORY, 2, 0, 0, YES, NO },
	{ "checkactorceilingtexture", PCD_NOP, PCD_CHECKACTORCEILINGTEXTURE, 2, 0, 0, YES, NO },
	{ "checkactorfloortexture", PCD_NOP, PCD_CHECKACTORFLOORTEXTURE, 2, 0, 0, YES, NO },
	{ "getactorlightlevel", PCD_NOP, PCD_GETACTORLIGHTLEVEL, 1, 0, 0, YES, NO },
	{ "setmugshotstate", PCD_NOP, PCD_SETMUGSHOTSTATE, 1, 0, 0, NO, NO },
	{ "thingcountsector", PCD_NOP, PCD_THINGCOUNTSECTOR, 3, 0, 0, YES, NO },
	{ "thingcountnamesector", PCD_NOP, PCD_THINGCOUNTNAMESECTOR, 3, 0, 0, YES, NO },
	{ "checkplayercamera", PCD_NOP, PCD_CHECKPLAYERCAMERA, 1, 0, 0, YES, NO },
	{ "unmorphactor", PCD_NOP, PCD_UNMORPHACTOR, 2, 2, 0, YES, NO },
	{ "getplayerinput", PCD_NOP, PCD_GETPLAYERINPUT, 2, 0, 0, YES, NO },
	{ "classifyactor", PCD_NOP, PCD_CLASSIFYACTOR, 1, 0, 0, YES, NO },
	
	{ NULL, PCD_NOP, PCD_NOP, 0, 0, 0, NO, NO }
};

static char *SymbolTypeNames[] =
{
	"SY_DUMMY",
	"SY_LABEL",
	"SY_SCRIPTVAR",
	"SY_SCRIPTALIAS",
	"SY_MAPVAR",
	"SY_WORLDVAR",
	"SY_GLOBALVAR",
	"SY_SCRIPTARRAY",
	"SY_MAPARRAY",
	"SY_WORLDARRAY",
	"SY_GLOBALARRAY",
	"SY_SPECIAL",
	"SY_CONSTANT",
	"SY_INTERNFUNC",
	"SY_SCRIPTFUNC"
};

// CODE --------------------------------------------------------------------

//==========================================================================
//
// SY_Init
//
//==========================================================================

void SY_Init(void)
{
	symbolNode_t *sym;
	internFuncDef_t *def;

	LocalRoot = NULL;
	GlobalRoot = NULL;
	for(def = InternalFunctions; def->name != NULL; def++)
	{
		sym = SY_InsertGlobal(def->name, SY_INTERNFUNC);
		sym->info.internFunc.directCommand = def->directCommand;
		sym->info.internFunc.stackCommand = def->stackCommand;
		sym->info.internFunc.argCount = def->argCount;
		sym->info.internFunc.optMask = def->optMask;
		sym->info.internFunc.outMask = def->outMask;
		sym->info.internFunc.hasReturnValue = def->hasReturnValue;
		sym->info.internFunc.latent = def->latent;
	}
}

//==========================================================================
//
// SY_Find
//
//==========================================================================

symbolNode_t *SY_Find(char *name)
{
	symbolNode_t *node;

	if((node = SY_FindGlobal(name)) == NULL)
	{
		return SY_FindLocal(name);
	}
	return node;
}

//==========================================================================
//
// SY_FindGlobal
//
//==========================================================================

symbolNode_t *SY_FindGlobal(char *name)
{
	symbolNode_t *sym = Find(name, GlobalRoot);
	if(sym != NULL && sym->unused)
	{
		MS_Message(MSG_DEBUG, "Symbol %s marked as used.\n", name);
		sym->unused = NO;
		if(sym->type == SY_SCRIPTFUNC)
		{
			PC_AddFunction(sym, 0, NULL);
		}
		else if(sym->type == SY_MAPVAR)
		{
			if(pa_MapVarCount >= MAX_MAP_VARIABLES)
			{
				ERR_Error(ERR_TOO_MANY_MAP_VARS, YES);
			}
			else
			{
				sym->info.var.index = pa_MapVarCount++;
				PC_NameMapVariable(sym->info.var.index, sym);
			}
		}
		else if(sym->type == SY_MAPARRAY)
		{
			if(pa_MapVarCount >= MAX_MAP_VARIABLES)
			{
				ERR_Error(ERR_TOO_MANY_MAP_VARS, YES);
			}
			else
			{
				sym->info.array.index = pa_MapVarCount++;
				PC_NameMapVariable(sym->info.array.index, sym);
				if(sym->type == SY_MAPARRAY)
				{
					PC_AddArray(sym->info.array.index, sym->info.array.size);
				}
			}
		}
	}
	return sym;
}

//==========================================================================
//
// SY_Findlocal
//
//==========================================================================

symbolNode_t *SY_FindLocal(char *name)
{
	return Find(name, LocalRoot);
}

//==========================================================================
//
// Find
//
//==========================================================================

static symbolNode_t *Find(char *name, symbolNode_t *root)
{
	int compare;
	symbolNode_t *node;

	node = root;
	while(node != NULL)
	{
		compare = strcmp(name, node->name);
		if(compare == 0)
		{
			if(node->type != SY_DUMMY)
			{
				return node;
			}
			else
			{
				return NULL;
			}
		}
		node = compare < 0 ? node->left : node->right;
	}
	return NULL;
}

//==========================================================================
//
// SY_InsertLocal
//
//==========================================================================

symbolNode_t *SY_InsertLocal(char *name, symbolType_t type)
{
	if(Find(name, GlobalRoot))
	{
		ERR_Error(ERR_LOCAL_VAR_SHADOWED, YES);
	}
	MS_Message(MSG_DEBUG, "Inserting local identifier: %s (%s)\n",
		name, SymbolTypeNames[type]);
	return Insert(name, type, &LocalRoot);
}

//==========================================================================
//
// SY_InsertGlobal
//
//==========================================================================

symbolNode_t *SY_InsertGlobal(char *name, symbolType_t type)
{
	MS_Message(MSG_DEBUG, "Inserting global identifier: %s (%s)\n",
		name, SymbolTypeNames[type]);
	return Insert(name, type, &GlobalRoot);
}

//==========================================================================
//
// SY_InsertGlobalUnique
//
//==========================================================================

symbolNode_t *SY_InsertGlobalUnique(char *name, symbolType_t type)
{
	if(SY_FindGlobal(name) != NULL)
	{ // Redefined
		ERR_Exit(ERR_REDEFINED_IDENTIFIER, YES, name);
	}
	return SY_InsertGlobal(name, type);
}

//==========================================================================
//
// Insert
//
//==========================================================================

static symbolNode_t *Insert(char *name, symbolType_t type,
	symbolNode_t **root)
{
	int compare;
	symbolNode_t *newNode;
	symbolNode_t *node;

	newNode = (symbolNode_t*)MS_Alloc(sizeof(symbolNode_t), ERR_NO_SYMBOL_MEM);
	newNode->name = (char*)MS_Alloc(strlen(name)+1, ERR_NO_SYMBOL_MEM);
	strcpy(newNode->name, name);
	newNode->left = newNode->right = NULL;
	newNode->type = type;
	newNode->unused = NO;
	newNode->imported = ImportMode == IMPORT_Importing;
	while((node = *root) != NULL)
	{
		compare = strcmp(name, node->name);
		root = compare < 0 ? &(node->left) : &(node->right);
	}
	*root = newNode;
	return(newNode);
}

//==========================================================================
//
// SY_FreeLocals
//
//==========================================================================

void SY_FreeLocals(void)
{
	MS_Message(MSG_DEBUG, "Freeing local identifiers\n");
	FreeNodes(LocalRoot);
	LocalRoot = NULL;
}

//==========================================================================
//
// SY_FreeGlobals
//
//==========================================================================

void SY_FreeGlobals(void)
{
	MS_Message(MSG_DEBUG, "Freeing global identifiers\n");
	FreeNodes(GlobalRoot);
	GlobalRoot = NULL;
}

//==========================================================================
//
// FreeNodes
//
//==========================================================================

static void FreeNodes(symbolNode_t *root)
{
	if(root == NULL)
	{
		return;
	}
	FreeNodes(root->left);
	FreeNodes(root->right);
	free(root->name);
	free(root);
}

//==========================================================================
//
// SY_FreeConstants
//
//==========================================================================

void SY_FreeConstants(int depth)
{
	MS_Message(MSG_DEBUG, "Freeing constants for depth %d\n", depth);
	FreeNodesAtDepth(&GlobalRoot, depth);
}

//==========================================================================
//
// FreeNodesAtDepth
//
// Like FreeNodes, but it only frees the nodes of type SY_CONSTANT that are
// marked at the specified depth. The other nodes are relinked to maintain a
// proper binary tree.
//
//==========================================================================

static void FreeNodesAtDepth(symbolNode_t **root, int depth)
{
	symbolNode_t *node = *root;

	if(node == NULL)
	{
		return;
	}
	FreeNodesAtDepth(&node->left, depth);
	FreeNodesAtDepth(&node->right, depth);
	if(node->type == SY_CONSTANT && node->info.constant.fileDepth == depth)
	{
		MS_Message(MSG_DEBUG, "Deleting constant %s\n", node->name);
		DeleteNode(node, root);
	}
}

//==========================================================================
//
// DeleteNode
//
//==========================================================================

static void DeleteNode(symbolNode_t *node, symbolNode_t **parent_p)
{
	symbolNode_t **temp;
	char *nametemp;

	if(node->type == SY_CONSTANT && node->info.constant.strValue != NULL)
	{
		free(node->info.constant.strValue);
		node->info.constant.strValue = NULL;
	}
	if(node->left == NULL)
	{
		*parent_p = node->right;
		free(node->name);
		free(node);
	}
	else if(node->right == NULL)
	{
		*parent_p = node->left;
		free(node->name);
		free(node);
	}
	else
	{
		// "Randomly" pick the in-order successor or predecessor to take
		// the place of the deleted node.
		if(rand() & 1)
		{
			// predecessor
			temp = &node->left;
			while((*temp)->right != NULL)
			{
				temp = &(*temp)->right;
			}
		}
		else
		{
			// successor
			temp = &node->right;
			while((*temp)->left != NULL)
			{
				temp = &(*temp)->left;
			}
		}
		nametemp = node->name;
		node->name = (*temp)->name;
		(*temp)->name = nametemp;
		node->type = (*temp)->type;
		node->unused = (*temp)->unused;
		node->imported = (*temp)->imported;
		node->info = (*temp)->info;
		DeleteNode(*temp, temp);
	}
}

//==========================================================================
//
// SY_ClearShared
//
//==========================================================================

void SY_ClearShared(void)
{
	MS_Message(MSG_DEBUG, "Marking library exports as unused\n");
	ClearShared(GlobalRoot);
}

//==========================================================================
//
// ClearShared
//
//==========================================================================

static void ClearShared(symbolNode_t *root)
{
	while(root != NULL)
	{
		if( root->type == SY_SCRIPTFUNC ||
			root->type == SY_MAPVAR ||
			root->type == SY_MAPARRAY)
		{
			root->unused = YES;
		}
		ClearShared(root->left);
		root = root->right;
	}
}
