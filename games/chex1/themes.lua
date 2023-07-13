------------------------------------------------------------------------
--  CHEX1 THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

CHEX1.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "FWATER1",
    dz  = -12
  },

  liquid_slime0 =
  {
    mat = "BLOOD1",
    dz = -12
  },

  liquid_slime1 =
  {
    mat = "NUKAGE1",
    dz  = -12
  },

  liquid_slime2 =
  {
    mat = "LAVA1",
    dz  = -12
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "CEIL5_1",
    dz = 2,
  
    trim_mat = "GRAYTALL",
    trim_dz = 2,
  }

}


CHEX1.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      k_yellow = 50,
      k_red = 50,
      k_blue = 50
    },

    skyboxes =
    {

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

      Theme MIL
      Theme RED secret


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

      ; MIL walls ; note that in MIL the walls all have explicit switches
      Texture BRONZE4 wall core MIL subtle BRONZE3 switch SW1TEK noDoom0 noDoom1
      Texture STARTAN1 wall core MIL subtle STARTAN2 switch SW1STRTN noDoom2
      Texture STARTAN3 wall core MIL subtle STARG3 switch SW1STRTN
      Texture STARTAN2 wall core MIL subtle STARBR2 switch SW1STRTN
      Texture STARG3 wall core MIL subtle STARGR1 switch SW1STRTN
      Texture STARG2 wall core MIL subtle STARG1 switch SW1STRTN
      Texture STARG1 wall core MIL subtle STARG2 switch SW1STRTN
      Texture BROWN96 wall core MIL subtle BROWNGRN switch SW1DIRT
      Texture TEKGREN2 wall core MIL subtle TEKGREN1 switch SW1TEK noDoom0 noDoom1
      Texture BROWN1 wall core MIL switch SW1BRN2
      Texture STONE wall core MIL subtle GRAY1 switch SW1GRAY
      Texture STONE6 wall comp MIL subtle STONE7 switch SW1STON6 noDoom0 noDoom1
      Texture BROWNGRN wall core MIL subtle BROWN96 switch SW1BRNGN
      Texture SLADWALL wall core MIL subtle BROWNGRN switch SW1SLAD
      Texture PIPEWAL2 wall comp MIL subtle PIPEWAL1 switch SW1COMP noDoom0 noDoom1
      Texture GRAYALT wall core MIL switch SW1GRAY noDoom0 noDoom1 custom
      Texture TEKVINE wall comp MIL subtle TEKWALL1 switch SW1TEK yhint 0 noDoom0 noDoom1 custom
      Texture SPACEW4 wall comp MIL switch SW1TEK noDoom0 noDoom1
      Texture METAL5 wall comp MIL subtle METAL3 switch SW1MET2 noDoom0 noDoom1
      Texture METAL2 switch SW1MET2 noDoom0 noDoom1
      Texture COMPUTE3 wall comp MIL switch SW1STRTN noDoom2
      Texture TEKWALL4 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture TEKWALL1 wall comp MIL subtle COMPWERD switch SW1COMP yhint 2
      Texture GRAY1 wall comp MIL subtle ICKWALL3 switch SW1GRAY
      Texture GRAY7 wall comp MIL subtle GRAY1 switch SW1GRAY1
      Texture ICKWALL3 wall comp MIL subtle ICKWALL7 switch SW2GRAY
      Texture BROVINE2 wall comp MIL switch SW1SLAD yhint 2
      Texture METAL1 wall comp MIL switch SW1METAL
      Texture STARBR2 wall comp MIL subtle STARTAN2 switch SW1STRTN


      ; And the lift texture
      Texture PLAT1 size 128 128 lift comp MIL


      ; RED walls
      Texture SP_HOT1 wall core RED
      Texture REDWALL wall core RED
      Texture FIREBLU1 wall core RED subtle FIREMAG1 yhint 0
      Texture SW1HOT isswitch comp RED
      ; a wall version of SKY3, just for fun.  You can comment this
      ; out if you think it looks ugly.
      Texture SKY3_W wall comp RED realname SKY3

      ; Doors of all kinds.  "size" gives the width and height of the texture,
      ; and "locked" means that it's a good texture to use on a door that only
      ; opens with a switch, not a touch.
      Texture TEKBRON2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR4 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR3 size 64 128 door comp MIL noDoom0 noDoom1
      Texture SPCDOOR2 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture SPCDOOR1 size 64 128 door comp MIL  noDoom0 noDoom1
      Texture DOORHI size 64 128 door comp MIL noDoom2
      Texture DOOR3 size 64 72 door comp MIL 
      Texture DOOR1 size 64 72 door comp MIL 
      Texture WOODSKUL size 64 128 door comp RED noDoom2
      Texture WOODMET2 size 64 128 door comp RED noDoom0 noDoom1
      Texture WOODGARG size 64 128 door comp RED
      Texture BIGDOOR4 size 128 128 door comp MIL 
      Texture BIGDOOR3 size 128 128 door comp MIL 
      Texture BIGDOOR2 size 128 128 door comp MIL 
      Texture BIGDOOR1 size 128 96 door comp MIL
      Texture BIGDOOR7 size 128 128 door comp RED 
      Texture BIGDOOR6 size 128 112 door comp RED 
      Texture BIGDOOR5 size 128 128 door comp RED
      Texture METAL size 64 128 door comp RED
      ; Our two custom locked-door textures
      Texture DOORSKUL size 64 72 door locked comp MIL noDoom0 noDoom1 custom
      Texture SLDOOR1 size 64 128 door locked comp MIL realname SP_DUDE5 custom

      ; Exit switches, suitable for use on any level-ending switch.  All are
      ; custom, and Doom2-only.
      Texture EXITSWIR exitswitch comp RED noDoom0 noDoom1 custom
      Texture EXITSWIT exitswitch comp MIL noDoom0 noDoom1 custom

      ; Lights, suitable for lighting recesses and stuff.
      Texture BFALL1 size 8 128 light comp RED noDoom0 noDoom1
      Texture LITEREDL size 8 128 light comp RED realname LITERED noDoom2
      Texture TEKLITE light comp MIL noDoom0 noDoom1
      Texture LITE4 light comp MIL noDoom2
      Texture LITE5 light comp MIL
      Texture LITE3 light comp MIL

      ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
      ; "vtiles" means that it's OK to pile one on top of another, as when
      ;    making the big central pillar in an arena.
      ; "half_plaque" means that the upper half of this texture can be used
      ;    by itself, as well as the whole thing.
      Texture SILVER3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture SPACEW3 plaque vtiles comp MIL noDoom0 noDoom1
      Texture COMPSTA2 plaque vtiles half_plaque comp MIL
      Texture COMPSTA1 plaque vtiles half_plaque comp MIL
      Texture COMP2 plaque vtiles half_plaque comp MIL
      Texture COMPTALL plaque vtiles comp MIL
      Texture COMPUTE1 plaque vtiles half_plaque comp MIL noDoom2
      Texture PLANET1 plaque vtiles half_plaque comp MIL noDoom2
      Texture SKIN2 plaque vtiles comp RED
      Texture GSTFONT1 plaque comp RED
      Texture FIREMAG1 plaque comp red
      ; Some people think these next two look silly;
      ; you can comment them out if you want to.
      ; Texture SKY1 plaque  
      ; Texture SKY3 plaque comp RED

      ; Gratings
      Texture BRNBIGC grating comp MIL noDoom2
      Texture MIDSPACE grating comp MIL noDoom0 noDoom1
      Texture MIDVINE1 grating comp MIL comp RED noDoom2
      Texture MIDBARS1 grating comp MIL comp RED  noDoom0 noDoom1
      Texture MIDGRATE grating comp MIL comp RED 

      ; Colors (suitable for marking key-locked things)
      Texture LITERED size 8 128 red comp MIL noDoom2
      Texture DOORRED size 8 128 red comp MIL 
      Texture DOORRED2 size 16 128 red  comp RED 
      Texture DOORYEL size 8 128 yellow comp MIL 
      Texture DOORYEL2 size 16 128 yellow comp RED 
      Texture LITEBLU4 size 16 128 blue comp MIL
      Texture LITEBLU1 size 8 128 blue comp MIL
      Texture DOORBLU size 8 128 blue comp MIL 
      Texture DOORBLU2 size 16 128 blue comp RED 

      ; Step kickplates
      Texture STEP6 size 256 16 step comp MIL 
      Texture STEP5 size 256 16 step comp MIL 
      Texture STEP4 size 256 16 step comp MIL
      Texture STEP3 size 256 8 step comp MIL 
      Texture STEP2 size 256 8 step comp MIL
      Texture STEP1 size 256 8 step comp MIL 

      ; "Doorjambs"
      Texture FIRELAVA jamb comp RED
      Texture DOORTRAK jamb comp MIL
      Texture DOORSTOP jamb comp MIL
      ; Texture PIPE2 jamb comp MIL   ; PIPE2 is also a wall texture

      ; Support textures, used in various places
      Texture SKSNAKE2 support comp RED
      Texture ROCKRED1 support comp RED
      Texture COMPSPAN support comp MIL 
      Texture SUPPORT2 support comp MIL 
      Texture SHAWN2 support comp MIL  
      Texture ASHWALL3 support  noDoom0 noDoom1
      Texture ASHWALL support  noDoom2
      Texture BROWNHUG support  comp MIL  
      Texture METAL support comp RED

      ; Bunch of things for outside patios (no themes applied here)
      Texture ZIMMER1 outside noDoom0 noDoom1
      Texture ZIMMER2 outside noDoom0 noDoom1
      Texture ZIMMER3 outside noDoom0 noDoom1
      Texture ZIMMER4 outside noDoom0 noDoom1
      Texture ZIMMER5 outside noDoom0 noDoom1
      Texture ZIMMER7 outside noDoom0 noDoom1
      Texture ZIMMER8 outside noDoom0 noDoom1
      Texture TANROCK5 outside noDoom0 noDoom1
      Texture TANROCK4 outside noDoom0 noDoom1
      Texture TANROCK2 outside noDoom0 noDoom1
      Texture STUCCO outside noDoom0 noDoom1
      Texture STONE6 outside noDoom0 noDoom1
      Texture ROCK1 outside noDoom0 noDoom1
      Texture MODWALL1 outside noDoom0 noDoom1
      Texture BSTONE1 outside noDoom0 noDoom1
      Texture BRICK4 outside noDoom0 noDoom1
      Texture ASHWALL7 outside noDoom0 noDoom1
      Texture ASHWALL6 outside noDoom0 noDoom1
      Texture ASHWALL4 outside noDoom0 noDoom1
      Texture ASHWALL2 outside noDoom0 noDoom1
      Texture SP_ROCK1 outside
      Texture GRAYVINE outside
      Texture ICKWALL3 outside
      Texture BROWN144 outside
      Texture GSTONE1 outside
      Texture GSTVINE1 outside
      Texture BRICK10 outside NoDoom0 NoDoom1
      Texture ASHWALL3 outside NoDoom0 NoDoom1
      Texture ASHWALL outside NoDoom2
      Texture BROWNHUG outside

      ; Misc
      Texture EXITSIGN gateexitsign
      Texture REDWALL error

      ; This silly texture has the switch in the wrong half!
      Texture SW1DIRT ybias 72
      Texture SW1MET2 ybias 64

      ; Now the flats.  Keywords should all be pretty obvious...   *8)

      ; Teleport-gate floors
      Flat SLGATE1 gate  comp MIL  comp RED custom
      Flat GATE4 gate comp MIL comp RED 
      Flat GATE3 gate comp MIL comp RED 
      Flat GATE2 gate comp MIL comp RED 
      Flat GATE1 gate comp MIL comp RED 

      ; Floors and ceilings for MIL theme
      Flat SLLITE1 ceiling light comp MIL custom
      Flat TLITE6_6 ceiling light comp MIL
      Flat TLITE6_5 ceiling light comp MIL
      Flat FLOOR7_1 ceiling outside comp MIL
      Flat FLOOR5_2 ceiling comp MIL
      Flat CEIL3_1 ceiling comp MIL
      Flat CEIL3_2 ceiling comp MIL
      Flat CEIL3_5 ceiling comp MIL
      Flat FLAT14 floor comp MIL
      Flat FLOOR4_1 floor comp MIL
      Flat FLOOR4_8 floor comp MIL
      Flat FLOOR5_1 floor comp MIL
      Flat FLOOR3_3 floor ceiling comp MIL 
      Flat FLOOR0_2 floor comp MIL
      Flat FLOOR0_1 floor comp MIL
      Flat FLAT1_2 floor outside comp MIL
      Flat FLAT5 floor comp MIL
      Flat SLIME14 floor comp MIL noDoom0 noDoom1
      Flat SLIME15 floor comp MIL noDoom0 noDoom1
      Flat SLIME16 floor comp MIL noDoom0 noDoom1
      ; and nukage
      Flat NUKAGE1 nukage comp MIL
      Flat SLIME01 nukage comp MIL noDoom0 noDoom1

      ; Floors and ceilings for (secret) RED theme
      Flat SLSPARKS floor comp RED custom
      Flat SFLR6_4 floor ceiling comp RED
      Flat TLITE6_5 ceiling light comp RED
      Flat FLOOR6_1 floor ceiling red comp RED
      Flat FLOOR1_7 ceiling light comp RED
      Flat FLOOR1_6 floor ceiling red comp RED
      Flat FLAT5_3 floor ceiling red comp RED
      Flat LAVA1 nukage comp RED
      Flat BLOOD1 nukage red comp RED
      Flat RROCK05 nukage comp RED noDoom0 noDoom1

      ; Floors for outside areas not yet mentioned
      Flat SLGRASS1 outside custom
      Flat SLIME13 outside noDoom0 noDoom1
      Flat RROCK19 outside noDoom0 noDoom1
      Flat RROCK16 outside noDoom0 noDoom1
      Flat RROCK11 outside noDoom0 noDoom1
      Flat GRNROCK outside noDoom0 noDoom1
      Flat GRASS2 outside noDoom0 noDoom1
      Flat GRASS1 outside noDoom0 noDoom1
      Flat MFLR8_4 outside
      Flat MFLR8_3 outside
      Flat MFLR8_2 outside
      Flat FLAT5_7 outside
      Flat FLAT10 outside

      ; These are the defaults, but we'll list them anyway.
      Flat FWATER1 water
      Flat F_SKY1 sky

      ; Constructs: computers and crates and stuff that stand around in rooms
      ; This is pretty complex!  Fool with it at your peril.

      ; Family 1 is silver-colored computers; short ones and tall ones
      Construct family 1 height 64 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary COMPUTE1 yoffsets 0 64
        Primary COMPSTA2
        Primary COMPSTA1
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16
      Construct family 1 height 128 comp MIL 
        top FLAT9 top FLAT4 top FLAT23 top FLAT19 top FLAT18 top CRATOP1 top COMP01
        Primary SILVER3
        Primary COMPUTE1 yoffsets 0 64
        Secondary SILVER2 width 64
        Secondary SILVER1 width 64
        Secondary SUPPORT2 width 16
        Secondary SHAWN2 width 16

      ; Family 2 is dark-colored computers; short and tall
      Construct family 2 height 64 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 yoffsets 0 64 width 64
        Primary COMPTALL yoffsets 0 64 width 256
        Primary COMP2 yoffsets 0 64 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16
      Construct family 2 height 128 comp MIL
        top CEIL5_1 top FLAT4 top TLITE6_1
        Primary SPACEW3 width 64
        Primary COMPTALL width 256
        Primary COMP2 width 256
        Secondary METAL7 yoffsets 0 64 width 64
        Secondary METAL6 yoffsets 0 64 width 64
        Secondary METAL5 yoffsets 0 64 width 64
        Secondary METAL3 yoffsets 0 64 width 64
        Secondary METAL2 yoffsets 0 64 width 64
        Secondary COMPWERD width 64
        Secondary COMPSPAN width 16

      ; Family 3 is crates of various sizes and kinds
      Construct family 3 height 64  comp MIL 
        top CRATOP2
        Primary CRATWIDE yoffsets 64 64
        Primary CRATE1 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATWIDE
        Primary CRATE2 width 64
      Construct family 3 height 64  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 32  comp MIL 
        top CRATOP1
        Primary CRATELIT width 32
      Construct family 3 height 16  comp MIL 
        top CRATOP1
        Primary CRATINY width 16

      ; And Family 4 is bookcases; works only in Doom2
      Construct family 4 height 128 noDoom0 noDoom1
        top FLAT5_1 top CRATOP2 top CEIL5_2 top CEIL3_3 top CEIL1_1
        Secondary PANEL5 width 64
        Secondary PANCASE2 width 64
        Secondary PANCASE1 width 64
        Secondary PANBORD2 width 16
        Secondary PANBORD1 width 32
        Primary PANBOOK width 64

      ; Mask-adjustments for the construct textures that need it
      Texture PANEL5 noDoom0 noDoom1
      Texture PANCASE2 noDoom0 noDoom1
      Texture PANCASE1 noDoom0 noDoom1
      Texture PANBORD2 noDoom0 noDoom1
      Texture PANBORD1 noDoom0 noDoom1
      Texture METAL7 noDoom0 noDoom1
      Texture METAL6 noDoom0 noDoom1
      Texture METAL2 noDoom0 noDoom1
      Texture COMP2 noDoom2
      Texture SILVER2 noDoom0 noDoom1
      Texture SILVER1 noDoom0 noDoom1

      ; Load the hardwired monster and object and so on data (required in
      ; this version of SLIGE; don't remove this!)
      Hardwired1

      ; Say which lamps we like in which themes, and where barrels are allowed
      ; Information like which Doom version each object is in, and which ones
      ; cast light, and which ones explode, is still hardwired.
      Thing 2035 comp MIL  ; barrel
      Thing 34  comp MIL    ; candle
      ;Thing 44     ; tall blue torch
      ;Thing 45     ; tall green torch
      Thing 46 comp RED  ; tall red torch
      ;Thing 55 comp RED    ; short blue torch
      ;Thing 56 comp RED    ; short green torch
      Thing 57 comp RED  ; short red torch
      Thing 48 comp MIL             ; electric pillar
      Thing 2028 comp MIL
      Thing 85 comp MIL
      Thing 86 comp MIL
      Thing 70 comp MIL     ; flaming barrel
      ;Thing 35              ; candelabra

      ; and that's it!
    ]]
  },

  -- Themes by Cubebert --

  bazoik =
  {

   style_list =
    {
      caves = { none=80, few=12, some=5, heaps=3 },
      outdoors = { none=80, few=18, some=2 },
      pictures = { few=80, some=20, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=60, few=20, some=10, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=15, few=60, some=20, heaps=5 },
      ambushes = { none=5, few=50, some=45, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=80, few=10, some=10 }
    },

    liquids =
    {
      slime0 = 15,
      slime1 = 10
    },


    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50,
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_slime0 = 50,
      liquid_slime1 = 25,
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      FLOOR0_6 = 30,
    },

    cage_mats =
    {
      GRAY7 = 10,
      STARG3 = 30
    },

    facades =
    {
      STARG3 = 50,
      CEMENT5 = 10,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 12,
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
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

    cave_torches =
    {
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      LITE4 = 30,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "FLAT1_1",

    post_mat  = "FLOOR0_6",
	
	skyboxes =
    {

    },

  },
  
  spaceport =
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
      barrels = { none=10, few=50, some=20, heaps=5 }
    },

    liquids =
    {
      water = 50,
    },
	
    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50,
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_plain = 50
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      SP_DUDE1 = 30,
	    BROWNHUG = 5,
    },
	
    cage_mats =
    {
      SP_DUDE1 = 30,
      MUSEUM = 10
    },
	
    facades =
    {
      SP_DUDE1 = 30,
    },
	
    fence_groups =
    {
      PLAIN = 50,
      crenels = 12,
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
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

    cave_torches =
    {
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      DOORSTOP = 80
    },
	
    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "CEIL5_1",

    post_mat  = "FLOOR0_6",
	
	  skyboxes =
    {

    },

    streets_friendly = true
  
  },
  
  villa =
  {

   style_list =
    {
      caves = { none=50, few=25, some=15, heaps=10 },
      outdoors = { none=60, few=31, some=9 },
      pictures = { few=50, some=40, heaps=30 },
      hallways = { none=30, few=60, some=25, heaps=20 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=70, few=15, some=5, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=15, few=60, some=20, heaps=5 },
      ambushes = { none=5, few=50, some=45, heaps=30 },
      teleporters = { none=30, few=50, some=35, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=60, heaps=35 },
      barrels = { none=10, few=40, some=30, heaps=10 }
    },

    liquids =
    {
      slime0 = 15,
      slime1 = 10,
	  water = 10,
    },


    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50,
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_slime0 = 50,
      liquid_slime1 = 25,
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      CJLODG01 = 30,
    },

    cage_mats =
    {
      CJVILL01 = 20,
    },

    facades =
    {
      SP_DUDE1 = 30,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 12,
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
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

    cave_torches =
    {
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      LITE4 = 30,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "FLAT1_1",

    post_mat  = "FLOOR0_6",
	
	skyboxes =
    {

    },
	
   },

}

