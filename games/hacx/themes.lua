------------------------------------------------------------------------
--  HACX THEMES
------------------------------------------------------------------------

HACX.SINKS =
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
    mat = water,
    dz  = -12
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "RROCK02",
    dz = 2,
  
    trim_mat = "PLAT1",
    trim_dz = 2,
  }
}


HACX.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      kz_red = 50,
      kz_yellow = 50,
      kz_blue = 50
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

	  Theme CYB ; "Cyberspace" theme

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

	  ; Cyb walls
	  Texture BRICK10 size 128 128 wall core CYB
	  Texture ASHWALL2 size 128 128 wall core CYB subtle TEKWALL1
    Texture COMPUTE2 size 128 128 wall core CYB
	  Texture BROWNHUG size 64 128 wall core CYB subtle BROWN96
    Texture BROWNPIP size 128 128 wall core CYB
    Texture STONE2 size 128 128 wall core CYB
    Texture STONE size 128 128 wall core CYB
    Texture BRNSMAL1 size 128 128 wall core CYB subtle BRNSMALL

	  ; Cyb switches
	  Texture SW1BRNGN size 128 128 ybias 82 isswitch comp CYB

    ; And the lift texture
    Texture BIGDOOR1 size 128 128 lift comp CYB

    ; Doors of all kinds.  "size" gives the width and height of the texture,
    ; and "locked" means that it's a good texture to use on a door that only
    ; opens with a switch, not a touch.
    Texture BIGDOOR2 size 128 128 door comp CYB

	  ; Cyb exit switches
	  Texture DOORRED size 128 128 exitswitch comp CYB

    ; Lights, suitable for lighting recesses and stuff.
    Texture HW208 size 8 64 light comp CYB

    ; "Plaques", suitable for wall consoles and paintings and pillars and stuff.
    ; "vtiles" means that it's OK to pile one on top of another, as when
    ;    making the big central pillar in an arena.
    ; "half_plaque" means that the upper half of this texture can be used
    ;    by itself, as well as the whole thing.
    Texture COMPSTA1 size 16 128 plaque vtiles comp CYB

    ; Gratings
    Texture SLADRIP1 size 128 128 grating comp CYB

    ; Colors (suitable for marking key-locked things)
    Texture HW510 size 8 128 red comp CYB
    Texture HW511 size 8 128 yellow comp CYB
    Texture HW512 size 8 128 blue comp CYB

    ; Step kickplates
    Texture HW216 size 64 8 step comp CYB

    ; "Doorjambs"
    Texture HW513 size 16 128 jamb comp CYB

    ; Support textures, used in various places
    Texture BIGBRIK3 size 128 128 support comp CYB

    ; Bunch of things for outside patios (no themes applied here)
	  Texture BRICK10 size 128 128 outside

    ; Misc
    Texture TANROCK2 size 128 128 error

    ; Now the flats.  Keywords should all be pretty obvious...   *8)

    ; Teleport-gate floors
    Flat BLOOD1 gate comp CYB

    ; Cyb floors and ceilings
    Flat FLOOR0_3 floor comp CYB
    Flat FLOOR0_3 ceiling comp CYB
    Flat FLOOR0_3 ceiling light comp CYB
    Flat FLOOR4_5 floor comp CYB
    Flat FLOOR4_5 ceiling comp CYB
    Flat FLOOR4_5 ceiling light comp CYB
    Flat COMP01 floor comp CYB
    Flat COMP01 ceiling comp CYB
    Flat CEIL1_2 floor comp CYB
    Flat CEIL1_2 ceiling comp CYB
    Flat CEIL3_6 floor comp CYB
    Flat CEIL3_6 ceiling comp CYB
    Flat FLAT1 floor comp CYB
    Flat FLAT1 ceiling comp CYB
    Flat SLIME05 floor outside comp CYB
    Flat MFLR8_4 ceiling outside comp CYB

    ; and nukage
    Flat NUKAGE1 nukage comp CYB
    Flat LAVA1 nukage red comp CYB

    ; Floors for outside areas not yet mentioned
    Flat SLIME05 outside

    ; These are the defaults, but we'll list them anyway.
    Flat FWATER1 water
    Flat F_SKY1 sky

    ; Constructs: computers and crates and stuff that stand around in rooms
    ; This is pretty complex!  Fool with it at your peril.

    ; Family 1 is crates of various sizes and kinds
    Construct family 1 height 128 comp CYB
      top FLOOR0_2
      Primary BLAKWAL2 width 128

    ; Load the hardwired monster and object and so on data (required in
    ; this version of SLIGE; don't remove this!)
    Hardwired1

    ; Say which lamps we like in which themes, and where barrels are allowed
    ; Information like which Doom version each object is in, and which ones
    ; cast light, and which ones explode, is still hardwired.
    Thing 2028 comp CYB ; floor lamp

    ; and that's it!
    ]]
  },


  genemp =
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
      water2 = 40,
      water  = 50,
      elec = 10
    },

    narrow_halls =
    {

    },

    wide_halls =
    {

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
      BRICK8 = 30,
    },

    cage_mats =
    {
      MODWALL3 = 30,
    },

    facades =
    {
      MODWALL3 = 30,
    },

    fence_groups =
    {
      PLAIN = 50,
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
      square = 40,
      tall   = 80,
    },

    wall_groups =
    {
      PLAIN = 0.01,
    },

    cliff_trees =
    {
      tree = 50,
    },

    park_decor =
    {
      tree = 50,
    },

    cave_torches =
    {
      rock = 50
    },

    outdoor_torches =
    {
      standing_lamp = 50
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      BRIDGE_RAIL = 80,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "CEIL5_1",

    post_mat  = "HW209"

  }

}


