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

  local music_list = table.copy(GAME.RESOURCES.MUSIC_LUMPS)
  
  local data =
  [[
    //
    // Playlist.ddf created by OBSIDIAN
    //
	// 
  ]]

  for i = 1,#GAME.levels do
    local song_pick = rand.pick(music_list)

    local track_num = i

    -- Account for EC's playlist numbering
    if OB_CONFIG.game == "doom" or OB_CONFIG.game == "ultdoom" then
      track_num = track_num + 32
    end

    local track = string.format(
      "[%02d] MUSICINFO=LUMP:\"%s\";\n", track_num, song_pick)

    data = data .. track

    table.kill_elem(music_list, song_pick)

    if table.empty(music_list) then
      music_list = table.copy(GAME.RESOURCES.MUSIC_LUMPS)
    end
  end

  SCRIPTS.ddfplay = ScriptMan_combine_script(SCRIPTS.ddfplay, data)
end


function EDGE.create_language()

  
  local data =
[[
//
// Language.ldf created by OBSIDIAN\n
//

]]

  for _,L in pairs(GAME.levels) do
    if L.description then
      local id = string.format("%sDesc", L.name)
      local text = L.name .. ": " .. L.description
	  
      data = data .. string.format("%s = \"%s\";\n", id, text)
    end
  end

  SCRIPTS.ddflang = ScriptMan_combine_script(SCRIPTS.ddflang, data)
end


function EDGE.setup()
  gui.property("ef_solid_type",  400)
  gui.property("ef_liquid_type", 405)
  gui.property("ef_thing_mode", 2)
end


function EDGE.all_done()
  EDGE.create_language();
end

OB_MODULES["edge_music_swapper"] =
{
  label = _("EDGE Music Swapper"),

  where = "other",
  priority = 8,

  port = "edge",
  tooltip=_("Shuffles songs using DDFPLAY."),

  hooks =
  {
    all_done = EDGE.remap_music
  },
}

OB_PORTS["edge"] =
{
  label = _("EDGE-Classic"),

  extends = "advanced",

  priority = 95,

  game = { doom1=1, doom2=1, hacx=1, heretic=1, harmony=1, ultdoom=1, tnt=1, plutonia=1 },

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

