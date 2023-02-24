
PREFABS.Pic_dem_commercial_set1 =
{
  file   = "picture/dem_pic_commercial_set.wad",
  map    = "MAP01",

  rank = 1,

  prob   = 250,
  theme = "urban",

  group = "dem_wall_commercial",

  where  = "seeds",
  height = 104,
  deep = 16,

  theme  = "urban",
  env = "building",

  seed_w = 2,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_FLAT14 = { FLAT14 = 50, FLOOR1_1=50 },

  x_fit = "frame",
  y_fit = "top",

  texture_pack = "armaetus"
}

PREFABS.Pic_dem_commercial_set2 =
{
  template = "Pic_dem_commercial_set1",
  map    = "MAP02",

  height = 88,

  seed_h = 1,

  bound_z2 = 88,

  x_fit = "stretch",

  tex_DNSTOR07 = { DNSTOR07 = 50, DNSTOR07=50, DNSTOR08=50, DNSTOR09=50, },

  sound = "Electric_Sparks"
}

PREFABS.Pic_dem_commercial_set3 =
{
  template = "Pic_dem_commercial_set1",
  map    = "MAP03",

  seed_h = 1,

  bound_z2 = 104
}

PREFABS.Pic_dem_commercial_set4 =
{
  template = "Pic_dem_commercial_set1",
  map    = "MAP04",

  seed_h = 1,

  bound_z2 = 104
}

PREFABS.Pic_dem_commercial_set5 =
{
  template = "Pic_dem_commercial_set1",
  map    = "MAP05",

  seed_h = 1,

  bound_z2 = 104
}

PREFABS.Pic_dem_commercial_set6 =
{
  template = "Pic_dem_commercial_set1",
  map    = "MAP06",

  seed_h = 1,

  bound_z2 = 104
}
