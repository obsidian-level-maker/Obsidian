----------------------------------------------------------------
-- GAME DEF : Heretic
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

HC_THINGS =
{
  --- special stuff ---
  player1 = { id=1, kind="other", r=16,h=xx },
  player2 = { id=2, kind="other", r=16,h=xx },
  player3 = { id=3, kind="other", r=16,h=xx },
  player4 = { id=4, kind="other", r=16,h=xx },

  dm_player     = { id=11, kind="other", r=16,h=xx },
  teleport_spot = { id=14, kind="other", r=16,h=xx },

  --- monsters ---
  gargoyle    = { id=66, kind="monster", r=xx,h=xx },
  fire_garg   = { id=5,  kind="monster", r=xx,h=xx },
  golem       = { id=68, kind="monster", r=xx,h=xx },
  golem_inv   = { id=69, kind="monster", r=xx,h=xx },
  nitro       = { id=45, kind="monster", r=xx,h=xx },
  nitro_inv   = { id=46, kind="monster", r=xx,h=xx },
  warrior     = { id=64, kind="monster", r=xx,h=xx },
  warrior_inv = { id=65, kind="monster", r=xx,h=xx },

  disciple   = { id=15, kind="monster", r=xx,h=xx },
  sabreclaw  = { id=90, kind="monster", r=xx,h=xx },
  weredragon = { id=70, kind="monster", r=xx,h=xx },
  ophidian   = { id=92, kind="monster", r=xx,h=xx },
  ironlich   = { id=6,  kind="monster", r=xx,h=xx },
  maulotaur  = { id=9,  kind="monster", r=xx,h=xx },
  d_sparil   = { id=7,  kind="monster", r=xx,h=xx },

  --- pickups ---
  k_yellow   = { id=80, kind="pickup", r=xx,h=xx },
  k_green    = { id=73, kind="pickup", r=xx,h=xx },
  k_blue     = { id=79, kind="pickup", r=xx,h=xx },

  gauntlets  = { id=2005, kind="pickup", r=xx,h=xx },
  crossbow   = { id=2001, kind="pickup", r=xx,h=xx },
  claw       = { id=53,   kind="pickup", r=xx,h=xx },
  hellstaff  = { id=2004, kind="pickup", r=xx,h=xx },
  phoenix    = { id=2003, kind="pickup", r=xx,h=xx },
  firemace   = { id=2002, kind="pickup", r=xx,h=xx },

  crystal    = { id=10, kind="pickup", r=xx,h=xx },
  geode      = { id=12, kind="pickup", r=xx,h=xx },
  arrows     = { id=18, kind="pickup", r=xx,h=xx },
  quiver     = { id=19, kind="pickup", r=xx,h=xx },
  claw_orb1  = { id=54, kind="pickup", r=xx,h=xx },
  claw_orb2  = { id=55, kind="pickup", r=xx,h=xx },
  runes1     = { id=20, kind="pickup", r=xx,h=xx },
  runes2     = { id=21, kind="pickup", r=xx,h=xx },
  flame_orb1 = { id=22, kind="pickup", r=xx,h=xx },
  flame_orb2 = { id=23, kind="pickup", r=xx,h=xx },
  mace_orbs  = { id=13, kind="pickup", r=xx,h=xx },
  mace_pile  = { id=16, kind="pickup", r=xx,h=xx },

  h_vial  = { id=81, kind="pickup", r=xx,h=xx },
  h_flask = { id=82, kind="pickup", r=xx,h=xx },
  h_urn   = { id=32, kind="pickup", r=xx,h=xx },
  shield1 = { id=85, kind="pickup", r=xx,h=xx },
  shield2 = { id=31, kind="pickup", r=xx,h=xx },

  bag     = { id=8,  kind="pickup", r=xx,h=xx },
  wings   = { id=23, kind="pickup", r=xx,h=xx },
  ovum    = { id=30, kind="pickup", r=xx,h=xx },
  torch   = { id=33, kind="pickup", r=xx,h=xx },
  bomb    = { id=34, kind="pickup", r=xx,h=xx },
  map     = { id=35, kind="pickup", r=xx,h=xx },
  chaos   = { id=36, kind="pickup", r=xx,h=xx },
  shadow  = { id=75, kind="pickup", r=xx,h=xx },
  ring    = { id=84, kind="pickup", r=xx,h=xx },
  tome    = { id=86, kind="pickup", r=xx,h=xx },

  --- scenery ---
  wall_torch    = { id=50, kind="scenery", r=xx,h=xx, light=255, add_mode="extend" },
  serpent_torch = { id=27, kind="scenery", r=xx,h=xx, light=255 },
  fire_brazier  = { id=76, kind="scenery", r=xx,h=xx, light=255 },
  chandelier    = { id=28, kind="scenery", r=xx,h=xx, light=255, pass=true, ceil=true, add_mode="island" },

  barrel  = { id=44,   kind="scenery", r=xx,h=xx },
  pod     = { id=2035, kind="scenery", r=xx,h=xx },
  glitter = { id=74,   kind="scenery", r=xx,h=xx },

  blue_statue   = { id=94, kind="scenery", r=xx,h=xx },
  green_statue  = { id=95, kind="scenery", r=xx,h=xx },
  yellow_statue = { id=96, kind="scenery", r=xx,h=xx },

  moss1   = { id=48, kind="scenery", r=xx,h=xx },
  moss2   = { id=49, kind="scenery", r=xx,h=xx },
  volcano = { id=87, kind="scenery", r=xx,h=xx },
  
  small_pillar = { id=29, kind="scenery", r=xx,h=xx },
  brown_pillar = { id=47, kind="scenery", r=xx,h=xx },
  stal_small_F = { id=37, kind="scenery", r=xx,h=xx },
  stal_small_C = { id=39, kind="scenery", r=xx,h=xx },
  stal_big_F   = { id=38, kind="scenery", r=xx,h=xx },
  stal_big_C   = { id=40, kind="scenery", r=xx,h=xx },

  hang_corpse  = { id=51, kind="scenery", r=xx,h=xx },
  hang_skull_1 = { id=17, kind="scenery", r=xx,h=xx },
  hang_skull_2 = { id=24, kind="scenery", r=xx,h=xx },
  hang_skull_3 = { id=25, kind="scenery", r=xx,h=xx },
  hang_skull_4 = { id=26, kind="scenery", r=xx,h=xx },

  --- ambient sounds ---
  amb_scream = { id=1200, kind="other", r=xx,h=xx },
  amb_squish = { id=1201, kind="other", r=xx,h=xx },
  amb_drip   = { id=1202, kind="other", r=xx,h=xx },
  amb_feet   = { id=1203, kind="other", r=xx,h=xx },
  amb_heart  = { id=1204, kind="other", r=xx,h=xx },
  amb_bells  = { id=1205, kind="other", r=xx,h=xx },
  amb_growl  = { id=1206, kind="other", r=xx,h=xx },
  amb_magic  = { id=1207, kind="other", r=xx,h=xx },
  amb_laugh  = { id=1208, kind="other", r=xx,h=xx },
  amb_run    = { id=1209, kind="other", r=xx,h=xx },

  env_water  = { id=41, kind="other", r=xx,h=xx },
  env_wind   = { id=42, kind="other", r=xx,h=xx },
}

