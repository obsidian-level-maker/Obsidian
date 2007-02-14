----------------------------------------------------------------
-- THEMES : TNT Evilution (Final DOOM)
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


THEME_FACTORIES["tnt"] = function()

  local T = THEME_FACTORIES.doom2()

  --[[
  T.themes   = copy_and_merge(T.themes,   TN_THEMES)
  T.exits    = copy_and_merge(T.exits,    TN_EXITS)
  T.hallways = copy_and_merge(T.hallways, TN_HALLWAYS)

  T.rails = copy_and_merge(T.rails, TN_RAILS)

  T.hangs   = copy_and_merge(T.hangs,   TN_OVERHANGS)
  T.mats    = copy_and_merge(T.mats,    TN_MATS)
  T.crates  = copy_and_merge(T.crates,  TN_CRATES)
  T.liquids = copy_and_merge(T.liquids, TN_LIQUIDS)
  --]]

  return T
end
