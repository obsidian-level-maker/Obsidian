PREFABS.Pic_urban_terraced_building_2x =
{
  file = "picture/gtd_pic_urban_terraced_buildings_EPIC.wad",
  map = "MAP01",

  prob = 150,
  theme = "urban",
  engine = "zdoom",

  env = "outdoor",

  where = "seeds",
  height = 264,

  seed_h = 1,
  seed_w = 2,

  bound_z1 = 0,
  bound_z2 = 264,

  deep = 16,

  texture_pack = "armaetus",

  y_fit = "top",

  tex_LITE5 =
  {
    LITE5=5,
    LITEBLU4=5,
  },

  tex_DOOR1 =
  {
    DOOR1=5,
    DOOR5=5,
  },
}

PREFABS.Pic_urban_terraced_building_3x =
{
  template = "Pic_urban_terraced_building_2x",
  map = "MAP02",

  prob = 80,

  seed_w = 3,

  x_fit = {128,176 , 304,352},
}
