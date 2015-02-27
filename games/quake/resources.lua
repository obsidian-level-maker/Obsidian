------------------------------------------------------------------------
--  QUAKE RESOURCES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------


-- TODO : create logos (etc)


function QUAKE.begin_level()
  -- find the texture wad
  local primary_tex_wad = gui.locate_data("quake_tex.wd2")

  if not primary_tex_wad then
    error("cannot find texture file: quake_tex.wd2\n\n" ..
          "Please visit the following link which takes you to the " ..
          "Quake Setup documentation on the OBLIGE website: " ..
          "<a http://oblige.sourceforge.net/doc_usage.html#quake>Setting Up Quake</a>")
  end

  gui.q1_add_tex_wad(primary_tex_wad)

  -- set worldtype (controls the way keys look, doors sound, etc)
  gui.property("worldtype", LEVEL.theme.worldtype)

  -- select the sky to use
  assert(LEVEL.theme.skies)
  GAME.MATERIALS["_SKY"].t = rand.key_by_probs(LEVEL.theme.skies)
end

