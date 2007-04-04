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
  player1 = { easy=19, medium=19, hard=19, dirs="player" },

  -- enemies
  dog     = { easy=138, medium=174, hard=210, dirs=true },

  guard   = { easy=108, medium=144, hard=180, dirs=true, patrol=4 },
  officer = { easy=116, medium=152, hard=188, dirs=true, patrol=4 },
  ss_dude = { easy=126, medium=162, hard=198, dirs=true, patrol=4 },
  mutant  = { easy=216, medium=234, hard=252, dirs=true, patrol=4 },

  -- bosses
  fake_hitler   = 160,
  fat_face      = 179,
  gretel_grosse = 197,
  hans_grosse   = 214,

  schabbs       = 196,
  giftmacher    = 215,
  hitler        = 178,

  -- ghosts
  blinky = 224, -- red
  clyde  = 225, -- yellow
  pinky  = 226, -- pink
  inky   = 227, -- blue

  -- pickups
  k_silver = 43,
  k_gold = 44,

  first_aid = 48,
  good_food = 47,
  dog_food  = 29,

  clip_8 = 49,
  machine_gun = 50,
  gatling_gun = 51,

  cross   = 52,
  chalice = 53,
  bible   = 54,
  crown   = 55,
  one_up  = 56,

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
  plant = 34,
  urn = 35,
  bare_table = 36,
  ceil_light = 37,
  kitchen_stuff = 38,

  suit_of_armor = 39,
  hanging_cage = 40,
  skeleton_in_cage = 41,
  skeleton_relax = 42,

  bed    = 45,  --???
  basket = 46,

  gibs_1 = 57,
  barrel = 58,
  water_well = 59,
  empty_well = 60,
  gibs_2 = 61,
  flag = 62,

  aardwolf = 63,
  junk_1 = 64,
  junk_2 = 65,
  junk_3 = 66,
  pots = 67,
  stove = 68,
  spears = 69,
  vines = 70,

  dud_clip = 71,

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

  --- Spear of Destiny ---

  spear_of_destiny = 74,

  clip_25 = 72,

  trans_grosse = 125,
  uber_mutant  = 142,
  wilhelm = 143,
  death_knight = 161,

  ghost = 106,
  angel = 107,

  skull_stick = 33,   -- REPLACES: sink
  skull_cage  = 45,   -- REPLACES: bed
  ceil_light2 = 63,   -- REPLACES: aardwolf

  cow_skull    = 67,  -- REPLACES: pots
  blood_well   = 68,  -- REPLACES: stove
  angel_statue = 69,  -- REPLACES: spears
  marble_column = 71, -- REPLACES: dud_clip
}

WF_TILE_NUMS =
{
  area_min = 108,
  area_max = 143,

  deaf_guard = 106,
  elevator_secret = 107,

  door = { 90, 91 },  -- E/W then N/S

  door_silver = { 92, 93 },
  door_gold   = { 94, 95 },

  door_elevator = { 100, 101 },
}

----------------------------------------------------------------

WF_COMBOS =
{
  WOOD =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
    decorate = 10, door_side = 23,

    theme_probs = { BUNKER=120, CELLS=25  },
  },

  GRAY_STONE =
  {
    mat_pri = 7,
    wall = 1, void = 1, floor=0, ceil=0,
    decorate = { 4,6 }, door_side = 28,

    theme_probs = { BUNKER=60, CAVE=30 },
  },

  GRAY_BRICK =
  {
    mat_pri = 7,
    wall = 35, void = 35, floor=0, ceil=0,
    decorate = { 37,43 }, door_side = 49,

    theme_probs = { CELLS=60, BUNKER=40 },
  },

  BLUE_STONE =
  {
    mat_pri = 6,
    wall = 8, void = 8, floor=0, ceil=0,
    decorate = { 5,7 }, door_side = 41,

    theme_probs = { CELLS=140 },
  },

  BLUE_BRICK =
  {
    mat_pri = 6,
    wall = 40, void = 40, floor=0, ceil=0,
    decorate = { 34,36 },

    theme_probs = { CELLS=80 },
  },

  RED_BRICK =
  {
    mat_pri = 5,
    wall = 17, void = 17, floor=0, ceil=0,
    decorate = { 18,38 }, door_side = 20,

    theme_probs = { BUNKER=80 },
  },
 
  PURPLE_STONE =
  {
    mat_pri = 1,
    wall = 19, void = 19, floor=0, ceil=0,
    decorate = 25,

    theme_probs = { CAVE=30 },
  },

  BROWN_CAVE =
  {
    mat_pri = 3,
    wall = 29, void = 29, floor=0, ceil=0,
    decorate = { 30,31,32 },

    theme_probs = { CAVE=90 },
  },
 
  BROWN_BRICK =
  {
    mat_pri = 5,
    wall = 42, void = 42, floor=0, ceil=0,
    door_side = 47,

    theme_probs = { CAVE=20 },
  },

  BROWN_STONE =
  {
    mat_pri = 5,
    wall = 44, void = 44, floor=0, ceil=0,

    theme_probs = { CAVE=50, CELLS=20 },
  },
}

