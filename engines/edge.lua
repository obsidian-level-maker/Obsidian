----------------------------------------------------------------
--  Engine: EDGE (Enhanced Doom Gaming Engine)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008,2010 Andrew Apted
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

EDGE = { }

EDGE.ENTITIES =
{
  -- players --

  player5 = { id=4001, kind="other", r=16,h=56 }
  player6 = { id=4002, kind="other", r=16,h=56 }
  player7 = { id=4003, kind="other", r=16,h=56 }
  player8 = { id=4004, kind="other", r=16,h=56 }

  -- monsters --

  mbf_dog = { id=888, kind="monster", r=12,h=28 }

  -- pickups --

  kc_green = { id=7015, kind="pickup", r=16,h=16, pass=true }
  ks_green = { id=7017, kind="pickup", r=16,h=16, pass=true }

  night_vision = { id=7000, kind="pickup", r=16,h=16, pass=true }
  jetpack      = { id=7020, kind="pickup", r=16,h=16, pass=true }

  purple_armor = { id=7031, kind="pickup", r=16,h=16, pass=true }
  yellow_armor = { id=7032, kind="pickup", r=16,h=16, pass=true }
  red_armor    = { id=7033, kind="pickup", r=16,h=16, pass=true }

  -- scenery --

  burnt_spike_stub = { id=7010, kind="scenery", r=16,h=46 }

  nukage_glow = { id=7041, kind="scenery", r=16,h=16, pass=true }
  lava_glow   = { id=7042, kind="scenery", r=16,h=16, pass=true }
  water_glow  = { id=7043, kind="scenery", r=16,h=16, pass=true }
}


EDGE.PARAMETERS =
{
  bridges = true
  extra_floors = true
  liquid_floors = true
  mirrors = true
  thing_exfloor_flags = true
}


----------------------------------------------------------------

function EDGE.remap_music()
  
  -- FIXME: DOOM2 specific!!!
  local mus_list =
  {
    "RUNNIN", "STALKS", "COUNTD", "BETWEE", "DOOM",
    "THE_DA", "SHAWN", "DDTBLU", "IN_CIT", "DEAD",
  }

  local old_list = table.copy(mus_list)

  rand.shuffle(mus_list)

  local data =
  {
    "//\n"
    "// Playlist.ddf created by OBLIGE\n"
    "//\n\n"
    "<PLAYLISTS>\n\n"
  }

  for i = 1,10 do
    local track = string.format(
      "[%2d] MUSICINFO = MUS:LUMP:D_%s;\n", i, mus_list[i])
 
    table.insert(data, track)
  end

  gui.wad_add_text_lump("DDFPLAY", data);
end


function EDGE.create_language()
  
  local data =
  {
    "//\n"
    "// Language.ldf created by OBLIGE\n"
    "//\n\n"
    "<LANGUAGES>\n\n"
    "[ENGLISH]\n"
  }

  each L in GAME.levels do
    if L.description then
      local id = string.format("%sDesc", L.name)
      local text = L.name .. ": " .. L.description;

      table.insert(data, string.format("%s = \"%s\";\n", id, text))
    end
  end

  -- TODO: use TNTLANG and PLUTLANG when necessary
  gui.wad_add_text_lump("DDFLANG", data);
end


function EDGE.setup()
  gui.property("ef_solid_type",  400)
  gui.property("ef_liquid_type", 405)
  gui.property("ef_thing_mode", 2)
end


function EDGE.all_done()
  EDGE.create_language();

  -- Edge_remap_music()
end


OB_ENGINES["edge"] =
{
  label = "EDGE"
  priority = 90

  extends = "boom"

  game = { doom1=1, doom2=1 }

  tables =
  {
    EDGE
  }

  hooks =
  {
    setup    = EDGE.setup
--  all_done = EDGE.all_done
  }
}

