----------------------------------------------------------------
--  GAME DEFINITION : FreeDOOM
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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

FREEDOOM = { }

FREEDOOM.MONSTER_LIST =
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

FREEDOOM.SCENERY_LIST =
{
  ---| missing sprites |---

  hang_arm_pair = 0,
  hang_leg_pair = 0,
  hang_leg_gone = 0,
  hang_leg      = 0,
}

FREEDOOM.LIQUID_LIST = --FIXME
{
  water = { floor="FWATER1", wall="WFALL1" },
}

FREEDOOM.SKY_INFO =
{
  { color="brown",  light=192 },
  { color="black",  light=160 },
  { color="red",    light=192 },
}


----------------------------------------------------------------


function FREEDOOM.setup()

  GAME.sky_info = FREEDOOM.SKY_INFO

  -- FreeDOOM is lacking many monster sprites

  for name,quality in pairs(FREEDOOM.MONSTER_LIST) do
    if quality < 1 then
      GAME.monsters[name] = nil
    end
  end

  -- FreeDOOM is lacking some scenery sprites

  for name,quality in pairs(FREEDOOM.SCENERY_LIST) do
    if quality < 1 then
      GAME.things[name] = nil
    end
  end
end


OB_GAMES["freedoom"] =
{
  label = "FreeDoom 0.6",

  extends = "doom2",

  tables =
  {
    -- TODO
  },

  hooks =
  {
    setup = FREEDOOM.setup,
  },

  -- no additional parameters
}

