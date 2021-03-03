------------------------------------------------------------------------
--  STRIFE MATERIALS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.LIQUIDS =
{
  water = { mat="F_WATR01", light_add=16, special=0 },
}


STRIFE.MATERIALS =
{
  -- special materials --
  _DEFAULT = { t="CONCRT01", f="F_CONCRP" },
  _ERROR = { t="BIGSTN02", f="P_SPLATR" },
  _SKY   = { t="BIGSTN01", f="F_SKY001" },

  -- textures --

  BRKGRY01 = { t="BRKGRY01", f="F_BRKTOP" },
  BRKGRY17 = { t="BRKGRY17", f="F_BRKTOP" },
  WALCAV01 = { t="WALCAV01", f="F_CAVE01" },
  DORWS02  = { t="DORWS02", f="F_PLYWOD" },
  DORTRK02 = { t="DORTRK02", f="F_PLYWOD" },
  WOOD08   = { t="WOOD08", f="F_PLYWOD" },

  -- flats --

  F_BRKTOP = { t="BRKGRY01", f="F_BRKTOP" },
  F_CAVE01 = { t="WALCAV01", f="F_CAVE01" },

  -- liquids --
  F_WATR01 = { f="F_WATR01", t="WATR01" },

}


------------------------------------------------------------------------

STRIFE.PREFAB_FIELDS =
{
  -- TODO : compatibility with DOOM prefabs
}


STRIFE.SKIN_DEFAULTS =
{
}