HACX.ROOM_THEMES =
{

  genemp_Interior =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      PANEL9 = 30,
      BRICK9 = 30,
      BSTONE1 = 30,
      BSTONE2 = 30,
      BSTONE3 = 30,
      COMPUTE1 = 30,
    },

    floors =
    {
      FLAT5_4 = 30,
      CEIL4_3 = 30,
      FLAT5_5 = 30,   
    },

    ceilings =
    {
      MFLR8_2 = 30,
      CEIL3_5 = 30,
      CEIL1_1 = 30,
    }
  },

  genemp_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR6_2 = 50,
    },

    naturals =
    {
      TLITE6_1 = 50,
      CEIL3_4 = 50,
    },

    porch_floors =
    {
      FLOOR6_2 = 50,
    },

  },

  genemp_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      GRAY_ROCK = 50
    },

    walls =
    {
      GRAY_ROCK = 50
    }
  }

}

function HACX.slump_setup()
  if ob_match_game({game = {hacx=1}}) then
    if OB_CONFIG.theme == "original" or OB_CONFIG.theme == "epi" then
      PARAM.slump_config = HACX.THEMES.DEFAULTS.slump_config
    elseif OB_CONFIG.theme == "jumble" or OB_CONFIG.theme == "bit_mixed" then
      local possible_configs = {}
      for _,tab in pairs(HACX.THEMES) do
        if tab.slump_config then
          table.insert(possible_configs, tab.slump_config)
        end
      end
      PARAM.slump_config = rand.pick(possible_configs)
    elseif HACX.THEMES[OB_CONFIG.theme].slump_config then
      PARAM.slump_config = HACX.THEMES[OB_CONFIG.theme].slump_config
    else
      PARAM.slump_config = HACX.THEMES.DEFAULTS.slump_config
    end
  end
end

------------------------------------------------------------------------

OB_THEMES["genemp"] =
{
  label = _("GenEmp Corp"),
  game = "hacx",
  name_class = "GENEMP",
  mixed_prob = 50
}