HC_LINE_TYPES =  -- NOTE: only includes differences to DOOM
{
  A1_scroll_right = { kind=99 },
  W1_secret_exit  = { kind=105 }, -- FIXME: correct?

  P1_green_door = { kind=33 },
  PR_green_door = { kind=28 },
}

HC_SECTOR_TYPES =
{
  secret   = { kind=9 },
  friction = { kind=15 },

  random_off = { kind=1 },
  blink_fast = { kind=2 },
  blink_slow = { kind=3 },
  glow       = { kind=8 },

  damage_5  = { kind=7 },
  damage_10 = { kind=5 },
  damage_20 = { kind=16 },
}


----------------------------------------------------------------

HC_COMBOS =
{
  ---- INDOOR ------------

  GOLD =
  {
    mat_pri = 6,

    wall = "SANDSQ2",
    void = "SNDBLCKS",
    pillar = "SNDCHNKS",

    floor = "FLOOR06",
    ceil = "FLOOR11",

    scenery = "wall_torch",

    theme_probs = { CITY=20 },
  },

  BLOCK =
  {
    mat_pri = 7,

    wall = "GRSTNPB",
    void = "GRSTNPBW",
    pillar = "WOODWL",

    floor = "FLOOR03",
    ceil = "FLOOR03",

    scenery = "barrel",

    theme_probs = { CITY=20 },
  },

  MOSSY =
  {
    mat_pri = 2,

    wall = "MOSSRCK1",
    void = "MOSSRCK1",
    pillar = "SKULLSB1", -- SPINE1
    
    floor = "FLOOR00",
    ceil  = "FLOOR04",

    scenery = "chandelier",

    theme_probs = { CITY=20 },
  },

  WOOD =
  {
    mat_pri = 2,

    wall = "WOODWL",
    void = "CTYSTUC3",

    floor = "FLOOR10",
    ceil  = "FLOOR12",

    scenery = "hang_skull_1",

    theme_probs = { CITY=20 },
  },

  HUT =
  {
    mat_pri = 1,
    
    wall = "CTYSTUC3",
    void = "CTYSTUC4",
    
    floor = "FLOOR10",
    ceil  = "FLOOR11",

    scenery = "barrel",

    theme_probs = { CITY=20 },
  },


  ---- OUTDOOR ------------

  STONY =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "GRSTNPB",
    void = "GRSTNPBV",

    floor = "FLOOR00",
    ceil =  "FLOOR00",

    scenery = "serpent_torch",
  },

  MUDDY =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "CSTLRCK",
    void = "SQPEB1",
    pillar = "SPINE1",

    floor = "FLOOR17",
    ceil  = "FLOOR17",

    scenery = "fire_brazier",

    theme_probs = { CITY=20 },
  },
  
  WATERY =
  {
    outdoor = true,
    mat_pri = 1,

    wall = "SNDBLCKS",
    void = "CTYSTCI4",

    floor = "FLTWAWA1",
    ceil  = "FLOOR27",

    theme_probs = { CITY=20 },
  },

  SANDY =
  {
    outdoor = true,
    mat_pri = 2,
    
    wall = "CTYSTUC2",
    void = "CTYSTUC3",
    pillar = "SPINE2",

    floor = "FLOOR27",
    ceil  = "FLOOR27",

    scenery = "small_pillar",

    theme_probs = { CITY=20 },
  },
  
}

