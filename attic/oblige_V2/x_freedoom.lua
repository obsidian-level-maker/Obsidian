----------------------------------------------------------------
-- GAME DEF : FreeDOOM 0.5
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
  "ss_dude", 

  ---| missing sprites |---
  
  -- "knight",  
  -- "pain",    

  -- "cyber",   
  -- "spider",  
  -- "vile",
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

GAME_FACTORIES["freedoom"] = function()

  -- the FreeDOOM IWAD contains both Doom 1 and Doom 2 textures

  -- TEMPORARY HACK
  local T = GAME_FACTORIES.doom2()

  T.sky_info = FD_SKY_INFO

  -- FreeDOOM is lacking many monster sprites

  T.monsters = {}
  
  for zzz,mon in ipairs(FD_MONSTER_LIST) do
    T.monsters[mon] = DM_MONSTERS[mon] or D2_MONSTERS[mon]
  end

  return T
end

