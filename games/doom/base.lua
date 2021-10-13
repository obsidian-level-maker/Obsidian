------------------------------------------------------------------------
--  BASE FILE for DOOM, DOOM II (etc)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

DOOM = { }


gui.import("params")

gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("shapes")

gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")

function DOOM.setup()
  if OB_CONFIG.engine == "nolimit" then
    DOOM.THEMES.DEFAULTS.narrow_halls = { vent = 50 }
    DOOM.THEMES.DEFAULTS.wide_halls = { deuce = 50 }
    DOOM.THEMES.DEFAULTS.has_triple_key_door = false
    DOOM.THEMES.DEFAULTS.has_double_switch_door = false
    DOOM.THEMES.tech.narrow_halls = { vent = 50 }
    DOOM.THEMES.tech.beam_groups = { beam_metal = 50 }
    DOOM.THEMES.tech.wall_groups = { PLAIN = 50 }
    DOOM.THEMES.tech.outdoor_wall_groups = { PLAIN = 50 }
    DOOM.THEMES.tech.window_groups = { square = 70, tall = 30 }
    DOOM.THEMES.tech.fence_groups = { PLAIN = 50 }
    DOOM.THEMES.tech.fence_posts = { Post = 50 }
    DOOM.THEMES.urban.narrow_halls = { vent = 50 }
    DOOM.THEMES.urban.beam_groups = { beam_metal = 50 }
    DOOM.THEMES.urban.wall_groups = { PLAIN = 50 }
    DOOM.THEMES.urban.outdoor_wall_groups = { PLAIN = 50 }
    DOOM.THEMES.urban.window_groups = { square = 70, tall = 30 }
    DOOM.THEMES.urban.fence_groups = { PLAIN = 50 }
    DOOM.THEMES.urban.fence_posts = { Post = 50 }
    DOOM.THEMES.hell.narrow_halls = { vent = 50 }
    DOOM.THEMES.hell.beam_groups = { beam_metal = 50 }
    DOOM.THEMES.hell.wall_groups = { PLAIN = 50 }
    DOOM.THEMES.hell.outdoor_wall_groups = { PLAIN = 50 }
    DOOM.THEMES.hell.window_groups = { square = 70, tall = 30 }
    DOOM.THEMES.hell.fence_groups = { PLAIN = 50 }
    DOOM.THEMES.hell.fence_posts = { Post = 50 }
  end
end
------------------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = _("Doom 2"),

  priority = 99,  -- keep at top

  format = "doom",
  game_dir = "doom",
  iwad_name = "doom2.wad",

  use_generics = true,

  tables =
  {
    DOOM
  },

  hooks =
  {
    setup = DOOM.setup,
    get_levels = DOOM.get_levels,
    end_level  = DOOM.end_level,
    all_done   = DOOM.all_done
  },
}


------------------------------------------------------------------------

-- pull in the other Doom games...

gui.import("x_doom1")
gui.import("x_tnt")
gui.import("x_plutonia")