HC_EXITS =
{
  METAL =
  {
    mat_pri = 9,

    wall = "METL2",
    void = "SKULLSB1",

    floor = "FLOOR03",
    ceil  = "FLOOR19",

---##    switch = { switch="SW2OFF", wall="METL2", h=64 },

    switch =
    {
      prefab="SWITCH_PILLAR",
      skin =
      {
        switch_w="SW2OFF", side_w="METL2",
        kind=11, tag=0,
      }
    },

---##    door = { wall="DOOREXIT", w=64, h=96 },
  },
}

HC_HALLWAYS =
{
  -- FIXME !!! hallway themes
}


---- BASE MATERIALS ------------

HC_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "METL2",
    void  = "METL1",
    floor = "FLOOR28",
    ceil  = "FLOOR28",
  },

  STEP =
  {
    wall  = "SNDPLAIN",
    floor = "FLOOR27",
  },

  LIFT =
  {
    wall = "DOORSTON",
    floor = "FLOOR08"
  },

  TRACK =
  {
    wall  = "METL2",
    floor = "FLOOR28",
  },

  DOOR_FRAME =
  {
    wall  = nil,  -- this means: use plain wall
    floor = "FLOOR04",
    ceil  = "FLOOR04",
  },
}

--- PEDESTALS --------------

HC_PEDESTALS =
{
  PLAYER =
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  },

  QUEST = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  },

  WEAPON = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",  ceil = "FLOOR11",
    h = 8,
  },
}

---- OVERHANGS ------------

HC_OVERHANGS =
{
  WOOD =
  {
    ceil = "FLOOR10",
    upper = "CTYSTUC3",
    thin = "WOODWL",
  },
}

---- MISC STUFF ------------

HC_LIQUIDS =
{
  water = { floor="FLTFLWW1" },
  -- FIXME
}

