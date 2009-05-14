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

  Doom2_setup()

  -- the FreeDOOM IWAD contains both Doom 1 and Doom 2 textures

---!!! Game_merge_tab(GAME.combos,   DOOM1_COMBOS)
---!!! Game_merge_tab(GAME.exits,    DOOM1_EXITS)
---!!! Game_merge_tab(GAME.hallways, DOOM1_HALLWAYS)
---!!!
---!!! Game_merge_tab(GAME.rails,   DOOM1_RAILS)
---!!!
---!!! Game_merge_tab(GAME.hangs,   DOOM1_OVERHANGS)
---!!! Game_merge_tab(GAME.mats,    DOOM1_MATS)
---!!! Game_merge_tab(GAME.crates,  DOOM1_CRATES)
---!!!
---!!! Game_merge_tab(GAME.liquids, DOOM1_LIQUIDS, FREEDOOM_LIQUIDS)

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


UNFINISHED["freedoom"] =
{
  label = "FreeDoom 0.6",

  format = "doom",

  setup_func = Freedoom_setup,

  param =
  {
    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,

    seed_size = 256,

    palette_mons = 4,
  },

  hooks =
  {
    get_levels = Doom2_get_levels,
  },
}

