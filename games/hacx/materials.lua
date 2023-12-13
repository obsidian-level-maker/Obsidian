HACX.LIQUIDS =
{
  water  = { mat="FWATER1",  light=168, special=0 },
  water2 = { mat="SLIME05", light=168, special=0 },

  slime  = { mat="SLIME01",  light=168, special=16, damage=20 },
  goo    = { mat="LAVA1",    light=168, special=16, damage=20 },
  lava   = { mat="SLIME09",   light=192, special=16, damage=20 },
  elec   = { mat="NUKAGE1",   light=176, special=16, damage=20 }
}

HACX.MATERIALS =
{
  -- special materials --
  _ERROR = { t="HW209", f="RROCK03" },
  _SKY   = { t="HW209", f="F_SKY1" },
  _DEFAULT = { t="HW209", f="RROCK03" },
  _LIQUID = { f="FWATER1", t="BLODRIP1" },
  XEMPTY = { t="-", f="-" },

  -- crates --
  HW200 = { t="HW200", f="RROCK03" },

  -- walls --
  BRNSMALC = { t="BRNSMALC", f="FLOOR0_1" },
  BSTONE1 = { t="BSTONE1", f="FLAT5_4" },
  BSTONE2 = { t="BSTONE2", f="FLAT5_4" },
  COMPUTE1 = { t="COMPUTE1", f="FLAT5_5" },
  HD6   = { t="HD6",   f="RROCK03" },
  HW185 = { t="HW185", f="FLOOR0_1" },
  HW211 = { t="HW211", f="RROCK03" },
  HW218 = { t="HW218", f="CONS1_5"},
  HW510 = { t="HW510", f="SLIME15" },
  HW511 = { t="HW511", f="SLIME14" },
  HW512 = { t="HW512", f="SLIME13" },
  HW513 = { t="HW513", f="SLIME16" },
  LITE2 = { t="LITE2", f="DEM1_2" },
  MODWALL3 = { t="MODWALL3", f="CEIL3_3" },
  PANEL9 = { t="PANEL9", f="CEIL4_3" },
  PLAT1 = { t="PLAT1", f="FLOOR6_2" },
  STARTAN3 = { t="STARTAN3", f="GRASS2" },
  ZZWOLF6 = { t="ZZWOLF6", f="CONS1_5" },

  -- flats --
  CEIL1_1 = { t="PLAT1", f="CEIL1_1" },
  CEIL3_4 = { t="MODWALL3", f="CEIL3_4" },
  CEIL4_3 = { t="PANEL9", f="CEIL4_3" },
  CONS1_5 = { t="ZZWOLF6", f="CONS1_5" },
  FLAT1_2 = { t="BRNSMALC", f="FLAT1_2" },
  FLAT5_4 = { t="BSTONE2", f="FLAT5_4" },
  FLAT5_5 = { t="COMPUTE1", f="FLAT5_5" },
  FLOOR0_1 = { t="HW185", f="FLOOR0_1" },
  FLOOR6_2 = { t="PLAT1", f="FLOOR6_2" },
  MFLR8_2 = { t="BSTONE3", f="MFLR8_2" },
  GRASS2 = { t="STARTAN3", f="GRASS2" },
  RROCK03 = { t="HW209", f="RROCK03" },
  RROCK04 = { t="HW209", f="RROCK04" },

  -- doorjamb/window frame --
  HW502 = { t="HW502", f="CONS1_5" },

  -- doors --
  HD5 = { t="HD5", f="CONS1_5" },

  -- switches --

  -- floors --

  -- rails --

  CABLE   = { t="HW167",    rail_h=48 },
  SHARKS  = { t="FIREWALB", rail_h=128 },
  SHELVES = { t="TEKGREN1", rail_h=128 },
  GRILL   = { t="TEKGREN2", rail_h=128 },
  WEB     = { t="HW213",    rail_h=34 },

  CAGE3     = { t="SPACEW3", rail_h=128 },
  CAGE4     = { t="SPACEW4", rail_h=128 },
  CAGE_BUST = { t="HW181",   rail_h=128 },

  FORCE_FIELD = { t="SLADRIP1", rail_h=128 },
  HIGH_BARS   = { t="HW203",    rail_h=128 },
  BRIDGE_RAIL = { t="HW211",    rail_h=128 },
  SUPT_BEAM   = { t="SHAWN2",   rail_h=128 },
  BARRACADE   = { t="HW225",    rail_h=128 },

  DARK_CONC_HOLE = { t="HW204", rail_h=128 },
  GRAY_ROCK_HOLE = { t="HW183", rail_h=128 },
  WASHGTON_HOLE  = { t="HW353", rail_h=128 },


  -- liquids / animated --

  NUKAGE1   = { f="NUKAGE1", t="HW177" },
  LAVA1    = { f="LAVA1",   t="HW325" },
  FWATER1  = { f="FWATER1", t="BLODRIP1" },
  SLIME05 = { f="SLIME05", t="WFALL1" },
  SLIME09   = { f="SLIME09", t="SFALL1" },
  SLIME01  = { f="SLIME01", t="BRICK6" },
  WFALL1 = { f="SLIME05", t="WFALL1" },

  -- teleporter
  BLOOD1 = { f="BLOOD1",  t="BRONZE1" },


  -- other --

  O_PILL   = { t="HW313", f="O_PILL",   sane=1 },
  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 },
  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 },
  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}

------------------------------------------------------------------------

HACX.PREFAB_FIELDS =
{
}


HACX.SKIN_DEFAULTS =
{
}
