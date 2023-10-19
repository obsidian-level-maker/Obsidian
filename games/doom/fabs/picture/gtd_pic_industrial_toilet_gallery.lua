PREFABS.Pic_industrial_toilet_gallery_toilets =
{
  file = "picture/gtd_pic_industrial_toilet_gallery.wad",
  map = "MAP01",

  prob = 50,

  where = "seeds",
  height = 96,

  group = "gtd_toilet_gallery",

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  deep =  16,

  y_fit = "top",
  x_fit = "frame"
}

PREFABS.Pic_industrial_toilet_gallery_urinals =
{
  template = "Pic_industrial_toilet_gallery_toilets",
  map = "MAP02"
}

-- only appears on resource pack
PREFABS.Pic_industrial_toilet_gallery_NAHIDA =
{
  template = "Pic_industrial_toilet_gallery_toilets",
  map = "MAP03",

  prob = 5
}