CHEX1.ROOM_THEMES =
{

  ---- BAZOIK THEME --------------------------------

  bazoik_Generic =
  {
    env  = "building",
    prob = 50,
  
    walls =
    {
	  SP_DUDE2 = 25,
	  TEKWALL5 = 25,
	  BROWN = 25,
      STARG3  = 25,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  },
  
  bazoik_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 10,
      SW2SATYR = 25,
	  TEKWALL5 = 25,
	  BROWN = 25,
      STARG3  = 15,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  bazoik_curve_Hallway =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 10,
	  SP_DUDE2 = 20,
	  TEKWALL5 = 25,
	  BROWN = 25,
      STARG3  = 20,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },

  bazoik_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 10,
	  SP_DUDE2 = 20,
	  TEKWALL5 = 25,
	  BROWN = 25,
      STARG3  = 20,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  bazoik_Outdoors =
  {
    env  = "outdoor",
    prob = 50,
  
    floors =
    {
      CEIL3_1 = 50,
    },
  
    naturals =
    {
      BIGDOOR2 = 50,
      BAZOIK1 = 50
    },
  
    porch_floors =
    {
      FLAT1_1 = 50,
      CJFCOMM5 = 50
    },
  
  },
  
  bazoik_Cave =
  {
    env  = "cave",
    prob = 50,
  
    floors =
    {
      CEIL3_1 = 50,
    },
  
    walls =
    {
      BIGDOOR2 = 50,
      BAZOIK1 = 50
    }
  
  },
  
  ---- SPACEPORT THEME --------------------------------

  spaceport_Generic =
  {
    env  = "building",
    prob = 50,
  
    walls =
    {
	  SW2SATYR = 25,
	  BROWN1 = 25,
      CITYWALL  = 50,
    },
  
    floors =
    {
      CEIL5_1 = 50,
      SW2SATYR = 50,
      MUSEUM = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  },
  
  spaceport_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
  
    walls =
    {
	  SW2SATYR = 25,
	  BROWN1 = 25,
      CITYWALL  = 50,
    },
  
    floors =
    {
      CEIL5_1 = 50,
      SW2SATYR = 50,
      MUSEUM = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  spaceport_curve_Hallway =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
  
    walls =
    {
	  SW2SATYR = 25,
	  BROWN1 = 25,
      CITYWALL  = 50,
    },
  
    floors =
    {
      CEIL5_1 = 50,
      SW2SATYR = 50,
      MUSEUM = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },

  spaceport_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
  
    walls =
    {
	  SW2SATYR = 25,
	  BROWN1 = 25,
      CITYWALL = 50,
    },
  
    floors =
    {
      CEIL5_1 = 50,
      SW2SATYR = 50,
      MUSEUM = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  spaceport_Outdoors =
  {
    env  = "outdoor",
    prob = 50,
  
    floors =
    {
      CJFGRAS1 = 50,
    },
  
    naturals =
    {
      CJCLIF01 = 50,
      CJFGRAS1 = 50
    },
  
    porch_floors =
    {
      SW2SATYR = 50,
      CJFCOMM3 = 50
    },
  
  },
  
  spaceport_Cave =
  {
    env  = "cave",
    prob = 50,
  
    floors =
    {
      ENDFLAT2 = 50,
    },
  
    walls =
    {
      SEWER1 = 50,
      SEWER2 = 50
    }
  
  },
  
  ---- VILLA THEME --------------------------------

  villa_Generic =
  {
    env  = "building",
    prob = 50,
  
    walls =
    {
	  SP_DUDE2 = 25,
	  TEKWALL5 = 25,
	  BROWN = 25,
      STARG3  = 25,
    },
  
    floors =
    {
      CJFVIL01 = 50,
      CJFVIL02 = 50,
      CJFLOD01 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  },
  
  villa_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
  
    walls =
    {
      CJVILL01 = 50,
    },
  
    floors =
    {
      CJFVIL02 = 50,
      CJFVIL04 = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  villa_curve_Hallway =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
  
    walls =
    {
      CJVILL01 = 50,
    },
  
    floors =
    {
      CJFVIL02 = 50,
      CJFVIL04 = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },

  villa_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
  
    walls =
    {
      CJVILL01 = 50,
    },
  
    floors =
    {
      CJFVIL02 = 50,
      CJFVIL04 = 50,
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      FLOOR0_6 = 25
    }
  
  },
  
  villa_Outdoors =
  {
    env  = "outdoor",
    prob = 50,
  
    floors =
    {
      CJFCRA03 = 50,
    },
  
    naturals =
    {
      CJMINE02 = 50,
      CJCLIF01 = 50
    },
  
    porch_floors =
    {
      CJFVIL01 = 50,
      CJFVIL02 = 50
    },
  
  },
  
  villa_Cave =
  {
    env  = "cave",
    prob = 50,
  
    floors =
    {
      CJFSHIP3 = 50,
	  CJFSHIP2 = 50,
    },
  
    walls =
    {
      CJSHIP02 = 50,
      CJSHIP05 = 50
    }
  
  },

}
------------------------------------------------------------------------


CHEX1.ROOMS =
{
  GENERIC =
  {
    env = "any"
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50
  },

}


function CHEX1.slump_setup()
  if ob_match_game({game = {chex1=1}}) then
    if OB_CONFIG.theme == "original" or OB_CONFIG.theme == "epi" then
      PARAM.slump_config = CHEX1.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" or OB_CONFIG.theme == "bit_mixed" then
      local possible_configs = {}
      for _,tab in pairs(CHEX1.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif CHEX1.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = CHEX1.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = CHEX1.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------

OB_THEMES["bazoik"] =
{
  label = _("Bazoik"),
  game = "chex1",
  name_class = "TECH",
  mixed_prob = 34
}

OB_THEMES["spaceport"] =
{
  label = _("Chextropolis"),
  game = "chex1",
  name_class = "URBAN",
  mixed_prob = 33
}

OB_THEMES["villa"] =
{
  label = _("Villa Chex"),
  game = "chex1",
  name_class = "URBAN",
  mixed_prob = 33
}