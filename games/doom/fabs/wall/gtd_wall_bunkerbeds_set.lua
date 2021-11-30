PREFABS.Wall_gtd_bunkerbeds_lockers =
{
  file = "wall/gtd_wall_bunkerbeds_set.wad",
  map = "MAP01",

  prob = 50,
  group = "cran_bunkbeds",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = {122,124}
}

PREFABS.Wall_gtd_bunkerbeds_comp =
{
  template = "Wall_gtd_bunkerbeds_lockers",
  map = "MAP02",

  prob = 12,

  tex_COMPTALL =
  {
    COMPTALL = 50,
    COMPWERD = 50,
    GRAY2 = 50
  }
}
