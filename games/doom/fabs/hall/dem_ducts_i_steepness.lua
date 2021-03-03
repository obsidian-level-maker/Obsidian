--
-- ducts piece : straight
--

-- Made by MSSP, steepness pieces based on Demios's ducts set

PREFABS.Hallway_ducts_i_slope =
{
  file   = "hall/dem_ducts_i_steepness.wad",
  map    = "MAP01",

  group  = "ducts",
  prob   = 50,

  style = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  delta_h = 64,

  can_flip = true,
}

PREFABS.Hallway_ducts_i_fanwell =
{
  template = "Hallway_ducts_i_slope",
  map    = "MAP02",

  delta_h = 64,

  can_flip = true,
}