HC_SWITCHES =
{
---##  sw_rock = { wall="RCKSNMUD", switch="SW1OFF" },

  sw_rock =
  {
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1OFF", wall="RCKSNMUD", kind=103,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="DMNMSK", door_c="FLOOR10",
        key_w="RCKSNMUD",
        door_h=128,

---     step_w="STEP1",  track_w="DOORTRAK",
---     frame_f="FLAT1", frame_c="FLAT1",
      }
    },
  },
}

HC_DOORS =
{
  d_demon = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DMNMSK", door_c="FLOOR10",
                 track_w="METL2",
                 door_h=128,

---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             },
  
  d_wood   = { wall="DOORWOOD", w=64,  h=128, ceil="FLOOR10" },
  
--  d_stone  = { wall="DOORSTON", w=64,  h=128 },
}

HC_KEY_DOORS =
{
  k_blue   =
  {
    w=128, h=128, kind_rep=26, kind_once=32,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR04",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
    },

    thing="blue_statue",
  },

  k_green  =
  {
    w=128, h=128, kind_rep=28, kind_once=33,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR04",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
    },

    thing="green_statue",
  },

  k_yellow =
  {
    w=128, h=128, kind_rep=27, kind_once=34,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR04",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
    },

    thing="yellow_statue",
  },
}

HC_DOOR_PREFABS =
{
  demon =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DMNMSK", door_c="FLOOR10",
      track_w="METL2",
      door_h=128,
    },

    theme_probs = { CITY=20 },
  },
}

HC_MISC_PREFABS =
{
  exit_DOOR =
  {
    w=64, h=96, prefab = "DOOR_NARROW",

    skin =
    {
      door_w="DOOREXIT",
      door_h=96
    },
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin = { door_h=128 }
  },
}

HC_RAILS =
{
  r_1 = { wall="WDGAT64", w=128, h=64  },
  r_2 = { wall="WDGAT64", w=128, h=128 },  -- FIXME!!
}

HC_IMAGES =
{
  { wall = "GRSKULL2", w=128, h=128, glow=true },
  { wall = "GRSKULL1", w=64,  h=64,  floor="FLOOR27" }
}

HC_LIGHTS =
{
  round = { floor="FLOOR26",  side="ORNGRAY" },
}

HC_WALL_LIGHTS =
{
  redwall = { wall="REDWALL", w=32 },
}

HC_PICS =
{
  skull3 = { wall="GRSKULL3", w=128, h=128 },
  glass1 = { wall="STNGLS1",  w=128, h=128 },
}

---- QUEST STUFF ----------------

HC_QUESTS =
{
  key =
  {
    k_blue=20, k_green=40, k_yellow=60
  },

  switch =
  {
    sw_rock=50,
--  sw_stone=50,
--  sw_brick=50,
  },

  weapon =
  {
    -- gauntlets=10, -- crossbow=60,

    claw=30, hellstaff=30,
    phoenix=30, firemace=20
  },

  item =
  {
    wings=50,  ovum=50,
    bomb=30,  chaos=30,
    shadow=50, tome=20,
  },

---##  exit = { exit=50 },
---##
---##  secret_exit = { secret_exit=50 },
}

HC_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 20, 65 },
  },
 
  SCENIC =
  {
  },

  -- TODO: check in-game level names for ideas
}

HC_THEMES =
{
  CITY =
  {
    room_probs=
    {
      PLAIN=50,
    },
  },
}

HC_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8  9  10  -------

  key    = {  0, 25, 50, 90, 65, 30, 10, 2 },
  exit   = {  0, 25, 50, 90, 65, 30, 10, 2 },

  switch = {  0, 50, 90, 50, 25, 5, 1 },

  weapon = { 25, 90, 50, 10, 2 },
  item   = { 15, 70, 70, 15, 2 },
}


------------------------------------------------------------

