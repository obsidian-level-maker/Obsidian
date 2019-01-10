--------------------------------------------------------------------
--  The Plutonia Experiment
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

PLUTONIA = { }


PLUTONIA.PARAMETERS =
{
  bex_map_prefix  = "PHUSTR_"

  bex_secret_name  = "P5TEXT"
  bex_secret2_name = "P6TEXT"
}


PLUTONIA.MATERIALS =
{
  -- Note the actual texture names contain hyphens, but we must use
  -- an underscore for the OBLIGE material names.

  A_BRBRK  = { t="A-BRBRK",  f="RROCK18" }
  A_BRBRK2 = { t="A-BRBRK2", f="RROCK16" }
  A_BRICK1 = { t="A-BRICK1", f="MFLR8_1" }
  A_BROWN1 = { t="A-BROWN1", f="RROCK17" }
  A_BROWN2 = { t="A-BROWN2", f="FLAT8" }
  A_BROWN3 = { t="A-BROWN3", f="RROCK03" }
  A_BROWN5 = { t="A-BROWN5", f="RROCK19" }

  A_CAMO1 =  { t="A-CAMO1",  f="GRASS1" }
  A_CAMO2 =  { t="A-CAMO2",  f="SLIME13" }
  A_CAMO3 =  { t="A-CAMO3",  f="SLIME13" }
  A_CAMO4 =  { t="A-CAMO4",  f="FLOOR7_2" }

  A_DBRI1 =  { t="A-DBRI1",  f="FLAT5_4" }
  A_DBRI2 =  { t="A-DBRI2",  f="MFLR8_2" }
  A_DROCK1 = { t="A-DROCK1", f="FLOOR6_2" }
  A_DROCK2 = { t="A-DROCK2", f="MFLR8_2" }

  A_MARBLE = { t="A-MARBLE", f="FLAT1" }
  A_MOSBRI = { t="A-MOSBRI", f="SLIME13" }
  A_MOSROK = { t="A-MOSROK", f="FLAT5_7" }
  A_MOSRK2 = { t="A-MOSRK2", f="SLIME13" }
  A_MOULD =  { t="A-MOULD",  f="RROCK19" }
  A_MUD =    { t="A-MUD",    f="RROCK16" }

  A_MYWOOD = { t="A-MYWOOD", f="FLAT5_1" }
  A_POIS =   { t="A-POIS",   f="CEIL5_2" }
  A_REDROK = { t="A-REDROK", f="FLAT5_3" }
  A_ROCK =   { t="A-ROCK",   f="FLAT5_7" }
  A_TILE =   { t="A-TILE",   f="GRNROCK" }
  A_VINE3 =  { t="A-VINE3",  f="RROCK12" }
  A_VINE4 =  { t="A-VINE4",  f="RROCK16" }
  A_VINE5 =  { t="A-VINE5",  f="MFLR8_3" }

  A_YELLOW = { t="A-YELLOW", f="FLAT23" }

  -- TODO: A-SKINxxx

  -- this is animated
  AROCK1   = { t="AROCK1",   f="GRNROCK" }
  FIREBLU1 = { t="FIREBLU1", f="GRNROCK" }

  JUNGLE1  = { t="MC10", f="RROCK19" }
  JUNGLE2  = { t="MC2",  f="RROCK19" }

  -- use the TNT name for this
  METALDR  = { t="A-BROWN4", f="CEIL5_2" }

  -- use Plutonia's waterfall texture instead of our own
  WFALL1   = { t="WFALL1", f="FWATER1", sane=1 }
  FWATER1  = { t="WFALL1", f="FWATER1", sane=1 }


  -- TODO: Rails
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_RAIL1 = { t="A-RAIL1", h=32 }
  --   A_VINE1 = { t="A-VINE1", h=128 }
  --   A_VINE2 = { t="A-VINE2", h=128 }


  -- Overrides for existing DOOM materials --

  WOOD1    = { t="A-MYWOOD", f="FLAT5_2" }
  CEIL1_1  = { f="CEIL1_1", t="A-WOOD1" }
  CEIL1_3  = { f="CEIL1_3", t="A-WOOD1" }
  FLAT5_1  = { f="FLAT5_1", t="A-WOOD1" }
  FLAT5_2  = { f="FLAT5_2", t="A-WOOD1" }

  STONE   = { t="A-CONCTE", f="FLAT5_4" }
  FLAT5_4 = { t="A-CONCTE", f="FLAT5_4" }

  BIGBRIK2 = { t="A-BRICK1", f="MFLR8_1" }
  BIGBRIK1 = { t="A-BRICK2", f="RROCK14" }
  RROCK14  = { t="A-BRICK2", f="RROCK14" }
  BRICK5   = { t="A-BRICK3", f="RROCK12" }
  BRICJ10  = { t="A-TILE",   f="GRNROCK" }
  BRICK11  = { t="A-BRBRK",  f="RROCK18" }
  BRICK12  = { t="A-BROCK2", f="FLOOR4_6" }

  ASHWALL4 = { t="A-DROCK2", f="MFLR8_2" }
  ASHWALL7 = { t="A-MUD",    f="RROCK16" }

  BIGDOOR2 = { t="A-BROWN4", f="CEIL5_2" }
  BIGDOOR3 = { t="A-BROWN4", f="CEIL5_2" }
  BIGDOOR4 = { t="A-BROWN4", f="CEIL5_2" }
}


PLUTONIA.EPISODES =
{
  episode1 =
  {
    theme = "tech"
    sky_patch = "SKY1"
    dark_prob = 10
    bex_mid_name = "P1TEXT"
    bex_end_name = "P2TEXT"
  }

  episode2 =
  {
    theme = "urban"
    sky_patch  = "SKY2A"
    sky_patch2 = "SKY2B"
    sky_patch3 = "SKY2C"
    sky_patch4 = "SKY2D"
    dark_prob = 10
    bex_end_name = "P3TEXT"
  }

  episode3 =
  {
    theme = "hell"
    sky_patch  = "SKY3A"
    sky_patch2 = "SKY3B"
    dark_prob = 40
    bex_end_name = "P4TEXT"
  }
}


--------------------------------------------------------------------

OB_GAMES["plutonia"] =
{
  label = _("Plutonia")

  extends = "doom2"

  iwad_name = "plutonia.wad"

  tables =
  {
    PLUTONIA
  }
}

