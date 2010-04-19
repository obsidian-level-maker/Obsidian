----------------------------------------------------------------
--  MODULE: Prefab Tester
----------------------------------------------------------------
--
--  Copyright (C) 2010 Andrew Apted
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

PREFAB_FILE = "ARCHWAY.lua"
PREFAB_NAME = "ARCHWAY"


function Build_Prefab()
  
  -- empty room
  Trans.brush("solid",
  {
    { x=-512, y=-512, tex="BLAKWAL1" },
    { x= 512, y=-512, tex="BLAKWAL1" },
    { x= 512, y= 512, tex="BLAKWAL1" },
    { x=-512, y= 512, tex="BLAKWAL1" },
    { t=0, tex="CEIL5_1" },
  })

  Trans.brush("solid",
  {
    { x=-512, y=-512, tex="BLAKWAL1" },
    { x= 512, y=-512, tex="BLAKWAL1" },
    { x= 512, y= 512, tex="BLAKWAL1" },
    { x=-512, y= 512, tex="BLAKWAL1" },
    { b=512, tex="CEIL5_1", light=1.0 },
  })

  -- player start
  Trans.entity("player1", 0, -400, 0)

  -- FIXME : THE PREFAB
end


function Test_Prefab()
  
  -- load it
  assert(loadfile(PREFAB_FILE))()

  GAME.all_levels[1].build_func = Build_Prefab
end


OB_MODULES["prefab_tester"] =
{
  label = "Prefab Tester",

  for_games = { doom2=1 },

  hooks = { get_levels = Test_Prefab },
}