HC_MONSTERS =
{
  -- FIXME: dm and fp values are CRAP!
  gargoyle    = { prob=30, r=16,h=36, hp=20,  dm= 7, fp=10, cage_fallback=10, float=true, melee=true },
  fire_garg   = { prob=20, r=16,h=36, hp=80,  dm=21, fp=30, float=true },
  golem       = { prob=90, r=22,h=64, hp=80,  dm= 7, fp=10, melee=true },
  golem_inv   = { prob=20, r=22,h=64, hp=80,  dm= 7, fp=10, melee=true },

  nitro       = { prob=70, r=22,h=64, hp=100, dm=21, fp=30, },
  nitro_inv   = { prob=10, r=22,h=64, hp=100, dm=21, fp=30, },
  warrior     = { prob=70, r=24,h=80, hp=200, dm=15, fp=50, },
  warrior_inv = { prob=20, r=24,h=80, hp=200, dm=15, fp=50, },

  disciple    = { prob=25, r=16,h=72, hp=180, dm=30, fp=90, float=true },
  sabreclaw   = { prob=25, r=20,h=64, hp=150, dm=30, fp=90, melee=true },
  weredragon  = { prob=20, r=34,h=80, hp=220, dm=50, fp=90, },
  ophidian    = { prob=20, r=22,h=72, hp=280, dm=50, fp=90, },
}

HC_BOSSES =
{
  ironlich    = { prob= 4, r=40,h=72, hp=700, dm=99, fp=200, float=true },
  maulotaur   = { prob= 1, r=28,h=104,hp=3000,dm=99, fp=200, },
  d_sparil    = { prob= 1, r=28,h=104,hp=2000,dm=99, fp=200, },
}

HC_WEAPONS =
{
  -- FIXME: all these stats are CRAP!
  staff      = { melee=true, rate=3.0, dm=10, freq= 2, held=true },
  gauntlets  = { melee=true, rate=6.0, dm=50, freq= 8 },

  wand       = { ammo="crystal",           per=1, rate=1.1, dm=10, freq=15, held=true },
  crossbow   = { ammo="arrow",     give=4, per=1, rate=1.1, dm=30, freq=90 },
  claw       = { ammo="claw_orb",  give=4, per=1, rate=1.1, dm=50, freq=50 },
  hellstaff  = { ammo="runes",     give=4, per=1, rate=1.1, dm=60, freq=50 },
  phoenix    = { ammo="flame_orb", give=4, per=1, rate=1.1, dm=70, freq=50 },
  firemace   = { ammo="mace_orb",  give=4, per=1, rate=1.1, dm=90, freq=25 },
}

HC_PICKUPS =
{
  -- FIXME: the ammo 'give' numbers are CRAP!
  crystal = { stat="crystal", give=5,  },
  geode   = { stat="crystal", give=20, },
  arrows  = { stat="arrow",   give=5,  },
  quiver  = { stat="arrow",   give=20, },

  claw_orb1 = { stat="claw_orb", give=5,  },
  claw_orb2 = { stat="claw_orb", give=20, },
  runes1    = { stat="runes",    give=5,  },
  runes2    = { stat="runes",    give=20, },

  flame_orb1 = { stat="flame_orb", give=5,  },
  flame_orb2 = { stat="flame_orb", give=20, },
  mace_orbs  = { stat="mace_orb",  give=5,  },
  mace_pile  = { stat="mace_orb",  give=20, },

  h_vial  = { stat="health", give=10,  prob=70 },
  h_flask = { stat="health", give=25,  prob=25 },
  h_urn   = { stat="health", give=100, prob=5, clu_max=1 },

  shield1 = { stat="armor", give=100, prob=70 },
  shield2 = { stat="armor", give=200, prob=10 },
}

HC_NICENESS =
{
  w1 = { weapon="crossbow",  quest=1, prob=70, always=true  },

  w3 = { weapon="gauntlets", quest=1, prob=50, always=false },
  w4 = { weapon="gauntlets", quest=3, prob=50, always=false },

  p1 = { pickup="shield1", prob=2.0 },
  p2 = { pickup="shield2", prob=0.7 },

---!!!!!!  p3 = { pickup="torch", prob=2.0 },
---!!!!!!  p4 = { pickup="bag",   prob=2.0 },
}

HC_DEATHMATCH =
{
  weapons =
  {
    gauntlets=10, crossbow=60,
    claw=30, hellstaff=30, phoenix=30
  },

  health =
  { 
    h_vial=70, h_flask=25, h_urn=5
  },

  ammo =
  { 
    crystal=10, geode=20,
    arrows=20, quiver=60,
    claw_orb1=10, claw_orb2=40,
    runes1=10, runes2=30,
    flame_orb1=10, flame_orb2=30,
  },

  items =
  {
    shield1=70, shield2=10,
    bag=10, torch=10,
    wings=50, ovum=50,
    bomb=30, chaos=30,
    shadow=50, tome=30,
  },

  cluster = {}
}

