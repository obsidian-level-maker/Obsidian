
PREFABS.Pic_industrial_storage_2x =
{
  file = "picture/gtd_pic_industrial_storage_2.wad",
  map = "MAP02",

  prob = 10,

  where = "seeds",
  height = 128,

  group = "gtd_full_storage",

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep =  16,

  y_fit = "top",
  z_fit = { 72,112 },

  --[[tex_CRATE1 = {CRATE1=1, CRATE2=1, CRATE3=1, CRATELIT=1},
  tex_CRATE2 = {CRATE1=1, CRATE2=1, CRATE3=1, CRATELIT=1},
  tex_CRATE3 = {CRATE1=1, CRATE2=1, CRATE3=1, CRATELIT=1}]]
}

PREFABS.Pic_industrial_storage_2x_2 =
{
  template = "Pic_industrial_storage_2x",
  map = "MAP02"
}

PREFABS.Pic_industrial_storage_3x =
{
  template = "Pic_industrial_storage_2x",
  map = "MAP03",

  seed_w = 3
}
