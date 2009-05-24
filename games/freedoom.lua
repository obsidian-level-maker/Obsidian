----------------------------------------------------------------
-- GAME DEF : FreeDOOM 0.5
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

FREEDOOM_MONSTER_LIST =
{
  ---| fairly good |---

  zombie  = 2,
  shooter = 2,
  imp     = 2,
  demon   = 2,
  spectre = 2,
  caco    = 2,
  arach   = 2,

  revenant = 2,
  mancubus = 2,

  ---| crappy but playable |---

  skull   = 1,  -- missing death frames
  baron   = 1,  -- not yet coloured
  gunner  = 1,
  ss_dude = 1,

  ---| missing sprites |---
  
  knight = 0,
  pain   = 0,
  vile   = 0,
  cyber  = 0,
  spider = 0,
}

FREEDOOM_MISSING_SCENERY =
{
  hang_arm_pair = 1,
  hang_leg_pair = 1,
  hang_leg_gone = 1,
  hang_leg      = 1,
}

FREEDOOM_LIQUIDS =
{
  water = { floor="FWATER1", wall="WFALL1" },
}

FREEDOOM_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="black",  light=160 },
  { color="red",    light=192 },
}


----------------------------------------------------------------

function Freedoom_setup()

  GAME.sky_info = FREEDOOM_SKY_INFO

  -- FreeDOOM is lacking many monster sprites

  for name,quality in pairs(FREEDOOM_MONSTER_LIST) do
    if quality < 1 then
      GAME.monsters[name] = nil
    end
  end

  -- FreeDOOM is lacking some scenery sprites

  for name,_ in pairs(FREEDOOM_MISSING_SCENERY) do
    for _,R in ipairs(GAME.rooms) do
      if R.scenery then
        R.scenery[name] = nil
      end
    end

    for _,C in ipairs(GAME.combos) do
      if C.scenery == name then
        C.scenery = nil
      end
    end
  end
end


function Freedoom_get_levels()
  Doom2_get_levels()
end


UNFINISHED["freedoom"] =
{
  label = "FreeDoom 0.6",

  setup_func = Freedoom_setup,

  levels_start_func = Freedoom_get_levels,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,

    seed_size = 256,

    -- this is roughly how many characters can fit on the
    -- intermission screens (the CWILVxx patches).  It does
    -- not reflect any buffer limits in Doom ports.
    max_name_length = 28,

    skip_monsters = { 30,44 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    -- FIXME: common stuff

    -- FIXME: doom 2 stuff
    
    -- FIXME: doom 1 stuff
  },
}

