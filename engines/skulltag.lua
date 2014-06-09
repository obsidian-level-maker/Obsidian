----------------------------------------------------------------
--  Engine: Skulltag
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2010 Andrew Apted
--  Copyright (C)      2009 Enhas
--  Copyright (C)      2009 Chris Pisarczyk
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

SKULLTAG = { }

SKULLTAG.ENTITIES =
{
  -- pickups
  max_potion = { id=5090, kind="pickup", r=20,h=16, pass=true }
  max_helmet = { id=5091, kind="pickup", r=20,h=16, pass=true }
  red_armor  = { id=5040, kind="pickup", r=20,h=16, pass=true }

  -- powerups
  turbo_sphere   = { id=5030, kind="pickup", r=20,h=45, pass=true }
  time_sphere    = { id=5032, kind="pickup", r=20,h=45, pass=true }
  invis_sphere   = { id=5035, kind="pickup", r=20,h=45, pass=true }
  doom_sphere    = { id=5036, kind="pickup", r=20,h=45, pass=true }
  guard_sphere   = { id=5037, kind="pickup", r=20,h=30, pass=true }
  random_sphere  = { id=5039, kind="pickup", r=20,h=45, pass=true }
 
  -- special powerups (multiplayer only)
  hellstone  = { id=6000, kind="pickup", r=20,h=45, pass=true }
  terminator = { id=6001, kind="pickup", r=20,h=45, pass=true }

  -- runes
  rune_strength = { id=5100, kind="pickup", r=20,h=45, pass=true }
  rune_rage     = { id=5101, kind="pickup", r=20,h=45, pass=true }
  rune_drain    = { id=5102, kind="pickup", r=20,h=45, pass=true }
  rune_spread   = { id=5103, kind="pickup", r=20,h=45, pass=true }
  rune_resist   = { id=5104, kind="pickup", r=20,h=45, pass=true }
  rune_regen    = { id=5105, kind="pickup", r=20,h=45, pass=true }
  rune_prosper  = { id=5106, kind="pickup", r=20,h=45, pass=true }
  rune_reflect  = { id=5107, kind="pickup", r=20,h=45, pass=true }
  rune_hi_jump  = { id=5108, kind="pickup", r=20,h=45, pass=true }
  rune_haste    = { id=5109, kind="pickup", r=20,h=45, pass=true }
}


SKULLTAG.PARAMETERS =
{
  bridges = true
  extra_floors = true
  liquid_floors = true
}


SKULLTAG.MATERIALS =
{
  -- textures

  N_SUBV01 = { t="N_SUBV01", f="FLOOR0_2" }
  N_SUBV02 = { t="N_SUBV02", f="FLOOR0_2" }
  N_SUBV03 = { t="N_SUBV03", f="FLAT1" }
  N_SUBV04 = { t="N_SUBV04", f="FLAT1" }
  N_SUBV05 = { t="N_SUBV05", f="FLAT3" }
  N_SUBV06 = { t="N_SUBV06", f="FLAT3" }
  N_SUBV07 = { t="N_SUBV07", f="FLOOR4_1" }
  N_SUBV08 = { t="N_SUBV08", f="FLOOR4_1" }

  -- flats

  FAN1     = { t="METAL",   f="FAN1" }
  NFMTSQ03 = { t="BROWN96", f="NFMTSQ03" }
  TLITE6_7 = { t="METAL",   f="TLITE6_7" }
}


function SKULLTAG.setup()
  -- extrafloors : use Legacy types
  gui.property("ef_solid_type",  281)
  gui.property("ef_liquid_type", 301)
  gui.property("ef_thing_mode", 1)
end


OB_ENGINES["skulltag"] =
{
  label = "Skulltag"

  extends = "zdoom"

  game =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  }

  tables =
  {
    SKULLTAG
  }

  hooks =
  {
    setup = SKULLTAG.setup
  }
}

