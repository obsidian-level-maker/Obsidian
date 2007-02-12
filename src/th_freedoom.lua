----------------------------------------------------------------
-- THEMES : FreeDOOM 0.5
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
  "wolf_ss", 
  "vile",

  ---| missing sprites |---
  
  -- "knight",  
  -- "pain",    

  -- "cyber",   
  -- "spider",  
}

function create_freedoom_theme()

  local T = common_doom_theme()

  -- the FreeDOOM IWAD contains both Doom 1 and Doom 2 textures

  T.themes   = copy_and_merge(T.themes,   D1_THEMES,   D2_THEMES)
  T.exits    = copy_and_merge(T.exits,    D1_EXITS,    D2_EXITS)
  T.hallways = copy_and_merge(T.hallways, D1_HALLWAYS, D2_HALLWAYS)

  T.rails = copy_and_merge(D1_RAILS, D2_RAILS)

  T.hangs   = copy_and_merge(T.hangs,   D1_OVERHANGS, D2_OVERHANGS)
  T.mats    = copy_and_merge(T.mats,    D1_MATS,      D2_MATS)
  T.crates  = copy_and_merge(T.crates,  D1_CRATES,    D2_CRATES)
  T.liquids = copy_and_merge(T.liquids, D1_LIQUIDS,   D2_LIQUIDS)

  -- FreeDOOM is lacking many monster sprites

  T.monsters = {}
  
  for zzz,mon in ipairs(FD_MONSTER_LIST) do
    T.monsters[mon] = DM_MONSTERS[mon] or D2_MONSTERS[mon]
  end

  return T
end

