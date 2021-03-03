PREFABS.Pic_gtd_library_big_shelves_EPIC =
{
  file = "picture/gtd_pic_library_set.wad",
  map = "MAP01",

  prob   = 50,

  texture_pack = "armaetus",

  replaces = "Pic_gtd_library_big_shelves",

  group = "gtd_library",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 120,136 },
  y_fit = "top",
}

PREFABS.Pic_gtd_library_caged_shelves_EPIC =
{
  template = "Pic_gtd_library_big_shelves_EPIC",
  map = "MAP02",

  replaces = "Pic_gtd_library_caged_shelves",
}

--

PREFABS.Pic_gtd_library_big_shelves =
{
  file = "picture/gtd_pic_library_set.wad",
  map = "MAP01",

  prob   = 50,

  where  = "seeds",
  height = 128,

  group = "gtd_library",

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 120,136 },
  y_fit = "top",

  tex_PANBOOK2 = "PANBOOK",
}

PREFABS.Pic_gtd_library_caged_shelves =
{
  template = "Pic_gtd_library_big_shelves",
  map = "MAP02",

  tex_PANBOOK4 = "PANBOOK",
}
