HACX.LIQUIDS =
{
  water  = { mat="L_WATER",  light=168, special=0 },
  water2 = { mat="L_WATER2", light=168, special=0 },

  slime  = { mat="L_SLIME",  light=168, special=16, damage=20 },
  goo    = { mat="L_GOO",    light=168, special=16, damage=20 },
  lava   = { mat="L_LAVA",   light=192, special=16, damage=20 },
  elec   = { mat="L_ELEC",   light=176, special=16, damage=20 }
}

HACX.MATERIALS =
{
  -- special materials --
  _ERROR = { t="HW209", f="RROCK03" },
  _SKY   = { t="HW209", f="F_SKY1" },
  _DEFAULT = { t="HW209", f="RROCK03" },
  _LIQUID = { f="FWATER1", t="BLODRIP1" },
  XEMPTY = { t="-", f="-" },

  -- general purpose --

  METAL  = { t="HW209", f="RROCK03" },

  LIFT   = { t="HW176", f="DEM1_1" },

  -- walls --

  BROWNHUG = { t="BROWNHUG", f="BLOOD1" },

  DOORTRAK = { t="HW209", f="RROCK03" },

  HD6   = { t="HD6",   f="RROCK03" },
  HW211 = { t="HW211", f="RROCK03" },
  HW510 = { t="HW510", f="SLIME15" },
  HW511 = { t="HW511", f="SLIME14" },
  HW512 = { t="HW512", f="SLIME13" },
  HW513 = { t="HW513", f="SLIME16" },

  TECHY1 = { t="HW172", f="FLAT5_1" },
  WOODY1 = { t="COMPTALL", f="RROCK14" },
  BLOCKY1 = { t="HW219", f="RROCK11" },
  BLOCKY2 = { t="MIDBRONZ", f="CONS1_1" },

  CAVEY1 = { t="MARBFAC4", f="RROCK12" },
  DIRTY1 = { t="PANCASE1", f="RROCK15" },
  DIRTY2 = { t="PANEL2",   f="RROCK15" },
  STONY1 = { t="PLANET1",  f="GRNROCK" },

  GRAY_ROCK = { t="HW185", f="FLOOR0_1" },

  DARK_CONC = { t="HW205", f="CONS1_5" },


  LITE2 = { t="LITE2", f="DEM1_2" },

  MODWALL3 = { t="MODWALL3", f="CEIL3_3" },


  TECH_PIC1 = { t="BRNSMALR", f="RROCK03" },
  TECH_PIC2 = { t="CEMENT7",  f="RROCK03" },

  TECH_COMP = { t="COMPSTA2", f="RROCK03" },

  LOGO_1 = { t="PANEL6", f="RROCK03" },

  -- doors --
  
  BIGDOOR1   = { t="BIGDOOR1",   f="RROCK03" },
  BIGDOOR2 = { t="BIGDOOR2", f="RROCK03" },
  BIGDOOR4 = { t="BIGDOOR4", f="RROCK03" },
  DOOR1 = { t="DOOR1", f="RROCK03" },
  DOOR3 = { t="DOOR3", f="RROCK03" },
  DOORBLU = { t="DOORBLU", f="RROCK03" },
  DOORRED = { t="DOORRED", f="RROCK03" },

  -- switches --

  SW1CMT = { t="SW1CMT", f="DEM1_2" },


  -- floors --

  GRASS1 = { t="MARBGRAY", f="TLITE6_1" },
  GRASS2 = { t="MARBGRAY", f="CONS1_7" },

  GRAY_BRICK = { f="GRASS2", t="STARTAN3" },
  HERRING_1  = { f="FLAT9", t="HW306" },
  WOOD_TILE  = { f="CEIL5_2", t="MIDBARS1", },

--FLAT14   = { t="STARTAN3", f="FLAT14" }


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

  L_ELEC   = { f="NUKAGE1", t="HW177" },
  L_GOO    = { f="LAVA1",   t="HW325" },
  L_WATER  = { f="FWATER1", t="BLODRIP1" },
  L_WATER2 = { f="SLIME05", t="WFALL1" },
  L_LAVA   = { f="SLIME09", t="SFALL1" },
  L_SLIME  = { f="SLIME01", t="BRICK6" },

  TELEPORT = { f="BLOOD1",  t="BRONZE1" },


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
