------------------------------------------------------------------------
--  STRIFE THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  --Adapted from MsrSgtShooterPerson's Doom themes.lua file
    --Into a singular theme (Castle) for Heretic
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "F_WATR01",
    dz  = -12,
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "F_CHMOL2",
    dz = 2,
  
    trim_mat = "WOOD08",
    trim_dz = 2,
  }

}


STRIFE.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      k_id = 50,
      k_badge = 50,
      k_passcard = 50
    },

    barrels = 
    {
      barrel = 50
    },

    cave_torches =
    {
      huge_torch   = 70,
    },

    outdoor_torches = 
    {
      pole_lamp = 50
    },

    cliff_trees =
    {
      big_tree  = 50,
      palm_tree  = 50,
      tree_stub  = 15
    },

    park_decor =
    {
      tall_bush  = 50,
      short_bush  = 50,
      big_tree  = 10,
      palm_tree  = 10,
    },

    skyboxes =
    {

    },

    scenic_fences =
    {
      GRATE04 = 50
    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,

    street_sinks =
    {
      floor_default_streets = 1
    },

    streets_friendly = false,

    slump_config = 
    [[
      ;
      ; Sample SLIGE config file. (Semicolon starts a comment to end of line.)
      ;
      ; This is the SLIGE.CFG as shipped with SLIGE itself.  It contains a
      ; description of the default SLIGE configuration, as hardwired into
      ; the program.  So having this file in the current directory under the
      ; name SLIGE.CFG should produce exactly the same effect as not having
      ; any config file at all.  You can use this file as a base to build
      ; your own config files on (but if you do, you should change these
      ; comments; otherwise they'll be WRONG!).
      ;
      ; Dave Chess, dmchess@aol.com, chess@us.ibm.com

      ; The current implementation ignores everything before the
      ; [THEMES] line also, but that will change.

      [THEMES]        ; Anything after a ; is, remember, a comment

      ; We have three themes, one secret.  They should all be declared
      ; before any textures or flats or anything else.  The only valid
      ; modifier is "secret", which says that that theme should only be
      ; used on secret levels.  There should be at least one "secret"
      ; theme.

	  Theme TWN ; Town theme

      ; Flats and textures and constructs and stuff are also in the [THEMES] section

      ; Textures are described by "Texture NAME <attributes>".  Obvious
      ; attributes include "wall", "door", and so on.  Some subtler ones:
      ;
      ; "core <theme>" means that this texture should be common in that theme.
      ; "comp <theme>" means that this texture is compatible with that theme, but
      ;    not to be used all that often.
      ; "switch <texture>" means "the given texture is a good switch to use in
      ;    a room that has walls of the current texture"
      ; "isswitch" means "the current texture is a good switch to use on any
      ;    wall in a room with a compatible theme"
      ; "subtle <texture>" means "the given texture is a subtle variant of the
      ;    current texture, suitable for hinting at secrets"
      ; "yhint N" means "when using a vertical misalignment to hint at
      ;    a secret door in a wall of this texture, use a y-offset of N".  If
      ;    N is zero, it means "this wall is too visually complex to hint via a
      ;    y-misalignment at all; hint some other way".  If no "yhint" is given,
      ;    the value 5 is used.
      ;  "noDoom2" means that the texture does not exist in the usual DOOM II
      ;    IWAD.  "noDoom0" means it doesn't exist in the DOOM 1.2 IWAD, and
      ;    "noDoom1" means it's not in the DOOM 1.666 or 1.89 IWAD.  If none
      ;    of these are specified, the texture is assumed to be in all.
      ;  "size <width> <height>" gives the size of the texture.  You can leave
      ;    this out if the height is 128, and the width is some reasonable
      ;    divisor of 256 (except for doors, where you should give the real
      ;    width so SLIGE can make them look nice).

	  ; Twn walls
	  Texture BRKBRN01 size 64 128 wall core TWN subtle BRKBRN02

	  ; Twn switches
	  Texture SWBRIK01 size 64 128 isswitch comp TWN

    ; And the lift texture
    Texture ELEVTR03 size 64 128 lift comp TWN

    ; Doors of all kinds.  "size" gives the width and height of the texture,
    ; and "locked" means that it's a good texture to use on a door that only
    ; opens with a switch, not a touch.
    Texture DORMS01 size 64 128 door comp TWN
    Texture DORWL01 size 128 128 door comp TWN

	  ; Twn exit switches
	  Texture SWBRN01 size 64 128 exitswitch comp TWN

    ; Lights, suitable for lighting recesses and stuff.
    Texture LITE06 size 8 64 light comp TWN

    ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
    ; "vtiles" means that it's OK to pile one on top of another, as when
    ;    making the big central pillar in an arena.
    ; "half_plaque" means that the upper half of this texture can be used
    ;    by itself, as well as the whole thing.
    Texture WINDW01 size 64 128 plaque vtiles half_plaque comp TWN
    Texture WINDW02 size 64 128 plaque vtiles half_plaque comp TWN
    Texture WINDW03 size 64 128 plaque vtiles half_plaque comp TWN
    Texture WINDW04 size 64 128 plaque vtiles half_plaque comp TWN

    ; Gratings
    Texture GRATE01 size 32 128 grating comp TWN

    ; Colors (suitable for marking key-locked things)
    Texture BANR12 size 16 128 red comp TWN
    Texture BRKHEX06 size 16 128 yellow comp TWN
    Texture COMP40 size 16 128 blue comp TWN

    ; Step kickplates
    Texture STAIR06 size 64 8 step comp TWN

    ; "Doorjambs"
    Texture DORTRK01 size 16 128 jamb comp TWN

    ; Support textures, used in various places
    Texture IRON02 size 64 128 support comp TWN

    ; Bunch of things for outside patios (no themes applied here)
	  Texture BRKBRN04 size 128 128 outside

    ; Misc
    Texture SIGIL01 size 64 128 error

    ; Now the flats.  Keywords should all be pretty obvious...   *8)

    ; Teleport-gate floors
    Flat F_TELE1 gate comp TWN

    ; Twn floors and ceilings
    Flat F_KNTBRK floor comp TWN
    Flat F_OLDWOD ceiling comp TWN
    Flat F_DISCO1 ceiling light comp TWN

    Flat F_GRASS floor outside comp TWN
    Flat F_BGROCK ceiling outside comp TWN

    ; and nukage
    Flat F_PWATR1 nukage comp TWN
    Flat F_PWATR1 nukage red comp TWN

    ; Floors for outside areas not yet mentioned
    Flat F_GRASS outside

    ; These are the defaults, but we'll list them anyway.
    Flat F_WATR01 water
    Flat F_SKY001 sky

    ; Constructs: computers and crates and stuff that stand around in rooms
    ; This is pretty complex!  Fool with it at your peril.

    ; Family 1 is crates of various sizes and kinds
    Construct family 1 height 128 comp TWN
      top F_COVER
      Primary BOXWOD02 width 64

    ; Load the hardwired monster and object and so on data (required in
    ; this version of SLIGE; don't remove this!)
    Hardwired1

    ; Say which lamps we like in which themes, and where barrels are allowed
    ; Information like which Doom version each object is in, and which ones
    ; cast light, and which ones explode, is still hardwired.
    Thing 2028 comp TWN ; floor lamp

    ; and that's it!
    ]]
  },


  town =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {
      water = 50,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      curve = 50,
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_plain = 50,
    },

    ceiling_sinks =
    {
      sky_plain = 50,
    },

    fences =
    {
      BRKGRY01 = 80,
    },

    cage_mats =
    {
      BRKGRY01 = 80,
    },

    facades =
    {
      BRKGRY01 = 80,
      BRKGRY17 = 40,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 12,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups = 
    {
      straddle = 70,
      tall   = 80,
      grate  = 45,
      barred = 10,
      supertall = 60,
      slits = 20,
      pillbox = 20,
      slumpish = 30,
      window_crossfire = 10,
      window_arched = 10,
      window_arched_tall = 10,
      window_arched_inverted = 10
    },

    wall_groups =
    {
      PLAIN = 0.01,
      mid_band = 10,
      lite1 = 20,
      lite2 = 20,
      torches1 = 12,
      torches2 = 12,
      high_gap = 25,
      vert_gap = 25,
      wallgutters = 10,
      lamptorch = 16,
      runic = 10,
    },

    ceil_light_prob = 70,

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "F_BRKTOP",

    post_mat  = "BRKGRY01",

    streets_friendly = true,

  },

}


