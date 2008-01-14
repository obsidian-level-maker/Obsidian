----------------------------------------------------------------
-- GAME DEF : FreeDOOM 0.5
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

FD_MONSTER_LIST =
{
  ---| fairly good |---

  "zombie", "shooter", "imp",
  "demon",  "spectre", "caco", 
  "arach", "revenant", "mancubus",

  ---| crappy but playable |---

  "skull",  -- missing death frames
  "baron",  -- not yet coloured
  "gunner",
  "ss_dude", 
  "vile",

  ---| missing sprites |---
  
  -- "knight",  
  -- "pain",    

  -- "cyber",   
  -- "spider",  
}

FD_LIQUIDS =
{
  water = { floor="FWATER1", wall="WFALL1" },
}

FD_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="black",  light=160 },
  { color="red",    light=192 },
}


----------------------------------------------------------------

function freedoom_modifier(T)

  -- the FreeDOOM IWAD contains both Doom 1 and Doom 2 textures

---!!!  T.combos   = copy_and_merge(T.combos,   D1_COMBOS)
---!!!  T.exits    = copy_and_merge(T.exits,    D1_EXITS)
---!!!  T.hallways = copy_and_merge(T.hallways, D1_HALLWAYS)
---!!!
---!!!  T.rails = copy_and_merge(T.rails, D1_RAILS)
---!!!
---!!!  T.hangs   = copy_and_merge(T.hangs,   D1_OVERHANGS)
---!!!  T.mats    = copy_and_merge(T.mats,    D1_MATS)
---!!!  T.crates  = copy_and_merge(T.crates,  D1_CRATES)
---!!!
---!!!  T.liquids = copy_and_merge(T.liquids, D1_LIQUIDS, FD_LIQUIDS)

  T.sky_info = FD_SKY_INFO

  -- FreeDOOM is lacking many monster sprites

  T.monsters = {}
  
  for zzz,mon in ipairs(FD_MONSTER_LIST) do
    T.monsters[mon] = DM_MONSTERS[mon] or D2_MONSTERS[mon]
  end

  return T
end


OB_MODULES["freedoom"] =
{
  label = "FreeDoom 0.5",
  priority = 90,

  for_games = { doom2=1 },

  conflict_mods = { tnt=1, plut=1 },

  mod_func = freedoom_modifier,
}

