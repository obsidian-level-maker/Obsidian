-- fake teleport that reveals monsters and a real teleport!(based on closet2.wad)

PREFABS.Teleporter_scionox_trap_teleport =
{
  file   = "teleporter/scionox_trap_teleport.wad",
  map    = "MAP01",

  prob   = 5,
  theme  = "!tech",

  where  = "seeds",
  style  = "traps",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit = "frame",
  y_fit = "top",

  tag_2 = "?out_tag",
  tag_3 = "?in_tag",

  flat_FLAT5_3 = "REDWALL",
  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=5 },
}

PREFABS.Teleporter_scionox_trap_teleport_2 =
{
  template = "Teleporter_scionox_trap_teleport",
  map    = "MAP02",

  sector_13 = { [13]=50, [12]=25, [1]=15, [2]=10, [3]=10, [0]=5 },
  tex_SW1GARG = { SW1GARG=50, SW1LION=50, SW1SATYR=50 },
}

PREFABS.Teleporter_scionox_trap_teleport_3 =
{
  template = "Teleporter_scionox_trap_teleport",
  map    = "MAP03",

  theme  = "tech",
}

PREFABS.Teleporter_scionox_trap_teleport_4 =
{
  template = "Teleporter_scionox_trap_teleport",
  map    = "MAP04",

  theme  = "urban",
  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=3 },
}

PREFABS.Teleporter_scionox_trap_teleport_5 =
{
  template = "Teleporter_scionox_trap_teleport",
  map    = "MAP05",

  theme  = "hell",
}
