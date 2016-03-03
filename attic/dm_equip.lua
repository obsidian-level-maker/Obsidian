----------------------------------------------------------------
--  MODULE: deathmatch equipment
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008-2009 Andrew Apted
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

OB_MODULES["dm_equip_doom"] =
{
  label = "DM Equipment (DOOM)",

  for_games = { doom2=1, doom1=1, freedoom=1 },
  for_modes = { dm=1, ctf=1 },

  options =
  {
    start_weap =
    {
      label = "Starting Weapon",

      choices =
      {
        { id="none",   label="NONE" },
        { id="saw",    label="Chainsaw" },
        { id="shotty", label="Shotgun" },
        { id="ssg",    label="SSG" },
        { id="chain",  label="Chaingun" },
        { id="launch", label="Rockets" },
        { id="plasma", label="Plasma" },
        { id="bfg",    label="BFG" },
        { id="mixed",  label="Mix It Up" },
      }
    }
  }
}