STRIFE.ROOM_THEMES =
{
  any_Hallway =
  {
    env  = "hallway",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Hallway_curve =
  {
    env  = "hallway",
    group = "curve",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Hallway_deuce =
  {
    env  = "hallway",
    group = "deuce",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Hallway_Vent =
  {
    env  = "hallway",
    group = "vent",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Gray =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    naturals =
    {
      F_CAVE01 = 50,
    },

    porch_floors =
    {
      F_CAVE01 = 50,
    },

  },

  any_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    walls =
    {
      F_CAVE01 = 50,
    },

  },

}
------------------------------------------------------------------------


STRIFE.ROOMS =
{
  GENERIC =
  {
    env = "any",
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50,
  },

}

function STRIFE.slump_setup()
  if ob_match_game({game = {strife=1}}) then
    if OB_CONFIG.theme == "original" or OB_CONFIG.theme == "epi" then
      PARAM.slump_config = STRIFE.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" or OB_CONFIG.theme == "bit_mixed" then
      local possible_configs = {}
      for _,tab in pairs(STRIFE.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif STRIFE.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = STRIFE.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = STRIFE.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------


OB_THEMES["town"] =
{
  label = _("Town"),
  game = "strife",
  name_class = "CASTLE",
  mixed_prob = 50,
}

