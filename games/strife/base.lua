------------------------------------------------------------------------
--  BASE FILE for STRIFE
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
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

STRIFE = { }


------------------------------------------------------------
gui.import("params")

gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
gui.import("vanilla_mats")

------------------------------------------------------------

function STRIFE.merge_conversation_script()
  local convo_file = "games/strife/data/CONVERSATIONS.wad"

  gui.wad_transfer_lump(convo_file, "SCRIPT00", "SCRIPT00")
end


OB_GAMES["strife"] =
{
  label = _("Strife"),
  priority = 89,

  format = "doom",
  --sub_format = "strife",

  game_dir = "strife",
  iwad_name = "strife1.wad",

  use_generics = true,

  tables =
  {
    STRIFE
  },

  hooks =
  {
    get_levels = STRIFE.get_levels,
    all_done   = STRIFE.merge_conversation_script
  },
}