WF_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


WF_KEY_BITS =
{
  k_silver = { kind_rep="door_silver", door_side=14 },
  k_gold   = { kind_rep="door_gold",   door_side=14 },
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

WF_SECRET_LEVELS =
{
  { leave="E1L1", enter="E1L10", kind="pacman" },
  { leave="E2L1", enter="E2L10", kind="pacman" },
  { leave="E3L7", enter="E3L10", kind="pacman" },
  { leave="E4L3", enter="E4L10", kind="pacman" },
  { leave="E5L5", enter="E5L10", kind="pacman" },
  { leave="E6L3", enter="E6L10", kind="pacman" },
}

WF_SCENERY =
{
  -- LIGHTS --

  floor_lamp = { r=24,h=48, light=true },
  ceil_light = { r=24,h=48, pass=true, ceil=true, light=true, add_mode="island" },
  chandelier = { r=24,h=48, pass=true, ceil=true, light=true, add_mode="island" },

  -- URBANE --
  
  puddle = { r=24,h= 4, pass=true },
  sink   = { r=24,h=48, add_mode="wall" },

  tree   = { r=24,h=48 },
  plant  = { r=24,h=48 },
  urn    = { r=24,h=48 },
  pots   = { r=24,h=48, add_mode="wall", pass=true },
  stove  = { r=24,h=48, add_mode="wall" },
  bed    = { r=24,h=48, add_mode="wall" },
  basket = { r=24,h=48 },

  bare_table    = { r=24,h=48, add_mode="island" },
  table_chairs  = { r=24,h=48, add_mode="island" },
  kitchen_stuff = { r=24,h=48 },

  -- CASTLEY --

  suit_of_armor = { r=24,h=48, add_mode="wall" },
  red_pillar    = { r=24,h=48, add_mode="island" },
  barrel        = { r=24,h=48 },
  green_barrel  = { r=24,h=48 },
  water_well    = { r=24,h=48 },
  empty_well    = { r=24,h=48 },

  flag   = { r=24,h=48 },
  junk_1 = { r=24,h=48, pass=true },
  junk_2 = { r=24,h=48, pass=true },
  junk_3 = { r=24,h=48, pass=true },
  vines  = { r=24,h=48, pass=true },
  spears = { r=24,h=48, add_mode="wall" },

  -- GORY --

  hanged_man       = { r=24,h=48, add_mode="island" },
  hanging_cage     = { r=24,h=48, add_mode="island" },
  skeleton_in_cage = { r=24,h=48, add_mode="island" },
  skeleton_flat    = { r=24,h= 8, pass=true },
  skeleton_relax   = { r=24,h= 8, pass=true },

  dead_guard = { r=24,h=8, pass=true },

  gibs_1 = { r=24,h=4, pass=true },
  gibs_2 = { r=24,h=4, pass=true },
}

WF_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, bible=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip_8=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}

WF_THEMES =
{
  -- Main Themes:
  --
  -- 1. BUNKER --> brick/wood, humans, quarters, plants/urns
  -- 2. CELLS  --> blue_stone, dogs, skeletons 
  -- 3. CAVE   --> cave/rock tex, vines, mutants

  BUNKER =
  {
    prob = 40,

    room_probs =
    {
      STORAGE = 50,
      TREASURE = 10, SUPPLIES = 15,
      QUARTERS = 50, BATHROOM = 15,
      KITCHEN = 30,  TORTURE = 20,
    },

    general_scenery =
    {
      suit_of_armor=50, flag=20,
    },
  },

  CELLS =
  {
    prob = 30,

    room_probs =
    {
      STORAGE = 40,
      TREASURE = 5,  SUPPLIES = 10,
      QUARTERS = 20, BATHROOM = 10,
      KITCHEN = 10,  TORTURE = 60,
    },

    general_scenery =
    {
      dead_guard=50, puddle=10,
    },

    monster_prefs =
    {
      dog=2.0, guard=2.0,
    },
  },

  CAVE =
  {
    prob = 20,

    room_probs =
    {
      STORAGE = 30,
      TREASURE = 15, SUPPLIES = 5,
      QUARTERS = 15, BATHROOM = 30,
      KITCHEN = 5,   TORTURE = 30,
    },

    general_scenery =
    {
      vines=90, spears=30,
    },

    monster_prefs =
    {
      mutant=6.0, officer=2.0,
    },
  },

--[[
  SECRET =
  {
    prob=0, -- special style, never chosen randomly

    room_probs =
    {
      STORAGE = 10,
      TREASURE = 90, SUPPLIES = 70,
      QUARTERS = 2,  BATHROOM = 2,
      KITCHEN = 20,  TORTURE = 2,
    },

    -- combo_probs : when missing, all have same prob
  },
--]]
}


