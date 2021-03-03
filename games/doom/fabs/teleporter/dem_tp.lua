--
-- Teleporter pad
--

PREFABS.Dem_teleports1 =
{
  file = "teleporter/dem_tp.wad",
  map = "MAP02",

  texture_pack = "armaetus",

  prob = 50,

  where = "point",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  sector_8  = { [8]=60, [2]=10, [3]=10, [17]=10, [21]=10 },
}

PREFABS.Dem_teleports2 =
{
  template = "Dem_teleports1",
  map = "MAP02",
}

--- Lill tribute to Turok 1 ---

PREFABS.Dem_teleports3 =
{
  template = "Dem_teleports1",
  map = "MAP03",
}

PREFABS.Dem_teleports4 =
{
  template = "Dem_teleports1",
  map = "MAP04",

  where = "seeds",
  env = "nature",

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}
