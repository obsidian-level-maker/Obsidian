-- teleport except reveals monsters instead!(based on closet2.wad)

PREFABS.Cage_scionox_fake_teleport =
{
  file   = "cage/scionox_fake_teleport.wad",
  map    = "MAP01",

  prob   = 100,
  theme  = "!tech",
  style  = "traps",

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit = "frame",
  y_fit = "top",

  flat_FLAT5_3 = "REDWALL",
  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=5 }
}

PREFABS.Cage_scionox_fake_teleport_2 =
{
  template = "Cage_scionox_fake_teleport",
  map    = "MAP02",

  sector_13 = { [13]=50, [12]=25, [1]=15, [2]=10, [3]=10, [0]=5 },
  tex_SW1GARG = { SW1GARG=50, SW1LION=50, SW1SATYR=50 }
}

PREFABS.Cage_scionox_fake_teleport_3 =
{
  template = "Cage_scionox_fake_teleport",
  map    = "MAP03",

  theme  = "tech",
}

PREFABS.Cage_scionox_fake_teleport_4 =
{
  template = "Cage_scionox_fake_teleport",
  map    = "MAP04",

  theme  = "urban",
  sector_8 = { [8]=50, [1]=15, [2]=10, [3]=10, [0]=3 }
}

PREFABS.Cage_scionox_fake_teleport_5 =
{
  template = "Cage_scionox_fake_teleport",
  map    = "MAP05",

  theme  = "hell",
}
