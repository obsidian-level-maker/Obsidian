PREFABS.Decor_armaetus_basic_computer1 =
{
  file   = "decor/armaetus_basiccomp1.wad",
  map    = "MAP01",

  texture_pack = "armaetus",

  prob   = 3500,
  theme  = "!hell",
  env    = "building", --!cave

  where  = "point",
  size   = 96,
  height = 136,

  bound_z1 = 0,
  bound_z2 = 138,
}

PREFABS.Decor_armaetus_basic_computer2 =
{
  template = "Decor_armaetus_basic_computer1",
  map      = "MAP02",
}

PREFABS.Decor_armaetus_basic_computer3 =
{
  template = "Decor_armaetus_basic_computer1",
  map      = "MAP03",
}

-- This uses action 261 ( Set Tagged Ceiling Lighting to Lighting on 1st Sidedef's Sector ) to give the
-- effect of light on the lower area without light being on the ceiling indoors. It is done with a tagged linedef
-- (tag 1 in editor) adjacent to a sector in light level 144 (Oblige's prefab default) and the desired
-- sector to give the effect to tagged as well. This can be very useful for other prefabs to give the illusion
-- of lighting effects on the lower level but don't want the sector to light up like Christmas.
--
-- Reference: https://soulsphere.org/projects/boomref/ under "Extended Property Transfer Linedefs",
PREFABS.Decor_armaetus_basic_computer4 =
{
  template = "Decor_armaetus_basic_computer1",
  map      = "MAP04",
}
