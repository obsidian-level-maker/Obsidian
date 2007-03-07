----------------------------------------------------------------
-- THEMES : Wolfenstein 3D
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

WF_THING_NUMS =
{
  -- players
  player1 = { easy=19, medium=19, hard=19, dirs=true },

  -- enemies
  guard   = { easy=108, medium=144, hard=180, dirs=true, patrol=4 },
  officer = { easy=116, medium=152, hard=188, dirs=true, patrol=4 },
  ss_dude = { easy=126, medium=162, hard=198, dirs=true, patrol=4 },
  dog     = { easy=134, medium=170, hard=206, dirs=true, patrol=4 },

  -- bosses
  fake_hitler = 160,
  hitler = 178,
  fat_face = 179,
  schabbs = 196,
  gretel_grosse = 197,
  hans_grosse = 214,
  giftmacher = 215,

  -- ghosts
  blinky = 224, -- red
  clyde  = 225, -- yellow
  pinky  = 226, -- pink
  inky   = 227, -- blue

  -- pickups
  key_1 = 43,
  key_2 = 44,
  stuff_1 = 45,
  stuff_2 = 46,

  first_aid = 48,
  good_food = 47,
  bad_food = 29,

  clip_4 = 71,
  clip_8 = 49,
  machine_gun = 50,
  gatling_gun = 51,

  cross = 52,
  chalice = 53,
  bible = 54,
  crown = 55,
  one_up = 56,

  -- scenery
  puddle = 23,
  green_barrel = 24,
  table_chairs = 25,
  floor_lamp = 26,
  chandelier = 27,
  hanged_man = 28,
  red_pillar = 30,

  tree = 31,
  skeleton_flat = 32,
  sink = 33,
  potted_plant = 34,
  urn = 35,
  bare_table = 36,
  ceiling_light = 37,
  kitchen_stuff = 38,

  suit_of_armor = 39,
  hanging_cage = 40,
  skeleton_in_cage = 41,
  skeleton_relax = 42,

  gibs_1 = 57,
  barrel = 58,
  well = 59,
  empty_well = 60,
  gibs_2 = 61,
  flag = 62,

  call_apogee = 63,
  junk_1 = 64,
  junk_2 = 65,
  junk_3 = 66,
  pots = 67,
  stove = 68,
  spears = 69,
  vines = 70,

  dead_guard = 124,

  -- special
  secret  = 98,
  trigger = 99,

  turn_E  = 90,
  turn_NE = 91,
  turn_N  = 92,
  turn_NW = 93,
  turn_W  = 94,
  turn_SW = 95,
  turn_S  = 96,
  turn_SE = 97,
}

WF_TILE_NUMS =
{
  area_min = 108,
  area_max = 143,

  deaf_guard = 106,
  elevator_secret = 107,

  door = { 90, 91 },

  door_silver = { 92, 93 },
  door_gold   = { 94, 95 },

  door_elevator = { 100, 101 },
}

----------------------------------------------------------------

WF_THEMES =
{
  WOOD =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
  },

  GRAY_STONE =
  {
    mat_pri = 7,
    wall = 1, void = 1, floor=0, ceil=0,
  },

  GRAY_BRICK =
  {
    mat_pri = 7,
    wall = 35, void = 35, floor=0, ceil=0,
  },

  BLUE_STONE =
  {
    mat_pri = 6,
    wall = 8, void = 8, floor=0, ceil=0,
  },

  BLUE_BRICK =
  {
    mat_pri = 6,
    wall = 40, void = 40, floor=0, ceil=0,
  },

  RED_BRICK =
  {
    mat_pri = 5,
    wall = 17, void = 17, floor=0, ceil=0,
  },
  
  PURPLE_STONE =
  {
    mat_pri = 1,
    wall = 19, void = 19, floor=0, ceil=0,
  },
  
  BROWN_CAVE =
  {
    mat_pri = 3,
    wall = 29, void = 29, floor=0, ceil=0,
  },
  
  BROWN_BRICK =
  {
    mat_pri = 5,
    wall = 42, void = 42, floor=0, ceil=0,
  },

  BROWN_STONE =
  {
    mat_pri = 5,
    wall = 44, void = 44, floor=0, ceil=0,
  },
}
 
