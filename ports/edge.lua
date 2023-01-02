----------------------------------------------------------------
--  Engine: EDGE-Classic
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2016  Andrew Apted
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

EDGE = {}


EDGE.ENTITIES =
{
  -- monsters --

  mbf_dog = { id=888, r=12,h=28 },

  -- pickups --

  kc_green = { id=7015, r=16,h=16, pass=true },
  ks_green = { id=7017, r=16,h=16, pass=true },

  night_vision = { id=7000, r=16,h=16, pass=true },
  jetpack      = { id=7020, r=16,h=16, pass=true },

  purple_armor = { id=7031, r=16,h=16, pass=true },
  yellow_armor = { id=7032, r=16,h=16, pass=true },
  red_armor    = { id=7033, r=16,h=16, pass=true },

  -- scenery --

  burnt_spike_stub = { id=7010, r=16,h=46 },

  -- special stuff --

  nukage_glow = { id=7041, r=16,h=16, pass=true },
  lava_glow   = { id=7042, r=16,h=16, pass=true },
  water_glow  = { id=7043, r=16,h=16, pass=true }
}


EDGE.PARAMETERS =
{
  bridges = true,
  extra_floors = true,
  liquid_floors = true,
  mirrors = true,
  thing_exfloor_flags = true,
  tga_images = true
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
    "//\n",
    "// Playlist.ddf created by OBLIGE\n",
    "//\n\n",
    "<PLAYLISTS>\n\n"
  }

  for i = 1,10 do
    local track = string.format(
      "[%02d] MUSICINFO = MUS:LUMP:\"D_%s\";\n", i, mus_list[i])

    table.insert(data, track)
  end

  gui.wad_add_text_lump("DDFPLAY", data);
end


function EDGE.create_language()

  local data =
  {
    "//\n",
    "// Language.ldf created by OBLIGE\n",
    "//\n\n",
    "<LANGUAGES>\n\n",
    "[ENGLISH]\n"
  }

  for _,L in pairs(GAME.levels) do
    if L.description then
      local id = string.format("%sDesc", L.name)
      local text = L.name .. ": " .. L.description;

      table.insert(data, string.format("%s = \"%s\";\n", id, text))
    end
  end

  gui.wad_add_text_lump("DDFLANG", data);
end


function EDGE.setup()
  gui.property("ef_solid_type",  400)
  gui.property("ef_liquid_type", 405)
  gui.property("ef_thing_mode", 2)
end


function EDGE.all_done()
  EDGE.create_language();

  --EDGE.remap_music()
end


OB_PORTS["edge"] =
{
  label = _("EDGE-Classic"),

  extends = "advanced",

  priority = 95,

  game = { doom1=1, doom2=1, hacx=1, harmony=1, heretic=1 },

  tables =
  {
    EDGE
  },

  hooks =
  {
    setup    = EDGE.setup,
    all_done = EDGE.all_done
  }
}

