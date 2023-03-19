--hospital room set
PREFABS.Pic_dem_hospital_set1 =
{
  file   = "picture/dem_pic_hospital_set.wad",
  map    = "MAP01",

rank = 1,

  prob   = 25000,
  theme = "!hell",
  env = "building",

  group = "dem_wall_hospital",

  where  = "seeds",
  height = 104,

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  texture_pack = "armaetus",

  thing_28 =
  {
    blood_pack = 50,
    nothing = 20,
  },

}

  PREFABS.Pic_dem_hospital_set2 =
{
  template = "Pic_dem_hospital_set1",
  map    = "MAP02",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

  PREFABS.Pic_dem_hospital_set3 =
{
  template = "Pic_dem_hospital_set1",
  map    = "MAP03",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

  PREFABS.Pic_dem_hospital_set4 =
{
  template = "Pic_dem_hospital_set1",
  map    = "MAP04",

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

-- hospital counter
  PREFABS.Pic_dem_hospital_set5 =
{
  template = "Pic_dem_hospital_set1",
  map    = "MAP05",

  prob   = 12000,

}