----------------------------------------------------------------

WF_MONSTERS =
{
  dog     = { prob=20, hp=1,   dm=5,  fp=10, r=20,h=40, melee=true, },
  guard   = { prob=60, hp=25,  dm=10, fp=10, r=20,h=40, hitscan=true, cage_fallback=10 },
  officer = { prob=30, hp=50,  dm=20, fp=10, r=20,h=40, hitscan=true, },
  mutant  = { prob=10, hp=55,  dm=35, fp=10, r=20,h=40, hitscan=true, },
  ss_dude = { prob=50, hp=100, dm=30, fp=10, r=20,h=40, hitscan=true, },
}

WF_BOSSES =
{
  -- FIXME: hit-points are just averages of skill 2 and 3
 
  -- FIXME: dm values are crap!

  fat_face      = { hp=1000, dm=50, r=20,h=40, hitscan=true },
  hans_grosse   = { hp=1000, dm=30, r=20,h=40, hitscan=true },
  gretel_grosse = { hp=1000, dm=50, r=20,h=40, hitscan=true },
  giftmacher    = { hp=1000, dm=50, r=20,h=40 },

  fake_hitler   = { hp=350,  dm=50, r=20,h=40 },
  schabbs       = { hp=1250, dm=70, r=20,h=40 },

  -- this includes both Hitlers (in and out of the armor suit)
  hitler        = { hp=1100, dm=90, r=20,h=40, hitscan=true },
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

  -- Note: machine_gun actually gives _6_ bullets.
  -- However: we don't model the fact that the SS_DUDE only
  -- drops a 4-bullet clip if you already have the machine gun.
  -- Therefore: this hack should maintain ammo balance.
}

WF_PICKUPS =
{
  first_aid = { stat="health", give=25 },
  good_food = { stat="health", give=10 },
  dog_food  = { stat="health", give=4  },

  -- NOTE: no "gibs" here, they are fairly insignificant

  clip_8  =   { stat="bullet", give=8 },
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

    caps = { blocky_items=true, blocky_doors=true,
             tiered_skills=true, elevator_exits=true,
             four_dirs=true, sealed_start=true,
           },

    ERROR_TEX  = WF_NO_TILE,
    ERROR_FLAT = 99, -- dummy
    SKY_TEX    = 77, -- dummy

    thing_nums = WF_THING_NUMS,
    monsters   = WF_MONSTERS,
    bosses     = WF_BOSSES,
    mon_give   = WF_MONSTER_GIVE,
    weapons    = WF_WEAPONS,

    pickups = WF_PICKUPS,
    pickup_stats = { "health", "bullet" },

    initial_model = WF_INITIAL_MODEL,

    quests  = WF_QUESTS,
    secrets = WF_SECRET_LEVELS,

    dm = {},

    combos    = WF_COMBOS,
    exits     = WF_EXITS,
    hallways  = WF_THEMES, -- not used

    doors     = WF_DOORS,
    key_bits  = WF_KEY_BITS,

    scenery   = WF_SCENERY,
    rooms     = WF_ROOMS,
    themes    = WF_THEMES,
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
    elseif B.door_kind then
      tile = WF_TILE_NUMS[B.door_kind]
      if not tile then
        error("Unknown door_kind: " .. tostring(B.door_kind))
      end
      if type(tile) == "table" then
        tile = tile[sel(B.door_dir==4 or B.door_dir==6, 1, 2)]
        assert(tile)
      end
    else
      -- when we run out of floor codes (unlikely!) then reuse them
      local avail = WF_TILE_NUMS.area_max - WF_TILE_NUMS.area_min + 1
      local floor = B.floor_code or 0

      tile = WF_TILE_NUMS.area_min + (floor % avail)
    end

    if B.things and B.things[1] then
      local th   = B.things[1]
      local kind = th.kind

      if type(kind) == "table" then

        -- convert skill settings
        if not th.options or th.options.easy then
          obj = kind.easy
        elseif th.options.medium then
          obj = kind.medium
        else
          obj = kind.hard
        end
        assert(obj)

        -- convert angle
        --
        -- Note that the player is different from the enemies:
        --   PLAYER : 19=N, 20=E, 21=S, 22=W
        --   ENEMY  : +0=E, +1=N, +2=W, +3=S

        if kind.dirs and th.angle then
          if kind.dirs == "player" then
            local offset = int((360 - th.angle + 135) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          else
            local offset = int((th.angle + 45) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          end
        end

        -- FIXME sometimes patrol (put choice in monster.lua)
        -- Disabled due to problems (T_Path error)

--      if kind.patrol and rand_odds(10) then
--        obj = obj + kind.patrol
--      end
      else
        obj = kind
      end
    end

    if (tile <= 63) and (obj > 0) then
      con.printf("HOLO BLOCK @ (%d,%d) -- tile:%d obj:%d\n", x, y, tile,obj)
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

