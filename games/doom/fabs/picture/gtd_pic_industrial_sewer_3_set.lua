PREFABS.Pic_industrial_sewer_3_liquid_pit =
{
  file = "picture/gtd_pic_industrial_sewer_3_set.wad",
  map = "MAP01",

  prob = 50,
  group  = "gtd_sewer_set_3",

  where  = "seeds",
  height = 96,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = {64,72 , 184,192},
  y_fit = { 16,24 },
  z_fit = { 76,78 }
}

PREFABS.Pic_industrial_sewer_3_liquid_pit_falls =
{
  template = "Pic_industrial_sewer_3_liquid_pit",
  map = "MAP02"
}
