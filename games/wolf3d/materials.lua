------------------------------------------------------------------------
--  WOLF3D MATERIALS
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

WOLF.LIQUIDS =
{
  --water = { mat="F_WATR01", light_add=16, special=0 },
}


WOLF.MATERIALS =
{
  -- special materials --

  _ERROR = { t=WF_NO_TILE },
  _FLOOR = { t=WF_NO_TILE },
  _SKY   = { t=0x10 },

  -- common stuff --

  BLU_BRIK  = { t=0x28, hue="#00F" },
  BLU_SKUL  = { t=0x22, hue="#00F" },
  BLU_SWAST = { t=0x24, hue="#00F" },
  BLU_STON1 = { t=0x08, hue="#00F" },
  BLU_STON2 = { t=0x09, hue="#00F" },
  BLU_CELL  = { t=0x05, hue="#00F" },
  BLU_SKELE = { t=0x07, hue="#00F" },
  BLU_SIGN  = { t=0x29, hue="#00F" },

  BR_BRICK1 = { t=0x2a, hue="#C60" },
  BR_BRICK2 = { t=0x2e, hue="#C60" },
  BR_FLAG   = { t=0x2f, hue="#C60" },
  BR_CAVE1  = { t=0x1d, hue="#C60" },
  BR_CAVE2  = { t=0x1e, hue="#C60" },
  BR_CAVE3  = { t=0x1f, hue="#C60" },
  BR_CAVE4  = { t=0x20, hue="#C60" },
  BR_STONE1 = { t=0x2c, hue="#C60" },
  BR_STONE2 = { t=0x2d, hue="#C60" },

  ELEVATOR  = { t=0x15, hue="#FF0" },
  ELEV_DEAD = { t=0x16, hue="#FF0" },
  ELEV_ENTR = { t=0x0d, hue="#FF0" },

  GBRK_VENT = { t=0x25, hue="#CCC" },
  GBRK_MAP  = { t=0x2b, hue="#CCC" },
  GBRICK1   = { t=0x23, hue="#CCC" },
  GBRICK2   = { t=0x27, hue="#CCC" },
  GR_STAIN  = { t=0x21, hue="#CCC" },
  GSTONE1   = { t=0x01, hue="#CCC" },
  GSTONE2   = { t=0x02, hue="#CCC" },
  GSTONE3   = { t=0x1b, hue="#CCC" },
  GSTN_EAGL = { t=0x06, hue="#CCC" },
  GSTN_HIT1 = { t=0x04, hue="#CCC" },
  GSTN_HIT2 = { t=0x31, hue="#CCC" },
  GSTN_MOS1 = { t=0x18, hue="#CCC" },
  GSTN_MOS2 = { t=0x1a, hue="#CCC" },
  GSTN_FLAG = { t=0x03, hue="#CCC" },
  GSTN_SIGN = { t=0x1c, hue="#CCC" },

  PURP_BLOD = { t=0x19, hue="#F0F" },
  PURP_STON = { t=0x13, hue="#F0F" },
  RED_BRIK  = { t=0x11, hue="#F00" },
  RED_EAGLE = { t=0x14, hue="#F00" },
  RED_MULTI = { t=0x26, hue="#F00" },
  RED_WREAT = { t=0x12, hue="#F00" },

  STEL_SIGN = { t=0x0e, hue="#0FF" },
  STEL_PLAT = { t=0x0f, hue="#0FF" },
  WOOD1     = { t=0x0c, hue="#F90" },
  WOOD2     = { t=0x30, hue="#F90" },
  WOOD_CROS = { t=0x17, hue="#F90" },
  WOOD_EAGL = { t=0x0a, hue="#F90" },
  WOOD_HITL = { t=0x0b, hue="#F90" },

  -- wolf3d only --

  JAM_DOOR1 = { t=0x32 },
  JAM_DOOR2 = { t=0x35 },
  DOOR_SIDE = { t=0x33 },
}



------------------------------------------------------------------------

WOLF.PREFAB_FIELDS =
{
  -- TODO : compatibility with DOOM prefabs
}


WOLF.SKIN_DEFAULTS =
{
}