HC_INITIAL_MODEL =
{
  health=100, armor=0,
  crystal=30, arrow=0, runes=0,
  claw_orb=0, flame_orb=0, mace_orb=0,
  staff=true, wand=true,
}


------------------------------------------------------------

HC_EPISODE_THEMES =
{
  { CITY=5 },
  { CITY=5 },
  { CITY=5 },

  { CITY=5 },
  { CITY=5 },
}

HC_SECRET_EXITS =
{
  E1M6 = true,
  E2M4 = true,
  E3M4 = true,

  E4M4 = true,
  E5M3 = true,
}

HC_EPISODE_BOSSES =
{
  "ironlich",
  "maulotaur",
  "d_sparil",

  "ironlich",
  "maulotaur",
}

HC_SKY_INFO =
{
  { color="gray",  light=176 },
  { color="red",   light=192 },
  { color="blue",  light=176 },

  { color="gray",  light=176 },
  { color="blue",  light=176 },
}

function heretic_get_levels(episode)

  local level_list = {}

  local theme_probs = HC_EPISODE_THEMES[episode]
  if SETTINGS.length ~= "full" then
    theme_probs = HC_EPISODE_THEMES[rand_irange(1,5)]
  end

  for map = 1,9 do
    local Level =
    {
      name = string.format("E%dM%d", episode, map),

      episode   = episode,
      ep_along  = map,
      ep_length = 9,

      theme_probs = theme_probs,
      sky_info = HC_SKY_INFO[episode],

      boss_kind   = (map == 8) and HC_EPISODE_BOSSES[episode],
      secret_kind = (map == 9) and "plain",
    }

    if HC_SECRET_EXITS[Level.name] then
      Level.secret_exit = true
    end

    std_decide_quests(Level, HC_QUESTS, HC_QUEST_LEN_PROBS)

    table.insert(level_list, Level)
  end

  return level_list
end

------------------------------------------------------------

GAME_FACTORIES["heretic"] = function()

  return
  {
    doom_format = true,

    plan_size = 10,
    cell_size = 9,
    cell_min_size = 6,

    caps = { heights=true, sky=true, 
             fragments=true, move_frag=true, rails=true,
             closets=true,   depots=true,
             switches=true,  liquids=true,
             teleporters=true,
             prefer_stairs=true,
           },

    SKY_TEX    = "F_SKY1",
    ERROR_TEX  = "DRIPWALL",
    ERROR_FLAT = "FLOOR09",

    episodes   = 5,
    level_func = heretic_get_levels,

    things     = HC_THINGS,
    monsters   = HC_MONSTERS,
    bosses     = HC_BOSSES,
    weapons    = HC_WEAPONS,

    pickups = HC_PICKUPS,
    pickup_stats = { "health", "crystal", "arrow", "claw_orb",
                       "runes", "flame_orb", "mace_orb" },
    niceness = HC_NICENESS,

    initial_model = HC_INITIAL_MODEL,

    quests  = HC_QUESTS,

    dm = HC_DEATHMATCH,

    combos    = HC_COMBOS,
    exits     = HC_EXITS,
    hallways  = HC_HALLWAYS,

    rooms     = HC_ROOMS,
    themes    = HC_THEMES,

    hangs     = HC_OVERHANGS,
    pedestals = HC_PEDESTALS,
    mats      = HC_MATS,
    rails     = HC_RAILS,

    liquids   = HC_LIQUIDS,
    switches  = HC_SWITCHES,
    doors     = HC_DOORS,
    key_doors = HC_KEY_DOORS,

    pics      = HC_PICS,
    images    = HC_IMAGES,
    lights    = HC_LIGHTS,
    wall_lights = HC_WALL_LIGHTS,

    door_fabs   = HC_DOOR_PREFABS,
    misc_fabs   = HC_MISC_PREFABS,

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },
    
    diff_probs = { [0]=20, [16]=40, [32]=80, [64]=30, [96]=5 },
    bump_probs = { [0]=30, [16]=30, [32]=20, [64]=5 },
    
    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=80, combo_diff=50, normal=30 },
  }
end

