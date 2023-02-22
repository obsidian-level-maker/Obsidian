PREFABS.Pic_tech_hydroponics_1 =
{
  file   = "picture/gtd_pic_tech_hydroponics_EPIC.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_hydroponics",

  where  = "seeds",
  height = 128,

  deep = 16,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 76,180 }
}

PREFABS.Pic_tech_hydroponics_2 =
{
  template = "Pic_tech_hydroponics_1", 
  map = "MAP02",

  x_fit = "frame"
}