WF_EXITS =
{
  ELEVATOR =
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


WF_KEY_BITS =
{
  k_silver = { },
  k_gold   = { },
}

---- QUEST STUFF ----------------

WF_QUESTS =
{
  key = { k_silver=60, k_gold=30, },

  switch = { },

  weapon = { machine_gun=50, gatling_gun=20, },

  item =
  {
    crown = 50, bible = 50, cross = 50, chalice = 50,
    one_up = 2,
  },

  exit =
  {
    elevator=50
  }
}

WF_DEATHMATCH =
{
  weapons = { machine_gun=50, gatling_gun=20, },
  health = { first_aid=70, good_food=25, bad_food=5 },
  ammo = { clip_8=70, clip_4=20 },
  items = { cross=50 },
  cluster = {}
}


----------------------------------------------------------------

WF_MONSTERS =
{
  dog     = { prob=50, hp=1,   dm=5,  fp=10, r=20,h=40, melee=true, },
  guard   = { prob=80, hp=25,  dm=10, fp=10, r=20,h=40, hitscan=true, cage_fallback=10 },
  officer = { prob=20, hp=50,  dm=20, fp=10, r=20,h=40, hitscan=true, },
  ss_dude = { prob=10, hp=100, dm=30, fp=10, r=20,h=40, hitscan=true, },
}

WF_MONSTER_GIVE =
{
  guard   = { { ammo="bullet", give=4 } },
  officer = { { ammo="bullet", give=4 } },
  mutant  = { { ammo="bullet", give=4 } },

  ss_dude = { { weapon="machine_gun" } },
}

WF_WEAPONS =
{
  knife       = { melee=true,           rate=3.0, dm= 7, freq= 2, held=true },
  pistol      = { ammo="bullet", per=1, rate=3.0, dm=17, freq=10, held=true },

  machine_gun = { ammo="bullet", give=4, per=1, rate=8.0,  dm=17, freq=30, },
  gatling_gun = { ammo="bullet", give=6, per=1, rate=16.0, dm=17, freq=90, },

  -- Note: machine_gun should give _6_ bullets.
  -- However, we don't model the fact that the SS_DUDE only
  -- drops a 4-bullet clip when you already have the machine
  -- gun.  The hack here should maintain ammo balance.
}

WF_PICKUPS =
{
  first_aid = { stat="health", give=25 },
  good_food = { stat="health", give=10 },
  bad_food  = { stat="health", give=4  },

  -- NOTE: no "gibs" here, they are fairly insignificant

  clip_8  =   { stat="bullet", give=8 },
  clip_4  =   { stat="bullet", give=4 },
}

WF_INITIAL_MODEL =
{
  health=100, armor=0, bullet=8,
  knife=true, pistol=true
}


----------------------------------------------------------------

-- constants
WF_NO_TILE = 48
WF_NO_OBJ  = 0


THEME_FACTORIES["wolf3d"] = function()

  return
  {
    plan_size = 7,
    cell_size = 7,
    cell_min_size = 3,

    caps = { narrow_doors=true, },

    ERROR_TEX  = WF_NO_TILE,
    ERROR_FLAT = 99, -- dummy
    SKY_TEX    = 77, -- dummy

    thing_nums = WF_THING_NUMS,
    monsters   = WF_MONSTERS,
    mon_give   = WF_MONSTER_GIVE,
    weapons    = WF_WEAPONS,

    pickups = WF_PICKUPS,
    pickup_stats = { "health", "bullet" },

    initial_model = WF_INITIAL_MODEL,

    quests = WF_QUESTS,
    dm = WF_DEATHMATCH,

    themes    = WF_THEMES,
    exits     = WF_EXITS,
    hallways  = WF_THEMES, -- ???

    doors     = WF_DOORS,
    key_bits  = WF_KEY_BITS,
  }
end


----------------------------------------------------------------
--  CUSTOM WRITER for WOLF MAPS
----------------------------------------------------------------

function write_wolf_level(p)

  local function handle_block(x, y)
    if not valid_block(p, x, y) then return end
    local B = p.blocks[x][y]
    if not B then return end

    local tile = WF_NO_TILE
    local obj  = WF_NO_OBJ

    if B.solid then
      assert(type(B.solid) == "number")
      tile = B.solid
    else
      tile = WF_TILE_NUMS.area_min -- FIXME: + quest number
    end

    if B.things and B.things[1] then
      local info = B.things[1]
      if type(info.kind) == "table" then
        obj = info.kind["easy"]  -- FIXME
      else
        obj = info.kind
      end
    end

    wolf.add_block(x, y, tile, obj)
  end

  con.progress(66); if con.abort() then return end

  wolf.begin_level(lev_name);

  for y = 1,64 do for x = 1,64 do
    handle_block(x, y)
  end end

  wolf.end_level()

  con.progress(100)
end

