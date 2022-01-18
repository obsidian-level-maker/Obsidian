PREFABS.Wall_toilet_gallery_toilets =
{
  file = "wall/gtd_wall_industrial_toilet_gallery.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_toilet_gallery",

  where = "edge",
  deep = 52,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Wall_toilet_gallery_plain =
{
  template = "Wall_toilet_gallery_toilets",
  map = "MAP02",

  deep = 16,

  prob = 18
}

PREFABS.Wall_toilet_gallery_urinals =
{
  template = "Wall_toilet_gallery_toilets",
  map = "MAP03",

  deep = 28
}
